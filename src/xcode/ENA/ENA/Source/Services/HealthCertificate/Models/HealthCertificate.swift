////
// 🦠 Corona-Warn-App
//

import Foundation
import HealthCertificateToolkit

protocol HealthCertificateData {
	var base45: Base45 { get }
	var version: String { get }
	var name: HealthCertificateToolkit.Name { get }
	var dateOfBirth: String { get }
	var dateOfBirthDate: Date? { get }
	var vaccinationCertificates: [VaccinationCertificate] { get }
	var isLastDoseInASeries: Bool { get }
	var expirationDate: Date { get }
	var dateOfVaccination: Date? { get }
	var doseNumber: Int { get }
	var totalSeriesOfDoses: Int { get }
}

struct HealthCertificate: HealthCertificateData, Codable, Equatable, Comparable {

	// MARK: - Init

	init(base45: Base45) throws {
		// Ensure the data will be decodable on the fly later on, even though we don't store the decoded data
		if case .failure(let error) = DigitalGreenCertificateAccess().extractCBORWebTokenHeader(from: base45) {
			Log.error("Failed to decode header of health certificate with error", log: .vaccination, error: error)
			throw error
		}

		if case .failure(let error) = DigitalGreenCertificateAccess().extractDigitalGreenCertificate(from: base45) {
			Log.error("Failed to decode health certificate with error", log: .vaccination, error: error)
			throw error
		}

		self.base45 = base45
	}

	// MARK: - Protocol Comparable

	static func < (lhs: HealthCertificate, rhs: HealthCertificate) -> Bool {
		guard
			let lhsVaccinationDate = lhs.vaccinationCertificates.first?.dateOfVaccination,
			let rhsVaccinationDate = rhs.vaccinationCertificates.first?.dateOfVaccination
		else {
			return false
		}

		return lhsVaccinationDate < rhsVaccinationDate
	}

	// MARK: - Internal

	let base45: Base45

	var version: String {
		digitalGreenCertificate.version
	}

	var name: HealthCertificateToolkit.Name {
		digitalGreenCertificate.name
	}

	var dateOfBirth: String {
		digitalGreenCertificate.dateOfBirth
	}

	var dateOfBirthDate: Date? {
		return ISO8601DateFormatter.justLocalDateFormatter.date(from: digitalGreenCertificate.dateOfBirth)
	}

	var vaccinationCertificates: [VaccinationCertificate] {
		digitalGreenCertificate.vaccinationCertificates
	}

	var isLastDoseInASeries: Bool {
		digitalGreenCertificate.isLastDoseInASeries
	}

	var expirationDate: Date {
		Date(timeIntervalSince1970: TimeInterval(cborWebTokenHeader.expirationTime))
	}

	var dateOfVaccination: Date? {
		guard let dateString = vaccinationCertificates.first?.dateOfVaccination else {
			return nil
		}
		return ISO8601DateFormatter.justLocalDateFormatter.date(from: dateString)
	}

	var doseNumber: Int {
		guard let vaccinationCertificate = vaccinationCertificates.last else {
			return 0
		}
		return vaccinationCertificate.doseNumber
	}
	
	var totalSeriesOfDoses: Int {
		guard let vaccinationCertificate = vaccinationCertificates.last else {
			return 0
		}
		return vaccinationCertificate.totalSeriesOfDoses
	}

	// MARK: - Private

	private var cborWebTokenHeader: CBORWebTokenHeader {
		let result = DigitalGreenCertificateAccess().extractCBORWebTokenHeader(from: base45)

		switch result {
		case .success(let cborWebTokenHeader):
			return cborWebTokenHeader
		case .failure(let error):
			Log.error("Failed to decode header of health certificate with error", log: .vaccination, error: error)
			fatalError("Decoding the cborWebTokenHeader failed even though decodability was checked at initialization.")
		}
	}

	private var digitalGreenCertificate: DigitalGreenCertificate {
		let result = DigitalGreenCertificateAccess().extractDigitalGreenCertificate(from: base45)

		switch result {
		case .success(let digitalGreenCertificate):
			return digitalGreenCertificate
		case .failure(let error):
			Log.error("Failed to decode health certificate with error", log: .vaccination, error: error)
			fatalError("Decoding the digitalGreenCertificate failed even though decodability was checked at initialization.")
		}
	}
}
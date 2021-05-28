////
// 🦠 Corona-Warn-App
//

import FMDB

// This implementation is based on the following technical specification.
// For more details please see: https://github.com/corona-warn-app/cwa-app-tech-spec/blob/e87ef2851c91141573d5714fd24485219280543e/docs/spec/event-registration-client.md

class CreateCheckinQuery: StoreQueryProtocol {

	// MARK: - Init

	init(
		checkin: Checkin,
		maxTextLength: Int
	) {
		self.checkin = checkin
		self.maxTextLength = maxTextLength
	}

	// MARK: - Protocol StoreQuery

	func execute(in database: FMDatabase) -> Bool {
		let sql = """
			INSERT INTO Checkin (
				traceLocationId,
				traceLocationIdHash,
				traceLocationVersion,
				traceLocationType,
				traceLocationDescription,
				traceLocationAddress,
				traceLocationStartDate,
				traceLocationEndDate,
				traceLocationDefaultCheckInLengthInMinutes,
				cryptographicSeed,
				cnPublicKey,
				checkinStartDate,
				checkinEndDate,
				checkinCompleted,
				createJournalEntry,
				checkinSubmitted
			)
			VALUES (
				:traceLocationId,
				:traceLocationIdHash,
				:traceLocationVersion,
				:traceLocationType,
				SUBSTR(:traceLocationDescription, 1, \(maxTextLength)),
				SUBSTR(:traceLocationAddress, 1, \(maxTextLength)),
				:traceLocationStartDate,
				:traceLocationEndDate,
				:traceLocationDefaultCheckInLengthInMinutes,
				:cryptographicSeed,
				:cnPublicKey,
				:checkinStartDate,
				:checkinEndDate,
				:checkinCompleted,
				:createJournalEntry,
				:checkinSubmitted
			);
		"""

		var traceLocationStartDateInterval: Int?
		// If the tracelocationstart date exceeds the Int.max, and Corona 🦠 is still around, we have other problems
		// than Int.max ;-) Int.max is Friday, 11. April 2262.
		if let traceLocationStart = checkin.traceLocationStartDate, traceLocationStart.timeIntervalSince1970 < Double(Int.max) {
			traceLocationStartDateInterval = Int(traceLocationStart.timeIntervalSince1970)
		} else {
			return false
		   }

		var traceLocationEndDateInterval: Int?
		// If the tracelocationstart date exceeds the Int.max, and Corona 🦠 is still around, we have other problems
		// than Int.max ;-) Int.max is Friday, 11. April 2262.
		if let traceLocationEnd = checkin.traceLocationEndDate, traceLocationEnd.timeIntervalSince1970 < Double(Int.max) {
			traceLocationEndDateInterval = Int(traceLocationEnd.timeIntervalSince1970)
		} else {
			return false
		}

		let parameters: [String: Any] = [
			"traceLocationId": checkin.traceLocationId,
			"traceLocationIdHash": checkin.traceLocationIdHash,
			"traceLocationVersion": checkin.traceLocationVersion,
			"traceLocationType": checkin.traceLocationType.rawValue,
			"traceLocationDescription": checkin.traceLocationDescription,
			"traceLocationAddress": checkin.traceLocationAddress,
			"traceLocationStartDate": traceLocationStartDateInterval as Any,
			"traceLocationEndDate": traceLocationEndDateInterval as Any,
			"traceLocationDefaultCheckInLengthInMinutes": checkin.traceLocationDefaultCheckInLengthInMinutes as Any,
			"cryptographicSeed": checkin.cryptographicSeed,
			"cnPublicKey": checkin.cnPublicKey,
			"checkinStartDate": Int(checkin.checkinStartDate.timeIntervalSince1970),
			"checkinEndDate": Int(checkin.checkinEndDate.timeIntervalSince1970),
			"checkinCompleted": checkin.checkinCompleted,
			"createJournalEntry": checkin.createJournalEntry,
			"checkinSubmitted": checkin.checkinSubmitted
		]

		return database.executeUpdate(sql, withParameterDictionary: parameters)
	}

	// MARK: - Private

	private let checkin: Checkin
	private let maxTextLength: Int

}

////
// 🦠 Corona-Warn-App
//

import Foundation
import UIKit

final class DiaryOverviewDayCellModel {

	// MARK: - Init

	init(
		diaryDay: DiaryDay,
		historyExposure: HistoryExposure,
		minimumDistinctEncountersWithHighRisk: Int,
		checkinsWithRisk: [CheckinWithRisk],
		// only needed for UI Testing purposes
		accessibilityIdentifierIndex: Int = 0
	) {
		self.diaryDay = diaryDay
		self.historyExposure = historyExposure
		self.minimumDistinctEncountersWithHighRisk = minimumDistinctEncountersWithHighRisk
		self.checkinsWithRisk = checkinsWithRisk
		self.accessibilityIdentifierIndex = accessibilityIdentifierIndex
	}

	// MARK: - Public

	// MARK: - Internal

	let historyExposure: HistoryExposure
	let checkinsWithRisk: [CheckinWithRisk]
	let accessibilityIdentifierIndex: Int

	func entryDetailTextFor(personEncounter: ContactPersonEncounter) -> String {
		var detailComponents = [String]()
		detailComponents.append(personEncounter.duration.description)
		detailComponents.append(personEncounter.maskSituation.description)
		detailComponents.append(personEncounter.setting.description)

		// Filter empty strings.
		detailComponents = detailComponents.filter { $0 != "" }

		return detailComponents.joined(separator: ", ")
	}

	func entryDetailTextFor(locationVisit: LocationVisit) -> String {
		guard locationVisit.durationInMinutes > 0 else {
			return ""
		}

		let dateComponents = DateComponents(minute: locationVisit.durationInMinutes)
		let timeString = dateComponentsFormatter.string(from: dateComponents) ?? ""
		return timeString + " \(AppStrings.ContactDiary.Overview.LocationVisit.abbreviationHours)"
	}

	var hideExposureHistory: Bool {
		switch historyExposure {
		case .none:
			return true
		case .encounter:
			return false
		}
	}

	var exposureHistoryAccessibilityIdentifier: String? {
		switch historyExposure {
		case let .encounter(risk):
			switch risk {
			case .low:
				return AccessibilityIdentifiers.ContactDiaryInformation.Overview.riskLevelLow
			case .high:
				return AccessibilityIdentifiers.ContactDiaryInformation.Overview.riskLevelHigh
			}
		case .none:
			return nil
		}
	}

	var exposureHistoryImage: UIImage? {
		switch historyExposure {
		case let .encounter(risk):
			switch risk {
			case .low:
				return UIImage(imageLiteralResourceName: "Icons_Attention_low")
			case .high:
				return UIImage(imageLiteralResourceName: "Icons_Attention_high")
			}
		case .none:
			return nil
		}
	}

	var exposureHistoryTitle: String? {
		switch historyExposure {
		case let .encounter(risk):
			switch risk {
			case .low:
				return AppStrings.ContactDiary.Overview.lowRiskTitle
			case .high:
				return AppStrings.ContactDiary.Overview.increasedRiskTitle
			}

		case .none:
			return nil
		}
	}

	var exposureHistoryDetail: String? {
		switch historyExposure {
		case let .encounter(risk):
			switch risk {
			case .low:
				return selectedEntries.isEmpty ? AppStrings.ContactDiary.Overview.riskTextStandardCause : [AppStrings.ContactDiary.Overview.riskTextStandardCause, AppStrings.ContactDiary.Overview.riskTextDisclaimer].joined(separator: "\n")
			case .high where minimumDistinctEncountersWithHighRisk > 0:
				return selectedEntries.isEmpty ? AppStrings.ContactDiary.Overview.riskTextStandardCause : [AppStrings.ContactDiary.Overview.riskTextStandardCause, AppStrings.ContactDiary.Overview.riskTextDisclaimer].joined(separator: "\n")
			// for other possible values of minimumDistinctEncountersWithHighRisk such as 0 and -1
			case .high:
				return selectedEntries.isEmpty ? AppStrings.ContactDiary.Overview.riskTextLowRiskEncountersCause : [AppStrings.ContactDiary.Overview.riskTextLowRiskEncountersCause, AppStrings.ContactDiary.Overview.riskTextDisclaimer].joined(separator: "\n")
			}
		case .none:
			return nil
		}
	}
	
	var hideCheckinRisk: Bool {
		return checkinsWithRisk.isEmpty
	}
	
	var checkinImage: UIImage? {
		if checkinsWithRisk.isEmpty {
			return nil
		} else {
			return checkinsWithRisk.contains(where: { $0.risk == .high }) ?
				UIImage(imageLiteralResourceName: "Icons_Attention_high") :
				UIImage(imageLiteralResourceName: "Icons_Attention_low")
		}
	}
	
	var checkinTitleHeadlineText: String? {
		if checkinsWithRisk.isEmpty {
			return nil
		} else {
			return checkinsWithRisk.contains(where: { $0.risk == .high }) ?
				AppStrings.ContactDiary.Overview.CheckinEncounter.titleHighRisk :
				AppStrings.ContactDiary.Overview.CheckinEncounter.titleLowRisk
		}
	}
	
	var checkinTitleAccessibilityIdentifier: String? {
		if checkinsWithRisk.isEmpty {
			return nil
		} else {
			return checkinsWithRisk.contains(where: { $0.risk == .high }) ?
				AccessibilityIdentifiers.ContactDiaryInformation.Overview.checkinRiskLevelHigh :
				AccessibilityIdentifiers.ContactDiaryInformation.Overview.checkinRiskLevelLow
		}
	}
	
	var checkinDetailDescription: String? {
		return checkinsWithRisk.isEmpty ? nil: AppStrings.ContactDiary.Overview.CheckinEncounter.titleSubheadline
	}
	
	var isSinlgeRiskyCheckin: Bool {
		return checkinsWithRisk.count <= 1
	}
	
	var selectedEntries: [DiaryEntry] {
		diaryDay.selectedEntries
	}

	var formattedDate: String {
		diaryDay.formattedDate
	}

	var isPCRTestHidden: Bool {
		return false
	}

	var PCRTestImage: UIImage {
		return UIImage(imageLiteralResourceName: "Test_green")
	}

	var PCRTestTitle: String? {
		return AppStrings.ContactDiary.Overview.Tests.PCRRegistered
	}
	var PCRTestResult: String? {
		return AppStrings.ContactDiary.Overview.Tests.negativeResult
	}

	var isAntigenTestHidden: Bool {
		return false
	}

	var antigenTestImage: UIImage {
		return UIImage(imageLiteralResourceName: "Test_red")
	}

	var antigenTestTitle: String? {
		return AppStrings.ContactDiary.Overview.Tests.AntigenDone
	}
	var antigenTestResult: String? {
		return AppStrings.ContactDiary.Overview.Tests.positiveResult
	}
	
	func checkInDespription(checkinWithRisk: CheckinWithRisk) -> String {
		let checkinName = checkinWithRisk.checkIn.traceLocationDescription
		let riskLevel = checkinWithRisk.risk
		var suffix = ""
		switch riskLevel {
		case .low:
			suffix = AppStrings.ContactDiary.Overview.CheckinEncounter.lowRisk
		case .high:
			suffix = AppStrings.ContactDiary.Overview.CheckinEncounter.highRisk
		}
		return isSinlgeRiskyCheckin ? checkinName : checkinName + " \(suffix)"
	}
	
	func colorFor(riskLevel: RiskLevel) -> UIColor {
		return riskLevel == .high ? .enaColor(for: .riskHigh) : .enaColor(for: .textPrimary2)
	}

	// MARK: - Private

	private let diaryDay: DiaryDay
	private let minimumDistinctEncountersWithHighRisk: Int
	
	private var dateComponentsFormatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .positional
		formatter.zeroFormattingBehavior = .pad
		formatter.allowedUnits = [.hour, .minute]
		return formatter
	}()
}

private extension ContactPersonEncounter.Duration {
	var description: String {
		switch self {
		case .none:
			return ""
		case .lessThan15Minutes:
			return AppStrings.ContactDiary.Overview.PersonEncounter.durationLessThan15Minutes
		case .moreThan15Minutes:
			return AppStrings.ContactDiary.Overview.PersonEncounter.durationMoreThan15Minutes
		}
	}
}

private extension ContactPersonEncounter.MaskSituation {
	var description: String {
		switch self {
		case .none:
			return ""
		case .withMask:
			return AppStrings.ContactDiary.Overview.PersonEncounter.maskSituationWithMask
		case .withoutMask:
			return AppStrings.ContactDiary.Overview.PersonEncounter.maskSituationWithoutMask
		}
	}
}

private extension ContactPersonEncounter.Setting {
	var description: String {
		   switch self {
		   case .none:
			   return ""
		   case .outside:
			   return AppStrings.ContactDiary.Overview.PersonEncounter.settingOutside
		   case .inside:
			return AppStrings.ContactDiary.Overview.PersonEncounter.settingInside
		   }
	   }
}

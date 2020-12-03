//
// 🦠 Corona-Warn-App
//

import Foundation

struct Risk: Equatable {
	let level: RiskLevel
	let details: Details
	let riskLevelHasChanged: Bool
}

extension Risk {
	struct Details: Equatable {
		var mostRecentDateWithRiskLevel: Date?
		var numberOfDaysWithRiskLevel: Int
		var numberOfHoursWithActiveTracing: Int { activeTracing.inHours }
		var activeTracing: ActiveTracing
		var numberOfDaysWithActiveTracing: Int { activeTracing.inDays }
		var exposureDetectionDate: Date?
	}
}

#if DEBUG
extension Risk {
	static let mocked = Risk(
		level: UserDefaults.standard.string(forKey: "-riskLevel") == "low" ? .low : .high,
		details: Risk.Details(
			mostRecentDateWithRiskLevel: Date(timeIntervalSinceNow: -3600),
			numberOfDaysWithRiskLevel: 1,
			activeTracing: .init(interval: 336 * 3600),  // two weeks
			exposureDetectionDate: Date()),
		riskLevelHasChanged: true
	)
}
#endif

////
// 🦠 Corona-Warn-App
//

import UIKit
import OpenCombine

class CheckinCellModel: EventCellModel {

	// MARK: - Init

	init(
		checkin: Checkin,
		eventProvider: EventProviding,
		onUpdate: @escaping () -> Void,
		forceReload: @escaping () -> Void
	) {
		self.checkin = checkin
		self.checkins = eventProvider.checkinsPublisher.value
		self.onUpdate = onUpdate

		eventProvider.checkinsPublisher
			.map { $0.sorted { $0.checkinStartDate < $1.checkinStartDate } }
			.sink { [weak self] checkins in
				guard
					checkins.map({ $0.id }) == self?.checkins.map({ $0.id }),
					let checkin = checkins.first(where: { $0.id == checkin.id })
				else {
					self?.checkins = checkins
					return
				}

				self?.checkin = checkin
				self?.checkins = checkins
				self?.updateForActiveState()
				onUpdate()
			}
			.store(in: &subscriptions)

		updateForActiveState()
		scheduleUpdateTimer()
	}

	// MARK: - Internal

	var isInactiveIconHiddenPublisher = CurrentValueSubject<Bool, Never>(true)
	var isActiveContainerViewHiddenPublisher = CurrentValueSubject<Bool, Never>(true)
	var isButtonHiddenPublisher = CurrentValueSubject<Bool, Never>(true)
	var durationPublisher = CurrentValueSubject<String?, Never>(nil)
	var timePublisher = CurrentValueSubject<String?, Never>(nil)

	var isActiveIconHidden: Bool = true
	var isDurationStackViewHidden: Bool = false

	var date: String? {
		DateFormatter.localizedString(from: checkin.checkinStartDate, dateStyle: .short, timeStyle: .none)
	}

	var title: String {
		checkin.traceLocationDescription
	}

	var address: String {
		checkin.traceLocationAddress
	}

	var buttonTitle: String = AppStrings.Checkins.Overview.checkoutButtonTitle

	// MARK: - Private

	private var checkin: Checkin
	private var checkins: [Checkin]
	private let onUpdate: () -> Void

	private var subscriptions = Set<AnyCancellable>()

	private var updateTimer: Timer?

	@objc
	private func updateForActiveState() {
		isInactiveIconHiddenPublisher.value = checkin.isActive
		isActiveContainerViewHiddenPublisher.value = !checkin.isActive
		isButtonHiddenPublisher.value = !checkin.isActive

		if let checkinEndDate = checkin.checkinEndDate {
			let dateFormatter = DateIntervalFormatter()
			dateFormatter.dateStyle = .short
			dateFormatter.timeStyle = .short

			timePublisher.value = dateFormatter.string(from: checkin.checkinStartDate, to: checkinEndDate)
		} else {
			let formattedCheckinTime = DateFormatter.localizedString(from: checkin.checkinStartDate, dateStyle: .none, timeStyle: .short)

			let dateComponentsFormatter = DateComponentsFormatter()
			dateComponentsFormatter.allowedUnits = [.hour, .minute]
			dateComponentsFormatter.unitsStyle = .short

			let automaticCheckoutTimeInterval = checkin.targetCheckinEndDate.timeIntervalSince(checkin.checkinStartDate)
			let formattedAutomaticCheckoutDuration = dateComponentsFormatter.string(from: automaticCheckoutTimeInterval) ?? ""

			timePublisher.value = String(format: "%@ - Automatisch auschecken nach %@", formattedCheckinTime, formattedAutomaticCheckoutDuration)
		}

		let duration = Date().timeIntervalSince(checkin.checkinStartDate)

		let dateComponentsFormatter = DateComponentsFormatter()
		dateComponentsFormatter.allowedUnits = [.hour, .minute]
		dateComponentsFormatter.unitsStyle = .positional
		dateComponentsFormatter.zeroFormattingBehavior = .pad

		durationPublisher.value = dateComponentsFormatter.string(from: duration)

		onUpdate()
	}

	private func scheduleUpdateTimer() {
//		updateTimer?.invalidate()
//		NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
//		NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
//
//		// Schedule new countdown.
//		NotificationCenter.default.addObserver(self, selector: #selector(invalidateUpdatedTimer), name: UIApplication.didEnterBackgroundNotification, object: nil)
//		NotificationCenter.default.addObserver(self, selector: #selector(refreshUpdateTimerAfterResumingFromBackground), name: UIApplication.didBecomeActiveNotification, object: nil)
//
//		updateTimer = Timer(fireAt: checkin.endDate, interval: 0, target: self, selector: #selector(updateForActiveState), userInfo: nil, repeats: false)
//		guard let updateTimer = updateTimer else { return }
//		RunLoop.current.add(updateTimer, forMode: .common)
	}

	@objc
	private func invalidateUpdatedTimer() {
		updateTimer?.invalidate()
	}

	@objc
	private func refreshUpdateTimerAfterResumingFromBackground() {
		scheduleUpdateTimer()
	}
    
}

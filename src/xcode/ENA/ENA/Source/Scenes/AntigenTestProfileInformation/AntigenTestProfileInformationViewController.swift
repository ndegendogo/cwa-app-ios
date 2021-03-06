////
// 🦠 Corona-Warn-App
//

import UIKit

class AntigenTestProfileInformationViewController: DynamicTableViewController, FooterViewHandling, DismissHandling {

	// MARK: - Init

	init(
		store: AntigenTestProfileStoring,
		didTapDataPrivacy: @escaping () -> Void,
		didTapContinue: @escaping () -> Void,
		dismiss: @escaping () -> Void
	) {
		self.viewModel = AntigenTestProfileInformationViewModel(store: store)
		self.didTapDataPrivacy = didTapDataPrivacy
		self.didTapContinue = didTapContinue
		self.dismiss = dismiss
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		parent?.navigationItem.title = viewModel.title
		parent?.navigationItem.rightBarButtonItem = dismissHandlingCloseBarButton
		viewModel.markScreenSeen()
	}

	// MARK: - Protocol FooterViewHandling

	func didTapFooterViewButton(_ type: FooterViewModel.ButtonType) {

		// this one can get used if data privacy will be removed from footer's secondary button
//		guard case .primary = type else {
//			return
//		}
		switch type {
		case .primary:
			didTapContinue()
		case .secondary:
			didTapDataPrivacy()
		}
	}

	// MARK: - Protocol DismissHandling

	func wasAttemptedToBeDismissed() {
		dismiss()
	}

	// MARK: - Public

	// MARK: - Internal

	// MARK: - Private

	private let viewModel: AntigenTestProfileInformationViewModel
	private let didTapDataPrivacy: () -> Void
	private let didTapContinue: () -> Void
	private let dismiss: () -> Void

}

//
// 🦠 Corona-Warn-App
//

import Foundation
import UIKit
import Combine

final class TestResultAvailableViewModel {
	
	// MARK: - Init
	
	init(
		exposureSubmissionService: ExposureSubmissionService,
		didTapConsentCell: @escaping (@escaping (Bool) -> Void) -> Void,
		didTapPrimaryFooterButton: @escaping (@escaping (Bool) -> Void) -> Void,
		presentDismissAlert: @escaping () -> Void
	) {
		self.exposureSubmissionService = exposureSubmissionService
		self.didTapConsentCell = didTapConsentCell
		self.didTapPrimaryFooterButton = didTapPrimaryFooterButton
		self.presentDismissAlert = presentDismissAlert
		
		exposureSubmissionService.isSubmissionConsentGivenPublisher.sink { [weak self] consentGranted in
			guard let self = self else { return }
			self.dynamicTableViewModel = self.createDynamicTableViewModel(consentGranted)
		}.store(in: &cancellables)
	}
	
	// MARK: - Internal
	
	let didTapPrimaryFooterButton: (@escaping (Bool) -> Void) -> Void
	let presentDismissAlert: () -> Void

	@Published var dynamicTableViewModel: DynamicTableViewModel = DynamicTableViewModel([])

	lazy var navigationFooterItem: ENANavigationFooterItem = {
		let item = ENANavigationFooterItem()

		item.primaryButtonTitle = AppStrings.ExposureSubmissionTestresultAvailable.primaryButtonTitle
		item.isPrimaryButtonEnabled = true
		item.isSecondaryButtonHidden = true
		item.title = AppStrings.ExposureSubmissionTestresultAvailable.title

		return item
	}()
	
	// MARK: - Private
	
	private let exposureSubmissionService: ExposureSubmissionService
	private var cancellables: Set<AnyCancellable> = []
	private let didTapConsentCell: (@escaping (Bool) -> Void) -> Void
	
	private func createDynamicTableViewModel(_ consentGiven: Bool) -> DynamicTableViewModel {
		let consentStateString = consentGiven ?
			AppStrings.ExposureSubmissionTestresultAvailable.consentGranted :
			AppStrings.ExposureSubmissionTestresultAvailable.consentNotGranted

		let listItem1String = consentGiven ?
			AppStrings.ExposureSubmissionTestresultAvailable.listItem1WithConsent :
			AppStrings.ExposureSubmissionTestresultAvailable.listItem1WithoutConsent

		let listItem2String = consentGiven ?
			AppStrings.ExposureSubmissionTestresultAvailable.listItem2WithConsent :
			AppStrings.ExposureSubmissionTestresultAvailable.listItem2WithoutConsent
		
		return DynamicTableViewModel([
			// header illustration image with automatic height resizing
			.section(
				header: .image(
					UIImage(named: "Illu_Testresult_available"),
					accessibilityLabel: AppStrings.ExposureSubmissionTestresultAvailable.accImageDescription,
					accessibilityIdentifier: AccessibilityIdentifiers.General.image
				),
				separators: .none,
				cells: []
			),
			// section with the consent state
			.section(
				separators: .all,
				cells: [
					.icon(UIImage(named: "Icons_Grey_Warnen"),
						  text: .string(consentStateString),
						  action: .execute { [weak self] _, cell in
							guard let self = self else { return }

							self.didTapConsentCell { isLoading in
								let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
								activityIndicatorView.startAnimating()
								cell?.accessoryView = isLoading ? activityIndicatorView : nil
								cell?.isUserInteractionEnabled = !isLoading
								self.navigationFooterItem.isPrimaryButtonEnabled = !isLoading
							}
						  },
						  configure: { _, cell, _ in
							cell.accessoryType = .disclosureIndicator
						  }
					)
				]
			),
			// section with information texts
			.section(
				separators: .none,
				cells: [
					.body(text: listItem1String),
					consentGiven ? .headline(text: listItem2String) : .body(text: listItem2String)
				]
			)
		])
	}
	
}

////
// 🦠 Corona-Warn-App
//

import UIKit

final class ExposureDetectionCoordinator {

	private let rootViewController: UIViewController
	private var navigationController: ENANavigationControllerWithFooter?
	private let store: Store
	private let homeState: HomeState
	private let exposureManager: ExposureManager
	private let appConfigurationProvider: AppConfigurationProviding
	private let otpServie: OTPServiceProviding
	
	init(
		rootViewController: UIViewController,
		store: Store,
		homeState: HomeState,
		exposureManager: ExposureManager,
		appConfigurationProvider: AppConfigurationProviding,
		client: Client
	) {
		self.rootViewController = rootViewController
		self.store = store
		self.homeState = homeState
		self.exposureManager = exposureManager
		self.appConfigurationProvider = appConfigurationProvider
		self.otpServie = OTPService(store: store, client: client)
	}

	func start() {
		let exposureDetectionController = ExposureDetectionViewController(
			viewModel: ExposureDetectionViewModel(
				homeState: homeState,
				appConfigurationProvider: appConfigurationProvider,
				onSurveyTap: { [weak self] url in
					guard let self = self, let url = url else {
						return
					}
					if self.otpServie.isStoredOTPAuthorized {
						self.showSurveyWebpage(url: url)
					} else {
						self.showSurveyConsent(for: url)
					}
				},
				onInactiveButtonTap: { [weak self] completion in
					self?.setExposureManagerEnabled(true, then: completion)
				}
			),
			store: store
		)

		let _navigationController = ENANavigationControllerWithFooter(rootViewController: exposureDetectionController)
		navigationController = _navigationController
		setNavigationBarHidden(true)
		
		rootViewController.present(_navigationController, animated: true)
	}

	private func showSurveyConsent(for surveyURL: URL) {
		setNavigationBarHidden(false)
		
		let surveyConsentViewController = SurveyConsentViewController(viewModel: SurveyConsentViewModel(url: surveyURL)) { [weak self] url in
			self?.showSurveyWebpage(url: url)
		}
		navigationController?.pushViewController(surveyConsentViewController, animated: true)
	}

	private func showSurveyWebpage(url: URL) {
		UIApplication.shared.open(url)
	}

	private func setExposureManagerEnabled(_ enabled: Bool, then completion: @escaping (ExposureNotificationError?) -> Void) {
		if enabled {
			exposureManager.enable(completion: completion)
		} else {
			exposureManager.disable(completion: completion)
		}
	}

	private func setNavigationBarHidden(_ hidden: Bool) {
		navigationController?.setNavigationBarHidden(hidden, animated: false)
	}
}

////
// 🦠 Corona-Warn-App
//

import Foundation
import UIKit

struct TestOverwriteNoticeViewModel {

	// MARK: - Init

	init(_ testType: CoronaTestType) {
		self.title = AppStrings.ExposureSubmission.OverwriteNotice.title

		switch testType {
		case .pcr:
			self.headline = AppStrings.ExposureSubmission.OverwriteNotice.Pcr.headline
			self.headlineAccessibility = AccessibilityIdentifiers.ExposureSubmission.OverwriteNotice.Pcr.headline
			self.text = AppStrings.ExposureSubmission.OverwriteNotice.Pcr.text
			self.textAccessibility = AccessibilityIdentifiers.ExposureSubmission.OverwriteNotice.Pcr.text

		case .antigen:
			self.headline = AppStrings.ExposureSubmission.OverwriteNotice.Antigen.headline
			self.headlineAccessibility = AccessibilityIdentifiers.ExposureSubmission.OverwriteNotice.Antigen.headline
			self.text = AppStrings.ExposureSubmission.OverwriteNotice.Antigen.text
			self.textAccessibility = AccessibilityIdentifiers.ExposureSubmission.OverwriteNotice.Antigen.text
		}
	}

	// MARK: - Public

	// MARK: - Internal

	let title: String

	var dynamicTableViewModel: DynamicTableViewModel {
		DynamicTableViewModel([

			// Illustration with information text and bullet icons with text
			.section(
				header:
					.image(
						UIImage(imageLiteralResourceName: "Illu_Overwrite_Notice"),
						accessibilityLabel: AppStrings.Checkins.Information.imageDescription,
						accessibilityIdentifier: AccessibilityIdentifiers.ExposureSubmission.OverwriteNotice.imageDescription
					),
				cells: [
					.title2(
						text: headline,
						accessibilityIdentifier: headlineAccessibility
					),
					.subheadline(
						text: title,
						accessibilityIdentifier: textAccessibility
					)
				]
			)
		]
		)
	}

	// MARK: - Private

	private	let headline: String
	private	let headlineAccessibility: String
	private	let text: String
	private	let textAccessibility: String

}

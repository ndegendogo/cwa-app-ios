////
// 🦠 Corona-Warn-App
//

import XCTest
@testable import ENA

class QRCodePlaygroundTests: XCTestCase {

    func testQRCodeGeneration() throws {
		let qrCodeImage = try XCTUnwrap(QRCodePlayground.generateQRCode(with: "HTTPS://CORONAWARN.APP/E1/BIPEY33SMVWSA2LQON2W2IDEN5WG64RAONUXIIDBNVSXILBAMNXRBCM4UQARRKM6UQASAHRKCC7CTDWGQ4JCO7RVZSWVIMQK4UPA.GBCAEIA7TEORBTUA25QHBOCWT26BCA5PORBS2E4FFWMJ3UU3P6SXOL7SHUBCA7UEZBDDQ2R6VRJH7WBJKVF7GZYJA6YMRN27IPEP7NKGGJSWX3XQ"))
		
		XCTAssertEqual(qrCodeImage.size.height, qrCodeImage.size.width)
		XCTAssertEqual(qrCodeImage.size.height, 400)
    }
	
	
	func testQRCodeGenerationWithCustomSize() throws {
		let qrCodeImage = try XCTUnwrap(QRCodePlayground.generateQRCode(with: "HTTPS://CORONAWARN.APP/E1/BIPEY33SMVWSA2LQON2W2IDEN5WG64RAONUXIIDBNVSXILBAMNXRBCM4UQARRKM6UQASAHRKCC7CTDWGQ4JCO7RVZSWVIMQK4UPA.GBCAEIA7TEORBTUA25QHBOCWT26BCA5PORBS2E4FFWMJ3UU3P6SXOL7SHUBCA7UEZBDDQ2R6VRJH7WBJKVF7GZYJA6YMRN27IPEP7NKGGJSWX3XQ", size: CGSize(width: 1000, height: 1000)))
		
		XCTAssertEqual(qrCodeImage.size.height, qrCodeImage.size.width)
		XCTAssertEqual(qrCodeImage.size.height, 1000)
	}

}

//
// 🦠 Corona-Warn-App
//

import Foundation
import CommonCrypto

enum AESEncryptionError: Error {
    case EncryptionFailed(Int)
}

struct AESEncryption {

    private let encryptionKey: Data
    private let initializationVector: Data

    init(encryptionKey: Data, initializationVector: Data) {
        self.encryptionKey = encryptionKey
        self.initializationVector = initializationVector
    }

    func encrypt(data: Data) -> Result<Data, AESEncryptionError> {
        return crypt(data: data, option: CCOperation(kCCEncrypt))
    }

    func decrypt(data: Data) -> Result<Data, AESEncryptionError> {
        return crypt(data: data, option: CCOperation(kCCDecrypt))
    }

    private func crypt(data: Data, option: CCOperation) -> Result<Data, AESEncryptionError> {
        let cryptedDataLength = data.count + kCCBlockSizeAES128
        var cryptedData = Data(count: cryptedDataLength)
        let keyLength = encryptionKey.count
        let options = CCOptions(kCCOptionPKCS7Padding)
        var bytesLength = Int(0)

        let status = cryptedData.withUnsafeMutableBytes { cryptedBytes in
            data.withUnsafeBytes { dataBytes in
                initializationVector.withUnsafeBytes { ivBytes in
                    encryptionKey.withUnsafeBytes { keyBytes in
                        CCCrypt(
                            option,
                            CCAlgorithm(kCCAlgorithmAES),
                            options,
                            keyBytes.baseAddress,
                            keyLength,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress,
                            data.count,
                            cryptedBytes.baseAddress,
                            cryptedDataLength,
                            &bytesLength
                        )
                    }
                }
            }
        }

        guard UInt32(status) == UInt32(kCCSuccess) else {
            return .failure(.EncryptionFailed(Int(status)))
        }

        cryptedData.removeSubrange(bytesLength ..< cryptedData.count)
        return .success(cryptedData)
    }
}
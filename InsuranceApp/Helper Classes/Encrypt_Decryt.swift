//
//  Encrypt_Decryt.swift
//  InsuranceApp
//
//  Created by Sankalp on 29/04/22.
//

import Foundation
/*import CommonCrypto
import Security

class Encrypt_Decryt
{
    let keyData   = "P-!nsurance@2022".data(using:String.Encoding.utf8)!
    
    enum Encrypt_Decryt_Error: Error {
        case KeyError((String, Int))
        case IVError((String, Int))
        case CryptorError((String, Int))
    }

    
    
    
    
    
    // The iv is prefixed to the encrypted data
    func aesCBCEncrypt(data:Data) throws -> Data {
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES128]
        if (validKeyLengths.contains(keyLength) == false) {
            throw Encrypt_Decryt_Error.KeyError(("Invalid key length", keyLength))
        }

        let cryptLength = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)
        let status = cryptData.withUnsafeMutableBytes({ ivBytes in
            SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, ivBytes)
        })
        
//        let status = cryptData.withUnsafeMutableBytes {ivBytes in
//            SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, ivBytes)
//        }
        if (status != 0) {
            throw Encrypt_Decryt_Error.IVError(("IV generation failed", Int(status)))
        }
        
        var numBytesEncrypted :size_t = 0
        let options   = CCOptions(kCCOptionPKCS7Padding)

        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), options, keyBytes, keyLength, cryptBytes, dataBytes, data.count, cryptBytes+kCCBlockSizeAES128, cryptLength, &numBytesEncrypted)
                }
            }
        }
        
//        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
//            data.withUnsafeBytes {dataBytes in
//                keyData.withUnsafeBytes {keyBytes in
//                    CCCrypt(CCOperation(kCCEncrypt),
//                            CCAlgorithm(kCCAlgorithmAES),
//                            options,
//                            keyBytes, keyLength,
//                            cryptBytes,
//                            dataBytes, data.count,
//                            cryptBytes+kCCBlockSizeAES128, cryptLength,
//                            &numBytesEncrypted)
//                }
//            }
//        }

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.count = numBytesEncrypted
        }
        else {
            throw Encrypt_Decryt_Error.CryptorError(("Encryption failed", Int(cryptStatus)))
        }

        return cryptData;
    }

    // The iv is prefixed to the encrypted data
    func aesCBCDecrypt(data:Data) throws -> Data? {
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES128]
        if (validKeyLengths.contains(keyLength) == false) {
            throw Encrypt_Decryt_Error.KeyError(("Invalid key length", keyLength))
        }

        let clearLength = size_t(data.count)
        var clearData = Data(count:clearLength)

        var numBytesDecrypted :size_t = 0
        let options   = CCOptions(kCCOptionPKCS7Padding)

        
        let cryptStatus = clearData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithmAES128), options, keyBytes, keyLength, dataBytes, dataBytes+kCCBlockSizeAES128, clearLength, cryptBytes, clearLength, &numBytesDecrypted)
                }
            }
        }

//        let cryptStatus = clearData.withUnsafeMutableBytes {cryptBytes in
//            data.withUnsafeBytes {dataBytes in
//                keyData.withUnsafeBytes {keyBytes in
//                    CCCrypt(CCOperation(kCCDecrypt),
//                            CCAlgorithm(kCCAlgorithmAES128),
//                            options,
//                            keyBytes, keyLength,
//                            dataBytes,
//                            dataBytes+kCCBlockSizeAES128, clearLength,
//                            cryptBytes, clearLength,
//                            &numBytesDecrypted)
//                }
//            }
//        }

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            clearData.count = numBytesDecrypted
        }
        else {
            throw Encrypt_Decryt_Error.CryptorError(("Decryption failed", Int(cryptStatus)))
        }
        
        return clearData;
    }

}
*/

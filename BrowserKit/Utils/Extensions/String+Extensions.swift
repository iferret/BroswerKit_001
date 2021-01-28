//
//  String+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation
import CommonCrypto

extension String: CompatibleValue {}
extension CompatibleWrapper where Base == String {
    
    /// 获取md5值
    /// - Parameter uppercased: 是否输出大写字母
    /// - Returns: String
    internal func md5(_ uppercased: Bool = false) -> String {
        let data = Data(base.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        if uppercased == true  {
            return hash.map { String(format: "%02X", $0) }.joined()
        } else {
            return hash.map { String(format: "%02x", $0) }.joined()
        }
        
    }
}

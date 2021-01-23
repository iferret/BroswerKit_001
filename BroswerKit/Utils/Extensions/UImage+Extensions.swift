//
//  UImage+Extensions.swift
//  BroswerKit
//
//  Created by tramp on 2021/1/23.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 构建
    /// - Parameters:
    ///   - name: name of image
    ///   - bundle: Bundle
    internal convenience init?(named name: String, in bundle: Bundle?) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}

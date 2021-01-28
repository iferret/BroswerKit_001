//
//  UIApplication+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/27.
//

import Foundation
import UIKit

extension UIApplication: Compatible {}
extension CompatibleWrapper where Base: UIApplication {
    
    /// UIWindow
    internal var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return base.keyWindow ?? base.windows.first(where: { $0.windowScene?.activationState == .foregroundActive })
        } else {
            return base.keyWindow
        }
    }
    
}

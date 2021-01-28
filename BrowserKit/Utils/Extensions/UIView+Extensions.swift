//
//  UIView+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/28.
//

import UIKit

extension UIView: Compatible {}
extension CompatibleWrapper where Base: UIView {
    
    /// setup backgroundColor with animation
    /// - Parameters:
    ///   - backgroundColor: UIColor
    ///   - animated: Bool
    internal func set(backgroundColor: UIColor?, animated: Bool) {
        if animated == true {
            UIView.animate(withDuration: 0.25) {
                base.backgroundColor = backgroundColor
            }
        } else {
            base.backgroundColor = backgroundColor
        }
    }
    
    /// set tint color with animation
    /// - Parameters:
    ///   - tintColor: UIColor
    ///   - animated: Bool
    internal func set(tintColor: UIColor?, animated: Bool) {
        if animated == true {
            UIView.animate(withDuration: 0.25) {
                base.tintColor = tintColor
            }
        } else {
            base.tintColor = tintColor
        }
    }
    
    /// set hidden with animation
    /// - Parameters:
    ///   - hidden: Bool
    ///   - animated: Bool
    internal func set(hidden: Bool, animated: Bool) {
        if animated == true {
            UIView.animate(withDuration: 0.25) {
                base.isHidden = hidden
            }
        } else {
            base.isHidden = hidden
        }
    }
}

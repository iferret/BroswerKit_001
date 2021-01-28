//
//  UIBarButtonItem+Extensions.swift
//  VDiskMobileLite
//
//  Created by tramp on 2020/10/30.
//

import UIKit

extension UIBarButtonItem {
    
    /// flexibleSpace item
    internal static func flexible() -> UIBarButtonItem {
        return UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    /// fixedSpace item
    /// - Parameter width: width of item
    internal static func fixed(width: CGFloat) -> UIBarButtonItem {
        let item = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        item.width = width
        return item
    }
    
    /// 构建
    /// - Parameters:
    ///   - control: UIControl
    ///   - isEnabled: Bool
    internal convenience init(control: UIControl, isEnabled: Bool) {
        control.isEnabled = isEnabled
        self.init(customView: control)
        self.isEnabled = isEnabled
    }
}

// MARK: - Compatible
extension UIBarButtonItem: Compatible {}
extension CompatibleWrapper where Base: UIBarButtonItem {
    /// UILabel
    internal var label: UILabel? {
        return base.customView as? UILabel
    }
    
    /// UIButton
    internal var button: UIButton? {
        return base.customView as? UIButton
    }
    
    /// UIImageView
    internal var imageView: UIImageView? {
        return base.customView as? UIImageView
    }
    
    /// UISwitch
    internal var `switch`: UISwitch? {
        return base.customView as? UISwitch
    }
    
    /// UIControl
    internal var control: UIControl? {
        return base.customView as? UIControl
    }
}

extension CompatibleWrapper where Base: UIBarButtonItem {
    
    ///  add target and action
    /// - Parameters:
    ///   - target: AnyObject
    ///   - action: Selector
    /// - Returns: UIBarButtonItem
    internal func add(target: AnyObject?, action: Selector) -> UIBarButtonItem {
        if let control = self.control  {
            control.addTarget(target, action: action, for: .touchUpInside)
        } else {
            base.target = target
            base.action = action
        }
        return base
    }
}

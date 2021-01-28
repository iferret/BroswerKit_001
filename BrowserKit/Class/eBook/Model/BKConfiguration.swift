//
//  BKConfiguration.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/27.
//

import Foundation
import UIKit

/// BKConfiguration
public class BKConfiguration: NSObject {
    
    // MARK: - 公开属性
    
    /// BKConfiguration
    public static let `default`: BKConfiguration = .init()
    
    /// 文本颜色
    public var textColor: UIColor {
        get { UserDefaults.current.hub.color(forKey: .textColor) ?? .darkGray }
        set {
            UserDefaults.current.hub.set(newValue, forKey: .textColor)
            UserDefaults.current.hub.synchronize()
        }
    }
    
    /// 背景色
    public var backgroundColor: UIColor {
        get { UserDefaults.current.hub.color(forKey: .backgroundColor) ?? .lightGray }
        set {
            UserDefaults.current.hub.set(newValue, forKey: .backgroundColor)
            UserDefaults.current.hub.synchronize()
        }
    }
    
    /// 文本字体
    public var textFont: UIFont {
        get { UserDefaults.current.hub.font(forKey: .textFont) ?? .theme(ofSize: 18.0, weight: .regular)}
        set {
            UserDefaults.current.hub.set(newValue, forKey: .textFont)
            UserDefaults.current.hub.synchronize()
        }
    }
    
}

// MARK: - BKConfiguration
extension BKConfiguration {
    
    /// [NSAttributedString.Key: Any]
    internal var attributes: [NSAttributedString.Key: Any] {
        return [.foregroundColor: textColor, .font: textFont]
    }
    
    /// UIEdgeInsets
    internal var safeAreaInsets: UIEdgeInsets {
        
        /// safeAreaInsets
        /// - Returns: UIEdgeInsets
        func safeAreaInsets() -> UIEdgeInsets {
            let left: CGFloat = 16.0
            let right: CGFloat = 16.0
            let bottom: CGFloat = UIApplication.shared.hub.keyWindow?.safeAreaInsets.bottom ?? 0.0
            let top: CGFloat
            if #available(iOS 13.0, *) {
                top = (UIApplication.shared.hub.keyWindow?.safeAreaInsets.top ?? 0.0)
            } else {
                top = (UIApplication.shared.hub.keyWindow?.safeAreaInsets.top ?? 0.0)
            }
            return .init(top: top, left: left, bottom: bottom, right: right)
        }
        // thread check
        if Thread.isMainThread == true {
            return safeAreaInsets()
        } else {
            return DispatchQueue.main.sync { () -> UIEdgeInsets in
                return safeAreaInsets()
            }
        }
    }
    
    
}

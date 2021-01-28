//
//  BKTheme.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/27.
//

import Foundation
import UIKit

/// BKTheme
enum BKTheme: Int, CaseIterable {
    case light = 101
    case soft
    case girl
    case medium
    case heavy
}

extension BKTheme {
    
    /// theme value
    internal var colors: (textColor: UIColor, backgroundColor: UIColor) {
        switch self {
        case .light:    return (UIColor.darkText, UIColor.init(hex: "#F7F7F7"))
        case .soft:     return (UIColor.darkText, UIColor.init(hex: "#DFECF2"))
        case .girl:     return (UIColor.darkText, UIColor.init(hex: "#E3BFCD"))
        case .medium:   return (UIColor.lightText, UIColor.init(hex: "#8696A6"))
        case .heavy:    return (UIColor.lightText, UIColor.init(hex: "#656565"))
        }
    }
}

extension BKTheme {
    
    /// UIBarButtonItem
    internal var barItem: UIBarButtonItem {
        let _button = UIButton.init(type: .custom)
        _button.frame = .init(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        _button.backgroundColor = colors.backgroundColor
        _button.layer.cornerRadius = 20.0
        _button.layer.borderWidth = 0.5
        _button.layer.borderColor = UIColor.lightText.cgColor
        _button.tag = rawValue
        let item = UIBarButtonItem.init(customView: _button)
        item.tag = rawValue
        return item
    }
}

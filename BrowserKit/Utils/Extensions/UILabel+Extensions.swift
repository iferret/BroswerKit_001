//
//  UILabel+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/28.
//

import UIKit


extension CompatibleWrapper where Base: UILabel {
    
    /// set text color with animation
    /// - Parameters:
    ///   - textColor: UIColor
    ///   - animated: Bool
    internal func set(textColor: UIColor?, animated: Bool) {
        if animated == true {
            UIView.animate(withDuration: 0.25) {
                base.textColor = textColor
            }
        } else {
            base.textColor = textColor
        }
    }
    
    /// add attributes with animation
    /// - Parameters:
    ///   - attributes: [NSAttributedString.Key: Any]
    ///   - animated: Bool
    internal func add(attributes: [NSAttributedString.Key: Any], animated: Bool) {
        guard let attributedText = base.attributedText else { return }
        let attrText: NSMutableAttributedString = .init(attributedString: attributedText)
        attrText.addAttributes(attributes, range: .init(location: 0, length: attrText.length))
        if animated == true {
            UIView.animate(withDuration: 0.25) {
                base.attributedText = attrText
            }
        } else {
            base.attributedText = attrText
        }
    }
    
    /// set attributes with animation
    /// - Parameters:
    ///   - attributes: [NSAttributedString.Key: Any]
    ///   - animted: Bool
    internal func set(attributes: [NSAttributedString.Key: Any], animted: Bool) {
        guard let text = base.attributedText?.string else { return }
        let attrText: NSMutableAttributedString = .init(string: text, attributes: attributes)
        if animted == true {
            UIView.animate(withDuration: 0.25) {
                base.attributedText = attrText
            }
        } else {
            base.attributedText = attrText
        }
    }
    
}

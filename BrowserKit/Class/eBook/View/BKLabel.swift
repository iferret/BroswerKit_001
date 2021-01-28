//
//  BKLabel.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/27.
//

import Foundation
import UIKit

/// BKLabel
class BKLabel: UILabel {
    
    ///  textRect for bounds
    /// - Parameters:
    ///   - bounds: CGRect
    ///   - numberOfLines: Int
    /// - Returns: CGRect
    internal override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        return .init(x: textRect.origin.x, y: bounds.origin.y, width: textRect.width, height: textRect.height)
    }
    
    /// drawText
    /// - Parameter rect: CGRect
    internal override func drawText(in rect: CGRect) {
        let frame = self.textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: frame)
    }
}

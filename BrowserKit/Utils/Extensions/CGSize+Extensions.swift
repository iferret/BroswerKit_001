//
//  CGSize+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/27.
//

import Foundation
import UIKit

extension CGSize: CompatibleValue {}
extension CompatibleWrapper where Base == CGSize {
    
    /// inset by
    /// - Parameter insets: UIEdgeInsets
    /// - Returns: CGSize
    internal func inset(by insets: UIEdgeInsets) -> CGSize {
        let height = base.height - insets.top - insets.bottom
        let width = base.width - insets.right - insets.left
        return .init(width: width, height: height)
    }
}

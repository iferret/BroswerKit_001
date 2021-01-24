//
//  Bundle+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/23.
//

import Foundation

extension Bundle {

    /// framework bundle
    internal static var framework: Bundle {
        return Bundle.init(for: BKPageViewController.self)
    }
}

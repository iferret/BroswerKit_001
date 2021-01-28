//
//  Page+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation

extension Page {
    
    /// Page.Snapshot
    internal var snapshot: Snapshot {
        return .init(content: content, sortIndex: sortIndex)
    }
}

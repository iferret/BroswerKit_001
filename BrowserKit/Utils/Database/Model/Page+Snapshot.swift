//
//  Page+Snapshot.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation

extension Page {
    
    /// Page.Snapshot
    internal struct Snapshot {
        internal let uniqueID: String
        internal let text: String
        internal let chapterIndex: Int64
        internal let index: Int64
    }
}

// MARK: - Page.Snapshot
extension Page.Snapshot {
    
    /// 获取富文本内容
    /// - Parameter attributes: [NSAttributedString.Key: Any]
    /// - Returns: NSAttributedString
    internal func attributed(with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return .init(string: text, attributes:  attributes)
    }
}

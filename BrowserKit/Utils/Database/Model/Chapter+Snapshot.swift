//
//  Chapter+Snapshot.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation
import UIKit

extension Chapter {
    
    /// Chapter.Snapshot
    internal struct Snapshot {
        internal let uniqueID: String
        internal let title: String
        internal let contents: String
        internal let modified: Date
        internal let sortIndex: Int64
        internal let pages: Array<Page.Snapshot>
    }
}

// MARK: - Chapter.Snapshot
extension Chapter.Snapshot {
    
    
    /// 章节分页
    /// - Parameters:
    ///   - size: CGSize
    ///   - attributes: [NSAttributedString.Key: Any]
    /// - Returns: [Page.Snapshot]
    internal func pagination(with size: CGSize, attributes: [NSAttributedString.Key: Any]) -> [Page.Snapshot] {
        
        let layoutManager: NSLayoutManager = .init()
        let textStore: NSTextStorage = .init(string: contents, attributes: attributes)
        textStore.addLayoutManager(layoutManager)
        
        var offset: Int64 = 0
        var snapshots: Array<Page.Snapshot> = .init()
        
        while true {
            let textContainer: NSTextContainer = .init(size: size)
            layoutManager.addTextContainer(textContainer)
            let range = layoutManager.glyphRange(for: textContainer)
            if range.length <= 0 {
                break
            } else {
                let text = textStore.attributedSubstring(from: range).string
                let snapshot: Page.Snapshot = .init(content: text, sortIndex: offset)
                snapshots.append(snapshot)
                offset += 1
            }
        }
        
        return snapshots
    }
}


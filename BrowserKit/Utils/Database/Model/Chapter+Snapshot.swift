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
    internal class Snapshot: NSObject {
        internal let uniqueID: String
        internal let title: String
        internal let text: String
        internal private(set) var pages: Array<Page.Snapshot>
        internal let modified: Date
        internal let index: Int64
        
        /// 构建
        /// - Parameters:
        ///   - uniqueID: String
        ///   - title: String
        ///   - text: String
        ///   - pages: [Page.Snapshot]
        ///   - modified: Date
        ///   - index: Int64
        internal init(uniqueID: String, title: String, text: String, pages: [Page.Snapshot], modified: Date, index: Int64) {
            self.uniqueID = uniqueID
            self.title = title
            self.text = text
            self.pages = pages
            self.modified = modified
            self.index = index
            super.init()
        }
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
        let textStore: NSTextStorage = .init(string: text, attributes: attributes)
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
                let uniqueID = text.hub.md5()
                let snapshot: Page.Snapshot = .init(uniqueID: uniqueID, text: text, chapterIndex: index , index: offset)
                snapshots.append(snapshot)
                offset += 1
            }
        }
        
        return snapshots
    }
}


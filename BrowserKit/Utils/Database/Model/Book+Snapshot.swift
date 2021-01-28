//
//  Book+Snapshot.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation

extension Book {
    
    /// Book.Snapshot
    internal struct Snapshot {
        internal let uniqueID: String
        internal let creation: Date
        internal let title: String
        internal let contents: Array<Chapter.Snapshot>
    }
}

// MARK: - Book.Snapshot
extension Book.Snapshot {
    
    /// 获取分页信息
    /// - Parameter indexPath: BKIndexPath
    /// - Returns: Page.Snapshot
    internal func page(at indexPath: BKIndexPath) throws -> Page.Snapshot {
        guard indexPath.chapter < contents.count else { throw BKError.customized("未获取到相关章回信息")}
        let chapter = contents[indexPath.chapter]
        guard indexPath.page < chapter.pages.count else { throw BKError.customized("未获取到相关分页信息") }
        return chapter.pages[indexPath.page]
    }
}

//
//  Book+Snapshot.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation
import UIKit
import CoreData

extension Book {
    
    /// Book.Snapshot
    internal class Snapshot: NSObject {
        internal let uniqueID: String
        internal let title: String
        internal private(set) var chapters: Array<Chapter.Snapshot>
        internal let creation: Date
        
        /// 构建
        /// - Parameters:
        ///   - uniqueID: String
        ///   - title: String
        ///   - chapters: Array<Chapter.Snapshot>
        ///   - creation: Date
        internal init(uniqueID: String, title: String, chapters: Array<Chapter.Snapshot>, creation: Date) {
            self.uniqueID = uniqueID
            self.title = title
            self.chapters = chapters
            self.creation = creation
            super.init()
        }
    }
}

// MARK: - Book.Snapshot
extension Book.Snapshot {
    
    /// 获取分页信息
    /// - Parameter indexPath: IndexPath
    /// - Returns: Page.Snapshot
    internal func page(at indexPath: IndexPath, safeArea: CGSize, attributes: [NSAttributedString.Key: Any]) throws -> Page.Snapshot {
        guard indexPath.section < chapters.count else { throw BKError.customized("未获取到相关章回信息")}
        let chapter = chapters[indexPath.section]
        if chapter.pages.isEmpty == true {
            // 开始分页
            let pages = chapter.pagination(with: safeArea, attributes: attributes)
            let _chapter: Chapter.Snapshot = .init(uniqueID: chapter.uniqueID, title: chapter.title, text: chapter.text, pages: pages, modified: .init(), index: chapter.index)
            chapters[indexPath.section] = _chapter
            
            // 存储数据库
            let db = try Database.current()
            db.performBackgroundTask { (context) in
                let object: Chapter = try context.hub.fetchAny(with: .init(format: "uniqueID == %@", chapter.uniqueID))
                pages.forEach { (snapshot) in
                    let page = Page.insert(snapshot: snapshot, inContext: context)
                    page.chapter = object
                }
                try context.hub.save()
            }
            
            // 返回数据
            guard indexPath.item < _chapter.pages.count else { throw BKError.customized("未获取到相关分页信息") }
            return _chapter.pages[indexPath.item]
        } else {
            guard indexPath.item < chapter.pages.count else { throw BKError.customized("未获取到相关分页信息") }
            return chapter.pages[indexPath.item]
        }
    }
    
    /// 重新布局
    /// - Parameters:
    ///   - indexPath: IndexPath
    ///   - safeArea: CGSize
    ///   - attributes: [NSAttributedString.Key: Any]
    /// - Throws: Error
    /// - Returns: Page.Snapshot
    internal func relayout(at indexPath: IndexPath, safeArea: CGSize, attributes: [NSAttributedString.Key: Any]) throws -> Page.Snapshot {
        // 获取当前内容
        let content = try page(at: indexPath, safeArea: safeArea, attributes: attributes).text
        let db = try Database.current()
        let context: NSManagedObjectContext = .init(concurrencyType: .privateQueueConcurrencyType, parent: db.viewContext)
        // 1. 清理分页信息
        let deletes: [Page] = try context.hub.fetch(with: .init(format: "chapter.book.uniqueID == %@", uniqueID))
        context.hub.delete(deletes)
        // 2. 重新分页
        guard indexPath.section < chapters.count else { throw BKError.customized("为获取到相关章节信息")}
        var chapter = chapters[indexPath.section]
        let pages = chapter.pagination(with: safeArea, attributes: attributes)
        chapter = .init(uniqueID: chapter.uniqueID, title: chapter.title, text: chapter.text, pages: pages, modified: .init(), index: chapter.index)
        chapters[indexPath.section] = chapter
        // 存储数据库
        let object: Chapter = try context.hub.fetchAny(with: .init(format: "uniqueID == %@", chapter.uniqueID))
        pages.forEach { (snapshot) in
            let page = Page.insert(snapshot: snapshot, inContext: context)
            page.chapter = object
        }
        try context.hub.save()
        
        // 3. 定位当前内容
        let regex: NSRegularExpression = try .init(pattern: content, options: [])
        guard let result = regex.firstMatch(in: chapter.text, options: [], range: .init(location: 0, length: chapter.text.count)) else {
            throw BKError.customized("当前内容定位失败")
        }
        var offset: Int = 0
        for page in pages {
            offset += page.text.count
            if offset >= result.range.location {
                return page
            }
        }
        throw BKError.customized("当前内容定位失败")
    }
}

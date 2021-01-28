//
//  Chapter+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation
import CoreData

extension Chapter {
    
    /// Chapter.Snapshot
    internal var snapshot: Snapshot {
        let pages = self.pages.map { $0.snapshot }
        return .init(uniqueID: uniqueID, title: title, contents: contents, modified: modified, sortIndex: sortIndex, pages: pages)
    }
}

extension Chapter {
    
    /// 插入章节数据
    /// - Parameters:
    ///   - snapshot: Chapter.Snapshot
    ///   - context: NSManagedObjectContext
    /// - Throws: Error
    /// - Returns: Chapter
    @discardableResult
    internal static func insert(with snapshot: Chapter.Snapshot, inContext context: NSManagedObjectContext) throws -> Chapter {
        if let object: Chapter = try? context.hub.fetchAny(with: .init(format: "uniqueID == %@", snapshot.uniqueID)) {
            return object
        }
        let object = Chapter.init(context: context)
        object.uniqueID = snapshot.uniqueID
        object.title = snapshot.title
        object.contents = snapshot.contents
        object.modified = snapshot.modified
        object.sortIndex = snapshot.sortIndex
        object.pages = []
        return object
    }
}

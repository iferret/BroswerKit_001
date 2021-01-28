//
//  Page+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation
import CoreData

extension Page {
    
    /// Page.Snapshot
    internal var snapshot: Snapshot {
        return .init(uniqueID: uniqueID, text: text, chapterIndex: chapter.index, index: index)
    }
}

extension Page {
    
    /// 插入单页信息
    /// - Parameters:
    ///   - snapshot: Snapshot
    ///   - context: NSManagedObjectContext
    /// - Returns: Self
    @discardableResult
    internal static func insert(snapshot: Snapshot, inContext context: NSManagedObjectContext) -> Page {
        if let object: Page = try? context.hub.fetchAny(with: .init(format: "uniqueID == %@", snapshot.uniqueID)) {
            return object
        } else {
            let object: Page = .init(context: context)
            object.uniqueID = snapshot.uniqueID
            object.index = snapshot.index
            object.text = snapshot.text
            return object
        }
    }
}

//
//  Chapter+CoreDataProperties.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//
//

import Foundation
import CoreData


extension Chapter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chapter> {
        return NSFetchRequest<Chapter>(entityName: "Chapter")
    }

    @NSManaged public var title: String?
    @NSManaged public var sortIndex: Int64
    @NSManaged public var book: Book?
    @NSManaged public var contents: NSSet?

}

// MARK: Generated accessors for contents
extension Chapter {

    @objc(addContentsObject:)
    @NSManaged public func addToContents(_ value: Page)

    @objc(removeContentsObject:)
    @NSManaged public func removeFromContents(_ value: Page)

    @objc(addContents:)
    @NSManaged public func addToContents(_ values: NSSet)

    @objc(removeContents:)
    @NSManaged public func removeFromContents(_ values: NSSet)

}

//
//  Book+CoreDataProperties.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/28.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var creation: Date
    @NSManaged public var title: String
    @NSManaged public var uniqueID: String
    @NSManaged public var chapters: Set<Chapter>

}

// MARK: Generated accessors for chapters
extension Book {

    @objc(addChaptersObject:)
    @NSManaged public func addToChapters(_ value: Chapter)

    @objc(removeChaptersObject:)
    @NSManaged public func removeFromChapters(_ value: Chapter)

    @objc(addChapters:)
    @NSManaged public func addToChapters(_ values: NSSet)

    @objc(removeChapters:)
    @NSManaged public func removeFromChapters(_ values: NSSet)

}

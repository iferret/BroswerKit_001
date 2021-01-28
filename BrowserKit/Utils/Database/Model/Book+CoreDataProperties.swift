//
//  Book+CoreDataProperties.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }
    
    @NSManaged public var uniqueID: String
    @NSManaged public var title: String
    @NSManaged public var contents: Set<Chapter>
    @NSManaged public var creation: Date

}

// MARK: Generated accessors for contents
extension Book {

    @objc(addContentsObject:)
    @NSManaged public func addToContents(_ value: Chapter)

    @objc(removeContentsObject:)
    @NSManaged public func removeFromContents(_ value: Chapter)

    @objc(addContents:)
    @NSManaged public func addToContents(_ values: Set<Chapter>)

    @objc(removeContents:)
    @NSManaged public func removeFromContents(_ values: Set<Chapter>)

}

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

    @NSManaged public var title: String?
    @NSManaged public var creation: Date?
    @NSManaged public var contents: Chapter?

}

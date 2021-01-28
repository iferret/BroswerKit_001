//
//  Page+CoreDataProperties.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/28.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var uniqueID: String
    @NSManaged public var text: String
    @NSManaged public var index: Int64
    @NSManaged public var chapter: Chapter

}

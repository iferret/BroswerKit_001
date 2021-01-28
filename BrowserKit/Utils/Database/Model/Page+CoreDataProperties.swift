//
//  Page+CoreDataProperties.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var content: String
    @NSManaged public var sortIndex: Int64
    
}

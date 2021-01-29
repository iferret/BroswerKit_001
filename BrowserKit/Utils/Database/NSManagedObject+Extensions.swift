//
//  NSManagedObject+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/29.
//

import Foundation
import CoreData

extension NSManagedObject: Compatible {}
extension CompatibleWrapper where Base: NSManagedObject {
    
    /// refresh
    /// - Parameter mergeChanges: Bool
    internal func refresh(_ mergeChanges: Bool = true) {
        base.managedObjectContext?.refresh(base, mergeChanges: mergeChanges)
    }
}

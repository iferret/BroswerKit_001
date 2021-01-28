//
//  NSManagedObjectContext+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/26.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    /// 构建
    /// - Parameters:
    ///   - concurrencyType: NSManagedObjectContextConcurrencyType
    ///   - parent: NSManagedObjectContext
    internal convenience init(concurrencyType: NSManagedObjectContextConcurrencyType, parent: NSManagedObjectContext) {
        self.init(concurrencyType: concurrencyType)
        self.parent = parent
    }
}

extension NSManagedObjectContext: Compatible {}
extension CompatibleWrapper where Base: NSManagedObjectContext {
    
    /// 获取数据
    /// - Parameters:
    ///   - predicate: 谓词
    ///   - fetchLimit: 获取数量
    ///   - sortDescriptors: 排序
    /// - Throws: Error
    /// - Returns: [T]
    internal func fetch<T>(with predicate: NSPredicate? = nil, fetchLimit: Int? =  nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] where T: NSManagedObject {
        let req: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        req.resultType = .managedObjectResultType
        if let predicate = predicate {
            req.predicate = predicate
        }
        if let fetchLimit = fetchLimit {
            req.fetchLimit = fetchLimit
        }
        if let sortDescriptors = sortDescriptors {
            req.sortDescriptors = sortDescriptors
        }
        guard let results = try base.fetch(req) as? [T] else { throw BKError.customized("范型转换错误") }
        return results
    }
    
    /// 获取服务器数据
    /// - Parameter predicate: NSPredicate
    /// - Throws: Error
    /// - Returns: T
    internal func fetchAny<T>(with predicate: NSPredicate? = nil) throws -> T where T: NSManagedObject {
        let req: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        req.resultType = .managedObjectResultType
        req.fetchLimit = 1
        if let predicate = predicate {
            req.predicate = predicate
        }
        let results = try base.fetch(req)
        guard results.isEmpty == false else { throw BKError.customized("未获取到相关数据") }
        guard let result = try base.fetch(req).first as? T else { throw BKError.customized("范型转换错误") }
        return result
    }
    
    /// delete objects
    /// - Parameter objects: [NSManagedObject]
    internal func delete(_ objects: [NSManagedObject]) {
        objects.forEach {
            base.delete($0)
        }
    }
}


extension CompatibleWrapper where Base: NSManagedObjectContext {
    
    /// 保存数据
    /// - Parameter verify: 是否开启 验证 hasChanges
    /// - Throws: throws
    internal func save(verify: Bool = true) throws {
        guard verify == false || base.hasChanges == true else {
            print("NSManagedObjectContext, 没有变化，跳过保存")
            return
        }
        try base.save()
        print("NSManagedObjectContext 保存")
        if let parentCxt = base.parent {
            var parentSaveErr: Error? = nil
            parentCxt.performAndWait {
                do {
                    print("NSManagedObjectContext 同步保存")
                    try parentCxt.hub.save(verify: verify)
                } catch {
                    parentSaveErr = error
                }
            }
            if let error = parentSaveErr {
                throw error
            }
        }
    }
    
    /// 同步保存
    /// - Throws: Error
    internal func saveAndWait() throws {
        var err: Error? = nil
        base.performAndWait {
            do {
                try base.hub.save()
            } catch {
                err = error
            }
        }
        if let error = err {
            throw error
        }
    }
}

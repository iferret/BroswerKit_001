//
//  Database.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/23.
//

import Foundation
import CoreData

/// 数据库管理
class Database {
      
    
    /// NSPersistentContainer
    internal let container: NSPersistentContainer
    /// String
    internal var name: String { container.name }
    /// NSManagedObjectContext
    internal var viewContext: NSManagedObjectContext { container.viewContext }
    /// NSManagedObjectModel
    internal var managedObjectModel: NSManagedObjectModel { container.managedObjectModel }
    /// NSPersistentStoreCoordinator
    internal var persistentStoreCoordinator: NSPersistentStoreCoordinator { container.persistentStoreCoordinator }
    /// [NSPersistentStoreDescription]
    internal var persistentStoreDescriptions: [NSPersistentStoreDescription] { container.persistentStoreDescriptions }
    
    // MARK: - 私有属性
    /// Database
    private static var _current: Database? = nil
    
    // MARK: - 生命周期
    
    /// 构建
    private init() throws {
        let bundle = Bundle.init(for: type(of: self))
        guard let modelUrl = bundle.url(forResource: "BrowserKit", withExtension: "momd"),
              let model = NSManagedObjectModel.init(contentsOf: modelUrl) else { throw BKError.dbInitError }
        let storeUrl = try FileManager.default.hub.dir(with: .sqlites).appendingPathComponent("BrowserKit.sqlite", isDirectory: false)
        let description: NSPersistentStoreDescription = .init(url: storeUrl)
        description.shouldAddStoreAsynchronously = false
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container = .init(name: "BrowserKit", managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        var _error: Error? = nil
        container.loadPersistentStores { (_, error) in
            _error = error
        }
        // 注册
        NSIndexPathTransformer.register()
        guard let error = _error else { return }
        throw error
    }

}

// MARK: - 自定义方法
extension Database {
    
    /// 获取当前数据库对象
    /// - Throws: Error
    /// - Returns: Database
    internal static func current() throws -> Database {
        if let _current = _current {
            return _current
        } else {
            _current = try .init()
            return _current!
        }
    }
    
    /// destory
    internal static func destory() {
        _current = nil
    }
    
    /// newBackgroundContext
    /// - Returns: NSManagedObjectContext
    internal func newBackgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    /// performBackgroundTask
    /// - Parameters:
    ///   - block: @escaping (NSManagedObjectContext) throws -> Void
    ///   - completionHandle: ((Error?) -> Void)?
    internal func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) throws -> Void, completionHandle: ((Error?) -> Void)? = nil) {
        container.performBackgroundTask { (context) in
            do {
                try block(context)
                completionHandle?(nil)
            } catch {
                completionHandle?(error)
            }
        }
    }
    
}


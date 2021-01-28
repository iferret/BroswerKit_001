//
//  NSLock+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/27.
//

import Foundation

extension NSLock: Compatible {}
extension CompatibleWrapper where Base: NSLock {
    
    /// safe lock block
    /// - Parameter block: ()-> Void
    internal func safeLock(_ block: ()->Void) {
        base.lock()
        block()
        base.unlock()
    }
    
    /// safe lock block
    /// - Parameter block: ()->T
    /// - Returns: T
    internal func safeLock<T>(_ block: ()->T) -> T {
        base.lock()
        let value = block()
        base.unlock()
        return value
    }
}

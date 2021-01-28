//
//  NSLock+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/27.
//

import Foundation

extension NSLock: Compatible {}
extension CompatibleWrapper where Base: NSLock {
    
    /// safe lock closure
    /// - Parameter closure: ()-> Void
    internal func safeLock(_ closure: ()->Void) {
        base.lock()
        closure()
        base.unlock()
    }
    
    /// safe lock closure
    /// - Parameter closure: ()->T
    /// - Returns: T
    internal func safeLock<T>(_ closure: ()->T) -> T {
        base.lock()
        let value = closure()
        base.unlock()
        return value
    }
}

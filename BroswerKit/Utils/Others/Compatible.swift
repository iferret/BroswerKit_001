//
//  Compatible.swift
//  BroswerKit
//
//  Created by tramp on 2021/1/23.
//

import Foundation

/// Compatible
protocol Compatible: AnyObject {}
extension Compatible {
    /// Wrapper<Self>
    internal var hub: CompatibleWrapper<Self> {
        set {}
        get { .init(self) }
    }
}

/// CompatibleValue
protocol CompatibleValue {}
extension CompatibleValue {
    /// Wrapper<Self>
    internal var hub: CompatibleWrapper<Self> {
        set {}
        get { .init(self) }
    }
}

/// Wrapper
struct CompatibleWrapper<Base> {
    /// Base
    internal let base: Base
    
    /// 构建
    /// - Parameter base: Base
    internal init(_ base: Base) {
        self.base = base
    }
}

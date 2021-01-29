//
//  NSIndexPathTransformer.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/29.
//

import Foundation

/// NSIndexPathTransformer
@objc(NSIndexPathTransformer)
class NSIndexPathTransformer: ValueTransformer {
    
    /// transformedValueClass
    /// - Returns: AnyClass
    internal override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    /// allowsReverseTransformation
    /// - Returns: Bool
    internal override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    /// transformedValue
    /// - Parameter value: Any
    /// - Returns: Any
    internal override func transformedValue(_ value: Any?) -> Any? {
        guard let indexPath = value as? NSIndexPath else { return nil }
        return "\(indexPath.section)-\(indexPath.item)".data(using: .utf8)
    }
    
    /// reverseTransformedValue
    /// - Parameter value: Any
    /// - Returns: Any
    internal override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let value = value as? Data, let str = String.init(data: value, encoding: .utf8) else { return nil }
        let components = str.components(separatedBy: "-")
        guard components.count == 2 else { return nil }
        let section = (components[0] as NSString).integerValue
        let item = (components[1] as NSString).integerValue
        return NSIndexPath.init(item: item, section: section)
    }
}

// MARK: - NSIndexPathTransformer
extension NSIndexPathTransformer {
    
    /// NSValueTransformerName
    internal static var name: NSValueTransformerName { .init("NSValueTransformerName.NSIndexPathTransformer") }
    
    /// 注册
    internal static func register() {
        NSIndexPathTransformer.setValueTransformer(NSIndexPathTransformer.init(), forName: NSIndexPathTransformer.name)
    }
}

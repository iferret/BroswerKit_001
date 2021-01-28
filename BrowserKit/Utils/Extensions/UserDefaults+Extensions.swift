//
//  UserDefaults+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/27.
//

import Foundation
import UIKit

// MARK: - UserDefaultsKey
internal class UserDefaultsKey: NSObject {
    
    // MARK: - 公开属性
    
    /// String
    internal let rawValue: String
    
    // MARK: - 私有属性
    
    /// NSLock
    private lazy var lock: NSLock = .init()
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameter rawValue: String
    internal init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// safe lock
    /// - Parameter closure: () -> Void
    internal func safeLock(_ closure: () -> Void) {
        lock.hub.safeLock {
            closure()
        }
    }
    
    /// safeLock
    /// - Parameter closure: () -> T
    /// - Returns: T
    internal func safeLock<T>(_ closure: () -> T) -> T {
        return lock.hub.safeLock { () -> T in
            return closure()
        }
    }
}

extension UserDefaultsKey {
    
    /// background color
    internal static let backgroundColor: UserDefaultsKey = .init(rawValue: "BrowserKit.UserDefaultKey.backgroundColor")
    /// text color
    internal static let textColor: UserDefaultsKey = .init(rawValue: "BrowserKit.UserDefaultKey.textColor")
    /// text font
    internal static let textFont: UserDefaultsKey = .init(rawValue: "BrowserKit.UserDefaultKey.textFont")
}


// MARK: - UserDefaults
extension UserDefaults {
    
    // MARK: - 公开属性
    
    /// UserDefaults
    internal static let current: UserDefaults = {
        if let _userDefaults = UserDefaults.init(suiteName: "BrowserKit") {
            return _userDefaults
        } else {
            let _userDefaults = UserDefaults.init()
            _userDefaults.addSuite(named: "BrowserKit")
            return _userDefaults
        }
    }()
    
    
}

extension UserDefaults: Compatible {}
extension CompatibleWrapper where Base: UserDefaults {
    
    
    /// object for key
    /// - Parameter defaultKey: UserDefaultsKey
    /// - Returns: Any?
    internal func object(forKey defaultKey: UserDefaultsKey) -> Any? {
        return defaultKey.safeLock { () -> Any? in
            return base.object(forKey: defaultKey.rawValue)
        }
    }
    
    /**
     -setObject:forKey: immediately stores a value (or removes the value if nil is passed as the value) for the provided key in the search list entry for the receiver's suite name in the current user and any host, then asynchronously stores the value persistently, where it is made available to other processes.
     */
    internal func set(_ value: Any?, forKey defaultKey: UserDefaultsKey) {
        defaultKey.safeLock {
            base.setValue(value, forKey: defaultKey.rawValue)
        }
    }
    
    /// -removeObjectForKey: is equivalent to -[... setObject:nil forKey:defaultKey]
    internal func removeObject(forKey defaultKey: UserDefaultsKey) {
        defaultKey.safeLock {
            base.removeObject(forKey: defaultKey.rawValue)
        }
    }
    
    /// -stringForKey: is equivalent to -objectForKey:, except that it will convert NSNumber values to their NSString representation. If a non-string non-number value is found, nil will be returned.
    internal func string(forKey defaultKey: UserDefaultsKey) -> String? {
        return defaultKey.safeLock { () -> String? in
            return base.string(forKey: defaultKey.rawValue)
        }
    }
    
    /// -arrayForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray.
    internal func array(forKey defaultKey: UserDefaultsKey) -> [Any]? {
        return defaultKey.safeLock { () -> [Any]? in
            return base.array(forKey: defaultKey.rawValue)
        }
    }
    
    /// -dictionaryForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSDictionary.
    internal func dictionary(forKey defaultKey: UserDefaultsKey) -> [String : Any]? {
        return defaultKey.safeLock { () -> [String : Any]? in
            return base.dictionary(forKey: defaultKey.rawValue)
        }
    }
    
    /// -dataForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSData.
    internal func data(forKey defaultKey: UserDefaultsKey) -> Data? {
        return defaultKey.safeLock { () -> Data? in
            return base.data(forKey: defaultKey.rawValue)
        }
    }
    
    /// -stringForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray<NSString *>. Note that unlike -stringForKey:, NSNumbers are not converted to NSStrings.
    internal func stringArray(forKey defaultKey: UserDefaultsKey) -> [String]? {
        return defaultKey.safeLock { () -> [String]? in
            return base.stringArray(forKey: defaultKey.rawValue)
        }
    }
    
    /**
     -integerForKey: is equivalent to -objectForKey:, except that it converts the returned value to an NSInteger. If the value is an NSNumber, the result of -integerValue will be returned. If the value is an NSString, it will be converted to NSInteger if possible. If the value is a boolean, it will be converted to either 1 for YES or 0 for NO. If the value is absent or can't be converted to an integer, 0 will be returned.
     */
    internal func integer(forKey defaultKey: UserDefaultsKey) -> Int {
        return defaultKey.safeLock { () -> Int in
            return base.integer(forKey: defaultKey.rawValue)
        }
    }
    
    
    /// -floatForKey: is similar to -integerForKey:, except that it returns a float, and boolean values will not be converted.
    internal func float(forKey defaultKey: UserDefaultsKey) -> Float {
        return defaultKey.safeLock { () -> Float in
            return base.float(forKey: defaultKey.rawValue)
        }
    }
    
    /// -doubleForKey: is similar to -integerForKey:, except that it returns a double, and boolean values will not be converted.
    internal func double(forKey defaultKey: UserDefaultsKey) -> Double {
        return defaultKey.safeLock { () -> Double in
            return base.double(forKey: defaultKey.rawValue)
        }
    }
    
    /**
     -boolForKey: is equivalent to -objectForKey:, except that it converts the returned value to a BOOL. If the value is an NSNumber, NO will be returned if the value is 0, YES otherwise. If the value is an NSString, values of "YES" or "1" will return YES, and values of "NO", "0", or any other string will return NO. If the value is absent or can't be converted to a BOOL, NO will be returned.
     
     */
    internal func bool(forKey defaultKey: UserDefaultsKey) -> Bool {
        return defaultKey.safeLock { () -> Bool in
            return base.bool(forKey: defaultKey.rawValue)
        }
    }
    
    /**
     -URLForKey: is equivalent to -objectForKey: except that it converts the returned value to an NSURL. If the value is an NSString path, then it will construct a file URL to that path. If the value is an archived URL from -setURL:forKey: it will be unarchived. If the value is absent or can't be converted to an NSURL, nil will be returned.
     */
    @available(iOS 4.0, *)
    internal func url(forKey defaultKey: UserDefaultsKey) -> URL? {
        return defaultKey.safeLock { () -> URL? in
            return base.url(forKey: defaultKey.rawValue)
        }
    }
    
    /// -setInteger:forKey: is equivalent to -setObject:forKey: except that the value is converted from an NSInteger to an NSNumber.
    internal func set(_ value: Int, forKey defaultKey: UserDefaultsKey) {
        defaultKey.safeLock {
            base.set(value, forKey: defaultKey.rawValue)
        }
    }
    
    /// -setFloat:forKey: is equivalent to -setObject:forKey: except that the value is converted from a float to an NSNumber.
    internal func set(_ value: Float, forKey defaultKey: UserDefaultsKey) {
        defaultKey.safeLock {
            base.set(value, forKey: defaultKey.rawValue)
        }
    }
    
    /// -setDouble:forKey: is equivalent to -setObject:forKey: except that the value is converted from a double to an NSNumber.
    internal func set(_ value: Double, forKey defaultKey: UserDefaultsKey) {
        defaultKey.safeLock {
            base.set(value, forKey: defaultKey.rawValue)
        }
    }
    
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a BOOL to an NSNumber.
    internal func set(_ value: Bool, forKey defaultKey: UserDefaultsKey) {
        defaultKey.safeLock {
            base.set(value, forKey: defaultKey.rawValue)
        }
    }
    
    /// -setURL:forKey is equivalent to -setObject:forKey: except that the value is archived to an NSData. Use -URLForKey: to retrieve values set this way.
    @available(iOS 4.0, *)
    internal func set(_ url: URL?, forKey defaultKey: UserDefaultsKey) {
        defaultKey.safeLock {
            base.set(url, forKey: defaultKey.rawValue)
        }
    }
    
    /**
     -registerDefaults: adds the registrationDictionary to the last item in every search list. This means that after NSUserDefaults has looked for a value in every other valid location, it will look in registered defaults, making them useful as a "fallback" value. Registered defaults are never stored between runs of an application, and are visible only to the application that registers them.
     
     Default values from Defaults Configuration Files will automatically be registered.
     */
    internal func register(defaults registrationDictionary: [UserDefaultsKey : Any]) {
        var dict: [String: Any] = [:]
        registrationDictionary.forEach { (defaultKey, value) in
            dict[defaultKey.rawValue] = value
        }
        base.register(defaults: dict)
    }
    
    /**
     -synchronize is deprecated and will be marked with the API_DEPRECATED macro in a future release.
     
     -synchronize blocks the calling thread until all in-progress set operations have completed. This is no longer necessary. Replacements for previous uses of -synchronize depend on what the intent of calling synchronize was. If you synchronized...
     - ...before reading in order to fetch updated values: remove the synchronize call
     - ...after writing in order to notify another program to read: the other program can use KVO to observe the default without needing to notify
     - ...before exiting in a non-app (command line tool, agent, or daemon) process: call CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
     - ...for any other reason: remove the synchronize call
     */
    @discardableResult
    internal func synchronize() -> Bool {
       return base.synchronize()
    }
    
    /// objectIsForced
    /// - Parameter defaultkey: UserDefaultsKey
    /// - Returns: Bool
    internal func objectIsForced(forKey defaultkey: UserDefaultsKey) -> Bool {
        return defaultkey.safeLock { () -> Bool in
            return base.objectIsForced(forKey: defaultkey.rawValue)
        }
    }
    
    /// objectIsForced
    /// - Parameters:
    ///   - defaultkey: UserDefaultsKey
    ///   - domain: String
    /// - Returns: Bool
    internal func objectIsForced(forKey defaultkey: UserDefaultsKey, inDomain domain: String) -> Bool {
        return defaultkey.safeLock { () -> Bool in
            return base.objectIsForced(forKey: defaultkey.rawValue, inDomain: domain)
        }
    }
}

extension CompatibleWrapper where Base: UserDefaults {
    
    
    /// set color
    /// - Parameters:
    ///   - color: UIColor
    ///   - defaultKey: UserDefaultsKey
    internal func set(_ color: UIColor?, forKey defaultKey: UserDefaultsKey) {
        defaultKey.safeLock {
            base.set(color?.hub.toHex(), forKey: defaultKey.rawValue)
        }
    }
    
    /// 获取 UIColor
    /// - Parameter defaultKey: UserDefaultsKey
    /// - Returns: UIColor
    internal func color(forKey defaultKey: UserDefaultsKey) -> UIColor? {
        return defaultKey.safeLock { () -> UIColor? in
            guard let hex = base.string(forKey: defaultKey.rawValue) else { return nil }
            return UIColor.init(hex: hex)
        }
    }
    
    /// set font
    /// - Parameters:
    ///   - font: UIFont
    ///   - defaultKey: UserDefaultsKey
    internal func set(_ font: UIFont?, forKey defaultKey: UserDefaultsKey) {
        let sizeKey = "\(defaultKey.rawValue).sizeKey"
        let nameKey = "\(defaultKey.rawValue).nameKey"
        if let font = font {
            defaultKey.safeLock {
                base.set(font.fontName, forKey: nameKey)
                base.set(font.pointSize, forKey: sizeKey)
            }
        } else {
            defaultKey.safeLock {
                base.set(nil, forKey: sizeKey)
                base.set(nil, forKey: nameKey)
            }
        }
    }
    
    /// font for key
    /// - Parameter defaultKey: UserDefaultsKey
    /// - Returns: UIFont
    internal func font(forKey defaultKey: UserDefaultsKey) -> UIFont? {
        let sizeKey = "\(defaultKey.rawValue).sizeKey"
        let nameKey = "\(defaultKey.rawValue).nameKey"
        return defaultKey.safeLock { () -> UIFont? in
            guard let name = base.string(forKey: nameKey) else { return nil }
            let size = base.double(forKey: sizeKey)
            return UIFont.init(name: name, size: CGFloat(size))
        }
    }
}

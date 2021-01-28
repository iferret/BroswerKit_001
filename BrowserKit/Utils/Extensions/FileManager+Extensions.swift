//
//  FileManager+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation

extension FileManager: Compatible {}
extension CompatibleWrapper where Base: FileManager {
    /// Dir
    enum Dir {
        case customize(_ path: String)
        case sqlites
        
        /// rawValue
        internal var rawValue: String {
            switch self {
            case .customize(let path): return path
            case .sqlites: return "sqlites"
            }
        }
    }
    
    /// 获取文件夹
    /// - Parameter dir: Dir
    /// - Throws: Error
    /// - Returns: URL
    internal func dir(with dir: Dir) throws -> URL {
        var url = base.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BrowserKit", isDirectory: true)
        url.appendPathComponent(dir.rawValue, isDirectory: true)
        var isDir: ObjCBool = .init(false)
        if base.fileExists(atPath: url.path, isDirectory: &isDir) == false {
            try base.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return url
        } else {
            guard isDir.boolValue == false else { return url }
            try base.removeItem(at: url)
            try base.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return url
        }
    }
    
}

extension CompatibleWrapper where Base: FileManager {
    
    /// 获取唯一标识
    /// - Parameter fileUrl: 文件存储位置
    /// - Throws: Error
    /// - Returns: String
    internal func uniqueID(for fileUrl: URL) throws -> String {
        var isDir: ObjCBool = .init(false)
        guard base.fileExists(atPath: fileUrl.path, isDirectory: &isDir) == true, isDir.boolValue == false else { throw BKError.fileNotfound }
        return fileUrl.pathComponents.suffix(2).joined(separator: "-").hub.md5
    }
    
    /// 获取文件编码格式
    /// - Parameter fileUrl: URL
    /// - Returns: String.Encoding
    internal func encoding(for fileUrl: URL) throws -> String.Encoding {
        let data = try Data.init(contentsOf: fileUrl)
        let encodings = String.availableStringEncodings
        let test = "大a哥bπc你d好e啊f》“}！@#￥%……&*QWERTYUIqwertyuio请问儿童Yui《》？：“{}|，。、阿什利金佛；大公鸡IOS的奶粉了凯撒的佛是大佛寺啊的佛纳忙死了放得开21；‘【】、<>?:{}|,./[]"
        for encoding in encodings {
            guard encoding.rawValue != 2415919360 && encoding.rawValue != 2483028224 else { continue }
            guard let testData = test.data(using: encoding) else { continue }
            let tempData =  data + testData
            guard let temp = String.init(data: tempData, encoding: encoding) else { continue }
            let contents = temp.suffix(test.count)
            guard strcmp(contents.cString(using: .unicode), test.cString(using: .unicode)) == 0 else { continue }
            return encoding
        }
        throw BKError.encodigError
    }
}


//
//  Book+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation
import CoreData

extension Book {
    
    /// Book.Snapshot
    internal var snapshot: Snapshot {
        let chapters = self.chapters.map { $0.snapshot }.sorted(by: { $0.index < $1.index })
        return .init(uniqueID: uniqueID, title: title, chapters: chapters, creation: creation)
    }
}


extension Book {
    
    /// 插入书籍
    /// - Parameters:
    ///   - fileUrl: 文件存储路径
    ///   - context: NSManagedObjectContext
    /// - Throws: Error
    @discardableResult
    internal static func insert(with fileUrl: URL, inContext context: NSManagedObjectContext) throws -> Book {
        let uniqueID = try FileManager.default.hub.uniqueID(for: fileUrl)
        if let object: Book = try? context.hub.fetchAny(with: .init(format: "uniqueID == %@", uniqueID)) {
            return object
        }
        let object = Book.init(context: context)
        object.uniqueID = uniqueID
        object.title = fileUrl.lastPathComponent
        object.creation = .init()
        
        let encoding = try FileManager.default.hub.encoding(for: fileUrl)
        let contents = try String.init(contentsOf: fileUrl, encoding: encoding)
        let snapshots = try self.chapters(for: contents)
        for snapshot in snapshots {
           let chapter = try Chapter.insert(with: snapshot, inContext: context)
            chapter.book = object
            if chapter.title == "未知" {
                chapter.title = fileUrl.deletingPathExtension().lastPathComponent
            }
        }
        return object
    }
    
}

extension Book {
    
    
    /// 获取文章章节
    /// - Parameter txt: String
    /// - Returns: [Chapter.Snapshot]
    internal static func chapters(for txt: String) throws -> [Chapter.Snapshot] {
        let pattern = "第[ ]*[0-9一二三四五六七八九十百千]*[ ]*[章回].*"
        let regExp = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let results = regExp.matches(in: txt, options: .reportCompletion, range: .init(location: 0, length: txt.count))
        if results.isEmpty == false { // 按照章回拆分
            return results.enumerated().map { (offset, element) -> Chapter.Snapshot in
                let location = element.range.location
                let length: Int
                if offset < results.count - 1 {
                    length = results[offset + 1].range.location - location
                } else {
                    length = txt.count - element.range.location
                }
                let title = (txt as NSString).substring(with: element.range)
                let contents = (txt as NSString).substring(with: .init(location: location, length: length))
                let md5 = contents.hub.md5()
                return .init(uniqueID: md5, title: title, text: contents, pages: [], modified: .init(), index: Int64(offset))
            }
        } else { // 按照字数拆分
            let length = 10000
            let title = "未知"
            var txt: String = txt
            var chapters: [Chapter.Snapshot] = []
            var offset: Int64 = 0
            while txt.isEmpty == false {
                var contents: String = String.init(txt.prefix(length))
                txt = String.init(txt.dropFirst(length))
                let pattern = "(\([#"\r\n\r\n"#, #"\r\n"#, #"\r"#, #"\n"#].joined(separator: "|")))"
                let regExp = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
                if let result = regExp.firstMatch(in: txt, options: .reportCompletion, range: .init(location: 0, length: txt.count)) {
                    contents = contents + txt.prefix(result.range.location + result.range.length)
                    txt = String.init(txt.dropFirst(result.range.location + result.range.length))
                }
                let md5 = contents.hub.md5()
                chapters.append(.init(uniqueID: md5, title: title, text: contents, pages: [], modified: .init(), index: offset))
                offset += 1
            }
            return chapters
        }
    }
}

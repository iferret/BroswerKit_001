//
//  BKError.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/24.
//

import Foundation

/// BKError
enum BKError {
    /// 数据库初始化失败
    case dbInitError
    /// 未找到相关文件
    case fileNotfound
    /// 编码格式错误
    case encodigError
    /// 自定义
    case customized(_ message: String)
}

// MARK: - Error
extension BKError: Error {
    
    /// localizedDescription
    internal var localizedDescription: String {
        switch self {
        case .dbInitError: return "数据库初始化失败"
        case .fileNotfound: return "未找到相关文件"
        case .encodigError: return "编码格式错误"
        case .customized(let message): return message
        }
    }
}

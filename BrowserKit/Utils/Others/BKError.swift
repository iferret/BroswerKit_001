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
}

// MARK: - Error
extension BKError: Error {
    
    /// localizedDescription
    internal var localizedDescription: String {
        switch self {
        case .dbInitError:
            return "数据库初始化失败"
        }
    }
}

//
//  BKMenuToolBar.swift
//  BroswerKit
//
//  Created by tramp on 2021/1/23.
//

import Foundation
import UIKit

/// BKMenuTitleBar
class BKMenuToolBar: UIVisualEffectView {
    
    // MARK: - 私有属性
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameter effect: UIVisualEffect
    internal override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        // 初始化
        initialize()
    }
    
    /// 构建
    /// - Parameter coder: NSCoder
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 自定义
extension BKMenuToolBar {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        
    }
}

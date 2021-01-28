//
//  BKMenuToolBar.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/23.
//

import Foundation
import UIKit


/// BKMenuToolBarDelegate
protocol BKMenuToolBarDelegate: NSObjectProtocol {
    
    /// 主题切换
    /// - Parameters:
    ///   - menuToolBar: BKMenuToolBar
    ///   - theme: BKTheme
    func menuToolBar(_ menuToolBar: BKMenuToolBar, themeChangeHandle theme: BKTheme)
}

/// BKMenuTitleBar
class BKMenuToolBar: UIVisualEffectView {
    
    // MARK: - 公开属性
    
    /// BKMenuToolBarDelegate
    internal weak var delegate: BKMenuToolBarDelegate? = nil
    
    // MARK: - 私有属性
    
    /// backgroundColorBar
    private lazy var colorBar: UIToolbar = {
        let _bar = UIToolbar.init(frame: .init(x: 0.0, y: 0.0, width: 100.0, height: 44.0))
        _bar.setBackgroundImage(.init(), forToolbarPosition: .any, barMetrics: .default)
        _bar.setShadowImage(.init(), forToolbarPosition: .any)
        _bar.items = [
            .flexible(), BKTheme.light.barItem.hub.add(target: self, action: #selector(themeItemActionHandle(_:))),
            .flexible(), BKTheme.soft.barItem.hub.add(target: self, action: #selector(themeItemActionHandle(_:))),
            .flexible(), BKTheme.girl.barItem.hub.add(target: self, action: #selector(themeItemActionHandle(_:))),
            .flexible(), BKTheme.medium.barItem.hub.add(target: self, action: #selector(themeItemActionHandle(_:))),
            .flexible(), BKTheme.heavy.barItem.hub.add(target: self, action: #selector(themeItemActionHandle(_:))),
            .flexible()
        ]
        return _bar
    }()
    
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
        
        // 布局
        
        contentView.addSubview(colorBar)
        colorBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44.0)
            $0.top.equalToSuperview().offset(10.0)
        }
    }
    
    /// themeItemActionHandle
    /// - Parameter button: UIButton
    @objc private func themeItemActionHandle(_ sender: UIButton) {
        guard let theme = BKTheme.init(rawValue: sender.tag) else { return }
        delegate?.menuToolBar(self, themeChangeHandle: theme)
    }
}

//
//  BKMenuTitleBar.swift
//  BroswerKit
//
//  Created by tramp on 2021/1/23.
//

import Foundation
import UIKit
import SnapKit

/// BKMenuTitleBarDelegate
protocol BKMenuTitleBarDelegate: NSObjectProtocol {
    
    /// closeActionHandle
    /// - Parameters:
    ///   - menuTitleBar: BKMenuTitleBar
    ///   - sender: UIBarButtonItem
    func menuTitleBar(_ menuTitleBar: BKMenuTitleBar, closeActionHandle sender: UIBarButtonItem)
    
    /// tagActionHandle
    /// - Parameters:
    ///   - menuTitleBar: BKMenuTitleBar
    ///   - sender: UIBarButtonItem
    func menuTitleBar(_ menuTitleBar: BKMenuTitleBar, tagActionHandle sender: UIBarButtonItem)
}

/// BKMenuTitleBar
class BKMenuTitleBar: UIVisualEffectView {
    
    // MARK: - 公开属性
    
    /// BKMenuTitleBarDelegate
    internal weak var delegate: BKMenuTitleBarDelegate? = nil
    
    // MARK: - 私有属性
    
    /// close item
    private lazy var closeItem: UIBarButtonItem = {
        let _img = UIImage.init(named: "close", in: .framework)?.withRenderingMode(.alwaysTemplate)
        let _item = UIBarButtonItem.init(image: _img, style: .plain, target: self, action: #selector(itemActionHandle(_:)))
        _item.tintColor = .white
        return _item
    }()
    
    /// tag item
    private lazy var tagItem: UIBarButtonItem = {
        let _img = UIImage.init(named: "tag", in: .framework)?.withRenderingMode(.alwaysTemplate)
        let _item = UIBarButtonItem.init(image: _img, style: .plain, target: self, action: #selector(itemActionHandle(_:)))
        _item.tintColor = .white
        return _item
    }()
    
    /// UIToolbar
    private lazy var toolbar: UIToolbar = {
        let _toolbar = UIToolbar.init(frame: .init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        _toolbar.setBackgroundImage(.init(), forToolbarPosition: .any, barMetrics: .default)
        _toolbar.setShadowImage(.init(), forToolbarPosition: .any)
        _toolbar.items = [closeItem, .flexible(), tagItem]
        return _toolbar
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
extension BKMenuTitleBar {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        
        // 布局
        contentView.addSubview(toolbar)
        toolbar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(44.0)
        }
    }
    
    /// itemActionHandle
    /// - Parameter item: UIBarButtonItem
    @objc private func itemActionHandle(_ item: UIBarButtonItem) {
        switch item {
        case closeItem:
            delegate?.menuTitleBar(self, closeActionHandle: item)
        case tagItem:
            delegate?.menuTitleBar(self, tagActionHandle: item)
        default: break
        }
    }
}

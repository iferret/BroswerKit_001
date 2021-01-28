//
//  BKMenuViewController.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/23.
//

import UIKit
import SnapKit

// MARK: - BKMenuViewControllerDelegate
protocol BKMenuViewControllerDelegate: NSObjectProtocol {
    
    /// closeActionHandle
    /// - Parameters:
    ///   - menuViewController: BKMenuViewController
    ///   - sender: UIBarButtonItem
    func menuViewController(_ menuViewController: BKMenuViewController, closeActionHandle sender: UIBarButtonItem)
    
    /// tagActionHandle
    /// - Parameters:
    ///   - menuViewController: BKMenuViewController
    ///   - sender: UIBarButtonItem
    func menuViewController(_ menuViewController: BKMenuViewController, tagActionHandle sender: UIBarButtonItem)
    
    /// themeActionHandle
    /// - Parameters:
    ///   - menuViewController: BKMenuViewController
    ///   - sender: BKTheme
    func menuViewController(_ menuViewController: BKMenuViewController, themeActionHandle sender: BKTheme)
    
    /// 当前主题
    /// - Parameter menuViewController: BKMenuViewController
    func currentTheme(menuViewController: BKMenuViewController) -> BKTheme
}

// MARK: - BKMenuViewController
class BKMenuViewController: UIViewController {
    
    // MARK: - 公开属性
    
    /// prefersStatusBarHidden
    internal override var prefersStatusBarHidden: Bool { false }
    /// preferredStatusBarStyle
    internal override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    /// BKMenuViewControllerDelegate
    internal weak var delegate: BKMenuViewControllerDelegate? = nil
    
    // MARK: - 私有属性
    
    /// UITapGestureRecognizer
    private lazy var tap: UITapGestureRecognizer = {
        let _tap: UITapGestureRecognizer = .init(target: self, action: #selector(tapGestureHandle(_:)))
        return _tap
    }()
    
    /// title bar
    private lazy var titleBar: BKMenuTitleBar = {
        let _effect = UIBlurEffect.init(style: .dark)
        let _bar = BKMenuTitleBar.init(effect: _effect)
        _bar.delegate = self
        return _bar
    }()
    
    /// tool bar
    private lazy var toolBar: BKMenuToolBar = {
        let _effect = UIBlurEffect.init(style: .dark)
        let _bar = BKMenuToolBar.init(effect: _effect)
        _bar.delegate = self
        return _bar
    }()
    
    /// 唯一标识
    private let uniqueID: String
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameter uniqueID: 唯一标识
    internal init(with uniqueID: String) {
        self.uniqueID = uniqueID
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    /// 构建
    /// - Parameter coder: NSCoder
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// viewDidLoad
    internal override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 初始化
        initialize()
    }
    
    /// viewDidLayoutSubviews
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // update transform
        titleBar.transform = .init(translationX: 0.0, y: -titleBar.bounds.height)
        toolBar.transform = .init(translationX: 0.0, y: toolBar.bounds.height)
        // show menu view
        showMenuViews()
    }
}

// MARK: - 自定义
extension BKMenuViewController {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        view.addGestureRecognizer(tap)
        
        // 布局
        view.addSubview(titleBar)
        titleBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44.0)
        }
        
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-160.0)
        }
    }
    
    /// tapGestureHandle
    /// - Parameter tap: UITapGestureRecognizer
    @objc private func tapGestureHandle(_ tap: UITapGestureRecognizer) {
        guard [toolBar.frame, titleBar.frame].contains(where: { $0.contains(tap.location(in: view)) }) == false else { return }
        hideMenuViews { [weak self](_) in
            guard let this = self else { return }
            this.dismiss(animated: true, completion:  nil)
        }
    }
    
    /// showMenuViews
    /// - Parameters:
    ///   - duration: TimeInterval
    ///   - completionHandle: ((Bool) ->Void)? = nil
    private func showMenuViews(duration: TimeInterval = 0.25, completionHandle: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: duration) {
            self.titleBar.transform = .identity
            self.toolBar.transform = .identity
        } completion: { (completed) in
            completionHandle?(completed)
        }
        
    }
    
    /// hideMenuViews
    /// - Parameters:
    ///   - duration: TimeInterval
    ///   - completionHandle: ((Bool) ->Void)? = nil
    private func hideMenuViews(duration: TimeInterval = 0.25, completionHandle: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: duration) {
            self.titleBar.transform = .init(translationX: 0.0, y: -self.toolBar.bounds.height)
            self.toolBar.transform = .init(translationX: 0.0, y: self.toolBar.bounds.height)
        } completion: { (completed) in
            completionHandle?(completed)
        }
    }
}

// MARK: - BKMenuTitleBarDelegate
extension BKMenuViewController: BKMenuTitleBarDelegate {
    
    /// closeActionHandle
    /// - Parameters:
    ///   - menuTitleBar: BKMenuTitleBar
    ///   - sender: UIBarButtonItem
    internal func menuTitleBar(_ menuTitleBar: BKMenuTitleBar, closeActionHandle sender: UIBarButtonItem) {
        hideMenuViews(duration: 0.25) { [weak self](_) in
            guard let this = self, let delegate = this.delegate else { return }
            delegate.menuViewController(this, closeActionHandle: sender)
        }
    }
    
    /// tagActionHandle
    /// - Parameters:
    ///   - menuTitleBar: BKMenuTitleBar
    ///   - sender: UIBarButtonItem
    internal func menuTitleBar(_ menuTitleBar: BKMenuTitleBar, tagActionHandle sender: UIBarButtonItem) {
        delegate?.menuViewController(self, tagActionHandle: sender)
    }
    
    
}

// MARK: - BKMenuToolBarDelegate
extension BKMenuViewController: BKMenuToolBarDelegate {
    
    /// themeChangeHandle
    /// - Parameters:
    ///   - menuToolBar: BKMenuToolBar
    ///   - theme: BKTheme
    internal func menuToolBar(_ menuToolBar: BKMenuToolBar, themeChangeHandle theme: BKTheme) {
        delegate?.menuViewController(self, themeActionHandle: theme)
    }
    
    
    /// 获取当前主题
    /// - Parameter menuToolBar: BKMenuToolBar
    /// - Returns: BKTheme
    internal func currentTheme(menuToolBar: BKMenuToolBar) -> BKTheme {
        return delegate?.currentTheme(menuViewController: self) ?? .light
    }
}

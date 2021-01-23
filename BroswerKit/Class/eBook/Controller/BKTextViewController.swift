//
//  BKTextViewController.swift
//  BroswerKit
//
//  Created by tramp on 2021/1/23.
//

import UIKit

/// BKTextViewController
public class BKTextViewController: UIViewController {
    
    // MARK: - 公开属性
    
    /// prefersStatusBarHidden
    public override var prefersStatusBarHidden: Bool { true }
    
    // MARK: - 私有属性
    
    /// UITapGestureRecognizer
    private lazy var tap: UITapGestureRecognizer = {
        let _tap: UITapGestureRecognizer = .init(target: self, action: #selector(tapGestureHandle(_:)))
        return _tap
    }()
    
    /// BKPageViewController
    private lazy var pageController: BKPageViewController = {
        let _controller = BKPageViewController.init(transitionStyle: .pageCurl)
        _controller.delegate = self
        _controller.dataSource = self
        return _controller
    }()
    
    /// 文件存储位置
    private let fileUrl: URL
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameter fileUrl: 文件存储位置
    public init(with fileUrl: URL) {
        self.fileUrl = fileUrl
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .fullScreen
    }
    
    /// 构建
    /// - Parameter coder: NSCoder
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// viewDidLoad
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 初始化
        initialize()
        
        pageController.setViewControllers([BKContentViewController.init()], direction: .forward, animated: false)
    }
    
}

// MARK: - 自定义
extension BKTextViewController {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        view.backgroundColor = .cyan
        view.addGestureRecognizer(tap)
        addChild(pageController)
        
        // 布局
        pageController.view.frame = view.bounds
        view.addSubview(pageController.view)
        
    }
    
    /// tapGestureHandle
    /// - Parameter tap: UITapGestureRecognizer
    @objc private func tapGestureHandle(_ tap: UITapGestureRecognizer) {
        let controller = BKMenuViewController.init(with: "xxxx")
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - BKMenuViewControllerDelegate
extension BKTextViewController: BKMenuViewControllerDelegate {
    
    /// closeActionHandle
    /// - Parameters:
    ///   - menuViewController: BKMenuViewController
    ///   - sender: UIBarButtonItem
    internal func menuViewController(_ menuViewController: BKMenuViewController, closeActionHandle sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /// tagActionHandle
    /// - Parameters:
    ///   - menuViewController: BKMenuViewController
    ///   - sender: UIBarButtonItem
    internal func menuViewController(_ menuViewController: BKMenuViewController, tagActionHandle sender: UIBarButtonItem) {
        print(#function)
    }
    
}

// MARK: - BKPageViewControllerDelegate
extension BKTextViewController: BKPageViewControllerDelegate {
    
    /// didFinishAnimating
    /// - Parameters:
    ///   - pageViewController: BKPageViewController
    ///   - finished: Bool
    ///   - previousViewControllers: [UIViewController]
    ///   - completed: Bool
    internal func pageViewController(_ pageViewController: BKPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print(#function)
    }
    
    /// spineLocationFor orientation
    /// - Parameters:
    ///   - pageViewController: BKPageViewController
    ///   - orientation: UIInterfaceOrientation
    /// - Returns: BKPageViewController.SpineLocation
    internal func pageViewController(_ pageViewController: BKPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> BKPageViewController.SpineLocation {
        return .min
    }
}

// MARK: - BKPageViewControllerDataSource
extension BKTextViewController: BKPageViewControllerDataSource {
    
    /// viewControllerBefore
    /// - Parameters:
    ///   - pageViewController: BKPageViewController
    ///   - viewController: UIViewController
    internal func pageViewController(_ pageViewController: BKPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print(viewController.view.safeAreaInsets)
        return BKContentViewController.init()
    }
    
    /// viewControllerAfter
    /// - Parameters:
    ///   - pageViewController: BKPageViewController
    ///   - viewController: UIViewController
    internal func pageViewController(_ pageViewController: BKPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return BKContentViewController.init()
    }
    
}

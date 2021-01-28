//
//  BKTextViewController.swift
//  BrowserKit
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
    /// BKConfiguration
    private let configuration: BKConfiguration
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameters:
    ///   - fileUrl: 文件存储位置
    ///   - configuration: BKConfiguration
    public init(with fileUrl: URL, configuration: BKConfiguration = .default) {
        self.fileUrl = fileUrl
        self.configuration = configuration
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
        
        do {
            let db = try Database.current()
            try Book.insert(with: fileUrl, inContext: db.viewContext)
            try db.viewContext.hub.saveAndWait()
            
//            guard let page = object.snapshot.contents.first?.pagination(with: view.bounds.size.hub.inset(by:  configuration.safeAreaInsets),
//                                                                      attributes: configuration.attributes)[2]else { return }
            
            let safeArea = view.bounds.size.hub.inset(by: configuration.safeAreaInsets)
            let object: Book = try db.viewContext.hub.fetchAny()
            let page = try object.snapshot.page(at: .init(item: 0, section: 0), safeArea: safeArea, attributes: configuration.attributes)
            
            let controller: BKContentViewController = .init(with: page, configuration: configuration)
            pageController.setViewControllers([controller], direction: .forward, animated: false)
        } catch {
            
        }
    }
    
    /// deinit
    deinit {
        print("BKTextViewController object has been destoryed ...")
    }
}

// MARK: - 自定义
extension BKTextViewController {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        view.backgroundColor = configuration.backgroundColor
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
    
    /// themeActionHandle
    /// - Parameters:
    ///   - menuViewController: BKMenuViewController
    ///   - sender: BKTheme
    internal func menuViewController(_ menuViewController: BKMenuViewController, themeActionHandle sender: BKTheme) {
        guard let cotnrollers = pageController.viewControllers as? [BKContentViewController] else { return }
        cotnrollers.forEach { (controller) in
            controller.view.hub.set(backgroundColor: sender.colors.backgroundColor, animated: true)
            controller.add(attributes: [.foregroundColor: sender.colors.textColor], animated: true)
        }
        UserDefaults.current.hub.set(theme: sender, defaultKey: .theme)
        UserDefaults.current.hub.synchronize()
    }
    
    /// BKTheme
    /// - Parameter menuViewController: BKMenuViewController
    /// - Returns: BKTheme
    internal func currentTheme(menuViewController: BKMenuViewController) -> BKTheme {
        return UserDefaults.current.hub.theme(forKey: .theme) ?? .light
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
        return nil
    }
    
    /// viewControllerAfter
    /// - Parameters:
    ///   - pageViewController: BKPageViewController
    ///   - viewController: UIViewController
    internal func pageViewController(_ pageViewController: BKPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
}

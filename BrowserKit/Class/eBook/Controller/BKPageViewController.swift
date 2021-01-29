//
//  BKPageViewController.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/23.
//

import UIKit

// MARK: - BKPageViewControllerDelegate
protocol BKPageViewControllerDelegate: NSObjectProtocol {

    /// willTransitionTo
    /// - Parameters:
    ///   - pageViewController: BKPageViewController
    ///   - pendingViewControllers: [UIViewController]
    func pageViewController(_ pageViewController: BKPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    
    /// didFinishAnimating
    /// - Parameters:
    ///   - pageViewController: BKPageViewController
    ///   - finished: Bool
    ///   - previousViewControllers: [UIViewController]
    ///   - completed: Bool
    func pageViewController(_ pageViewController: BKPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    
    /// spineLocationFor orientation
    /// - Parameters:
    ///   - pageViewController: BKPageViewController
    ///   - orientation: UIInterfaceOrientation
    func pageViewController(_ pageViewController: BKPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> BKPageViewController.SpineLocation
    
    /// pageViewControllerSupportedInterfaceOrientations
    /// - Parameter pageViewController: BKPageViewController
    func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: BKPageViewController) -> UIInterfaceOrientationMask
    
    /// pageViewControllerPreferredInterfaceOrientationForPresentation
    /// - Parameter pageViewController: BKPageViewController
    func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: BKPageViewController) -> UIInterfaceOrientation
}
extension BKPageViewControllerDelegate {
    internal func pageViewController(_ pageViewController: BKPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {}
    internal func pageViewController(_ pageViewController: BKPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {}
    internal func pageViewController(_ pageViewController: BKPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> BKPageViewController.SpineLocation {
        return pageViewController.transitionStyle == .pageCurl ? .min : .none
    }
    internal func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: BKPageViewController) -> UIInterfaceOrientationMask { .portrait }
    internal func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: BKPageViewController) -> UIInterfaceOrientation { .portrait }
}

// MARK: - BKPageViewControllerDataSource
protocol BKPageViewControllerDataSource: NSObjectProtocol {
    
//
//    /// numberOfSections
//    /// - Parameter pageViewController: BKPageViewController
//    func numberOfSections(for pageViewController: BKPageViewController) -> Int
//    
//    /// numberOfItemsInSection
//    /// - Parameters:
//    ///   - pageViewController: BKPageViewController
//    ///   - section: Int
//    func pageViewController(_ pageViewController: BKPageViewController, numberOfItemsInSection section: Int) -> Int
//    
//    /// controllerForItemAt
//    /// - Parameters:
//    ///   - pageViewController: BKPageViewController
//    ///   - indexPath: UIViewController
//    func pageViewController(_ pageViewController: BKPageViewController, controllerForItemAt indexPath: IndexPath) -> UIViewController
//    
//    /// currentIndexPath
//    /// - Parameter pageViewController: BKPageViewController
//    func currentIndexPath(for pageViewController: BKPageViewController) -> IndexPath
    
    
    /// viewControllerBefore
    /// - Parameters:
    ///   - pageViewController: BKPageViewController
    ///   - viewController: UIViewController
    func pageViewController(_ pageViewController: BKPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    
    /// viewControllerAfter
    /// - Parameters:
    ///   - pageViewController: BKPageViewController
    ///   - viewController: UIViewController
    func pageViewController(_ pageViewController: BKPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    
    /// The number of items reflected in the page indicator.
    /// - Parameter pageViewController: BKPageViewController
    func presentationCount(for pageViewController: BKPageViewController) -> Int
    
    /// The selected item reflected in the page indicator.
    /// - Parameter pageViewController: BKPageViewController
    func presentationIndex(for pageViewController: BKPageViewController) -> Int
}

extension BKPageViewControllerDataSource {
    internal func presentationCount(for pageViewController: BKPageViewController) -> Int { 0 }
    internal func presentationIndex(for pageViewController: BKPageViewController) -> Int { 0 }
}

// MARK: - BKPageViewController
class BKPageViewController: UIViewController {
    typealias TransitionStyle = UIPageViewController.TransitionStyle
    typealias NavigationOrientation = UIPageViewController.NavigationOrientation
    typealias SpineLocation = UIPageViewController.SpineLocation
    typealias OptionsKey = UIPageViewController.OptionsKey
    typealias NavigationDirection = UIPageViewController.NavigationDirection

 
    
    // MARK: - 公开属性
    
    /// BKPageViewControllerDelegate
    internal weak var delegate: BKPageViewControllerDelegate? = nil
    /// BKPageViewControllerDataSource
    internal weak var dataSource: BKPageViewControllerDataSource? = nil
    /// TransitionStyle
    internal var transitionStyle: TransitionStyle { pageViewController.transitionStyle }
    /// NavigationOrientation
    internal var navigationOrientation: NavigationOrientation { pageViewController.navigationOrientation }
    /// BKPageViewController.SpineLocation
    internal var spineLocation: BKPageViewController.SpineLocation { pageViewController.spineLocation }
    /// Whether client content appears on both sides of each page. If 'NO', content on page front will partially show through back
    internal var isDoubleSided: Bool {
        get { pageViewController.isDoubleSided }
        set { pageViewController.isDoubleSided = newValue }
    }
    /// [UIGestureRecognizer]
    internal var gestureRecognizers: [UIGestureRecognizer] { pageViewController.gestureRecognizers }
    /// [UIViewController]
    internal var viewControllers: [UIViewController]? { pageViewController.viewControllers }

    // MARK: - 私有属性
    
    /// UIPageViewController
    private var pageViewController: UIPageViewController
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameters:
    ///   - transitionStyle: TransitionStyle
    ///   - navigationOrientation: NavigationOrientation
    ///   - options: [OptionsKey: Any]
    internal init(transitionStyle: TransitionStyle, navigationOrientation: NavigationOrientation = .horizontal, options: [OptionsKey: Any]? = nil) {
        pageViewController = .init(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation, options: options)
        super.init(nibName: nil, bundle: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
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
}

extension BKPageViewController {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        view.backgroundColor = .lightGray
        addChild(pageViewController)
        
        // 布局
        pageViewController.view.frame = view.bounds
        view.addSubview(pageViewController.view)
    }
    
    /// setViewControllers
    /// - Parameters:
    ///   - viewControllers: [UIViewController]
    ///   - direction: NavigationDirection
    ///   - animated: Bool
    ///   - completion: ((Bool) -> Void)? = nil
    internal func setViewControllers(_ viewControllers: [UIViewController]?, direction: NavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        pageViewController.setViewControllers(viewControllers, direction: direction, animated: animated, completion: completion)
    }
    
    ///  change style
    /// - Parameters:
    ///   - transitionStyle: TransitionStyle
    ///   - navigationOrientation: NavigationOrientation
    ///   - options: [OptionsKey: Any]
    internal func change(transitionStyle: TransitionStyle, navigationOrientation: NavigationOrientation = .horizontal, options: [OptionsKey: Any]? = nil) {
        let before = pageViewController
        pageViewController = .init(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation, options: options)
        pageViewController.setViewControllers(before.viewControllers, direction: .forward, animated: false, completion: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.frame = view.bounds
        view.insertSubview(pageViewController.view, belowSubview: before.view)
        UIView.transition(from: before.view, to: pageViewController.view, duration: 0.25, options: .showHideTransitionViews) { (_) in
            before.view.removeFromSuperview()
            before.removeFromParent()
        }
    }
}

// MARK: - IPageViewControllerDelegate
extension BKPageViewController: UIPageViewControllerDelegate {
    
    /// willTransitionTo
    /// - Parameters:
    ///   - pageViewController: UIPageViewController
    ///   - pendingViewControllers: [UIViewController]
    internal func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        delegate?.pageViewController(self, willTransitionTo: pendingViewControllers)
    }
    
    /// didFinishAnimating
    /// - Parameters:
    ///   - pageViewController: UIPageViewController
    ///   - finished: Bool
    ///   - previousViewControllers: [UIViewController]
    ///   - completed: Bool
    internal func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        delegate?.pageViewController(self, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }
    
    /// spineLocationFor orientation
    /// - Parameters:
    ///   - pageViewController: UIPageViewController
    ///   - orientation: UIInterfaceOrientation
    /// - Returns: UIPageViewController.SpineLocation
    internal func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        return delegate?.pageViewController(self, spineLocationFor: orientation) ?? (pageViewController.transitionStyle == .pageCurl ? .min : .none)
    }
    
    /// pageViewControllerSupportedInterfaceOrientations
    /// - Parameter pageViewController: UIPageViewController
    /// - Returns: UIInterfaceOrientationMask
    internal func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
        return delegate?.pageViewControllerSupportedInterfaceOrientations(self) ?? .portrait
    }
    
    /// pageViewControllerPreferredInterfaceOrientationForPresentation
    /// - Parameter pageViewController: UIPageViewController
    /// - Returns: UIInterfaceOrientation
    internal func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
        return delegate?.pageViewControllerPreferredInterfaceOrientationForPresentation(self) ?? .portrait
    }
}

// MARK: - IPageViewControllerDataSource
extension BKPageViewController: UIPageViewControllerDataSource {
    
    /// viewControllerBefore
    /// - Parameters:
    ///   - pageViewController: UIPageViewController
    ///   - viewController: UIViewController
    /// - Returns: UIViewController
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return dataSource?.pageViewController(self, viewControllerBefore: viewController)
    }
    
    /// viewControllerAfter
    /// - Parameters:
    ///   - pageViewController: UIPageViewController
    ///   - viewController: UIViewController
    /// - Returns: UIViewController
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return dataSource?.pageViewController(self, viewControllerAfter: viewController)
    }
    
    /// The number of items reflected in the page indicator.
    /// - Parameter pageViewController: UIPageViewController
    /// - Returns: Int
    internal func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource?.presentationCount(for: self) ?? 0
    }
    
    /// The selected item reflected in the page indicator.
    /// - Parameter pageViewController: UIPageViewController
    /// - Returns: Int
    internal func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return dataSource?.presentationIndex(for: self) ?? 0
    }
}

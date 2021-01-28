//
//  BKContentViewController.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/23.
//

import UIKit

/// BKContentViewController
class BKContentViewController: UIViewController {
    
    // MARK: - 私有属性
    
    /// BKLabel
    private lazy var label: BKLabel =  {
        let _label = BKLabel.init()
        _label.numberOfLines = 0
        _label.backgroundColor = .clear
        _label.textAlignment = .justified
        _label.lineBreakMode = .byClipping
        return _label
    }()

    /// Page.Snapshot
    private let page: Page.Snapshot
    /// BKConfiguration
    private let configuration: BKConfiguration
    
    // MARK: - 生命周期
    
    /// 构建
    /// - Parameters:
    ///   - page: Page.Snapshot
    ///   - configuration: BKConfiguration
    internal init(with page: Page.Snapshot, configuration: BKConfiguration) {
        self.page = page
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
        self.additionalSafeAreaInsets = .init(top: 0.0, left: configuration.safeAreaInsets.left, bottom: 0.0, right: configuration.safeAreaInsets.right)
        label.attributedText = page.attributed(with: configuration.attributes)
        print(page.text)
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

// MARK: - 自定义
extension BKContentViewController {
    
    /// 初始化
    private func initialize() {
        // coding here ...
        view.backgroundColor = configuration.backgroundColor
        
        // 布局
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    /// add attributes
    /// - Parameters:
    ///   - attributes: [NSAttributedString.Key: Any]
    ///   - animated: Bool
    internal func add(attributes: [NSAttributedString.Key: Any], animated: Bool) {
        label.hub.add(attributes: attributes, animated: animated)
    }
}

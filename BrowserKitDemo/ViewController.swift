//
//  ViewController.swift
//  BrowserKitDemo
//
//  Created by tramp on 2021/1/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import BroswerKit

class ViewController: UIViewController {
    
    // MARK: - 私有属性
    
    /// DisposeBag
    private lazy var bag: DisposeBag = .init()
    
    /// TXT阅读器
    private lazy var txtButton: UIButton = {
        let _button = UIButton.init(type: .custom)
        _button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        _button.setTitle("TXT阅读器", for: .normal)
        _button.backgroundColor = .orange
        _button.layer.cornerRadius = 6.0
        _button.rx.tap.subscribe { [unowned self](_) in
            let fileUrl = URL.init(string: "https://www.baidu.com")!
            let controller = BKTextViewController.init(with: fileUrl)
            self.present(controller, animated: true, completion:  nil)
        }.disposed(by: bag)
        return _button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(txtButton)
        txtButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(120.0)
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalTo(40.0)
        }
    }

}


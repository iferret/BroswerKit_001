//
//  BKContentViewController.swift
//  BroswerKit
//
//  Created by tramp on 2021/1/23.
//

import UIKit

class BKContentViewController: UIViewController {
    
    
    internal init() {
        super.init(nibName: nil, bundle: nil)
        self.additionalSafeAreaInsets = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    }
    
    /// 构建
    /// - Parameter coder: NSCoder
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .random
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

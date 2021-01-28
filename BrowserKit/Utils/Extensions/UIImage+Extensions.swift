//
//  UIImage+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/27.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 构建
    /// - Parameters:
    ///   - name: name of image
    ///   - bundle: Bundle
    internal convenience init?(named name: String, in bundle: Bundle?) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
    
    
    ///  通过颜色生成图片
    ///
    /// - Parameter color: UIColor
    /// - Returns: UIImage
    internal static func form(color: UIColor, opaque: Bool = false, size: CGSize = .init(width: 10.0, height: 10.0)) -> UIImage {
        let rect = CGRect.init(origin: CGPoint.zero, size: size)
        // 开启上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, UIScreen.main.scale)
        // 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIImage.init()
        }
        // 绘制
        context.setFillColor(color.cgColor)
        context.fill(rect)
        // 从上下文中获取图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage.init()
        // 关闭上下文
        UIGraphicsEndImageContext()
        // 返回
        return newImage.stretchableImage(withLeftCapWidth: Int(rect.size.width * 0.5), topCapHeight: Int(rect.size.height * 0.5))
    }
}

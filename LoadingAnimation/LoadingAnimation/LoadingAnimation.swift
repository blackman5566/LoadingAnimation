//
//  LoadingAnimation.swift
//  LoadingAnimation
//
//  Created by 許佳豪 on 2018/12/3.
//  Copyright © 2018 許佳豪. All rights reserved.
//

import Foundation
import UIKit

var ViewCover: UInt8 = 0

extension UIView {
    
    func startCovering() {
        self.setCoverView()
        self.backgroundColor = UIColor.white
        for subview in self.subviews {
        
            // 得到每個 subView 的 貝茲曲線
            var defaultCoverblePath = UIBezierPath(roundedRect: subview.bounds, cornerRadius: subview.frame.size.height/2.0)
            
            // 如果是 UILabel 或 UITextView，就設定圓角為4
            if subview is UILabel || subview is UITextView {
                defaultCoverblePath = UIBezierPath(roundedRect: subview.bounds, cornerRadius: 4)
            }
            
            let relativePath:UIBezierPath = defaultCoverblePath;
            let offsetPoint:CGPoint = subview.convert(subview.bounds, to: self).origin
            relativePath.apply(CGAffineTransform(translationX: offsetPoint.x, y: offsetPoint.y))

            let totalCoverablePath = UIBezierPath()
            totalCoverablePath.append(relativePath)
            
            self.coverView()!.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.addSubview(self.coverView()!)

            // 顏色的遮罩
            let colorLayer = CAGradientLayer()
            colorLayer.frame = self.bounds
            colorLayer.startPoint = CGPoint.init(x: -1.4, y: 0)
            colorLayer.endPoint = CGPoint.init(x: 1.4, y: 0)
            colorLayer.colors = [UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor,UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor,UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.15).cgColor,UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1),UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor]
            
            colorLayer.locations = [NSNumber.init(value: Float(colorLayer.startPoint.x)),NSNumber.init(value: Float(colorLayer.startPoint.x)),NSNumber.init(value: 0),NSNumber.init(value: 0.2),NSNumber.init(value: 1.2)]
            self.coverView()?.layer.addSublayer(colorLayer)

            // 新增遮罩
            let maskLayer = CAShapeLayer()
            maskLayer.path = totalCoverablePath.cgPath
            maskLayer.fillColor = UIColor.white.cgColor
            colorLayer.mask = maskLayer;
            
            // 新增動畫效果
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = colorLayer.locations;
            animation.toValue = [NSNumber.init(value: 0),NSNumber.init(value: 1),NSNumber.init(value: 1),NSNumber.init(value: 1.2),NSNumber.init(value: 1.2)]
            animation.duration = 0.7
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false
            colorLayer.add(animation, forKey: "locations-layer")
        }

    }
    
    // 停止動畫效果
    func stopCovering() {
        for subview in self.subviews {
            if (subview.tag == 2048) {
                subview.removeFromSuperview()
                break;
            }
        }
    }
    
    //MARK: runtime objects
    func setCoverView(){
        let viewCover:UIView = UIView()
        viewCover.tag = 2048
        viewCover.backgroundColor = UIColor.white
        objc_setAssociatedObject(self, &ViewCover, viewCover, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func coverView() -> UIView?{
        return objc_getAssociatedObject(self, &ViewCover) as? UIView
    }
}

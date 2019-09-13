//
//  UIColor+Extension.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2019/03/27.
//  Copyright © 2019 張帥. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hex hexString: String?) {
        var cleanString = hexString?.replacingOccurrences(of: "#", with: "")
        if (cleanString?.count ?? 0) == 3 {
            cleanString = "\((cleanString as NSString?)?.substring(with: NSRange(location: 0, length: 1)) ?? "")\((cleanString as NSString?)?.substring(with: NSRange(location: 0, length: 1)) ?? "")\((cleanString as NSString?)?.substring(with: NSRange(location: 1, length: 1)) ?? "")\((cleanString as NSString?)?.substring(with: NSRange(location: 1, length: 1)) ?? "")\((cleanString as NSString?)?.substring(with: NSRange(location: 2, length: 1)) ?? "")\((cleanString as NSString?)?.substring(with: NSRange(location: 2, length: 1)) ?? "")"
        }
        if (cleanString?.count ?? 0) == 6 {
            cleanString = "ff" + (cleanString ?? "")
        }
        
        var baseValue: UInt32 = 0
        (Scanner(string: cleanString ?? "")).scanHexInt32(&baseValue)
        
        let alpha: CGFloat = CGFloat(((baseValue >> 24) & 0xff)) / 255.0
        let red: CGFloat = CGFloat(((baseValue >> 16) & 0xff)) / 255.0
        let green: CGFloat = CGFloat(((baseValue >> 8) & 0xff)) / 255.0
        let blue: CGFloat = CGFloat(((baseValue >> 0) & 0xff)) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func random() -> UIColor? {
        let red: CGFloat = (CGFloat(arc4random() % 255) + 0.5) / 255.0
        let green: CGFloat = (CGFloat(arc4random() % 255) + 0.5) / 255.0
        let blue: CGFloat = (CGFloat(arc4random() % 255) + 0.5) / 255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return color
    }
}

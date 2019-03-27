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
    convenience init(rgb: Int64) {
        self.init(red: CGFloat((rgb & 0x00FF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x0000FF00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x000000FF) / 255.0,
                  alpha: 1.0)
    }
    
    class var mainColor: UIColor {
       return UIColor(rgb: MAIN_COLOR)
    }
}

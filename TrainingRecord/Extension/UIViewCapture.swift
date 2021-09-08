//
//  UIView.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/9/8.
//

import Foundation
import UIKit
extension UIView {

    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)

        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

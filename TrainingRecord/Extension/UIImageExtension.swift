//
//  UIImageExtension.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/30.
//

import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

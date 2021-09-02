//
//  String.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/22.
//

import Foundation
extension String {
    // 是否含有注音
    func isContainsPhoneticCharacters() -> Bool {
        for scalar in self.unicodeScalars {
            if (scalar.value >= 12549 && scalar.value <= 12582) || (scalar.value == 12584 || scalar.value == 12585 || scalar.value == 19968) {
                return true
            }
        }
        return false
    }
    
    // 是否含有中文字元
    func isContainsChineseCharacters() -> Bool {
        for scalar in self.unicodeScalars {
            if scalar.value >= 19968 && scalar.value <= 171941 {
                return true
            }
        }
        return false
    }
    
    // 是否含有空白字元
    func isContainsSpaceCharacters() -> Bool {
        for scalar in self.unicodeScalars {
            if scalar.value == 32 {
                return true
            }
        }
        return false
    }
    
    // if this number only
    func isNumberOnly() -> Bool {
        for scalar in self.unicodeScalars {
            if scalar.value >= 30 && scalar.value <= 39 {
                return true
            }
        }
        return false
    }
 
}

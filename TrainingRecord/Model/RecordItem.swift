//
//  RecordItem.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/6/28.
//

import Foundation
import Firebase

class RecordItem :NSObject ,NSCoding {
    var trainDate : String
//    var trainDateYesterday: Stringlkl
    var trainTimes : [Int]
    var trainLocation: [[Int]]
    init(_ traindate: String,/* _ traindateyesterday: String,*/ _ traintimes: [Int], _ trainlocation: [[Int]]){
        trainDate = traindate
        trainTimes = traintimes
        trainLocation = trainlocation
//        trainDateYesterday = traindateyesterday
    }
    //Note物件寫到檔案：Dictionary
    func encode(with coder: NSCoder) {
        coder.encode(self.trainTimes, forKey: "trainTimes")
        coder.encode(self.trainLocation, forKey: "trainLocation")
        coder.encode(self.trainDate, forKey: "trainDate")
//        coder.encode(self.trainDateYesterday, forKey: "trainDateYesterday")
    }
    //檔案->Note物件
    required init?(coder: NSCoder) {
        self.trainTimes =  coder.decodeObject(forKey: "trainTimes") as! [Int]
        self.trainLocation = coder.decodeObject(forKey: "trainLocation") as! [[Int]]
        self.trainDate = coder.decodeObject(forKey: "trainDate") as! String
//        self.trainDateYesterday = coder.decodeObject(forKey: "trainDateYesterday") as! String
    }
    
    
}

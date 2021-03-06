//
//  RecordItem.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/6/28.
//

import Foundation
import Firebase
import CoreData
enum rate: String {
    case Good = "Good"
    case Normal = "Normal"
    case Bad = "Bad"
    case none = "none"
}


class RecordItem:NSObject ,NSCoding {
    var trainDate : String
//    var trainDateYesterday: Stringlkl
    var trainSet : [[Int]:Int]
    var trainTimes : [[Int]:[Int]]
    var trainWeight : [[Int]:[Float]]
    var trainLocation: [[Int]:[Int]]
    var trainUnit: [[Int]:[String]]
    var trainLocationSort: [[Int]]
    var trainRate: [String]
    init(_ traindate: String,/* _ traindateyesterday: String,*/_ trainset: [[Int]: Int], _ traintimes: [[Int]:[Int]], _ trainlocationsort: [[Int]],_ trainweight: [[Int]:[Float]], _ trainlocation: [[Int]:[Int]], _ trainunit: [[Int]:[String]],_ trainrate: [String]){
        trainDate = traindate
        trainTimes = traintimes
        trainLocation = trainlocation
        trainSet = trainset
        trainWeight = trainweight
        trainLocationSort = trainlocationsort
        trainUnit = trainunit
        trainRate = trainrate
//        trainDateYesterday = traindateyesterday
    }
    //Note物件寫到檔案：Dictionary
    func encode(with coder: NSCoder) {
        coder.encode(self.trainTimes, forKey: "trainTimes")
        coder.encode(self.trainLocation, forKey: "trainLocation")
        coder.encode(self.trainDate, forKey: "trainDate")
        coder.encode(self.trainSet, forKey: "trainSet")
        coder.encode(self.trainWeight, forKey: "trainWeight")
        coder.encode(self.trainLocationSort, forKey: "trainLocationSort")
        coder.encode(self.trainUnit, forKey: "trainUnit")
        coder.encode(self.trainRate, forKey: "trainRate")
//        coder.encode(self.trainDateYesterday, forKey: "trainDateYesterday")
    }
    //檔案->Note物件
    required init?(coder: NSCoder) {
        self.trainTimes =  coder.decodeObject(forKey: "trainTimes") as! [[Int]:[Int]]
        self.trainLocation = coder.decodeObject(forKey: "trainLocation") as! [[Int]:[Int]]
        self.trainDate = coder.decodeObject(forKey: "trainDate") as! String
        self.trainSet = coder.decodeObject(forKey: "trainSet") as! [[Int]: Int]
        self.trainWeight =  coder.decodeObject(forKey: "trainWeight") as! [[Int]:[Float]]
        self.trainLocationSort = coder.decodeObject(forKey: "trainLocationSort") as! [[Int]]
        self.trainUnit =  coder.decodeObject(forKey: "trainUnit") as! [[Int]:[String]]
        self.trainRate = coder.decodeObject(forKey: "trainRate") as! [String]
//        self.trainDateYesterday = coder.decodeObject(forKey: "trainDateYesterday") as! String
    }
    
    
}

//class RecordItemC:NSManagedObject {
//   @NSManaged var trainDate : String?
//   @NSManaged var trainSet : String?
//    @NSManaged var trainTimes : String?
//   @NSManaged var trainWeight : String?
//   @NSManaged var trainLocation: String?
//   @NSManaged var trainUnit: String?
//   @NSManaged var trainRate: String?
//    @NSManaged var trainID: String
//    
//    override func awakeFromInsert() {
//        self.trainID = UUID().uuidString
//    }
//    
//}

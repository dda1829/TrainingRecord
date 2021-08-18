//
//  TrainingItem.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/5/29.
//
import Firebase
import Foundation
class TrainingItemForFireStore {
    var itemName: String?
    var itemDef: String?
    var itemImage: String?
    var itemID: String
    var itemNumber: String?
    init() {
        itemID = UUID().uuidString
    }
}

class TrainingItem:NSObject ,NSCoding  {
    var itemLocation: Int
    var itemName: String
    var itemDef: String
    var itemImage: String
    var itemID: String
    var itemNumber: Int
    init(_ id: String, _ location: Int,_ name: String,_ def: String,_ number: Int,_ image: String ) {
        itemID = id
        itemLocation = location
        itemName = name
        itemDef = def
        itemNumber = number
        itemImage = image
    }
    //Note物件寫到檔案：Dictionary
    func encode(with coder: NSCoder) {
        coder.encode(self.itemID, forKey: "itemID")
        coder.encode(self.itemLocation, forKey: "itemLocation")
        coder.encode(self.itemName, forKey: "itemName")
        coder.encode(self.itemDef, forKey: "itemDef")
        coder.encode(self.itemNumber, forKey: "itemNumber")
        coder.encode(self.itemImage, forKey: "itemImage")

    }
    //檔案->Note物件
    required init?(coder: NSCoder) {
        self.itemID =  coder.decodeObject(forKey: "itemID") as! String
        self.itemLocation = coder.decodeObject(forKey: "itemLocation") as! Int
        self.itemName = coder.decodeObject(forKey: "itemName") as! String
        self.itemDef = coder.decodeObject(forKey: "itemDef") as! String
        self.itemNumber = coder.decodeObject(forKey: "itemNumber") as! Int
        self.itemImage = coder.decodeObject(forKey: "itemImage") as! String
    }
}






class InfoItemForFireStore {
    var ItemUserName: String?
    var ItemEmail : String?
    var abdomenLast: String?
    var armLast: String?
    var backLast: String?
    var bottomLapLast: String?
    var brestShoulderLast: String?
    var exerciseLast: String?
    var ItemID: String
    var ItemTitle: String?
    var ItemContent: String?
    init(){
        ItemID = UUID().uuidString
    }
}

class userData{
    var userID: String?
    var userGoal: String?
    var userTrainingLog: String?
    var userBodyFat: String?
    var userBMI: String?
    init(){
        
    }
}

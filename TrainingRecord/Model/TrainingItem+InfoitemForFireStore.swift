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
    var haveNewItem: Bool?
    init(){
        ItemID = UUID().uuidString
    }
    func toSystem() {
        
    }
}


//
//  UserNotificationWithCalendarTrigger.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/9/11.
//

import Foundation
import UserNotifications

class UserNotificationWithCalendarTriggerUse{
    static var share = UserNotificationWithCalendarTriggerUse()
    private var content = UNMutableNotificationContent()
    private var trigger: Any?
    private var reminderDatas: [String:ReminderItem] = [:]
    private var reminderData: ReminderItem?
    private var index = 0
    init (){
        loadFromFile()
        if reminderDatas.count != 0{
            index = reminderDatas.count
        }
    }
    func setNotificationContent(Title title:String, Body body:String, Sound sound: UNNotificationSound?){
        content.title = title
        content.body = body
        content.sound = sound
    }
    func setCalendarTrigger(Datecomponents datecomponents: DateComponents, isRepeated isrepeated: Bool){
        trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: isrepeated)
    }
    func sendNotificationRequest(Identifier identifier:String){
        let notificationRequest = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger as? UNCalendarNotificationTrigger)
        UNUserNotificationCenter.current().add(notificationRequest) { error in
            if let e = error {
                print( "error \(e)")
                return
            }
        }
        reminderData = ReminderItem((trigger as? UNCalendarNotificationTrigger)!, true, content,identifier,index)
        reminderDatas.updateValue(reminderData!, forKey: identifier)
        writeToFile()
    }
    func dismissNotificationRequest(Identifier identifier:String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        reminderData = reminderDatas[identifier]
        reminderData!.isReminderON = false
        reminderDatas.updateValue(reminderData!, forKey: identifier)
        writeToFile()
        
    }
    func checkNotification(Identifier idetifier:String) -> Bool{
        if reminderDatas[idetifier] != nil {
            return true
        }
        return false
    }
    func checkNotificationData(Identifier identifier:String) -> Bool{
        if let reminderdata = reminderDatas[identifier], reminderdata.isReminderON{
                return true
        }
            return false
    }
    func setNotificationFromDatas(Identifier identifier:String){
        if let reminderdata = reminderDatas[identifier]{
            reminderData = reminderdata
            reminderData!.isReminderON = true
            let notificationRequest = UNNotificationRequest(identifier: identifier, content: reminderdata.reminderContent, trigger: reminderdata.dateTrigger )
            UNUserNotificationCenter.current().add(notificationRequest) { error in
                if let e = error {
                    print( "error \(e)")
                    return
                }
            }
            reminderDatas.updateValue(reminderData!, forKey: identifier)
        }
        writeToFile()
        
    }
    //MARK: Archiving
    func writeToFile()  {
        //
        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
        let filePath = doc.appendingPathComponent("NotificationDatas.archive")
    
        do {
            //將data陣列，轉成Data型式（二進位資料）
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.reminderDatas, requiringSecureCoding: false)
            try data.write(to: filePath, options: .atomic)
        } catch  {
            print("error while saving to file \(error)")
        }
    }
    
    func loadFromFile()  {
        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
        let filePath = doc.appendingPathComponent("NotificationDatas.archive")
        
        do {
            //載入成Data（二進位資料)
            let data =  try Data(contentsOf: filePath)
            //把資料轉成[Note]
            if let arrayData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String:ReminderItem]{
                self.reminderDatas = arrayData//轉成功就放到self.data裏
            }else{
                print("wrong")
            }
        } catch  {
            print("error while fetching data array \(error)")
            self.reminderDatas = [:]//有任何錯誤,空陣列
        }
    }
}
class ReminderItem: NSObject ,NSCoding{
    func encode(with coder: NSCoder) {
        coder.encode(dateTrigger,forKey: "dateTrigger")
        coder.encode(isReminderON,forKey: "isReminderON")
        coder.encode(reminderContent,forKey: "reminderContent")
        coder.encode(identifyTitle,forKey: "identifyTitle")
        coder.encode(index,forKey: "index")
    }
    
    required init?(coder: NSCoder) {
        dateTrigger = coder.decodeObject(forKey: "dateTrigger") as! UNCalendarNotificationTrigger
        isReminderON = coder.decodeBool(forKey: "isReminderON")
        reminderContent = coder.decodeObject(forKey: "reminderContent") as! UNMutableNotificationContent
        identifyTitle = coder.decodeObject(forKey: "identifyTitle") as! String
        index = coder.decodeInteger(forKey: "index")
    }
    
    var dateTrigger: UNCalendarNotificationTrigger
    var isReminderON: Bool
    var reminderContent: UNMutableNotificationContent
    var identifyTitle: String
    var index: Int
    init(_ datetrigger: UNCalendarNotificationTrigger, _ isreminderon: Bool, _ remindercontent: UNMutableNotificationContent, _ identifytitle: String,_ indexk:Int) {
        dateTrigger = datetrigger
        isReminderON = isreminderon
        reminderContent = remindercontent
        identifyTitle = identifytitle
        index = indexk
    }
}

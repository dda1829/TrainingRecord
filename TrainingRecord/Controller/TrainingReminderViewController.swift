//
//  TrainingRemainViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/9/10.
//

import UIKit
import UserNotifications
class TrainingReminderViewController: UIViewController {
    let unContent = UNMutableNotificationContent()
    var unDateComponents = DateComponents()
    var replaceString = ""
    var notificationDatas:[String:ReminderItem]?
    var weekdayNotification: ReminderItem?
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var weekSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reminderTitleTF: UITextField!
    @IBOutlet weak var determineDatePicker: UIDatePicker!
    @IBOutlet weak var sundayReminderBtn: UIButton!
    @IBOutlet weak var mondayReminderBtn: UIButton!
    @IBOutlet weak var tuesdayReminderBtn: UIButton!
    @IBOutlet weak var wednesdayReminderBtn: UIButton!
    @IBOutlet weak var thursdayReminderBtn: UIButton!
    @IBOutlet weak var fridayReminderBtn: UIButton!
    @IBOutlet weak var satuardayReminderBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if weekSegmentedControl.selectedSegmentIndex == 0 {
            reminderTitleTF.text = "星期日的運動提醒"
            replaceString = "星期日的運動提醒"
            if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: replaceString) {
                reminderSwitch.isOn = true
            }
        }
       let checklist: [String] = ["星期日的運動提醒","星期一的運動提醒","星期二的運動提醒","星期三的運動提醒","星期四的運動提醒","星期五的運動提醒","星期六的運動提醒"]
        let btns: [String:UIButton] = ["星期日的運動提醒":sundayReminderBtn,"星期一的運動提醒":mondayReminderBtn,"星期二的運動提醒":tuesdayReminderBtn,"星期三的運動提醒":wednesdayReminderBtn,"星期四的運動提醒":thursdayReminderBtn,"星期五的運動提醒":fridayReminderBtn,"星期六的運動提醒":satuardayReminderBtn]
        for x in checklist {
            if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: x) {
                btns[x]?.backgroundColor = .green
            }else{
                btns[x]?.backgroundColor = .systemGray2
            }
        }
    }
    
   
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        guard reminderTitleTF.text != "" else {
            let alert = UIAlertController(title: "注意", message: "請寫訓練提醒的內容，感謝！", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(okaction)
            present(alert, animated: true, completion: nil)
            return
        }
        if sender.isOn{
            unDateComponents = Calendar.current.dateComponents([.hour,.minute], from: determineDatePicker.date)
            unDateComponents.weekday = weekSegmentedControl.selectedSegmentIndex + 1
            UserNotificationWithCalendarTriggerUse.share.setNotificationContent(Title: reminderTitleTF.text ?? replaceString, Body: "該訓練了！！", Sound: UNNotificationSound(named: UNNotificationSoundName(rawValue: "Radar.mp3")))
            UserNotificationWithCalendarTriggerUse.share.setCalendarTrigger(Datecomponents: unDateComponents, isRepeated: true)
            UserNotificationWithCalendarTriggerUse.share.sendNotificationRequest(Identifier: replaceString)
            switch replaceString {
            case "星期日的運動提醒":
                sundayReminderBtn.backgroundColor = .green
            case "星期一的運動提醒":
                mondayReminderBtn.backgroundColor = .green
            case "星期二的運動提醒":
                tuesdayReminderBtn.backgroundColor = .green
            case "星期三的運動提醒":
                wednesdayReminderBtn.backgroundColor = .green
            case "星期四的運動提醒":
                thursdayReminderBtn.backgroundColor = .green
            case "星期五的運動提醒":
                fridayReminderBtn.backgroundColor = .green
            case "星期六的運動提醒":
                satuardayReminderBtn.backgroundColor = .green
            default:
                print("error")
            }
        }else{
            
            UserNotificationWithCalendarTriggerUse.share.dismissNotificationRequest(Identifier: replaceString)
            switch replaceString {
            case "星期日的運動提醒":
                sundayReminderBtn.backgroundColor = .systemGray2
            case "星期一的運動提醒":
                mondayReminderBtn.backgroundColor = .systemGray2
            case "星期二的運動提醒":
                tuesdayReminderBtn.backgroundColor = .systemGray2
            case "星期三的運動提醒":
                wednesdayReminderBtn.backgroundColor = .systemGray2
            case "星期四的運動提醒":
                thursdayReminderBtn.backgroundColor = .systemGray2
            case "星期五的運動提醒":
                fridayReminderBtn.backgroundColor = .systemGray2
            case "星期六的運動提醒":
                satuardayReminderBtn.backgroundColor = .systemGray2
            default:
                print("error")
            }
        }
    }
    @IBAction func weekSegmentedControlPressed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("sun")
            reminderTitleTF.text = "星期日的運動提醒"
            replaceString = "星期日的運動提醒"
            if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: replaceString){
                reminderSwitch.isOn = true
            }else{
                reminderSwitch.isOn = false
            }
        case 1:
            print("Mon")
            reminderTitleTF.text = "星期一的運動提醒"
            replaceString = "星期一的運動提醒"
            if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: replaceString){
                reminderSwitch.isOn = true
            }else{
                reminderSwitch.isOn = false
            }
        case 2:
            print("Tue")
            reminderTitleTF.text = "星期二的運動提醒"
            replaceString = "星期二的運動提醒"
            if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: replaceString){
                reminderSwitch.isOn = true
            }else{
                reminderSwitch.isOn = false
            }
        case 3:
            print("Wed")
            reminderTitleTF.text = "星期三的運動提醒"
            replaceString = "星期三的運動提醒"
            if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: replaceString){
                reminderSwitch.isOn = true
            }else{
                reminderSwitch.isOn = false
            }
        case 4 :
            print("Thu")
            reminderTitleTF.text = "星期四的運動提醒"
            replaceString = "星期四的運動提醒"
            if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: replaceString){
                reminderSwitch.isOn = true
            }else{
                reminderSwitch.isOn = false
            }
        case 5:
            print("Fri")
            reminderTitleTF.text = "星期五的運動提醒"
            replaceString = "星期五的運動提醒"
            if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: replaceString){
                reminderSwitch.isOn = true
            }else{
                reminderSwitch.isOn = false
            }
        case 6:
            print("Sat")
            reminderTitleTF.text = "星期六的運動提醒"
            replaceString = "星期六的運動提醒"
            if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: replaceString){
                reminderSwitch.isOn = true
            }else{
                reminderSwitch.isOn = false
            }
        default:
            print("error")
        }
    }
   
    @IBAction func sataurdayReminderPressed(_ sender: Any) {
        guard UserNotificationWithCalendarTriggerUse.share.checkNotification(Identifier: "星期六的運動提醒") else {
            let alert = UIAlertController(title: "注意", message: "請先設定過這個在使用此按鈕，感謝！", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(okaction)
            present(alert, animated: true, completion: nil)
            return
        }
        if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: "星期六的運動提醒"){
            satuardayReminderBtn.backgroundColor = .systemGray2
            UserNotificationWithCalendarTriggerUse.share.dismissNotificationRequest(Identifier: "星期六的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 6{
                reminderSwitch.isOn = false
            }
        }else{
            satuardayReminderBtn.backgroundColor = .green
            UserNotificationWithCalendarTriggerUse.share.setNotificationFromDatas(Identifier: "星期六的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 6{
                reminderSwitch.isOn = true
            }
        }
    }
    @IBAction func fridayReminderPressed(_ sender: Any) {
        guard UserNotificationWithCalendarTriggerUse.share.checkNotification(Identifier: "星期五的運動提醒") else {
            let alert = UIAlertController(title: "注意", message: "請先設定過這個在使用此按鈕，感謝！", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(okaction)
            present(alert, animated: true, completion: nil)
            return
        }
        if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: "星期五的運動提醒"){
            fridayReminderBtn.backgroundColor = .systemGray2
            UserNotificationWithCalendarTriggerUse.share.dismissNotificationRequest(Identifier: "星期五的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 5{
                reminderSwitch.isOn = false
            }
        }else{
            fridayReminderBtn.backgroundColor = .green
            UserNotificationWithCalendarTriggerUse.share.setNotificationFromDatas(Identifier: "星期五的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 5{
                reminderSwitch.isOn = true
            }
        }
    }
    @IBAction func thursdayReminderPressed(_ sender: Any) {
        guard UserNotificationWithCalendarTriggerUse.share.checkNotification(Identifier: "星期四的運動提醒") else {
            let alert = UIAlertController(title: "注意", message: "請先設定過這個在使用此按鈕，感謝！", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(okaction)
            present(alert, animated: true, completion: nil)
            return
        }
        if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: "星期四的運動提醒"){
            thursdayReminderBtn.backgroundColor = .systemGray2
            UserNotificationWithCalendarTriggerUse.share.dismissNotificationRequest(Identifier: "星期四的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 4{
                reminderSwitch.isOn = false
            }
        }else{
            thursdayReminderBtn.backgroundColor = .green
            UserNotificationWithCalendarTriggerUse.share.setNotificationFromDatas(Identifier: "星期四的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 4{
                reminderSwitch.isOn = true
            }
        }
    }
    @IBAction func wednesdayReminderPressed(_ sender: Any) {
        guard UserNotificationWithCalendarTriggerUse.share.checkNotification(Identifier: "星期三的運動提醒") else {
            let alert = UIAlertController(title: "注意", message: "請先設定過這個在使用此按鈕，感謝！", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(okaction)
            present(alert, animated: true, completion: nil)
            return
        }
        if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: "星期三的運動提醒"){
            wednesdayReminderBtn.backgroundColor = .systemGray2
            UserNotificationWithCalendarTriggerUse.share.dismissNotificationRequest(Identifier: "星期三的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 3{
                reminderSwitch.isOn = false
            }
        }else{
            wednesdayReminderBtn.backgroundColor = .green
            UserNotificationWithCalendarTriggerUse.share.setNotificationFromDatas(Identifier: "星期三的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 3{
                reminderSwitch.isOn = true
            }
        }
    }
    @IBAction func tuesdayReminderPressed(_ sender: Any) {
        guard UserNotificationWithCalendarTriggerUse.share.checkNotification(Identifier: "星期二的運動提醒") else {
            let alert = UIAlertController(title: "注意", message: "請先設定過這個在使用此按鈕，感謝！", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(okaction)
            present(alert, animated: true, completion: nil)
            return
        }
        if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: "星期二的運動提醒"){
            tuesdayReminderBtn.backgroundColor = .systemGray2
            UserNotificationWithCalendarTriggerUse.share.dismissNotificationRequest(Identifier: "星期二的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 2{
                reminderSwitch.isOn = false
            }
        }else{
            tuesdayReminderBtn.backgroundColor = .green
            UserNotificationWithCalendarTriggerUse.share.setNotificationFromDatas(Identifier: "星期二的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 2{
                reminderSwitch.isOn = true
            }
        }
    }
    @IBAction func mondayReminderPressed(_ sender: Any) {
        guard UserNotificationWithCalendarTriggerUse.share.checkNotification(Identifier: "星期一的運動提醒") else {
            let alert = UIAlertController(title: "注意", message: "請先設定過這個在使用此按鈕，感謝！", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(okaction)
            present(alert, animated: true, completion: nil)
            return
        }
        if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: "星期一的運動提醒"){
            mondayReminderBtn.backgroundColor = .systemGray2
            UserNotificationWithCalendarTriggerUse.share.dismissNotificationRequest(Identifier: "星期一的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 1{
                reminderSwitch.isOn = false
            }
        }else{
            mondayReminderBtn.backgroundColor = .green
            UserNotificationWithCalendarTriggerUse.share.setNotificationFromDatas(Identifier: "星期一的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 1{
                reminderSwitch.isOn = true
            }
        }
    }
    @IBAction func sundayReminderPressed(_ sender: Any) {
        guard UserNotificationWithCalendarTriggerUse.share.checkNotification(Identifier: "星期日的運動提醒") else {
            let alert = UIAlertController(title: "注意", message: "請先設定過這個在使用此按鈕，感謝！", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(okaction)
            present(alert, animated: true, completion: nil)
            return
        }
        if UserNotificationWithCalendarTriggerUse.share.checkNotificationData(Identifier: "星期日的運動提醒"){
            sundayReminderBtn.backgroundColor = .systemGray2
            UserNotificationWithCalendarTriggerUse.share.dismissNotificationRequest(Identifier: "星期日的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 0{
                reminderSwitch.isOn = false
            }
        }else{
            sundayReminderBtn.backgroundColor = .green
            UserNotificationWithCalendarTriggerUse.share.setNotificationFromDatas(Identifier: "星期日的運動提醒")
            if weekSegmentedControl.selectedSegmentIndex == 0{
                reminderSwitch.isOn = true
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SystemTableViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/7/21.
//

import UIKit
import MessageUI
import Firebase
class SystemTableViewController: UITableViewController,MFMailComposeViewControllerDelegate {
    var userTextLabel = "精壯使用者"
    var trainingGoals: [String] = []
    var trainingGoal: String = ""
    var userPhoto: UIImage?
    var trainUnitSettoKg = true
    var trainUnit = "Kg"
    var memberFunctionForm : [String] = ["設定會員資料","編輯器材資訊","設定預備時間","運動提醒"]
    //    var trainListEditForm : [String] = ["新增訓練項目","刪除訓練項目","修改訓練項目位置"]
    var trainListEditForm : [String] = ["新增訓練項目","刪除訓練項目","調整運動項目位置"]
    var trainingParameters: [String] = ["重量單位","紀錄模式"]
    var editorFormList: [String] = ["評價此ＡＰＰ","聯繫作者"]
    var clearDatasFormList: [String] = ["備份資料至iCloud","從iCloud還原資料","清除今日訓練資料","清除所有訓練資料"]
    var db: Firestore?
    var memberDatas: [String:Any]?
    var prepareTime: Int = 3
    
    var isEditTrainItem = false
    var isModeSetToSimple = false
    
    var dateRecord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let a = UserDefaults.standard.string(forKey: "userName")  {
            userTextLabel = a + " 您好,點此加入會員！"
        }
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToSysBtn))
        trainUnitSettoKg = UserDefaults.standard.bool(forKey: "trainUnitSet")
        isModeSetToSimple = UserDefaults.standard.bool(forKey: "isModeSetToSimple")
        trainingGoals = ["體脂降低10％","肌肉重量增加\(trainUnitSettoKg ? "1 Kg" : "2.2 lb")","基礎代謝率增加200大卡"]
        if let user = Auth.auth().currentUser{
            print("\(user.uid) login")
            if let usergoal = MemberUserDataToFirestore.share.getUserdatas("userGoal"){
                if let goal = (usergoal as! [String]).last{
                    trainingGoal = goal
                    UserDefaults.standard.setValue(goal, forKey: "userGoal")
                    UserDefaults.standard.synchronize()
                }else{
                    trainingGoal = "請設定會員資料用以設定目標！"
                }
            }
            if UserDefaults.standard.integer(forKey: "prepareTime") != 0 {
                prepareTime = UserDefaults.standard.integer(forKey: "prepareTime")
            }
            userTextLabel = user.displayName ?? "精壯使用者"
            userPhoto = UIImage(systemName: "person.circle.fill")
            
            
        }else {
            print("not login")
            userPhoto = UIImage(systemName: "person.circle")
        }
        
        trainUnitSettoKg = UserDefaults.standard.bool(forKey: "trainUnitSet")
    }
    
    @objc func backToSysBtn (){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as? TrainRecordHomeVC
        self.navigationController?.pushViewController(vc!,animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if Auth.auth().currentUser != nil {
            return 5
        }else{
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return trainingParameters.count
        case 2:
            if Auth.auth().currentUser == nil {
                return editorFormList.count
            }else {
                if isEditTrainItem{
                    return memberFunctionForm.count + trainListEditForm.count
                }else{
                    return memberFunctionForm.count
                }
            }
        case 3:
            if Auth.auth().currentUser == nil{
                return clearDatasFormList.count
            }
            return editorFormList.count
        case 4:
            if Auth.auth().currentUser == nil{
                return 0
            }
            return clearDatasFormList.count
        default:
            return 0
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == 0 && indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
            cell.textLabel?.text = userTextLabel
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            if Auth.auth().currentUser == nil{
                cell.detailTextLabel?.text = "目標：\(trainingGoals.randomElement()!)"
            }else{
                cell.detailTextLabel?.text = "目標：\(trainingGoal)"
            }
            
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.showsReorderControl = true
            // resize the ImageView of the tableview cell
            cell.imageView?.image = userPhoto
            let itemSize = CGSize.init(width: 70, height: 70)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
            cell.imageView?.image?.draw(in: imageRect)
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            cell.imageView?.setImageColor(color: .systemBlue)
        }
        else if  indexPath.section == 1  {
            if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "Systemcell", for: indexPath)
            cell.textLabel?.text = trainingParameters[indexPath.row]
            cell.detailTextLabel?.text = trainUnitSettoKg ? "Kg" : "lb"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
            }else if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "Systemcell", for: indexPath)
                cell.textLabel?.text = trainingParameters[indexPath.row]
                cell.detailTextLabel?.text = isModeSetToSimple ?  "簡易模式" : "一般模式"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
            }
            
        }else if indexPath.section == 2 {
            if Auth.auth().currentUser == nil {
                cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                cell.textLabel?.text = editorFormList[indexPath.row]
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.textLabel?.textColor = .white
            }else{
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: "SystemMemberCell", for: indexPath)
                    cell.textLabel?.text = memberFunctionForm[indexPath.row]
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                    cell.textLabel?.textColor = .white
                    
                }
                if isEditTrainItem == false {
                    if indexPath.row == 1 {
                        cell = tableView.dequeueReusableCell(withIdentifier: "Systemcell", for: indexPath)
                        cell.textLabel?.text = memberFunctionForm[indexPath.row]
                        cell.detailTextLabel!.text = "▽"
                        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.detailTextLabel?.textColor = .systemGray
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.textLabel?.textColor = .white
                    }else if indexPath.row == 2 {
                        cell = tableView.dequeueReusableCell(withIdentifier: "Systemcell", for: indexPath)
                        cell.textLabel?.text = memberFunctionForm[indexPath.row]
                        cell.detailTextLabel?.text = "\(prepareTime)"
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.textLabel?.textColor = .white
                    }else if indexPath.row == 3{
                        cell = tableView.dequeueReusableCell(withIdentifier: "SystemMemberCell", for: indexPath)
                        cell.textLabel?.text = memberFunctionForm[indexPath.row]
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.backgroundColor = .black
                        cell.textLabel?.textColor = .white
                    }
                }else {
                    if indexPath.row == 1 {
                        cell = tableView.dequeueReusableCell(withIdentifier: "Systemcell", for: indexPath)
                        cell.textLabel?.text = memberFunctionForm[indexPath.row]
                        cell.detailTextLabel!.text = "△"
                        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.detailTextLabel?.textColor = .systemGray
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.textLabel?.textColor = .white
                    }else if indexPath.row == 2{
                        cell = tableView.dequeueReusableCell(withIdentifier: "SystemMemberCell", for: indexPath)
                        cell.textLabel?.text = "    -" + trainListEditForm[indexPath.row - 2]
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.textLabel?.textColor = .white
                        cell.backgroundColor = .darkGray
                    }else if indexPath.row == 3{
                        cell = tableView.dequeueReusableCell(withIdentifier: "SystemMemberCell", for: indexPath)
                        cell.textLabel?.text = "    -" + trainListEditForm[indexPath.row - 2]
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.textLabel?.textColor = .white
                        cell.backgroundColor = .darkGray
                    }else if indexPath.row == 4 {
                        cell = tableView.dequeueReusableCell(withIdentifier: "SystemMemberCell", for: indexPath)
                        cell.textLabel?.text = "    -" + trainListEditForm[indexPath.row - 2]
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.textLabel?.textColor = .white
                        cell.backgroundColor = .darkGray
                    }else if indexPath.row == 5 {
                        cell = tableView.dequeueReusableCell(withIdentifier: "Systemcell", for: indexPath)
                        cell.textLabel?.text = memberFunctionForm[indexPath.row - 3]
                        cell.detailTextLabel?.text = "\(prepareTime)"
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.textLabel?.textColor = .white
                    }else if indexPath.row == 6{
                        cell = tableView.dequeueReusableCell(withIdentifier: "SystemMemberCell", for: indexPath)
                        cell.textLabel?.text = memberFunctionForm[indexPath.row - 3]
                        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                        cell.textLabel?.textColor = .white
                    }
                }
            }
        }else   if indexPath.section == 3 {
            if Auth.auth().currentUser == nil {
                if indexPath.row == 0{
                    cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                    cell.textLabel?.text = clearDatasFormList[indexPath.row]
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                    cell.textLabel?.textColor = .white
                }else if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                cell.textLabel?.text = clearDatasFormList[indexPath.row]
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.textLabel?.textColor = .white
                }else if indexPath.row == 2{
                    cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                    cell.textLabel?.text = clearDatasFormList[indexPath.row]
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                    cell.textLabel?.textColor = .red
                }else if indexPath.row == 3{
                    cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                    cell.textLabel?.text = clearDatasFormList[indexPath.row]
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                    cell.textLabel?.textColor = .red
                }
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                cell.textLabel?.text = editorFormList[indexPath.row]
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.textLabel?.textColor = .white
            }
        }else if indexPath.section == 4 {
            if Auth.auth().currentUser == nil {
            }else{
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                    cell.textLabel?.text = clearDatasFormList[indexPath.row]
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                    cell.textLabel?.textColor = .white
                }else if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                cell.textLabel?.text = clearDatasFormList[indexPath.row]
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.textLabel?.textColor = .white
                }else if indexPath.row == 2{
                    cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                    cell.textLabel?.text = clearDatasFormList[indexPath.row]
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                    cell.textLabel?.textColor = .red
                }else if indexPath.row == 3{
                    cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                    cell.textLabel?.text = clearDatasFormList[indexPath.row]
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                    cell.textLabel?.textColor = .red
                }
            }
        }
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            if let user = Auth.auth().currentUser {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoggedIn") as? MemberAlreadyLoginViewController{
                    vc.userName = user.displayName
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if !UserDefaults.standard.bool(forKey: "isMember"){
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpPage") as? MemberSignUpViewController{
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemberLoginPage") as? MemberLoginViewController{
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0{
            trainUnitSettoKg = !trainUnitSettoKg
            UserDefaults.standard.set(trainUnitSettoKg, forKey: "trainUnitSet")
            UserDefaults.standard.synchronize()
            trainUnit = trainUnitSettoKg ? "Kg" : "lb"
            UserDefaults.standard.set(trainUnit, forKey: "trainUnit")
            UserDefaults.standard.synchronize()
            }else if indexPath.row == 1{
                isModeSetToSimple = !isModeSetToSimple
                UserDefaults.standard.set(isModeSetToSimple,forKey: "isModeSetToSimple")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: Notification.Name("isModeSetToSimple"), object: nil)
            }
        }else if indexPath.section == 2{
            if Auth.auth().currentUser == nil {
                if indexPath.row == 0 {
                    let askController = UIAlertController(title: "Hello, APP User", message: "If you prefer this APP, please rate for 5 stars in APP store. Special thanks.", preferredStyle: .alert)
                    let laterAction = UIAlertAction(title: "稍後再評", style: .default, handler: nil)
                    let okAction = UIAlertAction(title: "我要評分", style: .default){
                        (action) -> Void in
                        let appID = "1581099175"
                        let appURL = URL(string: "https://itunes.apple.com/us/app/itunes-u/id\(appID)?action=write-review")!
                        UIApplication.shared.open(appURL, options: [:]) { (success) in
                            //
                        }
                    }
                    askController.addAction(laterAction)
                    askController.addAction(okAction)
                    self.present(askController,animated: true, completion: nil)
                }else if indexPath.row == 1{
                    if (MFMailComposeViewController.canSendMail()){
                        let alert = UIAlertController(title: "", message: "我希望能夠聆聽你的反應，感謝！", preferredStyle: .alert)
                        let email = UIAlertAction(title: "email", style: .default) { (action) -> Void in
                            let mailController = MFMailComposeViewController()
                            mailController.mailComposeDelegate = self
                            mailController.title = "I have question"
                            mailController.setSubject("I have question")
                            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
                            let product = Bundle.main.object(forInfoDictionaryKey: "CFBundleName" )
                            let messageBody = "<br/><br/><br/>Product:\(product!)(\(version!))"
                            mailController.setMessageBody(messageBody, isHTML: true)
                            mailController.setToRecipients(["dda1829@yahoo.com.tw"])
                            self.present(mailController,animated: true,completion: nil)
                        }
                        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                        alert.addAction(cancel)
                        alert.addAction(email)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        print("can't not send email")
                        let alert = UIAlertController(title: "", message: "請檢查是否能夠寄出郵件，感謝！", preferredStyle: .alert)
                        let email = UIAlertAction(title: "email", style: .default) { (action) -> Void in
                            
                        }
                        alert.addAction(email)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else{
                if indexPath.row == 0{
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SystemMemberPage") as? SystemMemberViewController{
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else if indexPath.row == 1{
                    isEditTrainItem = !isEditTrainItem
                }
                if isEditTrainItem {
                    if  indexPath.row == 2{
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewTrainingItemPage") as? NewTrainingItemViewController{
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else if  indexPath.row == 3{
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemoveTrainingItemPage") as? RemoveTrainingItemViewController{
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else if indexPath.row == 4{
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditTrainingItemPage") as? EditTrainingItemViewController{
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else if indexPath.row == 5{
                        prepareTime += 1
                        if prepareTime == 6 {
                            prepareTime = 1
                        }
                        UserDefaults.standard.setValue(prepareTime, forKey: "prepareTime")
                        UserDefaults.standard.synchronize()
                        NotificationCenter.default.post(name: Notification.Name("prepareTime"), object: nil, userInfo: ["prepareTime":prepareTime])
                    }else if indexPath.row == 6{
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemainderPage") as? TrainingReminderViewController{
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }else{
                    if indexPath.row == 2{
                        prepareTime += 1
                        if prepareTime == 6 {
                            prepareTime = 1
                        }
                        UserDefaults.standard.setValue(prepareTime, forKey: "prepareTime")
                        UserDefaults.standard.synchronize()
                        NotificationCenter.default.post(name: Notification.Name("prepareTime"), object: nil, userInfo: ["prepareTime":prepareTime])
                    }else if indexPath.row == 3 {
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemainderPage") as? TrainingReminderViewController{
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }else if indexPath.section == 3{
            if Auth.auth().currentUser == nil {
                if indexPath.row == 0 {
                    if FileManager.default.ubiquityIdentityToken == nil {
                        print("plz open iCloud Drive")
                        let alert = UIAlertController(title: "", message: "請開啟這個ＡＰＰ的iCloud服務，感謝！", preferredStyle: .alert)
                        let confirm = UIAlertAction(title: "確認", style: .default) { (action) -> Void in
                            
                        }
                        alert.addAction(confirm)
                        present(alert, animated: true, completion: nil)
                    }else{
                        let path = FileManager.default.url(forUbiquityContainerIdentifier:"iCloud.recordItem")
                        let ddc = path?.appendingPathComponent("Documents")
                        let fileURL = ddc?.appendingPathComponent("RecordDatas/")
                        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
                        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
                        let file = doc.appendingPathComponent("RecordDatas/")
                        let manager = FileManager.default
                        do {
                            try manager.removeItem(at: fileURL!)

                        } catch  {
                                print(error)
                        }
                        do {
                            try manager.copyItem(at: file, to: fileURL!)
                        } catch  {
                            print(error)
                        }

                    }
                }else if indexPath.row == 1 {
                    if FileManager.default.ubiquityIdentityToken == nil {
                        print("plz open iCloud Drive")
                        let alert = UIAlertController(title: "", message: "請開啟這個ＡＰＰ的iCloud服務，感謝！", preferredStyle: .alert)
                        let confirm = UIAlertAction(title: "確認", style: .default) { (action) -> Void in
                            
                        }
                        alert.addAction(confirm)
                        present(alert, animated: true, completion: nil)
                    }else{
                        let path = FileManager.default.url(forUbiquityContainerIdentifier:"iCloud.recordItem")
                        let doc2 = path?.appendingPathComponent("Documents")
                        let fileURL = doc2?.appendingPathComponent("RecordDatas")

                        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
                        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
                        let file = doc.appendingPathComponent("RecordDatas")
                        let manager = FileManager.default
                        do {
                            try manager.copyItem(at: fileURL!, to: file)
                            print("成功寫入")
                        } catch  {
                                print(error)
                        }

                    }
                }else if indexPath.row == 2 {
                    let alert = UIAlertController(title: "", message: "注意，您\(dateRecord)此日的訓練資料即將刪除，請點確認繼續，或者cancel取消。", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "確認", style: .default) { (action) -> Void in
                        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
                        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
                        let file = doc.appendingPathComponent("RecordDatas")
                        let file2 = file.appendingPathComponent(self.dateRecord)
                        let manager = FileManager.default
                        do{
                            try manager.removeItem(at: file2)
                        }catch{
                            print("removeFail")
                        }
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                        print("cancel")
                    }
                    alert.addAction(cancel)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: nil)
                    
                }else if indexPath.row == 3 {
                    let alert = UIAlertController(title: "", message: "注意，您所有的訓練資料即將刪除，請點確認繼續，或者cancel取消。", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "確認", style: .default) { (action) -> Void in
                    let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
                    let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
                    let file = doc.appendingPathComponent("RecordDatas")
                    let manager = FileManager.default
                    do{
                        try manager.removeItem(at: file)
                    }catch{
                        print("removeFail")
                    }
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                        print("cancel")
                    }
                    alert.addAction(cancel)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                if indexPath.row == 0 {
                    let askController = UIAlertController(title: "Hello, APP User", message: "If you prefer this APP, please rate for 5 stars in APP store. Special thanks.", preferredStyle: .alert)
                    let laterAction = UIAlertAction(title: "稍後再評", style: .default, handler: nil)
                    let okAction = UIAlertAction(title: "我要評分", style: .default){
                        (action) -> Void in
                        let appID = "1581099175"
                        let appURL = URL(string: "https://itunes.apple.com/us/app/itunes-u/id\(appID)?action=write-review")!
                        UIApplication.shared.open(appURL, options: [:]) { (success) in
                            //
                        }
                    }
                    askController.addAction(laterAction)
                    askController.addAction(okAction)
                    self.present(askController,animated: true, completion: nil)
                }else if indexPath.row == 1{
                    if (MFMailComposeViewController.canSendMail()){
                        let alert = UIAlertController(title: "", message: "我希望能夠聆聽你的反應，感謝！", preferredStyle: .alert)
                        let email = UIAlertAction(title: "email", style: .default) { (action) -> Void in
                            let mailController = MFMailComposeViewController()
                            mailController.mailComposeDelegate = self
                            mailController.title = "I have question"
                            mailController.setSubject("I have question")
                            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
                            let product = Bundle.main.object(forInfoDictionaryKey: "CFBundleName" )
                            let messageBody = "<br/><br/><br/>Product:\(product!)(\(version!))"
                            mailController.setMessageBody(messageBody, isHTML: true)
                            mailController.setToRecipients(["dda1829@yahoo.com.tw"])
                            self.present(mailController,animated: true,completion: nil)
                        }
                        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                        alert.addAction(cancel)
                        alert.addAction(email)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        print("can't not send email")
                        let alert = UIAlertController(title: "", message: "請檢查是否能夠寄出郵件，感謝！", preferredStyle: .alert)
                        let email = UIAlertAction(title: "email", style: .default) { (action) -> Void in
                            
                        }
                        alert.addAction(email)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }else if indexPath.section == 4{
            if Auth.auth().currentUser == nil {
            }else{
                if indexPath.row == 0 {
                    if FileManager.default.ubiquityIdentityToken == nil {
                        print("plz open iCloud Drive")
                        let alert = UIAlertController(title: "", message: "請開啟這個ＡＰＰ的iCloud服務，感謝！", preferredStyle: .alert)
                        let confirm = UIAlertAction(title: "確認", style: .default) { (action) -> Void in
                            
                        }
                        alert.addAction(confirm)
                        present(alert, animated: true, completion: nil)
                    }else{
                        let path = FileManager.default.url(forUbiquityContainerIdentifier:"iCloud.recordItem")
                        let ddc = path?.appendingPathComponent("Documents")
                        let fileURL = ddc?.appendingPathComponent("RecordDatas/")
                        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
                        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
                        let file = doc.appendingPathComponent("RecordDatas/")
                        let manager = FileManager.default
                        do {
                            try manager.removeItem(at: fileURL!)
//                            try manager.copyItem(at: file, to: fileURL!)


                        } catch  {
                                print(error)
                        }
                        do {
                            try manager.copyItem(at: file, to: fileURL!)
                        } catch  {
                            print(error)
                        }

                    }
                }else if indexPath.row == 1 {
                    if FileManager.default.ubiquityIdentityToken == nil {
                        print("plz open iCloud Drive")
                        let alert = UIAlertController(title: "", message: "請開啟這個ＡＰＰ的iCloud服務，感謝！", preferredStyle: .alert)
                        let confirm = UIAlertAction(title: "確認", style: .default) { (action) -> Void in
                            
                        }
                        alert.addAction(confirm)
                        present(alert, animated: true, completion: nil)
                    }else{
                        let path = FileManager.default.url(forUbiquityContainerIdentifier:"iCloud.recordItem")
                        let doc2 = path?.appendingPathComponent("Documents")
                        let fileURL = doc2?.appendingPathComponent("RecordDatas")

                        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
                        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
                        let file = doc.appendingPathComponent("RecordDatas")
                        let manager = FileManager.default
                        do {
                            try manager.copyItem(at: fileURL!, to: file)
                            print("成功寫入")
                        } catch  {
                                print(error)
                        }

                    }
                }else if indexPath.row == 2 {
                    let alert = UIAlertController(title: "", message: "注意，您\(dateRecord)此日的訓練資料即將刪除，請點確認繼續，或者cancel取消。", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "確認", style: .default) { (action) -> Void in
                        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
                        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
                        let file = doc.appendingPathComponent("RecordDatas")
                        let file2 = file.appendingPathComponent(self.dateRecord)
                        let manager = FileManager.default
                        do{
                            try manager.removeItem(at: file2)
                        }catch{
                            print("removeFail")
                        }
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                        print("cancel")
                    }
                    alert.addAction(cancel)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: nil)
                    
                }else if indexPath.row == 3 {
                    let alert = UIAlertController(title: "", message: "注意，您所有的訓練資料即將刪除，請點確認繼續，或者cancel取消。", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "確認", style: .default) { (action) -> Void in
                    let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
                    let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
                    let file = doc.appendingPathComponent("RecordDatas")
                    let manager = FileManager.default
                    do{
                        try manager.removeItem(at: file)
                    }catch{
                        print("removeFail")
                    }
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                        print("cancel")
                    }
                    alert.addAction(cancel)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "訓練系統調整"
        case 2:
            if Auth.auth().currentUser == nil {
                return "ＡＰＰ相關"
            }else {
                return "會員功能"
            }
        case 3:
            if Auth.auth().currentUser == nil {
                return "訓練資料相關"
            }else{
                return "ＡＰＰ相關"
            }
        case 4:
            if Auth.auth().currentUser == nil {
                return nil
            }
            return "訓練資料相關"
        default:
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 0 {
            return 200
        } else if indexPath.section == 1 {
            return 50
        } else {
            return 50
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cell_systemVC_segue"{
            
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result{
        case .cancelled:
            print("user cancelled")
        case .failed:
            print("user failed")
        case .saved:
            print("user saved email")
        case .sent:
            print("email sent")
        @unknown default:
            print("something wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

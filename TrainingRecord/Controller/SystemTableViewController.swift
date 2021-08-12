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
    var memberFunctionForm : [String] = ["設定會員資料","設定預備時間"]
//    var dataForm: [String] = ["清除所有訓練資料","聯繫作者"]
    var trainingParameters: [String] = ["重量單位"]
    var db: Firestore?
    var memberDatas: [String:Any]?
    var prepareTime: Int = 3
    @objc func getmemberdatas(noti:Notification){
        memberDatas = noti.userInfo as? [String:Any]
        print(memberDatas!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToSysBtn))
        trainUnitSettoKg = UserDefaults.standard.bool(forKey: "trainUnitSet")
        trainingGoals = ["體脂降低10％","肌肉重量增加\(trainUnitSettoKg ? "1 Kg" : "2.2 lb")","基礎代謝率增加200大卡"]
        if let user = Auth.auth().currentUser{
            print("\(user.uid) login")
            if let usergoal = UserDefaults.standard.string(forKey: "userGoal"){
            trainingGoal = usergoal
            }else if let usergoal = MemberUserDataToFirestore.share.getUserdatas("userGoal"){
                if let goal = (usergoal as! [String]).last{
                    trainingGoal = goal
                    UserDefaults.standard.setValue(goal, forKey: "userGoal")
                    UserDefaults.standard.synchronize()
                }
            }
            if UserDefaults.standard.integer(forKey: "prepareTime") != 0 {
            prepareTime = UserDefaults.standard.integer(forKey: "prepareTime")
            }
            userTextLabel = user.displayName ?? "精壯使用者"
            if let userphotoinFB = user.photoURL {
                userPhoto = UIImage(contentsOfFile: userphotoinFB.absoluteString)
            }else{
                userPhoto = UIImage(systemName: "person.circle.fill")
            }
            
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
            return 4
        }else{
            return 3
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
            if Auth.auth().currentUser != nil {
                return memberFunctionForm.count
            }else {
                return 1
            }
        case 3:
            return 1
        default:
            return 1
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
            cell.imageView?.translatesAutoresizingMaskIntoConstraints = false
            cell.imageView?.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            cell.imageView?.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 20).isActive = true
            cell.imageView?.widthAnchor.constraint(equalToConstant: 70).isActive = true
            cell.imageView?.heightAnchor.constraint(equalToConstant: 70).isActive = true
            cell.imageView?.setImageColor(color: .systemBlue)
        }
        else if  indexPath.section == 1  {
            cell = tableView.dequeueReusableCell(withIdentifier: "Systemcell", for: indexPath)
            cell.textLabel?.text = trainingParameters[indexPath.row]
            cell.detailTextLabel?.text = trainUnitSettoKg ? "Kg" : "lb"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        }else if indexPath.section == 2 {
            if Auth.auth().currentUser == nil {
                cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                cell.textLabel?.text = "清除所有訓練資料"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.textLabel?.textColor = .red
            }else{
                if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "SystemMemberCell", for: indexPath)
                cell.textLabel?.text = memberFunctionForm[indexPath.row]
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.textLabel?.textColor = .white
                }else if indexPath.row == 1 {
                    cell = tableView.dequeueReusableCell(withIdentifier: "Systemcell", for: indexPath)
                    cell.textLabel?.text = memberFunctionForm[indexPath.row]
                    cell.detailTextLabel?.text = "\(prepareTime)"
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
                    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
                    cell.textLabel?.textColor = .white
                }
            }
        }else   if indexPath.section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "清除所有訓練資料"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell.textLabel?.textColor = .red
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
        }else if indexPath.row == 0 && indexPath.section == 1 {
            trainUnitSettoKg = !trainUnitSettoKg
            UserDefaults.standard.set(trainUnitSettoKg, forKey: "trainUnitSet")
            UserDefaults.standard.synchronize()
            trainUnit = trainUnitSettoKg ? "Kg" : "lb"
            UserDefaults.standard.set(trainUnit, forKey: "trainUnit")
            UserDefaults.standard.synchronize()
        }else{
            if Auth.auth().currentUser == nil {
                if indexPath.row == 0 && indexPath.section == 2 {
                    let homeURL = URL(fileURLWithPath: NSHomeDirectory())
                    let docURL = homeURL.appendingPathComponent("Documents")
                    let fileURL = docURL.appendingPathComponent("RecordDatas.archive")
                    let manager = FileManager.default
                    try? manager.removeItem(at: fileURL)
                    let notificationName = Notification.Name("ClearDatas")
                    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
                }
            }else{
                if indexPath.section == 2 && indexPath.row == 0{
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SystemMemberPage") as? SystemMemberViewController{
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else if indexPath.section == 2 && indexPath.row == 1{
                    prepareTime += 1
                    if prepareTime == 6 {
                        prepareTime = 1
                    }
                    UserDefaults.standard.setValue(prepareTime, forKey: "prepareTime")
                    UserDefaults.standard.synchronize()
                }else if indexPath.row == 0 && indexPath.section == 3 {
                    let homeURL = URL(fileURLWithPath: NSHomeDirectory())
                    let docURL = homeURL.appendingPathComponent("Documents")
                    let fileURL = docURL.appendingPathComponent("RecordDatas.archive")
                    let manager = FileManager.default
                    try? manager.removeItem(at: fileURL)
                    let notificationName = Notification.Name("ClearDatas")
                    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
                }
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "訓練參數調整"
        case 2:
            if Auth.auth().currentUser == nil {
                return "訓練資料調整"
            }else {
                return "會員功能"
            }
        case 3:
            if Auth.auth().currentUser != nil {
                return "訓練資料調整"
            }
            return nil
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
   
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

//
//  SystemTableViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/7/21.
//

import UIKit

class SystemTableViewController: UITableViewController {
    var userTextLabel = "未知使用者"
    var trainingGoals = ["體脂降低10％","肌肉重量增加1公斤","基礎代謝率增加200大卡"]
    var trainUnitSettoKg = true
    var trainUnit = "Kg"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 1:
            return 1
        case 2:
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
            cell.detailTextLabel?.text = "目標：\(trainingGoals.randomElement()!)"
            cell.showsReorderControl = true
            
        }
        else if  indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Systemcell", for: indexPath)
            cell.textLabel?.text = "重量單位"
            cell.detailTextLabel?.text = trainUnitSettoKg ? "Kg" : "lb"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "清除所有訓練資料"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell.textLabel?.textColor = .red
        }
        
        
        
        
        // Configure the cell...

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 1 {
            trainUnitSettoKg = !trainUnitSettoKg
            trainUnit = trainUnitSettoKg ? "Kg" : "lb"
            let notificationName = Notification.Name("ChangeTrainUnit")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["trainUnit" : trainUnit])
        }else if indexPath.row == 0 && indexPath.section == 2 {
            let homeURL = URL(fileURLWithPath: NSHomeDirectory())
            let docURL = homeURL.appendingPathComponent("Documents")
            let fileURL = docURL.appendingPathComponent("RecordDatas.archive")
            let manager = FileManager.default
            try? manager.removeItem(at: fileURL)
            let notificationName = Notification.Name("ClearDatas")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        }
        
        
            
            tableView.reloadData()
        
    }
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "訓練參數調整"
        case 2:
            return "訓練資料定"
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

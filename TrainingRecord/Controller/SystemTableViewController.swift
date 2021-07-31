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
    var trainUnitset = true
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "Systemcell", for: indexPath)
        if indexPath.row == 0 && indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
            cell.textLabel?.text = userTextLabel
            cell.detailTextLabel?.text = "目標：\(trainingGoals.randomElement()!)"
            cell.showsReorderControl = true
            
        }
        else if  indexPath.section == 1 {
            cell.textLabel?.text = "重量單位"
            cell.detailTextLabel?.text = trainUnitset ? "Kg" : "lb"
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "清除所有訓練資料"
        }
        
        
        
        
        // Configure the cell...

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 1 {
            trainUnitset = !trainUnitset
            trainUnit = trainUnitset ? "Kg" : "lb"
            let notificationName = Notification.Name("GetUpdateNoti")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["trainUnit" : trainUnit])
            
            
            tableView.reloadData()
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

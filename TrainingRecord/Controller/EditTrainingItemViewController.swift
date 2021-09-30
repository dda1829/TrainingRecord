//
//  EditTrainingItemViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/25.
//

import UIKit

class EditTrainingItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    // MARK: TrainingItem's list
    var breastItems:[TrainingItem] = []
    var backItems:[TrainingItem] = []
    var abdomenItems:[TrainingItem] = []
    var blItems: [TrainingItem] = []
    var armItems: [TrainingItem] = []
    var exItems: [TrainingItem] = []
    // MARK: Picker View Selection
    var trainLS = 0
    var formListLocation : [String] = [NSLocalizedString("TrainingLocation",comment: "運動部位"), NSLocalizedString("BrestShoulder",comment: "肩胸部"),NSLocalizedString("Back",comment: "背部"), NSLocalizedString("Abdomen",comment: "核心"),NSLocalizedString("BottomLap",comment: "臀腿部"),NSLocalizedString("Arm",comment: "手臂")  ,NSLocalizedString("Exercise",comment: "有氧運動")]
    
    // tableview setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch trainLS {
        case 1:
            return breastItems.count
        case 2:
            return backItems.count
        case 3:
            return abdomenItems.count
        case 4:
            return blItems.count
        case 5:
            return armItems.count
        case 6:
            return exItems.count
        default:
            print("error")
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch trainLS {
        case 1:
            cell.textLabel?.text = breastItems[indexPath.row].name
            cell.detailTextLabel?.text = breastItems[indexPath.row].def
        case 2:
            cell.textLabel?.text = backItems[indexPath.row].name
            cell.detailTextLabel?.text = backItems[indexPath.row].def
        case 3:
            cell.textLabel?.text = abdomenItems[indexPath.row].name
            cell.detailTextLabel?.text = abdomenItems[indexPath.row].def
        case 4:
            cell.textLabel?.text = blItems[indexPath.row].name
            cell.detailTextLabel?.text = blItems[indexPath.row].def
        case 5:
            cell.textLabel?.text = armItems[indexPath.row].name
            cell.detailTextLabel?.text = armItems[indexPath.row].def
        case 6:
            cell.textLabel?.text = exItems[indexPath.row].name
            cell.detailTextLabel?.text = exItems[indexPath.row].def
        default:
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            print("error")
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.detailTextLabel?.textColor = .white
        return cell
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        switch trainLS {
        case 1:
                let origindata = breastItems.remove(at: sourceIndexPath.row)
                breastItems.insert(origindata, at: destinationIndexPath.row)
            ManageTrainingItem.share.editTraingItem(Location: "BrestShoulder", EditedRow: sourceIndexPath.row, EditedtoRow: destinationIndexPath.row, Content: nil, Type: "edit")
        case 2:
            let origindata = backItems.remove(at: sourceIndexPath.row)
            backItems.insert(origindata, at: destinationIndexPath.row)
            ManageTrainingItem.share.editTraingItem(Location: "Back", EditedRow: sourceIndexPath.row, EditedtoRow: destinationIndexPath.row, Content: nil, Type: "edit")
        case 3:
            let origindata = abdomenItems.remove(at: sourceIndexPath.row)
            abdomenItems.insert(origindata, at: destinationIndexPath.row)
            ManageTrainingItem.share.editTraingItem(Location: "Abdomen", EditedRow: sourceIndexPath.row, EditedtoRow: destinationIndexPath.row, Content: nil, Type: "edit")
        case 4:
            let origindata = blItems.remove(at: sourceIndexPath.row)
            blItems.insert(origindata, at: destinationIndexPath.row)
            ManageTrainingItem.share.editTraingItem(Location: "BottomLap", EditedRow: sourceIndexPath.row, EditedtoRow: destinationIndexPath.row, Content: nil, Type: "edit")
        case 5:
            let origindata = armItems.remove(at: sourceIndexPath.row)
            armItems.insert(origindata, at: destinationIndexPath.row)
            ManageTrainingItem.share.editTraingItem(Location: "Arm", EditedRow: sourceIndexPath.row, EditedtoRow: destinationIndexPath.row, Content: nil, Type: "edit")
        case 6:
            let originadata = exItems.remove(at: sourceIndexPath.row)
            armItems.insert(originadata, at: destinationIndexPath.row)
            ManageTrainingItem.share.editTraingItem(Location: "Exercise", EditedRow: sourceIndexPath.row, EditedtoRow: destinationIndexPath.row, Content: nil, Type: "edit")
        default:
            print("error")
        }
        tableView.reloadData()


    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }


    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    // pickerview setup
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        formListLocation.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formListLocation[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 1:
            trainLS = 1
            
        case 2:
            trainLS = 2
        case 3:
            trainLS = 3
        case 4:
            trainLS = 4
        case 5:
            trainLS = 5
        case 6:
            trainLS = 6
        default:
            trainLS = 0
            print("wrong data")
        }
        trainingItemTableView.reloadData()
    }
    
    @IBOutlet weak var trainLocationPickerView: UIPickerView!
    
    @IBOutlet weak var trainingItemTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        breastItems = ManageTrainingItem.share.getTrainingItem(Location: "BrestShoulder")!
         backItems = ManageTrainingItem.share.getTrainingItem(Location: "Back")!
         abdomenItems = ManageTrainingItem.share.getTrainingItem(Location: "Abdomen")!
         armItems = ManageTrainingItem.share.getTrainingItem(Location: "Arm")!
         blItems = ManageTrainingItem.share.getTrainingItem(Location: "BottomLap")!
         exItems = ManageTrainingItem.share.getTrainingItem(Location: "Exercise")!
        trainLocationPickerView.dataSource = self
        trainLocationPickerView.delegate = self
        trainingItemTableView.dataSource = self
        trainingItemTableView.delegate = self
        trainingItemTableView.setEditing(true, animated: true)
        trainLocationPickerView.setValue(UIColor.white, forKey: "textColor")
        // Do any additional setup after loading the view.
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

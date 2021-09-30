//
//  RemoveTrainingItemViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/25.
//

import UIKit
import CoreData
class RemoveTrainingItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITableViewDelegate {
    // MARK: TrainingItem's list
    var breastItems:[TrainingItem] = []
    var backItems:[TrainingItem] = []
    var abdomenItems:[TrainingItem] = []
    var blItems: [TrainingItem] = []
    var armItems: [TrainingItem] = []
    var exItems: [TrainingItem] = []
    var dbreastItems:[TrainingItem] = []
    var dbackItems:[TrainingItem] = []
    var dabdomenItems:[TrainingItem] = []
    var dblItems: [TrainingItem] = []
    var darmItems: [TrainingItem] = []
    var dexItems: [TrainingItem] = []
    // MARK: Picker View Selection
    var trainLS = 0
    var formListLocation : [String] = [NSLocalizedString("TrainingLocation",comment: "運動部位"), NSLocalizedString("BrestShoulder",comment: "肩胸部"),NSLocalizedString("Back",comment: "背部"), NSLocalizedString("Abdomen",comment: "核心"),NSLocalizedString("BottomLap",comment: "臀腿部"),NSLocalizedString("Arm",comment: "手臂")  ,NSLocalizedString("Exercise",comment: "有氧運動")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trainLocationPickerView.delegate = self
        trainLocationPickerView.dataSource = self
        trainingItemTableView.delegate = self
        trainingItemTableView.dataSource = self
        removedTrainingTableView.delegate = self
        removedTrainingTableView.dataSource = self
        breastItems = ManageTrainingItem.share.getTrainingItem(Location: "BrestShoulder")!
         backItems = ManageTrainingItem.share.getTrainingItem(Location: "Back")!
         abdomenItems = ManageTrainingItem.share.getTrainingItem(Location: "Abdomen")!
         armItems = ManageTrainingItem.share.getTrainingItem(Location: "Arm")!
         blItems = ManageTrainingItem.share.getTrainingItem(Location: "BottomLap")!
         exItems = ManageTrainingItem.share.getTrainingItem(Location: "Exercise")!
        dbreastItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "BrestShoulder")!
         dbackItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Back")!
         dabdomenItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Abdomen")!
         darmItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Arm")!
         dblItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "BottomLap")!
         dexItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Exercise")!
        trainingItemTableView.setEditing(true, animated: true)
        trainLocationPickerView.setValue(UIColor.white, forKey: "textColor")
    }
    // pickerView Setup
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formListLocation.count
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
        removedTrainingTableView.reloadData()
    }
    
   

    
    // tableView set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == trainingItemTableView {
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
            }
        }else{
            switch trainLS {
            case 1:
                return dbreastItems.count
            case 2:
                return dbackItems.count
            case 3:
                return dabdomenItems.count
            case 4:
                return dblItems.count
            case 5:
                return darmItems.count
            case 6:
                return dexItems.count
            default:
                print("error")
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if tableView == trainingItemTableView {
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


        }else{
            switch trainLS {
            case 1:
                cell.textLabel?.text = dbreastItems[indexPath.row].name
                cell.detailTextLabel?.text = dbreastItems[indexPath.row].def
            case 2:
                cell.textLabel?.text = dbackItems[indexPath.row].name
                cell.detailTextLabel?.text = dbackItems[indexPath.row].def
            case 3:
                cell.textLabel?.text = dabdomenItems[indexPath.row].name
                cell.detailTextLabel?.text = dabdomenItems[indexPath.row].def
            case 4:
                cell.textLabel?.text = dblItems[indexPath.row].name
                cell.detailTextLabel?.text = dblItems[indexPath.row].def
            case 5:
                cell.textLabel?.text = darmItems[indexPath.row].name
                cell.detailTextLabel?.text = darmItems[indexPath.row].def
            case 6:
                cell.textLabel?.text = dexItems[indexPath.row].name
                cell.detailTextLabel?.text = dexItems[indexPath.row].def
            default:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                print("error")
            }
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.detailTextLabel?.textColor = .white
        return cell
    }
//
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            defer {
                trainingItemTableView.reloadData()
                removedTrainingTableView.reloadData()
            }
            if tableView == trainingItemTableView {
            switch trainLS {
            case 1:
                if breastItems.count != 1 {
                    breastItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.editTraingItem(Location: "BrestShoulder", EditedRow: indexPath.row, EditedtoRow: nil, Content: nil, Type: "delete")
                    breastItems = ManageTrainingItem.share.getTrainingItem(Location: "BrestShoulder")!
                    dbreastItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "BrestShoulder")!
                    
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)

                    self.present(alertController, animated: true, completion: nil)
                }
            case 2:
                if backItems.count != 1 {
                    backItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.editTraingItem(Location: "Back", EditedRow: indexPath.row, EditedtoRow: nil, Content: nil, Type: "delete")
                    backItems = ManageTrainingItem.share.getTrainingItem(Location: "Back")!
                    dbackItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Back")!
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)

                    self.present(alertController, animated: true, completion: nil)
                }
            case 3:
                if abdomenItems.count != 1 {
                    abdomenItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.editTraingItem(Location: "Abdomen", EditedRow: indexPath.row, EditedtoRow: nil, Content: nil, Type: "delete")
                    abdomenItems = ManageTrainingItem.share.getTrainingItem(Location: "Abdomen")!
                    dabdomenItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Abdomen")!
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)

                    self.present(alertController, animated: true, completion: nil)
                }
            case 4:
                if blItems.count != 1 {
                    blItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.editTraingItem(Location: "BottomLap", EditedRow: indexPath.row, EditedtoRow: nil, Content: nil, Type: "delete")
                    blItems = ManageTrainingItem.share.getTrainingItem(Location: "BottomLap")!
                    dblItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "BottomLap")!
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)

                    self.present(alertController, animated: true, completion: nil)
                }
            case 5:
                if armItems.count != 1 {
                    armItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.editTraingItem(Location: "Arm", EditedRow: indexPath.row, EditedtoRow: nil, Content: nil, Type: "delete")
                    armItems = ManageTrainingItem.share.getTrainingItem(Location: "Arm")!
                    darmItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Arm")!
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)

                    self.present(alertController, animated: true, completion: nil)
                }
            case 6:
                if exItems.count != 1 {
                    exItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.editTraingItem(Location: "Exercise", EditedRow: indexPath.row, EditedtoRow: nil, Content: nil, Type: "delete")
                    exItems = ManageTrainingItem.share.getTrainingItem(Location: "Exercise")!
                    dexItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Exercise")!
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)

                    self.present(alertController, animated: true, completion: nil)
                }
            default:
                print("error")
            }

            }else{
                switch trainLS {
                case 1:
                    dbreastItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.recoverTrainingItem(Location: "BrestShoulder", EditedRow: indexPath.row)
                    dbreastItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "BrestShoulder")!
                    breastItems = ManageTrainingItem.share.getTrainingItem(Location: "BrestShoulder")!
                case 2:
                    dbackItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.recoverTrainingItem(Location: "Back", EditedRow: indexPath.row)
                    dbackItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Back")!
                    backItems = ManageTrainingItem.share.getTrainingItem(Location: "Back")!
                case 3:
                    dabdomenItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.recoverTrainingItem(Location: "Abdomen", EditedRow: indexPath.row)
                    dabdomenItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Abdomen")!
                    abdomenItems = ManageTrainingItem.share.getTrainingItem(Location: "Abdomen")!
                case 4:
                    dblItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.recoverTrainingItem(Location: "BottomLap", EditedRow: indexPath.row)
                    dblItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "BottomLap")!
                    blItems = ManageTrainingItem.share.getTrainingItem(Location: "BottomLap")!
                case 5:
                    darmItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.recoverTrainingItem(Location: "Arm", EditedRow: indexPath.row)
                    darmItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Arm")!
                    armItems = ManageTrainingItem.share.getTrainingItem(Location: "Arm")!
                case 6:
                    dexItems.remove(at: indexPath.row)
                    ManageTrainingItem.share.recoverTrainingItem(Location: "Exercise", EditedRow: indexPath.row)
                    dexItems = ManageTrainingItem.share.getDeletedTrainingItem(Location: "Exercise")!
                    exItems = ManageTrainingItem.share.getTrainingItem(Location: "Exercise")!
                default:
                    print("error")
                }
                trainingItemTableView.reloadData()
            }
        }

    }

    
    @IBOutlet weak var trainLocationPickerView: UIPickerView!
    @IBOutlet weak var trainingItemTableView: UITableView!
    @IBOutlet weak var removedTrainingTableView: UITableView!
    

    
   
}

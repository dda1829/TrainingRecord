//
//  RemoveTrainingItemViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/25.
//

import UIKit
import CoreData
class RemoveTrainingItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    // MARK: Picker View Selection
    var trainLS = 0
    var formListLocation : [String] = ["運動部位", "肩胸部", "背部" ,"臀腿部", "腹部", "手臂","有氧運動"]
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
    
    // MARK: tableView 
    // MARK: CoreData for TrainItem's List
    var brestData : BrestItem!
    var backData : BackItem!
    var abdomenData : AbdomenItem!
    var blData : BLItem!
    var exerciseData : ExerciseItem!
    var armData : ArmItem!
    var beforeBrestData : [BrestItem] = []
    var beforeBackData : [BackItem] = []
    var beforeAbdomenData : [AbdomenItem] = []
    var beforeBLData : [BLItem] = []
    var beforeExerciseData : [ExerciseItem] = []
    var beforeArmData : [ArmItem] = []
    
    var fetchResultController: NSFetchedResultsController<BrestItem>!
    var fetchResultControllerback: NSFetchedResultsController<BackItem>!
    var fetchResultControllerabdomen: NSFetchedResultsController<AbdomenItem>!
    var fetchResultControllerbl: NSFetchedResultsController<BLItem>!
    var fetchResultControllerarm: NSFetchedResultsController<ArmItem>!
    var fetchResultControllerex: NSFetchedResultsController<ExerciseItem>!
    var fetchResultControlleruB: NSFetchedResultsController<UBrestItem>!
    var fetchResultControllerUback: NSFetchedResultsController<UBackItem>!
    var fetchResultControllerUabdomen: NSFetchedResultsController<UAbdomenItem>!
    var fetchResultControllerUbl: NSFetchedResultsController<UBLItem>!
    var fetchResultControllerUarm: NSFetchedResultsController<UArmItem>!
    var fetchResultControllerUex: NSFetchedResultsController<UExerciseItem>!
    //MARK: CoreData for User's TrainItem's List
    var uBrestData: UBrestItem!
    var uBackData: UBackItem!
    var uAbdomenData: UAbdomenItem!
    var uBLData : UBLItem!
    var uArmData : UArmItem!
    var uExData : UExerciseItem!
    var uBrestDatas: [UBrestItem] = []
    var uBackDatas: [UBackItem] = []
    var uAbdomenDatas: [UAbdomenItem] = []
    var uBLDatas: [UBLItem] = []
    var uArmDatas: [UArmItem] = []
    var uExDatas: [UExerciseItem] = []
    // MARK: TrainItem's list
    var formListBrest : [String] = []
    var formListBL : [String] = []
    var formListAbdomen : [String] = []
    var formListArm : [String] = []
    var formListEx : [String] = []
    var formListBack : [String] = []
    var trainBrestText:[String] = []
    var trainBackText:[String] = []
    var trainBLText:[String] = []
    var trainAbdomenText:[String] = []
    var trainArmText:[String] = []
    var trainExText:[String] = []
    var formListBrestu : [String] = []
    var formListBLu : [String] = []
    var formListAbdomenu : [String] = []
    var formListArmu : [String] = []
    var formListExu : [String] = []
    var formListBacku : [String] = []
    var trainBrestTextu:[String] = []
    var trainBackTextu:[String] = []
    var trainBLTextu:[String] = []
    var trainAbdomenTextu:[String] = []
    var trainArmTextu:[String] = []
    var trainExTextu:[String] = []
    var brestImageforms : [UIImage] = []
    var backImageforms : [UIImage] = []
    var blImageforms : [UIImage] =  []
    var abdomenImageforms : [UIImage] = []
    var armImageforms : [UIImage] = []
    var exerciseImageforms : [UIImage] = []
    var brestImageformsu : [UIImage] = []
    var backImageformsu : [UIImage] = []
    var blImageformsu : [UIImage] =  []
    var abdomenImageformsu : [UIImage] = []
    var armImageformsu : [UIImage] = []
    var exerciseImageformsu : [UIImage] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == trainingItemTableView {
            switch trainLS {
            case 1:
                return beforeBrestData.count
            case 2:
                return beforeBackData.count
            case 3:
                return beforeAbdomenData.count
            case 4:
                return beforeBLData.count
            case 5:
                return beforeArmData.count
            case 6:
                return beforeExerciseData.count
            default:
                print("error")
            }
        }else{
            switch trainLS {
            case 1:
                return uBrestDatas.count
            case 2:
                return uBackDatas.count
            case 3:
                return uAbdomenDatas.count
            case 4:
                return uBLDatas.count
            case 5:
                return uArmDatas.count
            case 6:
                return uExDatas.count
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
                cell.textLabel?.text = beforeBrestData[indexPath.row].name
                cell.detailTextLabel?.text = beforeBrestData[indexPath.row].def
            case 2:
                cell.textLabel?.text = beforeBackData[indexPath.row].name
                cell.detailTextLabel?.text = beforeBackData[indexPath.row].def
            case 3:
                cell.textLabel?.text = beforeAbdomenData[indexPath.row].name
                cell.detailTextLabel?.text = beforeAbdomenData[indexPath.row].def
            case 4:
                cell.textLabel?.text = beforeBLData[indexPath.row].name
                cell.detailTextLabel?.text = beforeBLData[indexPath.row].def
            case 5:
                cell.textLabel?.text = beforeArmData[indexPath.row].name
                cell.detailTextLabel?.text = beforeArmData[indexPath.row].def
            case 6:
                cell.textLabel?.text = beforeExerciseData[indexPath.row].name
                cell.detailTextLabel?.text = beforeExerciseData[indexPath.row].def
            default:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                print("error")
            }
           
            
        }else{
            switch trainLS {
            case 1:
                cell.textLabel?.text = uBrestDatas[indexPath.row].name
                cell.detailTextLabel?.text = uBrestDatas[indexPath.row].def
            case 2:
                cell.textLabel?.text = uBackDatas[indexPath.row].name
                cell.detailTextLabel?.text = uBackDatas[indexPath.row].def
            case 3:
                cell.textLabel?.text = uAbdomenDatas[indexPath.row].name
                cell.detailTextLabel?.text = uAbdomenDatas[indexPath.row].def
            case 4:
                cell.textLabel?.text = uBLDatas[indexPath.row].name
                cell.detailTextLabel?.text = uBLDatas[indexPath.row].def
            case 5:
                cell.textLabel?.text = uArmDatas[indexPath.row].name
                cell.detailTextLabel?.text = uArmDatas[indexPath.row].def
            case 6:
                cell.textLabel?.text = uExDatas[indexPath.row].name
                cell.detailTextLabel?.text = uExDatas[indexPath.row].def
            default:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                print("error")
            }
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == trainingItemTableView {
            switch trainLS {
            case 1:
                if beforeBrestData.count != 1 {
                    userTrainingItemCoreDataStore(1, beforeBrestData[indexPath.row].image!, beforeBrestData[indexPath.row].name!, beforeBrestData[indexPath.row].def!, Int(beforeBrestData[indexPath.row].id))
                beforeBrestData.remove(at: indexPath.row)
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    let restaurantToDelete = fetchResultController.object(at: indexPath)
                    context.delete(restaurantToDelete)
                    
                    appDelegate.saveContext()
                }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            case 2:
                if beforeBackData.count != 1 {
                    userTrainingItemCoreDataStore(2, beforeBackData[indexPath.row].image!, beforeBackData[indexPath.row].name!, beforeBackData[indexPath.row].def!, Int(beforeBackData[indexPath.row].id))
                beforeBackData.remove(at: indexPath.row)
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    let restaurantToDelete = self.fetchResultControllerback.object(at: indexPath)
                    context.delete(restaurantToDelete)
                    
                    appDelegate.saveContext()
                }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            case 3:
                if beforeAbdomenData.count != 1 {
                    userTrainingItemCoreDataStore(3, beforeAbdomenData[indexPath.row].image!, beforeAbdomenData[indexPath.row].name!, beforeAbdomenData[indexPath.row].def!, Int(beforeAbdomenData[indexPath.row].id))
                beforeAbdomenData.remove(at: indexPath.row)
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    let restaurantToDelete = self.fetchResultControllerabdomen.object(at: indexPath)
                    context.delete(restaurantToDelete)
                    
                    appDelegate.saveContext()
                }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            case 4:
                if beforeBLData.count != 1 {
                    userTrainingItemCoreDataStore(4, beforeBLData[indexPath.row].image!, beforeBLData[indexPath.row].name!, beforeBLData[indexPath.row].def!, Int(beforeBLData[indexPath.row].id))
                beforeBLData.remove(at: indexPath.row)
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    let restaurantToDelete = self.fetchResultControllerbl.object(at: indexPath)
                    context.delete(restaurantToDelete)
                    
                    appDelegate.saveContext()
                }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            case 5:
                if beforeArmData.count != 1 {
                    userTrainingItemCoreDataStore(5, beforeArmData[indexPath.row].image!, beforeArmData[indexPath.row].name!, beforeArmData[indexPath.row].def!, Int(beforeArmData[indexPath.row].id))
                beforeArmData.remove(at: indexPath.row)
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    let restaurantToDelete = self.fetchResultControllerarm
                        .object(at: indexPath)
                    context.delete(restaurantToDelete)
                    
                    appDelegate.saveContext()
                }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }else{
                    let alertController = UIAlertController(title: "請至少保留一個項目，謝謝！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            case 6:
                if beforeExerciseData.count != 1 {
                    userTrainingItemCoreDataStore(6, beforeExerciseData[indexPath.row].image!, beforeExerciseData[indexPath.row].name!, beforeExerciseData[indexPath.row].def!, Int(beforeExerciseData[indexPath.row].id))
                beforeExerciseData.remove(at: indexPath.row)
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    let restaurantToDelete = self.fetchResultControllerex.object(at: indexPath)
                    context.delete(restaurantToDelete)
                    
                    appDelegate.saveContext()
                }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
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
                removedTrainingTableView.reloadData()
               
            }else{
                switch trainLS {
                case 1:
                    trainingItemCoreDataStore(1, uBrestDatas[indexPath.row].image!, uBrestDatas[indexPath.row].name!, uBrestDatas[indexPath.row].def!, Int(uBrestDatas[indexPath.row].id))
                    uBrestDatas.remove(at: indexPath.row)
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                        let context = appDelegate.persistentContainer.viewContext
                        let restaurantToDelete = self.fetchResultControlleruB.object(at: indexPath)
                        context.delete(restaurantToDelete)
                        
                        appDelegate.saveContext()
                    }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case 2:
                    trainingItemCoreDataStore(2, uBackDatas[indexPath.row].image!, uBackDatas[indexPath.row].name!, uBackDatas[indexPath.row].def!, Int(uBackDatas[indexPath.row].id))
                    uBackDatas.remove(at: indexPath.row)
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                        let context = appDelegate.persistentContainer.viewContext
                        let restaurantToDelete = self.fetchResultControllerUback.object(at: indexPath)
                        context.delete(restaurantToDelete)
                        
                        appDelegate.saveContext()
                    }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case 3:
                    trainingItemCoreDataStore(3, uAbdomenDatas[indexPath.row].image!, uAbdomenDatas[indexPath.row].name!, uAbdomenDatas[indexPath.row].def!, Int(uAbdomenDatas[indexPath.row].id))
                    uAbdomenDatas.remove(at: indexPath.row)
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                        let context = appDelegate.persistentContainer.viewContext
                        let restaurantToDelete = self.fetchResultControllerUabdomen.object(at: indexPath)
                        context.delete(restaurantToDelete)
                        
                        appDelegate.saveContext()
                    }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case 4:
                    trainingItemCoreDataStore(4, uBLDatas[indexPath.row].image!, uBLDatas[indexPath.row].name!, uBLDatas[indexPath.row].def!, Int(uBLDatas[indexPath.row].id))
                    uBLDatas.remove(at: indexPath.row)
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                        let context = appDelegate.persistentContainer.viewContext
                        let restaurantToDelete = self.fetchResultControllerUbl.object(at: indexPath)
                        context.delete(restaurantToDelete)
                        
                        appDelegate.saveContext()
                    }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case 5:
                    trainingItemCoreDataStore(5, uArmDatas[indexPath.row].image!, uArmDatas[indexPath.row].name!, uArmDatas[indexPath.row].def!, Int(uArmDatas[indexPath.row].id))
                    uArmDatas.remove(at: indexPath.row)
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                        let context = appDelegate.persistentContainer.viewContext
                        let restaurantToDelete = self.fetchResultControllerUarm.object(at: indexPath)
                        context.delete(restaurantToDelete)
                        
                        appDelegate.saveContext()
                    }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case 6:
                    trainingItemCoreDataStore(6, uExDatas[indexPath.row].image!, uExDatas[indexPath.row].name!, uExDatas[indexPath.row].def!, Int(uExDatas[indexPath.row].id))
                    uExDatas.remove(at: indexPath.row)
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                        let context = appDelegate.persistentContainer.viewContext
                        let restaurantToDelete = self.fetchResultControllerUex.object(at: indexPath)
                        context.delete(restaurantToDelete)
                        
                        appDelegate.saveContext()
                    }
                    loadTheTrainList()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                default:
                    print("error")
                }
                trainingItemTableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        switch trainLS {
        case 1:
                let origindata = beforeBrestData.remove(at: sourceIndexPath.row)
                beforeBrestData.insert(origindata, at: destinationIndexPath.row)
            clearCoreData()
            for x in beforeBrestData {
                trainingItemCoreDataStore(1, x.image!, x.name!, x.def!, Int(x.id))
            }
        case 2:
            let origindata = beforeBackData.remove(at: sourceIndexPath.row)
            beforeBackData.insert(origindata, at: destinationIndexPath.row)
            clearCoreData()
            for x in 0 ..< beforeBackData.count {
                trainingItemCoreDataStore(2,backImageURLs[x] , formListBack[x], trainBackText[x], Int(x))
            }
        case 3:
            let origindata = beforeAbdomenData.remove(at: sourceIndexPath.row)
            beforeAbdomenData.insert(origindata, at: destinationIndexPath.row)
            clearCoreData()
            for x in beforeAbdomenData {
                trainingItemCoreDataStore(3, x.image!, x.name!, x.def!, Int(x.id))
            }
        case 4:
            let origindata = beforeBLData.remove(at: sourceIndexPath.row)
            beforeBLData.insert(origindata, at: destinationIndexPath.row)
            clearCoreData()
            for x in beforeBLData {
                trainingItemCoreDataStore(4, x.image!, x.name!, x.def!, Int(x.id))
            }
        case 5:
            let origindata = beforeArmData.remove(at: sourceIndexPath.row)
            beforeArmData.insert(origindata, at: destinationIndexPath.row)
            clearCoreData()
            for x in beforeArmData {
                trainingItemCoreDataStore(5, x.image!, x.name!, x.def!, Int(x.id))
            }
        case 6:
            let origindata = beforeExerciseData.remove(at: sourceIndexPath.row)
            beforeExerciseData.insert(origindata, at: destinationIndexPath.row)
            clearCoreData()
            for x in beforeExerciseData {
                trainingItemCoreDataStore(6, x.image!, x.name!, x.def!, Int(x.id))
            }
        default:
            print("error")
        }
        
        
    }
    @IBOutlet weak var trainLocationPickerView: UIPickerView!
    @IBOutlet weak var trainingItemTableView: UITableView!
    @IBOutlet weak var removedTrainingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        trainLocationPickerView.delegate = self
        trainLocationPickerView.dataSource = self
        trainingItemTableView.delegate = self
        trainingItemTableView.dataSource = self
        removedTrainingTableView.delegate = self
        removedTrainingTableView.dataSource = self
        loadTheTrainList()
//        trainingItemTableView.setEditing(true, animated: false)
    }
    

    func trainingItemCoreDataStore (_ selected: Int,_ imageurl: String,_ itemname: String,_ itemdef: String,_ itemid: Int ) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            switch selected{
            case 1:
                brestData = BrestItem(context: appDelegate.persistentContainer.viewContext)
                brestData.name = itemname
                brestData.def = itemdef
                brestData.id = Int16(itemid)
                brestData.image = imageurl
            case 2:
                backData = BackItem(context: appDelegate.persistentContainer.viewContext)
                backData.name = itemname
                backData.def = itemdef
                backData.id = Int16(itemid)
                backData.image = imageurl
                
            case 3:
                blData = BLItem(context: appDelegate.persistentContainer.viewContext)
                blData.name = itemname
                blData.def = itemdef
                blData.id = Int16(itemid)
                blData.image = imageurl
                
            case 4:
                abdomenData = AbdomenItem(context: appDelegate.persistentContainer.viewContext)
                abdomenData.name = itemname
                abdomenData.def = itemdef
                abdomenData.id = Int16(itemid)
                abdomenData.image = imageurl
                
            case 5:
                
                armData = ArmItem(context: appDelegate.persistentContainer.viewContext)
                armData.name = itemname
                armData.def = itemdef
                armData.id = Int16(itemid)
                armData.image = imageurl
                
            case 6:
                exerciseData = ExerciseItem(context: appDelegate.persistentContainer.viewContext)
                exerciseData.name = itemname
                exerciseData.def = itemdef
                exerciseData.id = Int16(itemid)
                exerciseData.image = imageurl
                
         
            default:
                print("CoreData store select is wrong")
            }
            appDelegate.saveContext()
        }
    }
    func userTrainingItemCoreDataStore (_ selected: Int,_ imageurl: String,_ itemname: String,_ itemdef: String,_ itemid: Int ) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            switch selected{
            case 1:
                uBrestData = UBrestItem(context: appDelegate.persistentContainer.viewContext)
                uBrestData.name = itemname
                uBrestData.def = itemdef
                uBrestData.id = Int16(itemid)
                uBrestData.image = imageurl
                
            case 2:
                uBackData = UBackItem(context: appDelegate.persistentContainer.viewContext)
                uBackData.name = itemname
                uBackData.def = itemdef
                uBackData.id = Int16(itemid)
                uBackData.image = imageurl
                
            case 3:
                uBLData = UBLItem(context: appDelegate.persistentContainer.viewContext)
                uBLData.name = itemname
                uBLData.def = itemdef
                uBLData.id = Int16(itemid)
                uBLData.image = imageurl
                
            case 4:
                uAbdomenData = UAbdomenItem(context: appDelegate.persistentContainer.viewContext)
                uAbdomenData.name = itemname
                uAbdomenData.def = itemdef
                uAbdomenData.id = Int16(itemid)
                uAbdomenData.image = imageurl
                
            case 5:
                
                uArmData = UArmItem(context: appDelegate.persistentContainer.viewContext)
                uArmData.name = itemname
                uArmData.def = itemdef
                uArmData.id = Int16(itemid)
                uArmData.image = imageurl
                
            case 6:
                uExData = UExerciseItem(context: appDelegate.persistentContainer.viewContext)
                uExData.name = itemname
                uExData.def = itemdef
                uExData.id = Int16(itemid)
                uExData.image = imageurl
                
            default:
                print("CoreData store select is wrong")
            }
            appDelegate.saveContext()
        }
    }
    func clearCoreData(){
        switch trainLS {
        case 1:
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                for x in beforeBrestData{
                context.delete(x)
                }
                appDelegate.saveContext()
            }
        case 2:
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                for x in beforeBackData{
                context.delete(x)
                }
                appDelegate.saveContext()
            }
        case 3:
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                for x in beforeAbdomenData{
                context.delete(x)
                }
                appDelegate.saveContext()
            }
        case 4:
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                for x in beforeBLData{
                context.delete(x)
                }
                appDelegate.saveContext()
            }
        case 5:
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                for x in beforeArmData{
                context.delete(x)
                }
                appDelegate.saveContext()
            }
        case 6:
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                for x in beforeExerciseData{
                context.delete(x)
                }
                appDelegate.saveContext()
            }
        default:
            print("CoreData delete error")
        }
        
    }
    var backImageURLs:[String] = []
    func loadTheTrainList(){
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        // Fetch data from data store Brest
        let fetchRequest: NSFetchRequest<BrestItem> = BrestItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    beforeBrestData = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< beforeBrestData.count{
            formListBrest.append(beforeBrestData[x].name!)
            trainBrestText.append(beforeBrestData[x].def!)
            brestImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent("\(beforeBrestData[x].image!)")) as Data)!)
        }
        
        // Fetch data from data store Back
        
        let fetchRequestback: NSFetchRequest<BackItem> = BackItem.fetchRequest()
        let sortDescriptorback = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestback.sortDescriptors = [sortDescriptorback]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerback = NSFetchedResultsController(fetchRequest: fetchRequestback, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerback.delegate = self
            
            do {
                try fetchResultControllerback.performFetch()
                if let fetchedObjects = fetchResultControllerback.fetchedObjects {
                    beforeBackData = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< beforeBackData.count{
            formListBack.append(beforeBackData[x].name!)
            trainBackText.append(beforeBackData[x].def!)
            backImageURLs.append(beforeBackData[x].image!)
            backImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeBackData[x].image!) ) as Data)!)
        }
        // Fetch data from data store Abdomen
        
        let fetchRequestabdomen: NSFetchRequest<AbdomenItem> = AbdomenItem.fetchRequest()
        let sortDescriptorabdomen = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestabdomen.sortDescriptors = [sortDescriptorabdomen]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerabdomen = NSFetchedResultsController(fetchRequest: fetchRequestabdomen, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerabdomen.delegate = self
            
            do {
                try fetchResultControllerabdomen.performFetch()
                if let fetchedObjects = fetchResultControllerabdomen.fetchedObjects {
                    beforeAbdomenData = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< beforeAbdomenData.count{
            formListAbdomen.append(beforeAbdomenData[x].name!)
            trainAbdomenText.append(beforeAbdomenData[x].def!)
            
            abdomenImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeAbdomenData[x].image!)) as Data)!)
            
        }
        // Fetch data from data store Bottom
        
        let fetchRequestbl: NSFetchRequest<BLItem> = BLItem.fetchRequest()
        let sortDescriptorbl = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestbl.sortDescriptors = [sortDescriptorbl]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerbl = NSFetchedResultsController(fetchRequest: fetchRequestbl, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerbl.delegate = self
            
            do {
                try fetchResultControllerbl.performFetch()
                if let fetchedObjects = fetchResultControllerbl.fetchedObjects {
                    beforeBLData = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< beforeBLData.count{
            formListBL.append(beforeBLData[x].name!)
            trainBLText.append(beforeBLData[x].def!)
            blImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeBLData[x].image!) ) as Data)!)
            
        }
        // Fetch data from data store Arm
        
        let fetchRequestarm: NSFetchRequest<ArmItem> = ArmItem.fetchRequest()
        let sortDescriptorarm = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestarm.sortDescriptors = [sortDescriptorarm]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerarm = NSFetchedResultsController(fetchRequest: fetchRequestarm, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerarm.delegate = self
            
            do {
                try fetchResultControllerarm.performFetch()
                if let fetchedObjects = fetchResultControllerarm.fetchedObjects {
                    beforeArmData = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< beforeArmData.count{
            formListArm.append(beforeArmData[x].name!)
            trainArmText.append(beforeArmData[x].def!)
            armImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeArmData[x].image!) ) as Data)!)
            
        }
        // Fetch data from data store Exercise
        
        let fetchRequestexercise: NSFetchRequest<ExerciseItem> = ExerciseItem.fetchRequest()
        let sortDescriptorexercise = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestexercise.sortDescriptors = [sortDescriptorexercise]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerex = NSFetchedResultsController(fetchRequest: fetchRequestexercise, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerex.delegate = self
            
            do {
                try fetchResultControllerex.performFetch()
                if let fetchedObjects = fetchResultControllerex.fetchedObjects {
                    beforeExerciseData = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< beforeExerciseData.count{
            formListEx.append(beforeExerciseData[x].name!)
            trainExText.append(beforeExerciseData[x].def!)
            exerciseImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeExerciseData[x].image!) ) as Data)!)
            
        }
        
        
        // Fetch data from data store Brest
        let fetchRequestuB: NSFetchRequest<UBrestItem> = UBrestItem.fetchRequest()
        let sortDescriptoruB = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestuB.sortDescriptors = [sortDescriptoruB]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControlleruB = NSFetchedResultsController(fetchRequest: fetchRequestuB, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControlleruB.delegate = self
            
            do {
                try fetchResultControlleruB.performFetch()
                if let fetchedObjects = fetchResultControlleruB.fetchedObjects {
                    uBrestDatas = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< uBrestDatas.count {
            formListBrestu.append(uBrestDatas[x].name!)
            trainBrestTextu.append(uBrestDatas[x].def!)
            brestImageformsu.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(uBrestDatas[x].image!) ) as Data)!)
        }
        // Fetch data from data store Back
        let fetchRequestUback: NSFetchRequest<UBackItem> = UBackItem.fetchRequest()
        let sortDescriptorUback = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestUback.sortDescriptors = [sortDescriptorUback]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerUback = NSFetchedResultsController(fetchRequest: fetchRequestUback, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerUback.delegate = self
            
            do {
                try fetchResultControllerUback.performFetch()
                if let fetchedObjects = fetchResultControllerUback.fetchedObjects {
                    uBackDatas = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< uBackDatas.count {
            formListBacku.append(uBackDatas[x].name!)
            trainBackTextu.append(uBackDatas[x].def!)
            backImageformsu.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(uBackDatas[x].image!) ) as Data)!)
        }
        // Fetch data from data store Abdomen
        let fetchRequestUabdomen: NSFetchRequest<UAbdomenItem> = UAbdomenItem.fetchRequest()
        let sortDescriptorUabdomen = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestUabdomen.sortDescriptors = [sortDescriptorUabdomen]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerUabdomen = NSFetchedResultsController(fetchRequest: fetchRequestUabdomen, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerUabdomen.delegate = self
            
            do {
                try fetchResultControllerUabdomen.performFetch()
                if let fetchedObjects = fetchResultControllerUabdomen.fetchedObjects {
                    uAbdomenDatas = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< uAbdomenDatas.count {
            formListAbdomenu.append(uAbdomenDatas[x].name!)
            trainAbdomenTextu.append(uAbdomenDatas[x].def!)
            abdomenImageformsu.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(uAbdomenDatas[x].image!) ) as Data)!)
        }
        // Fetch data from data store Bottom
        let fetchRequestUbl: NSFetchRequest<UBLItem> = UBLItem.fetchRequest()
        let sortDescriptorUbl = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestUbl.sortDescriptors = [sortDescriptorUbl]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerUbl = NSFetchedResultsController(fetchRequest: fetchRequestUbl, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerUbl.delegate = self
            
            do {
                try fetchResultControllerUbl.performFetch()
                if let fetchedObjects = fetchResultControllerUbl.fetchedObjects {
                    uBLDatas = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< uBLDatas.count {
            formListBLu.append(beforeBLData[x].name!)
            trainBLTextu.append(beforeBLData[x].def!)
            blImageformsu.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeBLData[x].image!) ) as Data)!)
            
        }
        // Fetch data from data store Arm
        let fetchRequestUarm: NSFetchRequest<UArmItem> = UArmItem.fetchRequest()
        let sortDescriptorUarm = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestUarm.sortDescriptors = [sortDescriptorUarm]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerUarm = NSFetchedResultsController(fetchRequest: fetchRequestUarm, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerUarm.delegate = self
            
            do {
                try fetchResultControllerUarm.performFetch()
                if let fetchedObjects = fetchResultControllerUarm.fetchedObjects {
                    uArmDatas = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< uArmDatas.count {
            formListArmu.append(uArmDatas[x].name!)
            trainArmTextu.append(uArmDatas[x].def!)
            armImageformsu.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(uArmDatas[x].image!) ) as Data)!)
        }
        // Fetch data from data store Exercise
        
        let fetchRequestUexercise: NSFetchRequest<UExerciseItem> = UExerciseItem.fetchRequest()
        let sortDescriptorUexercise = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestUexercise.sortDescriptors = [sortDescriptorUexercise]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerUex = NSFetchedResultsController(fetchRequest: fetchRequestUexercise, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerUex.delegate = self
            
            do {
                try fetchResultControllerUex.performFetch()
                if let fetchedObjects = fetchResultControllerUex.fetchedObjects {
                    uExDatas = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        for x in 0 ..< uExDatas.count {
            formListExu.append(uExDatas[x].name!)
            trainExTextu.append(uExDatas[x].def!)
            exerciseImageformsu.append(UIImage(data: try! NSData.init(contentsOf: URL(fileURLWithPath: uExDatas[x].image!)) as Data)!)
        }
    }
}

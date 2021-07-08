//
//  ViewController.swift
//  Training Record
//  5/12  利用UIPickViewControl來做運動選單，此運動選單以變數來分類，此變數用來調整運動的部位，根據運動部位不同訓練項目也不同，目前想增加能夠手動增加運動項目的功能。
//  5/29 利用coredata存新元件資訊，然後原先設定的元件資訊以預設的陣列達成，並且在開啟app時，將coredata的元件導入現有陣列。
//  Created by 邱宣策 on 2021/5/7.
//

import UIKit
import CoreData

class TrainRecordHomeVC: UIViewController , UIPickerViewDataSource,UIPickerViewAccessibilityDelegate, NSFetchedResultsControllerDelegate{
   
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


    // MARK: Train's setting
    var trainWeight : Int = 10
    var trainSet : Int = 3
    var trainSetCount : Int = 10
    var trainEachSetInterval : Int = 30
    var trainSetEachInterval : Double = 1
    
    
    
    // MARK: TrainItem's Image
    let homeImage = UIImage(named: "homechicken")
    let BrestPush = UIImage(named: "Brest push machine")!
    let noColor = UIImage(named: "nocolor")
    let backPull = UIImage(named: "BackPull")
    let rowingMaching = UIImage(named: "RowingMachine")
    let seatingRow = UIImage(named: "SeatedRow")
    let dumbbell = UIImage(named: "Dumbbell")
    let barbell = UIImage(named: "Barbell")
    let backmachine = UIImage(named:"backmachine")
    let halfrack = UIImage(named: "halfrack")
    let absmachine = UIImage(named: "absmachine")
    let armmachine = UIImage(named: "armmachine")
    let runmachine = UIImage(named: "runmachine")
    var homeImageView : UIImageView?
    var brestImageform : [UIImage] = []
    var backImageform : [UIImage] = []
    var blImageform : [UIImage] =  []
    var abdomenImageform : [UIImage] = []
    var armImageform : [UIImage] = []
    var exerciseImageform : [UIImage] = []
    // MARK: TrainItem's list
    var formListLocation : [String] = ["運動部位", "肩胸部","背部", "臀腿部", "核心", "手臂","有氧運動"]
    var formListBrest : [String] = [ "訓練項目", "胸部推舉機"]
    var formListBL : [String] = [ "訓練項目", "深蹲"]
    var formListAbdomen : [String] = [ "訓練項目", "腹部訓練機"]
    var formListArm : [String] = [ "訓練項目", "二頭彎舉機"]
    var formListEx : [String] = [ "訓練項目", "跑步機"]
    var formListBack : [String] = [ "訓練項目", "高拉背部訓練機","坐式划船機","槓鈴划船","啞鈴划船"]
    var trainBrestText:[String] = [ "", "訓練目標：前三角肌,胸大肌,三頭肌",]
    var trainBackText:[String] = [ "","訓練目標：闊背肌、大小圓肌、菱形肌、後三角肌","訓練目標：闊背肌、大小圓肌、菱形肌、後三角肌","訓練目標：闊背肌、大小圓肌、菱形肌、後三角肌","訓練目標：闊背肌、大小圓肌、菱形肌、後三角肌","訓練目標：脊立住肌"]
    var trainBLText:[String] = ["", "訓練目標：股四頭、股二頭、臀大肌、小腿肌群",]
    var trainAbdomenText:[String] = ["", "訓練目標：上中段腹直肌",]
    var trainArmText:[String] = ["", "訓練目標：二頭肌",]
    var trainExText:[String] = ["", "訓練目標：心肺",]
    var newFormList : [Array<String>] = [[]]
    var newFormListDef : [Array<String>] = [[]]
    
    
   // MARK: Prepare for recording start
    var trainLS = [0,0] // trainLocationSelection Used to choose the training location
   
    let pauseAndplayImageButton = UIButton()
    let countdownTV = UITextView()
    let stopImageButton = UIButton()
    var countDownCounter = 5
    var trainIsStart = false
    var data : [RecordItem] = []
    
    
    
    
    // MARK: PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if trainLS[0] == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return formListLocation.count
        }
        else if component == 1 {
            switch trainLS[0]{
            case 1:
                return formListBrest.count
            case 2:
                return formListBack.count
            case 3:
                return formListBL.count
            case 4:
                return formListAbdomen.count
            case 5:
                return formListArm.count
            case 6:
                return formListEx.count
            default:
                return 0
            }
            
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component:Int)-> String?{
        if component == 0{
            return formListLocation[row]
        }
        else if component == 1 {
            switch trainLS[0] {
            case 1:
                return formListBrest[row]
                
            case 2:
                return formListBack[row]
                
            case 3:
                return formListBL[row]
            case 4:
                return formListAbdomen[row]
            case 5:
                return formListArm[row]
            case 6:
                return formListEx[row]
            default:
                return nil
            }
            
        }
        
        return nil
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0 {
            switch row {
            case 1:
                print(formListLocation[row])
                trainLS[0] = 1
                pickerView.reloadAllComponents()
                
            case 2:
                print(formListLocation[row])
                trainLS[0] = 2
                pickerView.reloadAllComponents()
            case 3:
                trainLS[0] = 3
                pickerView.reloadAllComponents()
            case 4:
                trainLS[0] = 4
                pickerView.reloadAllComponents()
            case 5:
                trainLS[0] = 5
                pickerView.reloadAllComponents()
            case 6:
                trainLS[0] = 6
                pickerView.reloadAllComponents()
            default:
                print("title")
                trainLS[0] = 0
                DefinitionTV.text = ""
                pickerView.reloadAllComponents()
                
            }}
        else if component == 1{
            switch trainLS[0] {  //trainLS tranin location
            case 1:    //Brest
                trainLS[1]=row
                if row == 0 {
                    DefinitionTV.text = ""
                    trainLS[0] = 0
                    homeImageViewGen()
                    pickerView.reloadAllComponents()
                }else{
                homeImageView?.removeFromSuperview()
                
                    
                }
                DefinitionTV.text = trainBrestText[row]
                trainImageView.image = brestImageform[row]
                
                
                
            case 2:   //Back
                trainLS[1]=row
                if row == 0 {
                    DefinitionTV.text = ""
                    trainLS[0] = 0
                    pickerView.reloadAllComponents()
                    homeImageViewGen()
                }else{
                    homeImageView?.removeFromSuperview()
                    
                        
                    }
                
                DefinitionTV.text = trainBackText[row]
                trainImageView.image = backImageform[row]
                
            case 3:   //Bottom Lap
                trainLS[1]=row
                if row == 0 {
                    DefinitionTV.text = ""
                    trainLS[0] = 0
                    pickerView.reloadAllComponents()
                    homeImageViewGen()
                }else{
                    homeImageView?.removeFromSuperview()
                    
                        
                    }
                
                DefinitionTV.text = trainBLText[row]
                trainImageView.image = blImageform[row]
                
            case 4:   //Abodmen
                trainLS[1]=row
                if row == 0 {
                    DefinitionTV.text = ""
                    trainLS[0] = 0
                    pickerView.reloadAllComponents()
                    homeImageViewGen()
                }else{
                    homeImageView?.removeFromSuperview()
                    
                        
                    }
                
                DefinitionTV.text = trainAbdomenText[row]
                trainImageView.image = abdomenImageform[row]
                
            case 5: //Arm
                trainLS[1]=row
                if row == 0 {
                    DefinitionTV.text = ""
                    trainLS[0] = 0
                    pickerView.reloadAllComponents()
                    homeImageViewGen()
                }else{
                    homeImageView?.removeFromSuperview()
                    
                        
                    }
                
                DefinitionTV.text = trainArmText[row]
                trainImageView.image = armImageform[row]
                
            case 6: //excerise
                trainLS[1]=row
                if row == 0 {
                    DefinitionTV.text = ""
                    trainLS[0] = 0
                    pickerView.reloadAllComponents()
                    homeImageViewGen()
                }else{
                    homeImageView?.removeFromSuperview()
                    
                        
                    }
                
                DefinitionTV.text = trainExText[row]
                trainImageView.image = exerciseImageform[row]
                
                
            default:
                print("")
            }
            
            
            
            
            
            
            
            
            
            
        }
        
    }
    

    @IBOutlet weak var DefinitionTV: UITextView!
    
    @IBOutlet weak var trainImageView: UIImageView!
    
    
    @IBOutlet weak var TrainPickerView: UIPickerView!
    
     func homeImageViewGen () {
        let imageView = UIImageView(image: self.homeImage)
        homeImageView = imageView
        self.view.addSubview(homeImageView!)
        homeImageView!.frame = CGRect(x: 106, y: 103, width: 163, height: 141)
        homeImageView!.contentMode = .scaleAspectFit //把圖片縮在你指定的大小
        homeImageView!.clipsToBounds = true
        
        
        homeImageView!.translatesAutoresizingMaskIntoConstraints = false
        
        homeImageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint(item: homeImageView!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.6, constant: 1).isActive = true
    }
   
    func DefaultFormEditor(){
        
        let textDefault : String = "\n訓練重量：\(trainWeight)kg。\n訓練組數：\(trainSet)組。\n每組次數：\(trainSetCount)下。\n每下間隔：\(trainEachSetInterval)秒。\n每組間隔：\(trainSetEachInterval)秒。"
        
        let listBrest : [String] = [ "訓練項目", "胸部推舉機"]
        let listBL : [String] = [ "訓練項目", "深蹲"]
        
        let listAbdomen : [String] = [ "訓練項目", "腹部訓練機"]
        let listArm : [String] = [ "訓練項目", "二頭彎舉機"]
        let listEx : [String] = [ "訓練項目", "跑步機"]
        let listBack : [String] = [ "訓練項目", "高拉背部訓練機","坐式划船機","槓鈴划船","啞鈴划船"]
        let brestText:[String] = [ "", "訓練目標：前三角肌,胸大肌,三頭肌\n\(textDefault)",]
        let backText:[String] = [ "","訓練目標：闊背肌、大小圓肌、菱形肌、後三角肌\n\(textDefault)","訓練目標：闊背肌、大小圓肌、菱形肌、後三角肌\n\(textDefault)","訓練目標：闊背肌、大小圓肌、菱形肌、後三角肌\n\(textDefault)","訓練目標：闊背肌、大小圓肌、菱形肌、後三角肌\n\(textDefault)","訓練目標：脊立住肌\n\(textDefault)"]
        let bLText:[String] = ["", "訓練目標：股四頭、股二頭、臀大肌、小腿肌群\n\(textDefault)",]
        let abdomenText:[String] = ["", "訓練目標：上中段腹直肌\n\(textDefault)",]
        let armText:[String] = ["", "訓練目標：二頭肌\n\(textDefault)",]
        let exText:[String] = ["", "訓練目標：心肺\n\(textDefault)",]
        formListBrest = listBrest
        formListBack = listBack
        formListBL = listBL
        formListAbdomen = listAbdomen
        formListArm = listArm
        formListEx = listEx
        trainBrestText = brestText
        trainBackText = backText
        trainBLText = bLText
        trainAbdomenText = abdomenText
        trainArmText = armText
        trainExText = exText
    
        brestImageform.append(noColor!)
        brestImageform.append(BrestPush)
        backImageform.append(noColor!)
        backImageform.append(backPull!)
        backImageform.append(seatingRow!)
        backImageform.append(barbell!)
        backImageform.append(dumbbell!)
        backImageform.append(backmachine!)
        abdomenImageform.append(noColor!)
        abdomenImageform.append(absmachine!)
        armImageform.append(noColor!)
        armImageform.append(armmachine!)
        blImageform.append(noColor!)
        blImageform.append(halfrack!)
        exerciseImageform.append(noColor!)
        exerciseImageform.append(runmachine!)
    
    
    
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TrainPickerView.delegate = self
        DefinitionTV.text = ""
        homeImageViewGen()
        DefaultFormEditor()
       
        
        
        
        
        // Fetch data from data store Brest
        var fetchResultController: NSFetchedResultsController<BrestItem>
        let fetchRequest: NSFetchRequest<BrestItem> = BrestItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
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
            if let trainImage = beforeBrestData[x].image {
                brestImageform.append( UIImage(data: trainImage as Data)!)
            }

       
        }
  
        // Fetch data from data store Back
        var fetchResultControllerback: NSFetchedResultsController<BackItem>!
        
        let fetchRequestback: NSFetchRequest<BackItem> = BackItem.fetchRequest()
        let sortDescriptorback = NSSortDescriptor(key: "name", ascending: true)
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
            if let trainImage = beforeBrestData[x].image {
                backImageform.append( UIImage(data: trainImage as Data)!)
            }
           
        }
        
        print(formListBack)
        // Fetch data from data store Abdomen
        var fetchResultControllerabdomen: NSFetchedResultsController<AbdomenItem>!
        
        let fetchRequestabdomen: NSFetchRequest<AbdomenItem> = AbdomenItem.fetchRequest()
        let sortDescriptorabdomen = NSSortDescriptor(key: "name", ascending: true)
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
            if let trainImage = beforeAbdomenData[x].image {
                abdomenImageform.append(UIImage(data: trainImage as Data)!)
            }
             
        }
        // Fetch data from data store Bottom
        var fetchResultControllerbl: NSFetchedResultsController<BLItem>!
        
        let fetchRequestbl: NSFetchRequest<BLItem> = BLItem.fetchRequest()
        let sortDescriptorbl = NSSortDescriptor(key: "name", ascending: true)
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
            if let trainImage = beforeBLData[x].image {
                blImageform.append(UIImage(data: trainImage as Data)!)
            }
            
        }
        // Fetch data from data store Exercise
        var fetchResultControllerex: NSFetchedResultsController<ExerciseItem>!
        
        let fetchRequestexercise: NSFetchRequest<ExerciseItem> = ExerciseItem.fetchRequest()
        let sortDescriptorexercise = NSSortDescriptor(key: "name", ascending: true)
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
            if let trainImage = beforeExerciseData[x].image {
                exerciseImageform.append(UIImage(data: trainImage as Data)!)
            }
        }
        // MARK: 先把資料抓出來確認是否為今天的資料，若為今天的資料便將資料存回今日，或非則將資料改至明日。
        loadFromFile()
        if let item = data.last {
            todayItem = item
        }
        // MARK: Save today's date
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let trainToday = dateFormatter.string(from: nowDate)
        print(trainToday)
        // MARK: Build a new todayItem, to check if it isn't a new today's item
        if todayItem.trainDate == " " {
            todayItem.trainDate = trainToday
        }else if todayItem.trainDate != trainToday{
//            todayItem = RecordItem(trainToday, <#T##traindateyesterday: String##String#>, [0], [])
            todayItem = RecordItem(trainToday, [0], [])
        }
        print(todayItem.trainDate, todayItem.trainTimes, todayItem.trainLocation)
        
        
        
    }
    
  
    //MARK: Archiving
    func writeToFile()  {
        //
        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
        let filePath = doc.appendingPathComponent("notes.archive")
        do {
            //將data陣列，轉成Data型式（二進位資料）
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.data, requiringSecureCoding: false)
            try data.write(to: filePath, options: .atomic)
        } catch  {
            print("error while saving to file \(error)")
        }
    }
    
    func loadFromFile()  {
        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
        let filePath = doc.appendingPathComponent("notes.archive")
        do {
        //載入成Data（二進位資料)
              let data =  try Data(contentsOf: filePath)
                //把資料轉成[Note]
              if let arrayData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [RecordItem]{
                self.data = arrayData//轉成功就放到self.data裏
              }
        } catch  {
            print("error while fetching data array \(error)")
            self.data = []//有任何錯誤,空陣列
        }
    }
    // MARK: Save Archiving after click the checklist button
    var todayItem = RecordItem(" ",[0], [])
    var recordTimesCount = 0
    // MARK: Start the Record
    @IBAction func trainStart(_ sender: UIButton) {
        print(trainLS)
        guard trainLS != [0,0]  && trainLS != [1,0] && trainLS != [2,0] && trainLS != [3,0] && trainLS != [4,0] && trainLS != [5,0] && trainLS != [6,0] else {
            let alertController = UIAlertController(title: "請選擇要訓練的部位", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        for view in self.view.subviews{
            view.isHidden = true
        }
        
        TimerUse.share.setTimer(1,self, #selector(CountDown), true,1)
        TimerUse.share.setTimer(6, self, #selector(CountTimeStart), false,2)
        
        
        todayItem.trainLocation.append(trainLS)
    
        
        
        
       
        let stopTrainBegin = UIAction(title: "stopTrainBegin"){(action) in
            self.stopImageButton.removeFromSuperview()
            self.pauseAndplayImageButton.removeFromSuperview()
            self.countdownTV.removeFromSuperview()
            TimerUse.share.stopTimer(1)
            TimerUse.share.stopTimer(2)
            self.countDownCounter = 5
            
            // MARK: build an alert activity to check the data if you want to record
            if self.todayItem.trainTimes[self.recordTimesCount] != 0 {
                let alertController = UIAlertController(title: "請確認是否儲存目前的訓練數值", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    print("OK")
                    let alertController = UIAlertController(title: "您完成了\(self.todayItem.trainTimes[self.recordTimesCount])次了！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                        
                        self.todayItem.trainTimes.append(0)
                        
                      
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    print("Cancel")
                    self.todayItem.trainTimes[self.recordTimesCount] = 0
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            for view in self.view.subviews{
                view.isHidden = false
            }
        }
        
        
        
        stopImageButton.addAction(stopTrainBegin, for: .touchUpInside)
        stopImageButton.setImage(UIImage(named: "stop"), for: .normal)
        self.view.addSubview(stopImageButton)
        stopImageButton.translatesAutoresizingMaskIntoConstraints = false
        stopImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint(item: stopImageButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.7, constant: 1).isActive = true

        

        
        

        
        
        
        
//        for view in self.view.subviews{
//            view.isHidden = false
//        }
    }
    

    
    
    @objc func CountTimeStart (){
        var isPlay = false
        let pauseTraining = UIAction(title: "pauseTraining"){(action) in
            if isPlay == false {
            self.pauseAndplayImageButton.setImage(UIImage(named: "play"), for: .normal)
            TimerUse.share.stopTimer(1)
                print(self.countDownCounter)
                isPlay = true
            }else{
                self.pauseAndplayImageButton.setImage(UIImage(named: "pause"), for: .normal)
                TimerUse.share.setTimer(self.trainSetEachInterval, self, #selector(self.CountTimer),true,1)
                isPlay = false
            }
            
        }
        
        pauseAndplayImageButton.addAction(pauseTraining, for: .touchUpInside)
        pauseAndplayImageButton.setImage(UIImage(named: "pause"), for: .normal)
        self.view.addSubview(pauseAndplayImageButton)
        pauseAndplayImageButton.translatesAutoresizingMaskIntoConstraints = false
        pauseAndplayImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint(item: pauseAndplayImageButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.4, constant: 1).isActive = true
        print(3)
    }
    
    

    @objc func CountDown() {
        if countDownCounter == 0{
            countdownTV.font = UIFont(name: "Helvetica-Light", size: 150)
            countdownTV.text = "開始"
        }else{
            countdownTV.font = UIFont(name: "Helvetica-Light", size: 200)
            countdownTV.text = "\(countDownCounter)"
        }
        
        countdownTV.textAlignment = .center
        countdownTV.textColor = .green
        countdownTV.isEditable = false
        countdownTV.isSelectable = false
        countdownTV.alwaysBounceHorizontal = true
        self.view.addSubview(countdownTV)
        countdownTV.translatesAutoresizingMaskIntoConstraints = false
        countdownTV.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        countdownTV.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        countdownTV.heightAnchor.constraint(equalToConstant: 234).isActive = true
        countdownTV.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
        
        if countDownCounter == 0 {
            countDownCounter = 1
            TimerUse.share.stopTimer(1)
            TimerUse.share.setTimer(trainSetEachInterval, self, #selector(CountTimer),true,1)
        }else{
            countDownCounter -= 1
        }
    }
    
    @objc func CountTimer(){
        countdownTV.font = UIFont(name: "Helvetica-Light", size: 200)
        countdownTV.text = "\(countDownCounter)"
        countdownTV.textAlignment = .center
        countdownTV.textColor = .red
        countdownTV.isEditable = false
        countdownTV.isSelectable = false
        countdownTV.alwaysBounceHorizontal = true

        
        todayItem.trainTimes[recordTimesCount] += 1
//        print(2)
        if countDownCounter == trainSetCount {
//            pauseAndplayImageButton.removeFromSuperview()
            countDownCounter = trainEachSetInterval
            TimerUse.share.stopTimer(1)
            if todayItem.trainTimes[recordTimesCount] == trainSet * trainSetCount{
                // MARK: alert training over show the traintimes
                print(todayItem.trainTimes)
                recordTimesCount += 1
                stopImageButton.removeFromSuperview()
                self.pauseAndplayImageButton.removeFromSuperview()
                self.countdownTV.removeFromSuperview()
                return
            }
            TimerUse.share.setTimer(1,self, #selector(CountTimeBreak), true,1)
            
            return
        }
        countDownCounter += 1
    }
    
    @objc func CountTimeBreak (){
        if countDownCounter == 0{
            countdownTV.font = UIFont(name: "Helvetica-Light", size: 150)
            countdownTV.text = "開始"
        }else{
            countdownTV.font = UIFont(name: "Helvetica-Light", size: 200)
            countdownTV.text = "\(countDownCounter)"
        }
        
        countdownTV.textAlignment = .center
        countdownTV.textColor = .green
        countdownTV.isEditable = false
        countdownTV.isSelectable = false
        countdownTV.alwaysBounceHorizontal = true

        
//        print(2)
        if countDownCounter == 0 {
//            pauseAndplayImageButton.removeFromSuperview()
            countDownCounter = 1
            TimerUse.share.stopTimer(1)
            TimerUse.share.setTimer(trainSetEachInterval,self, #selector(CountTimer), true,1)
            return
        }
        countDownCounter -= 1
    }
    
    
    // 用於連結至下一個ViewController
    override func prepare (for segue: UIStoryboardSegue, sender:Any?){
        if segue.identifier == "seague_vc_to_NewTrainItemVC"{
            let vc = segue.destination as! NewTrainingItemViewController
            vc.str = "hello"
        }
        else if segue.identifier == "seague_vc_to_ManageTrainSetVC"{
            
            
        }
    }
    var locationC : [Int] = [0,0,0,0,0,0]
    var formCounter = 0
    @IBAction func unwind(for segue: UIStoryboardSegue){
        if segue.identifier == "unwind_NewTrainItemVC_to_vc"{
            let vc = segue.source as! NewTrainingItemViewController


            print(vc.trainingItem)
            if vc.trainingItem != "" {


                newFormList.append([])
                newFormListDef.append([])

                newFormList[vc.trainLS-1].append(vc.trainingItem)
                newFormListDef[vc.trainLS-1].append(vc.trainingItemDef)
                switch vc.trainLS{
                case 1:
                    formListBrest.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainBrestText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        brestImageform.append(trainImage)
                    }
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                        brestData = BrestItem(context: appDelegate.persistentContainer.viewContext)
                        brestData.name = newFormList[vc.trainLS-1][locationC[vc.trainLS-1]]
                        brestData.def = newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]]
                        brestData.id = Int16(locationC[0])
                        if let brestImage = vc.imageView.image {
                            brestData.image = brestImage.pngData()
                        }
                        appDelegate.saveContext()
                    }
                    locationC[0] += 1

                case 2:

                    formListBack.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainBackText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        backImageform.append(trainImage)
                    }

                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                        backData = BackItem(context: appDelegate.persistentContainer.viewContext)
                        backData.name = newFormList[vc.trainLS-1][locationC[vc.trainLS-1]]
                        backData.def = newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]]
                        backData.id = Int16(locationC[1])
                        if let backImage = vc.imageView.image {
                            backData.image = backImage.pngData()
                        }
                        appDelegate.saveContext()
                    }
                    locationC[1] += 1
                case 3:
                    formListBL.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainBLText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        blImageform.append(trainImage)
                    }
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                        blData = BLItem(context: appDelegate.persistentContainer.viewContext)
                        blData.name = newFormList[vc.trainLS-1][locationC[vc.trainLS-1]]
                        blData.def = newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]]
                        blData.id = Int16(locationC[1])
                        if let bottomImage = vc.imageView.image {
                            blData.image = bottomImage.pngData()
                        }
                        appDelegate.saveContext()
                    }
                    locationC[2] += 1
                case 4:
                    formListAbdomen.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainAbdomenText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        abdomenImageform.append(trainImage)
                    }

                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                        abdomenData = AbdomenItem(context: appDelegate.persistentContainer.viewContext)
                        abdomenData.name = newFormList[vc.trainLS-1][locationC[vc.trainLS-1]]
                        abdomenData.def = newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]]
                        abdomenData.id = Int16(locationC[3])
                        if let abdomenImage = vc.imageView.image {
                            abdomenData.image = abdomenImage.pngData()
                        }
                        appDelegate.saveContext()
                    }
                    locationC[3] += 1
                case 5:

                    formListArm.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainArmText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        armImageform.append(trainImage)
                    }

                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                        armData = ArmItem(context: appDelegate.persistentContainer.viewContext)
                        armData.name = newFormList[vc.trainLS-1][locationC[vc.trainLS-1]]
                        armData.def = newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]]
                        armData.id = Int16(locationC[4])
                        if let armImage = vc.imageView.image {
                            armData.image = armImage.pngData()
                        }
                        appDelegate.saveContext()
                    }
                    locationC[4] += 1
                case 6:
                    formListEx.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainExText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        exerciseImageform.append(trainImage)
                    }
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                        exerciseData = ExerciseItem(context: appDelegate.persistentContainer.viewContext)
                        exerciseData.name = newFormList[vc.trainLS-1][locationC[vc.trainLS-1]]
                        exerciseData.def = newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]]
                        exerciseData.id = Int16(locationC[5])
                        if let exImage = vc.imageView.image {
                            exerciseData.image = exImage.pngData()
                        }
                        appDelegate.saveContext()
                    }
                    locationC[5] += 1
                default:
                    print("nothing added")
                }
            }

        }
         if segue.identifier == "unwind_ManageTrainSetVC_to_vc" {
            let vc = segue.source as! ManageTrainSetVC
            trainWeight = vc.trainWeight
            trainSet = vc.trainSet
            trainSetCount = vc.trainSetCount
            trainSetEachInterval = vc.trainSetEachInterval
            trainEachSetInterval = vc.trainEachSetInterval
            DefinitionTV.reloadInputViews()
            print(trainWeight)
            print(trainSet)
            print(trainSetCount)
            print(trainSetEachInterval)
            print(trainEachSetInterval)
        }
    }
    
}


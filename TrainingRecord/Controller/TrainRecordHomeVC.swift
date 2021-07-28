//
//  ViewController.swift
//  Training Record
//  5/12  利用UIPickViewControl來做運動選單，此運動選單以變數來分類，此變數用來調整運動的部位，根據運動部位不同訓練項目也不同，目前想增加能夠手動增加運動項目的功能。
//  5/29 利用coredata存新元件資訊，然後原先設定的元件資訊以預設的陣列達成，並且在開啟app時，將coredata的元件導入現有陣列。
//  Created by 邱宣策 on 2021/5/7.
//

import UIKit
import CoreData
import Firebase

class TrainRecordHomeVC: UIViewController , UIPickerViewDataSource,UIPickerViewDelegate, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate{
    
    // MARK: CoreData for TrainItem's List
    var brestData : BrestItem!
    var backData : BackItem!
    var abdomenData : AbdomenItem!
    var blData : BLItem!
    var exerciseData : ExerciseItem!
    var armData : ArmItem!
    var infoData : InfoItem!
    var beforeInfoData : [InfoItem] = []
    var beforeBrestData : [BrestItem] = []
    var beforeBackData : [BackItem] = []
    var beforeAbdomenData : [AbdomenItem] = []
    var beforeBLData : [BLItem] = []
    var beforeExerciseData : [ExerciseItem] = []
    var beforeArmData : [ArmItem] = []
    
    
    // MARK: Train's setting
    var trainWeight : Int = 10
    var trainSet : Int = 2
    var trainTimes : Int = 1
    var trainEachSetInterval : Int = 1
    var trainSetEachInterval : Float = 1
    
    
    
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
    var brestImageform : [UIImage] = [UIImage(named: "nocolor")!]
    var backImageform : [UIImage] = [UIImage(named: "nocolor")!]
    var blImageform : [UIImage] =  [UIImage(named: "nocolor")!]
    var abdomenImageform : [UIImage] = [UIImage(named: "nocolor")!]
    var armImageform : [UIImage] = [UIImage(named: "nocolor")!]
    var exerciseImageform : [UIImage] = [UIImage(named: "nocolor")!]
    // MARK: TrainItem's list
    var formListLocation : [String] = ["運動部位", "肩胸部","背部", "臀腿部", "核心", "手臂","有氧運動"]
    var formListBrest : [String] = [ "訓練項目"]
    var formListBL : [String] = [ "訓練項目"]
    var formListAbdomen : [String] = [ "訓練項目"]
    var formListArm : [String] = [ "訓練項目"]
    var formListEx : [String] = [ "訓練項目"]
    var formListBack : [String] = [ "訓練項目"]
    var trainBrestText:[String] = [ ""]
    var trainBackText:[String] = [ ""]
    var trainBLText:[String] = [""]
    var trainAbdomenText:[String] = [""]
    var trainArmText:[String] = [""]
    var trainExText:[String] = [""]
    var newFormList : [Array<String>] = [[]]
    var newFormListDef : [Array<String>] = [[]]
    
    
    // MARK: Prepare for recording start
    var trainLS = [0,0] // trainLocationSelection Used to choose the training location
    
    let pauseAndplayImageButton = UIButton()
    let countdownTV = UITextView()
    let stopImageButton = UIButton()
    var countDownCounter = 3
    var trainIsStart = false
    var data : [String: RecordItem] = [:]
    var trainToday = ""
    
    
    //MARK: firebase firestore used
    var db: Firestore!
    
    //MARK: Variable made for record list
    var recordLocation = ""
    var recordLocationItem = ""
    var recordDataList: [String:[RecordItem]]?
    var recordListString = ""
    var recordsort: [[Int]] = []
    
    //MARK:  Storage properties for new info
    var infodatainside: [String]? = []
    var beforeinfodatainside : [String]? = []
    
    
    // MARK: PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
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
                return 1
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
                return "訓練項目"
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
                trainLS[1] = 0
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                homeImageView!.isHidden = false
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
                
            case 2:
                print(formListLocation[row])
                trainLS[0] = 2
                trainLS[1] = 0
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                homeImageView!.isHidden = false
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
            case 3:
                trainLS[0] = 3
                trainLS[1] = 0
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                homeImageView!.isHidden = false
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
            case 4:
                trainLS[0] = 4
                trainLS[1]=0
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                homeImageView!.isHidden = false
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
            case 5:
                trainLS[0] = 5
                trainLS[1] = 0
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                homeImageView!.isHidden = false
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
            case 6:
                trainLS[0] = 6
                trainLS[1] = 0
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                homeImageView!.isHidden = false
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
            default:
                print("title")
                trainLS[0] = 0
                trainLS[1] = 0
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                homeImageView!.isHidden = false
                pickerView.reloadAllComponents()
                
            }}
        else if component == 1{
            switch trainLS[0] {  //trainLS tranin location
            case 1:    //Brest
                trainLS[1]=row
                if row == 0 {
                    definitionTV.text = ""
                    trainParametersTV.text = ""
                    homeImageView!.isHidden = false
                }else{
                    homeImageView!.isHidden = true
                    reloadTrainParameters()
                }
                definitionTV.text = trainBrestText[row]
                trainImageView.image = brestImageform[row]
                print(row)
                
                
            case 2:   //Back
                trainLS[1]=row
                if row == 0 {
                    definitionTV.text = ""
                    trainParametersTV.text = ""
                    homeImageView!.isHidden = false
                }else{
                    homeImageView!.isHidden = true
                    reloadTrainParameters()
                    
                }
                
                definitionTV.text = trainBackText[row]
                trainImageView.image = backImageform[row]
                
            case 3:   //Bottom Lap
                trainLS[1]=row
                if row == 0 {
                    definitionTV.text = ""
                    trainParametersTV.text = ""
                    homeImageView!.isHidden = false
                }else{
                    homeImageView!.isHidden = true
                    reloadTrainParameters()
                    
                }
                
                definitionTV.text = trainBLText[row]
                trainImageView.image = blImageform[row]
                
            case 4:   //Abodmen
                trainLS[1]=row
                if row == 0 {
                    definitionTV.text = ""
                    trainParametersTV.text = ""
                    homeImageView!.isHidden = false
                }else{
                    homeImageView!.isHidden = true
                    reloadTrainParameters()
                    
                }
                
                definitionTV.text = trainAbdomenText[row]
                trainImageView.image = abdomenImageform[row]
                
            case 5: //Arm
                trainLS[1]=row
                if row == 0 {
                    definitionTV.text = ""
                    trainParametersTV.text = ""
                    homeImageView!.isHidden = false
                }else{
                    homeImageView!.isHidden = true
                    reloadTrainParameters()
                    
                }
                
                definitionTV.text = trainArmText[row]
                trainImageView.image = armImageform[row]
                
            case 6: //excerise
                trainLS[1]=row
                if row == 0 {
                    definitionTV.text = ""
                    trainParametersTV.text = ""
                    homeImageView!.isHidden = false
                }else{
                    homeImageView!.isHidden = true
                    reloadTrainParameters()
                    
                }
                
                definitionTV.text = trainExText[row]
                trainImageView.image = exerciseImageform[row]
                
                
            default:
                print("")
            }
            
        }
        
    }
    
    
    @IBOutlet weak var definitionTV: UITextView!
    
    @IBOutlet weak var trainImageView: UIImageView!
    
    @IBOutlet weak var trainParametersTV: UITextView!
    
    @IBOutlet weak var TrainPickerView: UIPickerView!
    
    
    @IBOutlet weak var RecordListTV: UITableView!
    @IBOutlet weak var TrainDatePickerView: UIDatePicker!
    
    
    var dateRecord : String = ""
    
    
    @IBAction func TrainDatePicker(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateRecord = dateFormatter.string(from: sender.date)
        RecordListTV.reloadData()
        print(dateRecord)
        todayItem = RecordItem(trainToday,[:],[:],[],[:],[:])
        
    }
    
    @IBAction func BreakCounterBtn(_ sender: Any) {
    }
    
    // MARK: firestore load Data
    func loadData(_ location: String) {
        self.db.collection(location).getDocuments() { [self] (querySnapshot, error) in
            if let e = error {
                print("error \(e)")
            }
            guard let data = querySnapshot else {return}
            if location == "info"{
                for document in data.documents{
                    let item = InfoItemForFireStore()
                    item.ItemContent = document.data()["itemContent"] as? String
                    item.ItemID = document.documentID
                    if !(self.infodatainside?.contains(item.ItemContent!))!{
                        self.infodatainside?.append(item.ItemContent!)
                    }
                }
            }else{
            for document in data.documents{
                let item = TrainingItem()
                item.itemName = document.data()["itemName"] as? String
                item.itemDef = document.data()["itemDef"] as? String
                item.itemImage = document.data()["itemImage"] as? String
                item.itemNumber = document.data()["itemNumber"] as? String
                item.itemID = document.documentID
                switch location{
                case "BrestShoulder":
                    if !self.formListBrest.contains(item.itemName!){
                    self.formListBrest.append(item.itemName!)
                    self.trainBrestText.append(item.itemDef!)
                    }
                case "BottomLap":
                    if !self.formListBL.contains(item.itemName!){
                    self.formListBL.append(item.itemName!)
                    self.trainBLText.append(item.itemDef!)
                    }
                case "Arm":
                    if !self.formListArm.contains(item.itemName!){
                    self.formListArm.append(item.itemName!)
                    self.trainArmText.append(item.itemDef!)
                    }
                case "Back":
                    if !self.formListBack.contains(item.itemName!){
                    self.formListBack.append(item.itemName!)
                    self.trainBackText.append(item.itemDef!)
                    }
                case "Abdomen":
                    if !self.formListAbdomen.contains(item.itemName!){
                    self.formListAbdomen.append(item.itemName!)
                        self.trainAbdomenText.append(item.itemDef!)
                    }
                case "Exercise":
                    if !self.formListEx.contains(item.itemName!){
                    self.formListEx.append(item.itemName!)
                        self.trainExText.append(item.itemDef!)
                    }
                default:
                    print("type wrong")
                }
               }
            }
        }
        
    }
    func reloadTrainParameters(){
        let textDefault : String = "訓練重量：\(trainWeight)kg。\n此組次數：\(trainTimes)下。\n每下間隔：\(Float(Int(trainSetEachInterval*10))/10 )秒。"
        trainParametersTV.text = textDefault
    }
    
    func DownLoadTrainingItemImage(_ documentname: String, _ filename: String) {
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        let docUrl = homeUrl.appendingPathComponent("Documents")
        let doc2Url = docUrl.appendingPathComponent(documentname)
        let fileUrl = doc2Url.appendingPathComponent(filename)
        
        let storageRef = Storage.storage(url: "gs://trainingrecord-ad7d7.appspot.com/").reference()
        let imageRef = storageRef.child("\(documentname)/\(filename)")
        imageRef.write(toFile: fileUrl) { (url,error) in
            if let e = error {
                print( "error \(e)")
            } else {
                switch documentname {
                case "BrestShoulder":
                    self.brestImageform.append(UIImage(contentsOfFile: fileUrl.absoluteString)!)
                case "Back":
                    self.backImageform.append(UIImage(contentsOfFile: fileUrl.absoluteString)!)
                case "Abdomen":
                    self.abdomenImageform.append(UIImage(contentsOfFile: fileUrl.absoluteString)!)
                case "Arm":
                    self.armImageform.append(UIImage(contentsOfFile: fileUrl.absoluteString)!)
                case "BottomLap":
                    self.blImageform.append(UIImage(contentsOfFile: fileUrl.absoluteString)!)
                case "Exercise":
                    self.exerciseImageform.append(UIImage(contentsOfFile: fileUrl.absoluteString)!)
                default:
                    print("wrong type")
                }
                
            }
        }
    }
    
    
    func DefaultFormEditor(){
        loadData("Info")
        if formListBrest.count == 1{
            let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
            for x in trainLocationLoading{
                loadData(x)
            }
        }

        brestImageform.append(BrestPush)
        backImageform.append(backPull!)
        backImageform.append(seatingRow!)
        backImageform.append(barbell!)
        backImageform.append(dumbbell!)
        backImageform.append(backmachine!)
        abdomenImageform.append(absmachine!)
        armImageform.append(armmachine!)
        blImageform.append(halfrack!)
        exerciseImageform.append(runmachine!)
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TrainPickerView.delegate = self
        definitionTV.text = ""
        trainParametersTV.text = ""
        TrainPickerView.setValue(UIColor.white, forKey: "textColor")
        self.db = Firestore.firestore()
        let imageView = UIImageView(image: self.homeImage)
        homeImageView = imageView
        self.view.addSubview(homeImageView!)
        homeImageView!.frame = CGRect(x: 106, y: 103, width: 163, height: 141)
        homeImageView!.contentMode = .scaleAspectFit //把圖片縮在你指定的大小
        homeImageView!.clipsToBounds = true
        homeImageView!.translatesAutoresizingMaskIntoConstraints = false
        homeImageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        homeImageView!.bottomAnchor.constraint(equalTo: self.TrainPickerView.topAnchor, constant: -10).isActive = true
        loadTheTrainList()
        DefaultFormEditor()
        if formListBrest.count != 1{
        self.RecordListTV.dataSource = self
        self.RecordListTV.delegate = self
        }
        
        
        // MARK: 先把資料抓出來確認是否為今天的資料，若為今天的資料便將資料存回今日，或非則將資料改至明日。
        loadFromFile()
        print(data)
        
        
        // MARK: Save today's date
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        trainToday = dateFormatter.string(from: nowDate)
        print(trainToday)
        dateRecord = trainToday
        // MARK: Build a new todayItem, to check if it isn't a new today's item
        todayItem = RecordItem(trainToday,[:],[:],[],[:],[:])
        print(trainToday)
        print(data)
        
    }
    
    func manageStringArray(_ arraydata: [String]) -> [String]{
        var result : [String] = []
        for item in arraydata{
            result.append(item)
        }
        result.removeFirst()
        return result
    }
    func manageUIImageArray(_ arraydata: [UIImage]) -> [UIImage]{
        var result : [UIImage] = []
        for item in arraydata{
            result.append(item)
        }
        result.removeFirst()
        return result
    }
    func formlistCoredata (_ locationnumber: Int,_ namearray: [String], _ defarray: [String], _ imagearray: [UIImage]){

        let itemname: [String] = manageStringArray(namearray)
        let itemdef: [String] = manageStringArray(defarray )
        let itemimage: [UIImage] = manageUIImageArray(imagearray)
        
        for x in 0 ..< itemname.count {
        trainingItemCoreDataStore(locationnumber, itemimage[x], itemname[x], itemdef[x], x)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if formListBrest.count == 1{
            TimerUse.share.setTimer(5, self, #selector(setCoreDataStore), false, 1)
            self.RecordListTV.dataSource = self
            self.RecordListTV.delegate = self
        }
        print(formListBrest)
        
        
    }
    
    @objc func setCoreDataStore() {
        print(formListBrest)
        if beforeInfoData == [] || beforeInfoData.count != beforeinfodatainside?.count{
        formlistCoredata(1,formListBrest, trainBrestText, brestImageform)
        formlistCoredata(2,formListBack, trainBackText, backImageform)
        formlistCoredata(3, formListBL, trainBLText, blImageform)
        formlistCoredata(4, formListAbdomen, trainAbdomenText, abdomenImageform)
        formlistCoredata(5, formListArm, trainArmText, armImageform)
        formlistCoredata(6, formListEx, trainExText, exerciseImageform)
            for x in 0 ..< infodatainside!.count {
                trainingItemCoreDataStore(7, backImageform[x], infodatainside![x], infodatainside![x], x)
            }
        }
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
            if let arrayData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String:RecordItem]{
                self.data = arrayData//轉成功就放到self.data裏
            }
        } catch  {
            print("error while fetching data array \(error)")
            self.data = [:]//有任何錯誤,空陣列
        }
    }
    // MARK: Save Archiving after click the checklist button
    var todayItem : RecordItem?
    var recordTimesCount: [[Int]:Int] = [:]
    var checkmatrix : [[Int]:[Int]] = [:]
    var checkcount = 0
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
     
        
        let stopTrainBegin = UIAction(title: "stopTrainBegin"){(action) in
            self.stopImageButton.removeFromSuperview()
            self.pauseAndplayImageButton.removeFromSuperview()
            self.countdownTV.removeFromSuperview()
            TimerUse.share.stopTimer(1)
            TimerUse.share.stopTimer(2)
            self.countDownCounter = 3
            
            // MARK: build an alert activity to check the data if you want to record
            if self.recordTimesCount[self.trainLS] != 0 {
                            let alertController = UIAlertController(title: "請確認是否儲存目前的訓練數值", message: "", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                print("OK")
                                let alertController = UIAlertController(title: "您完成了\(self.fitRecordLocation(self.trainLS))中的\(self.fitRecordLocationItem(self.trainLS))的項目\(self.todayItem!.trainTimes[self.trainLS]![self.todayItem!.trainSet[self.trainLS]!-1])次了！請問您是否要紀錄，若要紀錄請選ＯＫ，不紀錄請Cancel，謝謝！", message: "", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                    print("OK")
                                    self.data.updateValue(self.todayItem!, forKey: self.dateRecord)
                                    self.writeToFile()
                                    }
                                alertController.addAction(okAction)
            
                                self.present(alertController, animated: true, completion: nil)
                            }
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                                print("Cancel")
//
                                if self.recordIsStart{
                                self.todayItem!.trainSet[self.trainLS]! -= 1
                                self.todayItem!.trainTimes[self.trainLS]!.removeLast()
                                self.todayItem!.trainWeight[self.trainLS]!.removeLast()
                                    self.recordTimesCount[self.trainLS]! -= 1
                                }
                            }
                            alertController.addAction(okAction)
                            alertController.addAction(cancelAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
            
            for view in self.view.subviews{
                view.isHidden = false
            }
            self.homeImageView?.isHidden = true
        }
        
        
        
        stopImageButton.addAction(stopTrainBegin, for: .touchUpInside)
        stopImageButton.setImage(UIImage(named: "stop"), for: .normal)
        self.view.addSubview(stopImageButton)
        stopImageButton.translatesAutoresizingMaskIntoConstraints = false
        stopImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint(item: stopImageButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.7, constant: 1).isActive = true
        
    }
    
    
    @objc func enablePause (){
        pauseAndplayImageButton.isEnabled = true
    }
    var isPauseImageExist: Bool = false
    func CountTimeStart (){
        TimerUse.share.stopTimer(2)
        var isPlay = false
        let pauseTraining = UIAction(title: "pauseTraining"){(action) in
            if isPlay == false {
                self.pauseAndplayImageButton.setImage(UIImage(named: "play"), for: .normal)
                TimerUse.share.setTimer(0.5, self, #selector(self.enablePause),false,2)
                self.pauseAndplayImageButton.isEnabled = false
                TimerUse.share.stopTimer(1)
                print(self.countDownCounter)
                isPlay = true
                return
            }else{
                self.pauseAndplayImageButton.setImage(UIImage(named: "pause"), for: .normal)
                TimerUse.share.setTimer(self.trainSetEachInterval, self, #selector(self.CountTimer),true,1)
                TimerUse.share.setTimer(0.5, self, #selector(self.enablePause),false,2)
                self.pauseAndplayImageButton.isEnabled = false
                isPlay = false
                return
            }
            
        }
        
        pauseAndplayImageButton.addAction(pauseTraining, for: .touchUpInside)
        pauseAndplayImageButton.setImage(UIImage(named: "pause"), for: .normal)
        if isPauseImageExist == false {
        self.view.addSubview(pauseAndplayImageButton)
        pauseAndplayImageButton.translatesAutoresizingMaskIntoConstraints = false
        pauseAndplayImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            NSLayoutConstraint(item: pauseAndplayImageButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.4, constant: 1).isActive = true
            print("pause item is generated")
            isPauseImageExist = true
        }
    }
    
    
    var recordIsStart : Bool = false
    @objc func CountDown() {
        
        if countDownCounter == 0{
            countdownTV.font = UIFont(name: "Helvetica-Light", size: 150)
            countdownTV.text = "開始"
        }else{
            countdownTV.font = UIFont(name: "Helvetica-Light", size: 200)
            countdownTV.text = "\(countDownCounter)"
        }
        countdownTV.backgroundColor = .black
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
            countDownCounter = 0
            TimerUse.share.stopTimer(1)
            if !recordIsStart {
                recordIsStart = true
            todayItem!.trainLocationSort.append(trainLS)
                todayItem!.trainLocation.updateValue(trainLS, forKey: trainLS)
            if let value = todayItem!.trainSet[trainLS] {
                todayItem!.trainSet[trainLS]! += 1
                print("add new value \(value)")
            }else {
                todayItem!.trainSet.updateValue(1, forKey: trainLS)
                print(todayItem!.trainSet)
            }
            if let value = todayItem!.trainTimes[trainLS] {
                todayItem!.trainTimes[trainLS]!.append(0)
                print("add new value \(value)")
            }else {
                todayItem!.trainTimes.updateValue([0], forKey: trainLS)
                print(todayItem!.trainTimes)
            }
            if let value = todayItem!.trainWeight[trainLS] {
                todayItem!.trainWeight[trainLS]!.append(trainWeight)
                print("add new value \(value)")
            }else {
                todayItem!.trainWeight.updateValue([trainWeight], forKey: trainLS)
                print(todayItem!.trainWeight)
            }
            if let value = recordTimesCount[trainLS]{
                recordTimesCount[trainLS]! += 1
                print("add RecordTimesCount \(value)")
            }else {
                recordTimesCount.updateValue(1, forKey: trainLS)
                print(recordTimesCount[trainLS]!)
            }
            }
            CountTimeStart()
            TimerUse.share.setTimer(trainSetEachInterval, self, #selector(CountTimer),true,1)
        }else{
            countDownCounter -= 1
        }
    }
    
    @IBAction func test(_ sender: Any) {
        
        print(data)
        
    }
    @objc func CountTimer(){
        countdownTV.font = UIFont(name: "Helvetica-Light", size: 200)
        
        countdownTV.textAlignment = .center
        countdownTV.textColor = .red
        countdownTV.isEditable = false
        countdownTV.isSelectable = false
        countdownTV.alwaysBounceHorizontal = true
        
        print("sum = \(trainTimes)")
        print(countDownCounter)
        print(todayItem!.trainTimes[trainLS])
        
        if countDownCounter == trainTimes {
            
            countDownCounter = trainEachSetInterval
            TimerUse.share.stopTimer(1)
            TimerUse.share.stopTimer(2)
            // MARK: alert training over show the traintimes
            let alertController = UIAlertController(title: "您完成了\(fitRecordLocation(trainLS))部位的\(fitRecordLocationItem(trainLS))訓練！若您不想紀錄，請點Cancel，謝謝！", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("OK")
                self.data.updateValue(self.todayItem!, forKey: self.dateRecord)
                print(self.trainToday)
                print(self.data)
                self.RecordListTV.reloadData()
                self.writeToFile()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel")
//                                self.todayItem.trainTimes[self.recordTimesCount] = 0
                
                self.todayItem!.trainSet[self.trainLS]! -= 1
                self.todayItem!.trainTimes[self.trainLS]!.removeLast()
                self.todayItem!.trainWeight[self.trainLS]!.removeLast()
                self.recordTimesCount[self.trainLS]! -= 1
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            print(todayItem!.trainTimes)
            stopImageButton.removeFromSuperview()
            isPauseImageExist = false
            self.pauseAndplayImageButton.removeFromSuperview()
            self.countdownTV.removeFromSuperview()
            for view in self.view.subviews{
                view.isHidden = false
            }
            self.homeImageView?.isHidden = true
            self.countDownCounter = 3
            self.recordIsStart = false
            return
        }
        countDownCounter += 1
        countdownTV.text = "\(countDownCounter)"
        todayItem!.trainTimes[trainLS]![todayItem!.trainSet[trainLS]!-1] += 1
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
            countDownCounter = 0
            TimerUse.share.stopTimer(1)
            TimerUse.share.setTimer(trainSetEachInterval,self, #selector(CountTimer), true,1)
            return
        }
        countDownCounter -= 1
    }
    
    
    // 用於連結至下一個ViewController
    override func prepare (for segue: UIStoryboardSegue, sender:Any?){
        if segue.identifier == "seague_vc_to_NewTrainItemVC"{
            
        }
        else if segue.identifier == "seague_vc_to_ManageTrainSetVC"{
            
        }
        // make for popover
        segue.destination.preferredContentSize = CGSize(width: 200, height: 400)
        segue.destination.popoverPresentationController?.delegate = self
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
        
    }
    
    
    func trainingItemCoreDataStore (_ selected: Int,_ imagedata: UIImage?,_ itemname: String,_ itemdef: String,_ itemid: Int ) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
        switch selected{
        case 1:
                brestData = BrestItem(context: appDelegate.persistentContainer.viewContext)
                brestData.name = itemname
                brestData.def = itemdef
                brestData.id = Int16(itemid)
                if let brestImage = imagedata {
                    brestData.image = brestImage.pngData()
                }
        case 2:
                backData = BackItem(context: appDelegate.persistentContainer.viewContext)
                backData.name = itemname
                backData.def = itemdef
                backData.id = Int16(itemid)
                if let backImage = imagedata {
                    backData.image = backImage.pngData()
                }
        case 3:
                blData = BLItem(context: appDelegate.persistentContainer.viewContext)
                blData.name = itemname
                blData.def = itemdef
                blData.id = Int16(itemid)
                if let bottomImage = imagedata {
                    blData.image = bottomImage.pngData()
                }
        case 4:
                abdomenData = AbdomenItem(context: appDelegate.persistentContainer.viewContext)
                abdomenData.name = itemname
                abdomenData.def = itemdef
                abdomenData.id = Int16(itemid)
                if let abdomenImage = imagedata {
                    abdomenData.image = abdomenImage.pngData()
                }
            
        case 5:

                armData = ArmItem(context: appDelegate.persistentContainer.viewContext)
                armData.name = itemname
                armData.def = itemdef
                armData.id = Int16(itemid)
                if let armImage = imagedata {
                    armData.image = armImage.pngData()
                }
            
        case 6:
                exerciseData = ExerciseItem(context: appDelegate.persistentContainer.viewContext)
                exerciseData.name = itemname
                exerciseData.def = itemdef
                exerciseData.id = Int16(itemid)
                if let exImage = imagedata {
                    exerciseData.image = exImage.pngData()
                }
        case 7:
                infoData = InfoItem(context: appDelegate.persistentContainer.viewContext)
                infoData.content = itemname
                infoData.id = Int16(itemid)
        default:
            print("CoreData store select is wrong")
        }
        appDelegate.saveContext()
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
                    
                    locationC[0] += 1
                    
                case 2:
                    
                    formListBack.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainBackText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        backImageform.append(trainImage)
                    }
                    trainingItemCoreDataStore(2, vc.imageView.image, newFormList[vc.trainLS-1][locationC[vc.trainLS-1]], newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]], locationC[1])
                    locationC[1] += 1
                case 3:
                    formListBL.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainBLText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        blImageform.append(trainImage)
                    }
                    trainingItemCoreDataStore(3, vc.imageView.image, newFormList[vc.trainLS-1][locationC[vc.trainLS-1]], newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]], locationC[2])
                    locationC[2] += 1
                case 4:
                    formListAbdomen.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainAbdomenText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        abdomenImageform.append(trainImage)
                    }
                    trainingItemCoreDataStore(4, vc.imageView.image, newFormList[vc.trainLS-1][locationC[vc.trainLS-1]], newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]], locationC[3])
                    locationC[3] += 1
                case 5:
                    
                    formListArm.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainArmText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        armImageform.append(trainImage)
                    }
                    trainingItemCoreDataStore(5, vc.imageView.image, newFormList[vc.trainLS-1][locationC[vc.trainLS-1]], newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]], locationC[4])
                    locationC[4] += 1
                case 6:
                    formListEx.append(newFormList[vc.trainLS-1][locationC[vc.trainLS-1]])
                    trainExText.append(newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]])
                    if let trainImage = vc.imageView.image {
                        exerciseImageform.append(trainImage)
                    }
                    
                    trainingItemCoreDataStore(6, vc.imageView.image, newFormList[vc.trainLS-1][locationC[vc.trainLS-1]], newFormListDef[vc.trainLS-1][locationC[vc.trainLS-1]], locationC[5])
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
            trainTimes = vc.trainTimes
            trainSetEachInterval = vc.trainSetEachInterval
            trainEachSetInterval = vc.trainEachSetInterval
            
            print(trainWeight)
            print(trainSet)
            print(trainTimes)
            print(trainSetEachInterval)
            print(trainEachSetInterval)
            if homeImageView?.isHidden == true {
                reloadTrainParameters()
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("a")
        
        data.updateValue(todayItem!, forKey: trainToday)
        writeToFile()
    }
    
}

extension TrainRecordHomeVC {
    func loadTheTrainList(){
        
        // Fetch data from data store Brest
        var fetchResultController: NSFetchedResultsController<BrestItem>
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
//                if let trainImage = beforeBrestData[x].image {
//                    brestImageform.append( UIImage(data: trainImage as Data)!)
//                }
          
        }
        
        // Fetch data from data store Back
        var fetchResultControllerback: NSFetchedResultsController<BackItem>!
        
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
//            if let trainImage = beforeBrestData[x].image {
//                backImageform.append( UIImage(data: trainImage as Data)!)
//            }
        }
        // Fetch data from data store Abdomen
        var fetchResultControllerabdomen: NSFetchedResultsController<AbdomenItem>!
        
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
//            if let trainImage = beforeAbdomenData[x].image {
//                abdomenImageform.append(UIImage(data: trainImage as Data)!)
//            }
        }
        // Fetch data from data store Bottom
        var fetchResultControllerbl: NSFetchedResultsController<BLItem>!
        
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
//            if let trainImage = beforeBLData[x].image {
//                blImageform.append(UIImage(data: trainImage as Data)!)
//            }
        }
        // Fetch data from data store Arm
        var fetchResultControllerarm: NSFetchedResultsController<ArmItem>!
        
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
//            if let trainImage = beforeBLData[x].image {
//                blImageform.append(UIImage(data: trainImage as Data)!)
//            }
        }
        // Fetch data from data store Exercise
        var fetchResultControllerex: NSFetchedResultsController<ExerciseItem>!
        
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
//            if let trainImage = beforeExerciseData[x].image {
//                exerciseImageform.append(UIImage(data: trainImage as Data)!)
//            }
        }
        
        // Fetch data from data store Info
        var fetchResultControllerInfo: NSFetchedResultsController<InfoItem>!
        
        let fetchRequestInfo: NSFetchRequest<InfoItem> = InfoItem.fetchRequest()
        let sortDescriptorInfo = NSSortDescriptor(key: "id", ascending: true)
        fetchRequestInfo.sortDescriptors = [sortDescriptorInfo]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultControllerInfo = NSFetchedResultsController(fetchRequest: fetchRequestInfo, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultControllerInfo.delegate = self
            
            do {
                try fetchResultControllerInfo.performFetch()
                if let fetchedObjects = fetchResultControllerInfo.fetchedObjects {
                    beforeInfoData = fetchedObjects
                }
            } catch {
                print(error)
            }
        }

        for x in 0 ..< beforeInfoData.count{
            beforeinfodatainside?.append(beforeInfoData[x].content!)
        }
        
    }
    
}


extension TrainRecordHomeVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(dateRecord)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data[dateRecord] != nil {
            return (data[dateRecord]?.trainLocation.count)!
        }
        return 0
    }
    
    
    func recordStringGen (_ traindate : String) -> [String]{
        var result: [String] = []
        
        
        if data[traindate] != nil {
            
            let locationsort = data[traindate]!.trainLocationSort
            var target : [[Int]] = []
            for x in locationsort {
                
                if !target.contains(x) {
                    target.append(x)
                }
                
                
            }
            
            
            
            
            for trainlocation in target{
                let recordstringdefault = "第\(1)組 \(data[traindate]!.trainWeight[trainlocation]![0]) 公斤 * \( data[traindate]!.trainTimes[trainlocation]![0]) 下"
                recordListString = recordstringdefault
                for itemSetCount in 1 ..< (data[traindate]?.trainSet[trainlocation])! {
                    let y = itemSetCount + 1
                    recordListString += "\n第\(y)組 \(data[traindate]!.trainWeight[trainlocation]![itemSetCount]) 公斤 * \(data[traindate]!.trainTimes[trainlocation]![itemSetCount]) 下"
                    
                }
                result.append(recordListString)
                recordsort.append(trainlocation)
            }
        }
        
        
        print("record String result = \(result)")
        
        return result
        
        
        
    }
    
    
    
    func recordLocationStringGen (_ traindate: String) -> [String] {
        var result: [String] = []
        var locationString = ""
        for x in recordsort {
            locationString = "\(fitRecordLocation(x))-\(fitRecordLocationItem(x))"
            result.append(locationString)
        }
        recordsort = []
        print("record location result = \(result)")
        return result
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainRecordCell" ,for: indexPath)
        print("tableview dateRecord = \(dateRecord)")
        if data[dateRecord] != nil {
            
            print("data is not nil")
            let detailLabelText = recordStringGen(dateRecord)[indexPath.row]
            let labelText = recordLocationStringGen(dateRecord)[indexPath.row]
            print(detailLabelText)
            print(labelText)
            cell.textLabel?.text =  labelText
            cell.detailTextLabel?.text = detailLabelText
            cell.showsReorderControl = true
            
            
            
            
            
        }
        
        
        return cell
    }
    
    
    func fitRecordLocation(_ locationdata: [Int]) -> String{
        switch locationdata[0] {
        case 1:
            return formListLocation[1]
        case 2:
            return formListLocation[2]
        case 3:
            return formListLocation[3]
        case 4:
            return formListLocation[4]
        case 5:
            return formListLocation[5]
        case 6:
            return formListLocation[6]
        default:
            return ""
        }
    }
    func fitRecordLocationItem(_ locationdata: [Int])  -> String {
        switch locationdata[0] {
        case 1:
            print(locationdata[1])
            print(formListBrest)
            return formListBrest[locationdata[1]]
        case 2:
            print(locationdata[1])
            print(formListBack)
            return formListBack[locationdata[1]]
        case 3:
            print(locationdata[1])
            print(formListBL)
            return formListBL[locationdata[1]]
        case 4:
            print(locationdata[1])
            print(formListAbdomen)
            return formListAbdomen[locationdata[1]]
        case 5:
            print(locationdata[1])
            print(formListArm)
            return formListArm[locationdata[1]]
        case 6:
            print(locationdata[1])
            print(formListEx)
            return formListEx[locationdata[1]]
        default:
            print(locationdata[1])
            print(formListBack)
            return ""
        }
    }
    
}


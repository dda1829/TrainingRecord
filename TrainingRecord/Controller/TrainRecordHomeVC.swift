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
    
    
    // MARK: Train's setting
    var trainWeight : Int = 10
    var trainSet : Int = 2
    var trainTimes : Int = 1
    var trainEachSetInterval : Int = 1
    var trainSetEachInterval : Float = 1
    var trainUnit: String = "Kg"
    
    
    // MARK: TrainItem's Image
    var homeImageView : UIImageView?
    let noColor = UIImage(named: "nocolor")!
    let homeImage = UIImage(named: "homechicken")
    var brestImageforms : [UIImage] = [UIImage(named: "nocolor")!]
    var backImageforms : [UIImage] = [UIImage(named: "nocolor")!]
    var blImageforms : [UIImage] =  [UIImage(named: "nocolor")!]
    var abdomenImageforms : [UIImage] = [UIImage(named: "nocolor")!]
    var armImageforms : [UIImage] = [UIImage(named: "nocolor")!]
    var exerciseImageform : [UIImage] = [UIImage(named: "nocolor")!]
    var brestImageURLs: [String] = []
    var backImageURLs: [String] = []
    var abdomenImageURLs: [String] = []
    var blImageURLs: [String] = []
    var armImageURLs: [String] = []
    var exImageURLs: [String] = []
    
    
    
    
    
    //MARK: Manage the TrainingItems
    var preBrestItems : [TrainingItem] = []
    var preBackItems : [TrainingItem] = []
    var preAbdomenItems : [TrainingItem] = []
    var preBLItems : [TrainingItem] = []
    var preArmItems : [TrainingItem] = []
    var preExItems : [TrainingItem] = []
    
    
    
    //MARK: User's adding TrainingItem
    var usersBrestItems : [TrainingItem] = []
    var usersBackItems : [TrainingItem] = []
    var usersAbdomenItems : [TrainingItem] = []
    var usersBLItems : [TrainingItem] = []
    var userArmItems : [TrainingItem] = []
    var userExItems : [TrainingItem] = []
    
    
    
    
    
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
    var dateRecord : String = ""
    var recordLocation = ""
    var recordLocationItem = ""
    var recordDataList: [String:[RecordItem]]?
    var recordListString = ""
    var recordsort: [[Int]] = []
    
    //MARK:  Storage properties for new info
    var infodatainside: [String] = []
    var beforeinfodatainside : [String] = []
    
    
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
                trainImageView.image = brestImageforms[row]
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
                trainImageView.image = backImageforms[row]
                
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
                trainImageView.image = blImageforms[row]
                
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
                trainImageView.image = abdomenImageforms[row]
                
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
                trainImageView.image = armImageforms[row]
                
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
    
    
    
    
    
    @IBAction func TrainDatePicker(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateRecord = dateFormatter.string(from: sender.date)
        RecordListTV.reloadData()
        print(dateRecord)
        if let recorddata = data[dateRecord] {
            todayItem = RecordItem(dateRecord, recorddata.trainSet, recorddata.trainTimes, recorddata.trainLocationSort, recorddata.trainWeight, recorddata.trainLocation,recorddata.trainUnit)
        }
        
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
                    item.ItemNumber = document.data()["itemNumber"] as? String
                    item.ItemID = document.documentID
                    if !(self.infodatainside.contains(item.ItemContent!)){
                        self.infodatainside.append(item.ItemContent!)
                        print(infodatainside)
                    }
                        if beforeinfodatainside.count != infodatainside.count {
                            let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
                            for x in trainLocationLoading{
                                loadData(x)
                            }
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
                
            }
        }
    }
    
    func trainingItemImageAppend(_ documentname: String, _ filename: String) {
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        let docUrl = homeUrl.appendingPathComponent("Documents")
        let doc2Url = docUrl.appendingPathComponent(documentname)
        let fileUrl = doc2Url.appendingPathComponent(filename)
        let a : NSData = try! NSData.init(contentsOf: fileUrl)
        let b = UIImage(data: a as Data)!
        switch documentname {
        case "BrestShoulder":
                    self.brestImageforms.append(b)
            print(fileUrl.absoluteString)
            self.brestImageURLs.append("Documents/\(documentname)/\(filename)")
            print(homeUrl.absoluteString)
                    print("Documents/\(documentname)/\(filename)")
        case "Back":
                    self.backImageforms.append(b)
                    self.backImageURLs.append("Documents/\(documentname)/\(filename)")
        case "Abdomen":
                    self.abdomenImageforms.append(b)
                    self.abdomenImageURLs.append("Documents/\(documentname)/\(filename)")
        case "Arm":
                    self.armImageforms.append(b)
                    self.armImageURLs.append("Documents/\(documentname)/\(filename)")
        case "BottomLap":
                    self.blImageforms.append(b)
                    self.blImageURLs.append("Documents/\(documentname)/\(filename)")
        case "Exercise":
                    self.exerciseImageform.append(b)
                    self.exImageURLs.append("Documents/\(documentname)/\(filename)")
        default:
            print("wrong type")
        }
    }
    
    
    func DefaultFormEditor(){
        loadData("info")
        if formListBrest.count == 1{
            let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
            for x in trainLocationLoading{
                loadData(x)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let notificationName = Notification.Name("GetUpdateNoti")
           NotificationCenter.default.addObserver(self, selector: #selector(getUpdateNoti(noti:)), name: notificationName, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        data.updateValue(todayItem!, forKey: trainToday)
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
            setImageFormListFromfirebase()
        }
       
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
        if let recorddata = data[dateRecord] {
            todayItem = RecordItem(dateRecord, recorddata.trainSet, recorddata.trainTimes, recorddata.trainLocationSort, recorddata.trainWeight, recorddata.trainLocation,recorddata.trainUnit)
        }else{
            todayItem = RecordItem(dateRecord,[:],[:],[],[:],[:],[:])
        }
        print(trainToday)
        print(data)
        
        
        
    }
    @objc func getUpdateNoti(noti:Notification) {
        trainUnit = noti.userInfo!["trainUnit"] as! String
       print(trainUnit)
    }
    
    func manageStringArray(_ arraydata: [String]) -> [String]{
        var result : [String] = []
        for item in arraydata{
            result.append(item)
        }
        result.removeFirst()
        return result
    }
//    func manageUIImageArray(_ arraydata: [String]) -> [String]{
//        var result : [UIImage] = []
//        for item in arraydata{
//            result.append(item)
//        }
//        return result
//    }
    func formlistCoredata (_ locationnumber: Int,_ namearray: [String], _ defarray: [String], _ imagearray: [String]){

        let itemname: [String] = manageStringArray(namearray)
        let itemdef: [String] = manageStringArray(defarray)
        let itemimage: [String] = imagearray
        
        for x in 0 ..< itemname.count {
        trainingItemCoreDataStore(locationnumber, itemimage[x], itemname[x], itemdef[x], x + 1)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DefaultFormEditor()
        if formListBrest.count == 1{
            TimerUse.share.setTimer(30, self, #selector(setCoreDataStore), false, 1)
            TimerUse.share.setTimer(5, self, #selector(downloadImageFormListFromfirebase), false, 2)
            TimerUse.share.setTimer(20, self, #selector(setImageFormListFromfirebase), false, 3)
            self.RecordListTV.dataSource = self
            self.RecordListTV.delegate = self
        }
        print(formListBrest)
        
        
    }
    
    @objc func setImageFormListFromfirebase() {
        let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
        for x in trainLocationLoading{
            switch x {
            case "BrestShoulder":
                for y in 1 ..< formListBrest.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            case "Back":
                for y in 1 ..< formListBack.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            case "Abdomen":
                for y in 1 ..< formListAbdomen.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            case "Arm":
                for y in 1 ..< formListArm.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            case "BottomLap":
                for y in 1 ..< formListBL.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            case "Exercise":
                for y in 1 ..< formListEx.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            default:
                print("Wrong Input")
            }
            
        }
    }
    @objc func downloadImageFormListFromfirebase() {
        let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
        for x in trainLocationLoading{
            switch x {
            case "BrestShoulder":
                for y in 1 ..< formListBrest.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            case "Back":
                for y in 1 ..< formListBack.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            case "Abdomen":
                for y in 1 ..< formListAbdomen.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            case "Arm":
                for y in 1 ..< formListArm.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            case "BottomLap":
                for y in 1 ..< formListBL.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            case "Exercise":
                for y in 1 ..< formListEx.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            default:
                print("Wrong Input")
            }
            
        }
    }
    
    
    
    @objc func setCoreDataStore() {
        print(formListBrest)
        if beforeInfoData == [] || infodatainside.count != beforeinfodatainside.count{
        formlistCoredata(1,formListBrest, trainBrestText, brestImageURLs)
        formlistCoredata(2,formListBack, trainBackText, backImageURLs)
        formlistCoredata(3, formListBL, trainBLText, blImageURLs)
        formlistCoredata(4, formListAbdomen, trainAbdomenText, abdomenImageURLs)
        formlistCoredata(5, formListArm, trainArmText, armImageURLs)
        formlistCoredata(6, formListEx, trainExText, exImageURLs)
            for x in 0 ..< infodatainside.count {
                trainingItemCoreDataStore(7, infodatainside[x], infodatainside[x], infodatainside[x], x)
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
                                self.todayItem?.trainSet[self.trainLS]! -= 1
                                self.todayItem?.trainTimes[self.trainLS]?.removeLast()
                                self.todayItem?.trainWeight[self.trainLS]?.removeLast()
                                    self.todayItem?.trainUnit[self.trainLS]?.removeLast()
                                self.recordTimesCount[self.trainLS]? -= 1
                                    self.recordIsStart = false
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
    func CountTimeStart (){

        self.view.addSubview(pauseAndplayImageButton)
        pauseAndplayImageButton.translatesAutoresizingMaskIntoConstraints = false
        pauseAndplayImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            NSLayoutConstraint(item: pauseAndplayImageButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.4, constant: 1).isActive = true
            print("pause item is generated")
            
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
                if let value = todayItem!.trainUnit[trainLS] {
                    todayItem!.trainUnit[trainLS]!.append(trainUnit)
                    print("add new value \(value)")
                }else {
                    todayItem!.trainUnit.updateValue([trainUnit], forKey: trainLS)
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
                self.todayItem!.trainUnit[self.trainLS]!.removeLast()
                self.recordTimesCount[self.trainLS]! -= 1
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            print(todayItem!.trainTimes)
            stopImageButton.removeFromSuperview()
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
            
        }else if segue.identifier == "Segue_Home_InfoVC" {
            let vc = segue.destination as! InfoTableViewController
            vc.infodata = infodatainside
        }
        // make for popover
        segue.destination.preferredContentSize = CGSize(width: 200, height: 400)
        segue.destination.popoverPresentationController?.delegate = self
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
        
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
                print(imageurl)
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
    
    
    
    
    var locationC : [Int] = [0,0,0,0,0,0]
    var formCounter = 0
    @IBAction func unwind(for segue: UIStoryboardSegue){
        if segue.identifier == "unwind_NewTrainItemVC_to_vc"{
            let vc = segue.source as! NewTrainingItemViewController

            if vc.trainingItem != "" {
                switch vc.trainLS{
                case 1:
                    formListBrest.append(vc.trainingItem)
                    trainBrestText.append(vc.trainingItemDef)
                    brestImageforms.append(UIImage(data: try! NSData.init(contentsOf: vc.imageURL!) as Data)!)
                    userTrainingItemCoreDataStore(vc.trainLS, vc.imageString!, vc.trainingItem, vc.trainingItemDef, locationC[0])
                    locationC[0] += 1
                    
                case 2:
                    
                    formListBack.append(vc.trainingItem)
                    trainBackText.append(vc.trainingItemDef)
                        backImageforms.append(UIImage(data: try! NSData.init(contentsOf: vc.imageURL!) as Data)!)
                    userTrainingItemCoreDataStore(vc.trainLS, vc.imageString!, vc.trainingItem, vc.trainingItemDef, locationC[0])
                    locationC[1] += 1
                case 3:
                    formListBL.append(vc.trainingItem)
                    trainBLText.append(vc.trainingItemDef)
                        blImageforms.append(UIImage(data: try! NSData.init(contentsOf: vc.imageURL!) as Data)!)
                    userTrainingItemCoreDataStore(vc.trainLS, vc.imageString!, vc.trainingItem, vc.trainingItemDef, locationC[0])
                    locationC[2] += 1
                case 4:
                    formListAbdomen.append(vc.trainingItem)
                    trainAbdomenText.append(vc.trainingItemDef)
                        abdomenImageforms.append(UIImage(data: try! NSData.init(contentsOf: vc.imageURL!) as Data)!)
                    userTrainingItemCoreDataStore(vc.trainLS, vc.imageString!, vc.trainingItem, vc.trainingItemDef, locationC[0])
                    locationC[3] += 1
                case 5:
                    
                    formListArm.append(vc.trainingItem)
                    trainArmText.append(vc.trainingItemDef)
                        armImageforms.append(UIImage(data: try! NSData.init(contentsOf: vc.imageURL!) as Data)!)
                    userTrainingItemCoreDataStore(vc.trainLS, vc.imageString!, vc.trainingItem, vc.trainingItemDef, locationC[0])
                    locationC[4] += 1
                case 6:
                    formListEx.append(vc.trainingItem)
                    trainExText.append(vc.trainingItemDef)
                        exerciseImageform.append(UIImage(data: try! NSData.init(contentsOf: vc.imageURL!) as Data)!)
                    userTrainingItemCoreDataStore(vc.trainLS, vc.imageString!, vc.trainingItem, vc.trainingItemDef, locationC[0])
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
        writeToFile()
    }
    
    func manageShowData(){
        
    }
    func loadTheTrainList(){
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
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
            brestImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent("\(beforeBrestData[x].image!)")) as Data)!)
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
            backImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeBackData[x].image!) ) as Data)!)
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
            
//            abdomenImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeAbdomenData[x].image!)) as Data)!)
            
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
            blImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeBLData[x].image!) ) as Data)!)
                        
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
            armImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeArmData[x].image!) ) as Data)!)
           
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
            exerciseImageform.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeExerciseData[x].image!) ) as Data)!)
                        
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
//            infodatainside.append(beforeInfoData[x].content!)
            beforeinfodatainside.append(beforeInfoData[x].content!)
        }
        
        // Fetch data from data store Brest
        var fetchResultControlleruB: NSFetchedResultsController<UBrestItem>
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
            formListBrest.append(uBrestDatas[x].name!)
            trainBrestText.append(uBrestDatas[x].def!)
            brestImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(uBrestDatas[x].image!) ) as Data)!)
        }
        // Fetch data from data store Back
        var fetchResultControllerUback: NSFetchedResultsController<UBackItem>!
        
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
            formListBack.append(uBackDatas[x].name!)
            trainBackText.append(uBackDatas[x].def!)
            backImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(uBackDatas[x].image!) ) as Data)!)
        }
        // Fetch data from data store Abdomen
        var fetchResultControllerUabdomen: NSFetchedResultsController<UAbdomenItem>!
        
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
            formListAbdomen.append(uAbdomenDatas[x].name!)
            trainAbdomenText.append(uAbdomenDatas[x].def!)
            abdomenImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(uAbdomenDatas[x].image!) ) as Data)!)
        }
        // Fetch data from data store Bottom
        var fetchResultControllerUbl: NSFetchedResultsController<UBLItem>!
        
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
            formListBL.append(beforeBLData[x].name!)
            trainBLText.append(beforeBLData[x].def!)
            blImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeBLData[x].image!) ) as Data)!)
                        
        }
        // Fetch data from data store Arm
        var fetchResultControllerUarm: NSFetchedResultsController<UArmItem>!
        
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
            formListArm.append(uArmDatas[x].name!)
            trainArmText.append(uArmDatas[x].def!)
            armImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(uArmDatas[x].image!) ) as Data)!)
        }
        // Fetch data from data store Exercise
        var fetchResultControllerUex: NSFetchedResultsController<UExerciseItem>!
        
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
            formListEx.append(uExDatas[x].name!)
            trainExText.append(uExDatas[x].def!)
            exerciseImageform.append(UIImage(data: try! NSData.init(contentsOf: URL(fileURLWithPath: uExDatas[x].image!)) as Data)!)
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
                let recordstringdefault = "第\(1)組 \(data[traindate]!.trainWeight[trainlocation]![0]) \(data[traindate]!.trainUnit[trainlocation]![0]) * \( data[traindate]!.trainTimes[trainlocation]![0]) 下"
                recordListString = recordstringdefault
                for itemSetCount in 1 ..< (data[traindate]?.trainSet[trainlocation])! {
                    let y = itemSetCount + 1
                    recordListString += "\n第\(y)組 \(data[traindate]!.trainWeight[trainlocation]![itemSetCount]) \(data[traindate]!.trainUnit[trainlocation]![itemSetCount]) * \(data[traindate]!.trainTimes[trainlocation]![itemSetCount]) 下"
                    
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


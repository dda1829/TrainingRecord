//
//  ViewController.swift
//  Training Record
//  Created by 邱宣策 on 2021/5/7.
//

import UIKit
import CoreData
import Firebase
//import GoogleMobileAds
import AppTrackingTransparency
//import AdSupport


//class TrainRecordHomeVC: UIViewController , UIPickerViewDataSource,UIPickerViewDelegate, NSFetchedResultsControllerDelegate,UIScrollViewDelegate, GADBannerViewDelegate{
class TrainRecordHomeVC: UIViewController , UIPickerViewDataSource,UIPickerViewDelegate, NSFetchedResultsControllerDelegate,UIScrollViewDelegate{
    
    // MARK: For Introduce Picture
    let fullScreenSize = UIScreen.main.bounds.size
    var imageArray = [UIImage(named: "IntroHome0"),UIImage(named: "introHome1"),UIImage(named: "IntroHome2"),UIImage(named: "IntroHome3")]
    var autoCurrentPage = 0
    
    // MARK: System parameters
    var loginTimes = 0
    var prepareTime = 3
    
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
    var trainWeight : Float  = 10.0
    var trainTimes : Int = 10
    var trainEachSetInterval : Int = 30
    var trainSetEachInterval : Float = 3.0
    var trainUnit: String = "Kg"
    
    
    // MARK: TrainItem's Image
    var homeImageView : UIImageView?
    let noColor = UIImage(named: "nocolor")!
    let homeImage = UIImage(named: "homeImage")
    var homeImageforms: [UIImage] = [UIImage(named: "homeimage")!,UIImage(named: "BrestTitle")!,UIImage(named: "BackTitle")!,UIImage(named: "AbdomenTitle")!,UIImage(named: "BLTitle")!,UIImage(named: "ArmTitle")!,UIImage(named: "ExerciseTitle")!]
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
   
    
    
    
    
    
    // MARK: TrainItem's list
    var formListLocation : [String] = ["運動部位", "肩胸部","背部", "核心","臀腿部",  "手臂","有氧運動"]
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
    var trainLS: [Int] = [0,0] // trainLocationSelection Used to choose the training location
    
    let pauseAndplayImageButton = UIButton()
    let countdownTV = UITextView()
    let stopTrainingButton = UIButton()
    let stopRestingButton = UIButton()
    var countDownCounter = 3
    var trainIsStart = false
//    var data : [String: RecordItem] = [:]
    var trainToday = ""
    var recordSet = 0
    var recordData: RecordItem?
    
    
    
    //MARK: firebase firestore used
    var db: Firestore!
    
    //MARK: Variable made for record list
    var dateRecord : String = ""
    var recordLocation = ""
    var recordLocationItem = ""
    var recordListString = ""
    var recordsort: [[Int]] = []
    var preventGoodBtnPressed: [IndexPath] = []
    var preventNormalBtnPressed: [IndexPath] = []
    var preventBadBtnPressed: [IndexPath] = []
    //MARK:  Storage properties for new info
    var infodatainside: [String] = []
    var infodatacontent: [String] = []
    var infodataUserName: [String] = []
    var infodataEmail: [String] = []
    var beforeinfodatainside : [String] = []
//    var bannerView: GADBannerView!
    
    //MARK: Member parameters
    var trainingGoal : String?
    let targetTV = UITextView(frame: CGRect(x: 0, y: 0, width: 343, height: 38))

    //MARK: Model parameters
    var isModeSetToSimple = false
    
    
    
    
    
    
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
                return formListAbdomen[row]
            case 4:
                return formListBL[row]
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
    @objc func rotate() {
        let oneDegree = CGFloat.pi / 180
        homeImageView!.transform = CGAffineTransform(rotationAngle: oneDegree * 0 )
        TimerUse.share.stopTimer(1)
    }
    @objc func mirror() {
        homeImageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        TimerUse.share.stopTimer(1)
    }
    func selectTrainPickerViewRow() {
        switch trainLS[0]{
        case 1:
            if trainLS[1] >= formListBrest.count{
                trainLS[1] = 0
            }
        case 2:
            if trainLS[1] >= formListBack.count{
                trainLS[1] = 0
            }
        case 3:
            if trainLS[1] >= formListAbdomen.count{
                trainLS[1] = 0
            }
        case 4:
            if trainLS[1] >= formListBL.count{
                trainLS[1] = 0
            }
        case 5:
            if trainLS[1] >= formListArm.count{
                trainLS[1] = 0
            }
        case 6:
            if trainLS[1] >= formListEx.count{
                trainLS[1] = 0
            }
        default:
            print("select error")
        }
        pickerView(TrainPickerView, didSelectRow: trainLS[1], inComponent: 1)
        TrainPickerView.selectRow(trainLS[1], inComponent: 1, animated: true)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0 {
            switch row {
            case 1:
                print(formListLocation[row])
                trainLS[0] = 1
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                homeImageView?.image = homeImageforms[row]
                homeImageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                homeImageView!.isHidden = false
                selectTrainPickerViewRow()
                pickerView.reloadComponent(1)
                
            case 2:
                print(formListLocation[row])
                trainLS[0] = 2
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                UIView.animate(withDuration: 0.3) { [self] in
                    homeImageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
                homeImageView?.image = homeImageforms[row]
                homeImageView!.isHidden = false
                selectTrainPickerViewRow()
                pickerView.reloadComponent(1)
            case 3:
                trainLS[0] = 3
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                let oneDegree = CGFloat.pi / 180
                homeImageView?.image = homeImageforms[row]
                homeImageView?.transform = CGAffineTransform.identity.translatedBy(x: 50, y: 100).rotated(by: oneDegree   * (-45)).scaledBy(x: -1, y: 1)
                UIView.animate(withDuration: 0.3) { [self] in
                    homeImageView!.transform = CGAffineTransform(rotationAngle: oneDegree * 0 )
                }
                homeImageView!.isHidden = false
                selectTrainPickerViewRow()
                pickerView.reloadComponent(1)
            case 4:
                trainLS[0] = 4
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                let oneDegree = CGFloat.pi / 180
                homeImageView?.transform = CGAffineTransform.identity.translatedBy(x: 50, y: 100).rotated(by: oneDegree   * (-45)).scaledBy(x: 1, y: 1)
                UIView.animate(withDuration: 0.3) { [self] in
                    homeImageView!.transform = CGAffineTransform(rotationAngle: oneDegree * 0 )
                }
                homeImageView?.image = homeImageforms[row]
                homeImageView!.isHidden = false
                selectTrainPickerViewRow()
                pickerView.reloadComponent(1)
            case 5:
                trainLS[0] = 5
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                let oneDegree = CGFloat.pi / 180
                homeImageView?.transform = CGAffineTransform.identity.translatedBy(x: 50, y: 100).rotated(by: oneDegree   * (-45)).scaledBy(x: 1, y: 1)
                UIView.animate(withDuration: 0.3) { [self] in
                    homeImageView!.transform = CGAffineTransform(rotationAngle: oneDegree * 0 )
                }
                homeImageView?.image = homeImageforms[row]
                homeImageView!.isHidden = false
                selectTrainPickerViewRow()
                pickerView.reloadComponent(1)
            case 6:
                trainLS[0] = 6
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                homeImageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                homeImageView?.image = homeImageforms[row]
                homeImageView!.isHidden = false
                selectTrainPickerViewRow()
                pickerView.reloadComponent(1)
            default:
                print("title")
                trainLS[0] = 0
                trainLS[1] = 0
                definitionTV.text = ""
                trainParametersTV.text = ""
                trainImageView.image = noColor
                homeImageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                homeImageView?.image = homeImageforms[row]
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
                
            case 3:  //Abodmen
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
                
            case 4: //Bottom Lap
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
                trainLS[1]=0
                print("")
            }
            
        }
        
    }
    @IBOutlet weak var ToolBar: UIToolbar!
    
    @IBOutlet weak var definitionTV: UITextView!
    
    @IBOutlet weak var trainImageView: UIImageView!
    
    @IBOutlet weak var trainParametersTV: UITextView!
    
    @IBOutlet weak var TrainPickerView: UIPickerView!
    
    
    @IBOutlet weak var IntroduceSV: UIScrollView!
 

    
    @IBOutlet weak var RecordListTV: UITableView!
    

    
    @IBOutlet weak var IntroducePCol: UIPageControl!
    @IBAction func IntroducePC(_ sender: UIPageControl) {
        let currentPageNumber = sender.currentPage
        let width = IntroduceSV.frame.size.width
        let offset = CGPoint(x: width * CGFloat(currentPageNumber), y: 0)
        IntroduceSV.setContentOffset(offset, animated: true)
    }
    let picker : UIDatePicker = UIDatePicker()
    var showDateBtnClick = false
    
    @objc func showDateBarBtnPressed(_ sender: Any) {
        if !showDateBtnClick {
            picker.datePickerMode = UIDatePicker.Mode.date
            picker.addTarget(self, action:#selector(dueDateChanged(sender:)),for: UIControl.Event.valueChanged)
            let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
            picker.frame = CGRect(x:50, y:120, width:pickerSize.width - 16, height:400)
            // you probably don't want to set background color as black
            
            picker.preferredDatePickerStyle = .inline
            self.view.addSubview(picker)
            picker.backgroundColor = .darkGray
            picker.translatesAutoresizingMaskIntoConstraints = false
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            picker.widthAnchor.constraint(equalToConstant: self.view.sizeThatFits(CGSize.zero).width - 40).isActive = true
            picker.heightAnchor.constraint(equalToConstant: self.view.sizeThatFits(CGSize.zero).width + 50).isActive = true
            showDateBtnClick = true
        } else {
            showDateBtnClick = false
            picker.removeFromSuperview()
        }
    }
    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        ToolBarManage()
        
    
        dateRecord = dateFormatter.string(from: sender.date)
        print("DatePicke is used")
        
        print(dateRecord)

        loadFromFile()
        RecordListTV.reloadData()
        picker.removeFromSuperview()
    }
    
   
    
    
    
    var lastData: [String:Int] = [:]
    // MARK: firestore load Training Data
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
                    item.ItemTitle = document.data()["itemTitle"] as? String
                    item.ItemEmail = document.data()["itemEmail"] as? String
                    item.ItemUserName = document.data()["itemUserName"] as? String
                    item.abdomenLast = document.data()["abdomenLast"] as? String
                    item.armLast = document.data()["armLast"] as? String
                    item.backLast = document.data()["backLast"] as? String
                    item.bottomLapLast = document.data()["bottomLapLast"] as? String
                    item.brestShoulderLast = document.data()["brestShoulderLast"] as? String
                    item.exerciseLast = document.data()["exerciseLast"] as? String
                    item.ItemID = document.documentID
                    if !(self.infodatainside.contains(item.ItemTitle!)){
                        self.infodatainside.append(item.ItemTitle!)
                        self.infodatacontent.append(item.ItemContent!)
                        self.infodataEmail.append(item.ItemEmail!)
                        self.infodataUserName.append(item.ItemUserName!)
                        print(infodatainside)
                    }
                    self.lastData.updateValue(Int(item.brestShoulderLast!)!, forKey: "BrestShoulder")
                    self.lastData.updateValue(Int(item.backLast!)!, forKey: "Back")
                    self.lastData.updateValue(Int(item.abdomenLast!)!, forKey: "Abdomen")
                    self.lastData.updateValue(Int(item.bottomLapLast!)!, forKey: "BottomLap")
                    self.lastData.updateValue(Int(item.armLast!)!, forKey: "Arm")
                    self.lastData.updateValue(Int(item.exerciseLast!)!, forKey: "Exercise")
                    
                    if beforeinfodatainside.count != infodatainside.count {
                        mbProgress(true)
                        let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
                        for x in trainLocationLoading{
                            loadData(x)
                        }
                    }
                }
            }else{
                for document in data.documents{
                    let item = TrainingItemForFireStore()
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
                            self.RecordListTV.dataSource = self
                            self.RecordListTV.delegate = self
                        }
                    default:
                        print("type wrong")
                    }
                }
            }
        }
        
    }
    func reloadTrainParameters(){
        if UserDefaults.standard.float(forKey: "trainWeight") != 0.0{
            trainWeight = UserDefaults.standard.float(forKey: "trainWeight")
        }
        if UserDefaults.standard.integer(forKey: "trainTimes") != 0{
            trainTimes = UserDefaults.standard.integer(forKey: "trainTimes")
        }
        if UserDefaults.standard.integer(forKey: "trainEachSetInterval") != 0 {
            trainEachSetInterval = UserDefaults.standard.integer(forKey: "trainEachSetInterval")
        }
        if UserDefaults.standard.float(forKey: "trainSetEachInterval") != 0.0 {
            trainSetEachInterval = UserDefaults.standard.float(forKey: "trainSetEachInterval")
        }
        let textDefault : String = "訓練重量：\(trainWeight)\(trainUnit)。\n此組次數：\(trainTimes)下。\n每下間隔：\(Float(Int(trainSetEachInterval*10))/10 )秒。\n休息時間：\(trainEachSetInterval)秒"
        trainParametersTV.text = textDefault
    }
    var lastImageDataCheck: [String:Int] = [:]
    func DownLoadTrainingItemImage(_ documentname: String, _ filename: String) {
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        let docUrl = homeUrl.appendingPathComponent("Documents")
        let doc2Url = docUrl.appendingPathComponent(documentname)
        let fileUrl = doc2Url.appendingPathComponent(filename)
        
        let storageRef = Storage.storage(url: "gs://trainingrecord-ad7d7.appspot.com/").reference()
        let imageRef = storageRef.child("\(documentname)/\(filename)").write(toFile: fileUrl)
        
//        imageRef.write(toFile: fileUrl) { (url,error) in
//            if let e = error {
//                print( "error \(e)")
//            } else {
//
//            }
//        }
            imageRef.observe(.success) { [self] snapshot in
                if lastImageDataCheck[documentname] == nil {
                lastImageDataCheck.updateValue(1, forKey: documentname)
                }else{
                    lastImageDataCheck[documentname]! += 1
                }
        
            
        }
    }
    func mbProgress(_ onoff: Bool){
        if onoff{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }else{
        MBProgressHUD.hide(for: self.view, animated: true)
        }
        }
    
    func trainingItemImageAppend(_ documentname: String, _ filename: String) {
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        let docUrl = homeUrl.appendingPathComponent("Documents")
        let doc2Url = docUrl.appendingPathComponent(documentname)
        let fileUrl = doc2Url.appendingPathComponent(filename)
        var c = 0
        while c == 0 {
        if let a = try! NSData.init(contentsOf: fileUrl){
            let b = UIImage(data: a as Data)!
        switch documentname {
        case "BrestShoulder":
            self.brestImageforms.append(b)
            print(fileUrl.absoluteString)
            self.brestImageURLs.append("Documents/\(documentname)/\(filename)")
            print(homeUrl.absoluteString)
            print("Documents/\(documentname)/\(filename)")
            c += 1
        case "Back":
            self.backImageforms.append(b)
            self.backImageURLs.append("Documents/\(documentname)/\(filename)")
            c += 1
        case "Abdomen":
            self.abdomenImageforms.append(b)
            self.abdomenImageURLs.append("Documents/\(documentname)/\(filename)")
            c += 1
        case "Arm":
            self.armImageforms.append(b)
            self.armImageURLs.append("Documents/\(documentname)/\(filename)")
            c += 1
        case "BottomLap":
            self.blImageforms.append(b)
            self.blImageURLs.append("Documents/\(documentname)/\(filename)")
            c += 1
        case "Exercise":
            self.exerciseImageform.append(b)
            self.exImageURLs.append("Documents/\(documentname)/\(filename)")
            c += 1
        default:
            print("wrong type")
        }
        }
        }
        if documentname == "Exercise" && filename == String(lastData["Exercise"]!) + ".png" {
            setCoreDataStore()
           mbProgress(false)
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
//        let notificationName = Notification.Name("ChangeTrainUnit")
//        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateNoti(noti:)), name: notificationName, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(clearDatas(noti:)), name: Notification.Name("ClearDatas"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name("dataDownloadDone"), object: nil, queue: OperationQueue.main) { notification in
            self.downloadImageFormListFromfirebase()
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("imageDownloadDone"), object: nil, queue: OperationQueue.main) { notification in
            self.setImageFormListFromfirebase()
        }
        
    }
//    @objc func getUpdateNoti(noti:Notification) {
//        trainUnit = noti.userInfo!["trainUnit"] as! String
//        print(trainUnit)
//    }
//    @objc func clearDatas(noti:Notification){
//        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
//        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
//        let file = doc.appendingPathComponent("RecordDatas")
//        let manager = FileManager.default
//        do{
//            try manager.removeItem(at: file)
//        }catch{
//            print("removeFail")
//        }
//        todayItem = RecordItem(trainToday, [:], [:], [], [:], [:], [:], [])
//        dateRecord = trainToday
//        RecordListTV.reloadData()
//        print("Already delete the data")
//    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNewTrainingItem()
        // Do any additional setup after loading the view.
        if UserDefaults.standard.integer(forKey: "prepareTime") != 0 {
            prepareTime = UserDefaults.standard.integer(forKey: "prepareTime")
            UserDefaults.standard.removeObject(forKey: "prepareTime")
        }
        TrainPickerView.delegate = self
        definitionTV.text = ""
        trainParametersTV.text = ""
        TrainPickerView.setValue(UIColor.white, forKey: "textColor")
        self.db = Firestore.firestore()
        let imageView = UIImageView(image: self.homeImageforms[0])
        homeImageView = imageView
        self.view.addSubview(homeImageView!)
        homeImageView!.frame = CGRect(x: 16, y: 54, width: 343, height: 145)
        homeImageView!.contentMode = .scaleAspectFit //把圖片縮在你指定的大小
        homeImageView!.clipsToBounds = true
        homeImageView!.translatesAutoresizingMaskIntoConstraints = false
        homeImageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        homeImageView!.bottomAnchor.constraint(equalTo: self.TrainPickerView.topAnchor, constant: -10).isActive = true
        loadTheTrainList()
        DefaultFormEditor()
        if lastData != [:]{
            self.RecordListTV.dataSource = self
            self.RecordListTV.delegate = self
        }
        MemberUserDataToFirestore.share.loadUserdatas()
        RecordListTV.translatesAutoresizingMaskIntoConstraints = false
        
        ToolBarManage()
        if Auth.auth().currentUser != nil {
            if let usergoal = UserDefaults.standard.string(forKey: "userGoal"){
               trainingGoal = usergoal

                    self.view.addSubview(targetTV)
                    targetTV.translatesAutoresizingMaskIntoConstraints = false
                    targetTV.topAnchor.constraint(equalTo: self.TrainPickerView.bottomAnchor, constant: 0).isActive = true
                    targetTV.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                    targetTV.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                    targetTV.bottomAnchor.constraint(equalTo: self.RecordListTV.topAnchor, constant: 0).isActive = true
                    targetTV.heightAnchor.constraint(equalToConstant: 45).isActive = true
                    targetTV.backgroundColor = .darkGray
                    targetTV.textColor = .red
                    targetTV.font = UIFont.systemFont(ofSize: 20)
                    targetTV.isEditable = false
                    targetTV.adjustsFontForContentSizeCategory = true
                    targetTV.textAlignment = .center
                    targetTV.text = "目標：" + (trainingGoal ?? "讀取中，請於系統設定確認。")
                    RecordListTV.topAnchor.constraint(equalTo: targetTV.bottomAnchor, constant: 0).isActive = true
                    RecordListTV.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                    RecordListTV.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                    RecordListTV.bottomAnchor.constraint(equalTo: self.ToolBar.topAnchor, constant: 0).isActive = true
                }else{
                    RecordListTV.topAnchor.constraint(equalTo: self.TrainPickerView.bottomAnchor, constant: 0).isActive = true
                    RecordListTV.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                    RecordListTV.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                    RecordListTV.bottomAnchor.constraint(equalTo: self.ToolBar.topAnchor, constant: 0).isActive = true
                }
            
            
            
        }else{
            RecordListTV.topAnchor.constraint(equalTo: self.TrainPickerView.bottomAnchor, constant: 0).isActive = true
            RecordListTV.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
            RecordListTV.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
            RecordListTV.bottomAnchor.constraint(equalTo: self.ToolBar.topAnchor, constant: 0).isActive = true
           
            
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
        
        
        
        // MARK: Save today's date
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        trainToday = dateFormatter.string(from: nowDate)
        print(trainToday)
        dateRecord = trainToday
        loadFromFile()
        print(trainToday)
        
        let stopRestBtnAction = UIAction(title:"stopRestBtnAction"){(action) in
            self.stopRestingButton.removeFromSuperview()
            self.countdownTV.removeFromSuperview()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            TimerUse.share.stopTimer(1)
            self.countDownCounter = self.prepareTime
            for view in self.view.subviews{
                view.isHidden = false
            }
            if self.trainLS != [0,0]  && self.trainLS != [1,0] && self.trainLS != [2,0] && self.trainLS != [3,0] && self.trainLS != [4,0] && self.trainLS != [5,0] && self.trainLS != [6,0]{
            self.homeImageView?.isHidden = true
            }
        }
        stopRestingButton.addAction(stopRestBtnAction, for: .touchUpInside)
        stopRestingButton.setImage(UIImage(named: "stop"), for: .normal)
        
        let stopTrainBegin = UIAction(title: "stopTrainBegin"){(action) in
            self.stopTrainingButton.removeFromSuperview()
            self.pauseAndplayImageButton.removeFromSuperview()
            self.countdownTV.removeFromSuperview()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            TimerUse.share.stopTimer(1)
            self.countDownCounter = self.prepareTime
            
            // MARK: build an alert activity to check the data if you want to record
            if self.recordIsStart {
                let alertController = UIAlertController(title: "請確認是否儲存目前的訓練數值，您完成了\(self.fitRecordLocation(self.trainLS))中的\(self.fitRecordLocationItem(self.trainLS))的項目\(self.todayItem!.trainTimes[self.trainLS]![self.todayItem!.trainSet[self.trainLS]!-1])次了！請問您是否要紀錄，若要紀錄請選ＯＫ，不紀錄請Cancel，謝謝！", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    print("OK")
                    let alertController = UIAlertController(title: "已經紀錄完成了！", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        print("OK")
                        self.writeToFile()
                        self.RecordListTV.reloadData()
                        self.recordIsStart = false
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    print("Cancel")
                    //
                    if self.recordIsStart{
                        self.todayItem?.trainLocationSort.removeLast()
                        self.todayItem?.trainLocation[self.trainLS]?.removeLast()
                        self.todayItem?.trainSet[self.trainLS]! -= 1
                        self.todayItem?.trainTimes[self.trainLS]?.removeLast()
                        self.todayItem?.trainWeight[self.trainLS]?.removeLast()
                        self.todayItem?.trainUnit[self.trainLS]?.removeLast()
                        self.todayItem!.trainRate.removeLast()
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
        stopTrainingButton.addAction(stopTrainBegin, for: .touchUpInside)
        stopTrainingButton.setImage(UIImage(named: "stop"), for: .normal)
        
        if trainLS != [] {
            TrainPickerView.selectRow(trainLS[0], inComponent: 0, animated: false)
            pickerView(TrainPickerView, didSelectRow: trainLS[0], inComponent: 0)
        }
        RecordListTV.register(ShareTableViewCell.nib(), forCellReuseIdentifier: ShareTableViewCell.identifier)
        let a =  UserDefaults.standard.integer(forKey: "LoginTimes")
        print(a)
        if a == 0 /*&& traitCollection.userInterfaceIdiom == .phone*/{
           
                for view in self.view.subviews{
                    view.isHidden = true
                }
                navigationController?.setNavigationBarHidden(true, animated: true)
                // this use to generate a view to introduce the program how to use

                IntroduceSV.delegate = self
                IntroduceSV.contentSize.width = (fullScreenSize.width) * CGFloat(imageArray.count + 1)
                IntroduceSV.contentSize.height = IntroduceSV.frame.height
                IntroduceSV.showsVerticalScrollIndicator = false
                IntroduceSV.showsHorizontalScrollIndicator = false
                IntroduceSV.bounces = false
                IntroduceSV.isPagingEnabled = true
                IntroduceSV.translatesAutoresizingMaskIntoConstraints = false
                IntroduceSV.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                IntroduceSV.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
                IntroduceSV.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                IntroduceSV.bottomAnchor.constraint(equalTo: self.IntroducePCol.topAnchor, constant: 0).isActive = true
                
                
                
                
                
                IntroduceSV.isDirectionalLockEnabled = true
                IntroducePCol.numberOfPages = imageArray.count
                IntroducePCol.currentPage = 0
                IntroducePCol.currentPageIndicatorTintColor = .blue
                IntroducePCol.pageIndicatorTintColor = .brown
            IntroducePCol.translatesAutoresizingMaskIntoConstraints = false
            IntroducePCol.topAnchor.constraint(equalTo: IntroduceSV.bottomAnchor, constant: 0).isActive = true
            IntroducePCol.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            IntroducePCol.heightAnchor.constraint(equalToConstant: 40).isActive = true
            IntroducePCol.widthAnchor.constraint(equalToConstant: fullScreenSize.width).isActive = true
                
                for i in 0 ..< imageArray.count{
                    myScrollImageView = UIImageView()
                    myScrollImageView.frame = CGRect(x: fullScreenSize.width * CGFloat(i) , y: 20, width: fullScreenSize.width, height: fullScreenSize.height - 100)
                    myScrollImageView.contentMode = .scaleToFill
                    myScrollImageView.image = imageArray[i]
                    self.IntroduceSV.addSubview(myScrollImageView)
//                    myScrollImageView.translatesAutoresizingMaskIntoConstraints = false
//                    myScrollImageView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
//                    myScrollImageView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
//                    myScrollImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
//                    myScrollImageView.bottomAnchor.constraint(equalTo: IntroducePCol.topAnchor, constant: 0).isActive = true
                  
                }

                
                IntroduceSV.isHidden = false
                IntroducePCol.isHidden = false
            
            
            
            
            
            
        }else{
            IntroduceSV.delegate = .none
            IntroduceSV.removeFromSuperview()
            IntroducePCol.removeFromSuperview()
        }
       
        loginTimes += 1
        UserDefaults.standard.set(loginTimes, forKey: "LoginTimes")
        UserDefaults.standard.synchronize()
                ATTrackingManager.requestTrackingAuthorization { status in
////
////                    DispatchQueue.main.async {
////                        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
////                        self.bannerView?.translatesAutoresizingMaskIntoConstraints = false
////                        self.bannerView?.adUnitID = "ca-app-pub-8982946958697547/7950255289"//廣告編號
////                        //ca-app-pub-3940256099942544/2934735716
////                        self.bannerView?.rootViewController = self
////                        self.bannerView?.delegate = self
////                        self.bannerView?.load(GADRequest())
////
////                    }
                }
        
        // Check the System Mode
            isModeSetToSimple = UserDefaults.standard.bool(forKey: "isModeSetToSimple")
        
        
        
    }
    @objc func registerTheMember(){
        let alertController = UIAlertController(title: "註冊會員後便開放此功能！", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("OK")
            
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
    }
    
    func ToolBarManage(){
        var restbarbtn = UIBarButtonItem()
        if Auth.auth().currentUser != nil{
            restbarbtn = UIBarButtonItem(image: UIImage(systemName: "bed.double.fill"), style: .plain, target: self, action: #selector(breakCounterBtnPressed))
        }else{
            restbarbtn = UIBarButtonItem(image: UIImage(systemName: "bed.double.fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(registerTheMember))
        }
        
        let adjusttrainingparameters = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(trainingParametersChange))
        let trainstartbarbtn = UIBarButtonItem(image: UIImage(named: "start"), style: .plain, target: self, action: #selector(trainStartBtnPressed))
        let trainreportbarbtn = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.right"), style: .plain, target: self, action: #selector(trainreportgo))
        let flexible = UIBarButtonItem.flexibleSpace()
        let traindatebarbtn = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(showDateBarBtnPressed))
        ToolBar.setItems([restbarbtn,flexible,adjusttrainingparameters,flexible, trainstartbarbtn,flexible,trainreportbarbtn,flexible,traindatebarbtn], animated: false)
    }
    
    
    @objc func trainingParametersChange(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageTrainSetPage") as? ManageTrainSetVC
        vc?.trainLS = trainLS
        self.navigationController?.pushViewController(vc!,animated: true)
        
    }
    @objc func trainreportgo() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SharePage") as? ShareViewController
        vc?.formListBL = formListBL
        vc?.formListBrest = formListBrest
        vc?.formListEx = formListEx
        vc?.formListArm = formListArm
        vc?.formListBack = formListBack
        vc?.formListAbdomen = formListAbdomen
        vc?.dateRecord = dateRecord
        self.navigationController?.pushViewController(vc!,animated: true)
        
    }
    
    
    func checkNewTrainingItem(){
        let tranLSnew = UserDefaults.standard.integer(forKey: "newTrainingLS")
        guard let trainingItemName = UserDefaults.standard.string(forKey: "newTrainingItemName") , let trainingItemDef = UserDefaults.standard.string(forKey: "newTrainingItemDef") , let trainingItemImageString = UserDefaults.standard.string(forKey: "newTrainingItemURLString") else {
            return
        }
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        let imageUrl = homeUrl.appendingPathComponent(trainingItemImageString)
        UserDefaults.standard.removeObject(forKey: "newTrainingLS")
        UserDefaults.standard.removeObject(forKey:"newTrainingItemName")
        UserDefaults.standard.removeObject(forKey:"newTrainingItemDef")
        UserDefaults.standard.removeObject(forKey:"newTrainingItemURLString")
        switch tranLSnew{
        case 1:
            formListBrest.append(trainingItemName)
            trainBrestText.append(trainingItemDef)
            brestImageforms.append(UIImage(data: try! NSData.init(contentsOf: imageUrl) as Data)!)
            trainingItemCoreDataStore(tranLSnew, trainingItemImageString, trainingItemName, trainingItemDef, formListBrest.count)
            
        case 2:
            formListBack.append(trainingItemName)
            trainBackText.append(trainingItemDef)
            backImageforms.append(UIImage(data: try! NSData.init(contentsOf: imageUrl) as Data)!)
            trainingItemCoreDataStore(tranLSnew, trainingItemImageString, trainingItemName, trainingItemDef, formListBack.count)
        case 3:
            formListBL.append(trainingItemName)
            trainBLText.append(trainingItemDef)
            blImageforms.append(UIImage(data: try! NSData.init(contentsOf: imageUrl) as Data)!)
            trainingItemCoreDataStore(tranLSnew, trainingItemImageString, trainingItemName, trainingItemDef, formListBL.count)
        case 4:
            formListAbdomen.append(trainingItemName)
            trainAbdomenText.append(trainingItemDef)
            abdomenImageforms.append(UIImage(data: try! NSData.init(contentsOf: imageUrl) as Data)!)
            trainingItemCoreDataStore(tranLSnew, trainingItemImageString, trainingItemName, trainingItemDef, formListAbdomen.count)
        case 5:
            
            formListArm.append(trainingItemName)
            trainArmText.append(trainingItemDef)
            armImageforms.append(UIImage(data: try! NSData.init(contentsOf: imageUrl) as Data)!)
            trainingItemCoreDataStore(tranLSnew, trainingItemImageString, trainingItemName, trainingItemDef, formListArm.count)
        case 6:
            formListEx.append(trainingItemName)
            trainExText.append(trainingItemDef)
            exerciseImageform.append(UIImage(data: try! NSData.init(contentsOf: imageUrl) as Data)!)
            trainingItemCoreDataStore(tranLSnew, trainingItemImageString, trainingItemName, trainingItemDef, formListEx.count)
        default:
            print("nothing added")
        }
    }
    
    
    
    
    
    // MARK: Use for Introduce the App
    var myScrollImageView: UIImageView!
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (IntroduceSV != nil){
            let currentPage = Int(IntroduceSV.contentOffset.x / IntroduceSV.frame.size.width)
            if let a = IntroducePCol {
                a.currentPage = currentPage
            }
            if currentPage == 4 {
                navigationController?.setNavigationBarHidden(false, animated: true)
                IntroduceSV.delegate = .none
                IntroduceSV.removeFromSuperview()
                myScrollImageView.removeFromSuperview()
                IntroducePCol.removeFromSuperview()
                for view in self.view.subviews{
                    view.isHidden = false
                }
                let alertController = UIAlertController(title: nil, message: "歡迎您使用此應用！", preferredStyle: .alert)
                alertController.addTextField { textfield in
                    textfield.placeholder = "請問大名"
                }
                let action = UIAlertAction(title: "Save", style: .default) { action in
                    //取得textfield中的值
                    if let input =  alertController.textFields?[0].text{
                        UserDefaults.standard.set(input, forKey: "userName")
                        UserDefaults.standard.synchronize()
                    }
                }
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    func manageStringArray(_ arraydata: [String]) -> [String]{
        var result : [String] = []
        for item in arraydata{
            result.append(item)
        }
        result.removeFirst()
        return result
    }
    
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
        if lastData == [:]{
            TimerUse.share.setTimer(1, self, #selector(checkFormListCount), true, 2)
        }
        
        
    }
    
    @objc func checkImageDownloaded() {
        if lastData["BrestShoulder"] == lastImageDataCheck["BrestShoulder"] && lastData["Back"] == lastImageDataCheck["Back"] && lastData["Abdomen"] ==  lastImageDataCheck["Abdomen"] && lastData["BottomLap"] == lastImageDataCheck["BottomLap"] && lastData["Arm"] == lastImageDataCheck["Arm"] && lastData["Exercise"] == lastImageDataCheck["Exercise"]{
            TimerUse.share.stopTimer(3)
            NotificationCenter.default.post(name: Notification.Name("imageDownloadDone"), object: nil)
        }
    }
    
    @objc func checkFormListCount() {
        
            if (formListBrest.count - 1) == lastData["BrestShoulder"] && (formListBack.count - 1) == lastData["Back"] && (formListAbdomen.count - 1) == lastData["Abdomen"] && (formListBL.count - 1) == lastData["BottomLap"] && (formListArm.count - 1) == lastData["Arm"] && (formListEx.count - 1) == lastData["Exercise"]  {
                NotificationCenter.default.post(name: Notification.Name("dataDownloadDone"), object: nil)
                TimerUse.share.stopTimer(2)
                TimerUse.share.setTimer(1, self,#selector(checkImageDownloaded),true,3)
            }
        
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

    
    
    
    //MARK: Archiving
    func writeToFile()  {
        //
        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
        let file = doc.appendingPathComponent("RecordDatas")
        let manager = FileManager.default
        if !manager.fileExists(atPath: file.absoluteString){
            try? manager.createDirectory(at: file, withIntermediateDirectories: true, attributes: nil)
        }
        let file2 = file.appendingPathComponent(dateRecord)
        if !manager.fileExists(atPath: file2.absoluteString){
            try? manager.createDirectory(at: file2, withIntermediateDirectories: true, attributes: nil)
        }
        let filePath = file2.appendingPathComponent("RecordDatas.archive")
        do {
            //將data陣列，轉成Data型式（二進位資料）
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.todayItem!, requiringSecureCoding: false)
            try data.write(to: filePath, options: .atomic)
        } catch  {
            print("error while saving to file \(error)")
        }
    }
    
    func loadFromFile()  {
        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
        let file = doc.appendingPathComponent("RecordDatas")
        let file2 = file.appendingPathComponent(dateRecord)
        let filePath = file2.appendingPathComponent("RecordDatas.archive")
        do {
            //載入成Data（二進位資料)
            let data =  try Data(contentsOf: filePath)
            //把資料轉成[Note]
            if let arrayData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? RecordItem{
                self.todayItem = arrayData//轉成功就放到self.data裏
            }
        } catch  {
            print("error while fetching data array \(error)")
            self.todayItem = RecordItem(dateRecord, [:], [:], [], [:], [:], [:], [])//有任何錯誤,空陣列
        }
    }
    // MARK: Save Archiving after click the checklist button
    var todayItem : RecordItem?
    var checkmatrix : [[Int]:[Int]] = [:]
    var checkcount = 0
    // MARK: Start the Record
    
    @objc func trainStartBtnPressed(_ sender: Any) {
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
        
        if !isModeSetToSimple {
        for view in self.view.subviews{
            view.isHidden = true
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
        countDownCounter = prepareTime
        TimerUse.share.setTimer(1,self, #selector(CountDown), true,1)
                TimerUse.share.fire(1)
        countdownTV.font = UIFont(name: "Helvetica-Light", size: 200)
        countdownTV.backgroundColor = .black
        countdownTV.textAlignment = .center
        countdownTV.textColor = .green
        countdownTV.isEditable = false
        countdownTV.isSelectable = false
        self.view.addSubview(countdownTV)
        countdownTV.translatesAutoresizingMaskIntoConstraints = false
        countdownTV.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        countdownTV.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        countdownTV.heightAnchor.constraint(equalToConstant: 300).isActive = true
        countdownTV.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
        self.view.addSubview(stopTrainingButton)
        stopTrainingButton.translatesAutoresizingMaskIntoConstraints = false
        stopTrainingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NSLayoutConstraint(item: stopTrainingButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.7, constant: 1).isActive = true
        }else{
            todayItem!.trainLocationSort.append(trainLS)
            
            if let value = todayItem!.trainLocation[trainLS] {
                todayItem!.trainLocation[trainLS]!.append(0)
                print("add new value \(value)")
            }else {
                todayItem!.trainLocation.updateValue([0], forKey: trainLS)
                print(todayItem!.trainLocation)
            }
            todayItem!.trainRate.append("none")
            if let value = todayItem!.trainSet[trainLS] {
                todayItem!.trainSet[trainLS]! += 1
                print("add new value \(value)")
            }else {
                todayItem!.trainSet.updateValue(1, forKey: trainLS)
                print(todayItem!.trainSet)
            }
            if let value = todayItem!.trainTimes[trainLS] {
                todayItem!.trainTimes[trainLS]!.append(trainTimes)
                print("add new value \(value)")
            }else {
                todayItem!.trainTimes.updateValue([trainTimes], forKey: trainLS)
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
            
            self.writeToFile()
            self.RecordListTV.reloadData()
        }

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
            countdownTV.text = "\(countDownCounter)"
        }
        if countDownCounter == 0 {
            countDownCounter = 0
            TimerUse.share.stopTimer(1)
            if let url = Bundle.main.url(forResource: "BeepGo", withExtension: "m4a"){
                AVFoundationUse.share.playTheSound(url)
            }
            TimerUse.share.setTimer(trainSetEachInterval, self, #selector(CountTimer),true,1)
        }else{
            if let url = Bundle.main.url(forResource: "BeepPrepare", withExtension: "m4a"){
                AVFoundationUse.share.playTheSound(url)
            }
            countDownCounter -= 1
        }
    }
    @objc func breakCounterBtnPressed(_ sender: Any) {
        guard Auth.auth().currentUser != nil else {
            let alertController = UIAlertController(title: "請您註冊會員，方能使用休息計時器之功能，感謝！", message: "", preferredStyle: .alert)
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
        navigationController?.setNavigationBarHidden(true, animated: true)
        countDownCounter = trainEachSetInterval
        self.view.addSubview(countdownTV)
      
        countdownTV.text = "\(countDownCounter)"
        countdownTV.font = UIFont(name: "Helvetica-Light", size: 200)
        countdownTV.translatesAutoresizingMaskIntoConstraints = false
        countdownTV.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        countdownTV.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        countdownTV.heightAnchor.constraint(equalToConstant: 300).isActive = true
        countdownTV.widthAnchor.constraint(equalToConstant: 500).isActive = true
        countdownTV.textColor = .green
        countdownTV.textAlignment = .center
        countdownTV.isEditable = false
        countdownTV.isSelectable = false
        countdownTV.bounces = false
        self.view.addSubview(stopRestingButton)
        stopRestingButton.translatesAutoresizingMaskIntoConstraints = false
        stopRestingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NSLayoutConstraint(item: stopRestingButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.7, constant: 1).isActive = true
        TimerUse.share.setTimer(1, self, #selector(CountTimeBreak), true, 1)
        TimerUse.share.fire(1)
    }
    @objc func fitCountDownBreak(){
        TimerUse.share.stopTimer(1)
        TimerUse.share.stopTimer(2)
        TimerUse.share.setTimer(1, self, #selector(CountTimeBreak), true, 1)
    }
    @objc func CountTimer(){
        if !recordIsStart {
            CountTimeStart()
            recordIsStart = true
           
            todayItem!.trainLocationSort.append(trainLS)
            if let value = todayItem!.trainLocation[trainLS] {
                todayItem!.trainLocation[trainLS]!.append(0)
                print("add new value \(value)")
            }else {
                todayItem!.trainLocation.updateValue([0], forKey: trainLS)
                print(todayItem!.trainLocation)
            }
            todayItem!.trainRate.append("none")
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
        }
        countdownTV.font = UIFont(name: "Helvetica-Light", size: 200)
        
        countdownTV.textAlignment = .center
        countdownTV.textColor = .red
        countdownTV.isEditable = false
        countdownTV.isSelectable = false
        countdownTV.alwaysBounceHorizontal = true
       
        
        if countDownCounter == trainTimes {
            
            countDownCounter = trainEachSetInterval
            TimerUse.share.stopTimer(1)
            // MARK: alert training over show the traintimes
            let alertController = UIAlertController(title: "您完成了\(fitRecordLocation(trainLS))部位的\(fitRecordLocationItem(trainLS))訓練！若您不想紀錄，請點Cancel，謝謝！", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("OK")
                self.RecordListTV.reloadData()
                self.writeToFile()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel")
                self.todayItem?.trainLocationSort.removeLast()
                self.todayItem?.trainLocation[self.trainLS]?.removeLast()
                self.todayItem!.trainSet[self.trainLS]! -= 1
                self.todayItem!.trainTimes[self.trainLS]!.removeLast()
                self.todayItem!.trainWeight[self.trainLS]!.removeLast()
                self.todayItem!.trainUnit[self.trainLS]!.removeLast()
                self.todayItem!.trainRate.removeLast()
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            print(todayItem!.trainTimes)
            stopTrainingButton.removeFromSuperview()
            self.pauseAndplayImageButton.removeFromSuperview()
            self.countdownTV.removeFromSuperview()
            for view in self.view.subviews{
                view.isHidden = false
            }
            navigationController?.setNavigationBarHidden(false, animated: true)
            self.homeImageView?.isHidden = true
            self.countDownCounter = prepareTime
            self.recordIsStart = false
            return
        }
        if let url = Bundle.main.url(forResource: "BeepPrepare", withExtension: "m4a"){
            AVFoundationUse.share.playTheSound(url)
        }
        countDownCounter += 1
        countdownTV.text = "\(countDownCounter)"
        todayItem!.trainTimes[trainLS]![todayItem!.trainSet[trainLS]!-1] += 1
    }
    
    @objc func alarmRadar() {
        if let url = Bundle.main.url(forResource: "Radar", withExtension: "mp3"){
            AVFoundationUse.share.playTheSound(url)
        }
    }
    @objc func stopAlarmRadar() {
        TimerUse.share.stopTimer(2)
        AVFoundationUse.share.stopTheSound()
    }
    
    @objc func CountTimeBreak (){
        if countDownCounter == 0{
            if let url = Bundle.main.url(forResource: "Radar", withExtension: "mp3"){
                AVFoundationUse.share.playTheSound(url)
            }
            TimerUse.share.setTimer(3, self, #selector(alarmRadar), true, 2)
            TimerUse.share.setTimer(18, self, #selector(stopAlarmRadar), false, 3)
        }else{
            countdownTV.text = "\(countDownCounter)"
        }
        if countDownCounter == 0 {
            let alertController = UIAlertController(title: "休息時間結束，請點OK關閉鬧鐘。", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("OK")
                TimerUse.share.stopTimer(2)
                AVFoundationUse.share.stopTheSound()
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            countDownCounter = prepareTime
            for view in self.view.subviews{
                view.isHidden = false
            }
            if trainLS == [0,0]{
                homeImageView?.isHidden = false
            }else{
                homeImageView?.isHidden = true
            }
            countdownTV.removeFromSuperview()
            navigationController?.setNavigationBarHidden(false, animated: true)
            stopRestingButton.removeFromSuperview()
            TimerUse.share.stopTimer(1)
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
            vc.infocontent = infodatacontent
            vc.infoEmail = infodataEmail
            vc.infoUserName = infodataUserName
        }else if segue.identifier == "segue_Home_SystemVC"{
            let vc = segue.destination as! SystemTableViewController
            vc.dateRecord = dateRecord
        }else if segue.identifier == "report_share_segue"{
//            let vc = segue.destination as! ShareViewController
            
            
        }
        
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
                infoData.brestLast = "\(lastData["BrestShoulder"]!)"
                infoData.backLast = "\(lastData["Back"]!)"
                infoData.abdomenLast = "\(lastData["Abdomen"]!)"
                infoData.blLast = "\(lastData["BottomLap"]!)"
                infoData.armLast = "\(lastData["Arm"]!)"
                infoData.exLast = "\(lastData["Exercise"]!)"
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
            
            abdomenImageforms.append(UIImage(data: try! NSData.init(contentsOf: homeUrl.appendingPathComponent(beforeAbdomenData[x].image!)) as Data)!)
            
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
            beforeinfodatainside.append(beforeInfoData[x].content!)
            lastData.updateValue(Int(beforeInfoData[x].brestLast!)!, forKey: "BrestShoulder")
            lastData.updateValue(Int(beforeInfoData[x].backLast!)!, forKey: "Back")
            lastData.updateValue(Int(beforeInfoData[x].abdomenLast!)!, forKey: "Abdomen")
            lastData.updateValue(Int(beforeInfoData[x].blLast!)!, forKey: "BottomLap")
            lastData.updateValue(Int(beforeInfoData[x].armLast!)!, forKey: "Arm")
            lastData.updateValue(Int(beforeInfoData[x].exLast!)!, forKey: "Exercise")
            
        }
    }
    // MARK:GADBannerViewDelegate
//    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
//
//        self.RecordListTV.tableHeaderView = bannerView
//        //        if bannerView.superview == nil {
//        //            //第一次廣告進來
//        //            self.view.addSubview(bannerView)
//        //            self.RecordListTV.topAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutYAxisAnchor>#>) //關閉tableview上緣的條件
//        //            //廣告上緣貼齊safearea的上緣
//        //            bannerView.topAnchor.constraint(equalTo: self.RecordListTV.safeAreaLayoutGuide.topAnchor).isActive = true
//        //            //廣告下緣貼齊tableView的上緣
//        ////            bannerView.bottomAnchor.constraint(equalTo: self.RecordListTV.topAnchor).isActive = true
//        //            //廣告左右緣貼齊self.view的左右
//        //            bannerView.rightAnchor.constraint(equalTo: self.RecordListTV.rightAnchor).isActive = true
//        //            bannerView.leftAnchor.constraint(equalTo: self.RecordListTV.leftAnchor).isActive = true
//        //
//        //        }
//
//    }
//    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//        print(error)
//    }
    
}


extension TrainRecordHomeVC: UITableViewDataSource, UITableViewDelegate,ShareTableViewCellDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var locationsort: [[Int]] =  todayItem!.trainLocationSort.reversed()
            var rateArray:[String] = todayItem!.trainRate.reversed()
            let deleteTarget = locationsort[indexPath.row]
            var countI = -1
            var countT = -1
            for x in locationsort{
               countI += 1
                if x == deleteTarget{
                    countT += 1
                    if countI == indexPath.row{
                        break
                    }
                }
            }
            
            
            let deletedSet = todayItem!.trainSet[deleteTarget]!  - (countT + 1) //被刪掉的元素為 總數扣掉倒數回來的個數的順序再加1 表示為 第幾組被刪掉的元素
            print(indexPath.row)
            print(countT)
            print(deletedSet)
            rateArray.remove(at: indexPath.row)
            locationsort.remove(at: indexPath.row)
            self.todayItem?.trainLocationSort = locationsort.reversed()
            self.todayItem?.trainSet[deleteTarget]! -= 1
            self.todayItem?.trainLocation[deleteTarget]?.removeLast()
            self.todayItem?.trainTimes[deleteTarget]?.remove(at: deletedSet)
            self.todayItem?.trainWeight[deleteTarget]?.remove(at: deletedSet)
            self.todayItem?.trainUnit[deleteTarget]?.removeLast()
            self.todayItem!.trainRate = rateArray.reversed()
            writeToFile()
            RecordListTV.reloadData()
            
        }
        
    }
    func shareTableViewCellDidTapGood(_ sender: ShareTableViewCell) {
        guard let tappedIndexPath = RecordListTV.indexPath(for: sender) else {return}
        print(tappedIndexPath)
        print("good")
        print(tappedIndexPath.row)
        var rateArray:[String] = todayItem!.trainRate.reversed()
        rateArray[tappedIndexPath.row] = "Good"
        todayItem!.trainRate = rateArray.reversed()
        
        writeToFile()
        RecordListTV.reloadData()
    }
    
    func shareTableViewCellDidTapNormal(_ sender: ShareTableViewCell) {
        guard let tappedIndexPath = RecordListTV.indexPath(for: sender) else {return}
        print(tappedIndexPath)
        print("normal")
        var rateArray:[String] = todayItem!.trainRate.reversed()
        rateArray[tappedIndexPath.row] = "Normal"
        todayItem!.trainRate = rateArray.reversed()
        writeToFile()
        RecordListTV.reloadData()
    }
    
    func shareTableViewCellDidTapBad(_ sender: ShareTableViewCell) {
        guard let tappedIndexPath = RecordListTV.indexPath(for: sender) else {return}
        print(tappedIndexPath)
        print("bad")
        var rateArray:[String] = todayItem!.trainRate.reversed()
        rateArray[tappedIndexPath.row] = "Bad"
        todayItem!.trainRate = rateArray.reversed()
        writeToFile()
        RecordListTV.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(dateRecord)"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todayItem != RecordItem(dateRecord, [:], [:], [], [:], [:], [:], []) {
            return (todayItem?.trainLocationSort.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as! ShareTableViewCell
        if todayItem != RecordItem(dateRecord, [:], [:], [], [:], [:], [:], []){
            let subtitle = recordStringGen(dateRecord)[indexPath.row]
            let title = rangeTVCTitle(dateRecord)[indexPath.row]
            let rateArray = todayItem!.trainRate.reversed()[indexPath.row]
            switch rateArray{
            case "Good":
                cell.ratingBtnRecord("Good")
            case "Normal":
                cell.ratingBtnRecord("Normal")
            case "Bad":
                cell.ratingBtnRecord("Bad")
            default:
                cell.ratingBtnRecord("None")
            }
        cell.Title.text = title
        cell.subTitle.text = subtitle
            
        cell.delegate = self
        }
        return cell
    }
    func rangeTVCTitle(_ traindate: String) -> [String]{
        var result: [String] = []
        var locationString = ""
        
        for x in todayItem!.trainLocationSort {
            locationString = "\(fitRecordLocation(x))-\(fitRecordLocationItem(x))"
            result.append(locationString)
            }
        print("record location result = \(result)")
        return result.reversed()
    }
    func recordStringGen (_ traindate : String) -> [String]{
        var result: [String] = []
        
        var locationcounter: [[Int]:Int] = [:]
        
        if todayItem != RecordItem(dateRecord, [:], [:], [], [:], [:], [:], []) {
            
            let locationsort = todayItem!.trainLocationSort
            var locationmax = todayItem?.trainSet
            
            for trainlocation in locationsort{
                if locationcounter[trainlocation] == nil {
                    locationcounter.updateValue(0, forKey: trainlocation)
                }
                
                
                if locationcounter[trainlocation] == 0 {
                if trainlocation[0] == 6{
                    let recordstringdefault = "第\(1)組  \( todayItem!.trainTimes[trainlocation]![0]) Times"
                    recordListString = recordstringdefault
                    result.append(recordListString)
                }else{
                    let recordstringdefault = "第\(1)組  \(todayItem!.trainWeight[trainlocation]![0]) \(todayItem!.trainUnit[trainlocation]![0]) * \( todayItem!.trainTimes[trainlocation]![0]) Times"
                    recordListString = recordstringdefault
                    result.append(recordListString)
                }
                    
                }else{
                    if trainlocation[0] == 6 {
                        recordListString = "\n第\(locationcounter[trainlocation]! + 1)組  \(todayItem!.trainTimes[trainlocation]![locationcounter[trainlocation]!]) Times"
                    result.append(recordListString)
                    }else{
                                        
                          recordListString = "\n第\(locationcounter[trainlocation]! + 1)組  \(todayItem!.trainWeight[trainlocation]![locationcounter[trainlocation]!]) \(todayItem!.trainUnit[trainlocation]![locationcounter[trainlocation]!]) * \(todayItem!.trainTimes[trainlocation]![locationcounter[trainlocation]!]) Times"
                           result.append(recordListString)
                    }
                                       
                }
                locationcounter[trainlocation]! += 1
              
            }
        }
        
        
        print("record String result = \(result)")
        
        return result.reversed()
        
        
        
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
            print(formListAbdomen)
            return formListAbdomen[locationdata[1]]
        case 4:
            print(locationdata[1])
            print(formListBL)
            return formListBL[locationdata[1]]
            
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


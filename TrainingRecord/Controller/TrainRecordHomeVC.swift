//
//  ViewController.swift
//  Training Record
//  Created by 邱宣策 on 2021/5/7.
//

import UIKit
import CoreData
import Firebase
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport


class TrainRecordHomeVC: UIViewController , UIPickerViewDataSource,UIPickerViewDelegate, NSFetchedResultsControllerDelegate,UIScrollViewDelegate, GADBannerViewDelegate{
//class TrainRecordHomeVC: UIViewController , UIPickerViewDataSource,UIPickerViewDelegate, NSFetchedResultsControllerDelegate,UIScrollViewDelegate{
    
    // MARK: For Introduce Picture
    let fullScreenSize = UIScreen.main.bounds.size
    var imageArray = [UIImage(named: "IntroHome0"),UIImage(named: "introHome1"),UIImage(named: "IntroHome2"),UIImage(named: "IntroHome3")]
    var autoCurrentPage = 0
    
    // MARK: System parameters
    var loginTimes = 0
    var prepareTime = 3
    
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
    var breastImageforms : [UIImage] = [UIImage(named: "nocolor")!]
    var backImageforms : [UIImage] = [UIImage(named: "nocolor")!]
    var blImageforms : [UIImage] =  [UIImage(named: "nocolor")!]
    var abdomenImageforms : [UIImage] = [UIImage(named: "nocolor")!]
    var armImageforms : [UIImage] = [UIImage(named: "nocolor")!]
    var exerciseImageform : [UIImage] = [UIImage(named: "nocolor")!]

    
    
    
    
    
    
    // MARK: TrainItem's list
    var formListLocation : [String] = ["運動部位", "肩胸部","背部", "核心","臀腿部",  "手臂","有氧運動"]
    var formListBreast : [String] = [ "訓練項目"]
    var formListBL : [String] = [ "訓練項目"]
    var formListAbdomen : [String] = [ "訓練項目"]
    var formListArm : [String] = [ "訓練項目"]
    var formListEx : [String] = [ "訓練項目"]
    var formListBack : [String] = [ "訓練項目"]
    var trainBreastText:[String] = [ ""]
    var trainBackText:[String] = [ ""]
    var trainBLText:[String] = [""]
    var trainAbdomenText:[String] = [""]
    var trainArmText:[String] = [""]
    var trainExText:[String] = [""]
    
    
    // MARK: Prepare for recording start
    var trainLS: [Int] = [0,0] // trainLocationSelection Used to choose the training location
    
    let pauseAndplayImageButton = UIButton()
    let countdownTV = UITextView()
    let stopTrainingButton = UIButton()
    let stopRestingButton = UIButton()
    var countDownCounter = 3
    var trainIsStart = false
    var trainToday = ""
    
    
    
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
    var bannerView: GADBannerView!
    
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
                return formListBreast.count
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
                return formListBreast[row]
                
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
            if trainLS[1] >= formListBreast.count{
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
                definitionTV.text = trainBreastText[row]
                trainImageView.image = breastImageforms[row]
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
           
            // you probably don't want to set background color as black
            
            if #available(iOS 14.0, *) {
                picker.preferredDatePickerStyle = .inline
            } else {
                // Fallback on earlier versions
            }
            let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
            picker.frame = CGRect(x:50, y:120, width:pickerSize.width - 16, height:400)
            self.view.addSubview(picker)
            picker.backgroundColor = .darkGray
            picker.translatesAutoresizingMaskIntoConstraints = false
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            picker.widthAnchor.constraint(equalToConstant: pickerSize.width).isActive = true
            picker.heightAnchor.constraint(equalToConstant: pickerSize.height).isActive = true
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
   
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    func mbProgress(_ onoff: Bool){
        if onoff{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }else{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        let notificationName = Notification.Name("ChangeTrainUnit")
        //        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateNoti(noti:)), name: notificationName, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(clearDatas(noti:)), name: Notification.Name("ClearDatas"), object: nil)
        NotificationCenter.default.addObserver(forName: Notification.Name("isModeSetToSimple"), object: nil, queue: OperationQueue.main) { notification in
            self.isModeSetToSimple = !self.isModeSetToSimple
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("prepareTime"), object: nil, queue: OperationQueue.main) { notitfication in
            let data = notitfication.userInfo!["prepareTime"]
            self.prepareTime = data as! Int
        }
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        var imagedata = try! NSData.init()
        var image = UIImage()
        NotificationCenter.default.addObserver(forName: Notification.Name("TrainingItemDeliver"), object: nil, queue: OperationQueue.current) { notification in
            let breastdatas = notification.userInfo!["breastItems"] as! [TrainingItem]
            for x in 0 ..< breastdatas.count{
                if !self.formListBreast.contains(breastdatas[x].name!){
                self.formListBreast.append(breastdatas[x].name!)
                self.trainBreastText.append(breastdatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(breastdatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.breastImageforms.append(image)
                }
            }
            let backdatas = notification.userInfo!["backItems"] as! [TrainingItem]
            for x in 0 ..< backdatas.count{
                if !self.formListBack.contains(backdatas[x].name!){
                self.formListBack.append(backdatas[x].name!)
                self.trainBackText.append(backdatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(backdatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.backImageforms.append(image)
                }
            }
            let abdomendatas = notification.userInfo!["abdomenItems"] as! [TrainingItem]
            for x in 0 ..< abdomendatas.count{
                if !self.formListAbdomen.contains(abdomendatas[x].name!){
                self.formListAbdomen.append(abdomendatas[x].name!)
                self.trainAbdomenText.append(abdomendatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(abdomendatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.abdomenImageforms.append(image)
                }
            }
            let bldatas = notification.userInfo!["blItems"] as! [TrainingItem]
            for x in 0 ..< bldatas.count{
                if !self.formListBL.contains(bldatas[x].name!){
                self.formListBL.append(bldatas[x].name!)
                self.trainBLText.append(bldatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(bldatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.blImageforms.append(image)
                }
            }
            let armdatas = notification.userInfo!["armItems"] as! [TrainingItem]
            for x in 0 ..< armdatas.count{
                if !self.formListArm.contains(armdatas[x].name!){
                self.formListArm.append(armdatas[x].name!)
                self.trainArmText.append(armdatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(armdatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.armImageforms.append(image)
                }
            }
            let exdatas = notification.userInfo!["exerciseItems"] as! [TrainingItem]
            for x in 0 ..< exdatas.count{
                if !self.formListEx.contains(exdatas[x].name!){
                self.formListEx.append(exdatas[x].name!)
                self.trainExText.append(exdatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(exdatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.exerciseImageform.append(image)
                }
            }
            print("done")
            self.mbProgress(false)
            self.RecordListTV.dataSource = self
            self.RecordListTV.delegate = self
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("infoItems"), object: nil, queue: OperationQueue.main) { notification in
            let infodatas = notification.userInfo!["infoItems"] as! [InfoItemCoreData]
            
            
            for x in 0 ..< infodatas.count{
                self.infodatainside.append(infodatas[x].title!)
                self.infodatacontent.append(infodatas[x].content!)
                self.infodataUserName.append(infodatas[x].editorName!)
                self.infodataEmail.append(infodatas[x].editorEmail!)
            }
        }
        // If TrainingItems is edited will notify the data to here
        NotificationCenter.default.addObserver(forName: Notification.Name("reloadBreastItems"), object: nil, queue: OperationQueue.main) { notification in
            self.formListBreast = [ "訓練項目"]
            self.trainBreastText = [ "訓練項目"]
            self.breastImageforms = [UIImage(named: "nocolor")!]
            let breastdatas = notification.userInfo!["BreastItems"] as! [TrainingItem]
            for x in 0 ..< breastdatas.count {
                self.formListBreast.append(breastdatas[x].name!)
                self.trainBreastText.append(breastdatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(breastdatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.breastImageforms.append(image)
                
            }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("reloadBackItems"), object: nil, queue: OperationQueue.main) { notification in
            self.formListBack = [ "訓練項目"]
            self.trainBackText = [ "訓練項目"]
            self.backImageforms = [UIImage(named: "nocolor")!]
            let backdatas = notification.userInfo!["BackItems"] as! [TrainingItem]
            for x in 0 ..< backdatas.count{
                self.formListBack.append(backdatas[x].name!)
                self.trainBackText.append(backdatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(backdatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.backImageforms.append(image)
                
            }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("reloadAbdomenItems"), object: nil, queue: OperationQueue.main) { notification in
            self.formListAbdomen = [ "訓練項目"]
            self.trainAbdomenText = [ "訓練項目"]
            self.abdomenImageforms = [UIImage(named: "nocolor")!]
            let abdomendatas = notification.userInfo!["AbdomenItems"] as! [TrainingItem]
            for x in 0 ..< abdomendatas.count{
                
                self.formListAbdomen.append(abdomendatas[x].name!)
                self.trainAbdomenText.append(abdomendatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(abdomendatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.abdomenImageforms.append(image)
                
            }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("reloadBLItems"), object: nil, queue: OperationQueue.main) { notification in
            self.formListBL = [ "訓練項目"]
            self.trainBLText = [ "訓練項目"]
            self.blImageforms = [UIImage(named: "nocolor")!]
            let bldatas = notification.userInfo!["BLItems"] as! [TrainingItem]
            for x in 0 ..< bldatas.count{
                self.formListBL.append(bldatas[x].name!)
                self.trainBLText.append(bldatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(bldatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.blImageforms.append(image)
                
            }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("reloadExItems"), object: nil, queue: OperationQueue.main) { notification in
            self.formListEx = [ "訓練項目"]
            self.trainExText = [ "訓練項目"]
            self.exerciseImageform = [UIImage(named: "nocolor")!]
            let exdatas = notification.userInfo!["ExItems"] as! [TrainingItem]
            for x in 0 ..< exdatas.count{
                self.formListEx.append(exdatas[x].name!)
                self.trainExText.append(exdatas[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(exdatas[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.exerciseImageform.append(image)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print(error)
//        }
//        
        
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        var imagedata = try! NSData.init()
        var image = UIImage()
        let breastItems = ManageTrainingItem.share.getTrainingItem(Location: "BrestShoulder")
        let backItems = ManageTrainingItem.share.getTrainingItem(Location: "Back")
        let abdomenItems = ManageTrainingItem.share.getTrainingItem(Location: "Abdomen")
        let armItems = ManageTrainingItem.share.getTrainingItem(Location: "Arm")
        let blItems = ManageTrainingItem.share.getTrainingItem(Location: "BottomLap")
        let exerciseItems = ManageTrainingItem.share.getTrainingItem(Location: "Exercise")
        if let breast = breastItems, let back = backItems, let abdomen = abdomenItems, let arm = armItems, let bl = blItems, let ex = exerciseItems{
            for x in 0 ..< breast.count{
                self.formListBreast.append(breast[x].name!)
                self.trainBreastText.append(breast[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(breast[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.breastImageforms.append(image)
            }
            for x in 0 ..< back.count{
                self.formListBack.append(back[x].name!)
                self.trainBackText.append(back[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(back[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.backImageforms.append(image)
            }
            for x in 0 ..< abdomen.count{
                self.formListAbdomen.append(abdomen[x].name!)
                self.trainAbdomenText.append(abdomen[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(abdomen[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.abdomenImageforms.append(image)
            }
            for x in 0 ..< bl.count{
                self.formListBL.append(bl[x].name!)
                self.trainBLText.append(bl[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(bl[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.blImageforms.append(image)
            }
            for x in 0 ..< arm.count{
                self.formListArm.append(arm[x].name!)
                self.trainArmText.append(arm[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(arm[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.armImageforms.append(image)
            }
            for x in 0 ..< ex.count{
                self.formListEx.append(ex[x].name!)
                self.trainExText.append(ex[x].def!)
                imagedata = try! NSData.init(contentsOf: homeUrl.appendingPathComponent(ex[x].imageName!))
                image = UIImage(data: imagedata as Data)!
                self.exerciseImageform.append(image)
            }
            self.RecordListTV.dataSource = self
            self.RecordListTV.delegate = self
        }else{
            mbProgress(true)
        }
        
        
        
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
        if #available(iOS 13.0, *) {
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

        if #available(iOS 14.0, *) {
            pauseAndplayImageButton.addAction(pauseTraining, for: .touchUpInside)
        } else {
            // Fallback on earlier versions
            pauseAndplayImageButton.addTarget(self, action: #selector(pausetraining), for: .touchUpInside)
        }
        }
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
        if #available(iOS 13.0, *) {
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
        
        if #available(iOS 14.0, *) {
            stopRestingButton.addAction(stopRestBtnAction, for: .touchUpInside)
        } else {
            // Fallback on earlier versions
            stopRestingButton.addTarget(self, action: #selector(stopRestBtnaction), for: .touchUpInside)
        }
        }
        stopRestingButton.setImage(UIImage(named: "stop"), for: .normal)
        var stopTrainBegin: Any?
        if #available(iOS 13.0, *) {
             stopTrainBegin = UIAction(title: "stopTrainBegin"){(action) in
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
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 14.0, *) {
            stopTrainingButton.addAction(stopTrainBegin as! UIAction, for: .touchUpInside)
        } else {
            // Fallback on earlier versions
            stopTrainingButton.addTarget(self, action: #selector(stoptrainbegin), for: .touchUpInside)
        }
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
//        if Auth.auth().currentUser == nil {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                    self.bannerView.translatesAutoresizingMaskIntoConstraints = false
                    self.bannerView.adUnitID = "ca-app-pub-8982946958697547/5526736499"//廣告編號
                    //                                    "ca-app-pub-8982946958697547/5526736499"
                    //ca-app-pub-3940256099942544/2934735716
                    self.bannerView.rootViewController = self
                    self.bannerView.delegate = self
                    self.bannerView.load(GADRequest())
                }
                
                
            }
        } else {
            // Fallback on earlier versions
            self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            self.bannerView.translatesAutoresizingMaskIntoConstraints = false
            self.bannerView.adUnitID = "ca-app-pub-8982946958697547/5526736499"//廣告編號
            //                                    "ca-app-pub-8982946958697547/5526736499"
            //ca-app-pub-3940256099942544/2934735716
            self.bannerView.rootViewController = self
            self.bannerView.delegate = self
            self.bannerView.load(GADRequest())
        }
//        }
        // Check the System Mode
        isModeSetToSimple = UserDefaults.standard.bool(forKey: "isModeSetToSimple")
           
    }
    @objc func stoptrainbegin() {
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
    
    @objc func stopRestBtnaction(){
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
    var isPlay: Bool = false
    
    @objc func pausetraining(){
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
            restbarbtn = UIBarButtonItem(image: UIImage(systemName: "bed.double.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), style: .plain, target: self, action: #selector(registerTheMember))
        }
        
        let adjusttrainingparameters = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(trainingParametersChange))
        let trainstartbarbtn = UIBarButtonItem(image: UIImage(named: "start"), style: .plain, target: self, action: #selector(trainStartBtnPressed))
        let trainreportbarbtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(trainreportgo))
        var flexible = UIBarButtonItem()
        if #available(iOS 14.0, *) {
             flexible = UIBarButtonItem.flexibleSpace()
        } else {
            // Fallback on earlier versions
            flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        }
        let traindatebarbtn = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(showDateBarBtnPressed))
        ToolBar.setItems([restbarbtn,flexible,adjusttrainingparameters,flexible, trainstartbarbtn,flexible,trainreportbarbtn,flexible,traindatebarbtn], animated: false)
        ToolBar.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadFromFile()
        RecordListTV.reloadData()
        TrainPickerView.reloadAllComponents()
    }
    @objc func trainingParametersChange(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageTrainSetPage") as? ManageTrainSetVC
        vc?.trainLS = trainLS
        self.navigationController?.pushViewController(vc!,animated: true)
        
    }
    @objc func trainreportgo() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SharePage") as? ShareViewController
        vc?.formListBL = formListBL
        vc?.formListBrest = formListBreast
        vc?.formListEx = formListEx
        vc?.formListArm = formListArm
        vc?.formListBack = formListBack
        vc?.formListAbdomen = formListAbdomen
        vc?.dateRecord = dateRecord
        self.navigationController?.pushViewController(vc!,animated: true)
        
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
//            trainingItemCoreDataStore(locationnumber, itemimage[x], itemname[x], itemdef[x], x + 1)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
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
            }else{
                print("wrong")
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
            
        }else if segue.identifier == "Segue_Home_InfoVC" {
            let vc = segue.destination as! InfoTableViewController
            vc.infodata = infodatainside
            vc.infocontent = infodatacontent
            vc.infoEmail = infodataEmail
            vc.infoUserName = infodataUserName
        }else if segue.identifier == "segue_Home_SystemVC"{
            let vc = segue.destination as! SystemTableViewController
            vc.dateRecord = dateRecord
        }
        
    }
  
    
    
    
    // MARK:GADBannerViewDelegate
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            let _ = GADAdSizeFromCGSize(CGSize(width: 323, height: 20))

            if bannerView.superview == nil /*&& Auth.auth().currentUser == nil*/ {
                            self.RecordListTV.tableHeaderView = bannerView
                        //第一次廣告進來
//                        self.view.addSubview(bannerView)
                        //關閉tableview上緣的條件
                        //廣告上緣貼齊safearea的上緣
//                        RecordListTV.topAnchor.constraint(equalTo: self.TrainPickerView.bottomAnchor, constant: 0).isActive = false
//                        bannerView.topAnchor.constraint(equalTo: self.TrainPickerView.bottomAnchor,constant: 30).isActive = true
//                        //廣告下緣貼齊tableView的上緣
//                        bannerView.bottomAnchor.constraint(equalTo: self.RecordListTV.topAnchor).isActive = true
//                        //廣告左右緣貼齊self.view的左右
//                        bannerView.rightAnchor.constraint(equalTo: self.RecordListTV.rightAnchor,constant: 16).isActive = true
//                        bannerView.leftAnchor.constraint(equalTo: self.RecordListTV.leftAnchor,constant: 16).isActive = true
//                RecordListTV.topAnchor.constraint(equalTo: self.bannerView.bottomAnchor, constant: 0).isActive = true
//                        bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true

                    }

        }
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
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
            print(formListBreast)
            return formListBreast[locationdata[1]]
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


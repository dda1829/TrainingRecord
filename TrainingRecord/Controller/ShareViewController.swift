//
//  ShareViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/8.
//

import UIKit
import Firebase
class ShareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    var ratingForm: [String] = []
    var titleForm: [String] = []
    var subtitleForm: [String] = []
    var titleFormShare: [String] = []
    var recordListString = ""
    var recordsort: [[Int]] = []
    var trainItem: RecordItem?
    var dateRecord : String = ""
    @IBOutlet weak var dateRecordTitleBtn: UIButton!
    @IBOutlet weak var userReportLeft: UITextView!
    @IBOutlet weak var userReportRight: UITextView!
    @IBOutlet weak var RecodListTV: UITableView!
    
    @IBOutlet weak var shareBtn: UIButton!
    required init?(coder: NSCoder) {
        super.init(coder: coder)  
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "訓練紀錄報表"
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(share))
        
        // Do any additional setup after loading the view.
        if Auth.auth().currentUser != nil && UserDefaults.standard.bool(forKey: "isMemberDataEdited"){
            var conclusionright = ""
            var conclusionleft = ""
            let userAge = MemberUserDataToFirestore.share.getUserdatas("userAge") as! String
            let userGender = MemberUserDataToFirestore.share.getUserdatas("userGender") as! String
            let userHeight = MemberUserDataToFirestore.share.getUserdatas("userHeight") as! [String]
            let userWeight = MemberUserDataToFirestore.share.getUserdatas("userWeight") as! [String]
            let userBodyFat = MemberUserDataToFirestore.share.getUserdatas("userBodyFat") as! [String]
            let BMIo = (MemberUserDataToFirestore.share.getUserdatas("userBMI") as! [String]).last
            let BMRo = (MemberUserDataToFirestore.share.getUserdatas("userBMR") as! [String]).last
            let BMI = Double(BMIo!)
            let BMR = Double(BMRo!)
            let noInput = "NoData"
            if userAge != ""{
            conclusionright = "用戶年齡：  " + userAge + " 歲\n"
            }else{
                conclusionright = "用戶年齡：  " + noInput + " 歲\n"
            }
            conclusionleft = "用戶名稱：  " + (MemberUserDataToFirestore.share.getUserdatas("userName") as! String) + "\n"
            if  userGender != ""{
                conclusionleft += "用戶性別：  " + userGender + "\n"
            }else{
                conclusionleft += "用戶性別：  " + noInput + "\n"
            }
            
            conclusionright += "用戶身高：  " + userHeight.last! + " cm\n"
            conclusionleft += "用戶體重：  " + userWeight.last! + " kg\n"
            conclusionright += "用戶體脂:  " + userBodyFat.last! + " %\n"
            if BMI == 0.0 {
                conclusionleft += "BMI:  資料不足\n"
            }else{
                conclusionleft += "BMI：  " + String(format: "%.2f", BMI!) + "\n"
            }
            
            if BMR == 0.0{
                conclusionright += "BMR：  資料不足\n"
            }else {
                conclusionright += "BMR:  " + String(format: "%.2f", BMR!) + "\n"
            }
            conclusionleft += "^ 身體質量指數"
            conclusionright += "^ 基礎代謝率"
            
            
        userReportLeft.text = conclusionleft
        userReportRight.text = conclusionright
            let border = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            border.backgroundColor = .white
            self.view.addSubview(border)
            border.translatesAutoresizingMaskIntoConstraints = false
            border.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16 ).isActive = true
            border.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
            border.bottomAnchor.constraint(equalTo: RecodListTV.topAnchor, constant: 0).isActive = true
            border.heightAnchor.constraint(equalToConstant: 5).isActive = true
        }else{
        let warningWord = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(warningWord)
        warningWord.translatesAutoresizingMaskIntoConstraints = false
            warningWord.topAnchor.constraint(equalTo: self.dateRecordTitleBtn.bottomAnchor, constant: 0).isActive = true
        warningWord.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16 ).isActive = true
        warningWord.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        warningWord.heightAnchor.constraint(equalToConstant: 50).isActive = true
            warningWord.text = "請先完成會員資料，以此作為完整運動報表，感謝。"
            warningWord.textColor = .red
            warningWord.font = UIFont.systemFont(ofSize: 14)
            warningWord.isEditable = false
            warningWord.isSelectable = false
            warningWord.backgroundColor = .black
        }
        RecodListTV.delegate = self
        RecodListTV.dataSource = self
        RecodListTV.register(SharedTableViewCell.nib(), forCellReuseIdentifier: SharedTableViewCell.identifier)
        loadFromFile()
        subtitleForm = recordStringGen()
        titleForm = recordLocationStringGen()
        titleFormShare = recordLocationStringGen2()
        
        dateRecordTitleBtn.setTitle(dateRecord, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadFromFile()
    }
    
    var showDateBtnClick = false
    var picker = UIDatePicker()
    
    @IBAction func dateRecordTitleBtnPressed(_ sender: Any) {
        if !showDateBtnClick {
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.addTarget(self, action:#selector(dueDateChanged(sender:)),for: UIControl.Event.valueChanged)
        
            // you probably don't want to set background color as black
        
            if #available(iOS 14.0, *) {
                picker.preferredDatePickerStyle = .inline
            } else {
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
        dateRecordTitleBtn.setTitle(dateFormatter.string(from: sender.date), for: .normal)
        dateRecord = dateFormatter.string(from: sender.date)
        showDateBtnClick = !showDateBtnClick
        loadFromFile()
        print("DatePicke is used")
        RecodListTV.reloadData()
        print(dateRecord)
        picker.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(dateRecord)"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trainItem != RecordItem(dateRecord, [:], [:], [], [:], [:], [:], []) {
            return titleForm.count /*(trainItem?.trainLocation.count)!*/
        }
        return 0
    }
    
    
    func recordStringGen () -> [String]{
        var result: [String] = []
        
        
        if trainItem != RecordItem(dateRecord, [:], [:], [], [:], [:], [:], []) {
            
            let locationsort = trainItem!.trainLocationSort
            var target : [[Int]] = []
            for x in locationsort {
                if !target.contains(x) {
                    target.append(x)
                }
            }
            
            for trainlocation in target{
                if trainlocation[0] == 6{
                    let recordstringdefault = "第\(1)組  \( trainItem!.trainTimes[trainlocation]![0]) Times"
                    recordListString = recordstringdefault
                    for itemSetCount in 1 ..< (trainItem?.trainSet[trainlocation])! {
                        let y = itemSetCount + 1
                        recordListString += "\n第\(y)組  \(trainItem!.trainTimes[trainlocation]![itemSetCount]) Times"
                        
                    }
                }else{
                    let recordstringdefault = "第\(1)組  \(trainItem!.trainWeight[trainlocation]![0]) \(trainItem!.trainUnit[trainlocation]![0]) * \( trainItem!.trainTimes[trainlocation]![0]) Times"
                    recordListString = recordstringdefault
                    for itemSetCount in 1 ..< (trainItem?.trainSet[trainlocation])! {
                        let y = itemSetCount + 1
                        recordListString += "\n第\(y)組  \(trainItem!.trainWeight[trainlocation]![itemSetCount]) \(trainItem!.trainUnit[trainlocation]![itemSetCount]) * \(trainItem!.trainTimes[trainlocation]![itemSetCount]) Times"
                        
                    }
                }
                result.append(recordListString)
                recordsort.append(trainlocation)
                
                
            }
        }
        
        
        print("record String result = \(result)")
        
        return result
        
        
        
    }
    
    
    
    func recordLocationStringGen () -> [String] {
        var result: [String] = []
        var rateResult:[String] = []
        var trainRateSeperate : [[Int]:[String]] = [:]
        var traincount = 0
        for x in trainItem!.trainLocationSort {
            if trainRateSeperate[x] == nil {
                trainRateSeperate.updateValue(([trainItem!.trainRate[traincount]]), forKey: x)
            }else{
                trainRateSeperate[x]?.append(trainItem!.trainRate[traincount])
            }
            traincount += 1
        }
        var ratingScore: [[Int]:[Double]] = [:]
        var rating = 0.0
        for x in recordsort{
            
            for y in 0 ..< trainRateSeperate[x]!.count{
                switch trainRateSeperate[x]![y] {
                case "Good":
                    if ratingScore[x] == nil {
                        ratingScore.updateValue([1], forKey: x)
                    }else{
                        ratingScore[x]?.append(1)
                    }
                case "Normal":
                    if ratingScore[x] == nil {
                        ratingScore.updateValue([0], forKey: x)
                    }else{
                        ratingScore[x]?.append(0)
                    }
                case "Bad":
                    if ratingScore[x] == nil {
                        ratingScore.updateValue([-1], forKey: x)
                    }else{
                        ratingScore[x]?.append(-1)
                    }
                default:
                    if ratingScore[x] == nil {
                        ratingScore.updateValue([0], forKey: x)
                    }else{
                        ratingScore[x]?.append(0)
                    }
                }
                if y == trainRateSeperate[x]!.count - 1 {
                    for z in ratingScore[x]!{
                         rating += z
                    }
                    if rating >= 1 {
                        rateResult.append("😃，感覺良好。")
                    }else if rating == 0{
                        rateResult.append("😐，感覺普通。")
                    }else if rating == -1 {
                        rateResult.append("😱，感覺很糟。")
                    }else{
                        rateResult.append("資訊不足")
                    }
                }
                rating = 0
            }
        }
        var locationString = ""
        var ratecount = 0
        for x in recordsort {
            if (trainItem?.trainSet[x])! <= 2 {
                locationString = "\(fitRecordLocation(x))-\(fitRecordLocationItem(x))" + "\n" + rateResult[ratecount]
            }else{
                locationString = ""
                for _ in 0 ..< (trainItem?.trainSet[x])!/4 {
                    locationString += "\n"
                }
                locationString += "\(fitRecordLocation(x))-\(fitRecordLocationItem(x))" + "\n" + rateResult[ratecount]
//                for _ in 0 ..< (trainItem?.trainSet[x])!/3 {
//                    locationString += "\n"
//                }
            }
            ratecount += 1
            result.append(locationString)
        }
        print("record location result = \(result)")
        return result
    }
    
    func recordLocationStringGen2 () -> [String] {
        var result: [String] = []
        var rateResult:[String] = []
        var trainRateSeperate : [[Int]:[String]] = [:]
        var traincount = 0
        for x in trainItem!.trainLocationSort {
            if trainRateSeperate[x] == nil {
                trainRateSeperate.updateValue(([trainItem!.trainRate[traincount]]), forKey: x)
            }else{
                trainRateSeperate[x]?.append(trainItem!.trainRate[traincount])
            }
            traincount += 1
        }
        var ratingScore: [[Int]:[Double]] = [:]
        var rating = 0.0
        for x in recordsort{
            
            for y in 0 ..< trainRateSeperate[x]!.count{
                switch trainRateSeperate[x]![y] {
                case "Good":
                    if ratingScore[x] == nil {
                        ratingScore.updateValue([1], forKey: x)
                    }else{
                        ratingScore[x]?.append(1)
                    }
                case "Normal":
                    if ratingScore[x] == nil {
                        ratingScore.updateValue([0], forKey: x)
                    }else{
                        ratingScore[x]?.append(0)
                    }
                case "Bad":
                    if ratingScore[x] == nil {
                        ratingScore.updateValue([-1], forKey: x)
                    }else{
                        ratingScore[x]?.append(-1)
                    }
                default:
                    if ratingScore[x] == nil {
                        ratingScore.updateValue([0], forKey: x)
                    }else{
                        ratingScore[x]?.append(0)
                    }
                }
                if y == trainRateSeperate[x]!.count - 1 {
                    for z in ratingScore[x]!{
                         rating += z
                    }
                    if rating >= 1 {
                        rateResult.append("😃，感覺良好。")
                    }else if rating == 0{
                        rateResult.append("😐，感覺普通。")
                    }else if rating == -1 {
                        rateResult.append("😱，感覺很糟。")
                    }else{
                        rateResult.append("資訊不足")
                    }
                }
                rating = 0
            }
        }
        var locationString = ""
        var ratecount = 0
        for x in recordsort {
                locationString = "\(fitRecordLocation(x))-\(fitRecordLocationItem(x))" + "\n" + rateResult[ratecount]
            
            ratecount += 1
            result.append(locationString)
        }
        print("record location result = \(result)")
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharedTableViewCell", for: indexPath) as! SharedTableViewCell
        print("tableview dateRecord = \(dateRecord)")
        if trainItem != RecordItem(dateRecord, [:], [:], [], [:], [:], [:], []) {
            
            print("data is not nil")
           
            
            cell.titleLabel.text = titleForm[indexPath.row]
            cell.subTitleLabel.text = subtitleForm[indexPath.row]
//            cell.rateLabel.text = ratingForm[indexPath.row] ?? "未有足夠的資訊"
            
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
    
    
    
    
    var formListLocation: [String] = ["運動部位", "肩胸部","背部", "核心","臀腿部",  "手臂","有氧運動"]
    var formListBrest : [String] = [ "訓練項目"]
    var formListBL : [String] = [ "訓練項目"]
    var formListAbdomen : [String] = [ "訓練項目"]
    var formListArm : [String] = [ "訓練項目"]
    var formListEx : [String] = [ "訓練項目"]
    var formListBack : [String] = [ "訓練項目"]
    
    //MARK: Archiving
    func writeToFile()  {
        //
        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
        let file = doc.appendingPathComponent("RecordDatas")
        let file2 = file.appendingPathComponent("\(dateRecord)")
        let filePath = file2.appendingPathComponent("RecordDatas.archive")
        do {
            //將data陣列，轉成Data型式（二進位資料）
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.trainItem as Any, requiringSecureCoding: false)
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
                self.trainItem = arrayData//轉成功就放到self.data裏
            }
        } catch  {
            print("error while fetching data array \(error)")
            self.trainItem = RecordItem(dateRecord, [:], [:], [], [:], [:], [:], [])//有任何錯誤,空陣列
        }
    }
    
    func fitSizeImage(_ image: UIImage,_ size: CGSize) -> UIImage? {
        
            let scale = UIScreen.main.scale //找出目前螢幕的scale，視網膜技術為2.0 //產生畫布，第一個參數指定大小,第二個參數true:不透明(黑色底),false表示透明背景,scale為螢幕scale
            UIGraphicsBeginImageContextWithOptions(size,false,scale)
            //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill //最小值MIN會變成UIViewContentModeScaleAspectFit
            image.draw(in:CGRect(x: 0,y: 0,
                                 width: size.width,height: size.height)) //取得畫布上的縮圖
            let target = UIGraphicsGetImageFromCurrentImageContext(); //關掉畫布
            UIGraphicsEndImageContext();
            return target
    }
    func pb_takeSnapshot() -> UIImage {
        let imageA = UIImage(named: "background")!.withRenderingMode(.alwaysTemplate).withTintColor(.darkGray)
        var font=UIFont(name: "Helvetica-Bold", size: 15)!
        let paraStyle=NSMutableParagraphStyle()
        paraStyle.alignment=NSTextAlignment.center
        var attributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paraStyle]
        let height = font.lineHeight
        let strRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height)
        let wantimageASize = CGSize(width: self.view.frame.width, height: height)
        let titlex1:CGFloat = -10
        var imageBHeight: CGFloat = 40
        var imageBLocationY: CGFloat = 2 + height
        let imageB = UIImage(named: "background")!.withRenderingMode(.alwaysTemplate).withTintColor(.black)
        
        if recordsort.count != 0 {
            for x in 0 ..< titleFormShare.count {
                imageBHeight = 40
                var fitsizecount = 0
                while fitsizecount < (trainItem?.trainSet[recordsort[x]])!{
                    fitsizecount += 1
                    if fitsizecount % 2 == 0 {
                        imageBHeight += 20
                    }
                }
                imageBLocationY += imageBHeight + 2
        }
        }
        let drawSize = CGSize(width: self.view.frame.width, height: imageBLocationY )
        
        imageBHeight = 40
        imageBLocationY = 2 + height
        UIGraphicsBeginImageContextWithOptions(drawSize, false, 0.0)
        
        fitSizeImage(imageA, wantimageASize)?.draw(in: strRect.integral)
        (dateRecord as NSString).draw(in: strRect.integral, withAttributes: attributes)
       
        font = UIFont(name: "Helvetica-Bold", size: 13)!
        attributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paraStyle]
        if recordsort.count != 0 {
            for x in 0 ..< titleFormShare.count {
                imageBHeight = 40
                var fitsizecount = 0
                while fitsizecount < (trainItem?.trainSet[recordsort[x]])!{
                    fitsizecount += 1
                    if fitsizecount % 2 == 0 {
                        imageBHeight += 20
                    }
                }
        let wantBSize = CGSize(width: self.view.frame.width, height: imageBHeight)
        let titleRect = CGRect(x: titlex1, y: imageBLocationY , width: self.view.frame.width/2, height: imageBHeight)
        let subtitleRect = CGRect(x: self.view.frame.width/2, y: imageBLocationY, width: self.view.frame.width/2, height: imageBHeight)
        fitSizeImage(imageB, wantBSize)?.draw(in: CGRect(x: 0, y: imageBLocationY, width: self.view.frame.width, height: imageBHeight))
            (titleFormShare[x] as NSString).draw(in: titleRect, withAttributes: attributes)
            (subtitleForm[x] as NSString).draw(in: subtitleRect, withAttributes: attributes)
                imageBLocationY += imageBHeight + 2
        }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    @objc func share(){
        let defaultText = "看看我，今天我完成了..."
        
//        let sharedfile = self.view.pb_takeSnapshot()
        let sharedfile = pb_takeSnapshot()
        var activityController: UIActivityViewController
        
        
        activityController = UIActivityViewController(activityItems: [defaultText,sharedfile], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        self.present(activityController, animated: true, completion: nil)
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

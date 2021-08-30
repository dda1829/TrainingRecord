//
//  ShareViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/8.
//

import UIKit

class ShareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var ratingForm: [String] = []
    var titleForm: [String] = []
    var subtitleForm: [String] = []
    
    var recordListString = ""
    var recordsort: [[Int]] = []
    var trainItem: RecordItem?
    var dateRecord : String = ""
    @IBOutlet weak var dateRecordTitleBtn: UIButton!
    @IBOutlet weak var userReportLeft: UITextView!
    @IBOutlet weak var userReportRight: UITextView!
    @IBOutlet weak var RecodListTV: UITableView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "訓練紀錄報表"
        // Do any additional setup after loading the view.
        if let userreportleft = UserDefaults.standard.string(forKey: "userReportLeft"), let userreportright = UserDefaults.standard.string(forKey: "userReportRight"){
        userReportLeft.text = userreportleft
        userReportRight.text = userreportright
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
        }
        RecodListTV.delegate = self
        RecodListTV.dataSource = self
        RecodListTV.register(SharedTableViewCell.nib(), forCellReuseIdentifier: SharedTableViewCell.identifier)
        loadFromFile()
        subtitleForm = recordStringGen()
        titleForm = recordLocationStringGen()
        ratingForm = averageRateGen()

        
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
        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x:50, y:120, width:pickerSize.width - 16, height:400)
            // you probably don't want to set background color as black
        
        picker.preferredDatePickerStyle = .inline
            self.view.addSubview(picker)
        picker.backgroundColor = .darkGray
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            picker.widthAnchor.constraint(equalToConstant: self.view.sizeThatFits(CGSize.zero).width-40).isActive = true
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
            return (trainItem?.trainLocation.count)!
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
        var locationString = ""
        for x in recordsort {
            if (trainItem?.trainSet[x])! <= 2 {
                locationString = "\(fitRecordLocation(x))-\(fitRecordLocationItem(x))"
            }else{
                locationString = ""
                for _ in 0 ..< (trainItem?.trainSet[x])!/2 {
                    locationString += "\n"
                }
                locationString += "\(fitRecordLocation(x))-\(fitRecordLocationItem(x))"
//                for _ in 0 ..< (trainItem?.trainSet[x])!/3 {
//                    locationString += "\n"
//                }
            }
            result.append(locationString)
        }
        print("record location result = \(result)")
        return result
    }
    
    func averageRateGen () -> [String] {
        var result : [String] = []
        
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
                        ratingScore.updateValue([3], forKey: x)
                    }else{
                        ratingScore[x]?.append(3)
                    }
                case "Normal":
                    if ratingScore[x] == nil {
                        ratingScore.updateValue([1.5], forKey: x)
                    }else{
                        ratingScore[x]?.append(1.5)
                    }
                case "Bad":
                    if ratingScore[x] == nil {
                        ratingScore.updateValue([0.5], forKey: x)
                    }else{
                        ratingScore[x]?.append(0.5)
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
                    switch rating/Double(y + 1) {
                    case 2.5 ... 3:
                        result.append("😃，感覺良好。")
                    case 1.5 ..< 2.5:
                        result.append("😐，感覺普通。")
                    case 0 ..< 1.5:
                        result.append("😮‍💨，感覺很糟。")
                    default:
                        result.append("資訊不足")
                    }
                }
                rating = 0
            }
        }
        recordsort = []
        return result
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharedTableViewCell", for: indexPath) as! SharedTableViewCell
        print("tableview dateRecord = \(dateRecord)")
        if trainItem != RecordItem(dateRecord, [:], [:], [], [:], [:], [:], []) {
            
            print("data is not nil")
           
            
            cell.titleLabel.text = titleForm[indexPath.row]
            cell.subTitleLabel.text = subtitleForm[indexPath.row]
            cell.rateLabel.text = ratingForm[indexPath.row] ?? "未有足夠的資訊"
            
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
    @IBAction func shareBtnPressed(_ sender: Any) {
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

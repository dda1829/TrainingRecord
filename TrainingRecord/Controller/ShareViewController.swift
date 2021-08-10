//
//  ShareViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/8.
//

import UIKit

class ShareViewController: UIViewController, ShareTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var data : [String: RecordItem] = [:]
    var dateRecord : String = ""
    @IBOutlet weak var dateRecordTitleBtn: UIButton!
    @IBOutlet weak var userReportLeft: UITextView!
    @IBOutlet weak var userReportRight: UITextView!
    @IBOutlet weak var RecodListTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "訓練紀錄報表"
        // Do any additional setup after loading the view.
        if let userreportleft = UserDefaults.standard.string(forKey: "userReportLeft"), let userreportright = UserDefaults.standard.string(forKey: "userReportRight"){
        userReportLeft.text = userreportleft
        userReportRight.text = userreportright
            let border = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//            border.layer.borderWidth = 2
//            border.layer.borderColor = UIColor.white.cgColor
            border.backgroundColor = .white
            self.view.addSubview(border)
            border.translatesAutoresizingMaskIntoConstraints = false
//            border.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 0).isActive = true
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
            warningWord.text = "請幫我完成會員資料，以此作為完整運動報表，感謝。"
            warningWord.textColor = .red
            warningWord.font = UIFont.systemFont(ofSize: 14)
        }
        RecodListTV.delegate = self
        RecodListTV.dataSource = self
        RecodListTV.register(ShareTableViewCell.nib(), forCellReuseIdentifier: ShareTableViewCell.identifier)
        loadFromFile()
        
        print(data)
        
        dateRecordTitleBtn.setTitle(dateRecord, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadFromFile()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data[dateRecord] != nil {
            return (data[dateRecord]?.trainLocationSort.count)!
        }
        return 0
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
        print("DatePicke is used")
        RecodListTV.reloadData()
        print(dateRecord)
        picker.removeFromSuperview()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as! ShareTableViewCell
        if data[dateRecord] != nil{
            let subtitle = recordStringGen(dateRecord)[indexPath.row]
       let title = rangeTVCTitle(dateRecord)[indexPath.row]

            switch data[dateRecord]!.trainRate[indexPath.row]{
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
//    func forRecordRating(_ traindate: String) -> [String]{
//        let locationsort = data[traindate]!.trainLocationSort
//        var target : [[Int]] = []
//        var result: [String] = []
//        for x in locationsort {
//            if !target.contains(x) {
//                target.append(x)
//            }
//        }
//        for x in target {
//            for y in 0 ..< (data[traindate]?.trainSet[x]!)!{
//                if let z = data[traindate]?.trainRate[x] {
//                    result.append(z[y])
//                }else{
//                    result.append("none")
//                }
//            }
//        }
//        return result
//    }
    var recordsort: [[Int]] = []
    func rangeTVCTitle(_ traindate: String) -> [String]{
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
    var recordListString = ""
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
                if trainlocation[0] == 6{
                    let recordstringdefault = "第\(1)組  \( data[traindate]!.trainTimes[trainlocation]![0]) Times"
                    recordListString = recordstringdefault
                    
                }else{
                    let recordstringdefault = "第\(1)組  \(data[traindate]!.trainWeight[trainlocation]![0]) \(data[traindate]!.trainUnit[trainlocation]![0]) * \( data[traindate]!.trainTimes[trainlocation]![0]) Times"
                    recordListString = recordstringdefault
                    
                }
                result.append(recordListString)
                recordsort.append(trainlocation)
                if trainlocation[0] == 6{
                for itemSetCount in 1 ..< (data[traindate]?.trainSet[trainlocation])! {
                    let y = itemSetCount + 1
                    recordListString = "\n第\(y)組  \(data[traindate]!.trainTimes[trainlocation]![itemSetCount]) Times"
                    result.append(recordListString)
                    recordsort.append(trainlocation)
                }
                    
                }else{
                for itemSetCount in 1 ..< (data[traindate]?.trainSet[trainlocation])! {
                    let y = itemSetCount + 1
                    recordListString = "\n第\(y)組  \(data[traindate]!.trainWeight[trainlocation]![itemSetCount]) \(data[traindate]!.trainUnit[trainlocation]![itemSetCount]) * \(data[traindate]!.trainTimes[trainlocation]![itemSetCount]) Times"
                    result.append(recordListString)
                    recordsort.append(trainlocation)
                }
                    
                }
                
                
                
            }
        }
        
        
        print("record String result = \(result)")
        
        return result
        
        
        
    }
    
    var formListLocation: [String] = ["運動部位", "肩胸部","背部", "核心","臀腿部",  "手臂","有氧運動"]
    var formListBrest : [String] = [ "訓練項目"]
    var formListBL : [String] = [ "訓練項目"]
    var formListAbdomen : [String] = [ "訓練項目"]
    var formListArm : [String] = [ "訓練項目"]
    var formListEx : [String] = [ "訓練項目"]
    var formListBack : [String] = [ "訓練項目"]
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
    func writeToFile()  {
        //
        let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
        let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
        let filePath = doc.appendingPathComponent("RecordDatas.archive")
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
        let filePath = doc.appendingPathComponent("RecordDatas.archive")
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
    @IBAction func shareBtnPressed(_ sender: Any) {
    }
    var preventGoodBtnPressed: [IndexPath] = []
    var preventNormalBtnPressed: [IndexPath] = []
    var preventBadBtnPressed: [IndexPath] = []
    func shareTableViewCellDidTapGood(_ sender: ShareTableViewCell) {
        guard let tappedIndexPath = RecodListTV.indexPath(for: sender) else {return}
        print(tappedIndexPath)
        print("good")
        print(tappedIndexPath.row)
        
        data[dateRecord]!.trainRate[tappedIndexPath.row]="Good"
        
        writeToFile()
        RecodListTV.reloadData()
    }
    
    func shareTableViewCellDidTapNormal(_ sender: ShareTableViewCell) {
        guard let tappedIndexPath = RecodListTV.indexPath(for: sender) else {return}
        print(tappedIndexPath)
        print("normal")
        let key = data[dateRecord]?.trainLocationSort[tappedIndexPath.row]
        data[dateRecord]!.trainRate[tappedIndexPath.row] = "Normal"
        writeToFile()
        RecodListTV.reloadData()
    }
    
    func shareTableViewCellDidTapBad(_ sender: ShareTableViewCell) {
        guard let tappedIndexPath = RecodListTV.indexPath(for: sender) else {return}
        print(tappedIndexPath)
        print("bad")
        let key = data[dateRecord]?.trainLocationSort[tappedIndexPath.row]
        data[dateRecord]!.trainRate[tappedIndexPath.row] = "Bad"
        writeToFile()
        RecodListTV.reloadData()
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

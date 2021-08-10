//
//  SystemMemberViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/4.
//

import UIKit
import Firebase
class SystemMemberViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate {
   
    @IBOutlet weak var sexualAgePV: UIPickerView!
    @IBOutlet weak var targetTextField: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var parameterTV: UITextView!
    @IBOutlet weak var BodyFatTF: UITextField!
    @IBOutlet weak var parametersTVLeft: UITextView!
    @IBOutlet weak var parametersTVRight: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    var age: [Int] = Array(15...70)
    var sex: [String] = ["male","female"]
    var userAge: String?
    var userGender: String?
    var userHeight:[String] = []
    var userWeight:[String] = []
    var userBodyFat:[String] = []
    var userGoals:[String] = []
    var userRecordDate : [String] = []
    var userBMI : [String] = []
    var userBMR : [String] = []
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return sex.count + 1
        }
        else if component == 1 {
            return age.count + 1
        }
        
        
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component:Int)-> String?{
        if component == 0{
            if row == 0 {
                return "生理性別"
            }
            return sex[row-1]
        }
        else if component == 1 {
            if row == 0 {
                return "年齡"
            }
            return "\(age[row-1])"
        }
        return nil
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0 {
            if row != 0 {
            MemberUserDataToFirestore.share.updateUserdata("userGender", sex[row-1])
                userGender = sex[row-1]
            } else {
                MemberUserDataToFirestore.share.updateUserdata("userGender", "性別不詳")
            }
            }
        else if component == 1{
            if row != 0 {
            MemberUserDataToFirestore.share.updateUserdata("userAge", "\(age[row-1])")
                userAge = "\(age[row-1])"
            }else {
                MemberUserDataToFirestore.share.updateUserdata("userAge", "15")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetTextField.delegate = self
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        sexualAgePV.delegate = self
        sexualAgePV.dataSource = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToSysBtn))
        navigationController?.title = "會員資料設定"
        if let height = MemberUserDataToFirestore.share.getUserdatas("userHeight") {
            userHeight = height as! [String]
            heightTF.placeholder = userHeight.last! + "cm"
        }
        if let weight = MemberUserDataToFirestore.share.getUserdatas("userWeight") {
            userWeight = weight as! [String]
            weightTF.placeholder = userWeight.last! + "kg"
        }
        if let bodyfat = MemberUserDataToFirestore.share.getUserdatas("userBodyFat") {
            userBodyFat = bodyfat as! [String]
            BodyFatTF.placeholder = userBodyFat.last! + "%"
        }
        if let goal = MemberUserDataToFirestore.share.getUserdatas("userGoal"){
            userGoals = goal as! [String]
            targetTextField.placeholder = userGoals.last!
        }
        if let bmi = MemberUserDataToFirestore.share.getUserdatas("userBMI") {
            userBMI = bmi as! [String]
        }
        if let bmr = MemberUserDataToFirestore.share.getUserdatas("userBMR") {
            userBMR = bmr as! [String]
        }
        if let recorddate = MemberUserDataToFirestore.share.getUserdatas("userRecordDate") {
            userRecordDate = recorddate as! [String]
        }
        
        
        if MemberUserDataToFirestore.share.checkAge(){
            userAge = MemberUserDataToFirestore.share.getUserdatas("userAge") as! String
            userGender = MemberUserDataToFirestore.share.getUserdatas("userGender") as! String
            if userGender == "male"{
                sexualAgePV.selectRow(1, inComponent: 0, animated: true)
            } else if userGender == "female"{
                sexualAgePV.selectRow(2, inComponent: 0, animated: true)
            }
            sexualAgePV.selectRow(Int(userAge!)! - 14, inComponent: 1, animated: true)
        }
    }
    @objc func backToSysBtn (){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SystemPage") as? SystemTableViewController
        self.navigationController?.pushViewController(vc!,animated: true)
        
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @IBAction func setTargetBtnPressed(_ sender: Any) {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        userRecordDate.append(dateFormatter.string(from: nowDate))
        MemberUserDataToFirestore.share.updateUserdata("userRecordDate", userRecordDate)
        let noInput = "未寫入資料"
        if targetTextField.text != "" {
            userGoals.append(targetTextField.text!)
            UserDefaults.standard.setValue(targetTextField.text!, forKey: "userGoal")
            UserDefaults.standard.synchronize()
        }else{
            userGoals.append(userGoals.last ?? noInput)
        }
            MemberUserDataToFirestore.share.updateUserdata("userGoal", userGoals)
        
        if heightTF.text != "" {
            userHeight.append(heightTF.text!)
        }else{
            userHeight.append(userHeight.last ?? noInput)
        }
        MemberUserDataToFirestore.share.updateUserdata("userHeight", userHeight)
        if weightTF.text != "" {
            userWeight.append(weightTF.text!)
        }else{
            userWeight.append(userWeight.last ?? noInput)
        }
        MemberUserDataToFirestore.share.updateUserdata("userWeight", userWeight)
        if BodyFatTF.text != "" {
            userBodyFat.append(BodyFatTF.text!)
        }else{
            userBodyFat.append(userBodyFat.last ?? noInput)
        }
        MemberUserDataToFirestore.share.updateUserdata("userBodyFat", userBodyFat)
        
        parameterTV.layer.borderWidth = 2
        parameterTV.layer.borderColor = UIColor.white.cgColor
        var conclusionleft = ""
        var conclusionright = ""
        var BMI = 0.0
        if userWeight.last! != noInput && userHeight.last! != noInput {
            BMI = Double(userWeight.last!)! / ((Double(userHeight.last!)! / 100) * (Double(userHeight.last!)! / 100))
        }
        var BMR = 0.0
        if userGender == "male"{
            if userWeight.last! != noInput && userHeight.last! != noInput {
                BMR = 66 + (6.23 * Double(userWeight.last!)! * 2.2046) + (12.7 * (Double(userHeight.last!)! / 2.54) ) - (6.8 * Double(userAge!)!)
            }
        }else{
            if userWeight.last! != noInput && userHeight.last! != noInput {
                BMR = 655 + (4.35 * Double(userWeight.last!)! * 2.2046) + (4.7 * (Double(userHeight.last!)! / 2.54) ) - (4.7 * Double(userAge!)!)
            }
        }
        
        conclusionright = "用戶年齡：  " + userAge! + " 歲\n\n"
        conclusionleft = "用戶名稱：  " + (MemberUserDataToFirestore.share.getUserdatas("userName") as! String) + "\n\n"
        
        conclusionleft += "用戶性別：  " + userGender! + "\n\n"
        conclusionright += "用戶身高：  " + userHeight.last! + " cm\n\n"
        conclusionleft += "用戶體重：  " + userWeight.last! + " kg\n\n"
        conclusionright += "用戶體脂:  " + userBodyFat.last! + " %\n\n"
        if BMI == 0.0 {
            conclusionleft += "BMI:  資料不足\n"
        }else{
            conclusionleft += "BMI：  " + String(format: "%.2f", BMI) + "\n"
        }
        
        if BMR == 0.0{
            conclusionright += "BMR：  資料不足\n"
        }else {
            conclusionright += "BMR:  " + String(format: "%.2f", BMR) + "\n"
        }
        conclusionleft += "^ 身體質量指數"
        conclusionright += "^ 基礎代謝率"
        parameterTV.text = "\n"
        let a = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        a.layer.borderWidth = 2
//        a.layer.borderColor = UIColor.white.cgColor
        a.layer.backgroundColor = UIColor.white.cgColor
        view.addSubview(a)
        a.translatesAutoresizingMaskIntoConstraints = false
        a.topAnchor.constraint(equalTo: self.heightTF.bottomAnchor, constant: 25).isActive = true
        a.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        a.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
//        a.bottomAnchor.constraint(equalTo: self.sendBtn.topAnchor, constant: -50).isActive = true
        a.heightAnchor.constraint(equalToConstant: 5).isActive = true
        parameterTV.inputView?.bringSubviewToFront(parametersTVRight.textInputView)
        parameterTV.backgroundColor = .white.withAlphaComponent(100)
        parametersTVLeft.text = conclusionleft
        parametersTVRight.text = conclusionright
        UserDefaults.standard.setValue(conclusionleft, forKey: "userReportLeft")
        UserDefaults.standard.setValue(conclusionright, forKey: "userReportRight")
        UserDefaults.standard.synchronize()
        isPressedBtn = true
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location >= 11 {
            return false
        }
        return true
    }
    var isPressedBtn = false
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isPressedBtn {
            MemberUserDataToFirestore.share.updateUserdatas()
        }
        
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
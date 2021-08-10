//
//  NewTrainingItemViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/5/19.
//

import UIKit

class ManageTrainSetVC: UIViewController,UITextInputTraits, UITextFieldDelegate {
    var trainWeight : Int = 10
    var trainTimes : Int = 10
    var trainEachSetInterval : Int = 30
    var trainSetEachInterval : Float = 1
    var trainUnit: String = "kg"
    
    @IBOutlet weak var trainWeightTF: UITextField!

    @IBOutlet weak var trainWeightSlider: UISlider!
    
    @IBOutlet weak var trainWeightMinTF: UITextField!
    @IBOutlet weak var trainWeightMaxTF: UITextField!
    @IBOutlet weak var unit: UILabel!
    
  
    @IBOutlet weak var trainTimesTF: UITextField!
    
    @IBOutlet weak var trainTimesSlider: UISlider!

    @IBOutlet weak var trainTimesMinTF: UITextField!
    
    @IBOutlet weak var trainTimesMaxTF: UITextField!
    
    @IBOutlet weak var trainSetEachIntervalTF: UITextField!
    @IBOutlet weak var trainSetEachIntervalSlider: UISlider!

    @IBOutlet weak var trainSetEachIntervalMinTF: UITextField!
    @IBOutlet weak var trainSetEachIntervalMaxTF: UITextField!
    
    
    @IBOutlet weak var trainEachSetIntervalTF: UITextField!
    
    @IBOutlet weak var trainEachSetIntervalSlider: UISlider!
    
    @IBOutlet weak var trainEachSetIntervalMinTF: UITextField!
    
    @IBOutlet weak var trainEachSetIntervalMaxTF: UITextField!
    
//    var originalFrame : CGRect?
//    //畫面顯示時註冊通知
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //註冊UIKeyboardWillShow通知
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        //註冊UIKeyboardWillHide通知
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    //畫面消失時取消註冊通知
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
//   
//    
//    @objc func keyboardWillAppear(notification : Notification)  {
//        let info = notification.userInfo!
//        let currentKeyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//        let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
//        //取得textField的frame（windows座標)
//        let textFrame = self.view.window!.convert(self.trainEachSetIntervalTF.frame, from: self.view)
//        let textFrame2 = self.view.window!.convert(self.trainEachSetIntervalMaxTF.frame, from: self.view)
//        let textFrame3 = self.view.window!.convert(self.trainEachSetIntervalMinTF.frame, from: self.view)
//        var visibleRect = self.view.frame
//        if self.originalFrame == nil {
//            self.originalFrame = visibleRect
//        }
//        //如果textField frame（windows座標)的最低點 > keyboard frame minY,將view往上移
//        if (  textFrame.maxY > currentKeyboardFrame.minY ) || (  textFrame2.maxY > currentKeyboardFrame.minY ) || (  textFrame3.maxY > currentKeyboardFrame.minY ) {
//            //計算差額
//            let difference = textFrame3.maxY - currentKeyboardFrame.minY + 20
//            visibleRect.origin.y = visibleRect.origin.y - difference
//            //將controller view的 y 往上移
//            UIView.animate(withDuration: duration) {
//                self.view.frame = visibleRect
//            }
//        }
//    }
//    @objc func keyboardWillHide(notification : Notification)  {
//        let info = notification.userInfo!
//        //回復原本的位置,注意這裏的duration 要設的跟66行一樣，可以自行調整
//        UIView.animate(withDuration: 0.5) {
//            self.view.frame = self.originalFrame!
//        }
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 註冊tab事件，點選瑩幕任一處可關閉瑩幕小鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        trainUnit = UserDefaults.standard.string(forKey: "trainUnit") ?? "Kg"
        unit.text = trainUnit
        if UserDefaults.standard.float(forKey: "trainWeight") != 0.0{
            trainWeightSlider.value = UserDefaults.standard.float(forKey: "trainWeight")
            trainWeightTF.text = "\(UserDefaults.standard.integer(forKey: "trainWeight"))"
        }
        trainWeightSlider.value = Float(trainWeight)
        trainWeightTF.text = "\(trainWeight)"
        if UserDefaults.standard.float(forKey: "trainTimes") != 0.0{
            trainTimesTF.text = "\(UserDefaults.standard.integer(forKey: "trainTimes"))"
            trainTimesSlider.value = UserDefaults.standard.float(forKey: "trainTimes")
        }
        trainTimesTF.text = "\(trainTimes)"
        trainTimesSlider.value = Float(trainTimes)
        if UserDefaults.standard.integer(forKey: "trainEachSetInterval") != 0 {
            trainEachSetIntervalTF.text = "\(UserDefaults.standard.integer(forKey: "trainEachSetInterval"))"
            trainEachSetIntervalSlider.value = UserDefaults.standard.float(forKey: "trainEachSetInterval")
        }
        trainEachSetIntervalTF.text = "\(trainEachSetInterval)"
        trainEachSetIntervalSlider.value = Float(trainEachSetInterval)
        if UserDefaults.standard.float(forKey: "trainSetEachInterval") != 0.0 {
            trainSetEachIntervalTF.text = "\(UserDefaults.standard.float(forKey: "trainSetEachInterval"))"
            trainSetEachIntervalSlider.value = UserDefaults.standard.float(forKey: "trainSetEachInterval")
        }
        trainSetEachIntervalTF.text = "\(trainSetEachInterval)"
        trainSetEachIntervalSlider.value = trainSetEachInterval
    }
   
    // 關閉瑩幕小鍵盤
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    
    @IBAction func trainWeightEditSlider(_ sender: UISlider) {
        sender.value.round()
        if sender.value <= 10 {
            trainWeightTF.text = "\(Int(sender.value))"
            trainWeight = Int(sender.value)
        }else {
            trainWeightTF.text = "\(Int(sender.value) / 10 * 10)"
            trainWeight = Int(sender.value) / 10 * 10
        }
        UserDefaults.standard.setValue(trainWeight, forKey: "trainWeight")
        UserDefaults.standard.synchronize()
    }

    @IBAction func trainWeightEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainWeight = Int(sender.text!)!
            trainWeightSlider.setValue(Float(trainWeight), animated: true)
            UserDefaults.standard.setValue(trainWeight, forKey: "trainWeight")
            UserDefaults.standard.synchronize()
        }
    }
    var trainWeightMin: Float = 0
    var trainWeightMax: Float = 200
    
    @IBAction func trainWeightMinEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainWeightMin = Float(sender.text!)!
            trainWeightSlider.minimumValue = trainWeightMin
            trainWeightMinTF.text = sender.text!
        }
    }
    
    @IBAction func trainWeightMaxEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainWeightMax = Float(sender.text!)!
            trainWeightSlider.maximumValue = trainWeightMax
            trainWeightMaxTF.text = sender.text!
        }
    }
    
    @IBAction func trainTimesEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainTimes = Int(sender.text!)!
            trainTimesSlider.setValue(Float(trainTimes), animated: true)
        }
        UserDefaults.standard.setValue(trainTimes, forKey: "trainTimes")
        UserDefaults.standard.synchronize()
    }
    @IBAction func trainTimesEditSlider(_ sender: UISlider) {
        
        sender.value.round()
        trainTimes = Int(sender.value)
        trainTimesTF.text = "\(Int(sender.value))"
        UserDefaults.standard.setValue(trainTimes, forKey: "trainTimes")
        UserDefaults.standard.synchronize()
    }
    var trainTimesMin: Float = 6
    var trainTimesMax: Float = 20
    @IBAction func trainTimesMinEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainTimesMin = Float(sender.text!)!
            trainTimesSlider.minimumValue = trainTimesMin
            trainTimesMinTF.text = sender.text!
        }
    }
    @IBAction func trainTimesMaxEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainTimesMax = Float(sender.text!)!
            trainTimesSlider.maximumValue = trainTimesMax
            trainTimesMaxTF.text = sender.text!
        }
    }
    
    @IBAction func trainSetEachIntervalEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainSetEachInterval = Float(sender.text!)!
            trainSetEachIntervalSlider.setValue(Float(trainSetEachInterval), animated: true)
            UserDefaults.standard.setValue(trainSetEachInterval, forKey: "trainSetEachInterval")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    @IBAction func trainSetEachIntervalSlider(_ sender: UISlider) {
        trainSetEachInterval = sender.value
        trainSetEachIntervalTF.text = "\(Float(Int(sender.value * 10))/10 )"
        UserDefaults.standard.setValue(trainSetEachInterval, forKey: "trainSetEachInterval")
        UserDefaults.standard.synchronize()
    }
    var trainSetEachIntervalMin: Float = 1
    var trainSetEachIntervalMax: Float = 5
    
    @IBAction func trainSetEachIntervalMinEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainSetEachIntervalMin = Float(sender.text!)!
            trainSetEachIntervalSlider.minimumValue = trainSetEachIntervalMin
            trainSetEachIntervalMinTF.text = sender.text!
        }
    }
    
    @IBAction func trainSetEachIntervalMaxEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainSetEachIntervalMax = Float(sender.text!)!
            trainSetEachIntervalSlider.maximumValue = trainSetEachIntervalMax
            trainSetEachIntervalMaxTF.text = sender.text!
        }
    }
    
    
    @IBAction func trainEachSetIntervalEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainEachSetInterval = Int(sender.text!)!
            trainEachSetIntervalSlider.setValue(Float(trainEachSetInterval), animated: true)
            UserDefaults.standard.setValue(trainEachSetInterval, forKey: "trainEachSetInterval")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    @IBAction func trainEachSetIntervalEditSlider(_ sender: UISlider) {
       
        trainEachSetInterval = Int(sender.value)
        trainEachSetIntervalTF.text = "\(Int(sender.value))"
        UserDefaults.standard.setValue(trainEachSetInterval, forKey: "trainEachSetInterval")
        UserDefaults.standard.synchronize()
        
    }
    
    var trainEachSetIntervalMax = 120
    var trainEachSetIntervalMin = 30
    
    
    @IBAction func trainEachSetIntervalMinEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainEachSetIntervalMin = Int(sender.text!)!
            trainEachSetIntervalSlider.minimumValue = Float(trainEachSetIntervalMin)
            trainEachSetIntervalMinTF.text = sender.text!
        }
    }
    
    
    
    @IBAction func trainEachSetIntervalMaxEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainEachSetIntervalMax = Int(sender.text!)!
            trainEachSetIntervalSlider.maximumValue = Float(trainEachSetIntervalMax)
            trainEachSetIntervalMaxTF.text = sender.text!
        }
    }
    
    
    
    
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//       TrainingItemD.resignFirstResponder()
//        TrainingItemDefD.resignFirstResponder()
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


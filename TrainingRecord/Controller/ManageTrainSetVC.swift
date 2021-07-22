//
//  NewTrainingItemViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/5/19.
//

import UIKit

class ManageTrainSetVC: UIViewController,UITextInputTraits, UITextFieldDelegate {
    var trainWeight : Int = 10
    var trainSet : Int = 3
    var trainTimes : Int = 10
    var trainEachSetInterval : Int = 30
    var trainSetEachInterval : Float = 1
    var trainUnit: String = "kg"
    var trainLS = 0
    

    
    var formWeight : [String] = ["10","20","30","40","50","60","70","80","90","100","110","120","130","140","150","160","170","180","190","200"]
    var formUnit : [String] = ["kg","lb"]
    var formSet : [String] = ["3","4","5"]
    var formSetCount : [String] = ["10","11","12","13","14","15","16","17","18"]
    var formSetEachInterval : [String] = ["0.9","1","1.1","1.2","1.3","1.4","1.5","1.6","1.7","1.8","1.9","2","2.1","2.2","2.3","2.4","2.5","2.6","2.7","2.8","2.9","3"]
    var formEachSetInterval : [String] = ["30","40","50","60","70","80","90","100","110","120"]
//    @IBOutlet weak var trainWeightPV: UIPickerView!
//
//    @IBOutlet weak var trainUnitPV: UIPickerView!
//
//    @IBOutlet weak var trainSetPV: UIPickerView!
//
//    @IBOutlet weak var trainSetCountPV: UIPickerView!
//
//    @IBOutlet weak var trainSetEachIntervalPV: UIPickerView!
//
//    @IBOutlet weak var trainEachSetIntervalPV: UIPickerView!
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//            return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView == trainWeightPV {
//            return formWeight.count
//        } else if pickerView == trainUnitPV {
//            return formUnit.count
//        } else if pickerView == trainSetPV {
//            return formSet.count
//        } else if pickerView == trainSetCountPV {
//            return formSetCount.count
//        } else if pickerView == trainSetEachIntervalPV{
//            return formSetEachInterval.count
//        } else if pickerView == trainEachSetIntervalPV{
//            return formEachSetInterval.count
//        }
//            return 0
//
//        }
//
//        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component:Int)-> String?{
//            if pickerView == trainWeightPV {
//                return formWeight[row]
//            } else if pickerView == trainUnitPV {
//                return formUnit[row]
//            } else if pickerView == trainSetPV {
//                return formSet[row]
//            } else if pickerView == trainSetCountPV {
//                return formSetCount[row]
//            } else if pickerView == trainSetEachIntervalPV{
//                return formSetEachInterval[row]
//            } else if pickerView == trainEachSetIntervalPV{
//                return formEachSetInterval[row]
//            }
//            return nil
//        }
//
//
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//        print(row)
//        print(component)
//
//        if component == 0{
//            switch pickerView {
//            case trainWeightPV:
//                print(formWeight[row])
//                self.trainWeight = Int(formWeight[row])!
//                print(self.trainWeight)
//
//            case trainUnitPV:
//                self.trainUnit = formUnit[row]
//                print(self.trainUnit)
//            case trainSetPV:
//                self.trainSet = Int(formSet[row])!
//                print(self.trainSet)
//
//            case trainSetCountPV:
//                self.trainSetCount = Int(formSetCount[row])!
//                print(self.trainSetCount)
//            case trainSetEachIntervalPV:
//                self.trainSetEachInterval = Double(formSetEachInterval[row])!
//                print(self.trainSetEachInterval)
//            case trainEachSetIntervalPV:
//                self.trainEachSetInterval = Int(formEachSetInterval[row])!
//                print(self.trainEachSetInterval)
//            default:
//                self.trainWeight = Int(formWeight[row])!
//                print(self.trainWeight)
//
//            }
//        }
//
//    }
    
    
    
    @IBOutlet weak var trainWeightTF: UITextField!

    @IBOutlet weak var trainWeightSlider: UISlider!
    @IBOutlet weak var trainWeightMaxTF: UITextField!
    @IBOutlet weak var trainWeightMinTF: UITextField!
    @IBOutlet weak var unit: UILabel!
    
  
    @IBOutlet weak var trainTimesTF: UITextField!
    
    @IBOutlet weak var trainTimesSlider: UISlider!
    @IBOutlet weak var trainTimesMinTF: UITextField!
    
    @IBOutlet weak var trainTimesMaxTF: UITextField!
    
    
    @IBOutlet weak var trainSetEachIntervalTF: UITextField!
    
    @IBOutlet weak var trainSetEachIntervalMinTF: UITextField!
    
    @IBOutlet weak var trainSetEachIntervalSlider: UISlider!
    @IBOutlet weak var trainSetEachIntervalMaxTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 註冊tab事件，點選瑩幕任一處可關閉瑩幕小鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
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
        
    }

    @IBAction func trainWeightEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainWeight = Int(sender.text!)!
            trainWeightSlider.setValue(Float(trainWeight), animated: true)
        }
    }
    var trainWeightMin: Float = 0
    var trainWeightMax: Float = 200
    
    @IBAction func trainWeightMinEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainWeightMin = Float(sender.text!)!
            trainWeightSlider.minimumValue = trainWeightMin
        }
    }
    
    @IBAction func trainWeightMaxEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainWeightMax = Float(sender.text!)!
            trainWeightSlider.maximumValue = trainWeightMax
        }
    }
    
    @IBAction func trainTimesEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainTimes = Int(sender.text!)!
            trainTimesSlider.setValue(Float(trainTimes), animated: true)
        }
        
    }
    @IBAction func trainTimesEditSlider(_ sender: UISlider) {
        
        sender.value.round()
        trainTimes = Int(sender.value)
        trainTimesTF.text = "\(Int(sender.value))"
    }
    var trainTimesMin: Float = 6
    var trainTimesMax: Float = 20
    @IBAction func trainTimesMinEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainTimesMin = Float(sender.text!)!
            trainWeightSlider.minimumValue = trainTimesMin
        }
    }
    @IBAction func trainTimesMaxEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainTimesMax = Float(sender.text!)!
            trainWeightSlider.maximumValue = trainTimesMax
        }
    }
    
    @IBAction func trainSetEachIntervalEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainSetEachInterval = Float(sender.text!)!
            trainSetEachIntervalSlider.setValue(Float(trainSetEachInterval), animated: true)
        }
    }
    
    
    @IBAction func trainSetEachIntervalSlider(_ sender: UISlider) {
        trainSetEachInterval = sender.value
        trainSetEachIntervalTF.text = "\(Float(Int(sender.value * 10))/10 )"
    }
    var trainSetEachIntervalMin: Float = 1
    var trainSetEachIntervalMax: Float = 5
    
    @IBAction func trainSetEachIntervalMinEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainSetEachIntervalMin = Float(sender.text!)!
            trainWeightSlider.minimumValue = trainSetEachIntervalMin
        }
    }
    
    @IBAction func trainSetEachIntervalMaxEditTF(_ sender: UITextField) {
        if sender.text != nil {
            trainSetEachIntervalMax = Float(sender.text!)!
            trainWeightSlider.maximumValue = trainSetEachIntervalMax
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


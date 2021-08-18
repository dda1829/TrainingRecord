//
//  NewTrainingItemViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/5/19.
//

import UIKit

class NewTrainingItemViewController: UIViewController,UITextInputTraits, UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewAccessibilityDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //MARK: parameters for demonstration
    var trainingItem : String = ""
    var trainingItemDef : String = ""
    var trainLS = 0
    var formListLocation : [String] = ["運動部位", "肩胸部", "背部" ,"臀腿部", "腹部", "手臂","有氧運動"]
    let manager = FileManager.default
    var imageURL : URL?
    var imageString : String?

    let imagePickerVC = UIImagePickerController()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return formListLocation.count
            }
            
            return 0
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component:Int)-> String?{
            if component == 0{
                return formListLocation[row]
            }            
            return nil
        }
    
    
    @IBOutlet weak var addTrainingItemPV: UIPickerView!
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0 {
            switch row {
            case 1:
                trainLS = 1
                                       
            case 2:
                trainLS = 2
               
            case 3:
                trainLS = 3
            case 4:
                trainLS = 4
            case 5:
                trainLS = 5
            case 6:
                trainLS = 6
            default:
                trainLS = 0
                
            }
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTrainingItemPV.delegate = self
        addTrainingItemPV.setValue(UIColor.white, forKey: "textColor")
        TrainingItemD.delegate = self
        TrainingItemDefD.delegate = self
        
        
    }
    

    @IBOutlet weak var TrainingItemD: UITextField!
    @IBOutlet weak var TrainingItemDefD: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imagenumber : Bool = true
    @IBAction func imageAdder(_ sender: UIButton) {
        
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        
        imagePickerVC.modalPresentationStyle = .popover
        let popover = imagePickerVC.popoverPresentationController
        popover?.sourceView = sender
        
        
        popover?.sourceRect = sender.bounds
        popover?.permittedArrowDirections = .any
        show(imagePickerVC,sender :self)
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        try? manager.removeItem(atPath: imageURL!.absoluteString)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imagedata = image.jpegData(compressionQuality: 1) {
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        let docUrl = homeUrl.appendingPathComponent("Documents")
        let doc2Url = docUrl.appendingPathComponent(fitRecordLocation(trainLS))
        let fileName = UUID().uuidString
        let fileUrl = doc2Url.appendingPathComponent(fileName)
        imageString = "Documents/\(fitRecordLocation(trainLS))/\(fileName)"
        imageURL = fileUrl
            do{
           try imagedata.write(to: imageURL!, options: [.atomic])
            }catch{
                print("\(error)")
            }
            
        ///取得使用者選擇的圖片
        imageView.image = image
        
      }
        ///關閉ImagePickerController
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      ///關閉ImagePickerController
      picker.dismiss(animated: true, completion: nil)
    }
    func fitRecordLocation(_ locationdata: Int) -> String{
        let trainLocationLoading : [String] = ["BrestShoulder","Back","BottomLap","Abdomen","Arm","Exercise"]
        switch locationdata {
        case 1:
            return trainLocationLoading[1]
        case 2:
            return trainLocationLoading[2]
        case 3:
            return trainLocationLoading[3]
        case 4:
            return trainLocationLoading[4]
        case 5:
            return trainLocationLoading[5]
        case 6:
            return trainLocationLoading[6]
        default:
            return ""
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            //利用此方式讓按下Return後會Toogle 鍵盤讓它消失
            textField.resignFirstResponder()
            print("按下Return")
            return false
        }
    
    @IBAction func TrainingItemDidEnd(_ sender: UITextField) {
        if sender.text != nil {
        trainingItem = sender.text!
        print(trainingItem)
        }
    }

    
    @IBAction func TrainingItemDefDidEnd(_ sender: UITextField) {
        if sender.text != nil {
        trainingItemDef = sender.text!
        print(trainingItemDef)
        }
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
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


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
    var image: UIImage?
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
        trainingItemTF.delegate = self
        trainingItemDefTF.delegate = self
        
        
    }
    

    @IBOutlet weak var trainingItemTF: UITextField!
    @IBOutlet weak var trainingItemDefTF: UITextField!
    
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
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        guard trainingItemTF.text != "" && trainingItemDefTF.text != "" && imageView.image != nil && trainLS != 0 else {
            let alertController = UIAlertController(title: "請完成填入未完成的資料，並且加入圖片，謝謝！", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if let imagedata = imageView.image?.jpegData(compressionQuality: 1){
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
        }
        let moc = CoreDataHelper.shared.managedObjectContext()
        let newItem: TrainingItem = TrainingItem(context: moc)
        newItem.id = UUID().uuidString
        newItem.name = trainingItemTF.text
        newItem.def = trainingItemDefTF.text
        newItem.imageName = imageString
        switch trainLS {
        case 1:
            newItem.type = "BrestShoulder"
            ManageTrainingItem.share.editTraingItem(Location: "BrestShoulder", EditedRow: nil, EditedtoRow: nil, Content: newItem, Type: "new")
        case 2:
            newItem.type = "Back"
            ManageTrainingItem.share.editTraingItem(Location: "Back", EditedRow: nil, EditedtoRow: nil, Content: newItem, Type: "new")
        case 3:
            newItem.type = "Abdomen"
            ManageTrainingItem.share.editTraingItem(Location: "Abdomen", EditedRow: nil, EditedtoRow: nil, Content: newItem, Type: "new")
        case 4:
            newItem.type = "BottomLap"
            ManageTrainingItem.share.editTraingItem(Location: "BottomLap", EditedRow: nil, EditedtoRow: nil, Content: newItem, Type: "new")
        case 5:
            newItem.type = "Arm"
            ManageTrainingItem.share.editTraingItem(Location: "Arm", EditedRow: nil, EditedtoRow: nil, Content: newItem, Type: "new")
        case 6:
            newItem.type = "Exercise"
            ManageTrainingItem.share.editTraingItem(Location: "Exercise", EditedRow: nil, EditedtoRow: nil, Content: newItem, Type: "new")
        default:
            
            print("error")
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as? TrainRecordHomeVC
        self.navigationController?.pushViewController(vc!,animated: true)
        
    }
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        try? manager.removeItem(atPath: imageURL!.absoluteString)
        UserDefaults.standard.removeObject(forKey: "newTrainingItemURLString")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
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
        if textField == trainingItemTF {
            if imageView.image == nil{
            image = self.textToImage(drawText: textField.text!, inImage: UIImage.init(named: "backsquare")!)
            imageView.image = image
            }
            trainingItemDefTF.becomeFirstResponder()
        }else{
        
        
            //利用此方式讓按下Return後會Toogle 鍵盤讓它消失
            textField.resignFirstResponder()
            print("按下Return")
        }
            return false
        }
    
    @IBAction func TrainingItemDidEnd(_ sender: UITextField) {
        if sender.text != nil && sender == trainingItemTF {
        trainingItem = sender.text!
        print(trainingItem)
      
        }
    }

    
    @IBAction func TrainingItemDefDidEnd(_ sender: UITextField) {
        if imageView.image == nil{
        image = self.textToImage(drawText: trainingItemTF.text!, inImage: UIImage.init(named: "backsquare")!)
        imageView.image = image
        }
        if sender.text != nil && sender == trainingItemDefTF {
        trainingItemDef = sender.text!
        print(trainingItemDef)
        }
    }
    
    
    func textToImage(drawText text: String, inImage image: UIImage) -> UIImage
    {

        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        var target = ""
        var count = 0
        if text.count < 4 {
            target = text
        }else if text.count >= 4 && text.count < 6 {
            do{
                try text.forEach({ word in
                    count += 1
                    target += String(word)
                    if count == 2{
                        target += "\n"
                    }
                })
            }catch{
                print(error)
            }
            
        }else if text.count >= 6 && text.count < 8{
            do{
                try text.forEach({ word in
                    count += 1
                    target += String(word)
                    if count == 3{
                        target += "\n"
                    }
                })
            }catch{
                print(error)
            }
        }else if text.count >= 8 && text.count < 10{
            do{
                try text.forEach({ word in
                    count += 1
                    target += String(word)
                    if count == 4{
                        target += "\n"
                    }
                })
            }catch{
                print(error)
            }
        }else if text.count >= 10 && text.count < 12{
            do{
                try text.forEach({ word in
                    count += 1
                    target += String(word)
                    if count == 5{
                        target += "\n"
                    }
                })
            }catch{
                print(error)
            }
        }
        
        let font=UIFont(name: "Helvetica-Bold", size: 30)!

        let paraStyle=NSMutableParagraphStyle()
        paraStyle.alignment=NSTextAlignment.center
        
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.red, NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paraStyle]

        let height = image.size.height//font.lineHeight

        let y = (height) / 4

        let strRect = CGRect(x: 0, y: y, width: image.size.width, height: height)

        target.draw(in: strRect.integral, withAttributes: attributes)

        let result=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result!
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


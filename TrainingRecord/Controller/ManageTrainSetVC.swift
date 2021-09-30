//
//  NewTrainingItemViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/5/19.
//

import UIKit
import Firebase
import GoogleMobileAds
import AdSupport
import AppTrackingTransparency
class ManageTrainSetVC: UIViewController,UITextInputTraits, UITextFieldDelegate,GADBannerViewDelegate {
    var trainWeight : Float = 10
    var trainTimes : Int = 10
    var trainEachSetInterval : Int = 30
    var trainSetEachInterval : Float = 3
    var trainUnit: String = "kg"
    var trainLS: [Int] = []
    
    var bannerView: GADBannerView!
    @IBOutlet weak var trainWeightTF: UITextField!

    @IBOutlet weak var doneBtn: UIButton!
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
    
    @IBOutlet weak var trainEachSetIntervalLabel: UILabel!
    @IBOutlet weak var trainEachSetIntervalUnitLabel: UILabel!
    var originalFrame : CGRect?
    //畫面顯示時註冊通知
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //註冊UIKeyboardWillShow通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //註冊UIKeyboardWillHide通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //畫面消失時取消註冊通知
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
   
    
    @objc func keyboardWillAppear(notification : Notification)  {
        let info = notification.userInfo!
        let currentKeyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        //取得textField的frame（windows座標)
        let textFrame = self.view.window!.convert(self.trainEachSetIntervalMinTF.frame, from: self.view)
       
        var visibleRect = self.view.frame
        if self.originalFrame == nil {
            self.originalFrame = visibleRect
        }
        //如果textField frame（windows座標)的最低點 > keyboard frame minY,將view往上移
        if self.trainEachSetIntervalTF.isEditing || self.trainEachSetIntervalMaxTF.isEditing || self.trainEachSetIntervalMinTF.isEditing /*&& (  textFrame.maxY > currentKeyboardFrame.minY )*/ {
            //計算差額
            let difference = textFrame.maxY - currentKeyboardFrame.minY + 20
            visibleRect.origin.y = visibleRect.origin.y - difference
            //將controller view的 y 往上移
            UIView.animate(withDuration: duration) {
                self.view.frame = visibleRect
            }
        }
    }
    @objc func keyboardWillHide(notification : Notification)  {
        let info = notification.userInfo!
        //回復原本的位置,注意這裏的duration 要設的跟66行一樣，可以自行調整
        UIView.animate(withDuration: 0.5) {
            self.view.frame = self.originalFrame!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 註冊tab事件，點選瑩幕任一處可關閉瑩幕小鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        trainUnit = UserDefaults.standard.string(forKey: "trainUnit") ?? "Kg"
        unit.text = trainUnit
        if UserDefaults.standard.float(forKey: "trainWeight") != 0.0{
            trainWeight = UserDefaults.standard.float(forKey: "trainWeight")
            trainWeightSlider.setValue(trainWeight, animated: false)
            trainWeightTF.text = "\(trainWeight)"
        }
        if UserDefaults.standard.float(forKey: "trainTimes") != 0.0{
            trainTimes = UserDefaults.standard.integer(forKey: "trainTimes")
            trainTimesSlider.setValue(Float(trainTimes), animated: false)
            trainTimesTF.text = "\(trainTimes)"
        }
        if UserDefaults.standard.float(forKey: "trainSetEachInterval") != 0.0 {
            trainSetEachInterval = UserDefaults.standard.float(forKey: "trainSetEachInterval")
            trainSetEachIntervalSlider.setValue(trainSetEachInterval, animated: false)
            trainSetEachIntervalTF.text = "\(trainSetEachInterval)"
        }
        if UserDefaults.standard.integer(forKey: "trainEachSetInterval") != 0 {
            trainEachSetInterval = UserDefaults.standard.integer(forKey: "trainEachSetInterval")
            trainEachSetIntervalSlider.setValue(Float(trainEachSetInterval), animated: false)
            trainEachSetIntervalTF.text = "\(trainEachSetInterval)"
        }
        
        if Auth.auth().currentUser == nil{
            trainEachSetIntervalTF.isHidden = true
            trainEachSetIntervalMaxTF.isHidden = true
            trainEachSetIntervalSlider.isHidden = true
            trainEachSetIntervalMinTF.isHidden = true
            trainEachSetIntervalLabel.isHidden = true
            trainEachSetIntervalUnitLabel.isHidden = true
            doneBtn.translatesAutoresizingMaskIntoConstraints = false
            doneBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0 ).isActive = true
            doneBtn.topAnchor.constraint(equalTo: trainSetEachIntervalSlider.bottomAnchor, constant: 10).isActive = true
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    DispatchQueue.main.async {
                        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                        self.bannerView.translatesAutoresizingMaskIntoConstraints = false
                        self.bannerView.adUnitID = "ca-app-pub-8982946958697547/7467804861"//廣告編號
                        let frame = { () -> CGRect in
                                  // Here safe area is taken into account, hence the view frame is used
                                  // after the view has been laid out.
                                  if #available(iOS 11.0, *) {
                                    return self.view.frame.inset(by: self.view.safeAreaInsets)
                                  } else {
                                    return self.view.frame
                                  }
                                }()
                                let viewWidth = frame.size.width

                        self.bannerView.adSize = GADCurrentOrientationInlineAdaptiveBannerAdSizeWithWidth(viewWidth)
                        self.bannerView.rootViewController = self
                        self.bannerView.delegate = self
                        self.bannerView.load(GADRequest())
                    }
                    
                }
            } else {
                // Fallback on earlier versions
                self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                self.bannerView.translatesAutoresizingMaskIntoConstraints = false
                self.bannerView.adUnitID = "ca-app-pub-8982946958697547/7467804861"//廣告編號
                let frame = { () -> CGRect in
                          // Here safe area is taken into account, hence the view frame is used
                          // after the view has been laid out.
                          if #available(iOS 11.0, *) {
                            return view.frame.inset(by: view.safeAreaInsets)
                          } else {
                            return view.frame
                          }
                        }()
                        let viewWidth = frame.size.width

                bannerView.adSize = GADCurrentOrientationInlineAdaptiveBannerAdSizeWithWidth(viewWidth)
                self.bannerView.rootViewController = self
                self.bannerView.delegate = self
                self.bannerView.load(GADRequest())
            }
        }
    }
   
    // 關閉瑩幕小鍵盤
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    
    @IBAction func trainWeightEditSlider(_ sender: UISlider) {
        sender.value.round()
        if sender.value <= 10 {
            trainWeightTF.text = "\(Float(Int(sender.value * 10))/10)"
            trainWeight = Float(Int(sender.value * 10))/10
        }else {
            trainWeightTF.text = "\(Float(Int(sender.value * 10))/10)"
            trainWeight = Float(Int(sender.value * 10))/10
        }
    }

    @IBAction func trainWeightEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainWeight = Float(sender.text!)!
            trainWeightSlider.setValue(Float(trainWeight), animated: true)
        }else{
            trainWeightTF.text = "\(trainWeight)"
        }
    }
    var trainWeightMin: Float = 0
    var trainWeightMax: Float = 200
    
    @IBAction func trainWeightMinEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainWeightMin = Float(sender.text!)!
            trainWeightSlider.minimumValue = trainWeightMin
            trainWeightMinTF.text = sender.text!
        }else{
            trainWeightMinTF.text = "\(trainWeightMin)"
        }
    }
    
    @IBAction func trainWeightMaxEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainWeightMax = Float(sender.text!)!
            trainWeightSlider.maximumValue = trainWeightMax
            trainWeightMaxTF.text = sender.text!
        }else{
            trainWeightMaxTF.text = "\(trainWeightMax)"
        }
    }
    
    @IBAction func trainTimesEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainTimes = Int(sender.text!)!
            trainTimesSlider.setValue(Float(trainTimes), animated: true)
        }else{
            trainTimesTF.text = "\(trainTimes)"
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
        if sender.text != "" {
            trainTimesMin = Float(sender.text!)!
            trainTimesSlider.minimumValue = trainTimesMin
            trainTimesMinTF.text = sender.text!
        }else{
            trainTimesMinTF.text = "\(trainTimesMin)"
        }
    }
    @IBAction func trainTimesMaxEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainTimesMax = Float(sender.text!)!
            trainTimesSlider.maximumValue = trainTimesMax
            trainTimesMaxTF.text = sender.text!
        }else{
            trainTimesMaxTF.text = "\(trainTimesMax)"
        }
    }
    
    @IBAction func trainSetEachIntervalEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainSetEachInterval = Float(sender.text!)!
            trainSetEachIntervalSlider.setValue(Float(trainSetEachInterval), animated: true)
            
        }else{
            trainSetEachIntervalTF.text = "\(trainSetEachInterval)"
        }
    }
    
    
    @IBAction func trainSetEachIntervalSlider(_ sender: UISlider) {
        trainSetEachInterval = Float(Int(sender.value * 100))/100
        trainSetEachIntervalTF.text = "\(Float(Int(sender.value * 100))/100 )"
    }
    var trainSetEachIntervalMin: Float = 1
    var trainSetEachIntervalMax: Float = 5
    
    @IBAction func trainSetEachIntervalMinEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainSetEachIntervalMin = Float(sender.text!)!
            trainSetEachIntervalSlider.minimumValue = trainSetEachIntervalMin
            trainSetEachIntervalMinTF.text = sender.text!
        }else{
            trainSetEachIntervalMinTF.text = "\(trainSetEachIntervalMin)"
        }
    }
    
    @IBAction func trainSetEachIntervalMaxEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainSetEachIntervalMax = Float(sender.text!)!
            trainSetEachIntervalSlider.maximumValue = trainSetEachIntervalMax
            trainSetEachIntervalMaxTF.text = sender.text!
        }else{
            trainSetEachIntervalMaxTF.text = "\(trainSetEachIntervalMax)"
        }
    }
    
    
    @IBAction func trainEachSetIntervalEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainEachSetInterval = Int(sender.text!)!
            trainEachSetIntervalSlider.setValue(Float(trainEachSetInterval), animated: true)
        }else{
            trainEachSetIntervalTF.text = "\(trainEachSetInterval)"
        }
    }
    
    
    
    @IBAction func trainEachSetIntervalEditSlider(_ sender: UISlider) {
       
        trainEachSetInterval = Int(sender.value)
        trainEachSetIntervalTF.text = "\(Int(sender.value))"
        
    }
    
    var trainEachSetIntervalMax = 120
    var trainEachSetIntervalMin = 30
    
    
    @IBAction func trainEachSetIntervalMinEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainEachSetIntervalMin = Int(sender.text!)!
            trainEachSetIntervalSlider.minimumValue = Float(trainEachSetIntervalMin)
            trainEachSetIntervalMinTF.text = sender.text!
        }else{
            trainEachSetIntervalMinTF.text = "\(trainEachSetIntervalMin)"
        }
    }
    
    
    
    @IBAction func trainEachSetIntervalMaxEditTF(_ sender: UITextField) {
        if sender.text != "" {
            trainEachSetIntervalMax = Int(sender.text!)!
            trainEachSetIntervalSlider.maximumValue = Float(trainEachSetIntervalMax)
            trainEachSetIntervalMaxTF.text = sender.text!
        }else{
            trainEachSetIntervalMaxTF.text = "\(trainEachSetIntervalMax)"
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        
        // digit only
        if !string.isNumberOnly() {
            return false
        }
        return true
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        UserDefaults.standard.setValue(trainWeight, forKey: "trainWeight")
        UserDefaults.standard.setValue(trainTimes, forKey: "trainTimes")
        UserDefaults.standard.setValue(trainEachSetInterval, forKey: "trainEachSetInterval")
        UserDefaults.standard.setValue(trainSetEachInterval, forKey: "trainSetEachInterval")
        UserDefaults.standard.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as? TrainRecordHomeVC
        vc?.trainLS = trainLS
        vc?.trainWeight = trainWeight
        vc?.trainTimes = trainTimes
        vc?.trainEachSetInterval = trainEachSetInterval
        vc?.trainSetEachInterval = trainSetEachInterval
        self.navigationController?.pushViewController(vc!,animated: true)
    }
    
    // MARK:GADBannerViewDelegate
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {

            if bannerView.superview == nil && Auth.auth().currentUser == nil {
//                let a = UIStackView()
//                self.view.addSubview(a)
//                a.translatesAutoresizingMaskIntoConstraints = false
//                a.bottomAnchor.constraint(equalTo: self.view.topAnchor,constant: 20).isActive = true
//                a.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
                self.view.addSubview(bannerView)
                bannerView.translatesAutoresizingMaskIntoConstraints = false

                bannerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 0).isActive = true
                bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
                bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true

                    }

        }
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
}


//
//  MemberSignUpViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/3.
//

import UIKit
import Firebase


class MemberSignUpViewController: UIViewController, UITextFieldDelegate {

    
    
    var passwordstrength = 0
    
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
        let textFrame = self.view.window!.convert(self.passwordDebugLabel.frame, from: self.view)
        var visibleRect = self.view.frame
        if self.originalFrame == nil {
            self.originalFrame = visibleRect
        }
        //如果textField frame（windows座標)的最低點 > keyboard frame minY,將view往上移
        if (  textFrame.maxY > currentKeyboardFrame.minY ) {
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
//        let info = notification.userInfo!
        //回復原本的位置,注意這裏的duration 要設的跟66行一樣，可以自行調整
        UIView.animate(withDuration: 0.5) {
            self.view.frame = self.originalFrame!
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view
        
        


    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
            if emailTextField.text != "" && passwordTextField.text != "" {
                signUpBtnPressed(self)
            }
        }
        return true
    }
    
    @IBOutlet weak var passwordDebugLabel: UILabel!
    
 
    @IBOutlet weak var passwordStrenthL: UILabel!

    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == ""  {
                let alertController = UIAlertController(title: "Error", message: "Please enter your name,email and password", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            
            } else {
//
                
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in

                    if error == nil {
                        print("You have successfully signed up")
                        //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                        
                        Auth.auth().currentUser?.sendEmailVerification { error in
                        }
                        print(Auth.auth().currentUser!.isEmailVerified)
                        let alertController = UIAlertController(title: "請收取驗證信！", message: "請至您已填寫的信箱，收取驗證信，驗證過後即可正常登入，感謝。", preferredStyle: .alert)

                        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                            self.mbProgress(true)
                            TimerUse.share.setTimer(2, self, #selector(self.checkVeried), false, 1)
                        }
                        alertController.addAction(defaultAction)

                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)

                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)

                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
    }
    
    @objc func checkVeried(){
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        TimerUse.share.setTimer(1, self, #selector(cV), false, 1)
    }
    @objc func cV(){
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
            if let e = error {
                print( "error \(e)")
                return
            }
            
        }
        TimerUse.share.setTimer(1, self, #selector(checkVerified), false, 1)
    }
    @objc func checkVerified(){
        if let isemailverified = Auth.auth().currentUser?.isEmailVerified, isemailverified{
            GoLogInPage()
        }else{
        TimerUse.share.setTimer(1, self, #selector(checkVeried), false, 1)
        }
    }
    
    
    
    func mbProgress(_ onoff: Bool){
        if onoff{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }else{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func GoLogInPage() {
        TimerUse.share.stopTimer(1)
        
        UserDefaults.standard.setValue("email", forKey: "loginMethod")
        UserDefaults.standard.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoggedIn") as? MemberAlreadyLoginViewController
        self.navigationController?.pushViewController(vc!,animated: true)
    }
    
    
    @IBAction func memberLoginBtnPressed(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemberLoginPage") as? MemberLoginViewController
        self.navigationController?.pushViewController(vc!,animated: true)
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("textField.text: \(emailTextField.text!)")
        print("range: \(range.location)")
        print("string: \(string)")
        print("")
        
        if textField == passwordTextField{
            if range.location <= 4 {
                passwordDebugLabel.text = "密碼不得小於6字元"
                passwordStrenthL.text = ""
                passwordstrength = 0
            }else{
                passwordDebugLabel.text = "密碼強度："
                print("password \(passwordTextField.text)")
                // Upper case, Lower case, Number & Symbols
                let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{0,}$")
                
                let passwordmiddle1 = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9]).{0,}$")
                let passwordmiddle2 = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{0,}$")
                let passwordmiddle3 = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{0,}$")
                
                if  password.evaluate(with: passwordTextField.text) {
                    passwordStrenthL.text = "strong"
                    passwordStrenthL.textColor = .green
                }else{
                    if passwordmiddle1.evaluate(with: passwordTextField.text) || passwordmiddle2.evaluate(with: passwordTextField.text) || passwordmiddle3.evaluate(with: passwordTextField.text) {
                        passwordStrenthL.text = "middle"
                        passwordStrenthL.textColor = .yellow
                        
                    } else{
                        passwordStrenthL.text = "weak"
                        passwordStrenthL.textColor = .red
                    }
                }
                
                
                
               
                    
                
            }
            
            
        }
        
        // 不能輸入空白
        if string.isContainsSpaceCharacters() {
            return false
        }
        // 不能輸入中文字
        if string.isContainsChineseCharacters() {
            return false
        }
        
        
        
        
        return true
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


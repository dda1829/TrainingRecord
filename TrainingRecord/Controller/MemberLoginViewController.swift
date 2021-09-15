//
//  LoginViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/4.
//

import UIKit
import Firebase
class MemberLoginViewController: UIViewController, UITextFieldDelegate {
    var userName: String?
    
    @IBOutlet weak var memberEmailTextView: UITextField!
    @IBOutlet weak var memberPasswordTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        memberEmailTextView.delegate = self
        memberPasswordTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @IBAction func LogInBtnPressed(_ sender: Any) {
        if memberEmailTextView.text == "" || memberPasswordTextView.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            
            } else {
                Auth.auth().signIn(withEmail: memberEmailTextView.text!, password: memberPasswordTextView.text!) { [self] result, error in
                    if let e = error {
                        print( "error \(e)")
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                    var zz = false
                    let userc = Auth.auth().currentUser
                    if let user = userc {
//                        print(user.displayName)
                        if user.isEmailVerified {
                        DispatchQueue.global().sync {
                            
                            self.userName = user.displayName!
                            if self.userName != nil {
                                zz = true
                            }
                            DispatchQueue.main.async {
                                if zz {
                                    MemberUserDataToFirestore.share.loadUserdatas()
                                    mbProgress(true)
                                goAlreadylogin()
                                }
                            }
                        }
                        }else{
                            Auth.auth().currentUser?.sendEmailVerification { error in
                            }
                            mbProgress(true)
                            TimerUse.share.setTimer(1, self, #selector(checkVeried), false, 1)
                        }
                        
                    }
                    
                }
        }
    }
    
    
    @objc func checkVeried(){
        TimerUse.share.stopTimer(1)
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        TimerUse.share.setTimer(1, self, #selector(cV), false, 1)
    }
    @objc func cV(){
        TimerUse.share.stopTimer(1)
        Auth.auth().signIn(withEmail: memberEmailTextView.text!, password: memberPasswordTextView.text!) { result, error in
            if let e = error {
                print( "error \(e)")
                return
            }
            
        }
        TimerUse.share.setTimer(1, self, #selector(checkVerified), false, 1)
    }
    @objc func checkVerified(){
        TimerUse.share.stopTimer(1)
        if let isemailverified = Auth.auth().currentUser?.isEmailVerified, isemailverified{
            let userc = Auth.auth().currentUser
            var zz = false
            if let user = userc {
                DispatchQueue.global().sync {
                    
                    self.userName = user.displayName!
                    if self.userName != nil {
                        zz = true
                    }
                    DispatchQueue.main.sync {
                        if zz {
                            MemberUserDataToFirestore.share.loadUserdatas()
                        goAlreadylogin()
                        }
                    }
                }
                }
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
    @IBAction func forgetPasswordBtnPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "注意", message: "請將您印象中的email填至帳號欄內後再按下確認，確認後重設密碼的郵件便會送出。", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "確認", style: .default) { (action) -> Void in
            if let email = self.memberEmailTextView.text {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
              // ...
            }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    func goAlreadylogin(){
        mbProgress(false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoggedIn") as? MemberAlreadyLoginViewController
        if let username = self.userName {
        vc?.userName = username
        }
        self.navigationController?.pushViewController(vc!,animated: true)
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == memberEmailTextView{
            memberPasswordTextView.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
            if memberEmailTextView.text != "" && memberPasswordTextView.text != ""{
                      LogInBtnPressed(self)
                  }
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

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
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
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
                    let user = Auth.auth().currentUser
                    if let user = user {
                        print(user.displayName)
                        DispatchQueue.global().sync {
                            
                            self.userName = user.displayName!
                            if self.userName != nil {
                                zz = true
                            }
                            DispatchQueue.main.async {
                                if zz {
                                    MemberUserDataToFirestore.share.loadUserdatas()
                                goAlreadylogin()
                                }
                            }
                        }
                        
                    }
                    self.activity.startAnimating()
//                    TimerUse.share.setTimer(3, self, #selector(goAlreadylogin), false, 1)
                    
                }
        }
    }
    
 func goAlreadylogin(){
        activity.stopAnimating()
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

//
//  MemberAlreadyLoginViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/3.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
class MemberAlreadyLoginViewController: UIViewController, LoginButtonDelegate {
    var userName: String?
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var LogedinTV: UILabel!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var removeAccountBtn: UIButton!
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        //
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        do {
            try Auth.auth().signOut()
            MemberUserDataToFirestore.share.initialUserdata()
            UserDefaults.standard.removeObject(forKey: "isMemberDataEdited")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as? TrainRecordHomeVC
            self.navigationController?.pushViewController(vc!,animated: true)
        } catch {
            print(error)
        }
    }
    
    @objc func backToSysBtn (){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as? TrainRecordHomeVC
        self.navigationController?.pushViewController(vc!,animated: true)
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToSysBtn))
        print(Auth.auth().currentUser!.isEmailVerified)
        // Do any additional setup after loading the view.
        if let user = Auth.auth().currentUser{
            if let username = user.displayName {
                LogedinTV.text = "\(userName ?? username)您好\n您已經登入了！"
            }
        }
        switch UserDefaults.standard.string(forKey: "loginMethod") {
        case "FaceBook":
            logOutBtn.removeFromSuperview()
            let fblogoutbtn = FBLoginButton()
            fblogoutbtn.delegate = self
            stackView.insertArrangedSubview(fblogoutbtn, at: 3)
        default:
            print("emailLogin")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            if let username = user.displayName {
                LogedinTV.text = "\(username)您好\n您已經登入了！"
            }
        }
    }
    
    @IBAction func goMemberDataSetPage(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SystemMemberPage") as? SystemMemberViewController
        self.navigationController?.pushViewController(vc!,animated: true)
    }
    @IBAction func RemoveAccountBtnPressed(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "loginMethod") == "email"{
            do{
                try Auth.auth().signOut()
            }catch{
                print(error)
            }
            TimerUse.share.setTimer(1, self, #selector(removeAccount), false, 1)
            mbProgress(true)
        }else{
            if let user = Auth.auth().currentUser{
                let deleteUserDatas = user.email!
                do {
                    try Auth.auth().signOut()
                } catch {
                    print(error)
                }
                MemberUserDataToFirestore.share.removeUserdata(deleteUserDatas)
                MemberUserDataToFirestore.share.initialUserdata()
                UserDefaults.standard.removeObject(forKey: "userName")
                UserDefaults.standard.removeObject(forKey: "userGoal")
                UserDefaults.standard.removeObject(forKey: "isMemberDataEdited")
                UserDefaults.standard.synchronize()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as? TrainRecordHomeVC
                self.navigationController?.pushViewController(vc!,animated: true)
            }
        }
    }
    
    func mbProgress(_ onoff: Bool){
        if onoff{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }else{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc func removeAccount() {
        TimerUse.share.stopTimer(1)
        mbProgress(false)
        let alert = UIAlertController(title: "", message: "請重新輸入帳號密碼已刪除帳號。", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "請輸入您的帳號"
        }
        alert.addTextField { textfield in
            textfield.placeholder = "請輸入您的密碼"
        }
        let action = UIAlertAction(title: "確認", style: .default) { action in
            if let acount = alert.textFields?[0].text, let password = alert.textFields?[1].text{
                Auth.auth().signIn(withEmail: acount, password: password) { [self] result, error in
                    if let e = error {
                        print( "error \(e)")
                        return
                    }
                    TimerUse.share.setTimer(2, self, #selector(removeAcount2), false, 1)
                    mbProgress(true)
                }
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func removeAcount2(){
        TimerUse.share.stopTimer(1)
        mbProgress(false)
        if let user = Auth.auth().currentUser{
            let deleteUserDatas = user.email!
            print("there's current user")
            user.delete { error in
                if let error = error {
                    // An error happened.
                    print("Account can't delete because \(error)")
                } else {
                    // Account deleted.
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print(error)
                    }
                    MemberUserDataToFirestore.share.removeUserdata(deleteUserDatas)
                    MemberUserDataToFirestore.share.initialUserdata()
                    UserDefaults.standard.removeObject(forKey: "userName")
                    UserDefaults.standard.removeObject(forKey: "userGoal")
                    UserDefaults.standard.removeObject(forKey: "isMemberDataEdited")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as? TrainRecordHomeVC
                    self.navigationController?.pushViewController(vc!,animated: true)
                }
            }
        }else {
            print("there's no current user")
        }
    }
    
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            MemberUserDataToFirestore.share.initialUserdata()
            UserDefaults.standard.removeObject(forKey: "isMemberDataEdited")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as? TrainRecordHomeVC
            self.navigationController?.pushViewController(vc!,animated: true)
        } catch {
            print(error)
        }
    }
    
}

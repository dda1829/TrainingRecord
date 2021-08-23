//
//  MemberAlreadyLoginViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/3.
//

import UIKit
import Firebase
class MemberAlreadyLoginViewController: UIViewController {
    var userName: String?
    @IBOutlet weak var LogedinTV: UILabel!
    @objc func backToSysBtn (){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SystemPage") as? SystemTableViewController
        self.navigationController?.pushViewController(vc!,animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToSysBtn))
        
        // Do any additional setup after loading the view.
        if let user = Auth.auth().currentUser{
            if let username = user.displayName {
            LogedinTV.text = "\(userName ?? username)您好\n您已經登入了！"
        }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            print(user.displayName)
            if let username = user.displayName {
                LogedinTV.text = "\(username)您好\n您已經登入了！"
            }
        }
    }
    var db : Firestore?
    @IBAction func RemoveAccountBtn(_ sender: UIButton) {
        if let user = Auth.auth().currentUser{
            db = Firestore.firestore()
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SystemPage") as? SystemTableViewController
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SystemPage") as? SystemTableViewController
            self.navigationController?.pushViewController(vc!,animated: true)
        } catch {
            print(error)
        }
        
    }

}

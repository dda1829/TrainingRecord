//
//  FirebaseUserData.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/5.
//
import Firebase
import Foundation

class MemberUserDataToFirestore {
    static var share = MemberUserDataToFirestore()
    private let memberDatasDefault: [String:Any] =  ["userGoal":[],"userTrainingLog":"","userBMI":[], "userBodyFat":[], "userAge":"", "userGender":"","userRecordTime":[],"userHeight":[],"userWeight":[],"userBMR":[]          ]
    private var memberDatas: [String:Any] =  [:]
    private let db = Firestore.firestore()
    private var accountDatas: [String:String] = [:]
    init() {
        memberDatas = memberDatasDefault
        loadUserdatas()
           }
   
    func checkAge() -> Bool{
        
        if (memberDatas["userAge"] as! String) != ""  {
            let nowTime = Date().timeIntervalSinceNow
            let recordTime = (memberDatas["userRecordTime"] as! [String]).first
            let timeDifference = nowTime - Double(recordTime!)!
            
            var gapYearOld = timeDifference/(60*60*24*365)
            var yearDifference = 0
            while gapYearOld >= 1{
                gapYearOld -= 1
                yearDifference += 1
            }
            if yearDifference > 0 {
                let nowAge = String(Int((memberDatas["userAge"] as! String))! + yearDifference)
                updateUserdata(nowAge, "userAge")
            }
            return true
        }
        return false
    }
    private func monthCaculate(_ month: String) -> Int {
        switch month {
        case "Mon":
            return 1
        case "Feb":
            return 2
        case "Mar":
            return 3
        case "Apr":
            return 4
        case "May":
            return 5
        case "Jun":
            return 6
        case "Jul":
            return 7
        case "Aug":
            return 8
        case "Sep":
            return 9
        case "Oct":
            return 10
        case "Nov":
            return 11
        default:
            return 12
        }
    }
    func createUserDocument() {
        
        if let currentuser = Auth.auth().currentUser  {
            db.collection("users").document("\(currentuser.email!)").setData(memberDatas)
        }
    }
    func updateUserdata(_ parameters:String,_ content: Any){
        memberDatas.updateValue(content, forKey: parameters)
    }
    func updateUserdatas(){
        if let currentuser = Auth.auth().currentUser  {
            db.collection("users").document("\(currentuser.email!)").setData(memberDatas)
        }
    }
    func getUserdatas(_ parameters:String) -> Any?{
        if let result = memberDatas[parameters]{
            return result
        }else if let result = accountDatas[parameters]{
            return result
        }
        return nil
    }
    func loadUserdatas(){
        if let currentuser = Auth.auth().currentUser{
            
                accountDatas.updateValue(currentuser.email!, forKey: "userEmail")
                accountDatas.updateValue(currentuser.displayName ?? "", forKey: "userName")
            
            let docRef = db.collection("users").document("\(currentuser.email!)")
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.memberDatas = document.data()!
                    print(self.memberDatas)
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    func initialUserdata(){
        memberDatas =  memberDatasDefault
    }
    func removeUserdata(_ deleteUserDatas: String){
        db.collection("users").document(deleteUserDatas).delete() { error in
                if let e = error {
                    print( "error remove the document: \(e)")
                    return
                }else{
                    print("Document has already removed")
                }
            }
        
    }
}

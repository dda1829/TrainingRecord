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
    private let memberDatasDefault: [String:Any] =  ["userGoal":[],"userTrainingLog":"","userBMI":[], "userBodyFat":[], "userAge":"", "userGender":"","userRecordDate":[],"userHeight":[],"userWeight":[],"userBMR":[]          ]
    private var memberDatas: [String:Any] =  [:]
    private let db = Firestore.firestore()
    private var accountDatas: [String:String] = [:]
    init() {
        memberDatas = memberDatasDefault
        loadUserdatas()
           }
   
    func checkAge() -> Bool{
        
        if (memberDatas["userAge"] as! String) != ""  {
            let nowDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let nowdate = dateFormatter.string(from: nowDate).split(separator: " ")
            let recordate = (memberDatas["userRecordDate"]as! [String]).first!.split(separator: " ")
            let yearDifference = Int(nowdate[2])! - Int(recordate[2])!
            var dayDifference : Int?
            var monthDifference : Int?
            if yearDifference >= 1 {
                 monthDifference = monthCaculate(String(nowdate[0])) - monthCaculate(String(recordate[0]))
                if monthDifference! >= 0 {
                    var datenow = nowdate[1].map(String.init)
                    var daterecord = recordate[1].map(String.init)
                    datenow.removeLast()
                    daterecord.removeLast()
                    var nowaday = ""
                    var recordaday = ""
                    for x in datenow{
                        nowaday += x
                    }
                    for x in daterecord{
                        recordaday += x
                    }
                    dayDifference = Int(nowaday)!-Int(recordaday)!
//                    print(dayDifference)
                }
            }
            var nowAge = Int(memberDatas["userAge"] as! String)
            if let month = monthDifference {
                if month < 0 {
                    nowAge = Int(memberDatas["userAge"] as! String)! + yearDifference - 1
                } else if month == 0{
                    if let day = dayDifference, day >= 0 {
                        nowAge = Int(memberDatas["userAge"] as! String)! + yearDifference - 1
                    }else {
                        nowAge = Int(memberDatas["userAge"] as! String)! + yearDifference
                    }
                }else{
                    nowAge = Int(memberDatas["userAge"] as! String)! + yearDifference
                }
            updateUserdata("userAge", "\(nowAge!)")
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
                accountDatas.updateValue(currentuser.displayName!, forKey: "userName")
            
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



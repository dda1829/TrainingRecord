//
//  ManageTrainingItem.swift
//  健身小幫手
//
//  Created by 邱宣策 on 2021/9/14.
//

import Foundation
import Firebase
import CoreData
class ManageTrainingItem {
    static var share = ManageTrainingItem()
    init(){
        let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
        for x in trainLocationLoading{
            queryFromDB(Location: x)
        }
//        loadData("info")
        if breastItems == nil, backItems == nil, abdomenItems == nil, blItems == nil, armItems == nil, exerciseItems == nil {
            let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
            for x in trainLocationLoading{
//                loadData(x)
            }
        }
        
    }
    private var trainingItem: TrainingItem?
    private var breastItems: [TrainingItem]?
    private var backItems: [TrainingItem]?
    private var abdomenItems: [TrainingItem]?
    private var blItems: [TrainingItem]?
    private var armItems: [TrainingItem]?
    private var exerciseItems: [TrainingItem]?
    
    
    
    
    
    
    
    
    //MARK: Core Data
    func queryFromDB(Location location:String)  {
        let moc = CoreDataHelper.shared.managedObjectContext()
        
        let request = NSFetchRequest<TrainingItem>(entityName: "TrainingItem")//設定查詢的Entity(table): select * from Note order by xxx
        //Prepared Statement, php , MySQL
        let predicate = NSPredicate(format: "type contains[cd] %@ ",location)//sql where條件
        //where username=vincent and password = '' or 1=1 ; -- '
        request.predicate = predicate
        
        moc.performAndWait {
            
            
            switch location{
            case "BrestShoulder":
                do{
                    let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                    self.breastItems = result
                }catch{
                    print("error query db \(error)")
                    self.breastItems = []
                }
            case "BottomLap":
                do{
                    let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                    self.blItems = result
                }catch{
                    print("error query db \(error)")
                    self.blItems = []
                }
            case "Arm":
                do{
                    let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                    self.armItems = result
                }catch{
                    print("error query db \(error)")
                    self.armItems = []
                }
            case "Back":
                do{
                    let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                    self.backItems = result
                }catch{
                    print("error query db \(error)")
                    self.backItems = []
                }
            case "Abdomen":
                do{
                    let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                    self.abdomenItems = result
                }catch{
                    print("error query db \(error)")
                    self.abdomenItems = []
                }
            case "Exercise":
                do{
                    let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                    self.exerciseItems = result
                }catch{
                    print("error query db \(error)")
                    self.exerciseItems = []
                }
            default:
                print("type wrong")
            }
            
            
            
            
            
            
            
           
        }
    }
    
}
class TrainingItem:  NSManagedObject{
    @NSManaged var name:String
    @NSManaged var id:Int16
    @NSManaged var type:String
    @NSManaged var imageName:String?
    @NSManaged var def:String
    
    override func awakeFromInsert() {
    }
    
    func image() -> UIImage? {
        
        if let fileName = self.imageName {
            let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
            let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
            let filePath = doc.appendingPathComponent(fileName)//利用noteID做檔案名稱.jpg
            return UIImage(contentsOfFile: filePath.path)//path:URL-> String
        }
        return nil
    }
    override func prepareForDeletion() {
        
        if let imageName = self.imageName {
            let home = URL(fileURLWithPath: NSHomeDirectory())//利用URL物件組路徑
            let doc = home.appendingPathComponent("Documents")//Documents不要拚錯
            let filePath = doc.appendingPathComponent(imageName)
            //if FileManager.default.fileExists(atPath: )
            try? FileManager.default.removeItem(at: filePath)
        }

        
    }
}

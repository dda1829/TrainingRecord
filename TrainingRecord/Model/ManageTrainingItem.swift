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
    
    private var trainingItem: TrainingItem?
    private var breastItems: [TrainingItem] = []
    private var backItems: [TrainingItem] = []
    private var abdomenItems: [TrainingItem] = []
    private var blItems: [TrainingItem] = []
    private var armItems: [TrainingItem] = []
    private var exerciseItems: [TrainingItem] = []
    private var beforeInfoItem: [InfoItemCoreData] = []
    private var infoItem: [InfoItemCoreData] = []
    private var lastData: [String:Int] = [:]
    private var indexId: Int16 = 1
    private var db : Firestore!
    private var imageDownloadCounter = [0,0,0,0,0,0]
    private var lastImageDataCheck: [String:Int] = [:]
    init(){
        InfoItemQueryFromDB()
        let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
        for x in trainLocationLoading{
            TrainingItemQueryFromDB(Location: x)
        }
        self.db = Firestore.firestore()
        loadData("info")

        if breastItems.count == 0, backItems.count == 0, abdomenItems.count == 0, blItems.count == 0, armItems.count == 0, exerciseItems.count == 0 {
            let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
            for x in trainLocationLoading{
                loadData(x)
            }
        }
        TimerUse.share.setTimer(1, self, #selector(checkTrainingData), true, 1)
    }
    @objc private func checkTrainingData(){
        if breastItems.count == lastData["BrestShoulder"], backItems.count == lastData["Back"], abdomenItems.count == lastData["Abdomen"], blItems.count == lastData["BottomLap"], armItems.count == lastData["Arm"], exerciseItems.count == lastData["Exercise"] {
            TimerUse.share.stopTimer(1)
            downloadImageFormListFromfirebase()
            TimerUse.share.setTimer(1, self, #selector(checkImageDownloaded), true, 1)
        }
    }
    @objc private func checkImageDownloaded() {
        if lastData["BrestShoulder"] == lastImageDataCheck["BrestShoulder"] && lastData["Back"] == lastImageDataCheck["Back"] && lastData["Abdomen"] ==  lastImageDataCheck["Abdomen"] && lastData["BottomLap"] == lastImageDataCheck["BottomLap"] && lastData["Arm"] == lastImageDataCheck["Arm"] && lastData["Exercise"] == lastImageDataCheck["Exercise"]{
            TimerUse.share.stopTimer(1)
            setImageFormListFromfirebase()
            
        }
    }
    // MARK: firestore load Training Data
    private func loadData(_ location: String) {
        self.db.collection(location).getDocuments() { [self] (querySnapshot, error) in
            if let e = error {
                print("error \(e)")
            }
            guard let data = querySnapshot else {return}
            if location == "info"{
                for document in data.documents{
                    let item = InfoItemForFireStore()
                    item.ItemContent = document.data()["itemContent"] as? String
                    item.ItemTitle = document.data()["itemTitle"] as? String
                    item.ItemEmail = document.data()["itemEmail"] as? String
                    item.ItemUserName = document.data()["itemUserName"] as? String
                    item.abdomenLast = document.data()["abdomenLast"] as? String
                    item.armLast = document.data()["armLast"] as? String
                    item.backLast = document.data()["backLast"] as? String
                    item.bottomLapLast = document.data()["bottomLapLast"] as? String
                    item.brestShoulderLast = document.data()["brestShoulderLast"] as? String
                    item.exerciseLast = document.data()["exerciseLast"] as? String
                    item.ItemID = document.documentID
                    let moc = CoreDataHelper.shared.managedObjectContext()
                    let data = InfoItemCoreData(context: moc)
                    data.abdomenLast = item.abdomenLast!
                    data.backLast = item.backLast!
                    data.blLast = item.bottomLapLast!
                    data.brestLast = item.brestShoulderLast!
                    data.armLast = item.armLast!
                    data.exLast = item.exerciseLast!
                    data.content = item.ItemContent!
                    data.title = item.ItemTitle!
                    data.id = "\((item.ItemID))"
                    data.editorName = item.ItemUserName!
                    data.editorEmail = item.ItemEmail!
                    CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                    infoItem.append(data)
                    self.lastData.updateValue(Int(item.brestShoulderLast!)!, forKey: "BrestShoulder")
                    self.lastData.updateValue(Int(item.backLast!)!, forKey: "Back")
                    self.lastData.updateValue(Int(item.abdomenLast!)!, forKey: "Abdomen")
                    self.lastData.updateValue(Int(item.bottomLapLast!)!, forKey: "BottomLap")
                    self.lastData.updateValue(Int(item.armLast!)!, forKey: "Arm")
                    self.lastData.updateValue(Int(item.exerciseLast!)!, forKey: "Exercise")
                    
                    if beforeInfoItem.count != infoItem.count {
                        let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
                        for x in trainLocationLoading{
                            indexId += Int16(lastData[x]!)

                        }
                        for x in trainLocationLoading{
                            loadData(x)
                        }
                    }
                }
            }else{
                for document in data.documents{
                    let item = TrainingItemForFireStore()
                    item.itemName = document.data()["itemName"] as? String
                    item.itemDef = document.data()["itemDef"] as? String
                    item.itemNumber = document.data()["itemNumber"] as? String
                    item.itemID = document.documentID
                    switch location{
                    case "BrestShoulder":
                        for x in 0 ..< breastItems.count {
                            guard breastItems[x].name != item.itemName! else{
                                return
                            }
                        }
                    let moc = CoreDataHelper.shared.managedObjectContext()
                    let data = TrainingItem(context: moc)
                        data.name = item.itemName!
                        data.def = item.itemDef!
                        data.id = "\(indexId)"
                        indexId += 1
                        CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        breastItems.append(data)
                    case "BottomLap":
                        for x in 0 ..< blItems.count {
                            guard blItems[x].name != item.itemName! else{
                                return
                            }
                        }
                        let moc = CoreDataHelper.shared.managedObjectContext()
                        let data = TrainingItem(context: moc)
                            data.name = item.itemName!
                            data.def = item.itemDef!
                            data.id = "\(indexId)"
                            indexId += 1
                            CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        blItems.append(data)
                    case "Arm":
                        for x in 0 ..< armItems.count {
                            guard armItems[x].name != item.itemName! else{
                                return
                            }
                        }
                        let moc = CoreDataHelper.shared.managedObjectContext()
                        let data = TrainingItem(context: moc)
                            data.name = item.itemName!
                            data.def = item.itemDef!
                            data.id = "\(indexId)"
                            indexId += 1
                            CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        armItems.append(data)
                    case "Back":
                        for x in 0 ..< backItems.count {
                            guard backItems[x].name != item.itemName! else{
                                return
                            }
                        }
                        let moc = CoreDataHelper.shared.managedObjectContext()
                        let data = TrainingItem(context: moc)
                            data.name = item.itemName!
                            data.def = item.itemDef!
                            data.id = "\(indexId)"
                            indexId += 1
                            CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        backItems.append(data)
                    case "Abdomen":
                        for x in 0 ..< abdomenItems.count {
                            guard abdomenItems[x].name != item.itemName! else{
                                return
                            }
                        }
                        let moc = CoreDataHelper.shared.managedObjectContext()
                        let data = TrainingItem(context: moc)
                            data.name = item.itemName!
                            data.def = item.itemDef!
                            data.id = "\(indexId)"
                            indexId += 1
                            CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        abdomenItems.append(data)
                    case "Exercise":
                        for x in 0 ..< exerciseItems.count {
                            guard exerciseItems[x].name != item.itemName! else{
                                return
                            }
                        }
                        let moc = CoreDataHelper.shared.managedObjectContext()
                        let data = TrainingItem(context: moc)
                            data.name = item.itemName!
                            data.def = item.itemDef!
                            data.id = "\(indexId)"
                            indexId += 1
                            CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        exerciseItems.append(data)
                    default:
                        print("type wrong")
                    }
                }
            }
        }
        
    }
    @objc private func downloadImageFormListFromfirebase() {
        
        let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
        for x in trainLocationLoading{
            switch x {
            case "BrestShoulder":
                for y in 1 ..< breastItems.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            case "Back":
                for y in 1 ..< backItems.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            case "Abdomen":
                for y in 1 ..< abdomenItems.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            case "Arm":
                for y in 1 ..< armItems.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            case "BottomLap":
                for y in 1 ..< blItems.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            case "Exercise":
                for y in 1 ..< exerciseItems.count{
                    DownLoadTrainingItemImage(x, "\(y).png")
                }
            default:
                print("Wrong Input")
            }
            
        }
        print("Modal is OK")
    }
    
    func getTrainingItem(Location location:String) -> [TrainingItem]?{
        switch location {
        case "BrestShoulder":
            return breastItems
        case "Back":
            return backItems
        case "Abdomen":
            return abdomenItems
        case "Arm":
            return armItems
        case "BottomLap":
            return blItems
        case "Exercise":
            return exerciseItems
        default:
            print("Wrong Input")
        }
        
        
        return nil
        
        
        
    }
    
    //MARK: Load the image data from firebase storge
    private func DownLoadTrainingItemImage(_ documentname: String, _ filename: String) {
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        let docUrl = homeUrl.appendingPathComponent("Documents")
        let doc2Url = docUrl.appendingPathComponent(documentname)
        let fileUrl = doc2Url.appendingPathComponent(filename)
        
        let storageRef = Storage.storage(url: "gs://trainingrecord-ad7d7.appspot.com/").reference()
        let imageRef = storageRef.child("\(documentname)/\(filename)").write(toFile: fileUrl)
        
        imageRef.observe(.success) { [self] snapshot in
            if lastImageDataCheck[documentname] == nil {
                lastImageDataCheck.updateValue(1, forKey: documentname)
            }else{
                lastImageDataCheck[documentname]! += 1
            }
            
            
        }
    }
    //MARK: PutImageIn
    @objc private func setImageFormListFromfirebase() {
        
        let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
        for x in trainLocationLoading{
            switch x {
            case "BrestShoulder":
                for y in 1 ..< breastItems.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            case "Back":
                for y in 1 ..< backItems.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            case "Abdomen":
                for y in 1 ..< abdomenItems.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            case "Arm":
                for y in 1 ..< armItems.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            case "BottomLap":
                for y in 1 ..< blItems.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            case "Exercise":
                for y in 1 ..< exerciseItems.count{
                    trainingItemImageAppend(x, "\(y).png")
                }
            default:
                print("Wrong Input")
            }
            
        }
    }
    //MARK: Put the imageData to CoreData
   private func trainingItemImageAppend(_ documentname: String, _ filename: String) {
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        let docUrl = homeUrl.appendingPathComponent("Documents")
        let doc2Url = docUrl.appendingPathComponent(documentname)
        let fileUrl = doc2Url.appendingPathComponent(filename)
        var c = 0
        while c == 0 {
            if let a = try! NSData.init(contentsOf: fileUrl){
                let b = UIImage(data: a as Data)!
                switch documentname {
                case "BrestShoulder":
                    let data = breastItems[imageDownloadCounter[0]]
                    let moc = CoreDataHelper.shared.managedObjectContext()
                    moc.performAndWait {
                        moc.delete(data)//delete from table ....
                    }
                    CoreDataHelper.shared.saveContext()
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    breastItems[imageDownloadCounter[0]] = data
                    CoreDataHelper.shared.saveContext()
                    
                    
                    imageDownloadCounter[0] += 1
                    print(homeUrl.absoluteString)
                    print("Documents/\(documentname)/\(filename)")
                    c += 1
                case "Back":
                    let data = backItems[imageDownloadCounter[1]]
                    let moc = CoreDataHelper.shared.managedObjectContext()
                    moc.performAndWait {
                        moc.delete(data)//delete from table ....
                    }
                    CoreDataHelper.shared.saveContext()
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    backItems[imageDownloadCounter[1]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[1] += 1
                    c += 1
                case "Abdomen":
                    let data = abdomenItems[imageDownloadCounter[2]]
                    let moc = CoreDataHelper.shared.managedObjectContext()
                    moc.performAndWait {
                        moc.delete(data)//delete from table ....
                    }
                    CoreDataHelper.shared.saveContext()
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    abdomenItems[imageDownloadCounter[2]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[2] += 1
                    c += 1
                case "Arm":
                    let data = armItems[imageDownloadCounter[3]]
                    let moc = CoreDataHelper.shared.managedObjectContext()
                    moc.performAndWait {
                        moc.delete(data)//delete from table ....
                    }
                    CoreDataHelper.shared.saveContext()
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    armItems[imageDownloadCounter[3]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[3] += 1
                    c += 1
                case "BottomLap":
                    let data = blItems[imageDownloadCounter[4]]
                    let moc = CoreDataHelper.shared.managedObjectContext()
                    moc.performAndWait {
                        moc.delete(data)//delete from table ....
                    }
                    CoreDataHelper.shared.saveContext()
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    blItems[imageDownloadCounter[4]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[4] += 1
                    c += 1
                case "Exercise":
                    let data = exerciseItems[imageDownloadCounter[5]]
                    let moc = CoreDataHelper.shared.managedObjectContext()
                    moc.performAndWait {
                        moc.delete(data)//delete from table ....
                    }
                    CoreDataHelper.shared.saveContext()
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    exerciseItems[imageDownloadCounter[5]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[5] += 1
                    c += 1
                default:
                    print("wrong type")
                }
            }
        }
    }
    
    //MARK: Core Data
   private func TrainingItemQueryFromDB(Location location:String)  {
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
   private func InfoItemQueryFromDB()  {
        let moc = CoreDataHelper.shared.managedObjectContext()
        
        let request = NSFetchRequest<InfoItemCoreData>(entityName: "InfoItemCoreData")//設定查詢的Entity(table): select * from Note order by xxx
        let sortDescriptorbl = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptorbl]
        
        moc.performAndWait {
            do{
                let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                self.beforeInfoItem = result
            }catch{
                print("error query db \(error)")
                self.beforeInfoItem = []
            }
        }
    }
    
}
//class TrainingItem:  NSManagedObject{
////    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingItem> {
//////        return NSFetchRequest<TrainingItem>(entityName: "TrainingItem")
//////    }
////    @NSManaged var name:String?
////    @NSManaged var id:Int16
////    @NSManaged var type:String?
////    @NSManaged var imageName:String?
////    @NSManaged var def:String?
//
//}
//class InfoItemCoreData:  NSManagedObject{
////    @nonobjc public class func fetchRequest() -> NSFetchRequest<InfoItemCoreData> {
////        return NSFetchRequest<InfoItemCoreData>(entityName: "InfoItemCoreData")
////    }
////    @NSManaged var title:String?
////    @NSManaged var id:String
////    @NSManaged var content:String?
////    @NSManaged var brestLast:String?
////    @NSManaged var backLast:String?
////    @NSManaged var abdomenLast:String?
////    @NSManaged var armLast:String?
////    @NSManaged var blLast:String?
////    @NSManaged var exLast:String?
////    @NSManaged var editorEmail:String?
////    @NSManaged var editorName:String?
//
//
//}

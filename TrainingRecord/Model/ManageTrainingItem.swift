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
    //use for coredata
    private var breastItems: [TrainingItem] = []
    private var backItems: [TrainingItem] = []
    private var abdomenItems: [TrainingItem] = []
    private var blItems: [TrainingItem] = []
    private var armItems: [TrainingItem] = []
    private var exerciseItems: [TrainingItem] = []
    private var beforeInfoItem: [InfoItemCoreData] = []
    private var infoItems: [InfoItemCoreData] = []
    //use for store the deleted Items
    private var deletedBreastItems: [TrainingItem] = []
    private var deletedBackItems: [TrainingItem] = []
    private var deletedAbdomenItems: [TrainingItem] = []
    private var deletedBLItems: [TrainingItem] = []
    private var deletedArmItems: [TrainingItem] = []
    private var deletedExerciseItems: [TrainingItem] = []
    // use for prevent re-save the core data
    private var brestName:[String] = []
    private var backName:[String] = []
    private var abdomenName:[String] = []
    private var blName: [String] = []
    private var armName: [String] = []
    private var exName: [String] = []
    private var infoTitle: [String] = []
    
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
            TrainingItemDeletedQueryFromDB(Location: x)
        }
        self.db = Firestore.firestore()
        loadData("info")
       
        if breastItems.count == 0, backItems.count == 0, abdomenItems.count == 0, blItems.count == 0, armItems.count == 0, exerciseItems.count == 0 {
            let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
            for x in trainLocationLoading{
                loadData(x)
            }
        }
    }
       
    // MARK: firestore load Training Data
     func loadData(_ location: String) {
        self.db.collection(location).getDocuments() { [self] (querySnapshot, error) in
            if let e = error {
                print("error \(e)")
            }
            guard let data = querySnapshot else {return}
            if location == "info"{
                for document in data.documents{
                    DispatchQueue.global().sync {
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
                        item.haveNewItem = document.data()["haveNewItem"] as? Bool
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
                            data.id = item.ItemID
                            data.editorName = item.ItemUserName!
                            data.editorEmail = item.ItemEmail!
                            infoItems.append(data)
                            if !infoTitle.contains(item.ItemTitle!){
                            CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                            }
                            self.lastData.updateValue(Int(item.brestShoulderLast!)!, forKey: "BrestShoulder")
                            self.lastData.updateValue(Int(item.backLast!)!, forKey: "Back")
                            self.lastData.updateValue(Int(item.abdomenLast!)!, forKey: "Abdomen")
                            self.lastData.updateValue(Int(item.bottomLapLast!)!, forKey: "BottomLap")
                            self.lastData.updateValue(Int(item.armLast!)!, forKey: "Arm")
                            self.lastData.updateValue(Int(item.exerciseLast!)!, forKey: "Exercise")
                        NotificationCenter.default.post(name: Notification.Name("infoItems"), object: nil, userInfo: ["infoItems":infoItems])
                        if beforeInfoItem.count < infoItems.count && beforeInfoItem.count != 0 && item.haveNewItem! {
                                let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
                                for x in trainLocationLoading{
                                    indexId += Int16(lastData[x]!)

                                }
                                for x in trainLocationLoading{
                                    loadData(x)
                                }
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
                    
                    DispatchQueue.global().sync {
                    switch location{
                    case "BrestShoulder":
                        if !brestName.contains(item.itemName!){
                    let moc = CoreDataHelper.shared.managedObjectContext()
                    let data = TrainingItem(context: moc)
                        data.name = item.itemName!
                        data.def = item.itemDef!
                        data.id = "\(indexId)"
                        data.type = location
                        indexId += 1
                        CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        breastItems.append(data)
                        }
                    case "BottomLap":
                        if !blName.contains(item.itemName!){
                        let moc = CoreDataHelper.shared.managedObjectContext()
                        let data = TrainingItem(context: moc)
                            data.name = item.itemName!
                            data.def = item.itemDef!
                            data.id = "\(indexId)"
                            data.type = location
                            indexId += 1
                            CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        blItems.append(data)
                        }
                    case "Arm":
                        if !armName.contains(item.itemName!){
                        let moc = CoreDataHelper.shared.managedObjectContext()
                        let data = TrainingItem(context: moc)
                            data.name = item.itemName!
                            data.def = item.itemDef!
                            data.id = "\(indexId)"
                            data.type = location
                            indexId += 1
                            CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        armItems.append(data)
                        }
                    case "Back":
                        if !backName.contains(item.itemName!){
                        let moc = CoreDataHelper.shared.managedObjectContext()
                        let data = TrainingItem(context: moc)
                            data.name = item.itemName!
                            data.def = item.itemDef!
                            data.id = "\(indexId)"
                            data.type = location
                            indexId += 1
                            CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        backItems.append(data)
                        }
                    case "Abdomen":
                        if !abdomenName.contains(item.itemName!){
                        let moc = CoreDataHelper.shared.managedObjectContext()
                        let data = TrainingItem(context: moc)
                            data.name = item.itemName!
                            data.def = item.itemDef!
                            data.id = "\(indexId)"
                            data.type = location
                            indexId += 1
                            CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                        abdomenItems.append(data)
                        }
                    case "Exercise":
                        if !exName.contains(item.itemName!){
                            let moc = CoreDataHelper.shared.managedObjectContext()
                            let data = TrainingItem(context: moc)
                                data.name = item.itemName!
                                data.def = item.itemDef!
                                data.id = "\(indexId)"
                                data.type = location
                                indexId += 1
                                CoreDataHelper.shared.saveContext()//把Note資料存到sqlite
                            exerciseItems.append(data)
                        }
                    default:
                        print("type wrong")
                    }
                    if breastItems.count == lastData["BrestShoulder"], backItems.count == lastData["Back"], abdomenItems.count == lastData["Abdomen"], blItems.count == lastData["BottomLap"], armItems.count == lastData["Arm"], exerciseItems.count == lastData["Exercise"] {
                        downloadImageFormListFromfirebase()
                    }
                }
                }
            }
        }
        
    }
     private func downloadImageFormListFromfirebase() {
        
        let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
        for x in trainLocationLoading{
            switch x {
            case "BrestShoulder":
                for y in 0 ..< breastItems.count{
                    DownLoadTrainingItemImage(x, "\(y + 1).png")
                }
            case "Back":
                for y in 0 ..< backItems.count{
                    DownLoadTrainingItemImage(x, "\(y + 1).png")
                }
            case "Abdomen":
                for y in 0 ..< abdomenItems.count{
                    DownLoadTrainingItemImage(x, "\(y + 1).png")
                }
            case "Arm":
                for y in 0 ..< armItems.count{
                    DownLoadTrainingItemImage(x, "\(y + 1).png")
                }
            case "BottomLap":
                for y in 0 ..< blItems.count{
                    DownLoadTrainingItemImage(x, "\(y + 1).png")
                }
            case "Exercise":
                for y in 0 ..< exerciseItems.count{
                    DownLoadTrainingItemImage(x, "\(y + 1).png")
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
    func getDeletedTrainingItem(Location location:String) -> [TrainingItem]?{
        switch location {
        case "BrestShoulder":
            return deletedBreastItems
        case "Back":
            return deletedBackItems
        case "Abdomen":
            return deletedBackItems
        case "Arm":
            return deletedArmItems
        case "BottomLap":
            return deletedBLItems
        case "Exercise":
            return deletedExerciseItems
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
            DispatchQueue.global().sync {
                if lastImageDataCheck[documentname] == nil {
                    lastImageDataCheck.updateValue(1, forKey: documentname)
                }else{
                    lastImageDataCheck[documentname]! += 1
                }
                if lastData["BrestShoulder"] == lastImageDataCheck["BrestShoulder"] && lastData["Back"] == lastImageDataCheck["Back"] && lastData["Abdomen"] ==  lastImageDataCheck["Abdomen"] && lastData["BottomLap"] == lastImageDataCheck["BottomLap"] && lastData["Arm"] == lastImageDataCheck["Arm"] && lastData["Exercise"] == lastImageDataCheck["Exercise"]{
        
                    setImageFormListFromfirebase()
                }
            }
            
            
        }
    }
    //MARK: PutImageIn
    private func setImageFormListFromfirebase() {
        
        let trainLocationLoading : [String] = ["BrestShoulder","Back","Abdomen","Arm","BottomLap","Exercise"]
        for x in trainLocationLoading{
            switch x {
            case "BrestShoulder":
                for y in 0 ..< breastItems.count{
                    trainingItemImageAppend(x, "\(y + 1).png")
                }
            case "Back":
                for y in 0 ..< backItems.count{
                    trainingItemImageAppend(x, "\(y + 1).png")
                }
            case "Abdomen":
                for y in 0 ..< abdomenItems.count{
                    trainingItemImageAppend(x, "\(y + 1).png")
                }
            case "Arm":
                for y in 0 ..< armItems.count{
                    trainingItemImageAppend(x, "\(y + 1).png")
                }
            case "BottomLap":
                for y in 0 ..< blItems.count{
                    trainingItemImageAppend(x, "\(y + 1).png")
                }
            case "Exercise":
                for y in 0 ..< exerciseItems.count{
                    trainingItemImageAppend(x, "\(y + 1).png")
                }
            default:
                print("Wrong Input")
            }
            
        }
    }
    //MARK: Put the imageData to CoreData
   private func trainingItemImageAppend(_ documentname: String, _ filename: String) {
                switch documentname {
                case "BrestShoulder":
                    let data = breastItems[imageDownloadCounter[0]]
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    breastItems[imageDownloadCounter[0]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[0] += 1
                case "Back":
                    let data = backItems[imageDownloadCounter[1]]
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    backItems[imageDownloadCounter[1]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[1] += 1
                case "Abdomen":
                    let data = abdomenItems[imageDownloadCounter[2]]
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    abdomenItems[imageDownloadCounter[2]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[2] += 1
                case "Arm":
                    let data = armItems[imageDownloadCounter[3]]
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    armItems[imageDownloadCounter[3]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[3] += 1
                case "BottomLap":
                    let data = blItems[imageDownloadCounter[4]]
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    blItems[imageDownloadCounter[4]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[4] += 1
                case "Exercise":
                    let data = exerciseItems[imageDownloadCounter[5]]
                    data.imageName = "Documents/\(documentname)/\(filename)"
                    exerciseItems[imageDownloadCounter[5]] = data
                    CoreDataHelper.shared.saveContext()
                    imageDownloadCounter[5] += 1
                default:
                    print("wrong type")
                }
            
            
            if documentname == "Exercise" && filename == "\(lastData["Exercise"]!).png"{
                NotificationCenter.default.post(name: Notification.Name("TrainingItemDeliver"), object: nil, userInfo: ["breastItems":breastItems,"backItems":backItems,"abdomenItems":abdomenItems,"blItems":blItems,"armItems":armItems,"exerciseItems":exerciseItems])
            }
        
    }
    
    
    
    
    func recoverTrainingItem(Location location:String,EditedRow editedrow: Int){
        switch location {
        case "BrestShoulder":
            let breast = deletedBreastItems[editedrow]
            breast.type = "\(location)"
            deletedBreastItems[editedrow] = breast
            CoreDataHelper.shared.saveContext()
            TrainingItemQueryFromDB(Location: "BrestShoulder")
            TrainingItemDeletedQueryFromDB(Location: "BrestShoulder")
            NotificationCenter.default.post(name: Notification.Name("reloadBreastItems"), object: nil, userInfo: ["BreastItems":breastItems])
        case "Back":
            let back = deletedBackItems[editedrow]
             back.type = "\(location)"
             deletedBackItems[editedrow] = back
             CoreDataHelper.shared.saveContext()
            TrainingItemQueryFromDB(Location: "Back")
            TrainingItemDeletedQueryFromDB(Location: "Back")
            NotificationCenter.default.post(name: Notification.Name("reloadBackItems"), object: nil, userInfo: ["BackItems":backItems])
        case "Abdomen":
            let abdomen = deletedAbdomenItems[editedrow]
             abdomen.type = "\(location)"
             deletedAbdomenItems[editedrow] = abdomen
             CoreDataHelper.shared.saveContext()
            TrainingItemQueryFromDB(Location: "Abdomen")
            TrainingItemDeletedQueryFromDB(Location: "Abdomen")
            NotificationCenter.default.post(name: Notification.Name("reloadAbdomenItems"), object: nil, userInfo: ["AbdomenItems":abdomenItems])
        case "Arm":
            let arm = deletedArmItems[editedrow]
             arm.type = "\(location)"
             deletedArmItems[editedrow] = arm
             CoreDataHelper.shared.saveContext()
            TrainingItemQueryFromDB(Location: "Arm")
            TrainingItemDeletedQueryFromDB(Location: "Arm")
            NotificationCenter.default.post(name: Notification.Name("reloadArmItems"), object: nil, userInfo: ["ArmItems":armItems])
        case "BottomLap":
            let bl = deletedBLItems[editedrow]
             bl.type = "\(location)"
             deletedBLItems[editedrow] = bl
             CoreDataHelper.shared.saveContext()
            TrainingItemQueryFromDB(Location: "BottomLap")
            TrainingItemDeletedQueryFromDB(Location: "BottomLap")
            NotificationCenter.default.post(name: Notification.Name("reloadBLItems"), object: nil, userInfo: ["BLItems":blItems])
        case "Exercise":
            let exercise = deletedExerciseItems[editedrow]
             exercise.type = "\(location)"
             deletedExerciseItems[editedrow] = exercise
             CoreDataHelper.shared.saveContext()
            TrainingItemQueryFromDB(Location: "Exercise")
            TrainingItemDeletedQueryFromDB(Location: "Exercise")
            NotificationCenter.default.post(name: Notification.Name("reloadExItems"), object: nil, userInfo: ["ExItems":exerciseItems])
        default:
            print("Wrong Input")
        }
    }
    
    func editTraingItem(Location location:String, EditedRow editedrow: Int?,EditedtoRow editedtorow:Int?,Content content: TrainingItem?,Type type: String){
        switch type {
        case "new":
            switch location {
            case "BrestShoulder":
                breastItems.append(content!)
                CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "BrestShoulder")
                NotificationCenter.default.post(name: Notification.Name("reloadBreastItems"), object: nil, userInfo: ["BreastItems":breastItems])
            case "Back":
                backItems.append(content!)
                 CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "Back")
                NotificationCenter.default.post(name: Notification.Name("reloadBackItems"), object: nil, userInfo: ["BackItems":backItems])
            case "Abdomen":
                abdomenItems.append(content!)
                 CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "Abdomen")
                NotificationCenter.default.post(name: Notification.Name("reloadAbdomenItems"), object: nil, userInfo: ["AbdomenItems":abdomenItems])
            case "Arm":
                armItems.append(content!)
                 CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "Arm")
                NotificationCenter.default.post(name: Notification.Name("reloadArmItems"), object: nil, userInfo: ["ArmItems":armItems])
            case "BottomLap":
                blItems.append(content!)
                 CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "BottomLap")
                NotificationCenter.default.post(name: Notification.Name("reloadBLItems"), object: nil, userInfo: ["BLItems":blItems])
            case "Exercise":
                exerciseItems.append(content!)
                 CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "Exercise")
                NotificationCenter.default.post(name: Notification.Name("reloadExItems"), object: nil, userInfo: ["ExItems":exerciseItems])
            default:
                print("Wrong Input")
            }
        case "delete":
            switch location {
            case "BrestShoulder":
                let breast = breastItems[editedrow!]
                breast.type = "d\(location)"
                breastItems[editedrow!] = breast
                CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "BrestShoulder")
                TrainingItemDeletedQueryFromDB(Location: "BrestShoulder")
                NotificationCenter.default.post(name: Notification.Name("reloadBreastItems"), object: nil, userInfo: ["BreastItems":breastItems])
            case "Back":
                let back = backItems[editedrow!]
                 back.type = "d\(location)"
                 backItems[editedrow!] = back
                 CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "Back")
                TrainingItemDeletedQueryFromDB(Location: "Back")
                NotificationCenter.default.post(name: Notification.Name("reloadBackItems"), object: nil, userInfo: ["BackItems":backItems])
            case "Abdomen":
                let abdomen = abdomenItems[editedrow!]
                 abdomen.type = "d\(location)"
                 abdomenItems[editedrow!] = abdomen
                 CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "Abdomen")
                TrainingItemDeletedQueryFromDB(Location: "Abdomen")
                NotificationCenter.default.post(name: Notification.Name("reloadAbdomenItems"), object: nil, userInfo: ["AbdomenItems":abdomenItems])
            case "Arm":
                let arm = armItems[editedrow!]
                 arm.type = "d\(location)"
                 armItems[editedrow!] = arm
                 CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "Arm")
                TrainingItemDeletedQueryFromDB(Location: "Arm")
                NotificationCenter.default.post(name: Notification.Name("reloadArmItems"), object: nil, userInfo: ["ArmItems":armItems])
            case "BottomLap":
                let bl = blItems[editedrow!]
                 bl.type = "d\(location)"
                 blItems[editedrow!] = bl
                 CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "BottomLap")
                TrainingItemDeletedQueryFromDB(Location: "BottomLap")
                NotificationCenter.default.post(name: Notification.Name("reloadBLItems"), object: nil, userInfo: ["BLItems":blItems])
            case "Exercise":
                let exercise = exerciseItems[editedrow!]
                 exercise.type = "d\(location)"
                 exerciseItems[editedrow!] = exercise
                 CoreDataHelper.shared.saveContext()
                TrainingItemQueryFromDB(Location: "Exercise")
                TrainingItemDeletedQueryFromDB(Location: "Exercise")
                NotificationCenter.default.post(name: Notification.Name("reloadExItems"), object: nil, userInfo: ["ExItems":exerciseItems])
            default:
                print("Wrong Input")
            }
            case "edit":
                
                if editedtorow! - editedrow! > 0{
                switch location {
                case "BrestShoulder":
                    for x in stride(from: editedtorow!, to: editedrow!, by: -1){
                        let a = breastItems[x - 1].id
                        breastItems[x - 1].id = breastItems[x].id
                        breastItems[x].id = a
                        CoreDataHelper.shared.saveContext()
                    }
                    TrainingItemQueryFromDB(Location: "BrestShoulder")
                    NotificationCenter.default.post(name: Notification.Name("reloadBreastItems"), object: nil, userInfo: ["BreastItems":breastItems])
                case "Back":
                    
                            for x in stride(from: editedtorow!, to: editedrow!, by: -1) {
                              let a = backItems[x - 1].id
                                backItems[x - 1].id = backItems[x].id
                                backItems[x].id = a
                                CoreDataHelper.shared.saveContext()
                            }
                    TrainingItemQueryFromDB(Location: "Back")
                    NotificationCenter.default.post(name: Notification.Name("reloadBackItems"), object: nil, userInfo: ["BackItems":backItems])
                case "Abdomen":
                    for x in stride(from: editedtorow!, to: editedrow!, by: -1){
                        let a = abdomenItems[x - 1].id
                        abdomenItems[x - 1].id = abdomenItems[x].id
                        abdomenItems[x].id = a
                        CoreDataHelper.shared.saveContext()
                    }
                    TrainingItemQueryFromDB(Location: "Abdomen")
                    NotificationCenter.default.post(name: Notification.Name("reloadAbdomenItems"), object: nil, userInfo: ["AbdomenItems":abdomenItems])
                case "Arm":
                    for x in stride(from: editedtorow!, to: editedrow!, by: -1){
                        let a = armItems[x - 1].id
                        armItems[x - 1].id = armItems[x].id
                        armItems[x].id = a
                        CoreDataHelper.shared.saveContext()
                    }
                    TrainingItemQueryFromDB(Location: "Arm")
                    NotificationCenter.default.post(name: Notification.Name("reloadArmItems"), object: nil, userInfo: ["ArmItems":armItems])
                case "BottomLap":
                    for x in stride(from: editedtorow!, to: editedrow!, by: -1){
                        let a = blItems[x - 1].id
                        blItems[x - 1].id = blItems[x].id
                        blItems[x].id = a
                        CoreDataHelper.shared.saveContext()
                    }
                    TrainingItemQueryFromDB(Location: "BottomLap")
                    NotificationCenter.default.post(name: Notification.Name("reloadBLItems"), object: nil, userInfo: ["BLItems":blItems])
                case "Exercise":
                    for x in stride(from: editedtorow!, to: editedrow!, by: -1){
                        let a = exerciseItems[x - 1].id
                        exerciseItems[x - 1].id = exerciseItems[x].id
                        exerciseItems[x].id = a
                        CoreDataHelper.shared.saveContext()
                    }
                    TrainingItemQueryFromDB(Location: "Exercise")
                    NotificationCenter.default.post(name: Notification.Name("reloadExItems"), object: nil, userInfo: ["ExItems":exerciseItems])
                default:
                    print("Wrong Input")
                }
                }
        default:
            print("Wrong Input")
        }
    }
    
    
    
    
    
    //MARK: Core Data
   private func TrainingItemQueryFromDB(Location location:String)  {
        let moc = CoreDataHelper.shared.managedObjectContext()
        
        let request = NSFetchRequest<TrainingItem>(entityName: "TrainingItem")//設定查詢的Entity(table): select * from Note order by xxx
        //Prepared Statement, php , MySQL
        let predicate = NSPredicate(format: "type = %@ ",location)//sql where條件
    let sortDescriptorbl = NSSortDescriptor(key: "id", ascending: true)
    request.sortDescriptors = [sortDescriptorbl]
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
    switch location{
    case "BrestShoulder":
        for x in 0 ..< breastItems.count {
            if !brestName.contains(breastItems[x].name!){
            brestName.append(breastItems[x].name!)
            }
        }
    case "BottomLap":
        for x in 0 ..< blItems.count {
            if !blName.contains(blItems[x].name!){
            blName.append(blItems[x].name!)
            }
        }
    case "Arm":
        for x in 0 ..< armItems.count {
            if !armName.contains(armItems[x].name!){
            armName.append(armItems[x].name!)
            }
        }
    case "Back":
        for x in 0 ..< backItems.count {
            if !backName.contains(backItems[x].name!){
            backName.append(backItems[x].name!)
            }
        }
    case "Abdomen":
        for x in 0 ..< abdomenItems.count {
            if !abdomenName.contains(abdomenItems[x].name!){
            abdomenName.append(abdomenItems[x].name!)
            }
        }
    case "Exercise":
        for x in 0 ..< exerciseItems.count {
            if !exName.contains(exerciseItems[x].name!){
            exName.append(exerciseItems[x].name!)
            }
        }
    default:
        print("type wrong")
    }
    }
    private func TrainingItemDeletedQueryFromDB(Location location:String)  {
         let moc = CoreDataHelper.shared.managedObjectContext()
         
         let request = NSFetchRequest<TrainingItem>(entityName: "TrainingItem")//設定查詢的Entity(table): select * from Note order by xxx
         //Prepared Statement, php , MySQL
         let predicate = NSPredicate(format: "type contains[cd] %@ ","d" + location)//sql where條件
         let sortDescriptorbl = NSSortDescriptor(key: "id", ascending: true)
         request.sortDescriptors = [sortDescriptorbl]
         request.predicate = predicate
         
         moc.performAndWait {
             
             
             switch location{
             case "BrestShoulder":
                 do{
                     let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                     self.deletedBreastItems = result
                 }catch{
                     print("error query db \(error)")
                     self.deletedBreastItems = []
                 }
             case "BottomLap":
                 do{
                     let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                     self.deletedBLItems = result
                 }catch{
                     print("error query db \(error)")
                     self.deletedBLItems = []
                 }
             case "Arm":
                 do{
                     let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                     self.deletedArmItems = result
                 }catch{
                     print("error query db \(error)")
                     self.deletedArmItems = []
                 }
             case "Back":
                 do{
                     let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                     self.deletedBackItems = result
                 }catch{
                     print("error query db \(error)")
                     self.deletedBackItems = []
                 }
             case "Abdomen":
                 do{
                     let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                     self.deletedAbdomenItems = result
                 }catch{
                     print("error query db \(error)")
                     self.deletedAbdomenItems = []
                 }
             case "Exercise":
                 do{
                     let result = try moc.fetch(request) //送到DB(sqlite)做查詢
                     self.deletedExerciseItems = result
                 }catch{
                     print("error query db \(error)")
                     self.deletedExerciseItems = []
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
    
    for x in 0 ..< beforeInfoItem.count{
        infoTitle.append(beforeInfoItem[x].title!)
    }
    
    
    
    }
    
}
class TrainingItem:  NSManagedObject{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingItem> {
        return NSFetchRequest<TrainingItem>(entityName: "TrainingItem")
    }
    @NSManaged var name:String?
    @NSManaged var id:String
    @NSManaged var type:String?
    @NSManaged var imageName:String?
    @NSManaged var def:String?

}
class InfoItemCoreData:  NSManagedObject{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<InfoItemCoreData> {
        return NSFetchRequest<InfoItemCoreData>(entityName: "InfoItemCoreData")
    }
    @NSManaged var title:String?
    @NSManaged var id:String
    @NSManaged var content:String?
    @NSManaged var brestLast:String?
    @NSManaged var backLast:String?
    @NSManaged var abdomenLast:String?
    @NSManaged var armLast:String?
    @NSManaged var blLast:String?
    @NSManaged var exLast:String?
    @NSManaged var editorEmail:String?
    @NSManaged var editorName:String?


}

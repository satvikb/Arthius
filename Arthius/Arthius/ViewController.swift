//
//  ViewController.swift
//  Arthius
//
//  Created by Satvik Borra on 3/20/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

let transitionTime : CGFloat = 0.2;
let db = Firestore.firestore()
let storage = Storage.storage()

let lineStartTag = 1020;


enum View {
    case Splash
    case Menu
    case Account
    case PlaySelect
    case CampaignLevelSelect
    case LevelPlay
    case CreateSelect
    case LevelCreate
    case SavedLevelSelect
    case GLS
    case LevelBeat
}

class ViewController: UIViewController, MenuViewDelegate, AccountViewDelegate, PlaySelectViewDelegate, CampaignLevelSelectorViewDelegate, LevelViewDelegate, CreateLevelSelectorViewDelegate, CreateLevelViewDelegate, GlobalLevelSelectViewDelegate{

    var currentView : View!;
    var menuView : MenuView!;
    var accountView : AccountView!;
    var playSelectView : PlaySelectView!;
    var campaignLevelSelectView : CampaignLevelSelectView!;
    var createLevelSelectView : CreateLevelSelectView!;
    var globalLevelSelectView : GlobalLevelSelectView!;
    
    var levelView : LevelView!;
    var currentLevel : Level!;
    
    var createLevelView : CreateLevelView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentView = View.Splash
        
        File.copyLevelsFromBundleToDocuments()
        CampaignLevelHandler.load()
        ProgressHandler.load()
        
        firebaseAuthHandler()

        menuView = MenuView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        menuView.menuDelegate = self;
        
        accountView = AccountView(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1)))
        accountView.accountDelegate = self;
        
        
        //TODO change these startPosition to frame
        playSelectView = PlaySelectView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        playSelectView.playSelectDelegate = self;
        
        createLevelSelectView = CreateLevelSelectView(startPosition: CGPoint(x: 0, y: 0))
        createLevelSelectView.createLevelSelectDelegate = self;
        
        globalLevelSelectView = GlobalLevelSelectView(frame:  propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1)))
        globalLevelSelectView.globalLevelSelectDelegate = self;
        
        // COPY ALL FILES FROM LEVELS FOLDER TO DOCUMENTS
        // DO THIS BEFORE CAMPAIGNLEVELVIEW INIT
        
        campaignLevelSelectView = CampaignLevelSelectView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        campaignLevelSelectView.campaignLevelSelectDelegate = self;
        
        
        switchToView(newView: .Menu)
    }
    
    func firebaseAuthHandler(){
        let _ = Auth.auth().addStateDidChangeListener({(auth, user) in
            print("CHANGE \(String(describing: user?.uid))")
        })
    }
    
    func switchToView(newView : View, transitionTime : CGFloat = transitionTime, forceParentView: Bool = false, forcedParentView : View = .Menu){
        func removeView(view: UIView, after: CGFloat){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(after), execute: {
                view.removeFromSuperview()
            })
        }
        
        switch currentView {
        case .Menu:
            menuView.animateOut()
            removeView(view: menuView, after: transitionTime)
            break;
        case .Account:
            accountView.animateOut()
            removeView(view: accountView, after: transitionTime)
        case .PlaySelect:
            playSelectView.animateOut(time: transitionTime)
            removeView(view: playSelectView, after: transitionTime)
//            playSelectView.removeFromSuperview()
            break;
        case .CampaignLevelSelect:
            campaignLevelSelectView.animateOut(time: transitionTime)
            removeView(view: campaignLevelSelectView, after: transitionTime)
            break;
        case .LevelPlay:
            //TODO animate
            levelView.animateOut()
            removeView(view: levelView, after: transitionTime)
            break;
        case .CreateSelect:
            createLevelSelectView.animateOut(time: transitionTime)
            removeView(view: createLevelSelectView, after: transitionTime)
            break;
        case .LevelCreate:
            //TODO animate
            createLevelView.animateOut()
            removeView(view: createLevelView, after: transitionTime)
            break;
        case .GLS:
            globalLevelSelectView.animateOut()
            removeView(view: globalLevelSelectView, after: transitionTime)
            break;
        default: break
            
        }
        
        switch newView {
        case .Menu:
            self.view.addSubview(menuView);
            menuView.animateIn()
            break;
        case .Account:
            self.view.addSubview(accountView)
            accountView.animateIn()
        case .LevelPlay:
            levelView = LevelView(_level: currentLevel, _parentView: forceParentView ? forcedParentView : currentView, _campaignLevel: didPressCampaignLevel)//, _resetToLevel: currentLevel)
            levelView.levelViewDelegate = self;
            levelView.animateIn()
            didPressCampaignLevel = false;
            self.view.addSubview(levelView)
            break;
        case .PlaySelect:
            self.view.addSubview(playSelectView)
            playSelectView.animateIn(time: transitionTime)
            break;
        case .CampaignLevelSelect:
//            campaignLevelSelectView.
            self.view.addSubview(campaignLevelSelectView)
            campaignLevelSelectView.animateIn(time: transitionTime)
        case .CreateSelect:
            createLevelSelectView.loadLevels()
            self.view.addSubview(createLevelSelectView)
            createLevelSelectView.animateIn(time: transitionTime)
            break;
        case .LevelCreate:
            createLevelView = CreateLevelView(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1)), existingLevel: currentLevel.levelData!)
            createLevelView.delegate = self;
            createLevelView.animateIn()
            self.view.addSubview(createLevelView)
            break;
        case .GLS:
            self.view.addSubview(globalLevelSelectView)
            globalLevelSelectView.animateIn()
            break;
        default: break
            
        }
        
        currentView = newView;
    }
    
    public func propToPoint(prop: CGPoint) -> CGPoint {
        return CGPoint(x: propToFloat(prop: prop.x, scaleWithX: true), y: propToFloat(prop: prop.y, scaleWithX: false))
    }
    
    public func propToVector(prop: CGVector) -> CGVector {
        return CGVector(dx: propToFloat(prop: prop.dx, scaleWithX: true), dy: propToFloat(prop: prop.dy, scaleWithX: false))
    }
    
    public func propToFloat(prop: CGFloat, scaleWithX: Bool) -> CGFloat{
        let screen = UIScreen.main.bounds;
        return scaleWithX == true ? prop * screen.width : prop * screen.height;
    }
    
    public func propToRect(prop: CGRect) -> CGRect{
        let screen = UIScreen.main.bounds;
        return CGRect(x: prop.origin.x * screen.width, y: prop.origin.y * screen.height, width: screen.width*prop.width, height: screen.height*prop.height)
    }
    
    
    //delegate methods
    
    func menu_pressPlay(){
        switchToView(newView: View.PlaySelect)
    }
    
    func menu_pressCreate() {
        switchToView(newView: View.CreateSelect)
    }
    
    func menu_pressAccount() {
        switchToView(newView: .Account)
    }
    
    func account_pressBack() {
        switchToView(newView: .Menu)
    }
    
    func account_isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func account_signUp(email: String, password: String) {
        
    }
    
    func account_signIn(email: String, password: String) {
        
    }
    
    func globalLevelSelect_pressBack() {
        switchToView(newView: .PlaySelect)
    }
    
    func globalLevelSelect_pressLevel(level: GLSLevelData) {
        getLevelFile(uuid: level.levelUUID, completion: {(levelData : LevelData) in
            DownloadCounter.addDownloadCounterTo(uuid: level.levelUUID)
            self.currentLevel = Level(levelData: levelData);
            self.switchToView(newView: .LevelPlay)
        })
    }
    
    func getLevelFile(uuid: String, completion: @escaping (_ levelData : LevelData) -> Void){
        let storageRef = storage.reference()
        let levelRef = storageRef.child("levels/\(uuid).gws")
        
        // Download in memory with a maximum allowed size of 10MB (10 * 1024 * 1024 bytes)
        levelRef.getData(maxSize: 10 * 1024 * 1024, completion: {(datao : Data?, error : Error?) in
            if let error = error {
                // Uh-oh, an error occurred!
                print("error getData \(error.localizedDescription)")
            } else {
                // Data for "images/island.jpg" is returned
//                do{
                
                    //DECOMPRESS DATA
                    let data = datao?.decompress(withAlgorithm: .LZMA)
                    
                    let level : Level = Level.makeLevel(data: data!)!//List.fromByteArray(UnsafePointer(fbData))
                    let levelData = level.levelData
                    
                    print("GET GLS LEVEL FILE \(String(describing: level.levelData?.levelMetadata)) \(String(describing: level.levelData?.endPoints))")
                    
                    completion(levelData!)
//                }catch let error as NSError {
//                    print("Error getting file \(error.localizedDescription)")
//                }
            }
        })
    }
    
    func globalLevelSelect_getLevels(query: LevelQuery, completion: @escaping ([GLSLevelData]) -> Void){
        
        db.collection("levels").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                var lData : [GLSLevelData] = []
                var num : Int = 0
                
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    let d = document.data()
                    
                    //TODO guard lets based on query, optionals?
                    let title : String = d["Title"]! as! String
                    let creatorId : String = d["UserID"]! as! String
                    let levelUUID : String = d["LevelID"]! as! String
                    let description : String = d["Description"]! as! String
                    
                    DownloadCounter.getDownloadCountFor(uuid: levelUUID, completion: {(downloads : Int) in
                        let glsData = GLSLevelData(title: title, creatorId: creatorId, levelUUID: levelUUID, description: description, downloads: downloads)
                        lData.append(glsData)
                        num += 1
                        
                        if(querySnapshot?.count == num){
                            completion(lData)
                        }
                    })
                    
                    
                }
                
//                completion(lData)
            }
        }
    }
    
    func playSelect_pressBack() {
        switchToView(newView: View.Menu)
    }
    
    func playSelect_pressCampaign() {
        switchToView(newView: View.CampaignLevelSelect)

    }
    
    func playSelect_pressGlobalLevelSelect() {
        switchToView(newView: .GLS)
    }
    
    func playSelect_pressSavedLevelsSelect() {
        
    }
    
    func campaignLevelSelect_pressBack() {
        switchToView(newView: .PlaySelect)
    }
    
    var didPressCampaignLevel : Bool = false
    func campaignLevelSelect_pressLevel(level: LevelData) {
        currentLevel = Level(levelData: level);
        didPressCampaignLevel = true;
        switchToView(newView: .LevelPlay)
    }
    
    func level_pressMenu() {
        var t : CGFloat = transitionTime;
        
        //TOOD: do this better, no transition time ONLY if going back from level play to level create
        if(levelView.parentView == .LevelCreate){
            t = 0;
        }
        switchToView(newView: levelView.parentView, transitionTime: t)
    }
    
    func level_nextLevel(currentLevelNumber : Int) {
        //TODO get next level in a way that allows dynamic new levels from the internet
        //use LevelNumber in level metadata
        let d = CampaignLevelHandler.getLevelFromLevelNumber(levelNumber: currentLevelNumber + 1)
        if(d != nil){
            currentLevel = Level(levelData: d!)
            didPressCampaignLevel = true
            switchToView(newView: .LevelPlay, transitionTime: transitionTime, forceParentView: true, forcedParentView: .CampaignLevelSelect)
        }else{
            print("NO NEXT LEVEL")
        }
    }
    
    func createLevelSelect_pressBack() {
        switchToView(newView: .Menu)
    }
    
    func createLevelSelect_pressLevel(level: LevelData) {
        currentLevel = Level(levelData: level);
        switchToView(newView: .LevelCreate)
    }
    
    func createLevelSelect_createNew() {
        print("CREATE NEW LEVEL")
        currentLevel = Level(levelData: CreateLevelView.BlankLevel())
        switchToView(newView: .LevelCreate)
    }
    
    
    func createLevelView_pressMenu() {
        switchToView(newView: .CreateSelect)
    }
    
    func createLevelView_playLv() {
        currentLevel = Level(levelData: createLevelView.levelData)
//        levelView = LevelView(_level: Level(_levelData: createLevelView.levelData), _parentView: .LevelCreate)//, _resetToLevel: currentLevel)
//        levelView.levelViewDelegate = self;
//        self.view.addSubview(levelView)
        switchToView(newView: .LevelPlay, transitionTime: 0)
    }
    
    
    func createLevelView_publishLv(title: String, description: String, thumbnail: UIImage){
        if(account_isLoggedIn()){
            currentLevel = Level(levelData: createLevelView.levelData)
            let levelId = currentLevel.levelData?.levelMetadata?.levelUUID! ?? ""
            let userId = Auth.auth().currentUser?.uid ?? ""
            
            if(userId != ""){
                let thumbnailStoragePath = "thumb/\(levelId).jpg"
                
                let data : [String : Any] = [
                    "LevelID" : levelId,
                    "UserID" : userId, //TODO handle no user id?
                    "Title" : title,
                    "Description" : description,
                    //"Thumbnail" : thumbnailStoragePath //no need to actually store, can be remade with /{userId}/thumb/{levelUUID}.jpg
                ]
                
                
                db.collection("levels").document(levelId).setData(data, completion: {(error) in
                    print("Add document")
                    self.uploadCustomMadeFile(userId: userId, levelUUID: levelId)
                })
                
                print("uploading thumb to: \(thumbnailStoragePath)")
                uploadLevelImage(storagePath: thumbnailStoragePath, userId: userId, thumbnail: thumbnail)
            }
        }
    }
    
    func uploadLevelImage(storagePath: String, userId: String, thumbnail: UIImage){
        //test image
        
        let imageData : Data = UIImageJPEGRepresentation(thumbnail, 0.5)!.compress(withAlgorithm: .LZMA)!
        
        let storageRef = storage.reference()
        let levelRef = storageRef.child(storagePath)
        
        let metadata = StorageMetadata()
        metadata.contentType = "level/jpg"
        
        levelRef.putData(imageData)
    }
    
    func uploadCustomMadeFile(userId : String, levelUUID : String){
        let storageRef = storage.reference()

        let levelRef = storageRef.child("levels/\(levelUUID).gws")
        
        let localFile = File.getLevelPath(uuid: levelUUID, type: .UserMade)

        let metadata = StorageMetadata()
        metadata.contentType = "level/gws"

        
        // Upload the file to the path "images/rivers.jpg"
        let _ = levelRef.putFile(from: localFile, metadata: metadata) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("error uploading \(error.localizedDescription)")
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                
//                let downloadURL = metadata!.downloadURL()
//                print(downloadURL?.path)
            }
        }
        
    }
    
    
    func campaignLevelSelect_getThumbnail(uuid: String, completion: @escaping (_ img : UIImage) -> Void) {
        
    }
    
    func createLevelSelect_getThumbnail(uuid: String, completion: @escaping (_ img : UIImage) -> Void) {
         
    }
    
    func globalLevelSelect_getThumbnail(uuid : String, completion: @escaping (_ img : UIImage) -> Void){
        let storageRef = storage.reference()
        let thumbRef = storageRef.child("thumb/\(uuid).jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        thumbRef.getData(maxSize: 1 * 1024 * 1024, completion: {(datao : Data?, error : Error?) in
            if error != nil {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let data = datao?.decompress(withAlgorithm: .LZMA)
                
                let image = UIImage(data: data!)
                completion(image!)
            }
        })
    }
    
    
    //TODO async completion handlers
    func downloadLevel(){
        
    }

    
    override var prefersStatusBarHidden: Bool {
        return true;
    }
}

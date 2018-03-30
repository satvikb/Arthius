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
    case GLSSelect
    case LevelBeat
}

class ViewController: UIViewController, MenuViewDelegate, AccountViewDelegate, PlaySelectViewDelegate, CampaignLevelSelectorViewDelegate, LevelViewDelegate, CreateLevelSelectorViewDelegate, CreateLevelViewDelegate{
    
   

    var currentView : View!;
    var menuView : MenuView!;
    var accountView : AccountView!;
    var playSelectView : PlaySelectView!;
    var campaignLevelSelectView : CampaignLevelSelectView!;
    var createLevelSelectView : CreateLevelSelectView!;
    
    var levelView : LevelView!;
    var currentLevel : Level!;
    
    var createLevelView : CreateLevelView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentView = View.Splash
        
        File.copyLevelsFromBundleToDocuments()
        firebaseAuthHandler()

        menuView = MenuView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        menuView.menuDelegate = self;
        
        accountView = AccountView(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1)))
        accountView.accountDelegate = self;
        
        playSelectView = PlaySelectView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        playSelectView.playSelectDelegate = self;
        
        createLevelSelectView = CreateLevelSelectView(startPosition: CGPoint(x: 0, y: 0))
        createLevelSelectView.createLevelSelectDelegate = self;
        
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
    
    func switchToView(newView : View, transitionTime : CGFloat = transitionTime){
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
            levelView = LevelView(_level: currentLevel, _parentView: currentView)//, _resetToLevel: currentLevel)
            levelView.levelViewDelegate = self;
            levelView.animateIn()
            self.view.addSubview(levelView)
            break;
        case .PlaySelect:
            self.view.addSubview(playSelectView)
            playSelectView.animateIn(time: transitionTime)
            break;
        case .CampaignLevelSelect:
            self.view.addSubview(campaignLevelSelectView)
            campaignLevelSelectView.animateIn(time: transitionTime)
        case .CreateSelect:
            createLevelSelectView.loadLevels()
            self.view.addSubview(createLevelSelectView)
            createLevelSelectView.animateIn(time: transitionTime)
            break;
        case .LevelCreate:
            createLevelView = CreateLevelView(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1)), existingLevel: currentLevel.levelData)
            createLevelView.delegate = self;
            createLevelView.animateIn()
            self.view.addSubview(createLevelView)
            break;
        default: break
            
        }
        
        currentView = newView;
    }
//
//    func testLevel() -> Level{
//        var gWells : [GravityWellData] = []
////        gWells.append(GravityWell(corePoint: propToPoint(prop: CGPoint(x: 0.7, y: 0.5)), coreDiameter: propToFloat(prop: 0.1, scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: 0.65, scaleWithX: true), mass: 1000).data)
//        let level = Level(_metadata: LevelMetadata(levelUUID: "UUID", levelNumber: 0, levelName: "Lv 1", levelVersion: "0", levelAuthor: "Satvik Borra"), _propFrame: CGRect(x: 0, y: 0, width: 3, height: 1), _startPosition: CGPoint(x: 0, y: 0.4), _endPosition: CGRect(x: 2, y: 0.95, width: 0.1, height: 0.05), _startVelocity: CGVector(dx: 0.0025, dy: 0), _gravityWells: gWells, _colorBoxData: [], _rockData: [], _speedBoostData: [])
//
//        return level;
//    }
//
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
    
    func playSelect_pressBack() {
        switchToView(newView: View.Menu)
    }
    
    func playSelect_pressCampaign() {
        switchToView(newView: View.CampaignLevelSelect)

    }
    
    func playSelect_pressGlobalLevelSelect() {
        
    }
    
    func playSelect_pressSavedLevelsSelect() {
        
    }
    
    func campaignLevelSelect_pressBack() {
        switchToView(newView: .PlaySelect)
    }
    
    func campaignLevelSelect_pressLevel(level: LevelData) {
        currentLevel = Level(_levelData: level);
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
    
    func level_nextLevel() {
        print("NEXT LEVEL")
    }
    
    func createLevelSelect_pressBack() {
        switchToView(newView: .Menu)
    }
    
    func createLevelSelect_pressLevel(level: LevelData) {
        currentLevel = Level(_levelData: level);
        switchToView(newView: .LevelCreate)
    }
    
    func createLevelSelect_createNew() {
        print("CREATE NEW LEVEL")
        currentLevel = Level(_levelData: CreateLevelView.BlankLevel())
        switchToView(newView: .LevelCreate)
    }
    
    
    func createLevelView_pressMenu() {
        switchToView(newView: .CreateSelect)
    }
    
    func createLevelView_playLv() {
        currentLevel = Level(_levelData: createLevelView.levelData)
//        levelView = LevelView(_level: Level(_levelData: createLevelView.levelData), _parentView: .LevelCreate)//, _resetToLevel: currentLevel)
//        levelView.levelViewDelegate = self;
//        self.view.addSubview(levelView)
        switchToView(newView: .LevelPlay, transitionTime: 0)
    }
    
    
    func createLevelView_publishLv() {
        if(account_isLoggedIn()){
            currentLevel = Level(_levelData: createLevelView.levelData)
            let levelId = currentLevel.levelData.levelMetadata.levelUUID;
            let userId = Auth.auth().currentUser?.uid
            
            let data : [String : Any] = [
                "LevelID" : levelId,
                "UserID" : userId ?? "" //TODO handle no user id?
            ]
            
            db.collection("levels").addDocument(data: data, completion: {(error) in
                print("Add document")
                self.uploadCustomMadeFile(userId: userId!, levelUUID: levelId)
            })
            uploadLevelImage(userId: userId!, level: currentLevel)
        }
    }
    
    func uploadLevelImage(userId: String, level: Level){
        //test image
        
        let levelView = LevelView(_level: level, _parentView: .LevelCreate)
        let image = UIImage(view: levelView)
        let imageData : Data = UIImagePNGRepresentation(image)!
        
        let storageRef = storage.reference()
        let levelRef = storageRef.child("\(userId)/\(level.levelData.levelMetadata.levelUUID)_thumb.png")
        

        
        let metadata = StorageMetadata()
        metadata.contentType = "level/png"
        
        
        print("UPLOADING IMAGE")
        let _ = levelRef.putData(imageData, metadata: metadata) { metadata, error in
            let downloadURL = metadata?.downloadURL()
            print(downloadURL?.path)
        }
        
        // Upload the file to the path "images/rivers.jpg"
//        let _ = levelRef.putFile(from: localFile, metadata: nil) { metadata, error in
//            if let error = error {
//                // Uh-oh, an error occurred!
//                print("error uploading \(error.localizedDescription)")
//            } else {
//                // Metadata contains file metadata such as size, content-type, and download URL.
//
//                //                let downloadURL = metadata!.downloadURL()
//                //                print(downloadURL?.path)
//            }
//        }
        
    }
    
    func uploadCustomMadeFile(userId : String, levelUUID : String){
        let storageRef = storage.reference()
        
        let levelRef = storageRef.child("\(userId)/\(levelUUID).gws")
        
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
    
    override var prefersStatusBarHidden: Bool {
        return true;
    }
}

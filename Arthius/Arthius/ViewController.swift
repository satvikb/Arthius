//
//  ViewController.swift
//  Arthius
//
//  Created by Satvik Borra on 3/20/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

let transitionTime : CGFloat = 1;

enum View {
    case Splash
    case Menu
    case PlaySelect
    case CampaignLevelSelect
    case LevelPlay
    case CreateSelect
    case LevelCreate
    case LevelOver
}

class ViewController: UIViewController, MenuViewDelegate, PlaySelectViewDelegate, CampaignLevelSelectorViewDelegate, LevelViewDelegate{

    var currentView : View!;
    var menuView : MenuView!;
    var playSelectView : PlaySelectView!;
    var campaignLevelSelectView : CampaignLevelSelectView!;
    
    
    var levelView : LevelView!;
    var currentLevel : Level!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentView = View.Splash
        
        menuView = MenuView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        menuView.menuDelegate = self;
        
        playSelectView = PlaySelectView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        playSelectView.playSelectDelegate = self;
        
        
        
        // COPY ALL FILES FROM LEVELS FOLDER TO DOCUMENTS
        // DO THIS BEFORE CAMPAIGNLEVELVIEW INIT
        
        func copyFolders() {
            let filemgr = FileManager.default
//            filemgr.delegate = self
            let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
            let docsURL = dirPaths[0]
            
            let folderPath = Bundle.main.resourceURL!.appendingPathComponent("Levels").path
            let docsFolder = docsURL.appendingPathComponent(CAMPAIGN_LEVEL_FOLDER).path
            copyFiles(pathFromBundle: folderPath, pathDestDocs: docsFolder)
        }
        
        func copyFiles(pathFromBundle : String, pathDestDocs: String) {
            let fileManagerIs = FileManager.default
//            fileManagerIs.delegate = self
            
            let tempPath = fileManagerIs.temporaryDirectory.path
            
            do {
                let filelist = try fileManagerIs.contentsOfDirectory(atPath: pathFromBundle)
                try? fileManagerIs.copyItem(atPath: pathFromBundle, toPath: pathDestDocs)
                
                for filename in filelist {
                    let bundlePath = "\(pathFromBundle)/\(filename)"
                    let docPath = "\(pathDestDocs)/\(filename)";

                    if(fileManagerIs.fileExists(atPath: docPath)){
                        let docFileEqualToBundleFile = fileManagerIs.contentsEqual(atPath: docPath, andPath: bundlePath)
                        
                        if(docFileEqualToBundleFile == false){
                            let fileTemp = "\(tempPath)/\(filename)";
                            try? fileManagerIs.copyItem(atPath: bundlePath, toPath: fileTemp)
                            
                            // fileManagerIs.replaceitem(URL(string: docPath)!, withItemAt: URL(string: tempPath)!)
                            let replace = try fileManagerIs.replaceItemAt(URL(string: docPath)!, withItemAt: URL(string: fileTemp)!, backupItemName: "BU.gws", options: []);
                            if(replace != nil){
                                print("Lv \(filename) NOT equal. Replacing with original.")
                            }
                        }
                    }else{
                        try? fileManagerIs.copyItem(atPath: bundlePath, toPath: docPath)
                        print("Copying \(pathFromBundle)/\(filename) to \(pathDestDocs)/\(filename)")
                    }
                    
                }
            } catch let error as NSError{
                print("\nError \(error.localizedDescription)\n")
            }
        }
        
        
        copyFolders()
        
        
        
        campaignLevelSelectView = CampaignLevelSelectView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        campaignLevelSelectView.campaignLevelSelectDelegate = self;
        
        
        switchToView(newView: .Menu)
    }
    
    func switchToView(newView : View){
        func removeView(view: UIView, after: CGFloat){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
                view.removeFromSuperview()
            })
        }
        
        switch currentView {
        case .Menu:
            menuView.removeFromSuperview()
            break;
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
            removeView(view: levelView, after: transitionTime)
            break;
        default: break
            
        }
        
        currentView = newView;
        
        switch newView {
        case .Menu:
            self.view.addSubview(menuView);
            break;
        case .LevelPlay:
            levelView = LevelView(_level: currentLevel)//, _resetToLevel: currentLevel)
            levelView.levelViewDelegate = self;
            self.view.addSubview(levelView)
            break;
        case .PlaySelect:
            self.view.addSubview(playSelectView)
            playSelectView.animateIn(time: transitionTime)
            break;
        case .CampaignLevelSelect:
            self.view.addSubview(campaignLevelSelectView)
            campaignLevelSelectView.animateIn(time: transitionTime)
            
        default: break
            
        }
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
        //TODO, respective location
        switchToView(newView: .Menu)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true;
    }
}

//extension ViewController: MenuViewDelegate {
//    func didFinishTask(sender: ViewController) {
//        // do stuff like updating the UI
//    }
//}


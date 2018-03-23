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

class ViewController: UIViewController, MenuViewDelegate, PlaySelectViewDelegate, CampaignLevelSelectorViewDelegate{

    var currentView : View!;
    var menuView : MenuView!;
    var playSelectView : PlaySelectView!;
    var campaignLevelSelectView : CampaignLevelSelectView!;
    
    var l : Level!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
//
        currentView = View.Splash
        
        menuView = MenuView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        menuView.menuDelegate = self;
        
        playSelectView = PlaySelectView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        playSelectView.playSelectDelegate = self;
        
        
        
        // COPY ALL FILES FROM LEVELS FOLDER TO DOCUMENTS
        // DO THIS BEFORE CAMPAIGNLEVELVIEW INIT
        
        
        
        
        
        
        
        
        
        
        
        
        
        campaignLevelSelectView = CampaignLevelSelectView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        campaignLevelSelectView.campaignLevelSelectDelegate = self;
        
        
        
        
        
        
        
        
        
        do {
//            try Disk.save
//            try Disk.save(data: LevelData.archive(w: testLevel().levelData), to: .documents, as: "level.bin")
            
            if !Disk.exists("level.json", in: .documents){
                try Disk.save(testLevel().levelData, to: .documents, as: "level.json")
            }
//
            let file = "level.json" //this is the file. we will write to and read from it
//
            var text = "some text" //just a text
//
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                let fileURL = dir.appendingPathComponent(file)
//                print(filePath)

                //reading
                do {
                    text = try String(contentsOf: fileURL, encoding: .utf8)
                    print(text)
                }
                catch {/* error handling here */
                    print("read error")
                }
            }
            
            
            
            
            
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent("level.json") {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    print("FILE AVAILABLE "+filePath)
                    
                    var fileSize : UInt64
                    
                    do {
                        //return [FileAttributeKey : Any]
                        let attr = try FileManager.default.attributesOfItem(atPath: filePath)
                        fileSize = attr[FileAttributeKey.size] as! UInt64
                        
                        //if you convert to NSDictionary, you can get file size old way as well.
                        let dict = attr as NSDictionary
                        fileSize = dict.fileSize()
                        
                        print(fileSize, "bytes")
                    } catch {
                        print("Error: \(error)")
                    }
                    
                } else {
                    print("FILE NOT AVAILABLE")
                }
            } else {
                print("FILE PATH NOT AVAILABLE")
            }
            
            
        } catch let error as NSError {
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
        l = Level(_levelData: LevelData(name: "", propFrame: CGRect.zero, startPosition: CGPoint.zero, endPosition: CGRect.zero, startVelocity: CGVector.zero, gravityWells: [], colorBoxData: [], rockData: [], speedBoostData: []));
        
        do {
//            let newLData = try Disk.retrieve("level.bin", from: .documents, as: Data.self)
            let newLStruct = try Disk.retrieve("level.json", from: .documents, as: LevelData.self)
            let newL = newLStruct//LevelData.unarchive(d: newLData)
            l = Level(_levelData: newL);
            print("set l")
        } catch let error as NSError {
            print("error loading level "+error.localizedDescription)
        }
        
        
        
        
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
            
        default: break
            
        }
        
        currentView = newView;
        
        switch newView {
        case .Menu:
            self.view.addSubview(menuView);
            break;
        case .LevelPlay:
            let levelView : LevelView = LevelView(_level: l)
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
    
    func testLevel() -> Level{
        var gWells : [GravityWellData] = []
//        gWells.append(GravityWell(corePoint: propToPoint(prop: CGPoint(x: 0.7, y: 0.5)), coreDiameter: propToFloat(prop: 0.1, scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: 0.65, scaleWithX: true), mass: 1000).data)
        let level = Level(_name: "Lv 1", _propFrame: CGRect(x: 0, y: 0, width: 3, height: 1), _startPosition: CGPoint(x: 0, y: 0.4), _endPosition: CGRect(x: 2, y: 0.95, width: 0.1, height: 0.05), _startVelocity: CGVector(dx: 0.0025, dy: 0), _gravityWells: gWells, _colorBoxData: [], _rockData: [], _speedBoostData: [])
        
        return level;
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
        
    }
    
}

//extension ViewController: MenuViewDelegate {
//    func didFinishTask(sender: ViewController) {
//        // do stuff like updating the UI
//    }
//}


//
//  ViewController.swift
//  Arthius
//
//  Created by Satvik Borra on 3/20/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

let transitionTime : CGFloat = 0.1;

enum View {
    case Splash
    case Menu
    case PlaySelect
    case CampaignLevelSelect
    case LevelPlay
    case CreateSelect
    case LevelCreate
    case SavedLevelSelect
    case GLSSelect
    case LevelBeat
}

class ViewController: UIViewController, MenuViewDelegate, PlaySelectViewDelegate, CampaignLevelSelectorViewDelegate, LevelViewDelegate, CreateLevelSelectorViewDelegate, CreateLevelViewDelegate{
   

    var currentView : View!;
    var menuView : MenuView!;
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

        menuView = MenuView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        menuView.menuDelegate = self;
        
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
    
    func switchToView(newView : View, transitionTime : CGFloat = transitionTime){
        func removeView(view: UIView, after: CGFloat){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
                view.removeFromSuperview()
            })
        }
        
        switch currentView {
        case .Menu:
            menuView.animateOut()
            removeView(view: menuView, after: transitionTime)
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
            levelView.animateOut()
            removeView(view: levelView, after: transitionTime)
            break;
        case .CreateSelect:
            createLevelSelectView.animateOut(time: transitionTime)
            removeView(view: createLevelSelectView, after: transitionTime)
            break;
        case .LevelCreate:
            //TODO animate
//            createLevelView.animateOut(time: transitionTime)
            removeView(view: createLevelView, after: transitionTime)
            break;
        default: break
            
        }
        
        
        switch newView {
        case .Menu:
            self.view.addSubview(menuView);
            menuView.animateIn()
            break;
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
    
    
    func createLevelView_pressBack() {
        switchToView(newView: .CreateSelect)
    }
    
    func createLevelView_playLv() {
        currentLevel = Level(_levelData: createLevelView.levelData)
//        levelView = LevelView(_level: Level(_levelData: createLevelView.levelData), _parentView: .LevelCreate)//, _resetToLevel: currentLevel)
//        levelView.levelViewDelegate = self;
//        self.view.addSubview(levelView)
        switchToView(newView: .LevelPlay, transitionTime: 0)
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


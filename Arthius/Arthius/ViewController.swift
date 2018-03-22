//
//  ViewController.swift
//  Arthius
//
//  Created by Satvik Borra on 3/20/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

enum View {
    case Splash
    case Menu
    case LevelSelect
    case LevelPlay
    case LevelMake
    case LevelOver
}

class ViewController: UIViewController, MenuViewDelegate{

    var currentView : View!;
    var menuView : MenuView!;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentView = View.Menu//View.Splash
        
        menuView = MenuView(startPosition: propToPoint(prop: CGPoint(x: 0, y: 0)))
        menuView.menuDelegate = self;
        self.view.addSubview(menuView)
        
        let l = testLevel()
        
        do {
//            try Disk.save
            try Disk.save(l.levelData, to: .documents, as: "level.json")
            
            let file = "level.json" //this is the file. we will write to and read from it
            
            var text = "some text" //just a text
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let fileURL = dir.appendingPathComponent(file)
    
                //reading
                do {
                    text = try String(contentsOf: fileURL, encoding: .utf8)
                }
                catch {/* error handling here */
                    print("read error")
                }
            }
            print(text)
        } catch let error as NSError {
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
    }
    
    func switchToView(newView : View){
        switch currentView {
        case .Menu:
            menuView.removeFromSuperview()
        default: break
            
        }
        
        switch newView {
        case .LevelPlay:
            let levelView : LevelView = LevelView(_level: testLevel())
            self.view.addSubview(levelView)
        default: break
            
        }
    }
    
    func testLevel() -> Level{
        let gWells : [GravityWellData] = []
    //        gWells.append(GravityWell(corePoint: CGPoint(x: 0.7, y: 0.5), coreDiameter: 0.1, areaOfEffectDiameter: 0.65, mass: 1000).data)
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
    
    func menu_pressPlay(){
        switchToView(newView: View.LevelPlay)
    }
}

//extension ViewController: MenuViewDelegate {
//    func didFinishTask(sender: ViewController) {
//        // do stuff like updating the UI
//    }
//}


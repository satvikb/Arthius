//
//  ViewController.swift
//  Arthius
//
//  Created by Satvik Borra on 3/20/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var gWells : [GravityWellData] = []
//        gWells.append(GravityWell(corePoint: CGPoint(x: 0.7, y: 0.5), coreDiameter: 0.1, areaOfEffectDiameter: 0.65, mass: 1000).data)
        let level = Level(_name: "Lv 1", _propFrame: CGRect(x: 0, y: 0, width: 3, height: 1), _startPosition: CGPoint(x: 0, y: 0.4), _startVelocity: CGVector(dx: 0.0025, dy: 0), _gravityWells: gWells, _colorBoxData: [], _rockData: [], _speedBoostData: [])
        
        let levelView : LevelView = LevelView(_level: level)
        self.view.tag = 100;
        self.view.addSubview(levelView)
    }
    
    
    
    func propToRect(prop: CGRect) -> CGRect{
        let screen = UIScreen.main.bounds;
        return CGRect(x: prop.origin.x * screen.width, y: prop.origin.y * screen.height, width: screen.width*prop.width, height: screen.height*prop.height)
    }
}


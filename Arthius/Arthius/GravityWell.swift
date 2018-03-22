//
//  GravityWell.swift
//  Arthius
//
//  Created by Satvik Borra on 3/21/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class GravityWell: UIView {
    
    var coreView : UIView!;
    
    var corePoint:CGPoint!;
    var coreDiameter : CGFloat!;
    var areaOfEffectDiameter : CGFloat!;
    
    var mass : CGFloat = 100000;
    
    var touched = {}
    
    init(corePoint: CGPoint, coreDiameter: CGFloat, areaOfEffectDiameter: CGFloat, mass: CGFloat) {
        self.corePoint = corePoint;
        self.coreDiameter = coreDiameter;
        self.areaOfEffectDiameter = areaOfEffectDiameter;
        self.mass = mass;
        
        let frame = CGRect(origin: CGPoint(x: corePoint.x-areaOfEffectDiameter/2, y: corePoint.y-areaOfEffectDiameter/2), size: CGSize(width:areaOfEffectDiameter, height: areaOfEffectDiameter))
        let coreFrame = CGRect(origin: CGPoint(x: (frame.width/2)-coreDiameter/2, y: (frame.height/2)-coreDiameter/2), size: CGSize(width:coreDiameter, height: coreDiameter))

        super.init(frame: frame)
        
        self.layer.cornerRadius = areaOfEffectDiameter/2;
        
        coreView = UIView(frame: coreFrame)
        coreView.layer.cornerRadius = coreDiameter/2
        
        coreView.backgroundColor = UIColor(red: 0, green: 0.2, blue: 1, alpha: 0.7)
        self.backgroundColor = UIColor(red: 0, green: 0.2, blue: 1, alpha: 0.4)

        
        self.addSubview(coreView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(corePoint)
        touched();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension GravityWell {
    var data : GravityWellData {
        return GravityWellData(position: self.corePoint, mass: self.mass, coreDiameter: self.coreDiameter, areaOfEffectDiameter: self.areaOfEffectDiameter)
    }
}

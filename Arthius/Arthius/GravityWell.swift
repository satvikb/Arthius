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
    init(corePoint: CGPoint, coreDiameter: CGFloat, areaOfEffectDiameter: CGFloat) {
        self.corePoint = corePoint;
        self.coreDiameter = coreDiameter;
        self.areaOfEffectDiameter = areaOfEffectDiameter;
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

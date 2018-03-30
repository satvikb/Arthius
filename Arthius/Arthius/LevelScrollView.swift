//
//  LevelScrollView.swift
//  Arthius
//
//  Created by Satvik Borra on 3/24/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

//if needed use to handle custom scrolling/zooming
class LevelScrollView : UIScrollView{
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)

        if(shouldCancelTouch(result: result!)){
            self.isScrollEnabled = false;
            self.killScroll()
        }else{
            self.isScrollEnabled = true;
        }

        return super.hitTest(point, with: event)
    }
    
    func killScroll(){
        let offset = self.contentOffset;
        self.setContentOffset(offset, animated: false)
    }
    
    func shouldCancelTouch(result : UIView) -> Bool{
        let hitWell = testIfASuperViewIsType(subview: result, type: GravityWell.self)
        let hitKnob = testIfASuperViewIsType(subview: result, type: LineStart.self)

        
        return hitWell || hitKnob;
    }
    
    func testIfASuperViewIsType(subview: UIView, type : AnyClass) -> Bool{
        
        var currentView : UIView? = subview
        while currentView != nil {

            if(currentView?.isKind(of: type))!{
                return true;
            }
            currentView = currentView?.superview
        }
        return false
        
    }
    
    
}

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
        
//        UIView* result = [super hitTest:point withEvent:event];
//
//        if ([result.superview isKindOfClass:[UIPickerView class]])
//        {
//            self.scrollEnabled = NO;
//        }
//        else
//        {
//            self.scrollEnabled = YES;
//        }
//        return result;
        
        
        
        let result = super.hitTest(point, with: event)
//        print("HIT \(hitWell)")

        if(shouldCancelTouch(result: result!)){
            self.isScrollEnabled = false;
            self.killScroll()
        }else{
            self.isScrollEnabled = true;
        }
//        self.isScrollEnabled = false;

        return super.hitTest(point, with: event)// [super hitTest:point withEvent:event];
    }
    
    func killScroll(){
        let offset = self.contentOffset;
        self.setContentOffset(offset, animated: false)
    }
//    - (void)killScroll
//    {
//    CGPoint offset = scrollView.contentOffset;
//    [scrollView setContentOffset:offset animated:NO];
//    }
    
    func shouldCancelTouch(result : UIView) -> Bool{
        let hitWell = testIfASuperViewIsType(subview: result, type: GravityWell.self)
        let hitKnob = testIfASuperViewIsType(subview: result, type: LineStart.self)

        
        return hitWell || hitKnob;
    }
    
    func testIfASuperViewIsType(subview: UIView, type : AnyClass) -> Bool{
        
        var currentView : UIView? = subview
        while currentView != nil {
//            print("\(String(describing: currentView.self)) \(String(describing: currentView?.tag))")
            if(currentView?.isKind(of: type))!{
                return true;
            }
            currentView = currentView?.superview
        }
//        print("\n")

        return false
        
    }
    
    
}

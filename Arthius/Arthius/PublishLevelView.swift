//
//  PublishLevelView.swift
//  Arthius
//
//  Created by Satvik Borra on 3/30/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class PublishLevelView : UIView, UITextFieldDelegate {
    
    var publishBtnPressed = {(title : String, description : String, thumbnail : CGRect) in}
    var cancelled = {}
    
    var titleLabel : Label!;
    var thumbnailView : UIView!;
    
    var topRightSectionView : UIView!;
    var bottomView : UIView!;
    
    var cancelButton : Button!;
    var publishButton : Button!;
    
    var titleTextField : TextField!;
    var descriptionTextField : TextField!;
    
    private var levelView : LevelView!;
    
    init(frame: CGRect, level: LevelData) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        
        thumbnailView = UIView(frame: propToRect(prop: CGRect(x: 0.05, y: 0.2, width: 0.4, height: 0.275), within: self.frame))
        levelView = LevelView(_level: Level(levelData: level), _parentView: .LevelCreate)
        levelView.levelView.frame = CGRect(x: 0, y: 0, width: thumbnailView.frame.width, height: thumbnailView.frame.height)
//        levelView.levelView.delegate = self
        levelView.changeBordersBasedOnZoom = false
        levelView.levelView.minimumZoomScale = 0.1
        levelView.levelView.maximumZoomScale = 5
        levelView.stageView.layer.borderWidth = 0
        thumbnailView.addSubview(levelView.levelView)
        self.addSubview(thumbnailView)
        
        titleLabel = Label(frame: propToRect(prop: CGRect(x: 0.5, y: 0.025, width: 0.45, height: 0.1), within: self.frame), text: "Publish", _outPos: propToRect(prop: CGRect(x: 1, y: 0.05, width: 0, height: 0), within: self.frame).origin, textColor: UIColor.white, valign: VAlign.Bottom, _insets: false)
        titleLabel.font = UIFont(name: "SFProText-Heavy", size: Screen.fontSize(propFontSize: 70))
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .right
        self.addSubview(titleLabel)
        
        
        let backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        
        topRightSectionView = UIView(frame: propToRect(prop: CGRect(x: 0.5, y: 0.2, width: 0.45, height: 0.3), within: self.frame))
        topRightSectionView.backgroundColor = backgroundColor;
        self.addSubview(topRightSectionView)
        
        bottomView = UIView(frame: propToRect(prop: CGRect(x: 0.05, y: 0.5, width: 0.9, height: 0.45), within: self.frame))
        bottomView.backgroundColor = backgroundColor;
        self.addSubview(bottomView)
        
        cancelButton = Button(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 0.3, height: 0.1), within: self.frame), text: "cancel", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToRect(prop: CGRect(x: -1, y: 0.05, width: 0, height: 0), within: self.frame).origin)
        cancelButton.pressed = {
//            self.removeFromSuperview()
            self.cancelled()
        }
        self.addSubview(cancelButton)
        
        publishButton = Button(frame: propToRect(prop: CGRect(x: 0.1, y: 0.75, width: 0.8, height: 0.2), within: bottomView.frame), text: "publish", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToRect(prop: CGRect(x: -1, y: 0.05, width: 0, height: 0), within: self.frame).origin)
        publishButton.pressed = {
            
            self.publishBtnPressed(self.titleTextField.text!, self.descriptionTextField.text!, self.thumbnailFromView())
        }
        bottomView.addSubview(publishButton)
        
        
        //text fields
        titleTextField = TextField(frame: propToRect(prop: CGRect(x: 0.05, y: 0.05, width: 0.9, height: 0.2), within: topRightSectionView.frame))
        titleTextField.delegate = self;
        titleTextField.placeholder = "Title"
        titleTextField.text = "Untitled"
        topRightSectionView.addSubview(titleTextField)
        
        descriptionTextField = TextField(frame: propToRect(prop: CGRect(x: 0.05, y: 0.05, width: 0.9, height: 0.65), within: bottomView.frame))
        descriptionTextField.delegate = self;
        descriptionTextField.placeholder = "Description"
//        print("STARTING TEXT FIELD TEXT: \(descriptionTextField.text!)")
        bottomView.addSubview(descriptionTextField)
        
    }
    
    func thumbnailFromView() -> CGRect{
        let scrollView = levelView.levelView
        
        var visibleRect : CGRect = CGRect(origin: (scrollView?.contentOffset)!, size: (scrollView?.bounds.size)!);

        let theScale : CGFloat = 1.0 / (scrollView?.zoomScale)!;
        visibleRect = visibleRect * theScale;
        
        
        let prop = rectToProp(rect: visibleRect);

        print("Thumb visible: \(visibleRect)__\(prop)");
        
        return prop;
        
//        CGRect visibleRect;
//        visibleRect.origin = scrollView.contentOffset;
//        visibleRect.size = scrollView.bounds.size;
        
//        float theScale = 1.0 / scale;
//        visibleRect.origin.x *= theScale;
//        visibleRect.origin.y *= theScale;
//        visibleRect.size.width *= theScale;
//        visibleRect.size.height *= theScale;
//
        
        
//        return UIImage(view: thumbnailView)
    }
    
    func animateIn(){
        titleLabel.animateIn()
        cancelButton.animateIn()
        publishButton.animateIn()
    }
    
    func animateOut(){
        titleLabel.animateOut()
        cancelButton.animateOut()
        publishButton.animateOut()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

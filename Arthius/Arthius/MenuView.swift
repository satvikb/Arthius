//
//  MenuView.swift
//  Arthius
//
//  Created by Satvik Borra on 3/22/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol MenuViewDelegate: class {
    func menu_pressPlay()
    func menu_pressCreate()
    func menu_pressAccount()
}

class MenuView: UIView {
    
    weak var menuDelegate:MenuViewDelegate?

    var playButton : Button!;
    var createButton : Button!;
    var accountButton : Button!;
    
    init(startPosition: CGPoint){
        super.init(frame: CGRect(origin: startPosition, size: UIScreen.main.bounds.size))//CGRect.propToRect(prop: _level.levelData.propFrame, parentRect: UIScreen.main.bounds));
        
        playButton = Button(frame: propToRect(prop: CGRect(x: 0.2, y: 0.4, width: 0.6, height: 0.1)), text: "play")
        playButton.pressed = {
            self.menuDelegate?.menu_pressPlay()
        }
        self.addSubview(playButton)
        CGFloat.random
        createButton = Button(frame: propToRect(prop: CGRect(x: 0.2, y: 0.55, width: 0.6, height: 0.1)), text: "create")
        createButton.pressed = {
            self.menuDelegate?.menu_pressCreate()
        }
        self.addSubview(createButton)
        
        accountButton = Button(frame: propToRect(prop: CGRect(x: 0.2, y: 0.7, width: 0.6, height: 0.1)), text: "account")
        accountButton.pressed = {
            self.menuDelegate?.menu_pressAccount()
        }
        self.addSubview(accountButton)
    }
    
    func animateIn(){
        playButton.animateIn()
        createButton.animateIn()
        accountButton.animateIn()
    }
    
    func animateOut(){
        playButton.animateOut()
        createButton.animateOut()
        accountButton.animateOut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

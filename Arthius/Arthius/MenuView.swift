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
}

class MenuView: UIView {
    
    weak var menuDelegate:MenuViewDelegate?

    init(startPosition: CGPoint){
        super.init(frame: CGRect(origin: startPosition, size: UIScreen.main.bounds.size))//CGRect.propToRect(prop: _level.levelData.propFrame, parentRect: UIScreen.main.bounds));
        
        let playButton = Button(propFrame: CGRect(x: 0.2, y: 0.4, width: 0.6, height: 0.1), text: "play")
        playButton.pressed = {
            self.menuDelegate?.menu_pressPlay()
        }
        self.addSubview(playButton)
        
        let createButton = Button(propFrame: CGRect(x: 0.2, y: 0.55, width: 0.6, height: 0.1), text: "create")
        createButton.pressed = {
            self.menuDelegate?.menu_pressCreate()
        }
        self.addSubview(createButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

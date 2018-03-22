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
}

class MenuView: UIView {
    
    weak var menuDelegate:MenuViewDelegate?

    init(startPosition: CGPoint){
        super.init(frame: CGRect(origin: startPosition, size: UIScreen.main.bounds.size))//CGRect.propToRect(prop: _level.levelData.propFrame, parentRect: UIScreen.main.bounds));
        
        let button = Button(propFrame: CGRect(x: 0.4, y: 0.5, width: 0.2, height: 0.1), text: "play")
        button.pressed = {
            self.menuDelegate?.menu_pressPlay()
        }
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

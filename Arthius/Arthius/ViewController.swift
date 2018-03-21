//
//  ViewController.swift
//  Arthius
//
//  Created by Satvik Borra on 3/20/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var lastPoint: CGPoint!
    
    var gravityPoint: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 230)
    var radiusOfEffect : CGFloat = 200
    
    var movingAngle: CGFloat = CGFloat.pi/2
    var orbitVelocity: CGVector! = CGVector(dx: 0, dy: 0);
    
    private var buffer: UIImage?
    var displayLink : CADisplayLink!

    var gWell:UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lastPoint = CGPoint(x: 220, y: UIScreen.main.bounds.size.height/2)
        
        //todo offset gravity point for radius
        gWell = UIView(frame: CGRect(origin: CGPoint(x: gravityPoint.x-radiusOfEffect/2, y: gravityPoint.y-radiusOfEffect/2), size: CGSize(width:radiusOfEffect, height: radiusOfEffect)))
        gWell.layer.cornerRadius = radiusOfEffect/2;
        gWell.backgroundColor = UIColor(red: 0, green: 0.2, blue: 1, alpha: 0.4)
        self.view.addSubview(gWell)
        
        start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func drawLine(a: CGPoint, b: CGPoint, buffer: UIImage?) -> UIImage {
        let size = self.view.bounds.size
        
        // Initialize a full size image. Opaque because we don't need to draw over anything. Will be more performant.
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor)
        context?.fill(self.view.bounds);
        // Draw previous buffer first
        if let buffer = buffer {
            buffer.draw(in: self.view.bounds)
        }
        
        // Draw the line
        
        UIColor.blue.setStroke()
        context?.setLineWidth(8);
        context?.setLineCap(CGLineCap.round)
        context?.move(to: a);
        context?.addLine(to: b);
        context?.strokePath()
        // Grab the updated buffer
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func newMoveLocation(p: CGPoint){
        self.buffer = self.drawLine(a: self.lastPoint, b: p, buffer: self.buffer)
        
        // 3. Replace the layer contents with the updated image
        self.view.layer.contents = self.buffer?.cgImage ?? nil
        self.lastPoint = p;
    }

    
    @objc func update(){
//        containerView.newMoveLocation(p: CGPoint(x: containerView.lastPoint.x, y: containerView.lastPoint.y+1));
        
        
        
//        newMoveLocation(p: CGPoint(x: lastPoint.x+orbitVelocity.dx, y: lastPoint.y+1+orbitVelocity.dy))

        
        
//        let g = 6.6726e-11
//        let em = 5.98e17
//        let r = 6.38e6
//
//        var v : CGFloat;
        
//        movingAngle += CGFloat.random(min: -0.1, max: 0.05);
        let distFromGravityCenter = distance(a: lastPoint, b: gWell.center)
//        if(distFromGravityCenter < radiusOfEffect/2){
//            print(distFromGravityCenter)
            
           
//            v = CGFloat(sqrt((g*em)/r))
//            print(v)
            
            var targetAngle = (atan2(gWell.center.y - lastPoint.y, gWell.center.x - lastPoint.x)) + CGFloat.pi// * (180 / CGFloat.pi));
            print(targetAngle, movingAngle)
            movingAngle += (targetAngle - movingAngle)*0.01
//            var new = (movingAngle * 180) / CGFloat.pi
//
//            if(new < 0){
////                new = 360.0+new;
//            }
//
//            if(new < targetAngle){
//                new += 1;
//                movingAngle += (new * CGFloat.pi) / 180;
//            }
//
//            if(new >= targetAngle){
//                new -= 1;
//                movingAngle -= (new * CGFloat.pi) / 180;
//            }
            
//            print(targetAngle, new)
            
//            var c = CGFloat(distFromGravityCenter/10000);
//            var s1 = gWell.center.x > lastPoint.x ? 1 : -1
//            var s2 = gWell.center.y > lastPoint.y ? 1 : 1
//            var sf = CGFloat(s1 * s2);
//            c *= sf;
//
//            movingAngle += c;
            
//            var anchorAngle = movingAngle;
//            if(gWell.center.x > lastPoint.x){
//                anchorAngle += CGFloat.pi/2;
//                movingAngle += distFromGravityCenter/10000
//            }else{
//                anchorAngle -= CGFloat.pi/2;
//                movingAngle -= distFromGravityCenter/10000
//            }
//        }

//        print(v)
        var speed : CGFloat = 1;
        newMoveLocation(p: CGPoint(x: lastPoint.x+(cos(movingAngle+CGFloat.pi)*speed), y: lastPoint.y+(sin(movingAngle+CGFloat.pi)*speed)))
    }
    
    func distance(a: CGPoint, b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
    
    func start() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    func stop() {
        displayLink.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        displayLink = nil
    }
}

public extension Float {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}

public extension CGFloat {
    
    /// Randomly returns either 1.0 or -1.0.
    public static var randomSign: CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: CGFloat {
        return CGFloat(Float.random)
    }
    
    /// Random CGFloat between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random CGFloat point number between 0 and n max
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
}



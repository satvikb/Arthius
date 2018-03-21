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
    
//    var movingAngle: CGFloat = CGFloat.pi/2
//    var orbitVelocity: CGVector! = CGVector(dx: 0, dy: 0);
    var lineVelocity: CGVector! = CGVector(dx: 0, dy: -8);
    
    private var buffer: UIImage?
    var displayLink : CADisplayLink!

    var gWell:UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lastPoint = CGPoint(x: 120, y: UIScreen.main.bounds.size.height)
        
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
//        newMoveLocation(p: CGPoint(x: lastPoint.x+orbitVelocity.dx, y: lastPoint.y+1+orbitVelocity.dy))

        let distFromGravityCenter = distance(a: lastPoint, b: gWell.center)
        if(distFromGravityCenter < radiusOfEffect/2){
//            print(distFromGravityCenter)
        
            //gravRigid = line
            //transform = grav field
            
            let offset = gWell.center - lastPoint;
            let offsetVector = CGVector(dx: offset.x, dy: offset.y)
            //        Vector3 objectOffset = transform.position - gravRigidBody.transform.position; // Get the object's 2d offset relative to this World Body
            //        objectOffset.z = 0;
            
            //        Vector3 objectTrajectory = gravRigidBody.velocity; // Get object's trajectory vector
            
            //        float angle = Vector3.Angle (objectOffset, objectTrajectory); // Calculate object's angle of attack ( Not used here, but potentially insteresting to have )
            
            //        float magsqr = objectOffset.sqrMagnitude; // Square Magnitude of the object's offset
            
            let magsqr : CGFloat = sqrt(CGVectorDotProduct(vector1: offsetVector, vector2: offsetVector))
            
            if ( magsqr > 0.0001 ) { // If object's force is significant
                
                // Apply gravitational force to the object - pemdas
                let gravityVector : CGVector = (CGVectorMultiplyByScalar(vector: CGVectorNormalize(vector: offsetVector), value: 10) / magsqr ) * 2000;
                //            gravRigidBody.AddForce ( gravityVector * ( orbitalDistance/proximityModifier) );
                let change = (gravityVector * (distFromGravityCenter / 10000.0));
                var v = CGVector(dx: lineVelocity.dx, dy: lineVelocity.dy);
                v += change;
                lineVelocity = v;
            }
            
        }

        
        let deltaVel = lineVelocity!// * CGFloat(displayLink.duration)
        let pos = lastPoint + CGPoint(x: deltaVel.dx, y: deltaVel.dy);
        newMoveLocation(p: pos);
//        newMoveLocation(p: CGPoint(x: lastPoint.x+(cos(movingAngle+CGFloat.pi)*speed), y: lastPoint.y+(sin(movingAngle+CGFloat.pi)*speed)))
    }
    
    func CGVectorDotProduct(vector1 : CGVector, vector2 : CGVector) -> CGFloat{
        return vector1.dx * vector2.dx + vector1.dy * vector2.dy;
    }
    
    func CGVectorLength(vector : CGVector) -> Float
    {
        return hypotf(Float(vector.dx), Float(vector.dy));
    }

    
    func CGVectorMultiplyByScalar(vector : CGVector, value : CGFloat) -> CGVector{
        return CGVector(dx: vector.dx * value, dy: vector.dy * value);
    }
    
    func CGVectorNormalize(vector : CGVector) -> CGVector {
        let length : CGFloat = CGFloat(CGVectorLength(vector: vector));
        
        if (length == 0) {
            return CGVector.zero
        }
        
        let scale : CGFloat = 1.0 / length;
        return CGVectorMultiplyByScalar(vector: vector, value: scale);
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

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
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

public extension CGVector{
    /**
     * Adds two CGVector values and returns the result as a new CGVector.
     */
    static public func + (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }
    
    /**
     * Increments a CGVector with the value of another.
     */
    static public func += (left: inout CGVector, right: CGVector) {
        left = left + right
    }
    
    /**
     * Subtracts two CGVector values and returns the result as a new CGVector.
     */
    static public func - (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
    }
    
    /**
     * Decrements a CGVector with the value of another.
     */
    static public func -= (left: inout CGVector, right: CGVector) {
        left = left - right
    }
    
    /**
     * Multiplies two CGVector values and returns the result as a new CGVector.
     */
    static public func * (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
    }
    
    /**
     * Multiplies a CGVector with another.
     */
    static public func *= (left: inout CGVector, right: CGVector) {
        left = left * right
    }
    
    /**
     * Multiplies the x and y fields of a CGVector with the same scalar value and
     * returns the result as a new CGVector.
     */
    static public func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }
    
    /**
     * Multiplies the x and y fields of a CGVector with the same scalar value.
     */
    static public func *= (vector: inout CGVector, scalar: CGFloat) {
        vector = vector * scalar
    }
    
    /**
     * Divides two CGVector values and returns the result as a new CGVector.
     */
    static public func / (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
    }
    
    /**
     * Divides a CGVector by another.
     */
    static public func /= (left: inout CGVector, right: CGVector) {
        left = left / right
    }
    
    /**
     * Divides the dx and dy fields of a CGVector by the same scalar value and
     * returns the result as a new CGVector.
     */
    static public func / (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
    }
    
    /**
     * Divides the dx and dy fields of a CGVector by the same scalar value.
     */
    static public func /= (vector: inout CGVector, scalar: CGFloat) {
        vector = vector / scalar
    }
    

}

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
    
    
    var gravityWells : [GravityWell]! = []
    
    var lineVelocity: CGVector! = CGVector(dx: 0, dy: -1);
    var tempLineForces : CGVector! = CGVector.zero;
    var lineMass : CGFloat = 1; //no effect for now?
    let G : CGFloat = 1;
        
    private var buffer: UIImage?
    var displayLink : CADisplayLink!
    
    
    var testLine : UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lastPoint = CGPoint(x: 120, y: UIScreen.main.bounds.size.height)

        createGravityWell(point: CGPoint(x: UIScreen.main.bounds.size.width/2, y: 230), core: 40, areaOfEffectDiameter: 200, mass: 40)
        createGravityWell(point: CGPoint(x: UIScreen.main.bounds.size.width/5, y: 230), core: 40, areaOfEffectDiameter: 300, mass: 200)
        createGravityWell(point: CGPoint(x: UIScreen.main.bounds.size.width/2+40, y: 450), core: 40, areaOfEffectDiameter: 240, mass: 300)

        testLine = UIView(frame: CGRect(x: 40, y: 200, width: 50, height: 10));
        testLine.backgroundColor = UIColor.blue
        self.view.addSubview(testLine)
        
        start()
    }

    func createGravityWell(point: CGPoint, core: CGFloat, areaOfEffectDiameter: CGFloat, mass: CGFloat){
        let newWell = GravityWell(corePoint: point, coreDiameter: core, areaOfEffectDiameter: areaOfEffectDiameter)
        newWell.mass = mass;
        self.view.addSubview(newWell)
        gravityWells.append(newWell)
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
//        let distFromGravityCenter = distance(a: lastPoint, b: gWell.center)
//        if(distFromGravityCenter < gWell.areaOfEffectDiameter/2){
////            print(distFromGravityCenter)
//
//            //gravRigid = line
//            //transform = grav field
//
//            let offset = gWell.center - lastPoint;
//            let offsetVector = CGVector(dx: offset.x, dy: offset.y)
//            //        Vector3 objectOffset = transform.position - gravRigidBody.transform.position; // Get the object's 2d offset relative to this World Body
//            //        objectOffset.z = 0;
//
//            //        Vector3 objectTrajectory = gravRigidBody.velocity; // Get object's trajectory vector
//
//            //        float angle = Vector3.Angle (objectOffset, objectTrajectory); // Calculate object's angle of attack ( Not used here, but potentially insteresting to have )
//
//            //        float magsqr = objectOffset.sqrMagnitude; // Square Magnitude of the object's offset
//
//            let magsqr : CGFloat = sqrt(CGVectorDotProduct(vector1: offsetVector, vector2: offsetVector))
//
//            if ( magsqr > 0.0001 ) { // If object's force is significant
//
//                // Apply gravitational force to the object - pemdas
//                let gravityVector : CGVector = ((CGVectorNormalize(vector: offsetVector) * 10) / magsqr ) * 2000;
//                //            gravRigidBody.AddForce ( gravityVector * ( orbitalDistance/proximityModifier) );
//                let change = (gravityVector * (distFromGravityCenter / 10000.0));
//                var v = CGVector(dx: lineVelocity.dx, dy: lineVelocity.dy);
//                v += change;
//                lineVelocity = v;
//            }
//
//        }
//
//
//        let deltaVel = lineVelocity!// * CGFloat(displayLink.duration)
//        let pos = lastPoint + CGPoint(x: deltaVel.dx, y: deltaVel.dy);
//        newMoveLocation(p: pos);
        
        tempLineForces = CGVector.zero;
        
        for gravWell in gravityWells{
            let distFromGravityCenter = distance(a: lastPoint, b: gravWell.center)
            if(distFromGravityCenter < gravWell.areaOfEffectDiameter/2){
////                let v = sqrt( G * gravWell.mass / (gravWell.areaOfEffectDiameter/2) )
                let f = (G * gravWell.mass * lineMass) / (distFromGravityCenter*distFromGravityCenter)
                
                
                let p2 = gravWell.center;
                let p1 = lastPoint!;
                let angleRad = atan2(p2.y - p1.y, p2.x - p1.x)// * 180 / CGFloat.pi;
//                testLine.transform = CGAffineTransform(rotationAngle: angleDeg * CGFloat.pi/180);
                
//                tempLineForces += f
                let fx = f*cos(angleRad)
                let fy = f*sin(angleRad)
//                var v = CGVector(dx: tempLineForces.dx, dy: tempLineForces.dy);
//                v += CGVector(dx: fx, dy: fy)
                tempLineForces = tempLineForces + (CGVector(dx: fx, dy: fy))
                print(fx, fy, f, lineVelocity, distFromGravityCenter, tempLineForces)
            }
            
        }
        
        //pemdas
        let dV = (tempLineForces * CGFloat(displayLink.duration)) / lineMass
//        calculate velocity change dV for this timestep using Ft / m.
//        v = v + dV.
        lineVelocity = lineVelocity + dV
        
        
        let deltaVel = lineVelocity!// * CGFloat(displayLink.duration)
        let pos = lastPoint + CGPoint(x: deltaVel.dx, y: deltaVel.dy);
        newMoveLocation(p: pos);
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

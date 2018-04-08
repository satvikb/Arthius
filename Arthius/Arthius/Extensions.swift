//
//  Extensions.swift
//  Arthius
//
//  Created by Satvik Borra on 3/21/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func *(lhs: CGFloat, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
}

public func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

public extension CGPoint {
    public func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
}

public extension UIView {
    public func propToPoint(prop: CGPoint) -> CGPoint {
        return CGPoint(x: propToFloat(prop: prop.x, scaleWithX: true), y: propToFloat(prop: prop.y, scaleWithX: false))
    }
    
    public func propToVector(prop: CGVector) -> CGVector {
        return CGVector(dx: propToFloat(prop: prop.dx, scaleWithX: true), dy: propToFloat(prop: prop.dy, scaleWithX: false))
    }
    
    public func propToFloat(prop: CGFloat, scaleWithX: Bool) -> CGFloat{
        let screen = UIScreen.main.bounds;
        return scaleWithX == true ? prop * screen.width : prop * screen.height;
    }
    
    public func propToRect(prop: CGRect) -> CGRect{
        let screen = UIScreen.main.bounds;
        return CGRect(x: prop.origin.x * screen.width, y: prop.origin.y * screen.height, width: screen.width*prop.width, height: screen.height*prop.height)
    }
    
    public func propToRect(prop: CGRect, within: CGRect) -> CGRect{
        let screen = within;
        return CGRect(x: prop.origin.x * screen.width, y: prop.origin.y * screen.height, width: screen.width*prop.width, height: screen.height*prop.height)
    }
    
    
    
    public func pointToProp(point: CGPoint) -> CGPoint {
        return CGPoint(x: floatToProp(float: point.x, scaleWithX: true), y: floatToProp(float: point.y, scaleWithX: false))
    }
    
    public func pointToVector(vector: CGVector) -> CGVector {
        return CGVector(dx: floatToProp(float: vector.dx, scaleWithX: true), dy: floatToProp(float: vector.dy, scaleWithX: false))
    }
    
    public func floatToProp(float: CGFloat, scaleWithX: Bool) -> CGFloat{
        let screen = UIScreen.main.bounds;
        return scaleWithX == true ? float / screen.width : float / screen.height;
    }
    
    public func rectToProp(rect: CGRect) -> CGRect{
        let screen = UIScreen.main.bounds;
        return CGRect(x: rect.origin.x / screen.width, y: rect.origin.y / screen.height, width: rect.width / screen.width, height: rect.height / screen.height)
    }

    public func pointInRect(locInMain : CGPoint, view : UIView) -> Bool{
        let locInSub = self.convert(locInMain, from: view)
        
        if(self.bounds.contains(locInSub)){
            return true
        }
        return false;
    }
}


public extension CGRect {
    public static func propToRect(prop:CGRect, parentRect: CGRect) -> CGRect {
        return CGRect(x: parentRect.size.width * prop.origin.x, y: parentRect.size.height * prop.origin.y, width: parentRect.size.width * prop.size.width, height: parentRect.size.width * prop.size.height)
    }
}

extension UIColor {
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        guard let components = self.cgColor.components else { return nil }
        
        return (
            red: components[0],
            green: components[1],
            blue: components[2],
            alpha: components[3]
        )
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

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
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
    
    public func length() -> CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
    
    /**
     * Normalizes the vector described by the CGVector to length 1.0 and returns
     * the result as a new CGVector.
     public  */
    public func normalized() -> CGVector {
        let len = length()
        return len>0 ? self / len : CGVector.zero
    }
}

func ==(lh:LineData, rh:LineData) -> Bool{
    return lh.startColor == rh.startColor && lh.startPosition == rh.startPosition && lh.startThickness == rh.startThickness && lh.startVelocity == rh.startVelocity
}

func ==(lh:ColorBoxData, rh:ColorBoxData) -> Bool{
    return lh.backgroundColor == rh.backgroundColor && lh.frame == rh.frame && lh.leftColor == rh.leftColor && lh.middlePropWidth == rh.middlePropWidth && lh.rightColor == rh.rightColor && lh.rotation == rh.rotation
}

public extension Color {
    func uiColor() -> UIColor{
        return UIColor(red: CGFloat(self.r), green: CGFloat(self.g), blue: CGFloat(self.b), alpha: CGFloat(self.a))
    }
}

public extension Rect {
    var cgRect : CGRect {
        return CGRect(x: CGFloat(self.x), y: CGFloat(self.y), width: CGFloat(self.width), height: CGFloat(self.height))
    }
}

public extension Vector {
    var cgVector : CGVector {
        return CGVector(dx: CGFloat(self.dx), dy: CGFloat(self.dy))
    }
}

public extension Point {
    var cgPoint : CGPoint {
        return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
    }
}


public extension CGRect {
    var rect : Rect {
        return Rect(x: Float32(self.origin.x), y: Float32(self.origin.y), width: Float32(self.width), height: Float32(self.height))
//        return CGRect(x: CGFloat(self.x), y: CGFloat(self.y), width: CGFloat(self.width), height: CGFloat(self.height))
    }
}

public extension CGVector {
    var vector : Vector {
        return Vector(dx: Float32(self.dx), dy: Float32(self.dy))
    }
}

public extension CGPoint {
    var point : Point {
        return Point(x: Float32(self.x), y: Float32(self.y))
    }
}


extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

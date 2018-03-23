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
}


public extension CGRect {
    public static func propToRect(prop:CGRect, parentRect: CGRect) -> CGRect {
        return CGRect(x: parentRect.size.width * prop.origin.x, y: parentRect.size.height * prop.origin.y, width: parentRect.size.width * prop.size.width, height: parentRect.size.width * prop.size.height)
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

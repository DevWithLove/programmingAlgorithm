//
//  Drawing.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 21/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

extension UIView {
    
    // Drawing arcs using CGContextAddArcToPoint API
    func createRoundedRectPath(for rect: CGRect, radius: CGFloat) -> CGMutablePath {
        let path = CGMutablePath()
        
        // Move to the center of the top line segment
        let midTopPoint = CGPoint(x: rect.midX, y: rect.minY)
        path.move(to: midTopPoint)
        
        // Declare each corner as a local constant
        let topRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let topLeftPoint = CGPoint(x: rect.minX, y: rect.minY)
        
        // Add each arch to the path
        path.addArc(tangent1End: topRightPoint,
                    tangent2End: bottomRightPoint,
                    radius: radius)
        
        path.addArc(tangent1End: bottomRightPoint,
                    tangent2End: bottomLeftPoint,
                    radius: radius)
        
        path.addArc(tangent1End: bottomLeftPoint,
                    tangent2End: topLeftPoint,
                    radius: radius)
        
        path.addArc(tangent1End: topLeftPoint,
                    tangent2End: topRightPoint,
                    radius: radius)
        
        // you cnnect the ending point of the arc with the starting point
        path.closeSubpath()
        return path
    }
    
    func drawLinearGradient(
        context: CGContext, rect: CGRect, startColor: CGColor, endColor: CGColor) {
        // The first thing you need is to get a color space that you’ll use to draw the gradient.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //Next, you set up an array that tracks the location of each color within the range of the gradient. A value of 0 means the start of the gradient, 1 means the end of the gradient. You only have two colors, and you want the first to be at the start and the second to be at the end, so you pass in 0 and 1.
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // you create an array with the colors that you passed into your function. You use a plain old array here for convenience, but you need to cast it as a CFArray, since that’s what the API requires.
        let colors: CFArray = [startColor, endColor] as CFArray
        
        // Then you create your gradient
        let gradient = CGGradient(
            colorsSpace: colorSpace, colors: colors, locations: colorLocations)!
        
        //  calculate the start and end point where you want to draw the gradient. You just set this as a line from the “top middle” to the “bottom middle” of the rectangle.
        let startPoint = CGPoint(x: rect.midX, y: rect.minY)
        let endPoint = CGPoint(x: rect.midX, y: rect.maxY)
        
        context.saveGState()
        
        // You add your rectangle to the context.
        context.addRect(rect)
        // Clip to that region.
        context.clip()
        
        context.drawLinearGradient(
            gradient, start: startPoint, end: endPoint, options: [])
        
        /*
         So what’s this stuff about saveGState()/restoreGState() all about?
         
         Well, Core Graphics is a state machine. You configure a set of states you want, such as colors and line thickness, and then perform actions to actually draw them. That means that once you’ve set something, it stays that way until you change it back.
         */
        
        context.restoreGState()
    }
    
    func drawGlossAndGradient(
        context: CGContext, rect: CGRect, startColor: CGColor, endColor: CGColor) {
        
        // 1
        drawLinearGradient(
            context: context, rect: rect, startColor: startColor, endColor: endColor)
        
        let glossColor1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.35)
        let glossColor2 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
        
        let topHalf = CGRect(origin: rect.origin,
                             size: CGSize(width: rect.width, height: rect.height/2))
        
        drawLinearGradient(context: context, rect: topHalf,
                           startColor: glossColor1.cgColor, endColor: glossColor2.cgColor)
    }
    
}


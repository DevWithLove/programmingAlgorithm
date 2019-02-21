//
//  CoolButton.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 21/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

/*
 https://www.raywenderlich.com/216251-core-graphics-how-to-make-a-glossy-button?utm_campaign=rw-weekly-issue-205&utm_medium=email&utm_source=rw-weekly
*/


class CoolButton: UIButton {
    var hue: CGFloat {
        didSet {
            /*
             When the properties are set, you trigger a call to setNeedsDisplay to force your UIButton to redraw the button when the user changes its color.
             */
            setNeedsDisplay()
        }
    }
    
    var saturation: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var brightness: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hue = 0.5
        self.saturation = 0.5
        self.brightness = 0.5
        
        super.init(coder: aDecoder)
        
        self.isOpaque = false
        self.backgroundColor = .clear
    }
    
    @objc func hesitateUpdate() {
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        setNeedsDisplay()
        
        perform(#selector(hesitateUpdate), with: nil, afterDelay: 0.1)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setNeedsDisplay()
        
        perform(#selector(hesitateUpdate), with: nil, afterDelay: 0.1)
    }

    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        var actualBrightness = brightness
        
        if state == .highlighted {
            actualBrightness -= 0.1
        }

        
        // 1
        let outerColor = UIColor(
            hue: hue, saturation: saturation, brightness: actualBrightness, alpha: 1.0)
        let shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        
        /*
         Then you use insetBy(dx:dy:) to get a slightly smaller rectangle (5 pixels on each side) where you’ll draw the rounded rect. You’ve made it smaller so that you’ll have space to draw a shadow on the outside.
         */
        let outerMargin: CGFloat = 5.0
        let outerRect = rect.insetBy(dx: outerMargin, dy: outerMargin)
        
        // to create a path for your rounded rect.
        let outerPath = createRoundedRectPath(for: outerRect, radius: 6.0)
        
        // you set the fill color and shadow, add the path to your context and call fillPath() to fill it with your current color.
        if state != .highlighted {
            context.saveGState()
            context.setFillColor(outerColor.cgColor)
            context.setShadow(offset: CGSize(width: 0, height: 2),
                              blur: 3.0, color: shadowColor.cgColor)
            context.addPath(outerPath)
            context.fillPath()
            context.restoreGState()
        }
        
        // Outer Path Gradient:
        // 1
        let outerTop = UIColor(hue: hue, saturation: saturation,
                               brightness: actualBrightness, alpha: 1.0)
        let outerBottom = UIColor(hue: hue, saturation: saturation,
                                  brightness: actualBrightness * 0.8, alpha: 1.0)
        
        // 2
        context.saveGState()
        context.addPath(outerPath)
        context.clip()
//        drawLinearGradient(context: context, rect: outerRect,
//                           startColor: outerTop.cgColor, endColor: outerBottom.cgColor)
//
        drawGlossAndGradient(context: context, rect: outerRect,
                             startColor: outerTop.cgColor, endColor: outerBottom.cgColor)
        context.restoreGState()
        
        //To create a bevel-type effect
        // 1: Inner Colors
        let innerTop = UIColor(
            hue: hue, saturation: saturation, brightness: actualBrightness * 0.9, alpha: 1.0)
        let innerBottom = UIColor(
            hue: hue, saturation: saturation, brightness: actualBrightness * 0.7, alpha: 1.0)
        
        // 2: Inner Path
        let innerMargin: CGFloat = 3.0
        let innerRect = outerRect.insetBy(dx: innerMargin, dy: innerMargin)
        let innerPath = createRoundedRectPath(for: innerRect, radius: 6.0)
        
        // 3: Draw Inner Path Gloss and Gradient
        context.saveGState()
        context.addPath(innerPath)
        context.clip()
        drawGlossAndGradient(context: context,
                             rect: innerRect, startColor: innerTop.cgColor, endColor: innerBottom.cgColor)
        context.restoreGState()


    }
}

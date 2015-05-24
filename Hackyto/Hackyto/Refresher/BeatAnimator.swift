//
// BeatAnimator.swift
//
// Copyright (c) 2014 Josip Cavar
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Refresher
import QuartzCore

class BeatAnimator: PullToRefreshViewAnimator {
    
    private var layerLoader: CAShapeLayer = CAShapeLayer()
    
    init() {
        
        layerLoader.lineWidth = 4
        layerLoader.strokeColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1).CGColor
        layerLoader.strokeEnd = 0
    }
    
    func startAnimation() {
        
        var pathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimationEnd.duration = 0.5
        pathAnimationEnd.repeatCount = 100
        pathAnimationEnd.autoreverses = true
        pathAnimationEnd.fromValue = 1
        pathAnimationEnd.toValue = 0.8
        self.layerLoader.addAnimation(pathAnimationEnd, forKey: "strokeEndAnimation")
        
        var pathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
        pathAnimationStart.duration = 0.5
        pathAnimationStart.repeatCount = 100
        pathAnimationStart.autoreverses = true
        pathAnimationStart.fromValue = 0
        pathAnimationStart.toValue = 0.2
        self.layerLoader.addAnimation(pathAnimationStart, forKey: "strokeStartAnimation")
    }
    
    func stopAnimation() {
        
        self.layerLoader.removeAllAnimations()
    }
    
    func layoutLayers(superview: UIView) {
        
        if layerLoader.superlayer == nil {
            superview.layer.addSublayer(layerLoader)
        }

        var bezierPathLoader = UIBezierPath()
        bezierPathLoader.moveToPoint(CGPointMake(0, superview.frame.height - 3))
        bezierPathLoader.addLineToPoint(CGPoint(x: superview.frame.width, y: superview.frame.height - 3))

        layerLoader.path = bezierPathLoader.CGPath
    }
    
    func changeProgress(progress: CGFloat) {
        
        self.layerLoader.strokeEnd = progress
    }
}
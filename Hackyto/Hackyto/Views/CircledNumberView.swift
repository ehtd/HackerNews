//
//  CircleView.swift
//  Hackyto
//
//  Created by Ernesto Torres on 12/30/15.
//  Copyright © 2015 ehtd. All rights reserved.
//

import UIKit

@IBDesignable
class CircledNumberView: UIView {

    @IBInspectable var number: String = "0" {
        didSet {
            self.numberLabel?.text = self.number
        }
    }
    
    @IBInspectable var colorNumber: Int = 0

    var circleView: UIView?
    var numberLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        createAndConfigure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createAndConfigure()
    }

    func createAndConfigure() {
        self.circleView = UIView()
        self.numberLabel = UILabel()

        configureCircleView()
        configureNumberLabel()
        attachSubviews()
        configureNumberLabel()
        configureLayout()
    }

    func configureCircleView() {
        self.circleView?.backgroundColor = ColorFactory.colorFromNumber(colorNumber)
    }

    func configureNumberLabel() {
        self.numberLabel?.textColor = ColorFactory.colorFromNumber(colorNumber)
        self.numberLabel?.textColor = UIColor.whiteColor()
        self.numberLabel?.adjustsFontSizeToFitWidth = true
        self.numberLabel?.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 300)
        self.numberLabel?.text = self.number
        self.numberLabel?.textAlignment = NSTextAlignment.Center
        self.numberLabel?.numberOfLines = 0
    }

    func attachSubviews() {
        guard let circleView = self.circleView, numberLabel = self.numberLabel else { return }
        self.addSubview(circleView)
        self.addSubview(numberLabel)
    }

    func configureLayout() {
        guard let circleView = self.circleView, numberLabel = self.numberLabel else { return }

        circleView.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false

        // Circle constraints
        self.addConstraint(NSLayoutConstraint(item: circleView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: circleView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: circleView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: circleView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: circleView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0.0))

        // Label constraints
        self.addConstraint(NSLayoutConstraint(item: numberLabel,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: circleView,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.7,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: numberLabel,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: circleView,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.7,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: numberLabel,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: circleView,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: numberLabel,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: circleView,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: 0.0))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let circleView = self.circleView else { return }
        circleView.layer.cornerRadius = self.frame.height / 2.0
    }
}

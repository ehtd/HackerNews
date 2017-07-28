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
    
    @IBInspectable var colorNumber: Int = 0 {
        didSet {
            self.circleView?.backgroundColor = ColorFactory.colorFromNumber(colorNumber)
        }
    }

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
        self.numberLabel?.textColor = UIColor.white
        self.numberLabel?.adjustsFontSizeToFitWidth = true
        self.numberLabel?.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 300)
        self.numberLabel?.text = self.number
        self.numberLabel?.textAlignment = NSTextAlignment.center
        self.numberLabel?.numberOfLines = 0
    }

    func attachSubviews() {
        guard let circleView = self.circleView, let numberLabel = self.numberLabel else { return }
        self.addSubview(circleView)
        self.addSubview(numberLabel)
    }

    func configureLayout() {
        guard let circleView = self.circleView, let numberLabel = self.numberLabel else { return }

        circleView.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false

        // Circle constraints
        self.addConstraint(NSLayoutConstraint(item: circleView,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.top,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: circleView,
            attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.bottom,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: circleView,
            attribute: NSLayoutAttribute.leading,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.leading,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: circleView,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: circleView,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 1.0,
            constant: 0.0))

        // Label constraints
        self.addConstraint(NSLayoutConstraint(item: numberLabel,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: circleView,
            attribute: NSLayoutAttribute.height,
            multiplier: 0.7,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: numberLabel,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: circleView,
            attribute: NSLayoutAttribute.width,
            multiplier: 0.7,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: numberLabel,
            attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: circleView,
            attribute: NSLayoutAttribute.centerY,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: numberLabel,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: circleView,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 1.0,
            constant: 0.0))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let circleView = self.circleView else { return }
        circleView.layer.cornerRadius = self.frame.height / 2.0
    }
}

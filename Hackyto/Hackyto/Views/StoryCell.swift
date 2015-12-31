//
//  StoryCell.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/27/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var pillView: UIView!
    @IBOutlet weak var circledNumberView: CircledNumberView!
    
    var launchComments: ((key: Int) -> ())?
    
    var key: Int?

    var number: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pillView.layer.cornerRadius = 30.0

        self.backgroundColor = ColorFactory.darkGrayColor()
        self.backgroundView?.backgroundColor = ColorFactory.darkGrayColor()
        self.contentView.backgroundColor = ColorFactory.darkGrayColor()
        self.numberLabel.textAlignment = .Center
        self.pillView.backgroundColor = ColorFactory.lightColor()
    }

    func configureCell(title title:String, author:String, storyKey: Int, number: Int) {
        let headlineFontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleHeadline)
        let captionFontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleCaption1)

        self.titleLabel.font = UIFont(name: "HelveticaNeue-Thin", size: headlineFontDescriptor.pointSize + 6)
        self.authorLabel.font = UIFont(name: "HelveticaNeue", size: captionFontDescriptor.pointSize)
        
        self.titleLabel.text = title
        
        self.authorLabel.textColor = ColorFactory.colorFromNumber(number)
        self.authorLabel.text = author

        self.numberLabel.textColor = ColorFactory.colorFromNumber(number)
        self.numberLabel.text = String(number)

        self.circledNumberView.colorNumber = number

        let tapGesture = UITapGestureRecognizer(target: self, action: "openComments")
        self.circledNumberView.addGestureRecognizer(tapGesture)

        self.number = number
        self.key = storyKey
    }

    func configureComments(comments comments:NSArray){
        self.circledNumberView.number = String(comments.count)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleLabel.text = ""
        self.authorLabel.text = ""
        self.numberLabel.text = ""
        self.key = 0

        for gesture in (self.circledNumberView?.gestureRecognizers)! {
            self.circledNumberView.removeGestureRecognizer(gesture)
        }
    }

    // MARK: Actions
    
    @IBAction func openComments() {
        guard let key = key else { return }
        launchComments?(key: key)
    }
}

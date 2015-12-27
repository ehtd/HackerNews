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
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var pillView: UIView!
    
    var launchComments: ((key: Int) -> ())?
    
    var key: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pillView.layer.cornerRadius = 30.0

        self.backgroundColor = ColorFactory.darkGrayColor()
        self.backgroundView?.backgroundColor = ColorFactory.darkGrayColor()
        self.contentView.backgroundColor = ColorFactory.darkGrayColor()
        self.numberLabel.textAlignment = .Center
    }

    func configureCell(title title:String, author:String, storyKey: Int, number: Int) {
        let headlineFontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleHeadline)
        let captionFontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleCaption1)

        titleLabel.font = UIFont(name: "HelveticaNeue-Thin", size: headlineFontDescriptor.pointSize + 6)
        authorLabel.font = UIFont(name: "HelveticaNeue", size: captionFontDescriptor.pointSize)
        
        titleLabel.text = title
        
        authorLabel.textColor = ColorFactory.colorFromNumber(number)
        authorLabel.text = author

        numberLabel.textColor = ColorFactory.colorFromNumber(number)
        numberLabel.text = String(number)

        commentsButton.setTitle("0", forState: UIControlState.Normal)
        
        key = storyKey
    }

    func configureComments(comments comments:NSArray){
        commentsButton.setTitle("\(comments.count)", forState: UIControlState.Normal)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = ""
        authorLabel.text = ""
        numberLabel.text = ""
        key = 0
    }

    // MARK: Actions
    
    @IBAction func openComments() {
        guard let key = key else { return }
        launchComments?(key: key)
    }
}

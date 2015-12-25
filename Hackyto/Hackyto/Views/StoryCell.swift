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
    @IBOutlet weak var commentsButton: UIButton!
    
    var launchComments: ((key: Int) -> ())?
    
    var key: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorFactory.darkColor()
        self.backgroundView?.backgroundColor = ColorFactory.darkColor()
        self.contentView.backgroundColor = ColorFactory.darkColor()
    }

    func configureCell(title title:String, author:String, storyKey: Int){
        
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        authorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        titleLabel.text = title
        authorLabel.text = author
        commentsButton.setTitle("0", forState: UIControlState.Normal)
        
        key = storyKey
    }

    func configureComments(comments comments:NSArray){
        commentsButton.setTitle("\(comments.count)", forState: UIControlState.Normal)
    }
    
    // MARK: Actions
    
    @IBAction func openComments() {
        guard let key = key else { return }
        launchComments?(key: key)
    }
}

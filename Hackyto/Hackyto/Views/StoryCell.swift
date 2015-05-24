//
//  StoryCell.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/27/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel: ETLabel!
    @IBOutlet weak var authorLabel: ETLabel!
    @IBOutlet weak var commentsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(#title:String, author:String){
        
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        authorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        titleLabel.text = title
        authorLabel.text = author
        commentsButton.setTitle("0", forState: UIControlState.Normal)
    }

    func configureComments(#comments:NSArray){
        commentsButton.setTitle("\(comments.count)", forState: UIControlState.Normal)
    }
}

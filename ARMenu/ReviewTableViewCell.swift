//
//  ReviewTableViewCell.swift
//  ARMenu
//
//  Created by William Bai on 4/26/20.
//  Copyright © 2020 CS5150-ARMenu. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageView.image = UIImage(named: "Image")
//        usernameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
//        usernameLabel.adjustsFontForContentSizeCategory = true
//
//        guard let palatino = UIFont(name: "Palatino", size: 18) else {
//            fatalError("""
//                Failed to load the "Palatino" font.
//                Since this font is included with all versions of iOS that support Dynamic Type, verify that the spelling and casing is correct.
//                """
//            )
//        }
//        reviewTextLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: palatino)
//        reviewTextLabel.adjustsFontForContentSizeCategory = true
//
//        usernameLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
//        usernameLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
//
//        reviewTextLabel.leadingAnchor.constraint(equalTo: reviewTextLabel.leadingAnchor).isActive = true
//        reviewTextLabel.trailingAnchor.constraint(equalTo: reviewTextLabel.trailingAnchor).isActive = true
//
//        usernameLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
//
//        contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: reviewTextLabel.lastBaselineAnchor, multiplier: 1).isActive = true
//
//        reviewTextLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: usernameLabel.lastBaselineAnchor, multiplier: 1).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

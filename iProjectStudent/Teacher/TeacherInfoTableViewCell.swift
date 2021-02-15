//
//  TeacherInfoTableViewCell.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/15.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import Cosmos

class TeacherInfoTableViewCell: UITableViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var furiganaLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var collageInfoLabel: UILabel!
    @IBOutlet var averageTitleLabel: UILabel!
    @IBOutlet var averageScoreCosmosView: CosmosView!
    @IBOutlet var studentNumLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        averageScoreCosmosView.settings.fillMode = .precise
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

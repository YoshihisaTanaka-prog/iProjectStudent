//
//  TeacherInfoTableViewCell.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/15.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import Cosmos
import NCMB

protocol TeacherInfoTableViewCellDelegate {
    func didTapCellButton(tableViewCell: UITableViewCell, button: UIButton)
}

class TeacherInfoTableViewCell: UITableViewCell {
    
    var delegate: TeacherInfoTableViewCellDelegate?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var furiganaLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var collageInfoLabel: UILabel!
    @IBOutlet var averageTitleLabel: UILabel!
    @IBOutlet var avarageNumLabel: UILabel!
    @IBOutlet var averageScoreCosmosView: CosmosView!
    @IBOutlet var studentSubjectTitleLabel: UILabel!
    @IBOutlet var studentSubjectNumLabel: UILabel!
    @IBOutlet var studentTotalNumLabel: UILabel!
    @IBOutlet var introductionTextView: UITextView!
    @IBOutlet var followButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        averageScoreCosmosView.settings.fillMode = .precise
        userImageView.layer.cornerRadius = userImageView.frame.height / 2.f
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tappedFollowButton(button: UIButton){
        print("tapped")
        self.delegate?.didTapCellButton(tableViewCell: self, button: button)
    }
    
}

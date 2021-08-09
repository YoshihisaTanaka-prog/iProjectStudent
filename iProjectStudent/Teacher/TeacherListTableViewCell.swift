//
//  TeacherListTableViewCell.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/08/06.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class TeacherListTableViewCell: UITableViewCell {
    
    @IBOutlet var teacherImageView: UIImageView!
    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet var teacherCollageLabel: UILabel!
    @IBOutlet var teacherStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        teacherImageView.layer.cornerRadius = teacherImageView.frame.height / 2.f
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

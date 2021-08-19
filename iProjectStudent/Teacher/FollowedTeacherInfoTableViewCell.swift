//
//  FollowedTeacherInfoTableViewCell.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/08/02.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

protocol FollowedTeacherInfoTableViewCellDelegate {
    func tappedChat()
    func tappedSchedule()
    func changestatus(status: Int)
}

class FollowedTeacherInfoTableViewCell: UITableViewCell {
    
    var delegate: FollowedTeacherInfoTableViewCellDelegate?
    var teacher: User!
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var furiganaLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var collageInfoLabel: UILabel!
    @IBOutlet var totalNUmLabel: UILabel!
    @IBOutlet var introductionTextView: UITextView!
    @IBOutlet var changeStatusButton: UIButton!
    @IBOutlet var buttonsView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2.f
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func tappedBlock(){
        self.delegate?.changestatus(status: -1)
        for v in buttonsView.subviews{
            if v is UIButton{
                let b = v as! UIButton
                b.isSelected = false
            }
        }
    }
    
    @IBAction private func tappedCSButton(){
        switch teacher.status {
        case 1:
            self.delegate?.changestatus(status: 2)
        case 2:
            self.delegate?.changestatus(status: 1)
        default:
            break
        }
        for v in buttonsView.subviews{
            if v is UIButton{
                let b = v as! UIButton
                b.isSelected = false
            }
        }
    }
    
    @IBAction private func tappedChat(){
        self.delegate?.tappedChat()
    }
    
    @IBAction private func tappedSchedule(){
        self.delegate?.tappedSchedule()
    }
    
}

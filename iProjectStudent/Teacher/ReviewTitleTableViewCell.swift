//
//  ReviewTitleTableViewCell.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/06/17.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

protocol ReviewTitleTableViewCellDelegate {
    func didTapTitleCellButton(tableViewCell: ReviewTitleTableViewCell, button: UIButton)
}

class ReviewTitleTableViewCell: UITableViewCell {
    
    var delegate: ReviewTitleTableViewCellDelegate?
    
    @IBOutlet var filterButton: UIButton!
    public var subjectButtons: [UIButton] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let subjects = ["国語","数学","理科","社会","英語"]
        let marginWidth = (screenSizeG["NnNt"]!.width - 290.f) / 4.f
        var x = 20.f
        var tag = 1
        for s in subjects{
            let button = UIButton(frame: CGRect(x: x, y: 60.f, width: 50.f, height: 20.f))
            button.setTitle(s, for: .normal)
            button.setTitleColor(UIColor(iRed: 255, iGreen: 255, iBlue: 255), for: .normal)
            button.addTarget(self, action: #selector(self.tappedSubjectButton(_:)), for: .touchUpInside)
            button.tag = tag
            
            self.addSubview(button)
            subjectButtons.append(button)
            x += marginWidth + 50.f
            tag += 1
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideButtons(){
        filterButton.isHidden = true
        filterButton.isEnabled = false
        for b in subjectButtons{
            b.isHidden = true
            b.isEnabled = false
        }
    }
    
    func showButtons(_ i: Int){
        filterButton.isHidden = false
        filterButton.isEnabled = true
        for b in subjectButtons{
            if b.tag == i+1 {
                b.alpha = 0.5.f
                b.isEnabled = false
            } else{
                b.alpha = 1.f
                b.isHidden = false
                b.isEnabled = true
            }
        }
    }
    
    @IBAction func tappedButton(button: UIButton){
        self.delegate?.didTapTitleCellButton(tableViewCell: self, button: button)
    }
    
    @objc func tappedSubjectButton(_ sender : UIButton){
        tappedButton(button: sender)
    }
    
}

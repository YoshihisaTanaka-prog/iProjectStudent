//
//  ChoiceTableViewCell.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 7/15/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class ChoiceTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var choiceLabel: UILabel!
    @IBOutlet weak var choiceTextField: UITextField!
    //@IBOutlet weak var choiceButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let size = screenSizeG["EnEt"]!
        self.contentView.frame = CGRect(x: 0.f, y: 0.f, width: size.width, height: size.viewHeight)
        choiceTextField.delegate = self
        choiceTextField.isEnabled = false
//        self.backgroundColor = dColor.base
        self.setFontColor()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

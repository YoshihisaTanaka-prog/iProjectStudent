//
//  ReviewTableViewCell.swift
//  iProjectStudent
//
//  Created by user on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import Cosmos
import NCMB

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet var title: UILabel!
    @IBOutlet var score: AccentLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.setFontColor()
        cosmosView.backgroundColor = .clear
        cosmosView.settings.totalStars = 5
        cosmosView.settings.passTouchesToSuperview = false
        // スター半分の評価ができるようにする
        cosmosView.settings.fillMode = .precise
        //ユーザー以外の人が編集できないようにする
        cosmosView.settings.updateOnTouch = false
        userimage.layer.cornerRadius = userimage.frame.height / 2.f
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
    
    
}

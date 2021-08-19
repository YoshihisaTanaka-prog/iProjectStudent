//
//  BookingTableViewCell.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/08/06.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

protocol BookingDelegate {
    func tappedBookingSelection(cell: UITableViewCell, button: UIButton)
}

class BookingTableViewCell: UITableViewCell {
    
    var bookingData: BookingData!
    var delegate: BookingDelegate?
    
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var title1Label: UILabel!
    @IBOutlet private var button1: UIButton!
    @IBOutlet private var title2Label: UILabel!
    @IBOutlet private var button2: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button1.layer.cornerRadius = 7.f
        button1.tag = 1
        button1.backgroundColor = dColor.base
        button1.setTitleColor(dColor.font, for: .normal)
        button1.setTitleColor(dColor.font, for: .selected)
        button2.layer.cornerRadius = 7.f
        button2.tag = 2
        button2.backgroundColor = dColor.base
        button2.setTitleColor(dColor.font, for: .normal)
        button2.setTitleColor(dColor.font, for: .selected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func tapped(_ sender: UIButton){
        if sender.tag == 1{
            button1.isEnabled = false
        } else{
            button2.isEnabled = false
        }
        self.delegate?.tappedBookingSelection(cell: self, button: sender)
    }
    
    func setUpUI(){
        dateLabel.text = bookingData.date.ymdJp
        title1Label.text = bookingData.title1
        title2Label.text = bookingData.title2
        if bookingData.isSelectFirst{
            button1.isEnabled = false
            button1.setTitle("◉", for: .normal)
            button2.isEnabled = true
            button2.setTitle("○", for: .normal)
        } else{
            button2.isEnabled = false
            button2.setTitle("◉", for: .normal)
            button1.isEnabled = true
            button1.setTitle("○", for: .normal)
        }
    }
    
}

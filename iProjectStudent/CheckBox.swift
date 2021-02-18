//
//  CheckBox.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/18.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit

class CheckBox {
    var mainView: UIView
    var checkBoxes: [CheckBoxButton]
    var height = 5.f
    
    init(_ list: [CheckBoxInput], size: CGRect) {
        self.mainView = UIView()
        checkBoxes = []
        for i in 0..<list.count {
            self.checkBoxes.append(CheckBoxButton(list[i], num: i))
            self.mainView.addSubview(self.checkBoxes[i].button)
            self.mainView.addSubview(self.checkBoxes[i].label)
            height += 25.f
        }
    }
}

class CheckBoxButton {
    var button: UIButton
    var label: UILabel
    var isSelected = false
    init(_ c: CheckBoxInput, num: Int) {
        self.label = UILabel(frame: CGRect(x: 25.f, y: 25.f * num.f , width: 120.f, height: 20.f))
        self.label.text = c.title
        if(c.color == nil){
            self.label.textColor = .black
        } else {
            self.label.textColor = c.color!
        }
        self.button = UIButton(frame: CGRect(x: 0.f, y: 25.f * num.f, width: 20.f, height: 20.f))
        self.button.setTitle("○", for: .normal)
        self.button.setTitleColor(UIColor(red: 0.f, green: 0.f, blue: 0.5.f, alpha: 1.f), for: .normal)
    }
    
    @objc private func tapped(_ sender: UIButton){
        if(self.isSelected){
            self.button.setTitle("○", for: .normal)
        }else{
            self.button.setTitle("◉", for: .normal)
        }
        self.isSelected = !self.isSelected
    }
}

class CheckBoxInput{
    var title: String
    var color: UIColor?
    init(_ title: String, color: UIColor?){
        self.title = title
        self.color = color
    }
    
    init(_ title: String){
        self.title = title
        self.color = nil
    }
}

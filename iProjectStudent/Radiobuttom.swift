//
//  Radiobuttom.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 3/10/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit


class RadiobuttomBox {
    var mainView: UIView
    var radiobuttomBoxes: [UIButton]
    var radiobuttomlabel: [UILabel]
    var radiobuttombool: [Bool]
    var height = 5.f
    
    init(_ list: [RadioBoxInput], size: CGRect) {
        self.mainView = UIView()
        //radiobuttomBoxes = []
        radiobuttomBoxes = []
        radiobuttomlabel = []
        radiobuttombool = []
        for i in 0..<list.count {
           // self.radiobuttomBoxes.append(RadioBoxButton(list[i], num: i))
          //  self.mainView.addSubview(self.radiobuttomBoxes[i].button)
          //  self.mainView.addSubview(self.radiobuttomBoxes[i].label)
            self.radiobuttombool.append(false)
            
            
            let label = UILabel()
            //ラベルの設定
            
            radiobuttomlabel.append(label)
            
            let button = UIButton()
            //ボタンの設定
            
            radiobuttomBoxes.append(button)
            self.mainView.addSubview(button)
            
            height += 25.f
        }
        self.mainView.frame = CGRect(x: 0, y: 0, width: 0, height: self.height)
        print(height)
        
        
        
        
    }
    
    func getSelection() -> String{
        var ret = ""
        for c in radiobuttomBoxes {
            if c.isSelected {
                ret += "T"
            } else {
                ret += "F"
            }
        }
        return ret
    }
    
    func setSelection(_ selection: String) {
        if selection.count == radiobuttomBoxes.count {
            let cList = Array(selection)
            for i in 0..<cList.count{
                let s = String(cList[i])
                if(s == "T"){
                    radiobuttomBoxes[i].isSelected = true
                    radiobuttomBoxes[i].setTitle("◉", for: .normal)
                } else {
                    //新しく追加　2021/03/10
                    radiobuttomBoxes[i].isSelected = false
                    radiobuttomBoxes[i].setTitle("○", for: .normal)
                }
            }
        }
    }
}
//使わない。参考にはできる
class RadioBoxButton {
    var button: UIButton
    var label: UILabel
    var isSelected = false
    init(_ c: RadioBoxInput, num: Int) {
//        この辺重要
//command /でその行をコメントアウト。複数行選んでる一括
        self.label = UILabel(frame: CGRect(x: 25.f, y: 25.f * num.f , width: 120.f, height: 20.f))
        self.label.text = c.title
        self.label.textColor = c.color
        self.button = UIButton(frame: CGRect(x: 0.f, y: 25.f * num.f, width: 20.f, height: 20.f))
        self.button.setTitle("○", for: .normal)
        self.button.setTitleColor(UIColor(red: 0.f, green: 0.f, blue: 0.5.f, alpha: 1.f), for: .normal)
        self.button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc private func tapped() -> Bool{
        if(self.isSelected == false){
            self.button.setTitle("○", for: .normal)
        }else{
            self.button.setTitle("◉", for: .normal)
        }
         //self.isSelected = !self.isSelected
        return isSelected
    }
}

class RadioBoxInput{
    var title: String
    var color: UIColor
    init(_ title: String, color: UIColor){
        self.title = title
        self.color = color
    }
    
    init(_ title: String){
        self.title = title
        self.color = dColor.font
    }
}

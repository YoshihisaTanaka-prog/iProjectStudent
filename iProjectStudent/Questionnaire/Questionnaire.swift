//
//  Questionnaire.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit
/*
class Questionnaire {
    var mainScrollView: UIScrollView
    var questionViews: [[QuestionView]]
    var questions: [[QuestionInputFormat]]
    var result: Int = -1
    init(questions: [[QuestionInputFormat]], size: Size, onlyEven numOfButton: Int) {
        <#statements#>
    }
}

class QuestionView: UIView{
    var buttons: [UIButton]
    var isNegative: Bool
    var numOfButton: Int
    var result: Int = -1
    
    init(_ size: Size, _ question: QuestionInputFormat, _ numOfButton: Int) {
        self.isNegative = question.isNegative
        self.numOfButton = numOfButton
//        質問文の設定
        let questionLabel = UILabel()
        questionLabel.frame = CGRect(x: 10.f, y: 10.f, width: size.width - 20.f, height: 0)
        questionLabel.numberOfLines = 0
        questionLabel.text = question.question
        questionLabel.sizeToFit()
        let height = questionLabel.frame.size.height
        self.frame = CGRect(x: 0.f, y: 0.f, width: size.width, height: height + 50.f)
        self.addSubview(questionLabel)
        
//        選択肢の設定
        let label1 = UILabel(frame: CGRect(x: 10, y: height + 10.f, width: 120, height: 30))
        let label2 = UILabel(frame: CGRect(x: size.width - 130, y: height + 10.f, width: 120, height: 30))
        label1.text = "そう思う"
        label2.text = "そうは思わない"
        for i in 0..<numOfButton {
            let button = UIButton(frame: CGRect(x: 0.f, y: 0.f, width: 30.f, height: 30.f))
            
            button.setTitle("○", for: .normal)
            button.tag = i
            button.actions()//ココ忘れた
        }
        self.addSubview(label1)
        self.addSubview(label2)
    }
    
    @objc func selected(_ sender: UIButton){
        
        for i in 0..<self.numOfButton {
            if(i == sender.tag){
                buttons[i].setTitle("●", for: .normal)
                self.result = i
            }
            else{
                buttons[i].setTitle("○", for: .normal)
            }
        }
    }
}

class QuestionInputFormat{
    var question: String
    var isNegative: Bool
    init(_ question: String, isNegative: Bool) {
        self.isNegative = isNegative
        if( question.hasSuffix("?") || question.hasSuffix("？") ){
            self.question = question
        }
        else if(question.hasSuffix(".") || question.hasSuffix("。")){
            self.question = String(question.prefix(question.count - 1)) + "?"
        }
        else{
            self.question = question + "?"
        }
        
    }
}
*/

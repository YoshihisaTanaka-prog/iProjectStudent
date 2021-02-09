//
//  Questionnaire.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit


class Questionnaire {
    var mainScrollView = UIScrollView()
    var questionViews: [[QuestionView]] = []
    var totalNumbers: [Int] = []
    var result: Int = -1
    init(questions: [[QuestionInputFormat]], size: Size, onlyEven numOfButton: Int) {
        var mainSVHeight = 20.f // mainScrollViewの高さを計算する。
        let titleLabel = UILabel(frame: CGRect(x: 10.f, y: 10.f, width: size.width - 20.f, height: 0))
        titleLabel.numberOfLines = 0
        titleLabel.text = """
アンケートに答えて下さい。

このアンケートの結果はより良い教師とマッチングできるようにするために使います。
"""
        titleLabel.sizeToFit()
        self.mainScrollView.addSubview(titleLabel)
        mainSVHeight += titleLabel.frame.size.height
        
//        質問の追加をする
        
        mainSVHeight += 10.f
        let answerButton = UIButton(frame: CGRect(x: 0.f, y: mainSVHeight, width: size.width, height: 40))
//        ボタンの設定をする
        self.mainScrollView.addSubview(answerButton)
        mainSVHeight += 50.f
        self.mainScrollView.frame = CGRect(x: 0.f, y: 0.f, width: size.width, height: mainSVHeight)
    }
    
    @objc func tappedAnswer(){
        if(isAnsweredAllQuestions()){}
        else{}
    }
    
    private func isAnsweredAllQuestions() -> Bool {
        for questViews in self.questionViews {
            for questView in questViews {
                if(questView.result == -1){
                    return false
                }
            }
        }
        return true
    }
}


class QuestionView{
    var mainView: UIView
    var buttons: [UIButton] = []
    var isNegative: Bool
    var numOfButton: Int
    var result: Int = -1
    
    init(_ size: Size, _ question: QuestionInputFormat, _ numOfButton: Int) {
        self.isNegative = question.isNegative
        self.numOfButton = numOfButton
        
        self.mainView = UIView(frame: CGRect(x: 0.f, y: 0.f, width: size.width, height: 0))
        
//        質問文の設定
        let questionLabel = UILabel()
        questionLabel.frame = CGRect(x: 10.f, y: 10.f, width: size.width - 20.f, height: 0)
        questionLabel.numberOfLines = 0
        questionLabel.text = question.question
        questionLabel.sizeToFit()
        let height = questionLabel.frame.size.height
        self.mainView.frame = CGRect(x: 0.f, y: 0.f, width: size.width, height: height + 50.f)
        self.mainView.addSubview(questionLabel)
        
//        選択肢の設定
        let label1 = UILabel(frame: CGRect(x: 10, y: height + 10.f, width: 120, height: 30))
        let label2 = UILabel(frame: CGRect(x: size.width - 130, y: height + 10.f, width: 120, height: 30))
        label1.text = "そう思う"
        label2.text = "そうは思わない"
        self.mainView.addSubview(label1)
        self.mainView.addSubview(label2)
        for i in 0..<numOfButton {
            self.buttons.append(UIButton(frame: CGRect(x: 0.f, y: 0.f, width: 30.f, height: 30.f)))
            let buttonWidth = (size.width - 260.f) / 4.f
            self.buttons[i].center = CGPoint(x: 130 + buttonWidth / 2.f + i.f * buttonWidth, y: height + 25)
            self.buttons[i].setTitle("○", for: .normal)
            self.buttons[i].tag = i
            self.buttons[i].addTarget(self, action: #selector(self.selected(_:)), for: .touchUpInside)
            self.mainView.addSubview(buttons[i])
        }
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


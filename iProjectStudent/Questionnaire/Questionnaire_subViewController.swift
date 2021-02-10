//
//  QuestionnaireViewController.swift
//  iProjectStudent
//
//  Created by Ring Trap on 2/8/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class QuestionnaireViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate {

    var questionaire: Questionnaire!
    let qustionlist = [[
        QuestionInputFormat(question: "応用よりもまずは基礎をじっくり学びたい", isNegative: true),
        QuestionInputFormat(question: "初対面の人とも気さくに話せる", isNegative: false),
        QuestionInputFormat(question: "計画を立てるのが苦手", isNegative: true),
        QuestionInputFormat(question: "一人で過ごすのが好き", isNegative: false),
        QuestionInputFormat(question:"慎重だとよく言われる", isNegative: true),
        QuestionInputFormat(question: "ポジティブに考えることが多い", isNegative: false),
        QuestionInputFormat(question: "新しいアイデアをひらめくことが好きだ", isNegative: true),
        QuestionInputFormat(question: "周りから大人しいと言われる", isNegative: false),
        QuestionInputFormat(question: "論理的に相手を説得させることができる", isNegative: true),
        QuestionInputFormat(question: "積極的だとよく言われる", isNegative: false),
        QuestionInputFormat(question: "絵や図で説明してもらう方がわかりやすい", isNegative: true),
        QuestionInputFormat(question: "自分の話をするより人の話を聞くことが多い", isNegative: false)
    ]]

    override func viewDidLoad() {
        super.viewDidLoad()
        questionaire = Questionnaire(questions: qustionlist, size: getScreenSize(isExsistsNavigationBar: true, isExsistsTabBar: true)!, onlyEven: 4)
        
        self.view.addSubview(questionaire.mainScrollView)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
}

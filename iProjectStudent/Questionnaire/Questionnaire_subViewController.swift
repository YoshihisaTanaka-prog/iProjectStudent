//
//  QuestionnaireViewController.swift
//  iProjectStudent
//
//  Created by Ring Trap on 2/8/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class QuestionnaireViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
//    @IBOutlet var Q1pickerView: UIPickerView!

    var selected: String?
    
   let Q1dataList = ["Q1. 他人に自己紹介するのが苦手だと感じる。","あてはまる","ややあてはまる","あまりあてはまらない","あてはまらない"]

    override func viewDidLoad() {
        super.viewDidLoad()
        questionaire = Questionnaire(questions: qustionlist, size: getScreenSize(isExsistsNavigationBar: true, isExsistsTabBar: true)!, onlyEven: 4)
        
        self.view.addSubview(questionaire.mainScrollView)
//        Q1pickerView.delegate = self
//        Q1pickerView.dataSource = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return Q1dataList.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return Q1dataList[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if row != 0 {
            selected = Q1dataList[row]
        } else {
            selected = nil
        }
    }

}

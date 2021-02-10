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
        QuestionInputFormat(question: "他人に自己紹介するのが苦手だと感じる。", isNegative: true),
        QuestionInputFormat(question: "他人に自己紹介するのが苦手だと感じる。", isNegative: false),
        QuestionInputFormat(question: "他人に自己紹介するのが苦手だと感じる。", isNegative: true),
        QuestionInputFormat(question: "他人に自己紹介するのが苦手だと感じる。", isNegative: true),
        QuestionInputFormat(question: "他人に自己紹介するのが苦手だと感じる。", isNegative: true)
    ]]
    
    @IBOutlet var Q1pickerView: UIPickerView!

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

//
//  QuestionnaireViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 2/8/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class QuestionnaireViewController: UIViewController {

    var questionaire: Questionnaire!
    var timer: Timer!
    
    /*
     let qustionlist = [[
     内向型or外交型の質問
     ],[
     もう一個の方の質問
     ]]
     という形式で入力お願いします。
     
     注意点として、isNegative -> isNormalに変更しました。（true,false の考え方が不自然だったから。）
     
     p.s. Opning2ViewController.swiftを弄ってテストしておいてください。
     
     */
    
    let qustionlist = [[
        QuestionInputFormat(question: "応用よりもまずは基礎をじっくり学びたい", isNormal: false),
        QuestionInputFormat(question: "初対面の人とも気さくに話せる", isNormal: false),
        QuestionInputFormat(question: "計画を立てるのが苦手", isNormal: false),
        QuestionInputFormat(question: "一人で過ごすのが好き", isNormal: true),
        QuestionInputFormat(question:"慎重だとよく言われる", isNormal: false),
        QuestionInputFormat(question: "ポジティブに考えることが多い", isNormal: true),
        QuestionInputFormat(question: "新しいアイデアをひらめくことが好きだ", isNormal: false),
        QuestionInputFormat(question: "周りから大人しいと言われる", isNormal: true),
        QuestionInputFormat(question: "論理的に相手を説得させることができる", isNormal: false),
        QuestionInputFormat(question: "積極的だとよく言われる", isNormal: true),
        QuestionInputFormat(question: "絵や図で説明してもらう方がわかりやすい", isNormal: false),
        QuestionInputFormat(question: "自分の話をするより人の話を聞くことが多い", isNormal: true)
    ]]

    override func viewDidLoad() {
        super.viewDidLoad()
        questionaire = Questionnaire(questions: qustionlist, onlyEven: 4)
        
        self.view.addSubview(questionaire.mainScrollView)
        
        self.setBackGround(false , false)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(QuestionnaireViewController.read), userInfo: nil, repeats: true)
        
    }
    
    @objc func read(){
        if(questionaire.result > -1){
//            送信して画面を移動
            timer.invalidate()
            let object = NCMBObject(className: "StudentParameter")
            object?.setObject([], forKey: "choice")
            object?.setObject("", forKey: "furigana")
            object?.setObject("0", forKey: "grade")
            object?.setObject("", forKey: "introduction")
            object?.setObject(nil, forKey: "imageName")
            object?.setObject(true, forKey: "isActive")
            object?.setObject(true, forKey: "isPermitted")
            object?.setObject("", forKey: "parentEmailAdress")
            object?.setObject(nil, forKey: "peerId")
            object?.setObject(questionaire.result, forKey: "personalityGroup")
            object?.setObject("", forKey: "schoolName")
            object?.setObject("", forKey: "selection")
            object?.setObject([], forKey: "teacherGrades")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.setObject("", forKey: "userName")
            object?.setObject("FFFFFFF", forKey: "youbi")
//            指導希望時間の初期値
            let weekTimes = ["MondayTime","TuesdayTime","WednesdayTime","ThursdayTime","FridayTime","SaturdayTime","SundayTime"]
            for w in weekTimes{
                object?.setObject([], forKey: w)
            }
            object?.saveInBackground({ (error) in
                if(error == nil){
                    NCMBUser.current()?.setObject(object, forKey: "parameter")
                    NCMBUser.current()?.signUpInBackground({ (error) in
                        if(error == nil){
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                            currentUserG = User(NCMBUser.current()!)
                            self.present(rootViewController, animated: false, completion: nil)
                        }
                        else{
                            self.showOkAlert(title: "Error", message: error!.localizedDescription)
                        }
                    })
                }
                else{
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
        }
        if(questionaire.result == -2){
            questionaire.result = -1
            showOkAlert(title: "注意", message: "未回答の項目があります。")
            questionaire.mainScrollView.setContentOffset(CGPoint(x: 0, y: -questionaire.mainScrollView.contentInset.top), animated: true)
        }
    }
}

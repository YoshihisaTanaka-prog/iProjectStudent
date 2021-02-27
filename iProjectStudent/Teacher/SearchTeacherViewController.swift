//
//  SearchTeacherViewController.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/23.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class SearchTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pickerView: UIPickerView!
    var teachers = Teachers()
    var selectedTeacher: User!
    var numOfSelectedSubject = 0
    var isSearching = true
    var selectedSubject: String?
    let mainSubjectList = ["5教科を選択","国語","数学","理科","社会","英語"]
    let subSubjectList = [
        ["------"],
        ["詳細を選択","現代文","古文","漢文"],
        ["詳細を選択","数学Ⅰ・A","数学Ⅱ・B","数学Ⅲ・C"],
        ["詳細を選択","物理","化学","生物","地学"],
        ["詳細を選択","地理","日本史","世界史","現代社会","倫理","政治・経済"],
        ["詳細を選択",""]
    ]
    var teacherList: [niseTeacher] = []
    let teacherLists = [[
        niseTeacher("清水彩加","東京大学",1,5.0),
        niseTeacher("中村香織","東京大学",1,4.9),
        niseTeacher("平岡龍聖","東京大学",3,4.17),
        niseTeacher("金井孝弘","東京大学",4,3.72),
        niseTeacher("福澤大喜","東京大学",1,3.71),
        niseTeacher("鹿島彩美","東京大学",2,3.53),
        niseTeacher("有川翔真","東京大学",2,3.29),
        niseTeacher("田中義久","東京大学",3,2.93),
        niseTeacher("田中要","東京大学",3,2.68),
        niseTeacher("上園陸人","東京大学",4,2.47)
    ],[
        niseTeacher("中川文馨","東京大学",2,4.66),
        niseTeacher("黒木奈々","東京大学",2,4.49),
        niseTeacher("長谷川詩峰","東京大学",2,4.08),
        niseTeacher("磯野友希","東京大学",2,3.81),
        niseTeacher("中尾勇太","東京大学",2,3.55),
        niseTeacher("藤田浩輔","東京大学",4,3.50),
        niseTeacher("後藤達哉","東京大学",4,3.43),
        niseTeacher("田中琴子","東京大学",1,3.24),
        niseTeacher("前田優花","東京大学",3,3.22),
        niseTeacher("笹井翔","東京大学",2,2.03)
    ],[
        niseTeacher("中村香織","東京大学",1,4.9),
        niseTeacher("黒岩秀嵩","東京大学",2,4.39),
        niseTeacher("佐野直希","東京大学",1,4.11),
        niseTeacher("大庭直哉","東京大学",1,3.81),
        niseTeacher("能美雅貴","東京大学",1,3.81),
        niseTeacher("前田直人","東京大学",2,3.50),
        niseTeacher("萬治大典","東京大学",3,3.28),
        niseTeacher("吉行謙","東京大学",2,3.05),
        niseTeacher("外丸遼太","東京大学",3,2.92),
        niseTeacher("原田鞠愛","東京大学",2,2.72)
    ],[
        niseTeacher("木村亮太","東京大学",1,4.41),
        niseTeacher("大庭優実子","東京大学",3,4.36),
        niseTeacher("永田光一","東京大学",4,4.05),
        niseTeacher("田中空","東京大学",4,3.99),
        niseTeacher("河野佑輔","東京大学",1,3.68),
        niseTeacher("松本陽子","東京大学",2,3.55),
        niseTeacher("川崎理聖","東京大学",1,2.52),
        niseTeacher("山口嵩洋","東京大学",1,2.50),
        niseTeacher("平岡龍聖","東京大学",3,2.32),
        niseTeacher("上園陸人","東京大学",4,2.25)
    ],[
        niseTeacher("安永匡志","東京大学",4,4.35),
        niseTeacher("鹿島里美","東京大学",2,4.01),
        niseTeacher("佐藤尚弥","東京大学",2,3.86),
        niseTeacher("柿並遼","東京大学",1,3.73),
        niseTeacher("波多野護","東京大学",3,3.09),
        niseTeacher("中上まゆ","東京大学",3,3.06),
        niseTeacher("高永美歩","東京大学",1,2.98),
        niseTeacher("小畠俊哉","東京大学",4,2.63),
        niseTeacher("浅田翔","東京大学",3,2.55),
        niseTeacher("木嶋マイキ","東京大学",4,2.39)
    ]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackGround(true, true)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100.f
        // カスタムセルの登録
        let nib1 = UINib(nibName: "ReviewTableViewCell", bundle: Bundle.main)
        // (「register(nib: UINib?, forCellReuseIdentifier: String)」を選ぶ。)
        tableView.register(nib1, forCellReuseIdentifier: "Cell2")
        let quely = NCMBUser.query()
        quely?.whereKey("objectId", equalTo: "Yz4FWnQdSmIhUn48")
        quely?.findObjectsInBackground({ (result, error) in
            if(error == nil && result?.count == 1){
                let user = result?.first as! NCMBUser
                self.selectedTeacher = User(user)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(teacherList.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if teacherList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.backgroundColor = .clear
            if(selectedSubject == nil){
                cell.textLabel?.text = "教科を選択してください。"
            } else if(selectedSubject! == ""){
                cell.textLabel?.text = "詳しく教科を選択してください。"
            }
            else if isSearching{
                cell.textLabel?.text = "教師を検索中"
            } else{
                cell.textLabel?.text = "あなたの志望校に通う教師が\n見つかりませんでした。"
            }
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = dColor.font
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! ReviewTableViewCell
            cell.cosmosView.rating = teacherList[indexPath.row].score
            for v in cell.score.subviews {
                v.removeFromSuperview()
            }
            cell.score.text = teacherList[indexPath.row].score.s
            cell.title.text = teacherList[indexPath.row].collage + "   " + teacherList[indexPath.row].grade.s + "年"
            cell.userNameLabel.text = teacherList[indexPath.row].name
            cell.setFontColor()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if teacherList.count != 0 {
            self.performSegue(withIdentifier: "Segue", sender: nil)
        }
        tableView.reloadData()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component{
        case 0:
            return mainSubjectList.count
        default:
            return subSubjectList[numOfSelectedSubject].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        switch component {
        case 0:
            let label = PickerLabel(text: mainSubjectList[row], pickerView.frame.width / 2.f)
            return label
        default:
            let label = PickerLabel(text: subSubjectList[numOfSelectedSubject][row], pickerView.frame.width / 2.f)
            return label
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            numOfSelectedSubject = row
            self.pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.reloadComponent(1)
            teacherList = []
            if(row == 0){
                selectedSubject = nil
            } else{
                selectedSubject = ""
            }
            tableView.reloadData()
        default:
            if(row == 0){
                selectedSubject = ""
            }
            else{
                selectedSubject = subSubjectList[numOfSelectedSubject][row - 1]
                isSearching = true
                teacherList = []
                tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isSearching = false
                    self.teacherList = self.teacherLists[self.numOfSelectedSubject - 1]
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nectVC = segue.destination as! TeacherInfoViewController
        nectVC.subject = selectedSubject!
        nectVC.teacher = selectedTeacher
    }

}

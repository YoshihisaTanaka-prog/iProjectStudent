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
    @IBOutlet var searchBar1: UISearchBar!
    var teachers = Teachers()
    var selectedTeacher: User!
    var numOfSelectedSubject = 0
    var isSearching = true
    var youbi: YoubiCompatibility!
    var spirit: SpiritCompatibility!
    var gradeCheckBox: CheckBox!
    let gradeNameList = ["B1", "B2", "B3", "B4", "M1", "M2"]
    let gradeList: [CheckBoxInput] = [
        CheckBoxInput("学部 1年生"),
        CheckBoxInput("学部 2年生"),
        CheckBoxInput("学部 3年生"),
        CheckBoxInput("学部 4年生"),
        CheckBoxInput("修士 1年生"),
        CheckBoxInput("修士 2年生")
    ]
    let user = User(NCMBUser.current())
    private var selectedSubject: String?
    private var selectedSubjectList = [["------",""]]
    private let mainSubjectList = [["教科を選択",""],["国語",""],["数学",""],["理科",""],["社会",""],["英語","English"]]
    private let subSubjectList = [
            [["------",""]],
            [["詳細を選択",""],["現代文","modernWriting"],["古文","ancientWiting"],["漢文","chineseWriting"]],
            [["詳細を選択",""],["数学Ⅰ・A","math1a"],["数学Ⅱ・B","math2b"],["数学Ⅲ・C","math3c"]],
            [["詳細を選択",""],["物理","physics"],["化学","chemistry"],["生物","biology"],["地学","earthScience"]],
            [["詳細を選択",""],["地理","geography"],["日本史","japaneseHistory"],["世界史","worldHistory"],
             ["現代社会","modernSociety"],["倫理","ethics"],["政治・経済","politicalScienceAndEconomics"]],
            [["-----","English"]]
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
        gradeCheckBox = CheckBox(gradeList,size: CGRect(x: 0, y: 0, width: 0, height: 0))
        gradeCheckBox.setSelection(user.studentParameter!.teacherGrade)
        //gradeCheckBox.setSelection(user_.studentParameter!.youbi)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        youbi = YoubiCompatibility((user.studentParameter?.youbi) ?? "FFFFFFF")
        spirit = SpiritCompatibility()
        tableView.reloadData()
        for y in youbi.badList {
            print(y)
        }

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
    
//学年はチェックボックスで選択
//pickerViewの列の個数（return 2　のところ）
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
  
    //pickerViewの行の個数（return 　のところ）　component列目の個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return mainSubjectList.count
        case 1:
            return selectedSubjectList.count
        default:
            return 0
        }
    }
    
//picerViewに表示する内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0:
                return mainSubjectList[row][0]
            case 1:
                return selectedSubjectList[row][0]
            default:
                return ""
            }
        }
    
//選択されたときの処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedSubjectList = subSubjectList[row]
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            selectedSubject = mainSubjectList[row][1]
            print(selectedSubject)
        case 1:
            selectedSubject = selectedSubjectList[row][1]
            print(selectedSubject)
        default:
            break
        }
        
        if selectedSubject! != "" {
            loadUsers(searchText: searchBar1.text, searchText2: "", searchText3: "")
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nectVC = segue.destination as! TeacherInfoViewController
        nectVC.subject = selectedSubject!
        nectVC.teacher = selectedTeacher
    }
    
    func loadUsers(searchText: String?, searchText2:String?, searchText3: String?){
        let query = NCMBQuery(className: "TeacherParameter")
        query?.whereKeyExists("user")
        query?.whereKey("isAbleToTeach", equalTo: true)
        query?.whereKey("isPermitted", equalTo: true)
        //曜日が合わない教師をはじく
        for i in 0..<youbi.badList.count {
            query?.whereKey("youbi", notEqualTo: youbi.badList[i])
        }
        //性格の相性の悪い教師をはじく
        for s in spirit.getBad(user.studentParameter?.personalityGroup ?? -1) {
            query?.whereKey("personalityGroup", notEqualTo: s)
        }
        //希望した学年以外をはじく
        for i in 0..<gradeCheckBox.checkBoxes.count {
            if !gradeCheckBox.checkBoxes[i].isSelected {
                query?.whereKey("grade", notEqualTo: gradeNameList[i])
            }
        }
        
        if let text = searchText {
            print(text)
            if text != ""{
                query?.whereKey("collage", equalTo: text)
            }
            //大学
            //性格診断
            //学年（int型）
            //andの=!
        }
        
        if let text2 = searchText2 {
            print(text2)
            //大学
            //性格診断
            //学年（int型）
            //isableto
//            query?.whereKey("personalityGroup", equalTo: text2)
        }
        
        
        query?.findObjectsInBackground({ (result, error) in
            if error == nil {
                let objects = result as? [NCMBObject] ?? []
                self.teachers = Teachers(objects, subject: self.selectedSubject!)
                for i in self.teachers.list{
                    print("name:"+i.userName)
                }
            }
            else {
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
            
        })
        
    }
    
    @IBAction func selectTeacherGrade(){
        let alertController = UIAlertController(title: "先生の学年を選んでください。", message: "\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "選択完了", style: .default) { (action) in
            self.gradeCheckBox.mainView.removeFromSuperview()
            alertController.dismiss(animated: true, completion: nil)
            //アプリ内に保存
            self.user.studentParameter!.teacherGrade = self.gradeCheckBox.getSelection()
            //ニフクラに保存
            self.user.studentParameter!.ncmb.setObject(self.gradeCheckBox.getSelection(), forKey: "teacherGrade")
            self.user.studentParameter!.ncmb.saveInBackground { (error) in
                if error == nil {
                    
                } else {
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            }

        }
        let width = alertController.view.frame.width
        gradeCheckBox.mainView.frame = CGRect(x: width / 10.f, y: 50, width: width * 0.8, height: gradeCheckBox.height)
        alertController.view.addSubview(gradeCheckBox.mainView)
        alertController.addAction(alertOkAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

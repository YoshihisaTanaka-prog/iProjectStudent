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
    let gradeList: [CheckBoxInput] = [
        CheckBoxInput("学部 1年生", key: "B1"),
        CheckBoxInput("学部 2年生", key: "B2"),
        CheckBoxInput("学部 3年生", key: "B3"),
        CheckBoxInput("学部 4年生", key: "B4"),
        CheckBoxInput("修士 1年生", key: "M1"),
        CheckBoxInput("修士 2年生", key: "M2"),
        CheckBoxInput("博士 1年生", key: "D1"),
        CheckBoxInput("博士 2年生", key: "D2"),
        CheckBoxInput("博士 3年生", key: "D3"),
        CheckBoxInput("博士 4年生", key: "D4"),
        CheckBoxInput("博士 5年生", key: "D5")
    ]
    private var selectedSubject: String?
    private var selectedSubjectList = [["------",""]]
    private let mainSubjectList = [["教科を選択",""],["国語",""],["数学",""],["理科",""],["社会",""],["英語",""]]
    private let subSubjectList = [
            [["------",""]],
            [["詳細を選択",""],["現代文","modernWriting"],["古文","ancientWiting"],["漢文","chineseWriting"]],
            [["詳細を選択",""],["数学Ⅰ・A","math1a"],["数学Ⅱ・B","math2b"],["数学Ⅲ・C","math3c"]],
            [["詳細を選択",""],["物理","physics"],["化学","chemistry"],["生物","biology"],["地学","earthScience"]],
            [["詳細を選択",""],["地理","geography"],["日本史","japaneseHistory"],["世界史","worldHistory"],
             ["現代社会","modernSociety"],["倫理","ethics"],["政治・経済","politicalScienceAndEconomics"]],
            [["詳細を選択",""],["高校英語","hsEnglish"]]
        ]
    
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
        gradeCheckBox = CheckBox(gradeList)
        gradeCheckBox.setSelectedKey(currentUserG.studentParameter!.teacherGrades)
        //gradeCheckBox.setSelection(user_.studentParameter!.youbi)
        
        print(NCMBUser.current()!.objectId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        youbi = YoubiCompatibility((currentUserG.studentParameter?.youbi) ?? "FFFFFFF")
        spirit = SpiritCompatibility()
        tableView.reloadData()
        for y in youbi.badList {
            print(y)
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(teachers.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if teachers.count == 0 {
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
                cell.textLabel?.text = "希望する条件を満たす教師が\n見つかりませんでした。"
            }
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = dColor.font
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! ReviewTableViewCell
            let teacher = teachers.list[indexPath.row]
//            ここに教師の情報を表示するコードを書いてください。
            cell.cosmosView.rating = teacher.teacherParameter!.score
            cell.score.text = teacher.teacherParameter!.score.s2
            cell.userNameLabel.text = teacher.userName
            cell.userimage.image = userImagesCacheG[teacher.userId]
            cell.title.text = teacher.teacherParameter!.collage + " " + transformGrade(teacher.grade)
            cell.title.numberOfLines = 0
            
            cell.setFontColor()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if teachers.count != 0 {
            self.selectedTeacher = teachers.list[indexPath.row]
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
            print(selectedSubject!)
        case 1:
            selectedSubject = selectedSubjectList[row][1]
            print(selectedSubject!)
        default:
            break
        }
        
        if selectedSubject! != "" && selectedSubject != nil {
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
//        まず、教師の情報をリセットして「教師を検索中」に表示を変える。
        teachers.list = []
        isSearching = true
        tableView.reloadData()
        
        let query = NCMBQuery(className: "TeacherParameter")
        // 垢BANや面接前の教師や退会した教師をはじく
        query?.whereKey("isActive", equalTo: true)
        query?.whereKey("isAbleToTeach", equalTo: true)
        query?.whereKey("isPermitted", equalTo: true)
        
        // 選んだ教科を教えられない先生をはじく
        query?.whereKey("isAbleToTeach" + selectedSubject!.upHead, equalTo: true)
        
        //曜日が合わない教師をはじく
        query?.whereKey("youbi", notContainedIn: youbi.badList)
        
        //性格の相性の悪い教師をはじく
        query?.whereKey("personalityGroup", notContainedIn: spirit.getBad(currentUserG.studentParameter?.personalityGroup ?? -1))
        
        //希望した学年のみ選ぶ
        var goodGrades:[String] = []
        for g in gradeCheckBox.checkBoxes {
            if g.isSelected {
                goodGrades.append(g.key)
            }
        }
        if goodGrades.count != 0{
            query?.whereKey("grade", containedIn: goodGrades)
            
            //        もうすでに登録してある教師やブロックした教師をはじく
            var knownTeacherIds: [String] = []
            //        登録済み
            for u in mixFollowList(){
                knownTeacherIds.append(u.userId)
            }
            //        ブロック済み
            for id in blockedUserIdListG{
                knownTeacherIds.append(id)
            }
            if(knownTeacherIds.count != 0){
                query?.whereKey("userId", notContainedIn: knownTeacherIds)
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
                    print(objects.count)
                    self.teachers = Teachers(objects, subject: self.selectedSubject!)
                    //                5秒待った後に（検索に時間がかかるから）レビューの高い順に並び替えて検索結果を反映する。
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.isSearching = false
                        self.teachers.sort()  //.sort()でレビューの高い順に並び替える（未完成）
                        self.tableView.reloadData()
                    }
                }
                else {
                    self.showOkAlert(title: "Search Teacher Error", message: error!.localizedDescription)
                }
            })
        } else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.isSearching = false
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func selectTeacherGrade(){
        let alertController = UIAlertController(title: "先生の学年を選んでください。", message: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "選択完了", style: .default) { (action) in
            self.gradeCheckBox.mainView.removeFromSuperview()
            alertController.dismiss(animated: true, completion: nil)
            //アプリ内に保存
            currentUserG.studentParameter!.teacherGrades = self.gradeCheckBox.selectedKeys
            //ニフクラに保存
            currentUserG.studentParameter!.ncmb.setObject(self.gradeCheckBox.selectedKeys, forKey: "teacherGrades")
            currentUserG.studentParameter!.ncmb.saveInBackground { (error) in
                if error != nil {
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            }

        }
        alertController.view.addSubview(gradeCheckBox.mainView)
        alertController.addAction(alertOkAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

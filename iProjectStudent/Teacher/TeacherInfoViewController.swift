//
//  TeacherInfoViewController.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/15.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import Cosmos

class TeacherInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TeacherInfoTableViewCellDelegate {
    
//    値渡し用
    var teacher: User!
    var subject: String?
    
    private var isSelectedSubject: Bool!
    private var selectedSubjectList: [String] = []
    private var subjectCheckBoxList = [CheckBox]()
    private var isNeedFilterButton = false
    
    private var reviewList: [Review] = []
    private var size: Size!
    private var selectedReview: Review!
    
    
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = teacher.userName + "先生の詳細情報"

        // Do any additional setup after loading the view.
        size = getScreenSize(isExsistsNavigationBar: true, isExsistsTabBar: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // カスタムセルの登録
        let nib1 = UINib(nibName: "TeacherInfoTableViewCell", bundle: Bundle.main)
        let nib2 = UINib(nibName: "ReviewTableViewCell", bundle: Bundle.main)
        let nib3 = UINib(nibName: "ReviewTitleTableViewCell", bundle: Bundle.main)
        // (「register(nib: UINib?, forCellReuseIdentifier: String)」を選ぶ。)
        tableView.register(nib1, forCellReuseIdentifier: "Cell1")
        tableView.register(nib2, forCellReuseIdentifier: "Cell2")
        tableView.register(nib3, forCellReuseIdentifier: "Cell3")
        
        if subject == nil{
            isSelectedSubject = false
            
            let subjectsInputList = [
                [
                    CheckBoxInput("現代文", key: "modernWriting"),
                    CheckBoxInput("古文", key: "ancientWiting"),
                    CheckBoxInput("漢文", key: "chineseWriting")
                ],[
                    CheckBoxInput("数学Ⅰ・A", key: "math1a"),
                    CheckBoxInput("数学Ⅱ・B", key: "math2b"),
                    CheckBoxInput("数学Ⅲ・C", key: "math3c")
                ],[
                    CheckBoxInput("物理", key: "physics"),
                    CheckBoxInput("化学", key: "chemistry"),
                    CheckBoxInput("生物", key: "biology"),
                    CheckBoxInput("地学", key: "earthScience")
                ],[
                    CheckBoxInput("地理", key: "geography"),
                    CheckBoxInput("日本史", key: "japaneseHistory"),
                    CheckBoxInput("世界史", key: "worldHistory"),
                    CheckBoxInput("現代社会", key: "modernSociety"),
                    CheckBoxInput("倫理", key: "ethics"),
                    CheckBoxInput("政治経済", key: "politicalScienceAndEconomics")
                ],[
                    CheckBoxInput("高校英語", key: "hsEnglish")
                ]
            ]
            for sList in subjectsInputList{
                let checkBox = CheckBox(sList)
                checkBox.setSelectedAll()
                subjectCheckBoxList.append(checkBox)
            }
        } else {
            isSelectedSubject = true
        }
        
        setBackGround(true, true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadReview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return size.viewHeight - 200.f
        }
        else{
            return 100.f
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TeacherInfoTableViewCell
            cell.delegate = self
            cell.averageScoreCosmosView.rating = teacher.teacherParameter!.score
            cell.furiganaLabel.text = teacher.furigana
            self.setUserImage(&cell.userImageView, teacher)
            cell.userNameLabel.text = teacher.userName + "　先生"
            cell.collageInfoLabel.text = teacher.teacherParameter!.collage + " " + teacher.selection + " " + transformGrade(teacher.grade)
            
            if isSelectedSubject{
                cell.averageTitleLabel.text = transformSubject(subject!) + "の平均評価："
                cell.avarageNumLabel.text = teacher.teacherParameter!.score.s
                cell.averageScoreCosmosView.rating = teacher.teacherParameter!.score
                cell.studentSubjectTitleLabel.text = transformSubject(subject!) + "の指導人数："
                cell.studentSubjectNumLabel.text = teacher.teacherParameter!.subjectNum.s + "名"
                cell.followButton.setTitleColor(UIColor(iRed: 255, iGreen: 255, iBlue: 255), for: .normal)
                cell.followButton.isHidden = false
                cell.followButton.isEnabled = true
            } else {
                cell.averageTitleLabel.text = ""
                cell.avarageNumLabel.text = ""
                cell.averageScoreCosmosView.alpha = 0.f
                cell.studentSubjectTitleLabel.text = ""
                cell.studentSubjectNumLabel.text = ""
                cell.followButton.isHidden = true
                cell.followButton.isEnabled = false
            }
            cell.studentTotalNumLabel.text = teacher.teacherParameter!.totalNum.s + "名"
            cell.introductionTextView.text = teacher.introduction
            cell.setFontColor()
            
            return cell
        } else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3") as! ReviewTitleTableViewCell
            if isSelectedSubject {
                cell.hideButtons()
            } else{
                var index = -1
                switch subject ?? "" {
                case "jap":
                    index = 0
                case "math":
                    index = 1
                case "sci":
                    index = 2
                case "soc":
                    index = 3
                case "eng":
                    index = 4
                default:
                    break
                }
                
                cell.delegate = self
                cell.showButtons(index)
            }
            if !isNeedFilterButton {
                cell.filterButton.isHidden = true
                cell.filterButton.isEnabled = false
            }
            cell.setFontColor()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! ReviewTableViewCell
            let review = reviewList[indexPath.row - 2]
            cell.userimage.image = UIImage(named: "studentNoImage.png")
            cell.userNameLabel.text = ""
            cell.title.text = review.title
            cell.cosmosView.rating = review.score
            for v in cell.score.subviews {
                v.removeFromSuperview()
            }
            cell.score.text = review.score.s
            cell.setFontColor()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row > 1){
            selectedReview = reviewList[indexPath.row - 2]
            self.performSegue(withIdentifier: "Detail", sender: nil)
        }
        tableView.reloadData()
    }
    
    func didTapCellButton(tableViewCell: UITableViewCell, button: UIButton) {
        print("didTapButton was called!")
        self.createFollow(teacher.userId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let alert = UIAlertController(title: "選んでください。", message: "", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            let goToChatAlertAction = UIAlertAction(title: "チャットを始める。", style: .default) { _ in
                self.performSegue(withIdentifier: "GoToChat", sender: nil)
            }
            let goToScheduleAlertAction = UIAlertAction(title: "スケジュールを見る", style: .default) { _ in
                self.performSegue(withIdentifier: "WatchSchedule", sender: nil)
            }
            
            alert.addAction(goToChatAlertAction)
            alert.addAction(goToScheduleAlertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadReview(){
        let query = NCMBQuery(className: "Review")
        query?.whereKey("teacherId", equalTo: teacher.userId)
        if isSelectedSubject{
            query?.whereKey("subject", equalTo: subject!)
        } else if selectedSubjectList.count != 0 {
            query?.whereKey("subject", containedIn: selectedSubjectList)
        }
        query?.findObjectsInBackground({ (result, error) in
            if(error == nil){
                self.reviewList = []
                let objects = result as! [NCMBObject]
                for object in objects {
                    self.reviewList.append(Review(object))
                }
                self.tableView.reloadData()
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Detail":
            let nextVC = segue.destination as! ReviewDetailViewController
            nextVC.subjectName = "japanese"
            nextVC.review = selectedReview
            nextVC.isAbletoEdit = false
        case "GoToChat":
            let nextVC = segue.destination as! ChatViewController
            nextVC.selectedChatRoom = ChatRoom(teacher)
        case "WatchSchedule":
            let nextVC = segue.destination as! CalendarViewController
            nextVC.teacher = teacher
        default:
            break
        }
    }
    

}


extension TeacherInfoViewController: ReviewTitleTableViewCellDelegate{
    
    func didTapTitleCellButton(tableViewCell: ReviewTitleTableViewCell, button: UIButton) {
        switch button.tag {
        case 0:
            if subject == nil{
                showOkAlert(title: "注意", message: "教科を選んでください。")
            } else {
                var index = -1
                switch subject! {
                case "jap":
                    index = 0
                case "math":
                    index = 1
                case "sci":
                    index = 2
                case "soc":
                    index = 3
                case "eng":
                    index = 4
                default:
                    break
                }
                if ( index == -1 ) {
                    showOkAlert(title: "エラー", message: "予期せぬエラーが発生しました。")
                } else {
                    let alertController = UIAlertController(title: "レビューを表示する科目を選んでください。", message: subjectCheckBoxList[index].msg, preferredStyle: .alert)
                    let action = UIAlertAction(title: "選択完了", style: .default) { (action) in
                        if (self.subjectCheckBoxList[index].selectedKeys.count == 0){
                            alertController.dismiss(animated: true, completion: nil)
                            self.showOkAlert(title: "注意", message: "最低限1つは科目を選んでください。") {
                                self.subjectCheckBoxList[index].setSelectedAll()
                                self.present(alertController, animated: true, completion: nil)
                            }
                        } else{
                            self.selectedSubjectList = self.subjectCheckBoxList[index].selectedKeys
                            self.loadReview()
                            alertController.dismiss(animated: true, completion: nil)
                        }
                    }
                    alertController.view.addSubview(subjectCheckBoxList[index].mainView)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        case 1:
            subject = "jap"
            selectedSubjectList = ["modernWriting","ancientWiting","chineseWriting"]
            loadReview()
        case 2:
            subject = "math"
            selectedSubjectList = ["math1a","math2b","math3c"]
            loadReview()
        case 3:
            subject = "sci"
            selectedSubjectList = ["physics","chemistry","biology","earthScience"]
            loadReview()
        case 4:
            subject = "soc"
            selectedSubjectList = ["geography","japaneseHistory","worldHistory","modernSociety","ethics","politicalScienceAndEconomics"]
            loadReview()
        case 5:
            subject = "eng"
            selectedSubjectList = ["hsEnglish"]
            loadReview()
        default:
            break
        }
        isNeedFilterButton = true
    }
}

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

class TeacherInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    値渡し用
    var teacher: User!
    var subject: String?
    
    private var isAbleToGoSchedule = false
    
    private var isSelectedSubject: Bool!
    private var selectedSubjectList: [String] = []
    private var subjectCheckBoxList = [CheckBox]()
    private var isNeedFilterButton = false
    private var isFollowed = false
    
    private var reviewList: [Review] = []
    private var size: Size!
    private var selectedReview: Review!
    
    
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        print(teacher.userId)
        super.viewDidLoad()
        
        self.navigationItem.title = teacher.userName + "先生の詳細情報"

        // Do any additional setup after loading the view.
        size = getScreenSize(isExsistsNavigationBar: true, isExsistsTabBar: true)
        
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // カスタムセルの登録
        isFollowed = !isSelectedSubject
        let nib1 = UINib(nibName: "TeacherInfoTableViewCell", bundle: Bundle.main)
        tableView.register(nib1, forCellReuseIdentifier: "Cell1")
        let nib4 = UINib(nibName: "FollowedTeacherInfoTableViewCell", bundle: Bundle.main)
        tableView.register(nib4, forCellReuseIdentifier: "Cell4")
        let nib2 = UINib(nibName: "ReviewTableViewCell", bundle: Bundle.main)
        let nib3 = UINib(nibName: "ReviewTitleTableViewCell", bundle: Bundle.main)
        tableView.register(nib2, forCellReuseIdentifier: "Cell2")
        tableView.register(nib3, forCellReuseIdentifier: "Cell3")
        
        setBackGround(true, true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mixedScheduleG.loadSchedule(date: Date(), userIds: [teacher.userId,currentUserG.userId], self)
        mixedScheduleG.delegate = self
        isAbleToGoSchedule = false
        loadReview()
    }
}

//テーブルビュー関連
extension TeacherInfoViewController{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 538.f
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
            if isFollowed{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4") as! FollowedTeacherInfoTableViewCell
                
                cell.delegate = self
                
                cell.teacher = teacher
                cell.userImageView.image = userImagesCacheG[teacher.userId]
                cell.furiganaLabel.text = teacher.furigana
                cell.userNameLabel.text = teacher.userName
                cell.collageInfoLabel.text = teacher.teacherParameter!.collage
                cell.totalNUmLabel.text = teacher.teacherParameter!.totalNum.s + "名"
                cell.introductionTextView.text = teacher.introduction
                
                switch teacher.status {
                case 1:
                    cell.changeStatusButton.setTitle("固定する", for: .normal)
                case 2:
                    cell.changeStatusButton.setTitle("固定を外す", for: .normal)
                default:
                    break
                }
                for v in cell.subviews{
                    if v is UIButton{
                        let b = v as! UIButton
                        b.isSelected = false
                    }
                }
                
                cell.setFontColor()
                return cell
            } else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TeacherInfoTableViewCell
                cell.delegate = self
                cell.averageScoreCosmosView.rating = teacher.teacherParameter!.score
                cell.furiganaLabel.text = teacher.furigana
                self.setUserImage(&cell.userImageView, teacher)
                cell.userNameLabel.text = teacher.userName + "　先生"
                cell.collageInfoLabel.text = teacher.teacherParameter!.collage + " " + teacher.selection + " " + transformGrade(teacher.grade)
                cell.averageTitleLabel.text = transformSubject(subject!) + "の平均評価："
                cell.avarageNumLabel.text = teacher.teacherParameter!.score.s
                cell.averageScoreCosmosView.rating = teacher.teacherParameter!.score
                cell.studentSubjectTitleLabel.text = transformSubject(subject!) + "の指導人数："
                cell.studentSubjectNumLabel.text = teacher.teacherParameter!.subjectNum.s + "名"
                cell.followButton.setTitleColor(UIColor(iRed: 255, iGreen: 255, iBlue: 255), for: .normal)
                cell.studentTotalNumLabel.text = teacher.teacherParameter!.totalNum.s + "名"
                cell.introductionTextView.text = teacher.introduction
                cell.setFontColor()
                
                return cell
            }
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
            cell.userNameLabel.text = review.student.userName
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.tableView.reloadData()
                }
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
}

//テーブルビューのデリゲート関連
extension TeacherInfoViewController: TeacherInfoTableViewCellDelegate, FollowedTeacherInfoTableViewCellDelegate{
    
    func tappedChat() {
        self.performSegue(withIdentifier: "GoToChat", sender: nil)
    }
    
    func tappedSchedule() {
        if isAbleToGoSchedule{
            self.performSegue(withIdentifier: "WatchSchedule", sender: nil)
        } else{
            isAbleToGoSchedule = true
        }
    }
    
    func changestatus(status: Int) {
        tableView.reloadData()
        switch (teacher.status, status){
        case (1, -1):
            var k = -1
            for i in 0..<followUserListG.count{
                if followUserListG[i].userId == teacher.userId {
                    k = i
                    break
                }
            }
            if k != -1{
                followUserListG.remove(at: k)
            }
            teacher.status = status
            blockedUserIdListG.append(teacher.userId)
        case (1, 2):
            var k = -1
            for i in 0..<followUserListG.count{
                if followUserListG[i].userId == teacher.userId {
                    k = i
                    break
                }
            }
            if k != -1{
                followUserListG.remove(at: k)
            }
            teacher.status = status
            favoriteUserListG.append(teacher)
        case (2, -1):
            var k = -1
            for i in 0..<favoriteUserListG.count{
                if favoriteUserListG[i].userId == teacher.userId {
                    k = i
                    break
                }
            }
            if k != -1{
                favoriteUserListG.remove(at: k)
            }
            teacher.status = status
            blockedUserIdListG.append(teacher.userId)
        case (2, 1):
            var k = -1
            for i in 0..<favoriteUserListG.count{
                if favoriteUserListG[i].userId == teacher.userId {
                    k = i
                    break
                }
            }
            if k != -1{
                favoriteUserListG.remove(at: k)
            }
            teacher.status = status
            followUserListG.append(teacher)
        default:
            break
        }
        let query = NCMBQuery(className: "Follow")
        query?.whereKey("fromUserId", equalTo: currentUserG.userId)
        query?.whereKey("toUserId", equalTo: teacher.userId)
        query?.findObjectsInBackground({ result, error in
            if error == nil{
                let objects = result as? [NCMBObject] ?? []
                for o in objects{
                    o.setObject(status, forKey: "status")
                    o.saveInBackground { error in
                        if error != nil{
                            self.showOkAlert(title: "Updating infomation error!", message: error!.localizedDescription)
                        }
                    }
                }
            } else{
                self.showOkAlert(title: "Updating infomation error!", message: error!.localizedDescription)
            }
        })
    }
    
    func didTapCellButton(tableViewCell: UITableViewCell, button: UIButton) {
        print("didTapButton was called!")
        self.createFollow(teacher.userId)
        var k = -1
        for i in 0..<waitingUserListG.count{
            if waitingUserListG[i].userId == teacher.userId {
                k = i
            }
            break
        }
        if k != -1{
            waitingUserListG.remove(at: k)
        }
        followUserListG.append(teacher)
        teacher.status = 1
        let nib4 = UINib(nibName: "FollowedTeacherInfoTableViewCell", bundle: Bundle.main)
        tableView.register(nib4, forCellReuseIdentifier: "Cell4")
        isFollowed = true
        tableView.reloadData()
        let query = NCMBQuery(className: "Follow")
        query?.whereKey("fromUserId", equalTo: currentUserG.userId)
        query?.whereKey("toUserId", equalTo: teacher.userId)
        query?.findObjectsInBackground({ result, error in
            if error == nil{
                let objects = result as? [NCMBObject] ?? []
                for o in objects{
                    o.setObject(1, forKey: "status")
                    o.saveInBackground { error in
                        if error != nil{
                            self.showOkAlert(title: "Updating infomation error!", message: error!.localizedDescription)
                        }
                    }
                }
            } else{
                self.showOkAlert(title: "Updating infomation error!", message: error!.localizedDescription)
            }
        })
    }
}

extension TeacherInfoViewController: ScheduleDelegate{
    func schedulesDidLoaded() {
        if isAbleToGoSchedule{
            self.performSegue(withIdentifier: "WatchSchedule", sender: nil)
        } else{
            isAbleToGoSchedule = true
        }
    }
    
    func allSchedulesDidLoaded() {
    }
}

//教科フィルター処理部分
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
        tableView.reloadData()
    }
}

//値渡し用
extension TeacherInfoViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Detail":
            let nextVC = segue.destination as! ReviewDetailViewController
            nextVC.review = selectedReview
            nextVC.isAbletoEdit = false
        case "GoToChat":
            let nextVC = segue.destination as! ChatViewController
            let chatRoom = ChatRoom(user: teacher)
            chatRoom.loadChats()
            chatRoom.delegate = nextVC
            nextVC.sentChatRoom = chatRoom
            break
        case "WatchSchedule":
            let nextVC = segue.destination as! CalendarViewController
            nextVC.teacher = teacher
        default:
            break
        }
    }
}

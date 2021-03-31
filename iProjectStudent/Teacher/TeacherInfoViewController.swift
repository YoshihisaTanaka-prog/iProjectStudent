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
    var subject: String!
    
    private var reviewList: [ReviewTeacher] = []
    private var size: Size!
    private var selectedReview: ReviewTeacher!
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
        // (「register(nib: UINib?, forCellReuseIdentifier: String)」を選ぶ。)
        tableView.register(nib1, forCellReuseIdentifier: "Cell1")
        tableView.register(nib2, forCellReuseIdentifier: "Cell2")
        
        setBackGround(true, true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadReview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return size.viewHeight - 50.f
        }
        else{
            return 100.f
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TeacherInfoTableViewCell
            cell.averageScoreCosmosView.rating = teacher.teacherParameter!.score
            cell.furiganaLabel.text = teacher.userIdFurigana
            self.setUserImage(&cell.userImageView, teacher)
            cell.userNameLabel.text = teacher.userName + "　先生"
            cell.collageInfoLabel.text = "東京大学   1年"
            cell.averageTitleLabel.text = "平均評価：" + 4.9.s
            cell.studentNumLabel.text = 10.s + "名"
            cell.averageScoreCosmosView.rating = 4.91
            cell.setFontColor()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! ReviewTableViewCell
            let review = reviewList[indexPath.row - 1]
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
        if(indexPath.row == 0){
            let alert = UIAlertController(title: "選んでください。", message: "", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            switch isNeedToCreateFollow(teacher.userId) {
            case nil:
                return
            case true:
                let createFollowAlertAction = UIAlertAction(title: "この先生を登録する", style: .default) { (action) in
                    if let errorText = self.createFollow(self.teacher.userId){
                        alert.dismiss(animated: true, completion: nil)
                        self.showOkAlert(title: "Error", message: errorText)
                    }
                }
                alert.addAction(createFollowAlertAction)
            default:
                let goToChatAlertAction = UIAlertAction(title: "チャットを始める。", style: .default) { _ in
                    self.performSegue(withIdentifier: "GoToChat", sender: nil)
                }
                let goToScheduleAlertAction = UIAlertAction(title: "スケジュールを見る", style: .default) { _ in
                    self.performSegue(withIdentifier: "WatchSchedule", sender: nil)
                }
                
                alert.addAction(goToChatAlertAction)
                alert.addAction(goToScheduleAlertAction)
            }
            self.present(alert, animated: true, completion: nil)
        }
        else{
            selectedReview = reviewList[indexPath.row - 1]
            self.performSegue(withIdentifier: "Detail", sender: nil)
        }
        tableView.reloadData()
    }
    
    func loadReview(){
        let query = NCMBQuery(className: "Review")
        query?.whereKey("teacherId", equalTo: teacher.userId)
        query?.findObjectsInBackground({ (result, error) in
            if(error == nil){
                self.reviewList = []
                let objects = result as! [NCMBObject]
                for object in objects {
                    self.reviewList.append(ReviewTeacher(object))
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

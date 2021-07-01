//
//  FollowingTeacherViewController.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/03/08.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class FollowingTeacherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private var tableView: UITableView!
    
    private var selectedTeacher: User!
    
    private var teachers = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100.f
        
        let nib = UINib(nibName: "ReviewTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "Cell2")
//        /Users/tanakayoshihisa/iProjectStudent/iProjectStudent/Teacher
        setBackGround(true, true)
        teachers = mixFollowList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! ReviewTableViewCell
        cell.cosmosView.alpha = 0.f // 教師の評価部分（生徒は平均評価が存在しないので不要）
        cell.score.alpha = 0.f      // 教師の評価部分（生徒は平均評価が存在しないので不要）
        cell.title.text = teachers[indexPath.row].teacherParameter!.collage + " " + transformGrade(teachers[indexPath.row].grade)
        cell.title.numberOfLines = 0
        cell.userNameLabel.text = teachers[indexPath.row].userName + "先生"
        cell.userimage.image = userImagesCacheG[teachers[indexPath.row].userId]  //ユーザー画像を設定
        
        cell.setFontColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTeacher = teachers[indexPath.row]
        self.performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Detail":
            let nectVC = segue.destination as! TeacherInfoViewController
            nectVC.teacher = selectedTeacher
        default:
            break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

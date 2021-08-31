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
        
        let nib = UINib(nibName: "TeacherListTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        setBackGround(true, true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        teachers = mixFollowList()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TeacherListTableViewCell
        let teacher = teachers[indexPath.row]
        let ud = UserDefaults.standard
        cell.teacherImageView.image = ud.image(forKey: teacher.userId)
        cell.teacherNameLabel.text = teacher.userName
        cell.teacherCollageLabel.text = teacher.teacherParameter!.collage + teacher.selection + self.transformGrade(teacher.grade)
        switch teacher.status {
        case -1:
            cell.teacherStatusLabel.text = "ブロック中"
        case 1:
            cell.teacherStatusLabel.text = "未固定"
        case 2:
            cell.teacherStatusLabel.text = "固定済み"
        default:
            cell.teacherStatusLabel.text = "???"
        }
        
        
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

}

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
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // カスタムセルの登録
        let nib1 = UINib(nibName: "TeacherInfoTableViewCell", bundle: Bundle.main)
        let nib2 = UINib(nibName: "ReviewTableViewCell", bundle: Bundle.main)
        // (「register(nib: UINib?, forCellReuseIdentifier: String)」を選ぶ。)
        tableView.register(nib1, forCellReuseIdentifier: "Cell1")
        tableView.register(nib2, forCellReuseIdentifier: "Cell2")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TeacherInfoTableViewCell
//            cell.averageScoreCosmosView.rating = teacher.teacherParameter
            return cell
        }
        else {
//            let indRow = indexPath.row - 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! ReviewTableViewCell
            
            return cell
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

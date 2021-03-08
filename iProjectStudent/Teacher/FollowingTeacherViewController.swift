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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100.f
        
        setBackGround(true, true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followUserListG.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = followUserListG[indexPath.row].userName + "先生"
        cell.imageView?.image = userImagesCacheG[followUserListG[indexPath.row].userId]!
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        cell.imageView?.center = CGPoint(x: 50, y: 50)
        cell.imageView?.layer.cornerRadius = 50.f
        cell.imageView?.clipsToBounds = true
        cell.setFontColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTeacher = followUserListG[indexPath.row]
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

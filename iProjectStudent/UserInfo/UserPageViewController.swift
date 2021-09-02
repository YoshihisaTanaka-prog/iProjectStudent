//
//  UserPageViewController.swift
//  iProjectStudent
//
//  Created by Kaori Nakamura on 2/10/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class UserPageViewController: UIViewController{
    
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var userFuriganaLabel: UILabel!
    @IBOutlet private var schoolLabel: UILabel!
    @IBOutlet private var gradeLabel: UILabel!
    @IBOutlet private var selectionLabel: UILabel!
    @IBOutlet private var myEmailLabel: UILabel!
    @IBOutlet private var parentsEmailLabel: UILabel!
    @IBOutlet private var introductionTextView: UITextView!
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "ChoiceTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.allowsSelection = false
        tableView.rowHeight = 25
        
        setBackGround(true, true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userNameLabel.text = currentUserG.userName
        myEmailLabel.text = currentUserG.mailAddress
        userFuriganaLabel.text = currentUserG.furigana
        schoolLabel.text = currentUserG.studentParameter?.schoolName
        gradeLabel.text = transformGrade(currentUserG.grade)
        //choiceTextField.text = (currentUserG.studentParameter?.choice.first ?? []).first ?? ""
        selectionLabel.text = currentUserG.selection
        parentsEmailLabel.text = currentUserG.studentParameter?.parentEmailAdress
        introductionTextView.text = currentUserG.introduction
        let ud = UserDefaults.standard
        userImageView.image = ud.image(forKey: currentUserG.userId)
        tableView.reloadData()
        
    }
    
    @IBAction func showMenu(){
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択して下さい。", preferredStyle: .actionSheet)
        let  signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground { (error) in
                if error != nil {
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    //ログアウト成功
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "RootNavigationController")
                    
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        
            }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
  

}

extension UserPageViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUserG.studentParameter!.choice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChoiceTableViewCell
        cell.choiceLabel.text = "第" + (indexPath.row + 1).jp + "志望"
        cell.choiceTextField.text = currentUserG.studentParameter!.choice[indexPath.row][0]
        cell.backgroundColor = dColor.base
        return cell
    }
    
}

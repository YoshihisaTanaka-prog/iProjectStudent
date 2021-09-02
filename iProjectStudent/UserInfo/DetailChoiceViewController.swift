//
//  DetailChoiceViewController.swift
//  iProjectStudent
//
//  Created by Ring Trap on 7/15/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class DetailChoiceViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet var choiceTextField: UITextField!
    var selectedIndex: Int!
    var choice: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choiceTextField.delegate = self
        choiceTextField.text = choice[0]
        // Do any additional setup after loading the view.
        setBackGround(true, true)
    }
    
    @IBAction func saveUserInfo(){
//        let param = currentUserG.studentParameter!.ncmb
//        param.setObject([[choiceTextField.text]], forKey: "choice")
//        param.saveInBackground { (error) in
//            if error == nil{
//                currentUserG = User(NCMBUser.current()!)
//                self.navigationController?.popViewController(animated: true)
//            } else{
//                self.showOkAlert(title: "Error", message: error!.localizedDescription)
//            }
//        }
        
        choice[0] = choiceTextField.text!
//        let preNC = self.presentingViewController as! UINavigationController
        let preNC = self.navigationController!
        let preVC = preNC.viewControllers[preNC.viewControllers.count - 2] as! EditUserPageViewController
        preVC.choice[selectedIndex] = self.choice  //ここで値渡し
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

//
//  Opening2ViewController.swift
//  opening
//
//  Created by 田中義久 on 2021/01/30.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class Opening2ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = dColor.opening
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.alpha = 0.f
        self.navigationController?.navigationBar.backgroundColor = dColor.base
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        TabBarやNavigationBarがある時の画面サイズの取得
        let size = screenSizeG["NnNt"]!
        
        screenSizeG["NnEt"] = Size(tm: size.topMargin, bm: self.view.safeAreaInsets.bottom)
        screenSizeG["EnNt"] = Size(tm: self.view.safeAreaInsets.top, bm: size.bottomMargin)
        screenSizeG["EnEt"] = Size(tm: self.view.safeAreaInsets.top, bm: self.view.safeAreaInsets.bottom)
        print("NnEt", screenSizeG["NnEt"]!.viewHeight)
        print("EnNt", screenSizeG["EnNt"]!.viewHeight)
        print("EnEt", screenSizeG["EnEt"]!.viewHeight)
        
        label.textColor = .black
        UIView.animate(withDuration: 1.5, animations: {
            self.label.textColor = .red
        }) { _ in
            if isLogInG {
                // ログイン中だったら
//                let storyboard = UIStoryboard(name: "Questionnaire", bundle: Bundle.main)
//                let rootViewController = storyboard.instantiateViewController(withIdentifier: "QuestionnaireController")
                self.loadFollowList()
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                self.present(rootViewController, animated: true, completion: nil)

            } else {
                // ログインしていなかったら
//                let storyboard = UIStoryboard(name: "Questionnaire", bundle: Bundle.main)
//                let rootViewController = storyboard.instantiateViewController(withIdentifier: "QuestionnaireController")
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                self.present(rootViewController, animated: true, completion: nil)
            }
        }
    }

}

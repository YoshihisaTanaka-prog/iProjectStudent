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
    
    private var baceView: UIView!
    private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = dColor.opening
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.alpha = 0.f
        self.navigationController?.navigationBar.backgroundColor = dColor.base
        self.view.backgroundColor = dColor.opening
        
        
        let x = screenSizeG["NnNt"]!.width
        let y = screenSizeG["NnNt"]!.screenHeight
        
        baceView = UIView(frame: CGRect(x: 0, y: 0, width: x*0.8.f, height: x*0.8.f) )
        baceView.center = CGPoint(x: x / 2.f, y: y / 2.f)
        baceView.layer.cornerRadius = x / 10.f
        baceView.clipsToBounds = true
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: x*1.6.f, height: x*0.8.f) )
        imageView.image = UIImage(named: "iconS.png")
        baceView.addSubview(imageView)
        
        self.view.addSubview(baceView)
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
        
        UIView.animate(withDuration: 0.8, animations: {
            let x = screenSizeG["NnNt"]!.width
            self.imageView.center = CGPoint(x: 0, y: x*0.4.f)
        }) { _ in
            if isLogInG {
                // ログイン中だったら
//                let storyboard = UIStoryboard(name: "Questionnaire", bundle: Bundle.main)
//                let rootViewController = storyboard.instantiateViewController(withIdentifier: "QuestionnaireController")
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

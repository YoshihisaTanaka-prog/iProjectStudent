//
//  Extensions.swift
//  ChatTest
//
//  Created by 田中義久 on 2021/01/13.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit
import NCMB

extension Int{
    public var d: Double {
        return Double(self)
    }
    public var f: CGFloat {
        return CGFloat(self)
    }
    public var s: String {
        return String(self)
    }
}

extension Double{
    public var i: Int {
        return Int(self)
    }
    public var f: CGFloat {
        return CGFloat(self)
    }
    public var s: String {
        return String(self)
    }
}

extension UIViewController{
    func showOkAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertOkAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setBackGround(_ isExistsNavigationBar: Bool, _ isExistsTabBar: Bool) {
        let _ = BackGrounvView(isExistsNavigationBar, isExistsTabBar, mainView: &self.view)
        
        let size = getScreenSize(isExsistsNavigationBar: false, isExsistsTabBar: false)!
        if isExistsNavigationBar {
            self.navigationController!.navigationBar.barTintColor = dColor.concept
            self.navigationController!.navigationBar.tintColor = dColor.font
        }
        else{
            let safeAreaView = UIView(frame: CGRect(x: 0.f, y: 0.f, width: size.width, height: size.topMargin))
            safeAreaView.backgroundColor = dColor.concept
            self.view.addSubview(safeAreaView)
            self.view.sendSubviewToBack(safeAreaView)
        }
        if isExistsTabBar {
            self.tabBarController!.tabBar.barTintColor = dColor.concept
            self.tabBarController!.tabBar.tintColor = dColor.font
            self.tabBarController!.tabBar.unselectedItemTintColor = dColor.base
        }
        else{
            let safeAreaView = UIView(frame: CGRect(x: 0.f, y: size.viewHeight + size.topMargin, width: size.width, height: size.bottomMargin))
            safeAreaView.backgroundColor = dColor.concept
            self.view.addSubview(safeAreaView)
            self.view.sendSubviewToBack(safeAreaView)
        }
    }
}

extension UIView{
    func setFontColor() {
        for view in self.subviews {
            if view is UILabel{
                let v = view as! UILabel
                v.textColor = dColor.font
                v.backgroundColor = .clear
            }
            if view is UITextField{
                let v = view as! UITextField
                v.textColor = dColor.font
                v.backgroundColor = .clear
            }
            if view is UITextView{
                let v = view as! UITextView
                v.textColor = dColor.font
                v.backgroundColor = .clear
            }
        }
    }
}

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
        self.view.setFontColor()
        
        let size = getScreenSize(isExsistsNavigationBar: false, isExsistsTabBar: false)!
        if isExistsNavigationBar {
            self.navigationController!.navigationBar.barTintColor = dColor.concept
            self.navigationController!.navigationBar.tintColor = dColor.font
        }
        else{
            let safeAreaView = UIView(frame: CGRect(x: 0.f, y: 0.f, width: size.width, height: size.topMargin))
            safeAreaView.backgroundColor = dColor.base
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
            safeAreaView.backgroundColor = dColor.base
            self.view.addSubview(safeAreaView)
            self.view.sendSubviewToBack(safeAreaView)
        }
    }
}

extension UIView{
    
    func setFontColor() {
        for view in self.subviews {
            view.setFontColor()
            if view is UILabel{
                let v = view as! UILabel
                v.textColor = dColor.font
                v.backgroundColor = .clear
            }
            if view is AccentLabel {
                let v = view as! AccentLabel
                v.textColor = dColor.font
                v.backgroundColor = dColor.accent
            }
//            if view is UIPickerView {
//                let v = view as! UIPickerView
//                v.backgroundColor = dColor.opening
//            }
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
            if view is UIButton {
                let v = view as! UIButton
                v.setTitleColor(UIColor(iRed: 255, iGreen: 255, iBlue: 255), for: .normal)
                v.backgroundColor = dColor.concept
                let h = min( v.frame.size.height / 2.f , 15.f )
                v.layer.cornerRadius = h
            }
            if view is AccentButton {
                let v = view as! AccentButton
                v.setTitleColor(UIColor(iRed: 127, iGreen: 0, iBlue: 0), for: .normal)
                v.backgroundColor = dColor.accent
                let h = min( v.frame.size.height / 2.f , 15.f )
                v.layer.cornerRadius = h
            }
            if view is WeakButton {
                let v = view as! WeakButton
                v.setTitleColor(.blue, for: .normal)
                v.backgroundColor = .clear
            }
            if view is CheckRadioButton {
                let v = view as! CheckRadioButton
                v.setTitleColor(dColor.font, for: .normal)
                v.backgroundColor = .clear
            }
        }
    }
    
}

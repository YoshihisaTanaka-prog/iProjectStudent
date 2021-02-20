//
//  Color.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/19.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit


//    Color
class OriginalCollor {
    var concept: UIColor
    var base: UIColor
    var font: UIColor
    var accent: UIColor
    init() {
        self.concept = UIColor(iRed: 55, iGreen: 180, iBlue: 255)
        self.base = UIColor(iRed: 215, iGreen: 240, iBlue: 255)
        self.font = UIColor(iRed: 0, iGreen: 0, iBlue: 102)
        self.accent = UIColor(iRed: 255, iGreen: 255, iBlue: 0)
    }
}

extension UIColor {
    
    convenience init(iRed: Int, iGreen: Int, iBlue: Int, iAlpha: Int){
        let r = iRed.f / 255.f
        let g = iGreen.f / 255.f
        let b = iBlue.f / 255.f
        let a = iAlpha.f / 255.f
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    convenience init(iRed: Int, iGreen: Int, iBlue: Int){
        let r = iRed.f / 255.f
        let g = iGreen.f / 255.f
        let b = iBlue.f / 255.f
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}


//BackGroundView
class BackGrounvView{
    var baseView = UIView()
    var backView =  UIView()
    
    init(_ isExistsNavigationBar: Bool, _ isExistsTabBar: Bool, mainView: inout UIView){
        var title = ""
        switch [isExistsNavigationBar,isExistsTabBar] {
        case [false,false]:
            title = "NnNt"
        case [true ,false]:
            title = "EnNt"
        case [false,true ]:
            title = "NnEt"
        default:
            title = "EnEt"
        }
        
        let sizeInfo = screenSizeG[title]!
        let frame = CGRect(x: 0.f, y: sizeInfo.topMargin, width: sizeInfo.width, height: sizeInfo.viewHeight)
        let miniFrame = CGRect(x: frame.width / 20.f, y: 5.f, width: frame.width * 0.9.f, height: frame.height - 10.f)
        let bigFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height)
        self.baseView = UIView(frame: miniFrame)
        self.baseView.backgroundColor = dColor.base
        self.baseView.layer.cornerRadius = 10.f
        self.backView = UIView(frame: bigFrame)
        self.backView.backgroundColor = dColor.concept
        self.backView.addSubview(self.baseView)
        mainView.addSubview(self.backView)
        mainView.sendSubviewToBack(self.backView)
        mainView.setFontColor()
    }
}

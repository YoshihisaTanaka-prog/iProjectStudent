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
        return String(format: "%.2f", self)
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
    
    func loadFollowlist(){
        let query = NCMBQuery(className: "Follow")
        query?.includeKey("fromUser")
        query?.includeKey("toUser")
        query?.whereKey("fromUser", equalTo: NCMBUser.current()!)
        query?.findObjectsInBackground({ (result, error) in
            if(error == nil){
                for follow in result as! [NCMBObject]{
                    let user = follow.object(forKey: "toUser") as! NCMBUser
                    let status = follow.object(forKey: "status") as! Int
                    if(status < 0){
                        blockUserListG.append(User(user))
                    }
                    else{
                        followUserListG.append(User(user))
                    }
                }
            }
        })
    }
    
    func isNeedToCreateFollow(_ userId: String) -> Bool?{
        let userQuery = NCMBUser.query()
        var user = NCMBUser()
        userQuery?.whereKey("objectId", equalTo: userId)
        do{
            try user = userQuery?.findObjects().first as! NCMBUser
        }catch{
            return nil
        }
        let query = NCMBQuery(className: "Follow")
        query?.includeKey("fromUser")
        query?.includeKey("toUser")
        query?.whereKey("fromUser", equalTo: NCMBUser.current()!)
        query?.whereKey("toUser", equalTo: user)
        var num = 0
        do {
            num = try query!.findObjects().count
        } catch {
            return nil
        }
        if num == 0 {
            return true
        }
        return false
    }
    
    func createFollow(_ userId: String) -> String?{
        let userQuery = NCMBUser.query()
        var user = NCMBUser()
        userQuery?.whereKey("objectId", equalTo: userId)
        do{
            try user = userQuery?.findObjects().first as! NCMBUser
        }catch{
            return error.localizedDescription
        }
        let object1 = NCMBObject(className: "Follow")
        object1?.setObject(NCMBUser.current()!, forKey: "fromUser")
        object1?.setObject(user, forKey: "toUser")
        object1?.setObject(1, forKey: "status")
        var error: NSError? = nil
        object1?.save(&error)
        if(error != nil){
            return error!.localizedDescription
        }
        let object2 = NCMBObject(className: "Follow")
        object2?.setObject(NCMBUser.current()!, forKey: "toUser")
        object2?.setObject(user, forKey: "fromUser")
        object2?.setObject(0, forKey: "status")
        object2?.save(&error)
        if(error != nil){
            return error!.localizedDescription
        }
        followUserListG.append(User(user))
        return nil
    }
}

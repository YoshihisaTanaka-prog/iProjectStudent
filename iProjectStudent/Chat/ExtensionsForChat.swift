//
//  ExtensionsForChat.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/08/23.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB


extension UIViewController{
    func loadChatRoom(){
        chatRoomsG = [ChatRoom()]
        let query = NCMBQuery(className: "UserChatRoom")
        if reportedDataG["ChatRoom"] != nil && reportedDataG["ChatRoom"] != []{
            query?.whereKey("objectId", notContainedIn: reportedDataG["ChatRoom"]!)
        }
        query?.includeKey("lastTimeMessageSent")
        query?.order(byDescending: "lastTimeMessageSent")
        query?.whereKey("userId", equalTo: currentUserG.userId)
        query?.findObjectsInBackground({ result, error in
            if error == nil{
                let objs = result as? [NCMBObject] ?? []
                for o in objs{
                    let chatRoomId = o.object(forKey: "chatRoomId") as! String
                    let object = NCMBObject(className: "ChatRoom", objectId: chatRoomId)!
                    var error: NSError? = nil
                    object.fetch(&error)
                    if error == nil{
                        if let c = ChatRoom(chatRoom: object, self){
                            chatRoomsG.append(c)
                        }
                    } else {
                        self.showOkAlert(title: "Loading chat room error", message: error!.localizedDescription)
                    }
                }
//                並び替えのためのコード
                chatRoomsG = chatRoomsG.sorted(by: {$0.lastTimeMessageSent > $1.lastTimeMessageSent})
            } else{
                self.showOkAlert(title: "Loading chat room error", message: error!.localizedDescription)
            }
        })
    }
}

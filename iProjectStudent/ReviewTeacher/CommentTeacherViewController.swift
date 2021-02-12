//
//  CommentTeacherViewController.swift
//  iProjectStudent
//
//  Created by user on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import Cosmos

class CommentTeacherViewController: UIViewController {
    @IBOutlet var ratingScore: CosmosView!
    @IBOutlet var commentBox: UITextView!
    @IBOutlet var sendButton: UIButton!
    
    
    var isAbletoEdit: Bool!
    var objectId: String?
    var numofBeforeScore: Double = 1
    var numofAfterScore: Double = 1
    var isCreate: Bool = false
    var review: ReviewTeacher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //描画の設定
        if objectId == nil{
            isCreate = true
            sendButton.setTitle("送信", for: .normal)
        }else{
            let query = NCMBQuery(className: "Review")
            query?.whereKey("objectId", equalTo:objectId!)
            query?.findObjectsInBackground({ (rating, error) in
                if error == nil{
                    let objects = rating as! [NCMBObject]
                    let object = objects[0]
                    self.review = ReviewTeacher(object)
                    self.numofBeforeScore = self.review!.score
                    self.ratingScore.rating = self.review!.score
                    self.commentBox.text = self.review!.comment
                }else {
                    self.showOkAlert(title:"Alert", message:error!.localizedDescription)
                    
                }
            })
            
        }
        //描画の設定ここまで
        
        // ここからコメントの編集設定をする
        
        // スター半分の評価ができるようにする(本人だけが編集できるよう設定してある）
        ratingScore.settings.fillMode = .half
        if isAbletoEdit {
            // ビューから指を離した時に呼ばれる
            ratingScore.didFinishTouchingCosmos = { rating in
                // ratingでレートの値（Double）が受け取れる
                self.numofAfterScore = rating
            }

        } else{
            sendButton.setTitle("編集不可", for: .normal)
            ratingScore.settings.updateOnTouch = false
        }
        
    }
    @IBAction func sendReview(){
        if isAbletoEdit{
            if isCreate {
                let object = NCMBObject(className: "Review")
                object?.setObject(numofAfterScore, forKey: "Reviewscore")
                //ここにコメントボックスの定義をする
                object?.saveInBackground({ (error) in
                    if error == nil{
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.showOkAlert(title:"エラー", message:error!.localizedDescription)
                    }
                })
                
                
            }else{
                let object = NCMBObject(className: "Review",objectId:self.objectId!)
                object?.setObject(numofAfterScore, forKey: "Reviewscore")
                //コメントボックスのアップデートをする
                object?.saveInBackground({ (error) in
                    if error == nil{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.showOkAlert(title:"エラー", message:error!.localizedDescription)
                    }
                })
            }
        }
    }


}

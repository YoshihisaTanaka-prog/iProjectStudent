//
//  DetailTelectureViewController.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/08/02.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class DetailTelectureViewController: UIViewController, UITableViewDataSource {
    
    var lecture: Lecture!
    
    private var reviewList = [Review]()
    private var isAbleToMove = false
    
    @IBOutlet private var subjectLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var detailTextView: UITextView!
    @IBOutlet private var reviewButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        subjectLabel.text = lecture.subjectName
        detailTextView.text = lecture.detail
        detailTextView.isEditable = false
        detailTextView.isSelectable = false
        tableView.tableFooterView = UIView()
        
        setBackGround(true, true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isAbleToMove = false
        reviewButton.isEnabled = true
        
        let query = NCMBQuery(className: "Review")
        query?.whereKey("teacherId", equalTo: lecture.teacher.userId)
        query?.whereKey("subject", equalTo: lecture.subject)
        query?.findObjectsInBackground({ result, error in
            if error == nil{
                let objects = result as? [NCMBObject] ?? []
                self.reviewList = []
                for o in objects{
                    self.reviewList.append(Review(o))
                }
                DispatchQueue.main.async {
                    if self.isAbleToMove{
                        self.performSegue(withIdentifier: "Review", sender: nil)
                    } else{
                        self.isAbleToMove = true
                    }
                }
            } else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lecture.timeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let date = lecture.timeList[indexPath.row]
        
        cell.textLabel?.text = date.ymdJp + date.hmJp
        
        cell.setFontColor()
        
        return cell
    }
    
    @IBAction func tappedReview(){
        if isAbleToMove{
            self.performSegue(withIdentifier: "Review", sender: nil)
        } else{
            isAbleToMove = true
            reviewButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view2 = segue.destination as! ReviewListViewController
        view2.reviewList = reviewList
    }
    
}

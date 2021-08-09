//
//  ReviewListViewController.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/08/02.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class ReviewListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var reviewList = [Review]()
    private var selectedReview: Review!
    
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib2 = UINib(nibName: "ReviewTableViewCell", bundle: Bundle.main)
        tableView.register(nib2, forCellReuseIdentifier: "Cell2")
        tableView.rowHeight = 100.f
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        setBackGround(true, true)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! ReviewTableViewCell
        
        let review = reviewList[indexPath.row]
        cell.userimage.image = UIImage(named: "studentNoImage.png")
        cell.userNameLabel.text = review.student.userName
        cell.title.text = review.title
        cell.cosmosView.rating = review.score
        for v in cell.score.subviews {
            v.removeFromSuperview()
        }
        cell.score.text = review.score.s
        cell.setFontColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedReview = reviewList[indexPath.row]
        self.performSegue(withIdentifier: "Review", sender: nil)
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! ReviewDetailViewController
        nextVC.isAbletoEdit = false
        nextVC.review = selectedReview
    }

}

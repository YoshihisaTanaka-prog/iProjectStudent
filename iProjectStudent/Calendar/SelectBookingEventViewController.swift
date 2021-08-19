//
//  SelectBookingEventViewController.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/08/06.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class SelectBookingEventViewController: UIViewController {
    
    var beforeVC: NormalEventViewController!
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 180.f
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "BookingTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        setBackGround(true, true)
    }
    
    @IBAction private func tappedSave(){
        self.navigationController?.popViewController(animated: true)
    }

}

//テーブルビュー関連
extension SelectBookingEventViewController: UITableViewDataSource, UITableViewDelegate, BookingDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beforeVC.bookingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! BookingTableViewCell
        cell.tag = indexPath.row
        cell.bookingData = beforeVC.bookingList[indexPath.row]
        cell.setUpUI()
        cell.delegate = self
        cell.backgroundColor = dColor.base
        return cell
    }
    
    func tappedBookingSelection(cell: UITableViewCell, button: UIButton) {
        beforeVC.bookingList[cell.tag].isSelectFirst = button.tag == 1
        tableView.reloadData()
        beforeVC.didSelectBookingSchedule = true
    }
}

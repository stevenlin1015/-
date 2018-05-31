//
//  SettingsTableViewController.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/5/31.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    
    //MARK: IBOutlet
    /*
     基本設定 area.
     */
    
    
    //MARK: IBOutlet
    /*
     聯絡項目 area.
     */
    @IBAction func contactDeveloperButton(_ sender: UIButton) {
        //display an alert instead of launch Mail app.
        let emailUrl = URL(string: "04160410@ms1.mcu.edu.tw")
        UIApplication.shared.open(emailUrl!, options: [:], completionHandler: nil)
    }
    @IBAction func visitDeveloperWebsiteButton(_ sender: UIButton) {
        //Navigate to website of developer's blog.
        let developerWebsite = URL(string: "https://codingonmac.blogspot.com")
        UIApplication.shared.open(developerWebsite!, options: [:], completionHandler: nil)
    }
    @IBAction func bugReportButton(_ sender: UIButton) {
        //create an alert sheet to send problems.
        let alertSheet = UIAlertController(title: "問題回報", message: "請選擇您遇到的狀況", preferredStyle: .actionSheet)
        let textReportAction = UIAlertAction(title: "字體顯示不明確", style: .default, handler: nil)
        let dataReportAction = UIAlertAction(title: "資料無法取得", style: .default, handler: nil)
        let crashReportAction = UIAlertAction(title: "程式無預期當機", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertSheet.addAction(textReportAction)
        alertSheet.addAction(dataReportAction)
        alertSheet.addAction(crashReportAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: TableView datasource
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected section \(indexPath.section); row \(indexPath.row)")
        
    }


}

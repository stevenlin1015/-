//
//  SettingViewController.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/5/27.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    //MARK: IBOutlet and property.
    @IBOutlet var sideMenu: UIView!
    @IBOutlet var sideMenuLeadingConstant: NSLayoutConstraint!
    var sideMenuIsOpened = false
    @IBOutlet var dimView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: SideMenu Action
    @IBAction func isOpenedSideMenu(_ sender: UIBarButtonItem) {
        if sideMenuIsOpened {
            sideMenuLeadingConstant.constant = -160
            UIView.animate(withDuration: 0.5, animations: {
                self.dimView.alpha = 0.0
                self.view.layoutIfNeeded()
            })
        } else {
            sideMenuLeadingConstant.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.dimView.alpha = 0.5
                self.view.layoutIfNeeded()
            })
        }
        sideMenuIsOpened = !sideMenuIsOpened
    }
    
    @IBAction func menuButtonSelected(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "主頁"?:
            print("Matches 主頁")
            let settingVC = storyboard?.instantiateViewController(withIdentifier: "MainPageViewController")
            self.present(settingVC!, animated: true, completion: nil)
        case "政府公告"?:
            print("Matches 政府公告")
            let govNoticeVC = storyboard?.instantiateViewController(withIdentifier: "GovernmentNoticeViewController")
            self.present(govNoticeVC!, animated: true, completion: nil)
        case "設定"?:
            print("Matches 設定")
            sideMenuLeadingConstant.constant = -160
            UIView.animate(withDuration: 0.5, animations: {
                self.dimView.alpha = 0.0
                self.view.layoutIfNeeded()
            })
        default:
            print("no matches")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

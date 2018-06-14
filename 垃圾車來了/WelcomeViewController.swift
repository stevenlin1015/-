//
//  WelcomeViewController.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/6/14.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet var welcomeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: Animation Chaining
        UIView.animate(withDuration: 0.8, animations: {
            self.welcomeImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                self.welcomeImageView.transform = CGAffineTransform(scaleX: 20.0, y: 20.0)
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.backgroundColor = .white
                }, completion: { (finished) in
                    self.performSegue(withIdentifier: "performMainPageViewController", sender: self)
                })
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

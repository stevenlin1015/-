//
//  BackgroundImageViewController.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/6/7.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import UIKit

class BackgroundImageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let images = ["Background-MainPage"]
    
    //MARK: IBOutlet and Properties.
    @IBOutlet var backgroundImageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImageTableView.dataSource = self
        backgroundImageTableView.delegate = self

        self.navigationItem.title = "背景圖片"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! BackgroundImageTableViewCell
        
        cell.backgroundImage.image = UIImage(named: images[indexPath.row])
        cell.backgroundImage.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertMessage = UIAlertController(title: "提示", message: "需要購買正式版才可以享受客製化背景喔！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好", style: .default, handler: nil)
        alertMessage.addAction(okAction)
        present(alertMessage, animated: true, completion: nil)
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

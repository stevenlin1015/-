//
//  ViewController.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/5/14.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: IBOutlet and property
    @IBOutlet var sideMenu: UIView!
    @IBOutlet var sideMenuLeadingConstant: NSLayoutConstraint!
    var sideMenuIsOpened = false
    @IBOutlet var dustCartTableView: UITableView!
    var cartToPass: DustCart?
    
    //MARK: Data Struct of json
    struct DustCart: Decodable {
        var lineid: String
        var car: String
        var time: String
        var location: String
        var longitude: String
        var latitude: String
        var cityid: String
        var cityname: String
    }
    var dustcarts: [DustCart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        //initial setup for UITableView
        dustCartTableView.dataSource = self
        dustCartTableView.delegate = self
        
        fetchData()
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
                self.view.layoutIfNeeded()
            })
        } else {
            sideMenuLeadingConstant.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
        sideMenuIsOpened = !sideMenuIsOpened
    }
    
    //MARK: TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dustcarts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dustCartCell", for: indexPath) as! MainPageInfoTableViewCell

        if dustcarts.count == 0 {
            print("no data coming in.")
        } else {
            cell.distanceFromUserLabel.text = "經緯度：" + dustcarts[indexPath.row].longitude + " " + dustcarts[indexPath.row].latitude
            cell.licensePlateNumberLabel.text = "車牌：" + dustcarts[indexPath.row].car
            cell.currentLocationLabel.text = "目前位置：" + dustcarts[indexPath.row].location
        }
        return cell
    }
    
    /*
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let selectedPlayer = player[indexPath.row]
     
     performSegue(withIdentifier: "player", sender: selectedPlayer)
     }
     */

    var selectCart: DustCart?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: \(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailViewSegue" {
            if let indexPath = dustCartTableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as? DetailViewController
                destinationViewController?.car = dustcarts[indexPath.row].car
            }
            
        }
    }
    
    //MARK: Fetch data Function.
    func fetchData() {
        let url = URL(string: "http://data.ntpc.gov.tw/od/data/api/28AB4122-60E1-4065-98E5-ABCCB69AACA6?$format=json")
        
        let task = URLSession.shared.dataTask(with: url!) { (jsonData, response, error) in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let data = jsonData, let carts = try? decoder.decode([DustCart].self, from: data) {
                for cart in carts {
                    self.dustcarts.append(cart)
                    DispatchQueue.main.async {
                        self.dustCartTableView.reloadData()
                    }
                }
            } else {
                print("error")
            }
        }
        task.resume()
    }
}

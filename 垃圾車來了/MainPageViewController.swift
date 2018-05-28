//
//  ViewController.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/5/14.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import UIKit
import CoreLocation

class MainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    //MARK: IBOutlet and property
    @IBOutlet var sideMenu: UIView!
    @IBOutlet var sideMenuLeadingConstant: NSLayoutConstraint!
    var sideMenuIsOpened = false
    @IBOutlet var dustCartTableView: UITableView!
    var cartToPass: DustCart?
    var distanceRepresentInMeter: CLLocationDistance!
    
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
        displayUserLocation()
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
    @IBAction func menuButtonSelected(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "主頁"?:
            print("Matches 主頁")
            sideMenuLeadingConstant.constant = -160
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        case "政府公告"?:
            print("Matches 政府公告")
           let govNoticeVC = storyboard?.instantiateViewController(withIdentifier: "GovernmentNoticeViewController")
           self.present(govNoticeVC!, animated: true, completion: nil)
        case "設定"?:
            print("Matches 設定")
            let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingViewController")
            self.present(settingVC!, animated: true, completion: nil)
        default:
            print("no matches")
        }
    }
    
    
    //MARK: Fetch user Position.
    var userLocationManager: CLLocationManager!
    func displayUserLocation() {
        userLocationManager = CLLocationManager()
        userLocationManager.delegate = self
        userLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        userLocationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            userLocationManager.startUpdatingHeading()
            userLocationManager.startUpdatingLocation()
            
            print("Current User Location Data: \(userLocationManager.location)")
        }
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
            //calculate distance from user location
            let currentUserLocation = CLLocation(latitude: (userLocationManager.location?.coordinate.latitude)!, longitude: (userLocationManager.location?.coordinate.longitude)!)
            let dustCartLocation = CLLocation(latitude: Double(dustcarts[indexPath.row].latitude)!, longitude: Double(dustcarts[indexPath.row].longitude)!)
            distanceRepresentInMeter = currentUserLocation.distance(from: dustCartLocation)
            print("距離：\(Double(distanceRepresentInMeter)) 公尺")
            cell.distanceFromUserLabel.text = "距離你： \(Int(distanceRepresentInMeter)) 公尺。"
            cell.licensePlateNumberLabel.text = "車牌：" + dustcarts[indexPath.row].car
            cell.currentLocationLabel.text = "目前位置：" + dustcarts[indexPath.row].location
        }
        
        cell.selectionStyle = .none
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

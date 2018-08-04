//
//  ViewController.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/5/14.
//  Copyright © 2018年 林松賢. All rights reserved.
//
//

import UIKit
import CoreLocation
import UserNotifications

class MainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    //MARK: IBOutlet and property
    @IBOutlet var sideMenu: UIView!
    @IBOutlet var sideMenuLeadingConstant: NSLayoutConstraint!
    var sideMenuIsOpened = false
    @IBOutlet var dustCartTableView: UITableView!
    var cartToPass: DustCart?
    var distanceRepresentInMeter: CLLocationDistance!
    @IBOutlet var dimView: UIView!
    @IBOutlet var greetingTitleLabel: UILabel!
    
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
    var dustcartsSorted: [DustCartModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        //initial setup for UITableView
        dustCartTableView.dataSource = self
        dustCartTableView.delegate = self
        //fetch data
        displayUserLocation()
        fetchData()
        //MARK: setup greeting label to user according to date time on device.
        setupGreetingTitleLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Notification Object.
    func RemindToThrowGarbage() {
        let content = UNMutableNotificationContent()
        content.title = "📣準備打包垃圾囉！"
        content.body = "貼心提醒：垃圾車開始作業，別忘了待會將垃圾拿出來倒哦。"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: "testRequest", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            print("成功建立通知")
        }
    }

    //MARK: Date time configuration.
    func setupGreetingTitleLabel() {
        let hourTime = Calendar.current.component(.hour, from: Date())
        print("Current hour is \(hourTime)")
        switch hourTime {
        case 5...10:
            greetingTitleLabel.text = "早安！"
        case 11...15:
            greetingTitleLabel.text = "午安！"
        case 16...24,0...4:
            greetingTitleLabel.text = "晚安！"
        default:
            print("您好！")
        }
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
            sideMenuLeadingConstant.constant = -160
            UIView.animate(withDuration: 0.5, animations: {
                self.dimView.alpha = 0.0
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
    
    //MARK: Refresh TableView
    @IBAction func refreshButtonClicked(_ sender: UIBarButtonItem) {
        dustcartsSorted = []
        dustcarts = []
        fetchData()
        //Setup Timer of 5 sec. and push local notifications to user.
        RemindToThrowGarbage()
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
            
            print("Current User Location Data: \(String(describing: userLocationManager.location))")
        }
        
    }
    
    //MARK: TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dustcartsSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dustCartCell", for: indexPath) as! MainPageInfoTableViewCell

        if dustcartsSorted.count == 0 {
            print("no data coming in.")
        } else {
            cell.distanceFromUserLabel.text = convertMeterToKilometer(meter: dustcartsSorted[indexPath.row].distanceFromUser)
            cell.licensePlateNumberLabel.text = "車牌：" + dustcartsSorted[indexPath.row].car
            cell.currentLocationLabel.text = "目前位置：" + dustcartsSorted[indexPath.row].location
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailViewSegue" {
            if let indexPath = dustCartTableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as? DetailViewController
                destinationViewController?.car = dustcartsSorted[indexPath.row].car
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
                DispatchQueue.main.async {
                    self.sortArrayByDistance()
                    self.dustCartTableView.reloadData()
                }
            } else {
                print("error")
                let noInternetConnectionAlertView = UIAlertController(title: "無法取得資料", message: "網際網路無法連線，請確認行動網路/Wi-Fi屬於可連線狀態。", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "好", style: .default, handler: nil)
                noInternetConnectionAlertView.addAction(confirmAction)
                self.present(noInternetConnectionAlertView, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    //MARK: Sort dustcarts location by distance.
    func sortArrayByDistance() {
        for dustcart in dustcarts {
            //計算使用者與垃圾車距離
            let currentUserLocation = CLLocation(latitude: (userLocationManager.location?.coordinate.latitude)!, longitude: (userLocationManager.location?.coordinate.longitude)!)
            let dustCartLocation = CLLocation(latitude: Double(dustcart.latitude)!, longitude: Double(dustcart.longitude)!)
            distanceRepresentInMeter = currentUserLocation.distance(from: dustCartLocation)
            
            //assign values
            var cart: DustCartModel = DustCartModel(lineid: "", car: "", time: "", location: "", longitude: "", latitude: "", cityid: "", cityname: "", distanceFromUser: 0)
            cart.lineid = dustcart.lineid
            cart.car = dustcart.car
            cart.time = dustcart.time
            cart.location = dustcart.location
            cart.longitude = dustcart.longitude
            cart.latitude = dustcart.latitude
            cart.cityid = dustcart.cityid
            cart.cityname = dustcart.cityname
            cart.distanceFromUser = Int(distanceRepresentInMeter)
            //將加入距離差的資料加入新的陣列
            dustcartsSorted.append(cart)
        }
        //根據距離由近而遠排序
        dustcartsSorted.sort(by: {$0.distanceFromUser < $1.distanceFromUser})
    }
    
    //MARK: Calculate distance between meter and kilometer.
    func convertMeterToKilometer(meter : Int) -> String {
        var convertedDistance = meter
        if convertedDistance >= 1000 {
            convertedDistance /= 1000
            return "距離你： \(convertedDistance) 公里。"
        } else {
            return "距離你： \(convertedDistance) 公尺。"
        }
    }
    
}

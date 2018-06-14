//
//  DetailViewController.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/5/17.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    //MARK:  IBOutlet and property
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var infoTableView: UITableView!
    var car: String?
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

        // Do any additional setup after loading the view.
        infoTableView.dataSource = self
        infoTableView.delegate = self
        
        fetchData()
        displayUserLocation()
        infoTableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dustCartDetailCell", for: indexPath) as! DetailViewTableViewCell
        
        
        for dustcart in self.dustcarts {
            if dustcart.car == self.car! {
                
                //Set up annotation of DustCart
                let dustCartAnnotation = MKPointAnnotation()
                dustCartAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(dustcart.latitude)!, longitude: Double(dustcart.longitude)!)
                dustCartAnnotation.title = dustcart.car
                dustCartAnnotation.subtitle = dustcart.location
                
                mapView.addAnnotation(dustCartAnnotation)
                mapView.setCenter(dustCartAnnotation.coordinate, animated: true)
                let regionToDisplay = MKCoordinateRegionMakeWithDistance(
                    dustCartAnnotation.coordinate, 500, 500);
                mapView.region = MKCoordinateRegion(center: regionToDisplay.center, span: regionToDisplay.span)
                //calculate distance from user location
                let currentUserLocation = CLLocation(latitude: (userLocationManager.location?.coordinate.latitude)!, longitude: (userLocationManager.location?.coordinate.longitude)!)
                let dustCartLocation = CLLocation(latitude: dustCartAnnotation.coordinate.latitude, longitude: dustCartAnnotation.coordinate.longitude)
                distanceRepresentInMeter = currentUserLocation.distance(from: dustCartLocation)
                print("距離：\(Double(distanceRepresentInMeter)) 公尺")
                
                switch indexPath.row {
                case 0:
                    cell.informationLabel.text = "距離您 \(Int(distanceRepresentInMeter)) 公尺"
                case 1:
                    cell.informationLabel.text! = "車牌號碼：" + dustcart.car
                case 2:
                    cell.informationLabel.text! = "垃圾車目前位置：" + dustcart.location
                case 3:
                    cell.informationLabel.text! = "清運路線編號：" + dustcart.lineid
                case 4:
                    cell.informationLabel.text! = "行政區歸屬：" + dustcart.cityname
                case 5:
                    cell.informationLabel.text! = "上一次更新時間：" + dustcart.time
                default:
                    cell.informationLabel.text! = "no value."
                }
            }
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
                        self.infoTableView.reloadData()
                    }
                }
            } else {
                print("error")
            }
        }
        task.resume()
    }

}

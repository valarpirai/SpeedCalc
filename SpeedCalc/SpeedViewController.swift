//
//  FirstViewController.swift
//  SpeedCalc
//
//  Created by valar on 28/11/16.
//  Copyright © 2016 valar. All rights reserved.
//

import UIKit
import CoreLocation

class SpeedViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var SpeedText: UILabel!
    @IBOutlet weak var latlongText: UILabel!
    @IBOutlet weak var speedFormat: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var currentFormat = 0;
    var speed = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
//        label.font=[UIFont fontWithName:@"DBLCDTempBlack" size:60.0];
        SpeedText.font = UIFont( name: "DBLCDTempBlack", size: 60.0);
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(SpeedViewController.changeSpeedFormat))
        speedFormat.userInteractionEnabled = true
        speedFormat.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(SpeedViewController.changeSpeedFormat))
        SpeedText.userInteractionEnabled = true
        SpeedText.addGestureRecognizer(tap)
        
        SpeedText.text = String(format: "%.0f", mileToKm(speed));
        addressLabel.text = "";
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
        latlongText.text = "Unable to get location please check settings"
        
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updating location")
        
        print(locations)
        speed = (manager.location?.speed)!;
        
        if(speed <= 0) {
            speed = 0
        }
        
        if(currentFormat == 0) {
            SpeedText.text = String(format: "%.0f", mileToKm(speed));
        } else {
            SpeedText.text = String(format: "%.0f", speed);
        }
        
        let lat = (manager.location?.coordinate.latitude)!
        let long = (manager.location?.coordinate.longitude)!
        
        latlongText.text = String(format: "Lat: %.6f, Long: %.6f", lat, long)
        
        let location = CLLocation(latitude: lat, longitude: long)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            if(placemarks == nil) {
                print("Unable to get location")
                return
            }
            
            if let placeMark = (placemarks?[0])! as? CLPlacemark
            {
                
            // Address dictionary
//            print(placeMark.addressDictionary)
            
                let locationName = placeMark.addressDictionary!["FormattedAddressLines"]
                let name = locationName?.componentsJoinedByString(", ")
                print(name)
                self.addressLabel.text = name
            } else {
                print("Unable to get address string")
            }
            
        })
    
    }
    
    func changeSpeedFormat() {
        if(currentFormat == 0) {
            currentFormat = 1
            speedFormat.text = "Mph"
            SpeedText.text = String(format: "%.0f", speed);
        } else {
            currentFormat = 0
            speedFormat.text = "Kmph"
            SpeedText.text = String(format: "%.0f", mileToKm(speed));
        }
    }
    
    func mileToKm( mile : (Double) ) -> Double {
        return 1.6 * mile;
    }
    
    func KmToMile( km : (Double) ) -> Double {
        return 0.6 * km;
    }

}


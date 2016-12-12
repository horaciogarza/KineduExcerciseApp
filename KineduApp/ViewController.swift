//
//  ViewController.swift
//  KineduApp
//
//  Created by Horacio Garza on 12/6/16.
//  Copyright © 2016 HoracioGarza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class ViewController: UIViewController {

    
    //MARK: Variables Declaration
    @IBOutlet var totalUsersPremiumLabel: UILabel!
    @IBOutlet var moreDetailsButton: UIButton!
    @IBOutlet var npsFreemium: UILabel!
    @IBOutlet var npsPremium: UILabel!
    @IBOutlet var totalUsersFreeLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    var swiftyJSONObj:JSON!
    var kineduVersions = [String]()
    var npsJSONAsObject = [NPSObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        moreDetailsButton.layer.cornerRadius = 5
       
        //Segmented Control Attributes
        let attr = NSDictionary(object: UIFont(name: "GothamRounded-Bold", size: 15.0)!, forKey: NSFontAttributeName as NSCopying)
        self.segmentedControl.setTitleTextAttributes(attr as? [AnyHashable: Any] , for: .normal)
        self.segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState.selected)
        self.segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blue], for: UIControlState.normal)
        
        self.segmentedControl.layer.borderColor = UIColor.lightGray.cgColor //UIColor.gray
        self.segmentedControl.layer.borderWidth = 1
        self.segmentedControl.layer.cornerRadius = 5
        
        
        //Gets the JSONFromAPI
        getJSONFromAPI(){
            
        }
        
        
    }
    
    //MARK: KineduAPI
    func getJSONFromAPI(onCompletion:  @escaping () -> Void){
        Alamofire.request("http://demo.kinedu.com/bi/nps").responseJSON { response in
            
            print(response.response ?? "There's no response")
            print(response.data ?? "No data")
            print(response.result)
            
            if let jsonObj = response.result.value {
                
                
                self.swiftyJSONObj = JSON(jsonObj)
                
                for (_,subJson):(String, JSON) in self.swiftyJSONObj {
                    
                    
                    //Sets the JSON
                    let id = subJson["id"].int
                    let nps = subJson["nps"].int
                    let days_since_signup = subJson["days_since_signup"].int
                    let user_plan = subJson["user_plan"].string
                    let activity_views = subJson["activity_views"].int
                    
                        //Build
                    let version = subJson["build"]["version"].string
                    let releaseDate = subJson["build"]["release_date"].string
                    
                    
                    let objectToAppend = NPSObject(id: Int64(id!), nps: Int8(nps!), days_since_signup: days_since_signup!, user_plan: user_plan!, activity_views: activity_views!, build: Build(version: version!, release_date: releaseDate!))
                    self.npsJSONAsObject.append(objectToAppend)
                    
                    
                    //Obtain only the different versions
                    if !self.kineduVersions.contains(version!){
                        self.kineduVersions.append(version!)
                    }
                }
                
                //Re-initializes the UISegmented Control
                self.segmentedControl.removeAllSegments()
                
                //Prints each version and
                for version in self.kineduVersions{
                    print(version)
                    DispatchQueue.main.async{
                        self.segmentedControl.insertSegment(withTitle: version, at: 0, animated: true)
                        
                    }
                }
                
                onCompletion()
            }else{
                
                print("Something went wrong. \n \(response.response)")
                
            }
        
            
        }
    }

    
    func setnpsJSONAsObject(for userPlan:String) -> String {
        let selectedValue = self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)
        
        //Calculate the NPS
        
        var countOfScores = 0
        var npsPromoters = 0
        var npsDetractors = 0
        var npsPassives = 0
        
        
        
        for item in npsJSONAsObject{
            
            
            if item.build.version == selectedValue && item.user_plan == userPlan {
                
            
                countOfScores = countOfScores + 1
                
                //Classifies by Detractors, Passives or Promoters
                if (item.nps >= 0 && item.nps <= 6) {
                    
                    npsDetractors = npsDetractors + 1
                    
                }else if(item.nps == 7 || item.nps == 8){
                    npsPassives = npsPassives + 1
                }else{
                    
                    npsPromoters = npsPromoters + 1
                }
            }
        } //End of 'for' statement.
    
        print("Passives: \(npsPassives), Detractors: \(npsDetractors), Promoters: \(npsPromoters)")
        
        //Get the percentage
        
        let detractorsPercent = (npsDetractors * 100) / countOfScores
        let promotersPercent = (npsPromoters * 100) / countOfScores
        let neutralPercent = (npsPassives * 100) / countOfScores
        print("\(detractorsPercent) \(promotersPercent) \(neutralPercent)")
        
        
        //Update users-labels
        DispatchQueue.main.async {
            if userPlan == "freemium"{
                self.totalUsersFreeLabel.text = "Out of \(countOfScores) users"
            }else{
                self.totalUsersPremiumLabel.text = "Out of \(countOfScores) users"
            }
        }
        
        return String(promotersPercent - detractorsPercent)
    }

    
    @IBAction func segmentHasChanged(_ sender: Any) {
        let freemiumNPSScore = self.setnpsJSONAsObject(for: "freemium")
        let premiumNPSScore = self.setnpsJSONAsObject(for: "premium")
        
        DispatchQueue.main.async {
            self.npsFreemium.text = freemiumNPSScore
            self.npsPremium.text = premiumNPSScore
        }
        
    }
    
} //End of class

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    fileprivate func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

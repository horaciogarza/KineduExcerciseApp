//
//  ViewController.swift
//  KineduApp
//
//  Created by Horacio Garza on 12/6/16.
//  Copyright © 2016 HoracioGarza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var moreDetailsButton: UIButton!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        moreDetailsButton.layer.cornerRadius = 5
        let attr = NSDictionary(object: UIFont(name: "GothamRounded-Bold", size: 15.0)!, forKey: NSFontAttributeName as NSCopying)
        
        //Segmented Control Attributes
        segmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState.selected)
        
        
        segmentedControl.layer.borderColor = UIColor(red: 218, green: 218, blue: 218, alpha: 1).cgColor //UIColor.gray
        segmentedControl.layer.borderWidth = 10
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
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


//
//  SettingsViewController.swift
//  tips
//
//  Created by Cory Thompson on 12/12/15.
//  Copyright © 2015 Cory Thompson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var colorThemeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let intPercentageSelectedIndex = defaults.integerForKey("tipPercentageSelection")
        let intColorThemeIndex = defaults.integerForKey("colorThemeSelection")
        tipControl.selectedSegmentIndex = intPercentageSelectedIndex
        colorThemeControl.selectedSegmentIndex = intColorThemeIndex

        switch intColorThemeIndex
        {
            case 0:
                ViewController.fromDarkToLight(self.view)
            case 1:
                ViewController.fromLightToDark(self.view)
            default:
                print("Error in settings color selector")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "tipPercentageSelection")
        defaults.setInteger(colorThemeControl.selectedSegmentIndex, forKey: "colorThemeSelection")
        defaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onColorThemeChanged(sender: AnyObject) {

        if let getThemeControllerIndex = colorThemeControl.selectedSegmentIndex as? Int
        {
            switch getThemeControllerIndex
            {
                case 0:
                    ViewController.fromDarkToLight(self.view)
                case 1:
                    ViewController.fromLightToDark(self.view)
                default:
                    print("Error in settings color selector")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

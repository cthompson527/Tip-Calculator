//
//  ViewController.swift
//  tips
//
//  Created by Cory Thompson on 12/9/15.
//  Copyright © 2015 Cory Thompson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        billField.becomeFirstResponder()
        fromLightToDark()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Load the saved state */
        let defaults = NSUserDefaults.standardUserDefaults()
        if let intPercentageSelectedIndex = defaults.objectForKey("tipPercentageSelection") as? Int
        {
            tipControl.selectedSegmentIndex = intPercentageSelectedIndex
        }
        
        if let getThemeIndex = defaults.objectForKey("colorThemeSelection") as? Int
        {
            switch getThemeIndex
            {
            case 0:
                fromDarkToLight()
            case 1:
                fromLightToDark()
            default:
                print("Error in settings color selector")
            }
        }
    }
    
    func fromLightToDark()
    {
        print(view.backgroundColor?.CGColor)
        view.backgroundColor = UIColor.grayColor()
        for subview in view.subviews
        {
            if let label = subview as? UILabel {
                label.textColor = UIColor.lightTextColor()
            }
            else if let field = subview as? UITextField
            {
                field.textColor = UIColor.lightTextColor()
            }
            else if let control = subview as? UISegmentedControl
            {
                control.tintColor = UIColor.lightTextColor()
                control.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState: UIControlState.Selected)
            }
        }
    }
    
    func fromDarkToLight()
    {
        print(view.backgroundColor?.CGColor)
        view.backgroundColor = UIColor.whiteColor()
        for subview in view.subviews
        {
            if let label = subview as? UILabel {
                label.textColor = UIColor.darkTextColor()
            }
            else if let field = subview as? UITextField
            {
                field.textColor = UIColor.darkTextColor()
            }
            else if let control = subview as? UISegmentedControl
            {
                control.tintColor = nil
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Save the current state */
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "tipPercentageSelection")
        defaults.synchronize()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        let tipPercentages = [0.18, 0.2, 0.25]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * tipPercentage
        let total = billAmount + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
}


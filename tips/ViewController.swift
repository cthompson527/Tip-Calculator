//
//  ViewController.swift
//  tips
//
//  Created by Cory Thompson on 12/9/15.
//  Copyright © 2015 Cory Thompson. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var tipLabel:              UILabel!
    @IBOutlet weak var totalLabel:            UILabel!
    @IBOutlet weak var billField:             UITextField!
    @IBOutlet weak var tipControl:            UISegmentedControl!
    @IBOutlet weak var staticTipLabel:        UILabel!
    @IBOutlet weak var staticTotalLabel:      UILabel!
    @IBOutlet weak var staticBillAmountLabel: UILabel!

    var wasEmpty: Bool = true

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text                       = "$0.00"
        totalLabel.text                     = "$0.00"
        tipLabel.alpha                      = 0
        totalLabel.alpha                    = 0
        staticTipLabel.alpha                = 0
        staticTotalLabel.alpha              = 0
        staticBillAmountLabel.frame         = CGRectOffset(staticBillAmountLabel.frame, 0, 60)
        billField.frame                     = CGRectOffset(billField.frame, 0, 60)
        billField.becomeFirstResponder()
    }

    override func viewWillAppear(animated: Bool)
    {
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
                    ViewController.fromDarkToLight(self.view)
                case 1:
                    ViewController.fromLightToDark(self.view)
                default:
                    print("Error in settings color selector")
            }
        }
    }


    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)

        /* Save the current state */
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "tipPercentageSelection")
        defaults.synchronize()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject)
    {
        let tipPercentages = [0.18, 0.2, 0.25]
        let tipPercentage  = tipPercentages[tipControl.selectedSegmentIndex]

        let currency = NSNumberFormatter()
        currency.locale = NSLocale.currentLocale()
        currency.maximumFractionDigits = 2
        currency.minimumFractionDigits = 2
        currency.alwaysShowsDecimalSeparator = true
        currency.numberStyle = .CurrencyStyle

        let billAmount  = NSString(string: billField.text!).doubleValue
        let tip         = billAmount * tipPercentage
        let total       = billAmount + tip
        tipLabel.text   = currency.stringFromNumber(tip)
        totalLabel.text = currency.stringFromNumber(total)

        let selectedTextColor = view.backgroundColor!
        tipControl.setTitleTextAttributes([NSForegroundColorAttributeName: selectedTextColor], forState: UIControlState.Selected)

        /* animations */
        if billField.hasText() && wasEmpty
        {
            UIView.animateWithDuration(0.6, animations: {
                self.tipLabel.alpha              = 1
                self.totalLabel.alpha            = 1
                self.staticTipLabel.alpha        = 1
                self.staticTotalLabel.alpha      = 1
                self.staticBillAmountLabel.alpha = 0
            })
            UIView.animateWithDuration(0.2, animations: {
                self.billField.frame = CGRectOffset(self.billField.frame, 0, -40)
            })
            wasEmpty = false

        }
        else if !(billField.hasText() || wasEmpty)      // DeMorgan of !hasText && !wasEmpty
        {
            UIView.animateWithDuration(0.6, animations: {
                self.tipLabel.alpha              = 0
                self.totalLabel.alpha            = 0
                self.staticTipLabel.alpha        = 0
                self.staticTotalLabel.alpha      = 0
                self.staticBillAmountLabel.alpha = 1
            })
            UIView.animateWithDuration(0.2, delay: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.billField.frame = CGRectOffset(self.billField.frame, 0, 40)
            }, completion: nil)
            wasEmpty = true
        }


    }

    @IBAction func onTap(sender: AnyObject)
    {
        //view.endEditing(false)                  // changing this to false to permanently show keyboard
    }

    static func fromLightToDark(view: UIView)
    {
        let darkColor = UIColor(red: CGFloat(85.0)/256.0, green: CGFloat(107.0)/256.0, blue: CGFloat(47.0)/256.0, alpha: CGFloat(1.0))
        view.backgroundColor = darkColor
        for subview in view.subviews
        {
            if let label = subview as? UILabel
            {
                label.textColor = UIColor.lightTextColor()
            }
            else if let field = subview as? UITextField
            {
                field.textColor = UIColor.lightTextColor()
                field.backgroundColor = darkColor
            }
            else if let control = subview as? UISegmentedControl
            {
                control.tintColor = UIColor.lightTextColor()
                let selectedTextColor = view.backgroundColor!
                control.setTitleTextAttributes([NSForegroundColorAttributeName: selectedTextColor], forState: UIControlState.Selected)
            }
        }
    }

    static func fromDarkToLight(view: UIView)
    {
        view.backgroundColor = UIColor.whiteColor()
        for subview in view.subviews
        {
            if let label = subview as? UILabel
            {
                label.textColor = UIColor.darkTextColor()
            }
            else if let field = subview as? UITextField
            {
                field.textColor = UIColor.darkTextColor()
                field.backgroundColor = UIColor.whiteColor()
            }
            else if let control = subview as? UISegmentedControl
            {
                control.tintColor = nil
                let selectedTextColor = view.backgroundColor!
                control.setTitleTextAttributes([NSForegroundColorAttributeName: selectedTextColor], forState: UIControlState.Selected)
            }
        }
    }
}


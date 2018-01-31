//
//  FinalTipViewViewController.swift
//  Tip Buddy
//
//  Created by Jacob Bullon on 12/31/17.
//  Copyright © 2017 Jacob Bullon. All rights reserved.
//

import UIKit

class FinalTipViewViewController: UIViewController {
    // property to take in the total bill and total tip amount
    var totalAmount: String? {
        didSet {
            if isViewLoaded {
                updateTotalBill()
            }
        }
    }
    var billFinalAmount: String? {
        didSet {
            if isViewLoaded {
                updateTotalBill()
            }
        }
    }
    var tipFinalAmount: String? {
        didSet {
            if isViewLoaded {
                updateTotalBill()
            }
        }
    }
    
    @IBOutlet weak var calculateAnotherTipButton: UIButton!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipField: UITextField!
    @IBOutlet weak var totalAmountTextView: UITextView!
    
    // for the background
    @IBOutlet weak var bgSwitch: UIImageView!
    var background: BackgroundThemes!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the button font smaller in case user is on iPhone with a very small screen
        let screenSize = UIScreen.main.bounds.width
        if screenSize == 320 || screenSize == 568 {
            calculateAnotherTipButton.titleLabel?.font = calculateAnotherTipButton.titleLabel?.font.withSize(22)
        }
        
        // load the background
        background = BackgroundThemes.sharedBackground
        bgSwitch.image = background.backgroundImage
        
        updateTotalBill()
    }
    
    // if user changes the theme from another screen
    // make sure that the new theme shows up when coming back here
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if background.backgroundImage != bgSwitch.image {
            bgSwitch.image = background.backgroundImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Used to ensure totalAmount is not nil, then set the textView text to the total amount
    func updateTotalBill() {
        if let totalAmount = totalAmount {
            totalAmountTextView.text = totalAmount
        }
        if let billFinalAmount = billFinalAmount {
            billField.text = billFinalAmount
        }
        if let tipFinalAmount = tipFinalAmount {
            tipField.text = tipFinalAmount
        }
    }
}

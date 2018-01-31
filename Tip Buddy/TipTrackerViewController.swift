//
//  TipTrackerViewController.swift
//  Tip Buddy
//
//  Created by Jacob Bullon on 1/7/18.
//  Copyright © 2018 Jacob Bullon. All rights reserved.
//

import UIKit

protocol TipTrackerProtocol {
    var totalValueOfAllTips: Double { get }
    var numberOfTipsTracked: Int { get }
}

extension TipTrackerProtocol {
    var averageTip: Double {
        return round((totalValueOfAllTips / Double(numberOfTipsTracked)) * 100) / 100  // returns the average to two decimal places
    }
}

class TipTrackerViewController: UIViewController, TipTrackerProtocol {
    
    var numberOfTipsTracked = 0       // determine number of clicks(tips added)
    var valDollar = 0                 // first half of tip value
    var valCent = 0                   // second half of tip value
    var totalValueOfAllTips = 0.0     // tracking the total values of all tips
    
    // Array used with UserDefaults
    var tipsArray: [Double] = []
    
    // dollar label outlet
    @IBOutlet weak var dollarLabel: UILabel!
    
    // cent label outlet
    @IBOutlet weak var centLabel: UILabel!
    
    // sample log outlet
    @IBOutlet weak var sampleLog: UITextView!

    // total label field
    @IBOutlet weak var totalLabel: UILabel!
    
    // average label field
    @IBOutlet weak var avgLabel: UILabel!
    
    // steppers
    @IBOutlet weak var dollarsStepper: UIStepper!
    @IBOutlet weak var centsStepper: UIStepper!
    
    // Background
    var background: BackgroundThemes!
    @IBOutlet weak var bgSwitch: UIImageView!
    
    @IBAction func stepper(_ sender: UIStepper) {
        dollarLabel.text = "$\(Int(sender.value))"
        valDollar = Int(sender.value)       // value taken to be used in totalLabel
    }
    
    @IBAction func stepperCent(_ sender: UIStepper) {
        centLabel.text = ".\(Int(sender.value))"
        if sender.value == 0 {
            centLabel.text = ".00"          // changes suffix to ".00" if cent value is 0
        }
        valCent = Int(Double(sender.value))  // Get an int value of the cents
    }
    
    @IBAction func addTipButton(_ sender: UIButton) {
        let tipDollarCent = (dollarLabel.text ?? "$0") + (centLabel.text ?? ".00") // concatenated string
        let tipValue = getTipValue()
        
        addTipValues(tipValue: tipValue, tipDollarCent: tipDollarCent)
        
        // add it to the tips array and save to user defaults
        tipsArray.append(tipValue)
        saveArrayToUserDefaults()
        
        // Update total labels
        updateTotalLabels()
        
        // reset ui
        dollarLabel.text = "$0"             // set dollar label back to 0
        centLabel.text = ".00"              // set cent label back to 0
        
        // Set dollar/cent values back to 0
        valDollar = 0
        valCent = 0
        dollarsStepper.value = 0
        centsStepper.value = 0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup background
        background = BackgroundThemes.sharedBackground
        bgSwitch.image = background.backgroundImage
        
        // check to see if user defaults exists
        guard let userDefaultsTipsArray = UserDefaults.standard.object(forKey: "_allTipsArrayKey") as? [Double] else {
            saveArrayToUserDefaults()
            print("Creating a new user defaults set")
            return
        }
        print("Found existing data")
        tipsArray = userDefaultsTipsArray
        setupExistingTips()
        // UserDefaults.standard.set(totalValueOfAllTips, forKey: totalValueOfAllTipsKey)     // write
        // UserDefaults.standard.double(forKey: totalValueOfAllTipsKey)                       // read
    }
    
    // if user changes the theme from another screen
    // make sure that the new theme shows up when coming back here
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if background.backgroundImage != bgSwitch.image {
            bgSwitch.image = background.backgroundImage
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Saving array")
        saveArrayToUserDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Back Button
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // Clear Screen
    @IBAction func clearTipScreen(_ sender: Any) {
        clearAllTips()
    }
    
    
    // MARK: - Private Helper Functions
    private func getTipValue() -> Double {
        // Don't worry about nil because values are set to 0
        let valueOfCents = Double(valCent) / 100
        return Double(valDollar) + valueOfCents
    }
    
    // setup the tips that already exist in userdefaults
    private func setupExistingTips() {
        // setup a number formatter
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        for tip in tipsArray {
            guard let tipString = numberFormatter.string(from: tip as NSNumber) else {
                print("Unable to convert userdefaults tip to string")
                return
            }
            let tipStringWithDollar = "$" + tipString
            addTipValues(tipValue: tip, tipDollarCent: tipStringWithDollar)
        }
        
        // since all tips have been loaded, it's time to update the totals
        // but only do it if the user actually has some previous values
        if tipsArray.count > 0 {
            updateTotalLabels()
        }
        
    }
    
    // add tip values to UI
    private func addTipValues(tipValue: Double, tipDollarCent: String) {
        totalValueOfAllTips += tipValue
        numberOfTipsTracked += 1                          // to be used for averaging the tip
        sampleLog.text! += "\(tipDollarCent)\n"
    }
    
    // called to save array
    private func saveArrayToUserDefaults() {
        UserDefaults.standard.set(tipsArray, forKey: "_allTipsArrayKey")
    }
    
    // called to update the total labels
    private func updateTotalLabels() {
        let numberFormatter = NumberFormatter() // create a number formatter for the strings
        
        // setup the formatter so we always get 2 digits
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1  // delete this line if you don't want dollars to show 0 if tip or average is only in cents
        
        // get formatted strings to display
        let totalLabelStringValue = numberFormatter.string(from: totalValueOfAllTips as NSNumber)
        let averageLabelStringValue = numberFormatter.string(from: averageTip as NSNumber)
        
        totalLabel.text! = "$" + totalLabelStringValue!    // string will always return to hundredths digit
        avgLabel.text! = "$" + averageLabelStringValue!    // value is calculated by protocol
    }
    
    private func clearAllTips() {
        createAlert(title:"Are you sure you want to clear all tips?", message: "")
    }
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Yes Button
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // Clear Tips
            self.totalLabel.text = ""
            self.avgLabel.text = ""
            self.sampleLog.text = ""
            self.totalValueOfAllTips = 0.0
            self.tipsArray = []
            UserDefaults.standard.set(self.tipsArray, forKey: "_allTipsArrayKey")
            print("tips cleared")
        }))
        
        // No Button
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil) }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

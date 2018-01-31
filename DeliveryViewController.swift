//
//  DeliveryViewController.swift
//  Tip Buddy
//
//  Created by Jacob Bullon on 1/1/18.
//  Copyright © 2018 Jacob Bullon. All rights reserved.
//
/* TO DO:
 */



// Header Files
import UIKit
import AVFoundation

// Text Field Extension adds "done" button to decimalpad
extension UITextField {
    
    func addDoneButton(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}

// Delivery View Controller Class
class DeliveryViewController: UIViewController, UITextFieldDelegate {
    
    //Initialized Values
    var friendlyTip = 4.8
    var timelyTip = 4.8
    var driveTip = 4.8
    var distanceTip = 4.8
    var tipFinal = 0.0
    var billFinal = 0.0

    // Bill Total Field
    @IBOutlet weak var billField: UITextField!
    
    //Friendliness of Driver
    @IBOutlet weak var friendSlide: UISlider!
    @IBOutlet weak var friendCondition: UITextView!
    let friendArray = [0.1, 2.9, 4.8, 6.4, 7.9]
    let friendConditionString = ["Driver was disheveled and/or very unfriendly","Looked presentable, but wasn't interested in friendly small talk","Friendly, but only because they are working","Driver smiled and made eye contact","Very pleasant to be around and provided a genuine service experience"]
    
    // Time Waiting for Food
    @IBOutlet weak var timeSlide: UISlider!
    @IBOutlet weak var timeCondition: UITextView!
    let timeArray = [0.1, 2.9, 4.8, 6.4, 7.9]
    let timeConditionString = ["Over 2 hours, and I never received an update on my food","Very long, but the store or driver called to keep me updated","Food arrived around the same time the store quoted","Faster than expected","Extremely fast"]
    
    // Driver Efficiency
    @IBOutlet weak var driveSlide: UISlider!
    @IBOutlet weak var driveCondition: UITextView!
    let driveArray = [0.1, 2.9, 4.8, 6.4, 7.9]
    let driveConditionString = ["Driver sat outside my house for a few minutes, and didn't make an effort to get to the door quickly","Driver took their time getting to the door, and didn't have a pen for me to sign the receipt","Driver got to the door quickly and presented my receipt to sign, but forgot some items","Driver hustled to the door and came prepared with everything I needed","Driver went above and beyond to make the delivery as efficient as possible"]
    
    // Distance From Store
    @IBOutlet weak var distanceSlide: UISlider!
    @IBOutlet weak var distanceCondition: UITextView!
    let distanceArray = [0.1, 2.9, 4.8, 6.4, 7.9]
    let distanceConditionString = ["Less than 1 mile","1-3 miles","3-5 miles","5-10 miles","10+ miles"]
    
    // Calculate Tip
    @IBOutlet weak var calcTip: UIButton!
    
    // Audio Player
    var audioPlayer = AVAudioPlayer()
    
    // Menu View
    @IBOutlet weak var menuSwitch: UIView!
    
    // Change theme
    @IBOutlet weak var bgSwitch: UIImageView!
    var background: BackgroundThemes!
    
    @IBAction func changeTheme(_ sender: Any) {
        background.changeBackgroundImage()
        bgSwitch.image = background.backgroundImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.billField.delegate = self
        billField.addDoneButtonToKeyboard(myAction: #selector(self.billField.resignFirstResponder))
        
        // setup background
        background = BackgroundThemes.sharedBackground
        bgSwitch.image = background.backgroundImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // if user changes the theme from another screen
    // make sure that the new theme shows up when coming back here
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if background.backgroundImage != bgSwitch.image {
            bgSwitch.image = background.backgroundImage
        }
    }
    
    // Friend Slider
    @IBAction func friendSlide(_ sender: UISlider) {
        friendSlide.value = roundf(friendSlide.value)
        if friendSlide.value == 1.0 {
            friendlyTip = (friendArray[0])
            self.friendCondition.text = self.friendConditionString[0]
            slideSound()
        } else if friendSlide.value == 2.0 {
            friendlyTip = (friendArray[0])
            self.friendCondition.text = self.friendConditionString[1]
            slideSound()
        } else if friendSlide.value == 3.0 {
            friendlyTip = (friendArray[0])
            self.friendCondition.text = self.friendConditionString[2]
            slideSound()
        } else if friendSlide.value == 4.0 {
            friendlyTip = (friendArray[0])
            self.friendCondition.text = self.friendConditionString[3]
            slideSound()
        } else if friendSlide.value == 5.0 {
            friendlyTip = (friendArray[0])
            self.friendCondition.text = self.friendConditionString[4]
            slideSound()
        }
    }
    
    // Time Slider
    @IBAction func timeSlide(_ sender: UISlider) {
        timeSlide.value = roundf(timeSlide.value)
        if timeSlide.value == 1.0 {
            timelyTip = (timeArray[0])
            self.timeCondition.text = self.timeConditionString[0]
            slideSound()
        } else if timeSlide.value == 2.0 {
            timelyTip = (timeArray[1])
            self.timeCondition.text = self.timeConditionString[1]
            slideSound()
        } else if timeSlide.value == 3.0 {
            timelyTip = (timeArray[2])
            self.timeCondition.text = self.timeConditionString[2]
            slideSound()
        } else if timeSlide.value == 4.0 {
            timelyTip = (timeArray[3])
            self.timeCondition.text = self.timeConditionString[3]
            slideSound()
        } else if timeSlide.value == 5.0 {
            timelyTip = (timeArray[4])
            self.timeCondition.text = self.timeConditionString[4]
            slideSound()
        }

    }
    
    // Efficiency Slider
    @IBAction func driveSlide(_ sender: UISlider) {
        driveSlide.value = roundf(driveSlide.value)
        if driveSlide.value == 1.0 {
            driveTip = (driveArray[0])
            self.driveCondition.text = self.driveConditionString[0]
            slideSound()
        } else if driveSlide.value == 2.0 {
            driveTip = (driveArray[1])
            self.driveCondition.text = self.driveConditionString[1]
            slideSound()
        } else if driveSlide.value == 3.0 {
            driveTip = (driveArray[2])
            self.driveCondition.text = self.driveConditionString[2]
            slideSound()
        } else if driveSlide.value == 4.0 {
            driveTip = (driveArray[3])
            self.driveCondition.text = self.driveConditionString[3]
            slideSound()
        } else if driveSlide.value == 5.0 {
            driveTip = (driveArray[4])
            self.driveCondition.text = self.driveConditionString[4]
            slideSound()
        }
    }
    
    // Distance Slider
    @IBAction func distanceSlider(_ sender: UISlider) {
        distanceSlide.value = roundf(distanceSlide.value)
        if distanceSlide.value == 1.0 {
            distanceTip = (distanceArray[0])
            self.distanceCondition.text = self.distanceConditionString[0]
            slideSound()
        } else if distanceSlide.value == 2.0 {
            distanceTip = (distanceArray[1])
            self.distanceCondition.text = self.distanceConditionString[1]
            slideSound()
        } else if distanceSlide.value == 3.0 {
            distanceTip = (distanceArray[2])
            self.distanceCondition.text = self.distanceConditionString[2]
            slideSound()
        } else if distanceSlide.value == 4.0 {
            distanceTip = (distanceArray[3])
            self.distanceCondition.text = self.distanceConditionString[3]
            slideSound()
        } else if distanceSlide.value == 5.0 {
            distanceTip = (distanceArray[4])
            self.distanceCondition.text = self.distanceConditionString[4]
            slideSound()
        }
    }
    
    
    // Calculate Tip on Button Press
    @IBAction func calcTip(_ sender: Any) {
        tipFinal = (friendlyTip + timelyTip + driveTip + distanceTip) * 0.01
        let billValue = Double(billField!.text!) ?? -1 // If not a number, get -1
        billFinal = (1.0 + Double(tipFinal)) * billValue
        if billFinal < 0 {
            createAlert(title: "Please Enter A Valid Bill Total!", message: "")
        } else {
            print("Tip Amount: \(tipFinal/0.01)%")
            print("Total Bill after tip: $\(billFinal)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFinalTipVC" {
            guard let finalTipVC = segue.destination as? FinalTipViewViewController else { return }
            if (tipFinal/0.01) < 15 && billFinal > 0 {
                finalTipVC.totalAmount = "It seems you didn't enjoy your delivery experience! Remember that everybody has bad days. Unless your service was particularly awful, be sure to leave your driver a tip for their effort."
                finalTipVC.billFinalAmount = "Total Bill After Tip: $\(round(100 * billFinal)/100)"
                finalTipVC.tipFinalAmount = "Suggested Tip Amount: \(round((tipFinal/0.01)*100)/100)%"
            } else if (tipFinal/0.01) > 15 && billFinal > 0 {
                finalTipVC.totalAmount = "Looks like you had a great delivery experience! Be thankful that we can have food delivered to us at the touch of a button, and make sure to leave your server a tip for their effort."
                finalTipVC.billFinalAmount = "Total Bill After Tip: $\(round(100 * billFinal)/100)"
                finalTipVC.tipFinalAmount = "Suggested Tip Amount: \(round((tipFinal/0.01)*100)/100)%"
            } else if billFinal < 0  {
                finalTipVC.totalAmount = "Invalid Credentials Entered, try again."
                finalTipVC.billFinalAmount = ""
                finalTipVC.tipFinalAmount = ""
            }
        }
    }
    
    
    // make a sound when slider is used
    func slideSound() {
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "click1", ofType: "mp3")!)
        do {
            // Preparation
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        
        // Play the sound
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: alertSound)
        } catch _{
        }
        
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        if menuSwitch.isHidden == true {
            menuSwitch.isHidden = false
        } else if menuSwitch.isHidden == false {
            menuSwitch.isHidden = true
        }
    }
    
    
    // ** LP ** Added an IBAction for the back button which pops the view controller and takes you back to ViewControllerMain
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // hide the menu when leaving this scree
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        menuSwitch.isHidden = true
    }
    
    // Create Alert to be displayed when Invalid Bill Total is entered
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

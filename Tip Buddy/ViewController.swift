//
//  ViewController.swift
//  Tip Buddy
//
//  Created by Jacob Bullon on 9/29/17.
//  Copyright © 2017 Jacob Bullon. All rights reserved.
//


// Header Files
import UIKit
import AVFoundation

// Text field extension
extension UITextField {
    
    func addDoneButtonToKeyboard(myAction:Selector?){
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

// View Controller Class
class ViewController: UIViewController, UITextFieldDelegate {
    
    // Total Bill Field
    @IBOutlet weak var billTotal: UITextField!      // text field to input bill before tip
    
    // Friendliness of Server
    @IBOutlet weak var friendSlide: UISlider!       // slider 1
    @IBOutlet weak var friendbox: UITextView!       // variable text 1
    let friendArray = [0.1, 2.9, 4.8, 6.4, 7.9]     // tip percentage to be cumulative
    let friendConditions = ["Horrible!","Pretty Bad","Not Good, Not Bad","Very Courteous","Incredibly Personable"]
    
    // Time Waiting for Food
    @IBOutlet weak var foodSlide: UISlider!
    @IBOutlet weak var foodBox: UITextView!
    let foodArray = [0.1, 2.5, 4.8, 5.6, 7.7]
    let foodConditions = ["A ridiculously long time","Very Long, and your server lacked urgency","Very long, but your server kept you updated","Pretty Quick","Dangerously Fast"]
    
    // Server Efficiency
    @IBOutlet weak var drinkSlide: UISlider!
    @IBOutlet weak var drinkBox: UITextView!
    let drinkArray = [0.4, 1.5, 4.2, 5.3, 6.6]
    let drinkConditions = ["Drink was never refilled and the table remained a mess","My drink was often empty and the table remained a mess","Average efficiency","Server came by the table a little too much, but still got things done","Server was very efficient with keeping the table organized"]
    
    // Party Size
    @IBOutlet weak var partySlide: UISlider!
    @IBOutlet weak var partyBox: UITextView!
    let partyArray = [1.0, 2.0, 3.0, 4.0, 5.0]
    let partyConditions = ["Just Me","2","3-4","5-7","8+"]
    
    // Initialize tip values and final bill
    var friendlyTip = 4.8
    var timelyTip = 4.8
    var refillTip = 4.2
    var partyTip = 1.0
    var tipFinal = 0.0
    var billFinal = 0.0
    
    // audio player
    var audioPlayer = AVAudioPlayer()
    
    // Menu View
    @IBOutlet weak var menuSwitch: UIView!
    
    // Change Theme
    @IBOutlet weak var bgSwitch: UIImageView!
    var background: BackgroundThemes!
    
    // Background Button Pressed action
    @IBAction func bgButtonPressed(_ sender: UIButton) {
       background.changeBackgroundImage()
        bgSwitch.image = background.backgroundImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.billTotal.delegate = self
        billTotal.addDoneButtonToKeyboard(myAction: #selector(self.billTotal.resignFirstResponder))
        
        // load background
        background = BackgroundThemes.sharedBackground
        bgSwitch.image = background.backgroundImage
    }
    
    // if user changes the theme from another screen
    // make sure that the new theme shows up when coming back here
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if background.backgroundImage != bgSwitch.image {
            bgSwitch.image = background.backgroundImage
        }
    }
    
    // Slider Declarations
    @IBAction func friendSlide(_ sender: UISlider) {
        friendSlide.value = roundf(friendSlide.value)
        if friendSlide.value == 1.0 {
            friendlyTip = (friendArray[0])
            self.friendbox.text = self.friendConditions[0]
            slideSound()
        } else if friendSlide.value == 2.0 {
            friendlyTip = (friendArray[1])
            self.friendbox.text = self.friendConditions[1]
            slideSound()
        } else if friendSlide.value == 3.0 {
            friendlyTip = (friendArray[2])
            self.friendbox.text = self.friendConditions[2]
            slideSound()
        } else if friendSlide.value == 4.0 {
            friendlyTip = (friendArray[3])
            self.friendbox.text = self.friendConditions[3]
            slideSound()
        } else if friendSlide.value == 5.0 {
            friendlyTip = (friendArray[4])
            self.friendbox.text = self.friendConditions[4]
            slideSound()
        }
        
    }
    @IBAction func foodSlide(_ sender: UISlider) {
        foodSlide.value = roundf(foodSlide.value)
        if foodSlide.value == 1.0 {
            timelyTip = (foodArray[0])
            self.foodBox.text = self.foodConditions[0]
            slideSound()
        } else if foodSlide.value == 2.0 {
            timelyTip = (foodArray[1])
            self.foodBox.text = self.foodConditions[1]
            slideSound()
        } else if foodSlide.value == 3.0 {
            timelyTip = (foodArray[2])
            self.foodBox.text = self.foodConditions[2]
            slideSound()
        } else if foodSlide.value == 4.0 {
            timelyTip = (foodArray[3])
            self.foodBox.text = self.foodConditions[3]
            slideSound()
        } else if foodSlide.value == 5.0 {
            timelyTip = (foodArray[4])
            self.foodBox.text = self.foodConditions[4]
            slideSound()
        }
    }
    @IBAction func drinkSlide(_ sender: UISlider) {
        drinkSlide.value = roundf(drinkSlide.value)
        if drinkSlide.value == 1.0 {
            refillTip = (drinkArray[0])
            self.drinkBox.text = self.drinkConditions[0]
            slideSound()
        } else if drinkSlide.value == 2.0 {
            refillTip = (drinkArray[1])
            self.drinkBox.text = self.drinkConditions[1]
            slideSound()
        } else if drinkSlide.value == 3.0 {
            refillTip = (drinkArray[2])
            self.drinkBox.text = self.drinkConditions[2]
            slideSound()
        } else if drinkSlide.value == 4.0 {
            refillTip = (drinkArray[3])
            self.drinkBox.text = self.drinkConditions[3]
            slideSound()
        } else if drinkSlide.value == 5.0 {
            refillTip = (drinkArray[4])
            self.drinkBox.text = self.drinkConditions[4]
            slideSound()
        }
    }
    @IBAction func partySlide(_ sender: UISlider) {
        partySlide.value = roundf(partySlide.value)
        if partySlide.value == 1.0 {
            partyTip = (partyArray[0])
            self.partyBox.text = self.partyConditions[0]
            slideSound()
        } else if partySlide.value == 2.0 {
            partyTip = (partyArray[1])
            self.partyBox.text = self.partyConditions[1]
            slideSound()
        } else if partySlide.value == 3.0 {
            partyTip = (partyArray[2])
            self.partyBox.text = self.partyConditions[2]
            slideSound()
        } else if partySlide.value == 4.0 {
            partyTip = (partyArray[3])
            self.partyBox.text = self.partyConditions[3]
            slideSound()
        } else if partySlide.value == 5.0 {
            partyTip = (partyArray[4])
            self.partyBox.text = self.partyConditions[4]
            slideSound()
        }
    }
    
    // Calculate tip on button press
    @IBAction func calcTip(_ sender: UIButton) {
        tipFinal = (friendlyTip + timelyTip + refillTip + partyTip) * 0.01
        let billValue = Double(billTotal!.text!) ?? -1 // If not a number, get -1
        billFinal = (1.0 + Double(tipFinal)) * billValue
            if billFinal < 0 {
                createAlert(title: "Please Enter A Valid Bill Total!", message: "")
            } else {
            print("Tip Amount: \(tipFinal/0.01)%")
            print("Total Bill after tip: $\(billFinal)")
        }
    }
    // This method is used to pass data between two view controllers using `toFinalTipVC`
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFinalTipVC" {
            guard let finalTipVC = segue.destination as? FinalTipViewViewController else { return }
            if (tipFinal/0.01) < 15 && billFinal > 0 {
                finalTipVC.totalAmount = "Looks like you had a bad dining experience! Remember that everybody has bad days. Unless your service was particularly awful, be sure to leave your server a tip for their effort."
                finalTipVC.billFinalAmount = "Total Bill After Tip: $\(round(100 * billFinal)/100)"
                finalTipVC.tipFinalAmount = "Suggested Tip Amount: \(round((tipFinal/0.01)*100)/100)%"
            } else if (tipFinal/0.01) > 15 && billFinal > 0 {
                finalTipVC.totalAmount = "Looks like you had a great dining experience! Be thankful that we can go to restaurants and be served food with a smile, and make sure to leave your server a tip for their effort."
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
    
    // Show and hide the menu view when the menu button is pressed
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        if menuSwitch.isHidden == true {
            menuSwitch.isHidden = false
        } else if menuSwitch.isHidden == false {
            menuSwitch.isHidden = true
        }
    }
    
    // ** LP ** Added an IBAction for the back button which pops the view controller and takes you back to ViewControllerMain
    @IBAction func backButtonPressed(_ sender: Any) {
        
        // ** LP ** dismiss(animated:completion:) will not work as your initial view is a NavigationController. What popViewController is doing is just what it says, popping that viewController off
        // ** LP ** You could have segued the back button back to the ViewControllerMain in Interface Builder, but in my opinion, the transition doesn't look good
        
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

//
//  ViewControllerMain.swift
//  Tip Buddy
//
//  Created by Jacob Bullon on 12/21/17.
//  Copyright © 2017 Jacob Bullon. All rights reserved.
//

import UIKit

class ViewControllerMain: UIViewController {
    
    // Var for background
    var background: BackgroundThemes!
    
    @IBOutlet weak var menuSwitch: UIView!
    @IBOutlet weak var bgSwitch: UIImageView!
    @IBOutlet weak var tipBuddyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the font smaller in case user is on iPhone with a very small screen
        let screenSize = UIScreen.main.bounds.width
        if screenSize == 320 || screenSize == 568 {
            tipBuddyLabel.font = tipBuddyLabel.font.withSize(22)
        }
        
        // Setup the background shared singleton
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
    
    // hide menu when leaving
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        menuSwitch.isHidden = true
    }
    
    // Menu toggle button
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        if menuSwitch.isHidden == true {
            menuSwitch.isHidden = false
        } else if menuSwitch.isHidden == false {
            menuSwitch.isHidden = true
        }
    }
    
    // menu toggle function
    @IBAction func bgButtonPressed(_ sender: UIButton) {
        background.changeBackgroundImage()
        bgSwitch.image = background.backgroundImage
    }
}

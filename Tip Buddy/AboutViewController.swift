//
//  AboutViewController.swift
//  Tip Buddy
//
//  Created by Jacob Bullon on 1/7/18.
//  Copyright © 2018 Jacob Bullon. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    // for the background
    var background: BackgroundThemes!
    
    @IBOutlet weak var bgSwitch: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup background
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}

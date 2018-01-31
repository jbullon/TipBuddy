//
//  BackGroundThemes.swift
//  Tip Buddy
//
//  Refactored Background theme changing method
//  Created by Daniel Pratt on 1/11/18.
//  Copyright © 2018 Jacob Bullon. All rights reserved.
//

import Foundation
import UIKit

struct BackgroundThemeImages {
    
    static let randomBackGround = ["043 New York","003 Spring Warmth","007 Sunny Morning","005 Young Passion","050 Snow Again","057 Dirty Beauty", "095 Big Mango", "089 Premium White", "140 Mole Hall", "145 Rich Metal", "164 Strict November", "165 Morning Salad", "301 lizard", "302 orca", "303 red sunset", "304 telegram"]
}

final class BackgroundThemes {
    
    // class variables
    
    // holds the background index
    var backgroundIndex: Int = 0
    // holds the image
    var backgroundImage: UIImage = UIImage(named: BackgroundThemeImages.randomBackGround[0])!
    
    // shared singelton
    static let sharedBackground = BackgroundThemes()
    
    // Setup a background object
    init() {
        guard let backgroundValue = UserDefaults.standard.value(forKey: "_backGroundThemeValueKey") as? Int else {
            writeBackgroundValue()
            return
            }
        
        backgroundIndex = backgroundValue
        setBackgroundTheme()
    }
    
    // Change background
    public func changeBackgroundImage() {
        // Get a new random number
        backgroundIndex = randomNumber()
        
        // Set the new theme to the image
        setBackgroundTheme()
    }
    
    // Setup Background Theme
    private func setBackgroundTheme() {
        print("Setting theme...")
        let theme = BackgroundThemeImages.randomBackGround[backgroundIndex]
        print("Theme Displayed: \(theme)")
        backgroundImage = UIImage(named: theme)!
        
        // write the value of the background
        writeBackgroundValue()
    }
    
    // random number generator
    private func randomNumber() -> Int {
        var randomNumber = backgroundIndex
        while randomNumber == backgroundIndex {
            randomNumber = Int(arc4random_uniform(16))
        }
        
        return randomNumber
    }
    
    // write userdefaults for background value
    private func writeBackgroundValue() {
        UserDefaults.standard.set(backgroundIndex, forKey: "_backGroundThemeValueKey")
    }
    
}

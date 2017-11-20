//
//  InstaGradientController.swift
//  AKClone
//
//  Created by Akash on 16/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class InstaGradientController: UIViewController,StoryboardRedirectionProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Insta Gradient"
        let pastelView = InstagramGradiant(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPoint = .bottomLeft
        pastelView.endPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors(colors: [UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                                      UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                                      UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                                      UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                                      UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                                      UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                                      UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
    
    
}

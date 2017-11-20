//
//  DrawController.swift
//  AKClone
//
//  Created by Akash on 16/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class DrawController: UIViewController,StoryboardRedirectionProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Draw"
        // Do any additional setup after loading the view.
    }

    @IBOutlet var drawView: DrawView?

    @IBAction func clearButtonTapped(_ sender: UIButton){
        drawView?.lines = []
        drawView?.setNeedsDisplay()
        
    }
    
    @IBAction func ColorTapped(_ sender: UIButton) {
        sender.superview?.backgroundColor = .lightText
        sender.backgroundColor = .clear
        var color: UIColor!
        if sender.titleLabel?.text == "Red"{
            color = UIColor.red
        } else if sender.titleLabel?.text == "Green"{
            color = UIColor.green
        }else if sender.titleLabel?.text == "Blue"{
            color = UIColor.blue
        }
        drawView?.drawColor = color
        drawView?.setNeedsDisplay()
    }

}

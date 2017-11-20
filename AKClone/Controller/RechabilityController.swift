//
//  RechabilityController.swift
//  AKClone
//
//  Created by Akash on 16/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class RechabilityController: UIViewController,StoryboardRedirectionProtocol {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReachability(nil, useClosures: true)
        startNotifier()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }

   
    var reachability: Reachability?
    //FIXME:- Rechability
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        
        
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        self.reachability = reachability
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                DispatchQueue.main.async {
                    self.updateLabelColourWhenReachable(reachability)
                }
            }
            reachability?.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    self.updateLabelColourWhenNotReachable(reachability)
                }
            }
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        }
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        } catch {
            print("Unable to start notifier")
            
            alert(connected: "Fail", connectedString: "Unable to start Notifier")
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func updateLabelColourWhenReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.currentReachabilityString)")
        if reachability.isReachableViaWiFi {
            print("Connected via WIFI")

            alert(connected: "Success", connectedString: "Connected via WIFI")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        } else {
            print("Connected via mobile data")
            title = "Connected via mobile Data"
            alert(connected: "Success", connectedString: "Connected via Mobile Data")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
        
        print("\(reachability.description) - \(reachability.currentReachabilityString)")
        
        
        print("Please Connect to Internet First")
        alert(connected: "Fail", connectedString: "Please Connect to Internet First")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            updateLabelColourWhenReachable(reachability)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        } else {
            updateLabelColourWhenNotReachable(reachability)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    deinit {
        stopNotifier()
    }
    func alert(connected: String,connectedString: String) {
        let alert = UIAlertController(title: connected, message: connectedString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

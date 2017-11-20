//
//  Color.swift
//  AKClone
//
//  Created by Akash on 16/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit



protocol RedirectionProtocol {
    
    static func getViewController() -> UIViewController
    
}

protocol XIBRedirectionProtocol: RedirectionProtocol {
    
    static var nibIdentifier: String { get }
    
}

extension XIBRedirectionProtocol where Self: UIViewController {
    
    static var nibIdentifier: String {
        return String(describing: self)
    }
    
    private static func fromNib() -> Self {
        let viewController = Self(nibName: nibIdentifier, bundle:nil)
        return viewController
    }
    
    static func getViewController() -> UIViewController {
        return fromNib()
    }
    
}



protocol StoryboardRedirectionProtocol: RedirectionProtocol {
    
    static var storyboard: UIStoryboard { get }
    
    static var storyboardIdentifier: String { get }
    
}


extension StoryboardRedirectionProtocol where Self: UIViewController {
    
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    
    private static func fromStoryboard() -> Self {
        
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        return viewController
    }
    
    static func getViewController() -> UIViewController {
        return fromStoryboard()
    }
    
}

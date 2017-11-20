//
//  NotificationController.swift
//  AKClone
//
//  Created by Akash on 18/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class NotificationController: BaseController {

    @IBOutlet weak var showNotificationButton: UIButton!
    
    var notificationView: GCNotificationView = GCNotificationView()
    var yPoint: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }

    
    @IBAction func showNotificationButton(_ sender: Any) {
        /*
         notificationView.yPoint = self.customView.bounds.height
         yPoint = self.customView.bounds.height
         self.customView.isHidden = false

         */
        let navigHeight = self.navigationController?.navigationBar.bounds.height
        notificationView.yPoint = navigHeight!
        yPoint = navigHeight!
        notificationView.bgColor = .red
        notificationView.show(message: "Hello, World! asdf asdf asdf asdf asdf asdf aksdlf asjkdf ajsdfjksajdfjkasdfjaskdfhlk asdfkjasdfaspdf iasdfnaskldf  dfasdasdfasdfs sadf ssr")
    }
    
}



class GCNotificationViewDefaultColor {
    static let bgColor = UIColor(red: 78 / 255, green: 136 / 255, blue: 207 / 255, alpha: 1.0)
    static let txtColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1.0)
}



public class GCNotificationView: UIView {
    fileprivate let viewWidth: CGFloat = UIScreen.main.bounds.width
    fileprivate let viewHeight: CGFloat = 190.0
    fileprivate var toastView: UIView!
    fileprivate var messageLabel: UILabel!
    fileprivate var errorImageView: UIImageView!
    
    static fileprivate var isShowing: Bool = false
    public var duration: Double = 0.3
    public var delay: Double = 3.0
    public var yPoint: CGFloat = 0
    public var bgColor: UIColor = GCNotificationViewDefaultColor.bgColor
    public var textColor: UIColor = GCNotificationViewDefaultColor.txtColor
    
    public init(duration: Double = 0.3, delay: Double = 3.0, yPoint: CGFloat = 0) {
        super.init(frame: .zero)
        
        self.duration = duration
        self.delay = delay
        self.yPoint = yPoint
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GCNotificationView {
    
    fileprivate func setupView() {
        frame = CGRect(x: 0, y: (viewHeight - 80) - yPoint, width: viewWidth, height: 80)
        backgroundColor = .clear
        clipsToBounds = true
        
        toastView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        toastView.backgroundColor = bgColor
        addSubview(toastView)
    }
    
    fileprivate func setupMessage(message: String) {
        messageLabel = UILabel(frame: CGRect(x: 80, y: 0, width: bounds.width - 80, height: toastView.bounds.height))
        messageLabel.font = UIFont.systemFont(ofSize: 13.0)
        messageLabel.textColor = textColor
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        
        toastView.addSubview(messageLabel)
    }
//    fileprivate func setupImage()  {
//        errorImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
//        errorImageView.image = UIImage(named: "icon-warning")
//        errorImageView.contentMode = .scaleAspectFit
//        toastView.addSubview(errorImageView)
//    }
}

extension GCNotificationView {
    fileprivate func showAnimation() {
        GCNotificationView.isShowing = true
        toastView.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: duration) {
            self.toastView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.layoutIfNeeded()
        }
    }
    
    fileprivate func dismissAnimation() {
        UIView.animate(withDuration: duration, animations: {
            self.toastView.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in
            self.removeFromSuperview()
            GCNotificationView.isShowing = false
        }
    }
}

extension GCNotificationView {
    fileprivate func addNotificationView(_ completion: (() -> Void)) {
        guard let keyWindow = UIApplication.shared.keyWindow,
            let rootViewController = keyWindow.rootViewController else {
                return
        }
        
        checkVisibleView(viewController: rootViewController).view.addSubview(self)
        completion()
    }
    
    fileprivate func checkVisibleView(viewController: UIViewController) -> UIViewController {
        var vc = viewController
        if let presentedViewController = viewController.presentedViewController {
            vc = checkVisibleView(viewController: presentedViewController)
        }
        
        return vc
    }
}

extension GCNotificationView {
    public func change(duration: Double) -> GCNotificationView {
        self.duration = duration
        
        return self
    }
    
    public func change(delay: Double) -> GCNotificationView {
        self.delay = delay
        
        return self
    }
    
    public func change(yPoint: CGFloat) -> GCNotificationView {
        self.yPoint = yPoint
        
        return self
    }
    
    public func change(backgroundColor: UIColor) -> GCNotificationView {
        self.bgColor = backgroundColor
        
        return self
    }
    
    public func change(textColor: UIColor) -> GCNotificationView {
        self.textColor = textColor
        
        return self
    }
    
    public func show(message: String) {
        guard !GCNotificationView.isShowing else {
            return
        }
        
        setupView()
        setupMessage(message: message)
//        setupImage()
        addNotificationView {
            showAnimation()
            let timeNeed = duration + delay
            DispatchQueue.main.asyncAfter(deadline: .now() + timeNeed) {
                self.dismissAnimation()
            }
        }
    }
}


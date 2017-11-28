//
//  BaseController.swift
//  AKClone
//
//  Created by Akash on 16/11/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class BaseController: UIViewController,CAAnimationDelegate,StoryboardRedirectionProtocol {

    //共三组渐变色
    let colorsSet = [
        [UIColor.yellow.cgColor, UIColor.orange.cgColor],
        [UIColor.cyan.cgColor, UIColor.green.cgColor],
        [UIColor.magenta.cgColor, UIColor.blue.cgColor],
        ]
    
    //当前渐变色索引
    var currentIndex = 0
    
    //渐变层
    var gradientLayer:CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建CAGradientLayer对象
        gradientLayer = CAGradientLayer()
        //设置初始渐变色
        gradientLayer.colors = colorsSet[0]
        //每种颜色所在的位置
        gradientLayer.locations = [0.0, 1.0]
        
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    func tapSingleDid(){
        //下一组渐变色索引
        var nextIndex = currentIndex + 1
        if nextIndex >= colorsSet.count {
            nextIndex = 0
        }
        
        //添加渐变动画
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.delegate = self
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.fromValue = colorsSet[currentIndex]
        colorChangeAnimation.toValue = colorsSet[nextIndex]
        colorChangeAnimation.fillMode = kCAFillModeForwards
        //动画结束后保持最终的效果
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
        
        //动画播放后改变当前索引值
        currentIndex = nextIndex
    }

}

import UIKit

extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        view.backgroundColor = .clear
        view.layoutAttachAll(to: self)
        return view
    }
    
    func layoutAttachAll(to view: UIView){
        
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String : Any] = [
            "view" : self
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: [:], views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: [:], views: views))
        
        setNeedsLayout()
        layoutIfNeeded()
        view.layoutIfNeeded()
        
    }
    
}

extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
}

fileprivate var keyBorderShapeLayer: String = "Bordershapelayer"
private extension UIView {
    
    private var borderShapeLayer: CAShapeLayer? {
        get{
            if let layer = objc_getAssociatedObject(self, &keyBorderShapeLayer) as! CAShapeLayer?{
                return layer
            } else {
                return nil
            }
        }
        set{
            if let layer = newValue {
                objc_setAssociatedObject(self, &keyBorderShapeLayer, layer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    

    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        borderShapeLayer?.removeFromSuperlayer()
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
        borderShapeLayer = borderLayer
    }
    
}




struct UIViewBorderAttributeKey {
    static let marginTop = "marginTop"
    static let marginLeft = "marginLeft"
    static let marginRight = "marginRight"
    static let marginBottom = "marginBottom"
}


extension UIView {
    
    fileprivate var topBorderTag: Int{ return 8001 }
    fileprivate var leftBorderTag: Int{ return 8002 }
    fileprivate var rightBorderTag: Int{ return 8003 }
    fileprivate var bottomBorderTag: Int{ return 8004 }
    
    
    private var defaultAttributes: [String : Any] {
        
        let attributes: [String : Any] = [
            UIViewBorderAttributeKey.marginTop : 0,
            UIViewBorderAttributeKey.marginLeft : 0,
            UIViewBorderAttributeKey.marginBottom : 0,
            UIViewBorderAttributeKey.marginRight : 0,
        ]
        
        return attributes
    }
    
    @discardableResult
    func drawTopBorder(width: Float, color: UIColor, attributes: [String : Any]) -> UIView {
        
        var metrics: [String : Any] = defaultAttributes
        attributes.forEach { metrics.updateValue($1, forKey: $0) }
        metrics["borderWidth"] = width
        
        let borderView = viewWithTag(topBorderTag) ?? UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = color
        self.addSubview(borderView)
        
        let views: [String : Any] = [
            "borderView" : borderView
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-marginLeft-[borderView]-marginRight-|", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[borderView(==borderWidth)]", options: [], metrics: metrics, views: views))
        
        layoutIfNeeded()
        return borderView
    }
    
    @discardableResult
    func drawLeftBorder(width: Float, color: UIColor, attributes: [String : Any]) -> UIView {
        
        var metrics: [String : Any] = defaultAttributes
        attributes.forEach { metrics.updateValue($1, forKey: $0) }
        metrics["borderWidth"] = width
        
        let borderView = viewWithTag(leftBorderTag) ?? UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = color
        self.addSubview(borderView)
        
        let views: [String : Any] = [
            "borderView" : borderView
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[borderView(==borderWidth)]", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-marginTop-[borderView]-marginBottom-|", options: [], metrics: metrics, views: views))
        
        layoutIfNeeded()
        return borderView
    }
    
    @discardableResult
    func drawRightBorder(width: Float, color: UIColor, attributes: [String : Any]) -> UIView {
        
        var metrics: [String : Any] = defaultAttributes
        attributes.forEach { metrics.updateValue($1, forKey: $0) }
        metrics["borderWidth"] = width
        
        let borderView = viewWithTag(rightBorderTag) ?? UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = color
        self.addSubview(borderView)
        
        let views: [String : Any] = [
            "borderView" : borderView
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[borderView(==borderWidth)]-marginRight-|", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-marginTop-[borderView]-marginBottom-|", options: [], metrics: metrics, views: views))
        
        layoutIfNeeded()
        return borderView
    }
    
    @discardableResult
    func drawBottomBorder(width: Float, color: UIColor, attributes: [String : Any]) -> UIView {
        
        var metrics: [String : Any] = defaultAttributes
        attributes.forEach { metrics.updateValue($1, forKey: $0) }
        metrics["borderWidth"] = width
        
        let borderView = viewWithTag(bottomBorderTag) ?? UIView()
        borderView.tag = bottomBorderTag
        borderView.removeFromSuperview()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = color
        self.addSubview(borderView)
        
        let views: [String : Any] = [
            "borderView" : borderView
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-marginLeft-[borderView]-marginRight-|", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0)-[borderView(==borderWidth)]-marginBottom-|", options: [], metrics: metrics, views: views))
        
        layoutIfNeeded()
        return borderView
    }
    
    func removeTopBorder(animation: Bool) {
        
        if let borderView = viewWithTag(topBorderTag) {
            if animation {
                UIView.animate(withDuration: 0.2, animations: {
                    borderView.removeFromSuperview()
                })
            }else{
                borderView.removeFromSuperview()
            }
            
        }
        
    }
    
    func removeLeftBorder(animation: Bool) {
        
        if let borderView = viewWithTag(leftBorderTag) {
            if animation {
                UIView.animate(withDuration: 0.2, animations: {
                    borderView.removeFromSuperview()
                })
            }else{
                borderView.removeFromSuperview()
            }
            
        }
        
    }
    
    func removeRightBorder(animation: Bool) {
        
        if let borderView = viewWithTag(rightBorderTag) {
            if animation {
                UIView.animate(withDuration: 0.2, animations: {
                    borderView.removeFromSuperview()
                })
            }else{
                borderView.removeFromSuperview()
            }
            
        }
        
    }
    
    func removeBottomBorder(animation: Bool) {
        
        if let borderView = viewWithTag(bottomBorderTag) {
            if animation {
                UIView.animate(withDuration: 0.2, animations: {
                    borderView.removeFromSuperview()
                })
            }else{
                borderView.removeFromSuperview()
            }
            
        }
        
    }
    
}


fileprivate var keyStrokeShapeLayer: String = "StrokeShapeLayer"

extension UIView {
    
    fileprivate var strokeLayer: CAShapeLayer? {
        get{
            if let layer = objc_getAssociatedObject(self, &keyStrokeShapeLayer) as! CAShapeLayer?{
                return layer
            } else {
                return nil
            }
        }
        set{
            if let layer = newValue {
                objc_setAssociatedObject(self, &keyStrokeShapeLayer, layer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func drawStrokeArc(width lineWidth: CGFloat, color: UIColor) {
        
        if strokeLayer == nil {
            strokeLayer = CAShapeLayer()
            layer.addSublayer(strokeLayer!)
        }
        
        strokeLayer?.strokeColor = color.cgColor
        strokeLayer?.fillColor = UIColor.clear.cgColor
        strokeLayer?.lineWidth = lineWidth
        strokeLayer?.strokeStart = 0
        strokeLayer?.strokeEnd = 1
        
        let layerBounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        let radius = min(bounds.size.width, bounds.size.height) / 2
        let arcCenter = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat(-Double.pi/2.0), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true).cgPath
        
        strokeLayer?.bounds = layerBounds
        strokeLayer?.position = arcCenter
        strokeLayer?.path = path
        
    }
    
}



// MARK: - Activity Indicator
fileprivate var keyActivityIndicator: String = "keyActivityIndicator"
extension UIView {
    
    fileprivate var _activityIndicator: UIActivityIndicatorView? {
        get{
            if let activityIndicator = objc_getAssociatedObject(self, &keyActivityIndicator) as! UIActivityIndicatorView?{
                return activityIndicator
            } else {
                return nil
            }
        }
        set{
            if let activityIndicator = newValue {
                objc_setAssociatedObject(self, &keyActivityIndicator, activityIndicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    

    var activityIndicatorView: UIActivityIndicatorView {

        if let indicatorView = _activityIndicator {
            return indicatorView
        }else{
         
            let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicatorView.hidesWhenStopped = true
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(indicatorView)

            addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
            setNeedsLayout()
            layoutIfNeeded()
            
            _activityIndicator = indicatorView
            return _activityIndicator ?? indicatorView
        }
        
    }
    
}



// MARK: - UITableView Extension
extension UITableView {
    
    /// Scroll table to bottom
    ///
    /// - Parameter animated: With animation
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            scrollToRow(at: IndexPath(row: rows - 1, section: sections - 1), at: .bottom, animated: true)
        }
    }
    
}



fileprivate var keyInnerLayer: String = "InnerLayer"
extension UIView {
    
    fileprivate var innerLayer: CALayer? {
        get{
            if let layer = objc_getAssociatedObject(self, &keyInnerLayer) as! CALayer?{
                return layer
            } else {
                return nil
            }
        }
        set{
            if let layer = newValue {
                objc_setAssociatedObject(self, &keyInnerLayer, layer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func drawInnerBorder(width lineWidth: CGFloat, color: UIColor, padding: CGFloat = 0) {
        
        if innerLayer == nil {
            innerLayer = CAShapeLayer()
            layer.addSublayer(innerLayer!)
        }
        
        innerLayer?.borderWidth = lineWidth
        innerLayer?.borderColor = color.cgColor
        
        let layerFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height).insetBy(dx: padding, dy: padding)
        innerLayer?.frame = layerFrame
        innerLayer?.cornerRadius = layerFrame.width / 2
    }
    
}

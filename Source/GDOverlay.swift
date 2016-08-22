//
//  GDOverlay.swift
//  SwiftyGuideOverlay
//
//  Created by Saeid Basirnia on 8/16/16.
//  Copyright © 2016 Betternet. All rights reserved.
//

import UIKit

enum LineDirection: UInt32{
    case left
    case right
    
    private static let _count: LineDirection.RawValue = {
        var maxValue: UInt32 = 0
        while let _ = LineDirection(rawValue: maxValue) {
            maxValue += 1
        }
        return maxValue
    }()
    
    static func randomDir() -> LineDirection {
        let rand = arc4random_uniform(2)
        return LineDirection(rawValue: rand)!
    }
}

enum LineType{
    case line_arrow
    case line_bubble
    case dash_arrow
    case dash_bubble
}

protocol SkipOverlayDelegate{
    func onSkipSignal()
}

class GDOverlay: UIView {
    
    //MARK: - Attributes
    private var _backColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    var backColor: UIColor{
        get{
            return _backColor
        }
        set{
            _backColor = newValue
        }
    }
    
    private var _boxBackColor: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.05)
    var boxBackColor: UIColor{
        get{
            return _boxBackColor
        }
        set{
            _boxBackColor = newValue
        }
    }
    
    private var _boxBorderColor: UIColor = UIColor.whiteColor()
    var boxBorderColor: UIColor{
        get{
            return _boxBorderColor
        }
        set{
            _boxBorderColor = newValue
        }
    }
    
    private var _showBorder: Bool = true
    var showBorder: Bool{
        get{
            return _showBorder
        }
        set{
            _showBorder = newValue
        }
    }
    
    private var _lineType: LineType = .dash_bubble
    var lineType: LineType{
        get{
            return _lineType
        }
        set{
            _lineType = newValue
        }
    }
    
    private var _multiGuide: Bool = false
    var multiGuide: Bool{
        get{
            return _multiGuide
        }
        set{
            _multiGuide = newValue
        }
    }
    
    private var _labelFont: UIFont = UIFont.boldSystemFontOfSize(14)
    var labelFont: UIFont{
        get{
            return _labelFont
        }
        set{
            _labelFont = newValue
        }
    }
    
    private var _labelColor: UIColor = UIColor.whiteColor()
    var labelColor: UIColor{
        get{
            return _labelColor
        }
        set{
            _labelColor = newValue
        }
    }
    
    private var _arrowColor: UIColor = UIColor.whiteColor()
    var arrowColor: UIColor{
        get{
            return _arrowColor
        }
        set{
            _arrowColor = newValue
        }
    }
    
    private var _headColor: UIColor = UIColor.whiteColor()
    var headColor: UIColor{
        get{
            return _headColor
        }
        set{
            _headColor = newValue
        }
    }
    
    private var _arrowWidth: CGFloat = 2.0
    var arrowWidth: CGFloat{
        get{
            return _arrowWidth
        }
        set{
            _arrowWidth = newValue
        }
    }
    
    private var _headRadius: CGFloat = 4.0
    var headRadius: CGFloat{
        get{
            return _headRadius
        }
        set{
            _headRadius = newValue
        }
    }
    
    private var _highlightView: Bool = false
    var highlightView: Bool{
        get{
            return _highlightView
        }
        set{
            _highlightView = newValue
        }
    }
    
    private var _navHeight: CGFloat = 0.0
    var navHeight: CGFloat{
        get{
            return _navHeight
        }
        set{
            _navHeight = newValue
        }
    }
    
    
    //MARK: - Self Init
    var delegate: SkipOverlayDelegate? = nil
    private var superView: UIView!
    private var helpView: UIView!
    
    init(){
        super.init(frame: CGRectZero)
        self.frame = self.topView.frame
        self.backgroundColor = _backColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawOverlay(superView: UIView, containerWidth: CGFloat, descText: String, toView: UIView, isCircle: Bool){
        self.superView = superView
        self.helpView = toView
        let targetCenter = CGPointMake(CGRectGetMinX(toView.frame), CGRectGetMidY(toView.frame))
        self.createBackgroundView()
        self.createContainerView(containerWidth)
        self.descLabel.text = descText
        self.setSection(targetCenter)
        
        self.topView.addSubview(self)
        setupContainerViewConstraints(self.topView, toPoint: targetCenter)
        
        layoutIfNeeded()
        if _highlightView{
            self.unmaskView(toView, isCircle: isCircle)
        }
        
        self.createTargetView(toView.frame, center: targetCenter)
    }
    
    //MARK: - Background View
    private var backgroundView: UIView!
    
    func createBackgroundView(){
        backgroundView = UIView()
        backgroundView.frame = self.frame
        backgroundView.userInteractionEnabled = true
        backgroundView.backgroundColor = UIColor.clearColor()
        
        self.addSubview(backgroundView)
        self.setupGestures()
    }
    
    func setupGestures(){
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(GotoNext(_:)))
        tapGest.numberOfTapsRequired = 1
        tapGest.numberOfTouchesRequired = 1
        
        self.backgroundView.addGestureRecognizer(tapGest)
    }
    
    func GotoNext(sender: UIGestureRecognizer){
        self.backgroundView.removeFromSuperview()
        self.delegate?.onSkipSignal()
    }
    
    
    //MARK: - Description Label
    private var descLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .ByWordWrapping
        lbl.sizeToFit()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .Center
        return lbl
    }()
    
    func getLabelHeight() -> CGFloat{
        let lblHeight = descLabel.frame.height
        
        return lblHeight
    }
    
    //MARK: - Container View
    private var contView: UIView!
    
    func createContainerView(width: CGFloat){
        self.descLabel.font = _labelFont
        self.descLabel.textColor = _labelColor
        
        contView = UIView()
        contView.frame = CGRectMake(0, 0, width, 50)
        contView.backgroundColor = _boxBackColor
        if _showBorder{
            contView.layer.borderColor = _boxBorderColor.CGColor
            contView.layer.borderWidth = 2
            contView.layer.cornerRadius = 5
        }
        contView.translatesAutoresizingMaskIntoConstraints = false
        contView.addSubview(descLabel)
        backgroundView.addSubview(contView)
        setupLabelConstraints()
    }
    
    func setupLabelConstraints(){
        let left = NSLayoutConstraint(item: self.descLabel, attribute: .Left, relatedBy: .Equal, toItem: self.contView, attribute: .Left, multiplier: 1.0, constant: 10.0)
        let right = NSLayoutConstraint(item: self.descLabel, attribute: .Right, relatedBy: .Equal, toItem: self.contView, attribute: .Right, multiplier: 1.0, constant: -10.0)
        let top = NSLayoutConstraint(item: self.descLabel, attribute: .Top, relatedBy: .Equal, toItem: self.contView, attribute: .Top, multiplier: 1.0, constant: 10.0)
        let bottom = NSLayoutConstraint(item: self.descLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.contView, attribute: .Bottom, multiplier: 1.0, constant: -10.0)
        
        contView.addConstraints([left, right, top, bottom])
        
        let width = NSLayoutConstraint(item: self.descLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.contView.frame.width - 10)
        self.descLabel.addConstraint(width)
    }
    
    func setupContainerViewConstraints(toView: UIView, toPoint: CGPoint){
        let section = setSection(toPoint)
        let consts = setSectionPoint(section, toView: toView)
        
        toView.addConstraints(consts)
    }
    
    //MARK: - Target Object View
    func calcCenterPoint(start: CGPoint, end: CGPoint) -> CGPoint{
        let x = (start.x + end.x) / 2
        let y = (start.y + end.y) / 2
        
        return CGPointMake(x, y)
    }
    
    func createTargetView(targetRect: CGRect, center: CGPoint){
        let section = setSection(center)
        var startPoint: CGPoint!
        var endPoint: CGPoint!
        var controlPoint: CGPoint!
        
        let dir = LineDirection.randomDir()
        let offsetTop: CGFloat = highlightView ? 15.0 : 0.0
        let offsetBottom: CGFloat = highlightView ? -15.0 : 0.0
        
        switch section{
        case 1:
            if dir == .left{
                startPoint = CGPointMake(CGRectGetMinX(contView.frame) - 5, CGRectGetMinY(contView.frame) - 10)
                endPoint = CGPointMake(CGRectGetMinX(targetRect) - 5, CGRectGetMaxY(targetRect) + self._navHeight + offsetTop)
                
                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPointMake(cp.x - 50, cp.y)
            }else{
                startPoint = CGPointMake(CGRectGetMidX(contView.frame), CGRectGetMinY(contView.frame) - 20)
                endPoint = CGPointMake(CGRectGetMaxX(targetRect) + 5, CGRectGetMaxY(targetRect) + self._navHeight + offsetTop)
                
                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPointMake(cp.x + 50, cp.y)
            }
            
            break
            
        case 2:
            if dir == .left{
                startPoint = CGPointMake(CGRectGetMidX(contView.frame) + CGRectGetMidX(contView.frame) / 4, CGRectGetMinY(contView.frame) - 10)
                endPoint = CGPointMake(CGRectGetMinX(targetRect) + 5, CGRectGetMaxY(targetRect) + self._navHeight + offsetTop)
                
                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPointMake(cp.x - 50, cp.y)
            }else{
                startPoint = CGPointMake(CGRectGetMidX(contView.frame) + CGRectGetMidX(contView.frame) / 4, CGRectGetMinY(contView.frame) - 10)
                endPoint = CGPointMake(CGRectGetMidX(targetRect) + 5, CGRectGetMaxY(targetRect) + self._navHeight + offsetTop)
                
                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPointMake(cp.x + 50, cp.y)
            }
            
            break
            
        case 3:
            if dir == .left{
                startPoint = CGPointMake(CGRectGetMidX(contView.frame) - CGRectGetMidX(contView.frame) / 4, CGRectGetMaxY(contView.frame) + 10)
                endPoint = CGPointMake(CGRectGetMinX(targetRect) + 5, CGRectGetMinY(targetRect) + self._navHeight + offsetBottom)
                
                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPointMake(cp.x - 50, cp.y)
            }else{
                startPoint = CGPointMake(CGRectGetMidX(contView.frame) - CGRectGetMidX(contView.frame) / 4, CGRectGetMaxY(contView.frame) + 10)
                endPoint = CGPointMake(CGRectGetMaxX(targetRect), CGRectGetMinY(targetRect) + self._navHeight + offsetBottom)
                
                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPointMake(cp.x + 50, cp.y)
            }
            
            break
        case 4:
            if dir == .left{
                startPoint = CGPointMake(CGRectGetMidX(contView.frame) + CGRectGetMidX(contView.frame) / 4, CGRectGetMaxY(contView.frame) + 20)
                endPoint = CGPointMake(CGRectGetMidX(targetRect) + 5, CGRectGetMinY(targetRect) + self._navHeight + offsetBottom)
                
                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPointMake(cp.x + 50, cp.y)
            }else{
                startPoint = CGPointMake(CGRectGetMidX(contView.frame), CGRectGetMaxY(contView.frame) + 10)
                endPoint = CGPointMake(CGRectGetMinX(targetRect) - 5, CGRectGetMidY(targetRect) + self._navHeight + offsetBottom)
                
                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPointMake(cp.x - 50, cp.y)
            }
            
            break
            
        default:
            break
        }
        let lineShape = drawLine(startPoint, endPoint: endPoint, controlPoint: controlPoint)
        var bubbleShape: CAShapeLayer?
        
        switch _lineType{
        case .dash_arrow:
            break
        case .dash_bubble:
            lineShape.lineDashPattern = [3, 6]
            bubbleShape = drawHead(endPoint)
            break
        case .line_arrow:
            break
        case .line_bubble:
            bubbleShape = drawHead(endPoint)
            break
        }
        
        self.backgroundView.layer.addSublayer(lineShape)
        if let bs = bubbleShape{
            self.backgroundView.layer.addSublayer(bs)
        }
        animateArrow(lineShape)
    }
    
    func drawLine(startPoint: CGPoint, endPoint: CGPoint, controlPoint: CGPoint) -> CAShapeLayer{
        let bez = UIBezierPath()
        bez.moveToPoint(CGPointMake(startPoint.x, startPoint.y))
        bez.addQuadCurveToPoint(CGPointMake(endPoint.x, endPoint.y), controlPoint: controlPoint)
        
        let shape = CAShapeLayer()
        shape.path = bez.CGPath
        shape.strokeColor = _arrowColor.CGColor
        shape.fillColor = nil
        shape.lineWidth = _arrowWidth
        shape.lineCap = kCALineCapRound
        shape.lineJoin = kCALineJoinMiter
        shape.strokeStart = 0.0
        shape.strokeEnd = 0.0
        
        return shape
    }
    
    func drawHead(endPoint: CGPoint) -> CAShapeLayer{
        let circlePath: UIBezierPath = UIBezierPath(arcCenter: CGPointMake(endPoint.x, endPoint.y), radius: _headRadius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.CGPath
        circleShape.fillColor = _headColor.CGColor
        
        return circleShape
    }
    
    func animateArrow(shape1: CAShapeLayer){
        let arrowAnim = CABasicAnimation(keyPath: "strokeEnd")
        arrowAnim.fromValue = 0.0
        arrowAnim.toValue = 1.0
        arrowAnim.duration = 0.5
        arrowAnim.autoreverses = false
        arrowAnim.fillMode = kCAFillModeForwards
        arrowAnim.removedOnCompletion = false
        
        shape1.addAnimation(arrowAnim, forKey: nil)
    }
    
    //MARK: - Tools
    func screenShotScreen() -> UIImage{
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(UIApplication.sharedApplication().keyWindow!.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
    
    func screenShotView(view: UIView) -> UIImage{
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        self.layer.renderInContext(context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        return screenShot
    }
    
    func unmaskView(toView: UIView, isCircle: Bool){
        let maskLayer = CAShapeLayer()
        let path = CGPathCreateMutable()
        
        let radius: CGFloat = isCircle ? toView.frame.width * 0.5 : 20
        let clipPath: CGPathRef = UIBezierPath(roundedRect: CGRectMake(toView.frame.origin.x - 10, toView.frame.origin.y + self._navHeight - 10, toView.frame.width + 20, toView.frame.height + 20), cornerRadius: radius).CGPath
        
        CGPathAddPath(path, nil, clipPath)
        CGPathAddRect(path, nil, CGRectMake(0, 0, self.frame.width, self.frame.height))
        
        maskLayer.backgroundColor = UIColor.blackColor().CGColor
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        self.layer.mask = maskLayer
        self.clipsToBounds = false
    }
    
    func setSection(targetPoint: CGPoint) -> Int{
        let centerPoint: CGPoint = superView.center
        
        if targetPoint == centerPoint{
            return 0
        }else if targetPoint.x < centerPoint.x && targetPoint.y < centerPoint.y{
            return 1
        }else if targetPoint.x < centerPoint.x && targetPoint.y > centerPoint.y{
            return 3
        }else if targetPoint.x > centerPoint.x && targetPoint.y < centerPoint.y{
            return 2
        }else if targetPoint.x > centerPoint.x && targetPoint.y > centerPoint.y{
            return 4
        }else{
            return 0
        }
    }
    
    func setSectionPoint(section: Int, toView: UIView) -> [NSLayoutConstraint]{
        let dynamicSpace = CGFloat(arc4random_uniform(20) + 100)
        switch section {
        case 0, 1:
            let x = NSLayoutConstraint(item: self.contView, attribute: .CenterX, relatedBy: .Equal, toItem: superView, attribute: .CenterX, multiplier: 1.0, constant: 0)
            let y = NSLayoutConstraint(item: self.contView, attribute: .Top, relatedBy: .Equal, toItem: self.helpView, attribute: .Bottom, multiplier: 1.0, constant: dynamicSpace)
            
            return [x, y]
        case 2:
            let x = NSLayoutConstraint(item: self.contView, attribute: .CenterX, relatedBy: .Equal, toItem: superView, attribute: .CenterX, multiplier: 1.0, constant: 0)
            let y = NSLayoutConstraint(item: self.contView, attribute: .Top, relatedBy: .Equal, toItem: self.helpView, attribute: .Bottom, multiplier: 1.0, constant: dynamicSpace)
            
            return [x, y]
        case 3:
            let x = NSLayoutConstraint(item: self.contView, attribute: .CenterX, relatedBy: .Equal, toItem: superView, attribute: .CenterX, multiplier: 1.0, constant: 0)
            let y = NSLayoutConstraint(item: self.contView, attribute: .Bottom, relatedBy: .Equal, toItem: self.helpView, attribute: .Top, multiplier: 1.0, constant: -dynamicSpace)
            
            return [x, y]
        case 4:
            let x = NSLayoutConstraint(item: self.contView, attribute: .CenterX, relatedBy: .Equal, toItem: superView, attribute: .CenterX, multiplier: 1.0, constant: 0)
            let y = NSLayoutConstraint(item: self.contView, attribute: .Bottom, relatedBy: .Equal, toItem: self.helpView, attribute: .Top, multiplier: 1.0, constant: -dynamicSpace)
            
            return [x, y]
            
        default:
            return []
        }
    }
    
}

extension GDOverlay{
    var topView: UIView{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.window!
    }
    
    func calculateNavHeight(vc: UIViewController) -> CGFloat{
        if let nav = vc.navigationController{
            return nav.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height
        }
        return 0.0
    }
}





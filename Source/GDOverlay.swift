//
//  GDOverlay.swift
//  SwiftyGuideOverlay
//
//  Created by Saeid Basirnia on 8/16/16.
//  Copyright © 2016 Saeidbsn. All rights reserved.
//

import UIKit

enum LineDirection: UInt32{
    case left
    case right
    
     static let _count: LineDirection.RawValue = {
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
     var _backColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    var backColor: UIColor{
        get{
            return _backColor
        }
        set{
            _backColor = newValue
        }
    }
    
     var _boxBackColor: UIColor = UIColor.white.withAlphaComponent(0.05)
    var boxBackColor: UIColor{
        get{
            return _boxBackColor
        }
        set{
            _boxBackColor = newValue
        }
    }
    
    var _boxBorderColor: UIColor = UIColor.white
    var boxBorderColor: UIColor{
        get{
            return _boxBorderColor
        }
        set{
            _boxBorderColor = newValue
        }
    }
    
    var _showBorder: Bool = true
    var showBorder: Bool{
        get{
            return _showBorder
        }
        set{
            _showBorder = newValue
        }
    }
    
    var _lineType: LineType = .dash_bubble
    var lineType: LineType{
        get{
            return _lineType
        }
        set{
            _lineType = newValue
        }
    }
    
    var _multiGuide: Bool = false
    var multiGuide: Bool{
        get{
            return _multiGuide
        }
        set{
            _multiGuide = newValue
        }
    }
    
    var _labelFont: UIFont = UIFont.boldSystemFont(ofSize: 14)
    var labelFont: UIFont{
        get{
            return _labelFont
        }
        set{
            _labelFont = newValue
        }
    }
    
    var _labelColor: UIColor = UIColor.white
    var labelColor: UIColor{
        get{
            return _labelColor
        }
        set{
            _labelColor = newValue
        }
    }
    
    var _arrowColor: UIColor = UIColor.white
    var arrowColor: UIColor{
        get{
            return _arrowColor
        }
        set{
            _arrowColor = newValue
        }
    }
    
    var _headColor: UIColor = UIColor.white
    var headColor: UIColor{
        get{
            return _headColor
        }
        set{
            _headColor = newValue
        }
    }
    
    var _arrowWidth: CGFloat = 2.0
    var arrowWidth: CGFloat{
        get{
            return _arrowWidth
        }
        set{
            _arrowWidth = newValue
        }
    }
    
    var _headRadius: CGFloat = 4.0
    var headRadius: CGFloat{
        get{
            return _headRadius
        }
        set{
            _headRadius = newValue
        }
    }
    
    var _highlightView: Bool = false
    var highlightView: Bool{
        get{
            return _highlightView
        }
        set{
            _highlightView = newValue
        }
    }
    
    var _navHeight: CGFloat = 0.0
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
     var superView: UIView!
     var helpView: UIView!
    
    init(){
        super.init(frame: CGRect.zero)
        self.frame = self.topView.frame
        self.backgroundColor = _backColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawOverlay(_ superView: UIView, containerWidth: CGFloat, descText: String, toView: UIView, isCircle: Bool){
        self.superView = superView
        self.helpView = toView
        let targetCenter = CGPoint(x: toView.frame.minX, y: toView.frame.midY)
        self.createBackgroundView()
        self.createContainerView(containerWidth)
        self.descLabel.text = descText

        self.topView.addSubview(self)
        setupContainerViewConstraints(self.topView, toPoint: targetCenter)
        
        layoutIfNeeded()
        if _highlightView{
            self.unmaskView(toView, isCircle: isCircle)
        }
        
        self.createTargetView(toView.frame, center: targetCenter)
    }
    
    //MARK: - Background View
     var backgroundView: UIView!
    
    func createBackgroundView(){
        backgroundView = UIView()
        backgroundView.frame = self.frame
        backgroundView.isUserInteractionEnabled = true
        backgroundView.backgroundColor = UIColor.clear
        
        self.addSubview(backgroundView)
        self.setupGestures()
    }
    
    func setupGestures(){
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(GotoNext(_:)))
        tapGest.numberOfTapsRequired = 1
        tapGest.numberOfTouchesRequired = 1
        
        self.backgroundView.addGestureRecognizer(tapGest)
    }
    
    func GotoNext(_ sender: UIGestureRecognizer){
        self.backgroundView.removeFromSuperview()
        self.delegate?.onSkipSignal()
    }
    
    
    //MARK: - Description Label
     var descLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.sizeToFit()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        return lbl
    }()
    
    func getLabelHeight() -> CGFloat{
        let lblHeight = descLabel.frame.height
        
        return lblHeight
    }
    
    //MARK: - Container View
     var contView: UIView!
    
    func createContainerView(_ width: CGFloat){
        self.descLabel.font = _labelFont
        self.descLabel.textColor = _labelColor
        
        contView = UIView()
        contView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        contView.backgroundColor = _boxBackColor
        if _showBorder{
            contView.layer.borderColor = _boxBorderColor.cgColor
            contView.layer.borderWidth = 2
            contView.layer.cornerRadius = 5
        }
        contView.translatesAutoresizingMaskIntoConstraints = false
        contView.addSubview(descLabel)
        backgroundView.addSubview(contView)
        setupLabelConstraints()
    }
    
    func setupLabelConstraints(){
        let left = NSLayoutConstraint(item: self.descLabel, attribute: .left, relatedBy: .equal, toItem: self.contView, attribute: .left, multiplier: 1.0, constant: 10.0)
        let right = NSLayoutConstraint(item: self.descLabel, attribute: .right, relatedBy: .equal, toItem: self.contView, attribute: .right, multiplier: 1.0, constant: -10.0)
        let top = NSLayoutConstraint(item: self.descLabel, attribute: .top, relatedBy: .equal, toItem: self.contView, attribute: .top, multiplier: 1.0, constant: 10.0)
        let bottom = NSLayoutConstraint(item: self.descLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contView, attribute: .bottom, multiplier: 1.0, constant: -10.0)
        
        contView.addConstraints([left, right, top, bottom])
        
        let width = NSLayoutConstraint(item: self.descLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.contView.frame.width - 10)
        self.descLabel.addConstraint(width)
    }
    
    func setupContainerViewConstraints(_ toView: UIView, toPoint: CGPoint){
        let section = setSection(toPoint)
        let consts = setSectionPoint(section, toView: toView)
        
        toView.addConstraints(consts)
    }
    
    //MARK: - Target Object View
    func calcCenterPoint(_ start: CGPoint, end: CGPoint) -> CGPoint{
        let x = (start.x + end.x) / 2
        let y = (start.y + end.y) / 2
        
        return CGPoint(x: x, y: y)
    }
    
    func createTargetView(_ targetRect: CGRect, center: CGPoint){
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
                startPoint = CGPoint(x: contView.frame.minX - 5, y: contView.frame.minY - 10)
                endPoint = CGPoint(x: targetRect.minX - 5, y: targetRect.maxY + self._navHeight + offsetTop)

                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPoint(x: cp.x - 50, y: cp.y)
            }else{
                startPoint = CGPoint(x: contView.frame.midX, y: contView.frame.minY - 20)
                endPoint = CGPoint(x: targetRect.maxX + 5, y: targetRect.maxY + self._navHeight + offsetTop)
                
                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPoint(x: cp.x + 50, y: cp.y)
            }
            
            break
            
        case 2:
            if dir == .left{
                startPoint = CGPoint(x: contView.frame.midX + contView.frame.midX / 4, y: contView.frame.minY - 10)
                endPoint = CGPoint(x: targetRect.minX + 5, y: targetRect.maxY + self._navHeight + offsetTop)

                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPoint(x: cp.x - 50, y: cp.y)
            }else{
                startPoint = CGPoint(x: contView.frame.midX + contView.frame.midX / 4, y: contView.frame.minY - 10)
                endPoint = CGPoint(x: targetRect.midX + 5, y: targetRect.maxY + self._navHeight + offsetTop)

                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPoint(x: cp.x + 50, y: cp.y)
            }

            break
            
        case 3:
            if dir == .left{
                startPoint = CGPoint(x: contView.frame.midX - contView.frame.midX / 4, y: contView.frame.maxY + 10)
                endPoint = CGPoint(x: targetRect.minX + 5, y: targetRect.minY + self._navHeight + offsetBottom)

                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPoint(x: cp.x - 50, y: cp.y)
            }else{
                startPoint = CGPoint(x: contView.frame.midX - contView.frame.midX / 4, y: contView.frame.maxY + 10)
                endPoint = CGPoint(x: targetRect.maxX, y: targetRect.minY + self._navHeight + offsetBottom)

                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPoint(x: cp.x + 50, y: cp.y)
            }

            break
        case 4:
            if dir == .left{
                startPoint = CGPoint(x: contView.frame.midX + contView.frame.midX / 4, y: contView.frame.maxY + 20)
                endPoint = CGPoint(x: targetRect.midX + 5, y: targetRect.minY + self._navHeight + offsetBottom)

                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPoint(x: cp.x + 50, y: cp.y)
            }else{
                startPoint = CGPoint(x: contView.frame.midX, y: contView.frame.maxY + 10)
                endPoint = CGPoint(x: targetRect.minX - 5, y: targetRect.midY + self._navHeight + offsetBottom)

                let cp = calcCenterPoint(startPoint, end: endPoint)
                controlPoint = CGPoint(x: cp.x - 50, y: cp.y)
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
    
    func drawLine(_ startPoint: CGPoint, endPoint: CGPoint, controlPoint: CGPoint) -> CAShapeLayer{
        let bez = UIBezierPath()
        bez.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
        bez.addQuadCurve(to: CGPoint(x: endPoint.x, y: endPoint.y), controlPoint: controlPoint)
        
        let shape = CAShapeLayer()
        shape.path = bez.cgPath
        shape.strokeColor = _arrowColor.cgColor
        shape.fillColor = nil
        shape.lineWidth = _arrowWidth
        shape.lineCap = kCALineCapRound
        shape.lineJoin = kCALineJoinMiter
        shape.strokeStart = 0.0
        shape.strokeEnd = 0.0
        
        return shape
    }
    
    func drawHead(_ endPoint: CGPoint) -> CAShapeLayer{
        let circlePath: UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: endPoint.x, y: endPoint.y), radius: _headRadius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = _headColor.cgColor
        
        return circleShape
    }
    
    func animateArrow(_ shape1: CAShapeLayer){
        let arrowAnim = CABasicAnimation(keyPath: "strokeEnd")
        arrowAnim.fromValue = 0.0
        arrowAnim.toValue = 1.0
        arrowAnim.duration = 0.5
        arrowAnim.autoreverses = false
        arrowAnim.fillMode = kCAFillModeForwards
        arrowAnim.isRemovedOnCompletion = false
        
        shape1.add(arrowAnim, forKey: nil)
    }
    
    //MARK: - Tools
    func screenShotScreen() -> UIImage{
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(UIApplication.shared.keyWindow!.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot!
    }
    
    func screenShotView(_ view: UIView) -> UIImage{
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        return screenShot!
    }
    
    func unmaskView(_ toView: UIView, isCircle: Bool){
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        let radius: CGFloat = isCircle ? toView.frame.width * 0.5 : 20
        let clipPath: CGPath = UIBezierPath(roundedRect: CGRect(x: toView.frame.origin.x - 10, y: toView.frame.origin.y + self._navHeight - 10, width: toView.frame.width + 20, height: toView.frame.height + 20), cornerRadius: radius).cgPath
        
        path.addPath(clipPath)
        path.addRect(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        self.layer.mask = maskLayer
        self.clipsToBounds = false
    }
    
    func setSection(_ targetPoint: CGPoint) -> Int{
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
    
    func setSectionPoint(_ section: Int, toView: UIView) -> [NSLayoutConstraint]{
        let dynamicSpace = CGFloat(arc4random_uniform(20) + 100)
        switch section {
        case 0, 1:
            let x = NSLayoutConstraint(item: self.contView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0)
            let y = NSLayoutConstraint(item: self.contView, attribute: .top, relatedBy: .equal, toItem: self.helpView, attribute: .bottom, multiplier: 1.0, constant: dynamicSpace)
            
            return [x, y]
        case 2:
            let x = NSLayoutConstraint(item: self.contView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0)
            let y = NSLayoutConstraint(item: self.contView, attribute: .top, relatedBy: .equal, toItem: self.helpView, attribute: .bottom, multiplier: 1.0, constant: dynamicSpace)
            
            return [x, y]
        case 3:
            let x = NSLayoutConstraint(item: self.contView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0)
            let y = NSLayoutConstraint(item: self.contView, attribute: .bottom, relatedBy: .equal, toItem: self.helpView, attribute: .top, multiplier: 1.0, constant: -dynamicSpace)
            
            return [x, y]
        case 4:
            let x = NSLayoutConstraint(item: self.contView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0)
            let y = NSLayoutConstraint(item: self.contView, attribute: .bottom, relatedBy: .equal, toItem: self.helpView, attribute: .top, multiplier: 1.0, constant: -dynamicSpace)
            
            return [x, y]
            
        default:
            return []
        }
    }
    
}

extension GDOverlay{
    var topView: UIView{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window!
    }
    
    func calculateNavHeight(_ vc: UIViewController) -> CGFloat{
        if let nav = vc.navigationController{
            return nav.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        }
        return 0.0
    }
}





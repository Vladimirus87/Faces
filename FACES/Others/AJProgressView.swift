//
//  ViewController.swift
//  AJProgressView
//
//  Created by Arpit Jain on 22/09/17.
//  Copyright © 2017 Arpit Jain. All rights reserved.
//
/// Animation while waiting (with logo inside)

import UIKit

class AJProgressView: UIView {

    private var objProgressView = UIView()
    private var shapeLayer = CAShapeLayer()

    
    //MARK: - Private Properties
    //MARK: -

    public var tempFrame: CGRect?
    // Pass your image here which will be used for progressView
    public var imgLogo: UIImage = UIImage(named:"smallLogo")!
   
    // Pass your color here which will be used as layer color
    public var firstColor: UIColor? = #colorLiteral(red: 0.7123540044, green: 0.1004048362, blue: 0.1138514802, alpha: 1)
   
    // Add second and third colour if you want layer to have multiple colors. It will show animated colors on progressView layer
    public var secondColor: UIColor?
    public var thirdColor: UIColor?
    
    // Use this to set the speed of progressView
    public var duration: CGFloat = 3.0
    
    // Use this to set the line width of layer
    public var lineWidth: CGFloat = 4.0
    
    // Change background color of progressView
    public var bgColor = UIColor.clear
   
    // Returns bool for animating status of progressView
    public var isAnimating : Bool?

    //MARK: - AJProgressViewSetup Private Functions
    //MARK: -

    private func setupAJProgressView() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (appDelegate.window?.subviews.contains(objProgressView))! {
            appDelegate.window?.bringSubview(toFront:objProgressView)
        }else{
            appDelegate.window?.addSubview(objProgressView)
            appDelegate.window?.bringSubview(toFront: objProgressView)
        }
        objProgressView.backgroundColor = bgColor
        objProgressView.frame = tempFrame ?? UIScreen.main.bounds
        objProgressView.layer.zPosition = 1

        self.backgroundColor = bgColor

        let innerView = UIView()
        innerView.frame = tempFrame ?? CGRect.zero
        innerView.backgroundColor = UIColor.clear
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = firstColor?.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.lineWidth = lineWidth
        
        let center = CGPoint(x: innerView.bounds.size.width / 2.0, y: innerView.bounds.size.height / 2.0)
        let radius = min(innerView.bounds.size.width, innerView.bounds.size.height)/2.0 - self.shapeLayer.lineWidth / 2.0
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.frame = innerView.bounds
        innerView.layer.addSublayer(shapeLayer)
        self.addSubview(innerView)
       
        let imgViewLogo = UIImageView()
        imgViewLogo.image = imgLogo
        imgViewLogo.contentMode = .scaleAspectFit
        imgViewLogo.backgroundColor = UIColor.clear
        imgViewLogo.clipsToBounds = true
        imgViewLogo.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.addSubview(imgViewLogo)
        
        imgViewLogo.center = innerView.center
        objProgressView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        objProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        let xConstraint = NSLayoutConstraint(item: objProgressView, attribute: .centerX, relatedBy: .equal, toItem: appDelegate.window!, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: objProgressView, attribute: .centerY, relatedBy: .equal, toItem: appDelegate.window!, attribute: .centerY, multiplier: 1, constant: 0)
        
        appDelegate.window?.addConstraint(xConstraint)
        appDelegate.window?.addConstraint(yConstraint)

        self.centerXAnchor.constraint(equalTo: objProgressView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: objProgressView.centerYAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        self.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
    }
    
    private func animateStrokeEnd() -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = 0
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return animation
    }
    
    private func animateStrokeStart() -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = CFTimeInterval(duration / 2.0)
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return animation
    }
    
    private func animateRotation() -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = Float.infinity
        
        return animation
    }
    
    private func animateColors() -> CAKeyframeAnimation {
        
        let colors = configureColors()
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.duration = CFTimeInterval(duration)
        animation.keyTimes = configureKeyTimes(colors: colors)
        animation.values = colors
        animation.repeatCount = Float.infinity
        return animation
    }
    
    private func animateGroup() {
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animateStrokeEnd(), animateStrokeStart(), animateRotation(), animateColors()]
        animationGroup.duration = CFTimeInterval(duration)
        animationGroup.fillMode = kCAFillModeBoth
        animationGroup.isRemovedOnCompletion = false
        animationGroup.repeatCount = Float.infinity
        shapeLayer.add(animationGroup, forKey: "loading")
    }
    
    private func startAnimating() {
        isAnimating = true
        animateGroup()
    }
    
    private func stopAnimating() {
        isAnimating = false
        shapeLayer.removeAllAnimations()
    }
    
    private func configureColors() -> [CGColor] {
        var colors = [CGColor]()
        colors.append((firstColor?.cgColor)!)
        if secondColor != nil { colors.append((secondColor?.cgColor)!) }
        if thirdColor != nil { colors.append((thirdColor?.cgColor)!) }
        
        return colors
    }
    
    private func configureKeyTimes(colors: [CGColor]) -> [NSNumber] {
        switch colors.count {
        case 1:
            return [0]
        case 2:
            return [0, 1]
        default:
            return [0, 0.5, 1]
        }
    }

    //MARK: - Public Functions
    //MARK: -

    public func show() {
        
        self.setupAJProgressView()
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.alpha = 1.0
            self.startAnimating()
            
        }, completion: {(finished: Bool) -> Void in })
    }
    
    public func hide() {
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            self.stopAnimating()
            self.removeFromSuperview()
        })
    }
}

//
//  SlidingGenericViewController.swift
//  PayWandDemo
//
//  Created by Farid on 7/26/16.
//  Copyright © 2016 Farid. All rights reserved.
//

import UIKit
import EasyPeasy

open class SlidingGenericViewController: TopDownGenericViewController, UIViewControllerTransitioningDelegate {

    public var slidingView : UIView!
    public var middleXConst : NSLayoutConstraint!
    public var presenetViewControllerSlidingFromLeft : Bool = false
    
    fileprivate let slidingShowTransitionAnimation = SlidingShowTransitionAnimation()
    fileprivate let slidingDismissTransitionAnimation = SlidingDismissTransitionAnimation()
    
    public let slideInteractionController = SlideInteractionController()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        initElements()
        setConstraints()
        // Do any additional setup after loading the view.
    }
    
    func setConstraints(){
        if (middleXConst == nil){
            middleXConst = slidingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            middleXConst.isActive = true
        }
    }
    
    open func initElements(){
        fatalError("override in child class")
    }
    
    override open func setUIElements(){
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "bgDark")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (presenetViewControllerSlidingFromLeft){
            presenetViewControllerSlidingFromLeft = false
            return slidingDismissTransitionAnimation
        } else {
            return slidingShowTransitionAnimation
        }
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return slidingDismissTransitionAnimation
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return slideInteractionController.interactionInProgress ? slideInteractionController : nil
    }
}

open class SlidingAccountSetupViewController: SlidingGenericViewController {
    fileprivate var logoView : UIView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    open override func initElements(){
        
        slidingView = UIView()
        view.addSubview(slidingView)
        slidingView.translatesAutoresizingMaskIntoConstraints = false
        slidingView <- [
            Width(*0.8).like(self.view).with(Priority.mediumPriority),
            Width(<=400).with(Priority.highPriority),
            Height(*0.45).like(self.view),
        ]
        middleXConst = slidingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        middleXConst.isActive = true
        
        logoView = UIView()
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)
        logoView <- [
            Width(*0.8).like(view),
            //Height(*0.3).like(view),
            CenterX().to(view),
            Bottom().to(slidingView, .top)
        ]
        
        let logoLabel = UILabel()
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoView.addSubview(logoLabel)
        logoLabel.textColor = UIColor.TtroColors.white.color
        logoLabel.font = UIFont.TtroFonts.regular(size: 50).font
        logoLabel.text = "Daric"
        logoLabel <- [
            CenterY(20),
            CenterX().to(logoView, .centerX)
        ]
        
        setView(logoView, middleView: slidingView)
    }
}

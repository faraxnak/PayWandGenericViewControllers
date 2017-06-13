//
//  SlidingActionViewController.swift
//  PayWand
//
//  Created by Farid on 10/20/16.
//  Copyright © 2016 Farid. All rights reserved.
//

import UIKit
import EasyPeasy

public protocol SlidingActionViewControllerDelegate : class {
    func actionType() -> SlidingActionViewController.ActionType
}

public class SlidingActionViewController: SlidingGenericViewController {
    
    fileprivate var logoView : UIView!
    
    var cancelButton : UIButton!
    
    var presenterViewController : GenericViewController!
    
    var type = ActionType.Topup

    public enum ActionType : String {
        case Topup = "Top Up"
        case Cashout = "Cash Out"
        case Exchange
        case Send
        case Search
        case BankAccount = "Bank Account"
    }
    
    var typeDelegate : SlidingActionViewControllerDelegate!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func initElements(){
        slidingView = UIView()
        view.addSubview(slidingView)
        //slidingView.translatesAutoresizingMaskIntoConstraints = false
        slidingView <- [
            Width(*0.8).like(self.view).with(Priority.custom(999)),
            Width(<=min(400, view.frame.width)).with(Priority.custom(1000)),
            Height(*0.5).like(self.view),
        ]
        
        middleXConst = slidingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        middleXConst.isActive = true
        
        //slidingView.backgroundColor = UIColor.orangeColor()
        
        logoView = UIView()
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)
        logoView <- [
            Width(*0.8).like(view),
            //Height(*0.3).like(view),
            CenterX().to(view),
            Bottom().to(slidingView, .top)
        ]
        
        //setActionNameIcon()
        type = typeDelegate.actionType()
        
        let actionLabel = UILabel()
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        logoView.addSubview(actionLabel)
        actionLabel.textColor = UIColor.TtroColors.white.color
        actionLabel.font = UIFont.TtroPayWandFonts.regular4.font
        actionLabel.text = type.rawValue
        actionLabel <- [
            CenterY(),
            CenterX().to(logoView, .centerX)
        ]
        actionLabel.textColor = UIColor.TtroColors.cyan.color
        view.layoutIfNeeded()
        
        let actionIconView = UIImageView(image: UIImage(named: type.rawValue + "Icon"))
        actionIconView.translatesAutoresizingMaskIntoConstraints = false
        logoView.addSubview(actionIconView)
        actionIconView.contentMode = .scaleAspectFit
        actionIconView <- [
            CenterY().to(actionLabel),
            Right(5).to(actionLabel, .left),
            Height(35),
            Width().like(actionIconView, .height)
        ]
        actionIconView.image? = (actionIconView.image?.withRenderingMode(.alwaysTemplate))!
        
        actionIconView.tintColor = UIColor.TtroColors.cyan.color
        
        
        cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        logoView.addSubview(cancelButton)
        cancelButton <- [
            Right(),
            Top(),
            Height(35),
            Width(38)
        ]
        cancelButton.tintColor = UIColor.TtroColors.white.color
        cancelButton.setImage(UIImage(named: "closeIcon"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(self.onCancel(_:)), for: .touchUpInside)
        
        setView(logoView, middleView: slidingView) //, offset: view.frame.height/10
    }
    
//    func setActionNameIcon() {
//        fatalError("override in child class")
//    }
    
    func onCancel(_ sender : UIButton) {
//        self.transitioningDelegate = presenterViewController
        dismiss(animated: true, completion: nil)
    }
}

class ScrollSlidingActionViewController: SlidingActionViewController {
    
    var stackView : UIStackView!
    var scrollView : UIScrollView!
    
    override func initElements() {
        super.initElements()
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        slidingView.addSubview(scrollView)
        scrollView <- Edges()
        
        stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        stackView <- Edges()
        stackView <- [
            Width().like(slidingView)
        ]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (scrollView != nil){
            scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
        }
    }
}

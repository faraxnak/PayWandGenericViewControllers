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

public protocol SlidingViewHeightDelegate : class {
    func heightCoeff() -> CGFloat
}

open class SlidingActionViewController: SlidingGenericViewController {
    
//    fileprivate var logoView : UIView!
    
    public var cancelButton : UIButton!
    
    public weak var presenterViewController : GenericViewController!
    
    public var type = ActionType.Topup
    
    public var actionIconView : UIImageView!
    public var actionLabel : UILabel!

    public enum ActionType : String {
        case Topup = "Top Up"
        case Cashout = "Cash Out"
        case Exchange
        case Send
        case Search
        case BankAccount = "Bank Account"
        case Information
        case TouristCard = "Tourist Card"
        case BlockCard = "Block Card"
        case ReissueCard = "Reissue Card"
        case FAQ
        case Pay = "Purchase"
        case Hotel
        case Airline
        case Insurance
        case SimCard
        case Restaurant
        case Transportation
        case Taxi
        case Tour
    }
    
    public var typeDelegate : SlidingActionViewControllerDelegate!
    public var heightDelegate : SlidingViewHeightDelegate?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    open override func initElements(){
        slidingView = UIView()
        view.addSubview(slidingView)
        //slidingView.translatesAutoresizingMaskIntoConstraints = false
        let heightCoeff : CGFloat = heightDelegate?.heightCoeff() ?? 0.5
        slidingView.easy.layout([
            Width(*0.8).like(self.view).with(Priority.custom(999)),
            Width(<=min(400, view.frame.width)).with(Priority.custom(1000)),
            Height(*heightCoeff).like(self.view),
        ])
        
        middleXConst = slidingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        middleXConst.isActive = true
        
        setView(initLogoView(), middleView: slidingView) //, offset: view.frame.height/10
    }
    
    open func onCancel(_ sender : UIButton) {
        self.transitioningDelegate = presenterViewController as? UIViewControllerTransitioningDelegate
        var pVC = presenterViewController
        while pVC is SlidingActionViewController {
            if let vc = (pVC as? SlidingActionViewController)?.presenterViewController {
                pVC = vc
            }
        }
        pVC?.dismiss(animated: true, completion: nil)
    }
    
    open func initLogoView() -> UIView{
        let logoView = UIView()
        view.addSubview(logoView)
        logoView.easy.layout([
            Width(*0.9).like(view),
            CenterX().to(view),
            Bottom().to(slidingView, .top),
            ])
        
        let typeView = UIView()
        logoView.addSubview(typeView)
        typeView.easy.layout([
            Center(),
            Height().like(logoView),
            Width(<=0*0.8).like(logoView)
            ])
        
        type = typeDelegate.actionType()
        
        actionLabel = UILabel()
        
        typeView.addSubview(actionLabel)
        actionLabel.textColor = UIColor.TtroColors.white.color
        actionLabel.font = UIFont.TtroPayWandFonts.regular4.font
        actionLabel.text = type.rawValue
        actionLabel.easy.layout([
            Center(),
    
            Right()
            ])
        actionLabel.textColor = UIColor.TtroColors.cyan.color
        actionLabel.adjustsFontSizeToFitWidth = true
        
        
        actionIconView = UIImageView(image: UIImage(named: type.rawValue + "Icon"))
        typeView.addSubview(actionIconView)
        actionIconView.contentMode = .scaleAspectFit
        actionIconView.easy.layout([
            CenterY().to(actionLabel),
            Right(5).to(actionLabel, .left),
            Height(35),
            Width().like(actionIconView, .height),
            Left()
            ])
        actionIconView.image? = (actionIconView.image?.withRenderingMode(.alwaysTemplate))!
        
        actionIconView.tintColor = UIColor.TtroColors.cyan.color
        
        
        cancelButton = UIButton(type: .system)
        logoView.addSubview(cancelButton)
        cancelButton.easy.layout([
            Right(),
            Top(),
            Height(35),
            Width(38)
            ])
        cancelButton.tintColor = UIColor.TtroColors.white.color
        cancelButton.setImage(UIImage(named: "closeIcon"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(self.onCancel(_:)), for: .touchUpInside)
        return logoView
    }
}

open class ScrollSlidingActionViewController: SlidingActionViewController {
    
    public var stackView : UIStackView!
    public var scrollView : UIScrollView!
    
    open override func initElements() {
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
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (scrollView != nil){
            scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
        }
    }
}

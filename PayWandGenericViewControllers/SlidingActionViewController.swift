//
//  SlidingActionViewController.swift
//  PayWand
//
//  Created by Farid on 10/20/16.
//  Copyright © 2016 Farid. All rights reserved.
//

import UIKit
import EasyPeasy
import PayWandBasicElements


public protocol SlidingActionViewControllerDelegate : class {
    func actionType() -> SlidingActionViewController.ActionType
}

open class SlidingActionViewController: SlidingGenericViewController {
    
    public var cancelButton : UIButton!
    
    public weak var presenterViewController : GenericViewController!
    
    public var type = ActionType.Topup
    
    public var actionIconView : UIImageView!
    public var actionLabel : UILabel!
    
    open override var slidingViewHeightCoeff: CGFloat { return 0.5 }

    public enum ActionType : String {
        case Topup = "Top Up"
        case Cashout = "Cash Out"
        case Exchange
        case Send
        case Search
        case BankAccount = "Bank Account"
//        case Information
        case Document
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
        case Support
    }
    
    public var typeDelegate : SlidingActionViewControllerDelegate!
//    public var heightDelegate : SlidingViewHeightDelegate?
    
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
    
    open func onCancel(_ sender : UIButton) {
        if presenterViewController != nil {
            self.transitioningDelegate = presenterViewController as? UIViewControllerTransitioningDelegate
            var pVC = presenterViewController
            pVC?.shouldUpdateDataFromServer = false
            while pVC is SlidingActionViewController {
                if let vc = (pVC as? SlidingActionViewController)?.presenterViewController {
                    pVC = vc
                }
            }
            pVC?.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override open func initLogoView() -> UIView{
        let logoView = UIView()
        view.addSubview(logoView)
        logoView.easy.layout([
            Width(*0.9).like(view),
            CenterX().to(view),
            Bottom().to(slidingView, .top).with(Priority.medium),
            Height(<=(-20)*0.2).like(view)
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
    
    open override var slidingViewHeightCoeff: CGFloat { return 0.6 }
    
    open override func initElements() {
        super.initElements()
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        slidingView.addSubview(scrollView)
//        scrollView.easy.layout(Edges())
        scrollView.easy.layout([
            Leading(),
            Trailing(),
            Top(>=0),
            Bottom(<=0),
            CenterY(),
            Top(>=0).to(view, .top)
            ])
        
        stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
//        stackView.easy.layout(Edges())
        stackView.easy.layout([
            Leading(),
            Trailing(),
            Top(),
            Bottom(),
            Width().like(scrollView),
            Height().like(scrollView).with(Priority.medium)
        ])
        
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (scrollView != nil &&
            stackView != nil){
            scrollView.contentSize = CGSize(width: stackView.frame.width,
                                            height: stackView.frame.height)
            
//            scrollView.frame = CGRect(origin: scrollView.frame.origin,
//                                      size: CGSize(width: scrollView.frame.width,
//                                                   height: min(stackView.frame.height, view.frame.height)))
        }
    }
}

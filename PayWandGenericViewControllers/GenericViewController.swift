//
//  AccountSetupGenericViewController.swift
//  PayWandDemo
//
//  Created by Farid on 5/28/16.
//  Copyright © 2016 Farid. All rights reserved.
//

import UIKit
//import NYAlertViewController
import UIColor_Hex_Swift
import EasyPeasy
import NVActivityIndicatorView
import TtroAlertViewController
import PayWandBasicElements

open class GenericViewController: UIViewController, UITextFieldDelegate {
    
    public var activityIndicatorParentView : UIView!
    //    var activityIndicatorView : UIActivityIndicatorView!
    public var activityDescriptionLabel : UILabel!
    //let spinner = ALThreeCircleSpinner(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    public let nvActivityIndicatorView = TtroActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballPulse, color: UIColor.TtroColors.cyan.color, padding: 5)
    //    let nvActivityIndicatorView = TtroActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 40), config: TKRubberPageControlConfig())
    public var bottomView : UIView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        initActivityIndicator()
        initBottomView()
        setBottomViewConstraints()
        
        setUIElements()
    }
    
    //Changing Status Bar
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        //super.preferredStatusBarStyle()
        //LightContent
        return UIStatusBarStyle.lightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }
    
    open func setUIElements(){
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "bg")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    public func initActivityIndicator(){
        activityIndicatorParentView = UIView()//UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        activityIndicatorParentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorParentView)
        
        activityIndicatorParentView.addSubview(nvActivityIndicatorView)
        nvActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        nvActivityIndicatorView <- [
            Center(),
            Width(60),
            Height(60)
        ]
        
        activityDescriptionLabel = UILabel()
        activityIndicatorParentView.addSubview(activityDescriptionLabel)
        activityDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        activityDescriptionLabel <- [
            Top(5),
            CenterX()
        ]
        activityDescriptionLabel.textColor = UIColor.darkGray
    }
    
    func setBottomViewConstraints(){
        guard bottomView != nil else {
            return
        }
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        if let offset = self.tabBarController?.tabBar.frame.height {
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1 * offset - 30).isActive = true
        } else {
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        }
        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 46).isActive = true
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func initBottomView(){
        
    }
    
    public func showActivityIndicator(){
        view.addSubview(activityIndicatorParentView!)
        activityIndicatorParentView.layer.masksToBounds = true
        //activityIndicatorBlurView.layer.cornerRadius = 10
        activityIndicatorParentView <- [
            Center(),
            Width().like(view),
            Height(60)
        ]
        //spinner.startAnimating()
        nvActivityIndicatorView.startAnimation()
        view.layoutIfNeeded()
    }
    
    public func hideActivityIndicator(){
        nvActivityIndicatorView.stopAnimation()
        UIView.animate(withDuration: 0.4, animations: {
            self.activityIndicatorParentView!.alpha = 0
        }, completion: {_ in
            self.activityIndicatorParentView.removeFromSuperview()
            self.activityIndicatorParentView.alpha = 1
        })
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        if let tf = textField as? TtroTextField {
            tf.setToNormalState()
        }
    }
    
    open func findViewById(view: UIView, identifier : String) -> UIView? {
        if view.accessibilityIdentifier?.compare(identifier, options: String.CompareOptions.caseInsensitive) == .orderedSame {
            return view
        }
        for v in view.subviews {
            if let a = findViewById(view: v, identifier: identifier) { return a }
        }
        return nil
    }
}

// MARK : Create a Ttro alert view controller
extension GenericViewController : TtroAlertViewControllerDelegate {
    public func isPresentedOnTabbar(fromVC viewController: UIViewController) -> Bool {
        //        return false
        return viewController is GooeyTabbarGeneric
    }
    
    public func getFrontView() -> UIView {
        let snapshot : UIView?
        if let tb = self.tabBarController {
            snapshot = tb.view.snapshotView(afterScreenUpdates: false)
            //snapshot.backgroundColor = UIColor.TtroColors.DarkBlue.color
        } else if let gooey = presentingViewController?.presentedViewController as? GooeyTabbarGeneric{
            snapshot = gooey.view.snapshotView(afterScreenUpdates: false)
        } else {
            snapshot = view.snapshotView(afterScreenUpdates: true)
        }
        
        return snapshot ?? UIView(frame: view.frame)
    }
    
    public func createAlert(title: String, message : String, type : TtroAlertType) -> TtroAlertViewController{
        let alertController = TtroAlertViewController(title: title, message: message, type: type)
        alertController.delegate = self
        alertController.view.layoutIfNeeded()
        return alertController
    }
}

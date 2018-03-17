//
//  GenericViewController.swift
//  PayWandDemo
//
//  Created by Farid on 5/26/16.
//  Copyright © 2016 Farid. All rights reserved.
//

import UIKit
import PayWandBasicElements
import EasyPeasy

open class TopDownGenericViewController: GenericViewController {
    
    fileprivate var middleViewCenterYOffset : CGFloat = 0
    fileprivate var topViewTopConstraint : NSLayoutConstraint?
    
    public var middleViewCenterYConstraint : NSLayoutConstraint?
    
    public var topView : UIView?
    public var middleView : UIView?
    
    public var currentState : State = .down
    public var nextState : State = .none
    
    public var tapGestureRecognizer : UITapGestureRecognizer!
    
    public var currentTextField : UITextField?
    
    public enum State {
        case up
        case down
        case transient
        case none
    }
    
    open override func viewDidLoad() {
        let bckgrndView = UIView()
        view.addSubview(bckgrndView)
        bckgrndView <- Edges()
        let bckgrndTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        bckgrndView.addGestureRecognizer(bckgrndTapGestureRecognizer)
        
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func setView(_ topView : UIView?, middleView : UIView?, offset : CGFloat = 0){
        self.topView = topView
        self.middleView = middleView
        view.layoutIfNeeded()
        keyboardAlignment(offset: offset)
    }
    
    func keyboardAlignment(offset constant : CGFloat = 0){
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        topViewTopConstraint = topView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20)
        topViewTopConstraint!.isActive = true
        
        middleViewCenterYConstraint = middleView!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant : constant)
        
        middleViewCenterYConstraint?.isActive = true
        middleViewCenterYOffset = middleView!.frame.height/4
    }
    
    open func keyboardWillShow(_ notification: Notification) {
        if (nextState == .up && currentState == .down){
            interactWithKeyboardState(true, notification: notification)
        } else if (nextState == .down && currentState == .up) {
            interactWithKeyboardState(false, notification: notification)
        } else {
            nextState = .none
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if (nextState == .down && currentState == .up){
            interactWithKeyboardState(false, notification: notification)
        } else {
            nextState = .none
        }
    }
    
    open func interactWithKeyboardState(_ willShow : Bool, notification: Notification){
        
        let keyboardAnimationDetail = (notification as NSNotification).userInfo!
        let duration = keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] as? Double
        let curve = keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] as? UInt
        UIView.animate(withDuration: duration!, delay: 0, options: UIViewAnimationOptions(rawValue: curve!), animations: {
            self.currentState = .transient
            if (willShow){
                self.topView!.alpha = 0.5
                self.middleViewCenterYConstraint!.constant -= self.middleViewCenterYOffset
            } else {
                self.topView!.alpha = 1
                self.middleViewCenterYConstraint!.constant += self.middleViewCenterYOffset
            }
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
        }, completion: {_ in
            if (willShow) {
                self.currentState = .up
            } else {
                self.currentState = .down
            }
            self.nextState = .none
        })
        
    }
    
    
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if !textField.isKind(of: TtroTextField.self) ||
            (textField as? TtroTextField)?.shouldMoveUpOnBeginEdit == true {
            if (nextState != .up){
                nextState = .down
            }
            return (currentState != .transient)
        } else {
            return true
        }
        //return keyBoardShown
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !textField.isKind(of: TtroTextField.self) ||
            (textField as? TtroTextField)?.shouldMoveUpOnBeginEdit == true {
            if #available(iOS 11.0, *) {
                if (currentState != .up){
                    nextState = .up
                }
            } else {
                nextState = .up
            }
        }
        return true
    }
    
    open override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let tf = textField as? TtroTextField {
            tf.checkValidity()
        }
        currentTextField = nil
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let ttroTextField = textField as? TtroTextField else {
            return true
        }
        
        return ttroTextField.checkInputCharacters(shouldChangeCharactersIn: range, replacementString: string)
    }
    
    open func handleTap(_ recognizer: UITapGestureRecognizer){
        view.endEditing(false)
    }
}

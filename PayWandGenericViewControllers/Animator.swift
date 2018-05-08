//
//  Animator.swift
//  PayWandGenericViewControllers
//
//  Created by Farid on 6/11/17.
//  Copyright © 2017 ParsPay. All rights reserved.
//

import Foundation

public class SlidingShowTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        let containerView = transitionContext.containerView
        if let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? SlidingGenericViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? SlidingGenericViewController {
            slideTransitionNormal(transitionContext: transitionContext, fromVC: fromVC, toVC: toVC, containerView: containerView)
        } else if let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? SlidingGenericViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? GooeyTabbarGeneric {
            slideTransitionToGooeyTabbar(transitionContext: transitionContext, toVC: toVC, containerView: containerView)
        }
        else if let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? SlidingGenericViewController,
            let middleVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UITabBarController,
            let toVC =  middleVC.selectedViewController as? GenericViewController {
            slideToAccountState(transitionContext: transitionContext, fromVC: fromVC, middleVC: middleVC, toVC: toVC, containerView: containerView)
        } else if let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to){
            simpleTransition(transitionContext: transitionContext, toVC: toVC, containerView: containerView)
        } else {
            
        }
    }
    
    func slideTransitionToGooeyTabbar(transitionContext : UIViewControllerContextTransitioning ,toVC : GooeyTabbarGeneric, containerView : UIView){
        //2
        containerView.addSubview(toVC.view)
        let curtain = UIView(frame: containerView.frame)
        curtain.backgroundColor = UIColor.TtroColors.darkBlue.color
        containerView.insertSubview(curtain, aboveSubview: toVC.view)
        curtain.alpha = 0
        toVC.view.alpha = 0
        
        //3
        let duration = transitionDuration(using: transitionContext)
        
        //4
        UIView.animate(withDuration: duration/3, animations: {
            //snapshot?.frame = finalFrameForVC.offsetBy(dx: 0, dy: 0)
            curtain.alpha = 1
        }, completion: { finished in
            toVC.view.alpha = 1
            toVC.gooeyTabbar.alpha = 0
            UIView.animate(withDuration: duration/3, animations: {
                curtain.frame = toVC.gooeyTabbar.frame
                containerView.layoutIfNeeded()
            }, completion: { finished in
                containerView.bringSubview(toFront: toVC.view)
                curtain.removeFromSuperview()
                toVC.view.insertSubview(curtain, belowSubview: toVC.containerView)
                UIView.animate(withDuration: duration/3, animations: {
                    toVC.gooeyTabbar.alpha = 1
                }, completion: { finished in
                    containerView.addSubview(toVC.view) 
                    curtain.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            })
        })
    }
    
    func slideTransitionNormal(transitionContext : UIViewControllerContextTransitioning, fromVC : SlidingGenericViewController ,toVC : SlidingGenericViewController, containerView : UIView){
        //2
        let finalFrameForVC = transitionContext.finalFrame(for: toVC)
        let bounds = UIScreen.main.bounds
        toVC.view.frame = finalFrameForVC.offsetBy(dx: bounds.size.width, dy: 0)
        containerView.addSubview(toVC.view)
        
        //3
        let duration = transitionDuration(using: transitionContext)
        containerView.layoutIfNeeded()
        
        //4
        UIView.animate(withDuration: duration, animations: {
            toVC.middleXConst.constant -= containerView.frame.width
            fromVC.middleXConst.constant -= containerView.frame.width
            //                toVC.view.frame = finalFrameForVC
            containerView.layoutIfNeeded()
        }, completion: {
            finished in
            toVC.view.frame = finalFrameForVC
            toVC.middleXConst.constant += containerView.frame.width
            fromVC.middleXConst.constant += containerView.frame.width
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func slideToAccountState(transitionContext : UIViewControllerContextTransitioning, fromVC : SlidingGenericViewController, middleVC : UITabBarController ,toVC : GenericViewController, containerView : UIView){
        //2
        let finalFrameForVC = transitionContext.finalFrame(for: middleVC)
        let bounds = UIScreen.main.bounds
        //toVC.view.frame = CGRectOffset(finalFrameForVC, bounds.size.width, 0)
        //containerView.addSubview(toVC.view)
        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        snapshot?.frame = finalFrameForVC.offsetBy(dx: 0, dy: -bounds.size.height)
        print(snapshot?.frame ?? CGRect.zero)
        containerView.insertSubview(snapshot!, aboveSubview: fromVC.view)
        
        middleVC.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: middleVC.tabBar.frame.height)
        containerView.addSubview(middleVC.view)
        //middleVC.view.alpha = 0
        toVC.view.alpha = 0
        
        //3
        let duration = transitionDuration(using: transitionContext)
        containerView.layoutIfNeeded()
        
        //4
        UIView.animate(withDuration: duration/2, animations: {
            snapshot?.frame = finalFrameForVC.offsetBy(dx: 0, dy: 0)
            containerView.layoutIfNeeded()
        }, completion: {
            finished in
            UIView.animate(withDuration: duration/2, animations: {
                
                middleVC.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: 0)
                containerView.layoutIfNeeded()
            }, completion: {
                finished in
                toVC.view.alpha = 1
                snapshot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
    }
    
    func simpleTransition(transitionContext : UIViewControllerContextTransitioning ,toVC : UIViewController, containerView : UIView){
        let finalFrameForVC = transitionContext.finalFrame(for: toVC)
        let bounds = UIScreen.main.bounds
        toVC.view.frame = finalFrameForVC.offsetBy(dx: -bounds.size.width, dy: 0)
        containerView.addSubview(toVC.view)
        
        //3
        let duration = transitionDuration(using: transitionContext)
        containerView.layoutIfNeeded()
        
        //4
        UIView.animate(withDuration: duration, animations: {
            toVC.view.frame = finalFrameForVC
            containerView.layoutIfNeeded()
        }, completion: {
            finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

public class SlidingDismissTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? SlidingGenericViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? SlidingGenericViewController else {
                return
        }
        let containerView = transitionContext.containerView
        //2
        let finalFrameForVC = transitionContext.finalFrame(for: toVC)
        let bounds = UIScreen.main.bounds
        //toVC.view.frame = CGRectOffset(finalFrameForVC, -1*bounds.size.width, 0)
        fromVC.view.frame = finalFrameForVC.offsetBy(dx: bounds.size.width, dy: 0)
        toVC.middleXConst.constant -= containerView.frame.width
        fromVC.middleXConst.constant -= containerView.frame.width
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        //3
        let duration = transitionDuration(using: transitionContext)
        containerView.layoutIfNeeded()
        
        //4
        UIView.animate(withDuration: duration, animations: {
            toVC.middleXConst.constant += containerView.frame.width
            fromVC.middleXConst.constant += containerView.frame.width
            containerView.layoutIfNeeded()
        }, completion: {
            finished in
            fromVC.view.frame = finalFrameForVC
            fromVC.view.layoutIfNeeded()
            if transitionContext.transitionWasCancelled {
                //                    toVC.middleXConst.constant += containerView.frame.width / 2
                print(fromVC.middleXConst.constant)
                fromVC.middleXConst.constant += 0.1
                //                    toVC.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}

public class SlideInteractionController: UIPercentDrivenInteractiveTransition {
    public var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: SlidingGenericViewController?
    
    public func wireToViewController(viewController: SlidingGenericViewController?) {
        self.viewController = viewController
        prepareGestureRecognizerInView(view: viewController?.view)
    }
    
    private func prepareGestureRecognizerInView(view: UIView?) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        gesture.edges = UIRectEdge.left
        view?.addGestureRecognizer(gesture)
    }
    
    public func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        guard viewController != nil else {
            interactionInProgress = false
            return
        }
        
        // 1
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            // 2
            interactionInProgress = true
            viewController!.dismiss(animated: true, completion: nil)
            
        case .changed:
            // 3
            shouldCompleteTransition = progress > 0.5
            update(progress)
            
        case .cancelled:
            // 4
            interactionInProgress = false
            cancel()
            
        case .ended:
            // 5
            interactionInProgress = false
            
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
            
        default:
            print("Unsupported")
        }
    }
}

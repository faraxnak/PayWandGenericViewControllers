//
//  TtroActivityIndicatorView.swift
//  PayWand
//
//  Created by Farid on 11/28/16.
//  Copyright © 2016 Farid. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EasyPeasy

public class TtroActivityIndicatorView: UIView {
    let delay : Double = 0.5
    var finished = false
    var activityViewer : NVActivityIndicatorView!
    public convenience init(frame: CGRect, type: NVActivityIndicatorType?, color: UIColor?, padding:
        CGFloat?) {
        self.init(frame: frame)
        activityViewer = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
        addSubview(activityViewer)
        activityViewer <- Edges()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func startAnimation() {
        finished = false
        isHidden = true
        Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(self.delayedAnimation), userInfo: nil, repeats: false)
    }
    
    public func delayedAnimation() {
        if !finished {
            isHidden = false
            activityViewer.startAnimating()
        }
    }
    
    public func stopAnimation() {
        finished = true
        isHidden = false
        activityViewer.stopAnimating()
        //removeFromSuperview()
//        UIView.animate(withDuration: 0.4, animations: {
//            self.alpha = 0
//        }, completion: {_ in
//            self.removeFromSuperview()
//            self.alpha = 1
//        })
    }
}

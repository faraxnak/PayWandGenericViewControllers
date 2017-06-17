//
//  GooeyTabbarGenericViewController.swift
//  RadiusBlurMenu
//
//  Created by Farid on 9/27/16.
//  Copyright © 2016 Farid. All rights reserved.
//

import UIKit
import EasyPeasy
import SwiftDate
import TtroGooeyTabbar
import PayWandBasicElements

public protocol GooeyTabbarGeneric : class {
    var view: UIView! {get set}
    var containerView: UIView! {get set}
    var gooeyTabbar: TabbarMenu! {get set}
    
    func basicSwitchToViewController(index : Int)
    func cycleFromViewController(_ oldViewController: UIViewController, toViewController newViewController: UIViewController)
}

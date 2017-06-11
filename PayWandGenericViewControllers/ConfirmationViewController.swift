//
//  ConfirmationViewController.swift
//  PayWand
//
//  Created by Farid on 10/20/16.
//  Copyright © 2016 Farid. All rights reserved.
//

import UIKit
import EasyPeasy
import PayWandBasicElements

protocol ConfirmationViewControllerDelegate {
    func confirmationVC(infos confimationVC : ConfirmationViewController) -> [String : String?]
    
    func confirmationVC(keys confimationVC : ConfirmationViewController) -> [String]
    
    func confirmationVC(onConfirm confimationVC : ConfirmationViewController)
    
    func confirmationVC(onBack confimationVC : ConfirmationViewController)
    
    func confirmationVC(actionType confimationVC : ConfirmationViewController) -> SlidingActionViewController.ActionType
}

class ConfirmationViewController: ScrollSlidingActionViewController {
    
    var confirmDelegate : ConfirmationViewControllerDelegate!

    override func viewDidLoad() {
        typeDelegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func initElements() {
        super.initElements()
        
        let headerLabel = TtroLabel(font: UIFont.TtroPayWandFonts.regular2.font, color: UIColor.TtroColors.white.color)
        headerLabel.text = "Check requested transaction details below.\n\nConfirm to proceed."
        stackView.addArrangedSubview(headerLabel)
        headerLabel <- [
            CenterX(),
            Width().like(slidingView),
        ]
        headerLabel.textAlignment = .center
        headerLabel.numberOfLines = 4
        headerLabel.lineBreakMode = .byWordWrapping
        
        let keys = confirmDelegate.confirmationVC(keys: self)
        let infos = confirmDelegate.confirmationVC(infos: self)
        
        for key in keys {
            addInfoView(key: key, value: infos[key]!)
        }
    }
    
    func addInfoView(key : String, value : String?) {
        let infoView = UIView()
        stackView.addArrangedSubview(infoView)
        infoView <- [
            CenterX(),
            Width().like(slidingView)
        ]
        
        let keyLabel = TtroLabel(font: UIFont.TtroPayWandFonts.light3.font, color: UIColor.TtroColors.white.color)
        infoView.addSubview(keyLabel)
        keyLabel.text = key
        keyLabel.adjustsFontSizeToFitWidth = true
        
        let valueLabel = TtroLabel(font: UIFont.TtroPayWandFonts.regular3.font, color: UIColor.TtroColors.white.color)
        infoView.addSubview(valueLabel)
        valueLabel.text = value
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.textAlignment = .right
        
        if (value!.characters.count + key.characters.count < 20) {
            keyLabel <- [
                //Top(),
                Left().to(infoView, .left),
                Width(*0.4).like(slidingView),
            ]
            valueLabel <- [
                Top(20),
                Right(),
                Width(*0.6).like(slidingView),
                Bottom(),
                CenterY().to(keyLabel)
            ]
        } else {
            keyLabel <- [
                //Top(),
                Top(20),
                Left().to(infoView, .left),
                Width(*0.6).like(slidingView),
            ]
            valueLabel <- [
                Top(10).to(keyLabel),
                Right(),
                Width(*0.8).like(slidingView),
                Bottom(),
            ]
        }
    }
    
    override func initBottomView() {
        bottomView = TwoButtonBotttomView(frame : CGRect.zero)
        let twoButtonBotttomView = bottomView as! TwoButtonBotttomView
        twoButtonBotttomView.confirmButton.addTarget(self, action: #selector(self.onConfirm), for: .touchUpInside)
        twoButtonBotttomView.cancelButton.addTarget(self, action: #selector(self.onBack), for: .touchUpInside)
        twoButtonBotttomView.confirmButton.setTitle("Confirm", for: UIControlState())
        twoButtonBotttomView.cancelButton.setTitle("Back", for: UIControlState())
    }
    
    func onConfirm() {
        confirmDelegate.confirmationVC(onConfirm: self)
    }
    
    func onBack(){
        confirmDelegate.confirmationVC(onBack: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConfirmationViewController : SlidingActionViewControllerDelegate {
    func actionType() -> SlidingActionViewController.ActionType {
        return confirmDelegate.confirmationVC(actionType: self)
    }
}

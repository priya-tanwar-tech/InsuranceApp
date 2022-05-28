//
//  WebViewController.swift
//  Probus_Insurance
//
//  Created by Sankalp on 25/01/22.
//

import Foundation
import UIKit
import WebKit

class WebViewController : UIViewController, WKUIDelegate
{
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var webVu : WKWebView!
    var urlString : String!
    
    override func viewDidLoad() {
        webVu.uiDelegate = self
        let myURL = URL(string:urlString)
        let myRequest = URLRequest(url: myURL!)
        webVu.load(myRequest)
    }
    
    @IBAction func backBtnTapped()
    {
        let alertVu = SCLAlertView.init(appearance: Common.sharedCommon.alertwithCancel)
        alertVu.addButton("Okay", backgroundColor: .systemTeal, textColor: .white, showTimeout: .none) {
            alertVu.hideView()
            self.navigationController?.popViewController(animated: true)
        }
        alertVu.showInfo("Go Back", subTitle: "Do you still want to go on previous screen?", closeButtonTitle: "Cancel", timeout: .none, colorStyle: UInt(Common.sharedCommon.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
    }
}

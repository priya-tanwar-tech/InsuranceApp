//
//  WebViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 09/06/22.
//

import Foundation
import UIKit
import WebKit

class WebViewController : UIViewController, WKUIDelegate
{
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var webVu : WKWebView!
    
    var urlString : String!
    var titleString : String!

    override func viewDidLoad() {
        webVu.uiDelegate = self
        titleLbl.text = titleString
        let myURL = URL(string:urlString)
        let myRequest = URLRequest(url: myURL!)
        webVu.load(myRequest)
    }
    
    @IBAction func backBtnTapped()
    {
        self.navigationController?.popViewController(animated: true)
    }
}

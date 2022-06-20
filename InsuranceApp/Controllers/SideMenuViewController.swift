//
//  SideMenuViewController.swift
//  InsuranceApp
//
//  Created by Sankalp on 17/11/21.
//

import Foundation
import UIKit
import MBProgressHUD

protocol SideMenuViewControllerDelegate {
    func selectedCell()
}

class SideMenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var closeBtn: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    private var arrayList : [String]!
    private var imageList : [String]!
    var defaultHighlightedCell: Int = 0
    var delegate: SideMenuViewControllerDelegate?

    override func viewDidLoad()
    {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(SideMenuViewController.closeBtnAction))
        closeBtn.addGestureRecognizer(tapGesture)
        tableView.register(UINib.init(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userID = (Common.sharedCommon.sharedUserDefaults().object(forKey: "UserId") as? String)
        if (userID != nil && !userID!.elementsEqual("0"))
        {
            arrayList = Common.sharedCommon.getSideMenuStringListWithLogin()
           imageList = Common.sharedCommon.getSideMenuImageListWithLogin()
        }
        else
        {
            arrayList = Common.sharedCommon.getSideMenuStringListWithoutLogin()
           imageList = Common.sharedCommon.getSideMenuImageListWithoutLogin()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.displayCell(arrayList[indexPath.row], withImageName:imageList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closeBtnAction()
        let indexxxx = arrayList[indexPath.row]
        if (indexxxx.elementsEqual("Log Out"))
        {
            Common.sharedCommon.sharedUserDefaults().removeObject(forKey: "UserId")
            Common.sharedCommon.sharedUserDefaults().synchronize()
            Common.sharedCommon.goToNextScreenWith("LoginScreenController", self)
        }
        else if (indexxxx.elementsEqual("Privacy Policy"))
        {
            openUrlInNextScreen(urlString: "https://www.probusinsurance.com/privacy-and-terms/", title: arrayList[indexPath.row])
        }
        else if (indexxxx.elementsEqual("Greivance Redressal"))
        {
            openUrlInNextScreen(urlString: "https://www.probusinsurance.com/gr/", title: arrayList[indexPath.row])
        }
        else if (indexxxx.elementsEqual("Share App"))
        {
            if let name = URL(string: "https://itunes.apple.com/us/app/probusinsuranceapp/id1629007980"), !name.absoluteString.isEmpty
            {
              let objectsToShare = [name]
              let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
              self.present(activityVC, animated: true, completion: nil)
            } else {
                let alert = SCLAlertView.init(appearance: Common.sharedCommon.alertwithCancel)
                alert.showInfo("Not Available", subTitle: nil, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(Common.sharedCommon.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
            }

        }
        else if (indexxxx.elementsEqual("Rate Us / Feedback"))
        {
            let url = URL(string: "itms-apps://itunes.apple.com/app/1629007980")
            UIApplication.shared.open(url!)
        }
        else
        {
            let alert = SCLAlertView.init(appearance: Common.sharedCommon.alertwithCancel)
            alert.showInfo("Coming Soon", subTitle: nil, closeButtonTitle: "Okay", timeout: .none, colorStyle: UInt(Common.sharedCommon.colorValue), colorTextButton: .max, circleIconImage: nil, animationStyle: .noAnimation)
        }
    }
    
    func openUrlInNextScreen(urlString url: String, title lbl : String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webView = storyboard.instantiateViewController(withIdentifier:"WebViewController") as! WebViewController
        webView.urlString = url
        webView.titleString = lbl
        self.navigationController?.pushViewController(webView, animated: true)
    }


    @objc func closeBtnAction()
    {
        self.delegate?.selectedCell()
    }
}

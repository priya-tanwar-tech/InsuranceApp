//
//  SideMenuViewController.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 17/11/21.
//

import Foundation
import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell()
}

class SideMenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var closeBtn: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    private let arrayList = Common.sharedCommon.getSideMenuStringList()
    private let imageList = Common.sharedCommon.getSideMenuImageList()
    
    var defaultHighlightedCell: Int = 0
    var delegate: SideMenuViewControllerDelegate?

    override func viewDidLoad()
    {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(SideMenuViewController.closeBtnAction))
        closeBtn.addGestureRecognizer(tapGesture)
        tableView.register(UINib.init(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.view.frame.size.height*0.08;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.displayCell(arrayList[indexPath.row], withImageName:imageList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    @objc func closeBtnAction()
    {
        self.delegate?.selectedCell()
    }
}

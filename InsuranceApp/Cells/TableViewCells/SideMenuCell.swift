//
//  SideMenuCell.swift
//  InsuranceApp
//
//  Created by Sankalp on 17/11/21.
//

import Foundation
import UIKit

class SideMenuCell : UITableViewCell
{
    var SideMenuCell:UITableViewCell!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var labelVu: UILabel!
    @IBOutlet weak var imageVu: UIImageView!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    
    func displayCell(_ string: String, withImageName imageName: String)
    {
        self.selectionStyle = .none
        labelVu.text = string
        imageVu.image = UIImage.init(named: imageName)
        imageViewSize(0.16)
    }
    
    private func imageViewSize(_ wide : CGFloat)
    {
        let change_width = NSLayoutConstraint.init(item: imgWidth.firstItem as Any, attribute: imgWidth.firstAttribute, relatedBy: imgWidth.relation, toItem: imgWidth.secondItem, attribute: imgWidth.secondAttribute, multiplier: wide, constant: imgWidth.constant)
        imgWidth.isActive = false
        imgWidth = change_width
        NSLayoutConstraint.activate([imgWidth])
        imageVu.layoutIfNeeded()
    }
    
    func displayCellWithImage(_ string: String,_image img: UIImage)
    {
        self.selectionStyle = .none
        labelVu.text = string
        imageVu.image = img
        imageViewSize(0.3)
    }
}

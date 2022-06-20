//
//  RegisterCell.swift
//  InsuranceApp
//
//  Created by Sankalp on 22/11/21.
//

import Foundation
import UIKit

class RegisterCell:UITableViewCell
{
    var RegisterCell:UITableViewCell!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    private let common = Common.sharedCommon

    func display(_ lblname: String, andImage img: String)
    {
        common.applyRoundedShapeToView(backView, withRadius: 10)
        self.selectionStyle = .none
        common.applyShadowToView(self, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)
        self.backgroundColor = UIColor.clear
        lbl.text = lblname
        imgView.image = UIImage.init(named: img)
    }
}

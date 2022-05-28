//
//  IncomeTableViewCell.swift
//  PETTest
//
//  Created by Sankalp on 30/11/21.
//

import Foundation
import UIKit

class IncomeTableViewCell : UITableViewCell
{
    var IncomeTableViewCell: UITableViewCell!
    @IBOutlet weak var backVu: UIView!
    @IBOutlet weak var lbl: UILabel!

    func setDispaly(_ string: String)
    {
        self.selectionStyle = .none
        lbl.text = string
        Common.sharedCommon.applyShadowToView(backVu, withColor: Colors.shadowColor, opacityValue: 0.5, radiusValue: 5)

    }
}

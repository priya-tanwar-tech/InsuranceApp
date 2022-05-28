//
//  CustomizeCell.swift
//  ProbusInsuranceApp
//
//  Created by Sankalp on 16/11/21.
//

import Foundation
import UIKit

class CustomizeCell : UITableViewCell
{
    var CustomizeCell: UITableViewCell!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageVu: UIImageView!
    @IBOutlet weak var labelVu: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    func displayData(_ string: String, withSwitchValue switchValue: Bool)
    {
        self.selectionStyle = .none
        switchBtn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let textValue = string.replacingOccurrences(of: ":", with: " ")
        imageVu.image = UIImage.init(named: textValue)
        labelVu.text = textValue
        switchBtn.isOn = switchValue
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch)
    {
            let stringValue = sender.restorationIdentifier
            CustomizeController().updateMyArray(stringValue!)
    }
}

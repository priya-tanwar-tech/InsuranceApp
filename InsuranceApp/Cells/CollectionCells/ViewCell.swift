//
//  ViewCell.swift
//  InsuranceApp
//
//  Created by Sankalp on 10/11/21.
//

import Foundation
import UIKit

class ViewCell: UICollectionViewCell {
    var viewcell: UICollectionViewCell!
    @IBOutlet weak var secondName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    func displayData(_ string : NSString)
    {
        let str:String = string.replacingOccurrences(of: ":", with: " ")
        secondName.isHidden = true;
        if (string.contains(":"))
        {
            let stringName:[String] = string.components(separatedBy: ":")
            firstName.text = stringName.first
            secondName.text = stringName.last
            secondName.isHidden = false;
        }
        else
        {
            firstName.text = str
        }
        imageView.image = UIImage.init(named: str)
    }
}


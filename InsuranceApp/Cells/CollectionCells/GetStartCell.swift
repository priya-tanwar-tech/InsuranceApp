//
//  GetStartCell.swift
//  InsuranceApp
//
//  Created by Sankalp on 16/11/21.
//

import Foundation
import UIKit


class GetStartCell: UICollectionViewCell {
    var GetStartCell: UICollectionViewCell!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    func displayData(_ titleTxt: String, description desc: String, withImageName imageName: String)
    {
        imageView.image = UIImage.init(named: imageName)
        titleLbl.text = titleTxt
        descLbl.text = desc
    }
}

//
//  categoryCell.swift
//  AppCakeDemo
//
//  Created by Admin on 10/10/22.
//

import UIKit

class categoryCell: UICollectionViewCell {

    @IBOutlet weak var backView: RoundedView!
    @IBOutlet weak var topView: RoundedView!
    @IBOutlet weak var lbl_title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupView(isSelect: Bool){
        if isSelect {
            
            backView.backgroundColor =  UIColor(hexString: "#44B964")
            topView.backgroundColor = UIColor(hexString: "#2DC792")
        } else {
            backView.backgroundColor = UIColor(hexString: "#D2D6E9")
            topView.backgroundColor = UIColor(hexString: "#FFFFFF")
        }
    }
}

//
//  ProductTVC.swift
//  Komal_Badhe_TEST_DEMO
//
//  Created by Komal Badhe on 11/01/23.
//

import UIKit

class ProductTVC: UITableViewCell {
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var productIconImgView: UIImageView!
    
    @IBOutlet weak var productNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

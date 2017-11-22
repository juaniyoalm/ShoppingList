//
//  ShopsTableViewCell.swift
//  ShoppingList
//
//  Created by Juan Antonio Perez Clemente on 21/11/17.
//  Copyright © 2017 Juan Pérez. All rights reserved.
//

import UIKit

class ShopsTableViewCell: UITableViewCell {

   
    @IBOutlet weak var imageShops: UIImageView!
    @IBOutlet weak var labelShops: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

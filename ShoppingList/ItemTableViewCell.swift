//
//  ItemTableViewCell.swift
//  ShoppingList
//
//  Created by Juan Antonio Perez Clemente on 27/11/17.
//  Copyright © 2017 Juan Pérez. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {


    @IBOutlet weak var labelItemCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

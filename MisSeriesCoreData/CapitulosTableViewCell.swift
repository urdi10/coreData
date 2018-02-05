//
//  CapitulosTableViewCell.swift
//  MisSeriesCoreData
//
//  Created by Alejandro on 5/2/18.
//  Copyright © 2018 Alejandro. All rights reserved.
//

import UIKit

class CapitulosTableViewCell: UITableViewCell {

    @IBOutlet weak var nombreCapitulo: UILabel!    
    @IBOutlet weak var valoracion: UILabel!
    @IBOutlet weak var valorarBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func valorar(sender: UIButton) {
    }
}

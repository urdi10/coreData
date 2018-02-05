//
//  SeriesTableViewCell.swift
//  MisSeriesCoreData
//
//  Created by Alejandro on 5/2/18.
//  Copyright © 2018 Alejandro. All rights reserved.
//

import UIKit

class SeriesTableViewCell: UITableViewCell {

    @IBOutlet weak var nombreSerie: UILabel!
    
    @IBOutlet weak var numeroCapitulos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

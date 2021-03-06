//
//  ButtonCell.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 04.03.2021.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var authButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

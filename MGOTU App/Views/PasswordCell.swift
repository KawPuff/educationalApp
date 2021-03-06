//
//  PasswordCell.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 28.02.2021.
//

import UIKit

class PasswordCell: UITableViewCell {
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var passwodDeatailsBotton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

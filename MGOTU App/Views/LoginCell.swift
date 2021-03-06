//
//  LoginCell.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 28.02.2021.
//

import UIKit

class LoginCell: UITableViewCell {

    @IBOutlet weak var loginTF: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  SubjectCell.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 10.03.2021.
//

import UIKit

class SubjectCell: UICollectionViewCell {

    @IBOutlet weak var subjectMarkView: UIView!{
        didSet{
            subjectMarkView.layer.cornerRadius = 2
            subjectMarkView.layer.masksToBounds = true
            subjectMarkView.backgroundColor = UIColor.blue
        }
    }
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

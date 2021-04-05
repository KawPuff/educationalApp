//
//  WeekDayHeaderView.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 21.03.2021.
//

import UIKit

class WeekDayHeaderView: UICollectionReusableView {
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var line: UIView!{
        didSet{
            line.layer.cornerRadius = 2
            line.layer.masksToBounds = line.layer.cornerRadius>0
        }
    }
    
    
}

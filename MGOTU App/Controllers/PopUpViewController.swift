//
//  PopUpViewController.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 04.04.2021.
//

import UIKit

class PopUpViewController: UIViewController {
    
    var SubjectInfo: Subject?
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var PopUpView: UIView!{
        didSet{
            PopUpView.layer.cornerRadius = 15
            PopUpView.layer.masksToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        HandleLabels()
    }
    
    private func HandleLabels(){
        guard let subjectInfo = SubjectInfo else{
            return
        }
        var splettedLparam = subjectInfo.lparam.components(separatedBy: "(")
        var temp = splettedLparam[0]
        placeLabel.text = temp
        temp = splettedLparam[1]
        splettedLparam = splettedLparam[1].components(separatedBy: "-")
        temp = splettedLparam[0]
        teacherLabel.text = temp
        temp = splettedLparam[1]
        temp.removeFirst()
        subjectNameLabel.text = temp
        splettedLparam = splettedLparam[2].components(separatedBy: ")")
        temp = splettedLparam[0]
        subjectNameLabel.text! += " - \(temp)"
        timeLabel.text = subjectInfo.time
    }
    
}

//
//  HomeViewController.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 08.12.2020.
//

import UIKit
import JTAppleCalendar
import NVActivityIndicatorView
class HomeViewController: UIViewController {
    
    
    var networking = NetworkingManager🌐()
    
    var sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    var subjects = [[Subject]]()
    var selectedSubject: Subject?
    var firstDayOfSelectedWeek = Date()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segue" else{
            return
        }
        
        let dvc = segue.destination as! PopUpViewController
        dvc.SubjectInfo = selectedSubject
        
    }


    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var subjectActivityIndiactor: NVActivityIndicatorView!
    @IBOutlet weak var monthLabel: UILabel!{
        didSet{
            monthLabel.text = Date().toStringWithFormat(format: "LLLL yyyy").firstCharUppercased()
            
        }
    }
    
    @IBOutlet var weekdayLabels: [UILabel]!{
        didSet{
            let weekdays = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
            for i in 0..<weekdayLabels.count {
                weekdayLabels[i].text = weekdays[i]
            }
        }
    }
    @IBOutlet var subjectsCollectionView: UICollectionView!{
        didSet{
            subjectsCollectionView.layer.cornerRadius = 20
            subjectsCollectionView.layer.masksToBounds = subjectsCollectionView.layer.cornerRadius>0
            subjectsCollectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
        }
    }
    @IBOutlet weak var noSubjectsLabel: UILabel!
    @IBOutlet var calendarView: JTAppleCalendarView!{
        didSet{
            calendarView.scrollingMode = .stopAtEachCalendarFrame
            calendarView.isRangeSelectionUsed = false
            calendarView.allowsMultipleSelection = false
            calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: true, preferredScrollPosition: nil, extraAddedOffset: 0, completionHandler: nil)
            calendarView.selectDates([Date()])
          
            
        }
    }
    
    func checkForAuthentification(){
        let login = UserDefaults.standard.string(forKey: "login")!
        let password = UserDefaults.standard.string(forKey: "password")!
        
        networking.auth(login: login, password: password)
        networking.requestGroup.notify(queue: .main){ [self] in
            guard let authStatus = networking.authStatus else {
                let alert = UIAlertController(title: "Отсутсвтует подключение к серверу", message: "Проблемы с подключением к серверу.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
            
            if authStatus.authStatus {
                return
            } else {
                let alert = UIAlertController(title: "Необходимо авторизоваться заново!", message: "Данные для входа были изменены. Пожалуйста, авторизуйтесь заново.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Войти заново", style: .default) {_ in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.sceneDelegate?.changeViewController(vc: loginVC, animated: true)
                }
                
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Убрать границу Navigation Bar(если PrefersLargeSize == true)
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        subjectsCollectionView.delegate = self
        subjectsCollectionView.dataSource = self
        
        subjectsCollectionView.register(UINib(nibName: "SubjectCell", bundle: nil), forCellWithReuseIdentifier: "subjectCell")
        checkForAuthentification()
        
        
    }
    
}

//MARK: - Calendar DataSource/Delegate
extension HomeViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate{
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        cell.dateLabel.textColor = UIColor.white
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
 
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  13
            cell.selectedView.isHidden = false
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        configureCell(view: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let dateCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell",
                                                           for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: dateCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        calendar.allowsSelection = false
        return dateCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        subjectActivityIndiactor.startAnimating()
        noSubjectsLabel.isHidden = true
        subjects.removeAll()
        subjectsCollectionView.reloadData()
        let calendar = Calendar(identifier: .gregorian)
        
        let firstDate = calendar.date(byAdding: .day, value: 1, to: visibleDates.monthDates.first!.date)
        let lastDate = calendar.date(byAdding: .day, value: 1, to: visibleDates.monthDates.last!.date)
        
        firstDayOfSelectedWeek = firstDate!
        
        let visibleDateLabel = firstDayOfSelectedWeek.toStringWithFormat(format: "LLLL yyyy").firstCharUppercased()
        if visibleDateLabel != monthLabel.text{
            monthLabel.text = visibleDateLabel
        }
        
        networking.getSubjectsInfo(firstDate: firstDate!, secondDate: lastDate!)
        networking.requestGroup.notify(queue: .main){ [self] in
            subjectActivityIndiactor.stopAnimating()
            
            guard let subjects = networking.scheduleDataCallBack?.scheduleData?.data else{
                return
            }
            let dict = Dictionary(grouping: subjects) { (subj) in
                return subj.daynum
            }
            let sortedKeys = Array(dict.keys).sorted { (key, key1) -> Bool in
                key<key1
            }
            
            for key in sortedKeys{
                self.subjects.append(dict[key]!)
            }
            
            noSubjectsLabel.isHidden = !subjects.isEmpty
            
            subjectsCollectionView.reloadData()
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? DateCell else {return}
        configureCell(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? DateCell else {return}
        configureCell(view: cell, cellState: cellState)
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let calendar = Calendar(identifier: .iso8601)
        
        let startDate = dateFormatter.date(from: "02/02/2021")!
        let endDate = calendar.date(byAdding: .year, value: 1, to: startDate)!
        
        return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1, calendar: Calendar(identifier: .iso8601), generateInDates: .forFirstMonthOnly, generateOutDates: .off, firstDayOfWeek: .monday, hasStrictBoundaries: false)
        
    }
    
    
}
//MARK: - Subjects CollectionView Datasource/Delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard !subjects.isEmpty else{
            return 0
        }
        return subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionView == subjectsCollectionView else{
            return 0
        }
        let numOfItems = subjects[section].count
        return numOfItems
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSubject = subjects[indexPath.section][indexPath.row]
        self.selectedSubject = selectedSubject
        performSegue(withIdentifier: "segue", sender: nil)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! WeekDayHeaderView
            let subjectsDaynum = subjects[indexPath.section][0].daynum
            
            let stringDate = firstDayOfSelectedWeek.toStringWithFormatAndOffset(format: "E, dd MMMM", offsetComponent: .day, offset: subjectsDaynum - 2)
            switch  subjectsDaynum{
            case 1:
                header.weekDayLabel.text = stringDate
            case 2:
                header.weekDayLabel.text =  stringDate
            case 3:
                header.weekDayLabel.text =  stringDate
            case 4:
                header.weekDayLabel.text =  stringDate
            case 5:
                header.weekDayLabel.text = stringDate
            case 6:
                header.weekDayLabel.text =  stringDate
            case 7:
                header.weekDayLabel.text =  stringDate
            default:
                header.weekDayLabel.text = "-"
            }
            return header
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard collectionView == subjectsCollectionView else{
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCell", for: indexPath) as! SubjectCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
//        cell.layer.borderWidth = 0.5
//        cell.layer.borderColor = UIColor.gray.cgColor
        //Получение названия предмета
        var splettedLparam = subjects[indexPath.section][indexPath.row].lparam.components(separatedBy: "(")
        var temp = splettedLparam[1]
        splettedLparam = splettedLparam[1].components(separatedBy: "-")
        temp = splettedLparam[1]
        temp.removeFirst()
        cell.subjectLabel.text = temp
        splettedLparam = splettedLparam[2].components(separatedBy: ")")
        temp = splettedLparam[0]
        cell.subjectLabel.text! += " - \(temp)"
        let time = subjects[indexPath.section][indexPath.row].time.components(separatedBy: "-")[0]
        cell.timeLabel.text = "Начало: \(time)"
        
        
        return cell
        
        
    }
    
}

//MARK: - CollectionView Layout

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let avalibleWidth = collectionView.frame.width - 10
        return CGSize(width: avalibleWidth, height: 70)
    }
}

//
//  NewsViewController.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 12.02.2021.
//

import UIKit
class NewsViewController: UIViewController {
    
 
    let networking = NetworkingManager🌐()

    @IBOutlet weak var newsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        newsCollectionView.register(UINib(nibName: "FeedItemCell", bundle: nil), forCellWithReuseIdentifier: "feedItemCell")
        
        //Указываем в качестве источника данных для collectionview данный класс
        self.newsCollectionView.dataSource = self
        
        self.newsCollectionView.delegate = self
    }
    

}

extension NewsViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newsCollectionView.dequeueReusableCell(withReuseIdentifier: "feedItemCell", for: indexPath) as! FeedItemCell
        cell.headerLabel.text = "ЗАКРЫТОЕ ТЕСТИРОВАНИЕ ANDROID ПРИЛОЖЕНИЯ «ОБРАЗОВАТЕЛЬНОГО ПОРТАЛА МГОТУ»"
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = CGColor(gray: 1, alpha: 1)
        return cell
        
    }
}
extension NewsViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingWidth = 20 * 2
        let avilableWidth = collectionView.frame.width - CGFloat(paddingWidth)
        let itemWidth = avilableWidth
        return CGSize(width: itemWidth, height: itemWidth)
    }


    //Задает отступы для всех границ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    //Задает отступ между линиями объектов
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    //Задает отступ между объектами
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


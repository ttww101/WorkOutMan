//
//  DailyViewVC.swift
//  iHealthS
//
//  Created by Apple on 2019/4/5.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class DailyViewVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    @IBOutlet weak var dailyCollectionViewLayout: UICollectionViewFlowLayout!
    
    var superNavigationController: UINavigationController?
    
    var cellSize: CGFloat = 0
    var dailyData = [DailyCellMode]()
    var type = WorkOutManType.Elementary
    
    var mode = "Elementary"
    init(_ mode: String) {
        super.init(nibName: "DailyViewVC", bundle: nil)
        self.mode = mode
        setDefaultData()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(_ mode: String) {
        self.mode = mode
        setDefaultData()
        dailyCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        dailyCollectionView.backgroundColor = UIColor.clear
        cellSize = self.view.frame.width / 3 - 30
        
        dailyCollectionViewLayout.itemSize = CGSize(width: cellSize, height: cellSize)
        dailyCollectionView.register(UINib(nibName: "DailyViewCollectionCell", bundle: nil), forCellWithReuseIdentifier: "dailyCell")
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Data
    func setDefaultData() {
        dailyData = [DailyCellMode]()
        switch self.mode {
        case "Elementary":
            type = WorkOutManType.Elementary
        case "Intermediate":
            type = WorkOutManType.Intermediate
        case "Advanced":
            type = WorkOutManType.Advanced
        default:
            type = WorkOutManType.Elementary
        }
        for i in 0...WorkOutManAction.progress[self.mode]!.count - 1 {
            let title = "第\(i + 1)天"
            let value = WorkOutManAction.progress[self.mode]![i]
            self.dailyData.append(DailyCellMode.init(title: title, progress: value.toPercentage(type.totle), finishCount: Int(value)))
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyCell", for: indexPath) as! DailyViewCollectionCell
        cell.radius = self.cellSize / 2
        cell.setUp(cellMode: dailyData[indexPath.row])
//        cell.label.text = DailyViewMode!.data[indexPath.row].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = dailyData[indexPath.row]
        
        guard let delegate = UIApplication.shared.delegate, let window = delegate.window, let resideVC = window?.rootViewController as? RESideMenu else { return }
       
        guard let nav = resideVC.contentViewController as? UINavigationController else { return }
        
        let ActionListView = ActionListVC(self.mode, data.title, indexPath.row)
        ActionListView.progressChange = { [weak self] (progress) in
            guard let self = self else { return }
            self.dailyData[indexPath.row].progress = progress.toPercentage(self.type.totle)
            self.dailyCollectionView.reloadItems(at: [indexPath])
        }
        nav.pushViewController(ActionListView, animated: true)
        
    }
    
}

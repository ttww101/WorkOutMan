//
//  WorkOutManVC.swift
//  iHealthS
//
//  Created by Apple on 2019/4/3.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

@objc class WorkOutManVC: UIViewController {
    
    let userDefault = UserDefaults.standard
    var dailyView: DailyViewVC!
//    var transactionInProgress = false // 是否交易中
    var isBuy = false
    
    let mode = WorkOutManVCMode()
    var menuView = [WorkOutManMenuView]()
    var menuViews: UIStackView!
    var first = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - load Data
    func getData() {
        if let elementary = self.userDefault.array(forKey: "Elementary") {
            WorkOutManAction.progress["Elementary"] = elementary as? [CGFloat]
        }
        if let intermediate = self.userDefault.array(forKey: "Intermediate") {
            WorkOutManAction.progress["Intermediate"] = intermediate as? [CGFloat]
        }
        if let advanced = self.userDefault.array(forKey: "Advanced") {
            WorkOutManAction.progress["Advanced"] = advanced as? [CGFloat]
        }
    }
    
    // MARK: - UI
    // call UI func
    func setUI() {
        let imageView = UIImageView(image: UIImage(named: mode.bgImage))
        self.view.addBackground(imageView, .scaleAspectFill)
        self.addWorkOutManTitle()
    }
    // set menu title UI
    func addWorkOutManTitle() {
        menuViews = UIStackView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        menuViews.distribution = .fillEqually
        menuViews.axis = .vertical
        menuViews.spacing = 20
        menuViews.backgroundColor = UIColor.red
        self.view.addSubview(menuViews)
        self.view.addViewLayout(menuViews, 10, 10, 10, 10)
        
        for i in 0...mode.menu.count - 1 {
            let view = WorkOutManMenuView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), type: mode.menu[i])
            view.onTapView = { [weak self] (view) in
                guard let self = self else { return }
                self.menuTap(view)
            }
            menuViews.addArrangedSubview(view)
            self.menuView.append(view)
        }
    }
    // set daily UI
    func addWorkOutManDaily(_ mode: String) {
        let dailyView = DailyViewVC(mode)
        dailyView.superNavigationController = self.navigationController
        let menuHeight = self.view.frame.height - 130
        let dailyTop = (menuHeight / 3) + 50
        self.view.addSubview(dailyView.view)
        self.view.addViewLayout(dailyView.view, dailyTop, 10, 30, 30)
        self.addChild(dailyView)
        self.dailyView = dailyView
        dailyView.view.isHidden = true
    }
    // MARK: - UI Action
    // menu tap action
    func menuTap(_ view: WorkOutManMenuView) {
        let viewY = view.frame.minY
        let view = WorkOutManMenuView(frame: CGRect(x: 15, y: viewY + 10, width: view.frame.width, height: view.frame.height), type: view.type)
        print(view.frame.width)
        view.onTapView = { [weak self] (view) in
            guard let self = self else { return }
            view.removeFromSuperview()
            self.dailyView.view.isHidden = true
            self.menuViews.isHidden = false
        }
        self.view.addSubview(view)
        
        menuViews.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            view.frame.origin.y = view.frame.origin.y - viewY
        }) { (completion) in
            if self.first {
                self.addWorkOutManDaily(view.type.identifier)
                self.first = false
            }
            self.dailyView.setData(view.type!.identifier)
            self.dailyView.view.isHidden = false
        }
    }
}

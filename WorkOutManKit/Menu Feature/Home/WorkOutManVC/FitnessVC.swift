//
//  WorkOutManVC.swift
//  iHealthS
//
//  Created by Apple on 2019/4/3.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit
import StoreKit

@objc class WorkOutManVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let userDefault = UserDefaults.standard
    var dailyView: DailyViewVC!
    var transactionInProgress = false // 是否交易中
    var isBuy = false
    
    let mode = WorkOutManVCMode()
    var menuView = [FitnessMenuView]()
    var menuViews: UIStackView!
    var first = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        self.setUI()
        SKPaymentQueue.default().add(self)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - load Data
    func getData() {
        if let elementary = self.userDefault.array(forKey: "Elementary") {
            FitnessAction.progress["Elementary"] = elementary as? [CGFloat]
        }
        if let intermediate = self.userDefault.array(forKey: "Intermediate") {
            FitnessAction.progress["Intermediate"] = intermediate as? [CGFloat]
        }
        if let advanced = self.userDefault.array(forKey: "Advanced") {
            FitnessAction.progress["Advanced"] = advanced as? [CGFloat]
        }
//        if let isPay = self.userDefault.bool(forKey: "isPay") {
        FitnessAction.isPay = self.userDefault.bool(forKey: "isPay")
//        }
    }
    
    // MARK: - UI
    // call UI func
    func setUI() {
        let imageView = UIImageView(image: UIImage(named: mode.bgImage))
        self.view.addBackground(imageView, .scaleAspectFill)
        self.addFitnessTitle()
    }
    // set menu title UI
    func addFitnessTitle() {
        menuViews = UIStackView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        menuViews.distribution = .fillEqually
        menuViews.axis = .vertical
        menuViews.spacing = 20
        menuViews.backgroundColor = UIColor.red
        self.view.addSubview(menuViews)
        self.view.addViewLayout(menuViews, 10, 10, 10, 10)
        
        for i in 0...mode.menu.count - 1 {
            let view = FitnessMenuView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), type: mode.menu[i])
            view.onTapView = { [weak self] (view) in
                guard let self = self else { return }
                if view.type == FitnessType.Advanced, !FitnessAction.isPay {
                    self.purchaseAlert()
                    return
                }
                self.menuTap(view)
            }
            menuViews.addArrangedSubview(view)
            self.menuView.append(view)
        }
    }
    // set daily UI
    func addFitnessDaily(_ mode: String) {
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
    func menuTap(_ view: FitnessMenuView) {
        let viewY = view.frame.minY
        let view = FitnessMenuView(frame: CGRect(x: 15, y: viewY + 10, width: view.frame.width, height: view.frame.height), type: view.type)
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
                self.addFitnessDaily(view.type.identifier)
                self.first = false
            }
            self.dailyView.setData(view.type!.identifier)
            self.dailyView.view.isHidden = false
        }
    }
    // purchase success
    func purchaseComplete() {
        if FitnessAction.isPay {
            self.menuView[2].resetBackground("fit_Advanced_1.png")
        }
    }
    
    // MARK: - purchase
    // purchase alert
    func purchaseAlert() {
        if transactionInProgress { return }
        let actionSheetController = UIAlertController(title: "购买", message: "¥6.00 享用高阶课程?", preferredStyle: .actionSheet)
        
        let buyAction = UIAlertAction(title: "购买", style: .default) { (action) in
            if self.transactionInProgress { return }
            self.requestProductInfo()
            self.isBuy = true
            self.transactionInProgress = true
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // get product
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: FitnessAction.productID)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
            self.transactionInProgress = false
        }
    }
    // SKProductsRequestDelegate - get products
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            let payment = SKPayment(product: response.products[0])
            SKPaymentQueue.default().add(payment)
        }
        else {
            print("There are no products.")
            self.transactionInProgress = false
        }
    }
    
    // SKPaymentTransactionObserver - get transaction state
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        if isBuy {
            for transaction in transactions {
                switch transaction.transactionState {
                    case .purchased:
                        print("Transaction completed successfully.")
                        alertMessage("购买成功")
                        FitnessAction.isPay = true
                        self.userDefault.set(true, forKey: "isPay")
                        self.purchaseComplete()
                        self.transactionInProgress = false
                    case .purchasing:
                        print("purchasing")
                    case .failed:
                        print("Transaction Failed")
                        alertMessage("购买失败")
                        self.transactionInProgress = false
                    default:
                        print(transaction.transactionState.rawValue)
                }
            }
        }
    }
    
    func alertMessage(_ content: String) {
        let alert = UIAlertController(title: nil, message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

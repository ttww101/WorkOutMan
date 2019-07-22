//
//  ActionListVC.swift
//  iHealthS
//
//  Created by Apple on 2019/4/7.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class ActionListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var actionListTable: UITableView!
    
    var mode = "Elementary"
    var viewTitle = ""
    var listData:[ActionListMode] = [ActionListMode]()
    var day = 0
    
    var progressChange: ((_ progress: CGFloat) -> Void)?
    
    init(_ mode: String, _ title: String, _ day: Int) {
        super.init(nibName: "ActionListVC", bundle: nil)
        self.mode = mode
        self.viewTitle = title
        self.day = day
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ActionListCell", bundle: nil)
        actionListTable.register(nib, forCellReuseIdentifier: "Cell")
        self.title = viewTitle
        // Do any additional setup after loading the view.
        getData()
        actionListTable.reloadData()
    }
    var needReload = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needReload {
            getData()
            actionListTable.reloadData()
            self.progressChange?(WorkOutManAction.progress[self.mode]![self.day])
        }
    }
    
    func getData() {
        listData = [ActionListMode]()
        let actions = WorkOutManAction.actions
        let actionName = WorkOutManAction.actionName
        let actionList: [String] = WorkOutManAction.actionList[self.mode]!
        let actionTime: [Int] = WorkOutManAction.actionTime[self.mode]!
        let actionProgress: CGFloat = WorkOutManAction.progress[self.mode]![self.day]
        for i in 0...actionList.count - 1 {
            let imgsCount = actions[actionList[i]]!
            let imgs = getImgsName(actionList[i], imgsCount)
            let isFinish = ((i + 1) > Int(actionProgress)) ? false:true
            listData.append(ActionListMode.init(title: actionName[actionList[i]]!, time: actionTime[i], imgs: imgs, isFinish: isFinish))
        }
    }
    func getImgsName(_ action: String, _ count: Int) -> [String] {
        var imgs = [String]()
        for i in 1...count {
            imgs.append("\(action)0\(i).png")
        }
        return imgs
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let actionCellData = listData[indexPath.row]
        let cell = actionListTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActionListCell
        cell.titleLabel.text = actionCellData.title
        cell.timeLabel.text = actionCellData.time.toTimeString()
        cell.imgArray = actionCellData.imgs
        if actionCellData.isFinish {
            cell.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 244/255, alpha: 1)
        }
        cell.setImg()
        
        return cell
    }
    
    // MARK: - Button Action
    @IBAction func tapButton(_ sender: Any) {
        guard let delegate = UIApplication.shared.delegate, let window = delegate.window, let resideVC = window?.rootViewController as? RESideMenu else { return }
        
        guard let nav = resideVC.contentViewController as? UINavigationController else { return }
        
        nav.pushViewController(ActionViewVC(self.listData, self.mode, self.day), animated: true)
        needReload = true
    }
    
}

//
//  ActionViewVC.swift
//  iHealthS
//
//  Created by Apple on 2019/4/8.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class ActionViewVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var actionImg: UIImageView!
    @IBOutlet weak var restView: UIView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var actionPlayView: UIView!
    
     let userDefault = UserDefaults.standard
    var mode = "Elementary"
    var actionData:[ActionListMode] = [ActionListMode]()
    var actionCount = 0
    var reciprocalCount = 20
    var actionTime = 0
    var day = 0
    var changeView = true // true: restView  false: actionView
    let shapeLayer = CAShapeLayer()
    let reciprocalLabel = UILabel()
    var timer: Timer?
    
    init(_ data: [ActionListMode], _ mode: String, _ day: Int) {
        super.init(nibName: "ActionViewVC", bundle: nil)
        self.actionData = data
        self.mode = mode
        self.day = day
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "預備開始"
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    var first = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if first {
            self.setRestView()
            self.setActionView()
            self.registerTimer()
            first = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearTimer()
    }
    
    func setUI() {
        self.setLabel()
        self.setImg()
        actionView.isHidden = true
    }
    func setLabel() {
        actionLabel.text = actionData[actionCount].title
    }
    func setImg() {
        var imgs = [UIImage]()
        let imgArray = actionData[actionCount].imgs
        for i in 0...imgArray.count - 1 {
            if UIImage(named: imgArray[i]) != nil {
                imgs.append(UIImage(named: imgArray[i])!)
            }
        }
        actionImg.animationImages = imgs
        actionImg.animationDuration = 2
        actionImg.image = imgs[0]
    }
    func setRestView() {
        let viewWidth = restView.frame.width
        let viewHeight = restView.frame.height
        let radius:CGFloat = viewHeight * 0.3
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: viewWidth / 2, y: viewHeight * 0.4), radius: radius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
        
        let trackShapeLayer = CAShapeLayer()
        trackShapeLayer.path = circularPath.cgPath
        trackShapeLayer.strokeColor = UIColor.red.cgColor
        trackShapeLayer.lineWidth = 3
        trackShapeLayer.fillColor = UIColor.clear.cgColor
        restView.layer.addSublayer(trackShapeLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        restView.layer.addSublayer(shapeLayer)
        
        restView.addSubview(reciprocalLabel)
        reciprocalLabel.frame = CGRect(x: 0, y: 0, width: viewHeight * 0.5, height: viewHeight * 0.5)
        reciprocalLabel.center = CGPoint(x: viewWidth / 2, y: viewHeight * 0.4)
        reciprocalLabel.textAlignment = .center
        reciprocalLabel.font = UIFont.boldSystemFont(ofSize: 40)
        reciprocalLabel.adjustsFontSizeToFitWidth = true
        reciprocalLabel.text = "\(reciprocalCount)"
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: viewHeight * 0.2, height: viewHeight * 0.2)
        button.center  = CGPoint(x: viewWidth / 2, y: viewHeight * 0.8)
        button.backgroundColor = UIColor.clear
        button.tintColor = UIColor.red
        button.setTitle("跳过", for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        restView.addSubview(button)
    }
    func setActionView() {
        playLabel.text = "\(actionTime.toTimeString())/\(actionData[actionCount].time.toTimeString())\""
    }
    
    // MARK: - reset & update
    func clearTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    func resetRestView() {
        clearTimer()
        shapeLayer.removeAllAnimations()
        reciprocalCount = 20
        reciprocalLabel.text = "\(reciprocalCount)"
        runTrack = true
        RestActionViewChange()
    }
    func resetActionView() {
        clearTimer()
        actionPlayView.layer.removeAllAnimations()
        actionData[actionCount].isFinish = true
        updateData()
        actionTime = 0
        runAction = true
        RestActionViewChange()
    }
    func updateData() {
        let finishCount = WorkOutManAction.progress[self.mode]![day]
        if (actionCount + 1) > Int(finishCount) {
            WorkOutManAction.progress[self.mode]![day] = (actionCount + 1).toCGFloat()
            self.userDefault.set(WorkOutManAction.progress[self.mode]!, forKey: self.mode)
            self.userDefault.synchronize()
        }
    }
    
    // MARK: - action
    // button action
    @objc func tapButton(sender: UIButton) {
        resetRestView()
    }
    var runTrack = true
    @objc func runReciprocal(_ timer: Timer) -> Void {
        if reciprocalCount == 0 {
            resetRestView()
            return
        }
        if runTrack {
            let trackAnimation = CABasicAnimation(keyPath: "strokeEnd")
            trackAnimation.toValue = 1
            trackAnimation.duration = 20
            trackAnimation.fillMode = .forwards
            trackAnimation.isRemovedOnCompletion = true
            shapeLayer.add(trackAnimation, forKey: "runReciprocal")
            runTrack = false
        }
        reciprocalLabel.text = "\(reciprocalCount)"
        reciprocalCount -= 1
    }
    
    var runAction = true
    @objc func runActions(_ timer: Timer) -> Void {
        if actionTime == actionData[actionCount].time {
            resetActionView()
            return
        }
        if runAction {
            actionImg.startAnimating()
            let playAnimation = CABasicAnimation(keyPath: "bounds.size.width")
            playAnimation.toValue = self.view.frame.width * 2
            playAnimation.duration = CFTimeInterval(actionData[actionCount].time)
            playAnimation.fillMode = .forwards
            playAnimation.isRemovedOnCompletion = true
            actionPlayView.layer.add(playAnimation, forKey: "runActionPlay")
            runAction = false
        }
        
        actionTime += 1
        print(actionTime)
        playLabel.text = "\(actionTime.toTimeString())/\(actionData[actionCount].time.toTimeString())\""
    }
    
    // MARK: - register timer
    func registerTimer() {
        if changeView {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runReciprocal(_:)), userInfo: nil, repeats: true)
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runActions(_:)), userInfo: nil, repeats: true)
        }
    }
    
    // MARK: - view change
    func RestActionViewChange() {
        if changeView { // to action view
            titleLabel.text = actionData[actionCount].title
            playLabel.text = "\(actionTime.toTimeString())/\(actionData[actionCount].time.toTimeString())\""
        } else { //to rest view
            actionCount += 1
            if actionCount == actionData.count {
                popView()
                return
            }
            titleLabel.text = "預備開始"
            self.setLabel()
            self.setImg()
        }
        restView.isHidden = changeView
        actionView.isHidden = !changeView
        actionLabel.isHidden = changeView

        changeView = !changeView
        self.registerTimer()
    }
    
    // MARK: - pop view
    func popView() {
        guard let delegate = UIApplication.shared.delegate, let window = delegate.window, let resideVC = window?.rootViewController as? RESideMenu else { return }
        guard let nav = resideVC.contentViewController as? UINavigationController else { return }
        nav.popViewController(animated: true)
    }

}

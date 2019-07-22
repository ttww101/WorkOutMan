//
//  DailyViewCollectionCell.swift
//  iHealthS
//
//  Created by Apple on 2019/4/6.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class DailyViewCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    let trackShapeLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    
    var radius:CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        // Initialization code
    }
    override func prepareForReuse() {
        self.shapeLayer.removeFromSuperlayer()
        self.trackShapeLayer.removeFromSuperlayer()
    }
    var cellMode: DailyCellMode?
    // MARK: - init
    func setUp(cellMode: DailyCellMode) {
        self.cellMode = cellMode
        self.setUI()
        self.shapeAnimation(cellMode.progress)
    }
    
    // MARK: - set UI
    private func setUI() {
        self.setCircleView()
    }
    private func setCircleView() {
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: self.radius, y: self.radius), radius: self.radius - 5, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
        trackShapeLayer.path = circularPath.cgPath
        
        trackShapeLayer.strokeColor = UIColor(red: 39/255, green: 175/255, blue: 190/255, alpha: 1).cgColor
        trackShapeLayer.lineWidth = 5
        if self.cellMode!.progress == 1 {
            trackShapeLayer.fillColor = UIColor(red: 0/255, green: 69/255, blue: 78/255, alpha: 1).cgColor
        } else {
            trackShapeLayer.fillColor = UIColor.clear.cgColor
        }
        
        self.contentView.layer.addSublayer(trackShapeLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 39/255, green: 190/255, blue: 132/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.contentView.layer.addSublayer(shapeLayer)
        
        self.contentView.layer.insertSublayer(trackShapeLayer, below: titleLabel.layer)
        
        titleLabel.text = cellMode!.title
        self.addViewLayout(titleLabel, 20, self.radius, 10, 10)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        progressLabel.text = "\(Int(cellMode!.progress * 100))%"
        self.addViewLayout(progressLabel, self.radius, 20, 10, 10)
        progressLabel.font = UIFont.boldSystemFont(ofSize: 20)
        progressLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    
    // MARK: - view load animation
    private func shapeAnimation(_ progress: CGFloat) {
        let trackAnimation = CABasicAnimation(keyPath: "strokeEnd")

        trackAnimation.toValue = progress
        trackAnimation.duration = 2
        trackAnimation.fillMode = .forwards
        trackAnimation.isRemovedOnCompletion = false

        shapeLayer.add(trackAnimation, forKey: "runProgress")
    }
}

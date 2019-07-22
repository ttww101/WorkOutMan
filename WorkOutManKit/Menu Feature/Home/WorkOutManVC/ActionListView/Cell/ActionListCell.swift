//
//  ActionListCell.swift
//  iHealthS
//
//  Created by Apple on 2019/4/7.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class ActionListCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var imgArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImg() {
        var imgs = [UIImage]()
        for i in 0...imgArray.count - 1 {
            if UIImage(named: imgArray[i]) != nil {
                imgs.append(UIImage(named: imgArray[i])!)
            }
        }
        imgView.animationImages = imgs
        imgView.animationDuration = 2
        imgView.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

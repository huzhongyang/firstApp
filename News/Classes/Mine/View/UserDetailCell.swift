//
//  UserDetailCell.swift
//  News
//
//  Created by huzhongyang on 2019/3/12.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class UserDetailCell: UITableViewCell, RegisterCellFromNib {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

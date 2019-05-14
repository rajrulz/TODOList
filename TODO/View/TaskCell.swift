//
//  TaskCell.swift
//  TODO
//
//  Created by rajneesh on 14/05/19.
//  Copyright © 2019 rajneesh. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var scheduledLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    
    @IBOutlet weak var expiredLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func customizeCell() {
        taskTitle.font = UIFont.appFont(ofSize: .large)
        scheduledLabel.font = UIFont.appFont(ofSize: .small)
        dateAndTimeLabel.font = UIFont.appFont(ofSize: .small)
        
        taskTitle.textColor = UIColor.dark()
        scheduledLabel.textColor = UIColor.light()
        dateAndTimeLabel.textColor = UIColor.light()
        
        scheduledLabel.text = "scheduled at"
        
        expiredLabel.text = "expired"
        expiredLabel.font = UIFont.appFont(ofSize: .normal)
        expiredLabel.textColor = UIColor.red
    }
}

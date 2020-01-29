//
//  PostsTableViewCell.swift
//  Pratice_4_Bandana
//
//  Created by Rakesh Nangunoori on 29/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var switchStatus: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getUpdatedCell(postModel:[PostModel],indexPath:IndexPath){
        self.label1.text = postModel[indexPath.row].title
        self.label2.text = ViewModel.shared.getDateFormatChanges(dateString: postModel[indexPath.row].createdDate)
        self.switchStatus.isOn = postModel[indexPath.row].switchStatus
        self.contentView.backgroundColor = postModel[indexPath.row].switchStatus ? UIColor.lightGray : UIColor.white
        
    }
}

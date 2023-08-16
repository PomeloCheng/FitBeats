//
//  historyTableViewCell.swift
//  textPHP
//
//  Created by YuCheng on 2023/8/14.
//

import UIKit

class historyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

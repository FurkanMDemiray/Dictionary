//
//  RecentCell.swift
//  Dictionary
//
//  Created by Melik Demiray on 6.06.2024.
//

import UIKit

class RecentCell: UITableViewCell {

    @IBOutlet weak var recentWordLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView?.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        selectedBackgroundView = nil
    }

    func configure(with word: String) {
        recentWordLabel.text = word
    }

}

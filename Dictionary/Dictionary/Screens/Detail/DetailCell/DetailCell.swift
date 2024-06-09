//
//  DetailCell.swift
//  Dictionary
//
//  Created by Melik Demiray on 8.06.2024.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var wordTypesLabel: UILabel!
    @IBOutlet weak var definitionsLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!

    private static var counter = 0
    private static var tmp = "Noun"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(partOfSpeech: String, definition: String) {
        if DetailCell.tmp == partOfSpeech {
            DetailCell.counter += 1
            wordTypesLabel.text = "\(DetailCell.counter) - \(partOfSpeech)"
        } else {
            DetailCell.counter = 1
            DetailCell.tmp = partOfSpeech
            wordTypesLabel.text = "\(DetailCell.counter) - \(partOfSpeech)"
        }
        definitionsLabel.text = definition
        //exampleLabel.text = example
    }

}

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

     static var counter = 0
    private static var tmp = "Noun"
    let attributedString = NSMutableAttributedString()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    fileprivate func setWordTypesColor(_ counter: String, _ parthOfSpeech: String) {
        let counterString = NSAttributedString(string: "\(counter) - ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedString.append(counterString)
        let partOfSpeechString = NSAttributedString(string: parthOfSpeech, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        attributedString.append(partOfSpeechString)
        wordTypesLabel.attributedText = attributedString
    }

    func configureCell(partOfSpeech: String, definition: String) {

        if DetailCell.tmp == partOfSpeech {
            DetailCell.counter += 1
            setWordTypesColor(String(DetailCell.counter), partOfSpeech)
        } else {
            DetailCell.counter = 1
            DetailCell.tmp = partOfSpeech
            setWordTypesColor(String(DetailCell.counter), partOfSpeech)
        }
        definitionsLabel.text = definition
        //exampleLabel.text = example
    }

}

//
//  DetailCell.swift
//  Dictionary
//
//  Created by Melik Demiray on 8.06.2024.
//

import UIKit

final class DetailCell: UITableViewCell {

    @IBOutlet private weak var exampleTitle: UILabel!
    @IBOutlet private weak var wordTypesLabel: UILabel!
    @IBOutlet private weak var definitionsLabel: UILabel!
    @IBOutlet private weak var exampleLabel: UILabel!

    static var counter = 0
    private static var tmp = "Noun"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    fileprivate func setWordTypesColor(_ counter: String, _ parthOfSpeech: String) {
        let attributedString = NSMutableAttributedString()
        let counterString = NSAttributedString(string: "\(counter) - ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedString.append(counterString)
        let partOfSpeechString = NSAttributedString(string: parthOfSpeech, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        attributedString.append(partOfSpeechString)
        wordTypesLabel.attributedText = attributedString
    }

    fileprivate func setExampleLabel(_ example: String) {
        if example != "" {
            exampleLabel.isHidden = false
            exampleTitle.isHidden = false
            exampleLabel.text = example
        }
        else {
            exampleLabel.isHidden = true
            exampleTitle.isHidden = true
        }
    }

    fileprivate func setPartOfSpeechLabel(_ partOfSpeech: String) {
        if DetailCell.tmp == partOfSpeech {
            DetailCell.counter += 1
            setWordTypesColor(String(DetailCell.counter), partOfSpeech)
        } else {
            DetailCell.counter = 1
            DetailCell.tmp = partOfSpeech
            setWordTypesColor(String(DetailCell.counter), partOfSpeech)
        }
    }

    func configureCell(_ detailEntity: DetailModel) {

        let partOfSpeech = detailEntity.partOfSpeech
        let definition = detailEntity.definitions
        let example = detailEntity.examples

        setPartOfSpeechLabel(partOfSpeech)
        definitionsLabel.text = definition
        setExampleLabel(example)
    }
}

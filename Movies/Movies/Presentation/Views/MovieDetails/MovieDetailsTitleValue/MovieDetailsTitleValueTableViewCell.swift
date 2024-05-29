//
//  MovieDetailsTitleValueTableViewCell.swift
//  Movies
//
//  Created by Michelle on 29/05/2024.
//

import UIKit

class MovieDetailsTitleValueTableViewCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ viewModel: MovieDetailsTitleValueCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}

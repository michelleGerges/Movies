//
//  MovieDetailsDescriptionTableViewCell.swift
//  Movies
//
//  Created by Michelle on 29/05/2024.
//

import UIKit

class MovieDetailsDescriptionTableViewCell: UITableViewCell {

    @IBOutlet private var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ viewModel: MovieDetailsDescriptionCellViewModel) {
        descriptionLabel.text = viewModel.description
    }
}

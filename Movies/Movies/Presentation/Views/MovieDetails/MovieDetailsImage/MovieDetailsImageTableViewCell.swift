//
//  MovieDetailsImageTableViewCell.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import UIKit

class MovieDetailsImageTableViewCell: UITableViewCell {

    @IBOutlet private var posterImageView: URLImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Image Width:height scale is 27:40
        // as this the regular Movie poster size 27 x 40 inches
        // added within the Xib
    }
    
    func configure(_ viewModel: MovieDetailsImageCellViewModel) {
        posterImageView.load(url: viewModel.imageURL)
    }
}

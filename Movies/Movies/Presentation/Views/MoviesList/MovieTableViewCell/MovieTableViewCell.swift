//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var posterImageView: URLImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 4
    }
    
    func configure(_ viewModel: MovieCellViewModel) {
        posterImageView.load(url: viewModel.posterUrl)
        titleLabel.text = viewModel.title
        releaseDateLabel.text = viewModel.formattedReleaseDate
    }
}

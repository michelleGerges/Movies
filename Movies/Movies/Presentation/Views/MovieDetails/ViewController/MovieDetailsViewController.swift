//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {

    @IBOutlet private var movieDetailsTableView: UITableView!

    let viewModel: MovieDetailsViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setuopTableView()
        loadMovieDetails()
    }
    
    func setuopTableView() {
        
        movieDetailsTableView.dataSource = self
        movieDetailsTableView.delegate = self
        movieDetailsTableView.registerNibFor(cellClass: MovieDetailsImageTableViewCell.self)
        movieDetailsTableView.registerNibFor(cellClass: MovieDetailsDescriptionTableViewCell.self)
        movieDetailsTableView.registerNibFor(cellClass: MovieDetailsTitleValueTableViewCell.self)
    }
    
    func loadMovieDetails() {
        bindToViewModel()
        viewModel.loadMovieDetilas()
    }
    
    func bindToViewModel() {
        
        viewModel
            .$movieTitle
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)
        
        viewModel
            .$movieDetailsViewModels
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { _ in
                self.movieDetailsTableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel
            .$loadMovieDetailsError
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink {
                ToastView(message: $0.message)
                    .show()
            }
            .store(in: &subscriptions)
    }
}

extension MovieDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = viewModel.movieDetailsCellViewModelAt(indexPath)
        
        switch viewModel {
        case let viewModel as MovieDetailsImageCellViewModel:
            let cell = tableView.dequeueReusableCell(cellClass: MovieDetailsImageTableViewCell.self)
            cell.configure(viewModel)
            return cell
            
        case let viewModel as MovieDetailsDescriptionCellViewModel:
            let cell = tableView.dequeueReusableCell(cellClass: MovieDetailsDescriptionTableViewCell.self)
            cell.configure(viewModel)
            return cell
            
        case let viewModel as MovieDetailsTitleValueCellViewModel:
            let cell = tableView.dequeueReusableCell(cellClass: MovieDetailsTitleValueTableViewCell.self)
            cell.configure(viewModel)
            return cell
            
        default:
            fatalError("unsupported ViewModel type")
        }
    }
}

extension MovieDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

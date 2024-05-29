//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import UIKit
import Combine

class MoviesListViewController: UIViewController {
    
    @IBOutlet private var moviesTableView: UITableView!
    
    let viewModel: MoviesListViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
        setuopTableView()
        loadMovies()
    }
    
    func setuopTableView() {
        
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.registerNibFor(cellClass: MovieTableViewCell.self)
    }
    
    func loadMovies() {
        bindToViewModel()
        viewModel.loadMovies()
    }
    
    func bindToViewModel() {
        
        viewModel
            .$moviesViewModels
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { _ in
                self.moviesTableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel
            .$loadMoviesListError
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink {
                self.handleError($0)
            }
            .store(in: &subscriptions)
    }
    
    func handleError(_ error: Error) {
        if viewModel.isEmpty {
            showAlertWithError(message: error.message, tryAgainAction: {
                self.viewModel.loadMovies()
            })
        } else {
            ToastView(message: error.message).show()
        }
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellClass: MovieTableViewCell.self)
        cell.configure(viewModel.movieCellViewModelAt(indexPath))
        return cell
    }
}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectMovieAt(indexPath)
    }
}

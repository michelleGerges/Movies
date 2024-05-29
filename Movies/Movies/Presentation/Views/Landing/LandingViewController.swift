//
//  LandingViewController.swift
//  Movies
//
//  Created by Michelle on 27/05/2024.
//

import UIKit
import Combine
class LandingViewController: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    
    let viewModel: LandingViewModel
    init(viewModel: LandingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        viewModel.loadConfiguration()
    }
    
    func bindToViewModel() {
        viewModel
            .$loadConfigurationError
            .compactMap({ $0 })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.showAlertWithError(message: $0.message, tryAgainAction: {
                    self?.viewModel.loadConfiguration()
                })
            })
            .store(in: &subscriptions)
    }
}

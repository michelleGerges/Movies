//
//  UIViewController+Alert.swift
//  Movies
//
//  Created by Michelle on 27/05/2024.
//

import UIKit

extension UIViewController {
    
    func showAlertWithError(message: String, tryAgainAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try Again",
                                      style: .default, handler: { _ in
            tryAgainAction()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

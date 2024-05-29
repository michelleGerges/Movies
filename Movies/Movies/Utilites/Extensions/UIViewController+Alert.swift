//
//  UIViewController+Alert.swift
//  Movies
//
//  Created by Michelle on 27/05/2024.
//

import UIKit

extension UIViewController {
    
    func showAlertWithError(message: String, tryAgainAction: @escaping () -> Void, cancelAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try Again",
                                      style: .default, handler: { _ in
            tryAgainAction()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .destructive, handler: { _ in
            cancelAction?()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//
//  ToastView.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import UIKit

class ToastView: UIView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        self.messageLabel.text = message
        setupView()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func setupView() {
        
        backgroundColor = UIColor.systemRed
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    func show(duration: TimeInterval = 2.0) {
        
        guard let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.delegate as? SceneDelegate })
                .first?.window else {
            return
        }
        
        window.addSubview(self)
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let margin: CGFloat = 12.0
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            self.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 0.0),
            self.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: margin),
            self.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -margin)
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                self.alpha = 0.0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}


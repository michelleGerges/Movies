//
//  UITableView+Register.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerNibFor(cellClass: UITableViewCell.Type) {
        self.register(UINib(nibName: cellClass.cellNibName, bundle: nil),
                      forCellReuseIdentifier: cellClass.cellIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cellClass: T.Type) -> T {
        guard let cell: T = self.dequeueReusableCell(withIdentifier: cellClass.cellIdentifier) as? T else {
            fatalError("no \(cellClass.cellIdentifier) registered")
        }
        return cell
    }
}

extension UITableViewCell {
    
    static var cellIdentifier: String {
        return NSStringFromClass(Self.self)
    }
    
    static var cellNibName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last ?? ""
    }
}

//
//  UIAlertController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/08.
//

import UIKit

extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitle: String?, action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: action)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}




//
//  AlertView.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-24.
//

import UIKit

enum AlertViewType {
    case optional, determinal
}

class AlertView: UIAlertController {
    // MARK: - Properties
    private var completionHandler: ((Bool) -> Void)?
    private var alertViewType: AlertViewType!
    
    // MARK: - Initializers
    convenience init(title: String?, message: String?, alertViewType: AlertViewType,
                     completionHandler: ((Bool) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: .alert)
        self.alertViewType = alertViewType
        self.completionHandler = completionHandler
        configure()
    }
    
    // MARK: - Configuration
    private func configure() {
        let okAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
            self?.completionHandler?(true)
        }
        addAction(okAction)
        
        if alertViewType == .optional {
            let cancelAction = UIAlertAction(title: "CANCEL", style: .default) { [weak self] _ in
                self?.completionHandler?(false)
            }
            addAction(cancelAction)
        }
    }
}

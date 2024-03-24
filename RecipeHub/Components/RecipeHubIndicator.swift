//
//  RecipeHubIndicator.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

import UIKit

class RecipeHubIndicator: UIActivityIndicatorView {
    
    private var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.style = .large
        self.color = AppColors.lightGreen.value
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        self.isHidden = false
        self.startAnimating()
    }
    
    func hide() {
        self.isHidden = true
        self.stopAnimating()
    }
}

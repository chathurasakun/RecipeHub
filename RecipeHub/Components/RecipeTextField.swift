//
//  RecipeTextField.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

import UIKit

class RecipeTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 0.7
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.font = UIFont.systemFont(ofSize: 16)
        
        let insetView = UIView(frame: CGRect(x: 8, y: 0, width: 10, height: self.frame.height))
        self.leftView = insetView
        self.leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

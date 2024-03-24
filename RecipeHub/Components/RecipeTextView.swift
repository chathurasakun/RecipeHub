//
//  RecipeTextView.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

import UIKit

class RecipeTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 0.7
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.contentInset = UIEdgeInsets(top: 7, left: 7, bottom: 0, right: 5)
        self.font = UIFont.systemFont(ofSize: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  UITextViewExt.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

import UIKit

extension UITextView {
    func addPlaceholder(_ placeholder: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = self.font
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100 // Tag to identify the placeholder label
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 7, y: (self.font?.pointSize ?? 0) / 2)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc func textChanged() {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
}

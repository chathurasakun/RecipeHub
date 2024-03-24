//
//  UIImageExt.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-24.
//
import UIKit

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
}

//
//  AppColors.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//
import UIKit

enum AppColors {
    case lightGrayBG
    case DeepBlue
    
    var value: UIColor {
        switch self {
        case .lightGrayBG:
            return UIColor(named: "lightGrayBG") ?? UIColor.lightGray
        case .DeepBlue:
            return UIColor(named: "DeepBlue") ?? .green
        }
    }
}

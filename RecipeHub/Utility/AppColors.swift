//
//  AppColors.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//
import UIKit

enum AppColors {
    case lightGrayBG
    case lightGreen
    
    var value: UIColor {
        switch self {
        case .lightGrayBG:
            return UIColor(named: "lightGrayBG") ?? UIColor.lightGray
        case .lightGreen:
            return UIColor(named: "lightGreen") ?? .green
        }
    }
}

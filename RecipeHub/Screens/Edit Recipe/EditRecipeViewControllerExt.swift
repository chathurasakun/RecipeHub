//
//  EditRecipeViewControllerExt.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-24.
//

import Foundation

// MARK: - Register Observers
extension EditRecipeViewController {
    func setObservers() {
        // Update Recipe
        viewModel.recipieUpdated
            .sink { [weak self] success in
                self?.loadingIndicator.stopAnimating()
                if success {
                    let alertView = AlertView(title: "",
                                              message: "Updated recipe successfully.",
                                              alertViewType: .determinal, completionHandler: { _ in
                            self?.navigationController?.popViewController(animated: true)
                    })
                    self?.present(alertView, animated: false)
                } else {
                    let alertView = AlertView(title: "",
                                              message: "Recipe update failed. Server couldn't" +
                                              " respond to your request.",
                                              alertViewType: .determinal, completionHandler: { _ in})
                    self?.present(alertView, animated: false)
                }
            }
            .store(in: &cancellables)
        
        // Delete Recipe
        viewModel.recipieDeleted
            .sink { [weak self] success in
                self?.loadingIndicator.stopAnimating()
                if success {
                    let alertView = AlertView(title: "",
                                              message: "Recipe deleted successfully.",
                                              alertViewType: .determinal, completionHandler: { _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    self?.present(alertView, animated: false)
                } else {
                    let alertView = AlertView(title: "",
                                              message: "Recipe deletion failed. Server couldn't" +
                                              " respond to your request.",
                                              alertViewType: .determinal, completionHandler: { _ in})
                    self?.present(alertView, animated: false)
                }
            }
            .store(in: &cancellables)
        
    }
}

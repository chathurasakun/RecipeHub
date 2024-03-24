//
//  RecipeDetailsViewController.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-24.
//

import UIKit
import Swinject

class RecipeDetailsViewController: UIViewController {
    let viewModel: RecipeDetailsViewModelProtocol
    
    // MARK: - Components
    private let editBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                    target: RecipeDetailsViewController.self,
                                                                    action: nil)
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let pickedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 22)
        label.text = "Recipe Name"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let recipeTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "Select Type"
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .lightGray
        return label
    }()
    
    private let ingredientsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = "****** Ingredients: -"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = "Ingredients"
        label.textAlignment = .left
        label.numberOfLines = 20
        return label
    }()
    
    private let stepsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = "****** Steps to follow: -"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let stepsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "Steps"
        label.textAlignment = .left
        label.numberOfLines = 20
        return label
    }()
    
    private let gapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Life Cycle
    init(viewModel: RecipeDetailsViewModelProtocol = Container.sharedDIContainer.resolve(RecipeDetailsViewModelProtocol.self)!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        configureUI()
    }
    
    deinit {
        print("RecipeDetailsViewController Deallocated")
    }
    
    // MARK: - SetUp UI
    private func setUpUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = editBarButton
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0)
        ])
        
        scrollView.addSubview(baseView)
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            baseView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0),
            baseView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            baseView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
            baseView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0)
        ])
        
        baseView.addSubview(pickedImageView)
        NSLayoutConstraint.activate([
            pickedImageView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 0),
            pickedImageView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: 0),
            pickedImageView.heightAnchor.constraint(equalToConstant: 200),
            pickedImageView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 0)
        ])
        
        
        baseView.addSubview(recipeNameLabel)
        NSLayoutConstraint.activate([
            recipeNameLabel.topAnchor.constraint(equalTo: pickedImageView.bottomAnchor,
                                                  constant: 7),
            recipeNameLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12),
            recipeNameLabel.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -5)
        ])
        
        baseView.addSubview(recipeTypeLabel)
        NSLayoutConstraint.activate([
            recipeTypeLabel.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor,
                                                  constant: 7),
            recipeTypeLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12),
            recipeTypeLabel.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -5)
        ])
        
        baseView.addSubview(ingredientsTitleLabel)
        NSLayoutConstraint.activate([
            ingredientsTitleLabel.topAnchor.constraint(equalTo: recipeTypeLabel.bottomAnchor,
                                                  constant: 7),
            ingredientsTitleLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12),
        ])
        
        baseView.addSubview(ingredientsLabel)
        NSLayoutConstraint.activate([
            ingredientsLabel.topAnchor.constraint(equalTo: ingredientsTitleLabel.bottomAnchor,
                                                  constant: 7),
            ingredientsLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12),
            ingredientsLabel.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -5)
        ])
        
        baseView.addSubview(stepsTitleLabel)
        NSLayoutConstraint.activate([
            stepsTitleLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor,
                                                  constant: 7),
            stepsTitleLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12),
        ])
        
        baseView.addSubview(stepsLabel)
        NSLayoutConstraint.activate([
            stepsLabel.topAnchor.constraint(equalTo: stepsTitleLabel.bottomAnchor,
                                            constant: 7),
            stepsLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12),
            stepsLabel.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -5)
        ])
        
        baseView.addSubview(gapView)
        NSLayoutConstraint.activate([
            gapView.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 0),
            gapView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: 0),
            gapView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0),
            gapView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 0),
            gapView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        if let url = viewModel.currentRecipe?.image {
            if let imagURL = URL(string: url) {
                pickedImageView.load(url: imagURL)
            }
        }
        recipeNameLabel.text = viewModel.currentRecipe?.name ?? ""
        recipeTypeLabel.text?.mergeStrings(array: viewModel.currentRecipe?.mealType ?? [])
        ingredientsLabel.text?.concatStrings(array: viewModel.currentRecipe?.ingredients ?? [])
        stepsLabel.text?.concatStrings(array: viewModel.currentRecipe?.instructions ?? [])
    }
    
    
    
}

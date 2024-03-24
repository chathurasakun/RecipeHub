//
//  EditRecipeViewController.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-24.
//

import UIKit
import Swinject
import RxSwift

class EditRecipeViewController: UIViewController {
    var viewModel: EditRecipeViewModelProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Components
    private let updateBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                    target: EditRecipeViewController.self,
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
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Recipe Name"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let recipeNameTextField: RecipeTextField = {
        let textField = RecipeTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type Recipe Name Here..."
        return textField
    }()
    
    private let recipeTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Select Type"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let recipeTypeTextField: RecipeTextField = {
        let textField = RecipeTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Recipe Type..."
        return textField
    }()
    
    private lazy var recipeTypePicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .gray
        return pickerView
    }()
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Ingredients"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let addIngredientsTextView: RecipeTextView = {
        let textView = RecipeTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.addPlaceholder("Enter Ingrediants Here...")
        return textView
    }()
    
    private let stepsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Steps"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let addStepsTextView: RecipeTextView = {
        let textView = RecipeTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.addPlaceholder("Enter Steps Here...")
        return textView
    }()
    
    private let recipeImageInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Please add recipe image of size less than 5 MB"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .lightGray
        return label
    }()
    
    private let addRecipePhotoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Add Recipe Photo"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let uploadConatiner: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.lightGrayBG.value
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "upload")
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let pickedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private let deleteRecipeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete Recipe", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = AppColors.lightGrayBG.value
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let gapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                              target: CreateRecipeViewController.self,
                                                              action: nil)
    private lazy var cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self, action: nil)
    private lazy var flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                                 target: nil, action: nil)
    
    private lazy var loadingIndicator: RecipeHubIndicator = {
        let indicator = RecipeHubIndicator(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var imagePicker = UIImagePickerController()
    
    // MARK: - Life Cycle
    init(viewModel: EditRecipeViewModelProtocol = Container.sharedDIContainer.resolve(EditRecipeViewModelProtocol.self)!) {
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
        setUIBindings()
        initMethod()
    }
    
    deinit {
        print("EditRecipeViewController Deallocated")
    }
    
    private func initMethod() {
        imagePicker.delegate = self
    }
    
    // MARK: - Setup UI
    private func setUpUI() {
        title = "Update Recipe Details"
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = updateBarButton
        
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
    
        baseView.addSubview(recipeTypeLabel)
        NSLayoutConstraint.activate([
            recipeTypeLabel.topAnchor.constraint(equalTo: baseView.topAnchor,
                                                  constant: 20),
            recipeTypeLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12)
        ])
        
        baseView.addSubview(recipeTypeTextField)
        NSLayoutConstraint.activate([
            recipeTypeTextField.topAnchor.constraint(equalTo: recipeTypeLabel.bottomAnchor,
                                                        constant: 7),
            recipeTypeTextField.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -12),
            recipeTypeTextField.heightAnchor.constraint(equalToConstant: 50),
            recipeTypeTextField.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12)
        ])
        
        baseView.addSubview(recipeNameLabel)
        NSLayoutConstraint.activate([
            recipeNameLabel.topAnchor.constraint(equalTo: recipeTypeTextField.bottomAnchor,
                                                  constant: 15),
            recipeNameLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12)
        ])
        
        baseView.addSubview(recipeNameTextField)
        NSLayoutConstraint.activate([
            recipeNameTextField.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor,
                                                        constant: 7),
            recipeNameTextField.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -12),
            recipeNameTextField.heightAnchor.constraint(equalToConstant: 50),
            recipeNameTextField.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12)
        ])
        
        baseView.addSubview(ingredientsLabel)
        NSLayoutConstraint.activate([
            ingredientsLabel.topAnchor.constraint(equalTo: recipeNameTextField.bottomAnchor,
                                                  constant: 15),
            ingredientsLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12)
        ])
        
        baseView.addSubview(addIngredientsTextView)
        NSLayoutConstraint.activate([
            addIngredientsTextView.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor,
                                                        constant: 7),
            addIngredientsTextView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -12),
            addIngredientsTextView.heightAnchor.constraint(equalToConstant: 120),
            addIngredientsTextView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12)
        ])
        
        baseView.addSubview(stepsLabel)
        NSLayoutConstraint.activate([
            stepsLabel.topAnchor.constraint(equalTo: addIngredientsTextView.bottomAnchor,
                                            constant: 15),
            stepsLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12)
        ])
        
        baseView.addSubview(addStepsTextView)
        NSLayoutConstraint.activate([
            addStepsTextView.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor,
                                                        constant: 7),
            addStepsTextView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -12),
            addStepsTextView.heightAnchor.constraint(equalToConstant: 200),
            addStepsTextView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12)
        ])
        
        baseView.addSubview(addRecipePhotoLabel)
        NSLayoutConstraint.activate([
            addRecipePhotoLabel.topAnchor.constraint(equalTo: addStepsTextView.bottomAnchor,
                                            constant: 15),
            addRecipePhotoLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 12)
        ])
        
        baseView.addSubview(uploadConatiner)
        NSLayoutConstraint.activate([
            uploadConatiner.topAnchor.constraint(equalTo: addRecipePhotoLabel.bottomAnchor,
                                                 constant: 10),
            uploadConatiner.heightAnchor.constraint(equalToConstant: 240),
            uploadConatiner.widthAnchor.constraint(equalToConstant: 240),
            uploadConatiner.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0),
        ])
        
        uploadConatiner.addSubview(uploadImageView)
        NSLayoutConstraint.activate([
            uploadImageView.centerXAnchor.constraint(equalTo: uploadConatiner.centerXAnchor,
                                                     constant: 0),
            uploadImageView.centerYAnchor.constraint(equalTo: uploadConatiner.centerYAnchor,
                                                     constant: 0),
            uploadImageView.widthAnchor.constraint(equalToConstant: 60),
            uploadImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        uploadConatiner.addSubview(pickedImageView)
        NSLayoutConstraint.activate([
            pickedImageView.centerXAnchor.constraint(equalTo: uploadConatiner.centerXAnchor,
                                                     constant: 0),
            pickedImageView.centerYAnchor.constraint(equalTo: uploadConatiner.centerYAnchor,
                                                     constant: 0),
            pickedImageView.widthAnchor.constraint(equalToConstant: 200),
            pickedImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        baseView.addSubview(recipeImageInfoLabel)
        NSLayoutConstraint.activate([
            recipeImageInfoLabel.topAnchor.constraint(equalTo: uploadConatiner.bottomAnchor,
                                            constant: 7),
            recipeImageInfoLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor,
                                                          constant: 0)
        ])
        
        baseView.addSubview(deleteRecipeButton)
        NSLayoutConstraint.activate([
            deleteRecipeButton.topAnchor.constraint(equalTo: recipeImageInfoLabel.bottomAnchor,
                                                    constant: 50),
            deleteRecipeButton.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -15),
            deleteRecipeButton.heightAnchor.constraint(equalToConstant: 44),
            deleteRecipeButton.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 15)
        ])
        
        baseView.addSubview(gapView)
        NSLayoutConstraint.activate([
            gapView.topAnchor.constraint(equalTo: deleteRecipeButton.bottomAnchor, constant: 0),
            gapView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: 0),
            gapView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0),
            gapView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 0),
            gapView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        recipeTypeTextField.text?.mergeStrings(array: viewModel.currentRecipe?.mealType ?? [])
        recipeNameTextField.text = viewModel.currentRecipe?.name ?? ""
        
        addIngredientsTextView.addPlaceholder("")  // clear placeholder
        addIngredientsTextView.text.concatStrings(array: viewModel.currentRecipe?.ingredients ?? [])
        
        addStepsTextView.addPlaceholder("")    // clear placeholder
        addStepsTextView.text.concatStrings(array: viewModel.currentRecipe?.instructions ?? [])
        
        if let imageURL = viewModel.currentRecipe?.image {
            if let URL = URL(string: imageURL) {
                pickedImageView.load(url: URL)
                pickedImageView.isHidden = false
            }
        }
    }
    
    // MARK: - Set UI Bindings
    private func setUIBindings() {
        // Create Bar Button
        updateBarButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.loadingIndicator.startAnimating()
                self?.viewModel.updateRecipeDetails()
            })
            .disposed(by: disposeBag)
        
        // On tap TextField open UIPicker
        recipeTypeTextField.inputView = recipeTypePicker
        
        let tapGesture = UITapGestureRecognizer()
        recipeTypeTextField.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.showUIPicker()
            })
            .disposed(by: disposeBag)
        
        // Bind data to picker
        Observable.just(viewModel.recipeTypes)
            .bind(to: recipeTypePicker.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        // On picker value changed
        recipeTypePicker.rx.itemSelected
            .map { $0.row }
            .subscribe(onNext: { [weak self] value in
                let mealTypes = [(self?.viewModel.recipeTypes[value])!]
                self?.viewModel.currentRecipe?.mealType = mealTypes
                self?.recipeTypeTextField.text = self?.viewModel.recipeTypes[value]
            })
            .disposed(by: disposeBag)
        
        // Picker toolbar Done barbutton action
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.recipeTypePicker.removeFromSuperview()
                self?.view.subviews.last?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        // Picker toolbar Cancel barbutton action
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.recipeTypePicker.removeFromSuperview()
                self?.view.subviews.last?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        // Recipe Name textfield
        recipeNameTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.currentRecipe?.name = text
            })
            .disposed(by: disposeBag)
        
        // Bind textView changes to some observer
        addIngredientsTextView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                let ingrediants = text.seperateStringByComma()
                self?.viewModel.currentRecipe?.ingredients = ingrediants
            })
            .disposed(by: disposeBag)
        
        // Bind textView changes to some observer
        addStepsTextView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                let steps = text.seperateStringByComma()
                self?.viewModel.currentRecipe?.instructions = steps
            })
            .disposed(by: disposeBag)
        
        // Upload container tap gesture
        let uploadContainerTapGesture = UITapGestureRecognizer()
        uploadConatiner.addGestureRecognizer(uploadContainerTapGesture)
        
        uploadContainerTapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.openImagePicker()
            })
            .disposed(by: disposeBag)
        
        // Delete Recipe Button
        deleteRecipeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let alertView = AlertView(title: "",
                                          message: "You are going to delete the recipe. Are you sure",
                                          alertViewType: .optional, completionHandler: { okay in
                    if okay {
                        self?.viewModel.deleteRecipe()
                    }
                })
                self?.present(alertView, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func openImagePicker() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    private func showUIPicker() {
        recipeTypePicker.frame = CGRect(x: 0, y: view.frame.height - 200, width: view.frame.width,
                                        height: 250)
        view.addSubview(recipeTypePicker)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: view.frame.height - 240,
                                              width: view.frame.width, height: 40))
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        view.addSubview(toolbar)
    }
}

// MARK: - ImagePicker Delegate
extension EditRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // This method is called when the user picks an image
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImageView.image = pickedImage
            pickedImageView.isHidden = false
            viewModel.currentRecipe?.image = pickedImage.toBase64() ?? ""
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

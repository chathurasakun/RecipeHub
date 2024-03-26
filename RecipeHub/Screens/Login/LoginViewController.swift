//
//  LoginViewController.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-25.
//

import UIKit
import Swinject
import RxSwift
import Combine

class LoginViewController: UIViewController {
    var viewModel: LoginViewModelProtocol
    private let disposeBag = DisposeBag()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Components
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Username"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let usernameTextField: RecipeTextField = {
        let textField = RecipeTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Password"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let passwordTextField: RecipeTextField = {
        let textField = RecipeTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.DeepBlue.value
        button.layer.cornerRadius = 12
        return button
    }()
    
    lazy var loadingIndicator: RecipeHubIndicator = {
        let indicator = RecipeHubIndicator(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - LifeCycle
    init(viewModel: LoginViewModelProtocol = Container.sharedDIContainer.resolve(LoginViewModelProtocol.self)!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUIBindings()
        setObservers()
    }
    
    deinit {
        print("LoginViewController Deallocated")
    }

    // MARK: - Setup UI
    private func setUpUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .white
        
        view.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                  constant: 100),
            usernameLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 12)
        ])
        
        view.addSubview(usernameTextField)
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor,
                                                        constant: 7),
            usernameTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -12),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            usernameTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 12)
        ])
        
        view.addSubview(passwordLabel)
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor,
                                                  constant: 12),
            passwordLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 12)
        ])
        
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor,
                                                        constant: 7),
            passwordTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -12),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 12)
        ])
        
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                    constant: 20),
            loginButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -15),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 15)
        ])
        
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50)
        ])
    }
    
    // MARK: - Register UI Bindings
    private func setUIBindings() {
        // Username textfield
        usernameTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.username = text
            })
            .disposed(by: disposeBag)
        
        // Password textfield
        passwordTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.password = text
            })
            .disposed(by: disposeBag)
        
        // Login Button
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let username = self?.viewModel.username else {
                    return
                }
                if username.isEmpty {
                    let alertView = AlertView(title: "Error", message: "Username cannot be empty",
                                              alertViewType: .determinal) { _ in }
                    self?.present(alertView, animated: false)
                    return
                }
                
                guard let password = self?.viewModel.password else {
                    return
                }
                if password.isEmpty {
                    let alertView = AlertView(title: "Error", message: "Password cannot be empty",
                                              alertViewType: .determinal) { _ in }
                    self?.present(alertView, animated: false)
                    return
                }
                self?.loadingIndicator.startAnimating()
                self?.viewModel.loginUser()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Register Observers
    private func setObservers() {
        viewModel.loggedSuccessfully
            .sink(receiveCompletion: { [weak self] completion in
                self?.loadingIndicator.stopAnimating()
                
                switch completion {
                case .failure(let error):
                    let alertView = AlertView(title: "Error",
                                              message: error.localizedDescription,
                                              alertViewType: .determinal, completionHandler: { _ in})
                    self?.present(alertView, animated: false)
                default:
                    break
                }
            }, receiveValue: { [weak self] value in
                if value {
                    let recipeListViewController = RecipeListViewController()
                    self?.navigationController?.setViewControllers([recipeListViewController],
                                                                   animated: true)
                }
            })
            .store(in: &cancellables)
    }

}

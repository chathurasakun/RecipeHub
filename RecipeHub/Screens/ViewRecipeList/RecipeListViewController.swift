//
//  RecipeListViewController.swift
//  RecipeHub
//
//  Created by CHATHURA ELLAWALA on 2024-03-23.
//

import UIKit
import Swinject
import RxSwift
import Combine

class RecipeListViewController: UIViewController {
    var viewModel: RecipeListViewModelProtocol
    private let disposeBag = DisposeBag()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Components
    private var showPickerButton: UIButton = {
        let pickerButton = UIButton()
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        pickerButton.setTitle("Select Recipe Type", for: .normal)
        pickerButton.setTitleColor(.blue, for: .normal)
        pickerButton.tintColor = .cyan
        return pickerButton
    }()
    
    private lazy var recipeTypePicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .gray
        return pickerView
    }()
    
    private let recipeTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                              target: RecipeListViewController.self,
                                                              action: nil)
    private lazy var cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self, action: nil)
    private lazy var flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                                 target: nil, action: nil)
    private var createBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                    target: RecipeListViewController.self,
                                                                    action: nil)
    private lazy var loadingIndicator: RecipeHubIndicator = {
        let indicator = RecipeHubIndicator(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - LifeCycle
    init(viewModel: RecipeListViewModelProtocol = Container.sharedDIContainer.resolve(RecipeListViewModelProtocol.self)!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUIBindings()
        setObservers()
    }
    
    deinit {
        print("RecipeListViewController Deallocated")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        let safeArea = view.safeAreaLayoutGuide
        title = "Recipe List"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = createBarButton
        
        view.addSubview(showPickerButton)
        NSLayoutConstraint.activate([
            showPickerButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            showPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        view.addSubview(recipeTableView)
        recipeTableView.delegate = self
        NSLayoutConstraint.activate([
            recipeTableView.topAnchor.constraint(equalTo: showPickerButton.bottomAnchor, constant: 5),
            recipeTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            recipeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            recipeTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
        ])
        
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }
    
    // MARK: - Register Observers
    private func setObservers() {
        // Update tableView after recieve data
        viewModel.recipiesRecieved
            .sink { [weak self] success in
                self?.loadingIndicator.stopAnimating()
                if success {
                    DispatchQueue.main.async {
                        self?.recipeTableView.reloadData()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Register UI Bindings
    private func setUIBindings() {
        // Create Bar Button
        createBarButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let createRecipeViewController = CreateRecipeViewController()
                self?.navigationController?.pushViewController(createRecipeViewController,
                                                               animated: true)
            })
            .disposed(by: disposeBag)
        
        // Show picker button tap action
        showPickerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showPicker()
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
                self?.viewModel.mealType = (self?.viewModel.recipeTypes[value])!
            })
            .disposed(by: disposeBag)
        
        // Done barbutton action
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.recipeTypePicker.removeFromSuperview()
                self?.view.subviews.last?.removeFromSuperview()
                self?.loadingIndicator.startAnimating()
                self?.viewModel.getRecipeList()
            })
            .disposed(by: disposeBag)
        
        // Cancel barbutton action
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.recipeTypePicker.removeFromSuperview()
                self?.view.subviews.last?.removeFromSuperview()
            })
            .disposed(by: disposeBag)

        // On tableVie item select
        recipeTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.recipeTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        // Bind items to table view
        viewModel.recipies
            .bind(to: recipeTableView.rx.items(cellIdentifier: "identifier",
                                               cellType: UITableViewCell.self)) { (row, item, cell) in
                cell.textLabel?.text = item.name
            }
            .disposed(by: disposeBag)
    }
    
    private func showPicker() {
        recipeTypePicker.frame = CGRect(x: 0, y: view.frame.height - 200, width: view.frame.width,
                                        height: 250)
        view.addSubview(recipeTypePicker)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: view.frame.height - 240,
                                              width: view.frame.width, height: 40))
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        view.addSubview(toolbar)
    }
}

// MARK: - UITableView Delegate
extension RecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


//
//  CreateItemViewController.swift
//  Todoey
//
//  Created by Askar on 06.03.2023.
//

import UIKit
import SnapKit

final class CUViewController: UIViewController {
    
    private lazy var contentView = UIView()
    private var selectedPriority: Int16 = 1
    private var selectedSection: TodoeySection?
    private var selectedItem: TodoeyItem?
    private var isCreating: Bool = true
    
    private lazy var nameTextField: ViewTextField = {
        let viewTextField = ViewTextField()
        viewTextField.textField.placeholder = "Name"
        return viewTextField
    }()
    
    private lazy var descTextField: ViewTextField = {
        let viewTextField = ViewTextField()
        viewTextField.textField.placeholder = "Description"
        return viewTextField
    }()
    
    private lazy var priorityPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.backgroundColor = .systemBlue
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavBar()
        
        priorityPickerView.dataSource = self
        priorityPickerView.delegate = self
        
        setupViews()
        setupConstraints()
    
    }
    
    func configure(section: TodoeySection) {
        selectedSection = section
        isCreating = true
    }
    
    func configure(item: TodoeyItem) {
        isCreating = false
        selectedItem = item
        DispatchQueue.main.async {
            self.nameTextField.textField.text = item.name
            self.descTextField.textField.text = item.desc
        }
    }
}

//MARK: - Private methods

private extension CUViewController {
    
    func configureNavBar(){
        navigationItem.title = "Create Item"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func submitButtonPressed() {
        if let name = nameTextField.textField.text, name != "", let desc = descTextField.textField.text, desc != "" {
            switch isCreating {
            case true: ItemManager.shared.createItem(name: name, desc: desc, priority: selectedPriority, section: selectedSection!)
            case false: ItemManager.shared.editItem(item: selectedItem!, name: name, desc: desc, priority: selectedPriority)
            }
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Nil data found", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Return", style: .cancel))
            present(alert, animated: true)
        }
    }
}

//MARK: - Picker view data source and delegate methods

extension CUViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 1
        default: return Priority.allCases.count
        }
    }
}

extension CUViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "Priority: "
        default: return "\(Priority.allCases[row].rawValue)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPriority = Priority.allCases[row].rawValue
    }
}

//MARK: - Setup views and constraints

private extension CUViewController {
    
    func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(nameTextField)
        contentView.addSubview(descTextField)
        contentView.addSubview(priorityPickerView)
        contentView.addSubview(submitButton)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(7)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.1)
        }
        descTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.1)
        }
        priorityPickerView.snp.makeConstraints { make in
            make.top.equalTo(descTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.15)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(priorityPickerView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.1)
        }
    }
}


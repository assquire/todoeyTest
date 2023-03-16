//
//  FIlterViewController.swift
//  Todoey
//
//  Created by Askar on 14.03.2023.
//

import UIKit

protocol FilterToItemDelegate {
    func didUpdate(with isOn: Bool)
    func didFail(with error: Error)
}

final class FilterViewController: UIViewController {
    
    var delegate: FilterToItemDelegate?
    
    private lazy var contentView = UIView()
    private lazy var prioritySwitch = UISwitch()
    
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
        
        setupViews()
        setupConstraints()
    }
    
    func configure(with isShowingCompleted: Bool) {
        DispatchQueue.main.async {
            self.prioritySwitch.isOn = isShowingCompleted
        }
    }
}

//MARK: - Private controller methods

private extension FilterViewController {
    
    @objc func submitButtonPressed() {
        delegate?.didUpdate(with: prioritySwitch.isOn)
        dismiss(animated: true)
    }
}

//MARK: - Setup views and constraints

private extension FilterViewController {
    
    func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(prioritySwitch)
        contentView.addSubview(submitButton)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        prioritySwitch.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(prioritySwitch.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.1)
        }
    }
}

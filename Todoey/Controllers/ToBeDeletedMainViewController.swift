//
//  ItemViewController.swift
//  Todoey
//
//  Created by Yerzhan Syzdyk on 01.03.2023.
//

import UIKit

final class ToBeDeletedMainViewController: UIViewController {
    
    private var sections = [TodoeySection]()
    private lazy var contentView = UIView()
    
    private lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = .systemBlue
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .white
        return searchBar
    }()
    
    private lazy var itemTableView: UITableView = {
        let myTableView = UITableView()
        myTableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.IDENTIFIER)
        return myTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SectionManager.shared.delegate = self
        SectionManager.shared.fetchSections()
        
        view.backgroundColor = .systemBackground
        configureNavBar()
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        setupViews()
        setupConstraints()
    }
}

//MARK: SectionManger delegate methods

extension ToBeDeletedMainViewController: SectionManagerDelegate {
    
    func didUpdate(with models: [TodoeySection]) {
        self.sections = models
        
        DispatchQueue.main.async {
            self.itemTableView.reloadData()
        }
    }
}

//MARK: - Private methods

private extension ToBeDeletedMainViewController {
    
    func configureNavBar() {
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc private func addButtonTapped() {
        let alert  = UIAlertController(title: "New Section", message: "Create new section", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            
            SectionManager.shared.createSection(with: text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

//MARK: - Table view data source methods

extension ToBeDeletedMainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.IDENTIFIER) as! ItemTableViewCell
//        cell.configure(with: sections[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - Table view delegate methods

extension ToBeDeletedMainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.size.height * 0.1
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            SectionManager.shared.deleteSection(section: self.sections[indexPath.row])
        }

        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            let alert  = UIAlertController(title: "Edit Section", message: "Change name of section", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = self.sections[indexPath.row].name
            alert.addAction(UIAlertAction(title: "Change", style: .cancel, handler: { _ in
                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }

                SectionManager.shared.editSection(section: self.sections[indexPath.row], with: text)
            }))

            self.present(alert, animated: true)
        }

        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}


//MARK: - Section Headin

private extension ToBeDeletedMainViewController{
    
    func setupViews(){
        view.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(itemTableView)
    }
    
    func setupConstraints(){
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        searchBar.searchTextField.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
        itemTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

//
//  ViewController.swift
//  Todoey
//
//  Created by Yerzhan Syzdyk on 27.02.2023.
//

import UIKit
import SnapKit
import CoreData

final class ItemViewController: UIViewController {
    
    private var items = [TodoeyItem]()
    private var selectedSection: TodoeySection?
    private var isShowingCompleted = false
    
    private lazy var contentView = UIView()
    
    private lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var itemsTableView : UITableView = {
        let myTableView = UITableView()
        myTableView.register(DataTableViewCell.self, forCellReuseIdentifier: DataTableViewCell.IDENTIFIER)
        return myTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        ItemManager.shared.delegate = self
        ItemManager.shared.fetchItems(section: selectedSection!, isShowingCompleted: isShowingCompleted)
        
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        searchBar.delegate = self
        
        configureNavBar()
        setupViews()
        setupConstraints()
    }
    
    func configure(with section: TodoeySection) {
        self.selectedSection = section
    }
}

//MARK: - Private methods

private extension ItemViewController{
    
    func configureNavBar() {
        navigationItem.title = selectedSection?.name
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let filterButton = UIButton()
        filterButton.setImage(UIImage(systemName: "switch.2"), for: .normal)
        filterButton.addTarget(self, action: #selector(filtedButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: filterButton)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        navigationItem.rightBarButtonItems = [addButton, barButton]
    }
    
    @objc private func addButtonTapped() {
        guard let selectedSection else { return }
        let controller = CUViewController()
        controller.configure(section: selectedSection)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func filtedButtonTapped() {
        let controller = FilterViewController()
        controller.delegate = self
        controller.configure(with: isShowingCompleted)
        present(controller, animated: true)
    }
}

//MARK: - Search bar delegate methods
extension ItemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ItemManager.shared.fetchItems(with: searchText,section: selectedSection!, isShowingCompleted: isShowingCompleted)
    }
}

//MARK: - Item manager delegate methods

extension ItemViewController: ItemManagerDelegate{
    func didUpdate(with list: [TodoeyItem]) {
        items = list
        DispatchQueue.main.async {
            self.itemsTableView.reloadData()
        }
    }
}

//MARK: - Table view data source methods

extension ItemViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.IDENTIFIER) as! DataTableViewCell
        cell.configure(with: items[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - Table view delegate methods

extension ItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.size.height * 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Hello!")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { (_, _, _) in
            ItemManager.shared.completeItem(item: self.items[indexPath.row])
        }
        completeAction.backgroundColor = .systemBlue
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            let controller = CUViewController()
            controller.configure(item: self.items[indexPath.row])
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [completeAction, editAction])
        return configuration
    }
}

extension ItemViewController: FilterToItemDelegate {
    
    func didUpdate(with isOn: Bool) {
        isShowingCompleted = isOn
        ItemManager.shared.fetchItems(section: selectedSection!, isShowingCompleted: isShowingCompleted)
    }
}

//MARK: - Setup view and constraints methods

extension ItemViewController{
    
    func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(itemsTableView)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        searchBar.searchTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(7)
            make.leading.trailing.equalToSuperview()
        }
        itemsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}

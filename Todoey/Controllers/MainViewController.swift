//
//  ViewController.swift
//  Todoey
//
//  Created by Yerzhan Syzdyk on 27.02.2023.
//

import UIKit
import SnapKit
import CoreData

final class MainViewController: UIViewController {
    
    private var items = [TodoeyItem]()
    private var selectedSection: TodoeySection?
    private var isShowingCompleted = false
    
    private lazy var contentView = UIView()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.layer.cornerRadius = 15
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = .systemBlue
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .white
        return searchBar
    }()
    
    private lazy var sectionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ID")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var itemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.IDENTIFIER)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var addItemButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add new task", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 40
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        sectionCollectionView.dataSource = self
        sectionCollectionView.delegate = self
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

private extension MainViewController{
    
    func configureNavBar() {
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func addButtonTapped() {
        let controller = CUViewController()
        present(controller, animated: true)
    }
    
    @objc private func filtedButtonTapped() {
        let controller = FilterViewController()
        controller.delegate = self
        controller.configure(with: isShowingCompleted)
        present(controller, animated: true)
    }
}

//MARK: - Search bar delegate methods
extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
}

//MARK: - Item manager delegate methods

extension MainViewController: ItemManagerDelegate{
    func didUpdate(with list: [TodoeyItem]) {
        items = list
        DispatchQueue.main.async {
            self.itemsTableView.reloadData()
        }
    }
}

//MARK: - Table view data source methods

extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        items.count
        15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.IDENTIFIER) as! ItemTableViewCell
//        cell.configure(with: items[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - Table view delegate methods

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        125
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

//MARK: - Collection view data source and delegate methods

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ID", for: indexPath)
        cell.layer.cornerRadius = 15
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 2
        cell.clipsToBounds = true
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 40)
    }
}

//MARK: - Filterering delegate methods

extension MainViewController: FilterToItemDelegate {
    
    func didUpdate(with isOn: Bool) {
        isShowingCompleted = isOn
        ItemManager.shared.fetchItems(section: selectedSection!, isShowingCompleted: isShowingCompleted)
    }
}

//MARK: - Setup view and constraints methods

extension MainViewController{
    
    func setupViews(){
        view.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(sectionCollectionView)
        contentView.addSubview(itemsTableView)
        view.addSubview(addItemButton)
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
        sectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        itemsTableView.snp.makeConstraints { make in
            make.top.equalTo(sectionCollectionView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addItemButton.snp.top)
        }
        addItemButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}

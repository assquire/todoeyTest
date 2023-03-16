//
//  ItemViewController.swift
//  Todoey
//
//  Created by Yerzhan Syzdyk on 01.03.2023.
//

import UIKit

final class SectionViewController: UIViewController {
    
    private var sections = [TodoeySection]()
    
    private lazy var contentView = UIView()
    
    private lazy var sectionTableView : UITableView = {
        let myTableView = UITableView()
        myTableView.register(DataTableViewCell.self, forCellReuseIdentifier: DataTableViewCell.IDENTIFIER)
        return myTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SectionManager.shared.delegate = self
        SectionManager.shared.fetchSections()
        
        view.backgroundColor = .systemBackground
        configureNavBar()
        
        sectionTableView.delegate = self
        sectionTableView.dataSource = self
        
        setupViews()
        setupConstraints()
    }
}

//MARK: SectionManger delegate methods

extension SectionViewController: SectionManagerDelegate {
    
    func didUpdate(with models: [TodoeySection]) {
        self.sections = models
        
        DispatchQueue.main.async {
            self.sectionTableView.reloadData()
        }
    }
}

//MARK: - Private methods

private extension SectionViewController {
    
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

extension SectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.IDENTIFIER) as! DataTableViewCell
//        cell.configure(with: sections[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - Table view delegate methods

extension SectionViewController: UITableViewDelegate {
    
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
        let viewController = ItemViewController()
        
        viewController.configure(with: sections[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
}


//MARK: - Section Headin

private extension SectionViewController{
    
    func setupViews(){
        view.addSubview(contentView)
        contentView.addSubview(sectionTableView)
    }
    
    func setupConstraints(){
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        sectionTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

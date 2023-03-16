//
//  ItemTableViewCell.swift
//  Todoey
//
//  Created by Yerzhan Syzdyk on 01.03.2023.
//

import UIKit

final class DataTableViewCell: UITableViewCell {
    
    static let IDENTIFIER = "itemTableViewCell"
    
    private lazy var labelView = UIView()
    
    private lazy var nameLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Section"
        myLabel.font = UIFont.systemFont(ofSize: 25)
        myLabel.numberOfLines = 0
        return myLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Date"
        myLabel.font = UIFont.systemFont(ofSize: 15)
        myLabel.textColor = .systemGray3
        return myLabel
    }()
    
    private lazy var priorityView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: TodoeyItem){
        DispatchQueue.main.async {
            self.nameLabel.text = item.name
            self.dateLabel.text = Date.toString(from: item.createdAt!)
            switch item.priority {
            case 1: self.priorityView.backgroundColor = .systemRed
            case 2: self.priorityView.backgroundColor = .systemYellow
            default: self.priorityView.backgroundColor = .systemGreen
            }
        }
    }
}


//MARK: - Setup views and constraints methods

extension DataTableViewCell {
    
    func setupViews() {
        contentView.addSubview(labelView)
        labelView.addSubview(nameLabel)
        labelView.addSubview(dateLabel)
        contentView.addSubview(priorityView)
    }
    
    func setupConstraints(){
        labelView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        priorityView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(labelView.snp.trailing)
        }
    }
}

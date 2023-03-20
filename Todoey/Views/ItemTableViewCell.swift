//
//  ItemTableViewCell.swift
//  Todoey
//
//  Created by Yerzhan Syzdyk on 01.03.2023.
//

import UIKit

final class ItemTableViewCell: UITableViewCell {
    
    static let IDENTIFIER = "itemTableViewCell"
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var priorityView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        let colorList: [UIColor] = [.red, .green, .gray, .yellow]
        imageView.tintColor = colorList.randomElement()
        return imageView
    }()
    
    private lazy var labelView = UIView()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Project daily stand-up"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "At the conference center"
        label.font = UIFont.systemFont(ofSize: 12.5)
        label.numberOfLines = 0
        label.textColor = .systemGray2
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "9:00 am"
        label.font = UIFont.systemFont(ofSize: 12.5)
        label.textColor = .systemGray2
        label.textAlignment = .right
        return label
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

    }
}


//MARK: - Setup views and constraints methods

extension ItemTableViewCell {
    
    func setupViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(labelView)
        labelView.addSubview(nameLabel)
        labelView.addSubview(descLabel)
        cellView.addSubview(dateLabel)
        cellView.addSubview(priorityView)
    }
    
    func setupConstraints(){
        cellView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        priorityView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(15)
            make.centerY.equalTo(nameLabel)
        }
        labelView.snp.makeConstraints { make in
            make.leading.equalTo(priorityView.snp.trailing).offset(20)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.675)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(descLabel.snp.top).offset(-15)
        }
        descLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(25)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(labelView.snp.trailing)
            make.centerY.equalTo(nameLabel)
        }
    }
}

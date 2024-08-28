//
//  CategoryTableViewCell.swift
//  MyChucknorrisQuotes
//
//  Created by eva on 27.08.2024.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Subview
    
    private lazy var catText: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()

    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .default,
            reuseIdentifier: reuseIdentifier
        )
        
        contentView.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        contentView.addSubview(catText)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate( [
            catText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            catText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            catText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0)
        ])
    }
    
    // MARK: - Public
    
//    func setup(title: String, type: CellType) {
//        pathLabel.text = title
//
//        switch type {
//        case .file:
//            print("is file")
//
//        case .folder:
//            print("is folder")
//
//            accessoryType = .disclosureIndicator
//        }
//    }
    
    func setup(text: String) {
        catText.text = text
        
    }
}


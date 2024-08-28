//
//  CategoriesViewController.swift
//  MyChucknorrisQuotes
//
//  Created by eva on 27.08.2024.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // MARK: - Data
    
    var realmStore: RealmStore
    
    private enum TableViewCellReuseID: String {
        case main = "CatCellReuseID_ReuseID"
    }
    
    //MARK: Subviews
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    init(realmStore: RealmStore) {
        self.realmStore = realmStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        addSubviews()
        setupConstraints()
        
        tuneTableView()

    }

    // MARK: - Private
    
    private func tuneTableView() {
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        
        tableView.register(
            CategoryTableViewCell.self,
            forCellReuseIdentifier: TableViewCellReuseID.main.rawValue
        )
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate( [
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCellReuseID.main.rawValue,
            for: indexPath
        ) as? CategoryTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        let categories = realmStore.fetchCategories()
        cell.setup(text: categories[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categories = realmStore.fetchCategories()
        return categories.count
    }
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categories = realmStore.fetchCategories()
        
        let realmStore = RealmStore()
        let quotesViewController = QuotesViewController(realmStore: realmStore, category: categories[indexPath.row])
        navigationController?.pushViewController(quotesViewController, animated: true)
    }
}

extension CategoriesViewController: TableViewViewControllerDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

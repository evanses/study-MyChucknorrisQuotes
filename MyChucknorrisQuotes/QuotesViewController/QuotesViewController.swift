//
//  QuotesViewController.swift
//  MyChucknorrisQuotes
//
//  Created by eva on 27.08.2024.
//

import UIKit

protocol TableViewViewControllerDelegate {
    func reloadTableView()
}

class QuotesViewController: UIViewController {
    
    // MARK: - Data
    
    var realmStore: RealmStore
    var currentCategory: String? = nil
    
    private enum TableViewCellReuseID: String {
        case main = "QuoteCellReuseID_ReuseID"
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
    
    init(realmStore: RealmStore, category: String) {
        self.realmStore = realmStore
        self.currentCategory = category
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
            QuoteTableViewCell.self,
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

extension QuotesViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCellReuseID.main.rawValue,
            for: indexPath
        ) as? QuoteTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        if let currentCategory = self.currentCategory {
            var quotes = realmStore.fetchQuotesByCategory(category: currentCategory)
            quotes.sort {
                $0.cDate > $1.cDate
            }
            
            cell.setup(text: quotes[indexPath.row].value)
        } else {
            
            var quotes = realmStore.fetchQuotes()
            quotes.sort {
                $0.cDate > $1.cDate
            }
            
            cell.setup(text: quotes[indexPath.row].value)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentCategory = self.currentCategory {
            return realmStore.fetchQuotesByCategory(category: currentCategory).count
        }
        
        return realmStore.fetchQuotes().count
    }
}

// MARK: - UITableViewDelegate

extension QuotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentCategory = self.currentCategory {
            var quotes = realmStore.fetchQuotesByCategory(category: currentCategory)
            quotes.sort {
                $0.cDate > $1.cDate
            }

            AlertView.alert.show(in: self, text: quotes[indexPath.row].value)
        } else {
            var quotes = realmStore.fetchQuotes()
            quotes.sort {
                $0.cDate > $1.cDate
            }
            
            AlertView.alert.show(in: self, text: quotes[indexPath.row].value)
        }
    }
}

// MARK: - QuotesViewControllerDelegate

extension QuotesViewController: TableViewViewControllerDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

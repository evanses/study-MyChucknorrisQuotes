//
//  NewQuoteViewController.swift
//  MyChucknorrisQuotes
//
//  Created by eva on 27.08.2024.
//

import UIKit

class NewQuoteViewController: UIViewController {
    
    // MARK: Data
    
    var model: NewQuoteViewModel
    var quotesDelegate: TableViewViewControllerDelegate?
    var categoriesDelegate: TableViewViewControllerDelegate?
    
    //MARK: Subviews
    
    private lazy var getNewQuoteButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .systemBlue
        button.setTitle("Получить новую цитату", for: .normal)
        
        button.setTitleColor(.white, for: .normal)
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(model: NewQuoteViewModel) {
        self.model = model
        
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
        
        setupActions()
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        view.addSubview(getNewQuoteButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate( [
            getNewQuoteButton.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 120.0),
            getNewQuoteButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            getNewQuoteButton.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor, constant: -90)
        ])
    }
    
    private func setupActions() {
        getNewQuoteButton.addTarget(self, action: #selector(getNewQuote(_:)), for: .touchUpInside)
    }
    
    // MARK: Actions
    
    @objc func getNewQuote(_ sender: UIButton) {
        model.fetchRandomQuote() { result in
            AlertView.alert.show(in: self, text: result)
            
            self.quotesDelegate?.reloadTableView()
            self.categoriesDelegate?.reloadTableView()
        }
    }
    
}


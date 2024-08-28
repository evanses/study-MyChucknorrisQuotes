//
//  NewQuoteViewController.swift
//  MyChucknorrisQuotes
//
//  Created by eva on 27.08.2024.
//

import UIKit

class NewQuoteViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupConstraints()
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
        getNewQuoteButton.addTarget(self, action: #selector(sumbitPassword(_:)), for: .touchUpInside)
    }
    
    // MARK: Actions
    
    @objc func sumbitPassword(_ sender: UIButton) {
        print("new quote")
    }
    
}


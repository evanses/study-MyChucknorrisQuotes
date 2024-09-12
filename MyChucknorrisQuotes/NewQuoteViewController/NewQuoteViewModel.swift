//
//  ViewMoNewQuoteViewModeldel.swift
//  MyChucknorrisQuotes
//
//  Created by eva on 28.08.2024.
//

import Foundation

final class NewQuoteViewModel {
    private var networkManager = NetworkManager.shared
    
    func fetchRandomQuote(completion: @escaping ((String) -> Void)) {
        networkManager.getQuote { result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let randomQuote):
                    
                    print(randomQuote)
                    
                    let realmStore = RealmStore()
                    
                    let quotes = realmStore.fetchQuotes()
                    
                    var quotesValues: [String] = []
                    quotes.forEach { q in
                        quotesValues.append(q.value)
                    }
                    
                    if !quotesValues.contains(randomQuote.value) {
                        realmStore.insertQuote(quote: randomQuote)
                        
                        completion("Цитата получена и сохранена")
                    } else {
                        completion("Полученная цитата уже есть в базе!")
                    }
                    
                                        
                case .failure(let error):
                    completion("Ошибка: \(error)")
                }
            }
        }
    }
}

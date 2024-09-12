//
//  RealmStore.swift
//  MyChucknorrisQuotes
//
//  Created by eva on 28.08.2024.
//

import Foundation
import RealmSwift

class QuoteRealm: Object {
    @Persisted var value = ""
    @Persisted var category = "none"
    @Persisted var cDate = Date()
}

final class RealmStore {
    var quotes: [QuoteRealm] = []
    
    init() {
        
    }
    
    func insertQuote(quote: Quote) {
        let realm = try! Realm()
        let newQuote = QuoteRealm()
        
        
        newQuote.value = quote.value
        
        if quote.categories.count > 0 {
            newQuote.category = quote.categories.first!
        }
        
        try? realm.write {
            realm.add(newQuote)
        }
        
    }
    
    func fetchQuotes() -> [QuoteRealm] {
        let realm = try! Realm()
        return realm.objects(QuoteRealm.self).map { $0 }
    }
    
    func fetchQuotesByCategory(category: String) -> [QuoteRealm] {
        let realm = try! Realm()
        return realm.objects(QuoteRealm.self).filter("category == %@", category).map { $0 }
    }
    
    func fetchCategories() -> [String] {
        let quotes = fetchQuotes()
        var categories: [String] = []
        
        quotes.forEach { quote in
            if !categories.contains(quote.category) {
                categories.append(quote.category)
            }
        }
        return categories
    }
}

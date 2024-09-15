//
//  RealmStore.swift
//  MyChucknorrisQuotes
//
//  Created by eva on 28.08.2024.
//

import Foundation
import RealmSwift
import KeychainAccess

class QuoteRealm: Object {
    @Persisted var value = ""
    @Persisted var category = "none"
    @Persisted var cDate = Date()
}

final class RealmStore {
    var quotes: [QuoteRealm] = []
    
    private var keychainName: String {
        return "ru.eva.llee.MyChucknorrisQuotes"
    }

    
    init() {
    }
    
    func setNewSecretKey() {
        let keychain = Keychain(service: keychainName)
        
        var k = Data(count: 64)
        
        _ = k.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in
            SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
        }
        
        try? keychain.set(k, key: "realmKey")
    }
    
    func getSecretKey() -> Data {
        let keychain = Keychain(service: keychainName)

        var key = try? keychain.getData("realmKey")
        
        if key == nil {
            setNewSecretKey()
            key = try? keychain.getData("realmKey")
            if let key = key {
                return key
            }
            
        }
        
        return key!
    }
    
    func realmConnector() -> Realm {
        let key = getSecretKey()
        
        let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let encryptedPath = "\(documentDirectory)/default_enc.realm"
        
        let isEncryptedRealmExsist = fileManager.fileExists(atPath: encryptedPath)
        
        if !isEncryptedRealmExsist {
            let realm = try! Realm()
            try? realm.writeCopy(toFile: URL(fileURLWithPath: encryptedPath), encryptionKey: key)
        }
        
        let config = Realm.Configuration(fileURL: URL(fileURLWithPath: encryptedPath), encryptionKey: key)
        let realm = try? Realm(configuration: config)
        
        return realm!
    }
    
    func insertQuote(quote: Quote) {
        let realm = realmConnector()
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
        let realm = realmConnector()
        return realm.objects(QuoteRealm.self).map { $0 }
    }
    
    func fetchQuotesByCategory(category: String) -> [QuoteRealm] {
        let realm = realmConnector()
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

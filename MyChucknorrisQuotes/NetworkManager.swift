//
//  NetworkManager.swift
//  MyChucknorrisQuotes
//
//  Created by eva on 28.08.2024.
//

import Foundation

enum AppConfiguration: String {
    case qoute = "https://api.chucknorris.io/jokes/random"
}

enum NetworkError: Error {
    case noData
    case parsingError
    case notInternet
    case responseError
    case smthWentWrong
    
    var description: String {
        switch self {
        case .noData:
            return "Нет данных"
        case .parsingError:
            return "Ошиюка парсинга данных"
        case .notInternet:
            return "Нет интернета"
        case .responseError:
            return "Неверный ответ сервера"
        case .smthWentWrong:
            return "Что-то пошло не так"
        }
    }
}

struct Quote: Codable {
    let date: Date
    let value: String
    let categories: [String]
    
    private enum CodingKeys: String, CodingKey {
        case value, categories
        case date = "created_at"
    }
}

//struct QuoteCategory: Codable {
//    let title: [String]
//    
//    private enum CodingKeys: String, CodingKey {
//        case title = self
//    }
//}

/*
 {
     "categories": [
         "religion"
     ],
     "created_at": "2020-01-05 13:42:19.104863",
                    2019-10-21 09:15:00 +0000
     "icon_url": "https://api.chucknorris.io/img/avatar/chuck-norris.png",
     "id": "ak7chtuzqy2u7tzc6z1b3q",
     "updated_at": "2020-01-05 13:42:19.104863",
     "url": "https://api.chucknorris.io/jokes/ak7chtuzqy2u7tzc6z1b3q",
     "value": "It's widely believed that Jesus was Chuck Norris' stunt double for crucifixion due to the fact that it is impossible for nails to pierce Chuck Norris' skin."
 }
*/

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getQuote(completion: @escaping ((Result<Quote, NetworkError>) -> Void)) {
        guard let url = URL(string: AppConfiguration.qoute.rawValue) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
        
            if let error {
                completion(.failure(.notInternet))
                print(error.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let quote = try decoder.decode(Quote.self, from: data)
                
                completion(.success(quote))
                
            } catch (let error) {
                print(error)
                
                completion(.failure(.parsingError))
            }
            
        }.resume()
        
    }
}

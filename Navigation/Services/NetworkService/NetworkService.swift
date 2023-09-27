//
//  NetworkService.swift
//  Navigation
//
//  Created by Алексей Голованов on 27.09.2023.
//

import Foundation

enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people/5"
    case starships = "https://swapi.dev/api/starships/3"
    case films = "https://swapi.dev/api/films/1"
    
    var url: URL? {
        URL(string: self.rawValue)
    }
}

struct NetworkService {
    
    static func request(for configuration: AppConfiguration) {
        let session = URLSession.shared
        let sessionDataTask = session.dataTask(with: configuration.url!) { data, response, error in
            if let error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            if  let httpResponse = response as? HTTPURLResponse {
                print("Свойство allHeaderFields: \(httpResponse.allHeaderFields)")
                print("Свойство statusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 { return }
            }
            
            guard let data else {
                print("Нет данных!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("JSON-данные получены: \(json)")
            } catch {
                print("Ошибка обработки JSON: \(error.localizedDescription)")
            }
            
        }
        sessionDataTask.resume()
    }
}

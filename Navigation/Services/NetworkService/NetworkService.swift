//
//  NetworkService.swift
//  Navigation
//
//  Created by Алексей Голованов on 27.09.2023.
//

import Foundation

enum AppConfiguration {
    case people(URL)
    case starships(URL)
    case films(URL)
}

struct NetworkService {
    
    
    init(appConfiguration: AppConfiguration) {
        NetworkService.request(for: appConfiguration)
    }
    
    static func request(for configuration: AppConfiguration) {
        var rawValue: URL
        switch configuration {
        case .people(let uRL):
            rawValue = uRL
        case .starships(let uRL):
            rawValue = uRL
        case .films(let uRL):
            rawValue = uRL
        }
        
        let session = URLSession.shared
        let sessionDataTask = session.dataTask(with: rawValue) { data, response, error in
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

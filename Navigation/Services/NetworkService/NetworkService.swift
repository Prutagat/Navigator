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

struct DecodingPlanet: Decodable {
    let name: String
    let orbitalPeriod: String
    let rotationPeriod: String
    let residents: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case orbitalPeriod = "orbital_period"
        case rotationPeriod = "rotation_period"
        case residents
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
    
    static func requestUser(id: Int, completion: @escaping (_ title: String) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(id)")!
        let session = URLSession.shared
        let sessionDataTask = session.dataTask(with: url) { data, response, error in
            if let error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            if  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 { return }
            
            guard let data else {
                print("Нет данных!")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = jsonData as? [String: Any] {
                    DispatchQueue.main.async { completion(dictionary["title"] as! String) }
                }
            } catch {
                print("Ошибка обработки JSON: \(error.localizedDescription)")
            }
            
        }
        sessionDataTask.resume()
    }
    
    static func requestPlanet(id: Int, completion: @escaping (_ planet: DecodingPlanet) -> Void) {
        let url = URL(string: "https://swapi.dev/api/planets/\(id)")!
        let session = URLSession.shared
        let sessionDataTask = session.dataTask(with: url) { data, response, error in
            if let error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            if  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 { return }
            
            guard let data else {
                print("Нет данных!")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let planet = try decoder.decode(DecodingPlanet.self, from: data)
                DispatchQueue.main.async { completion(planet) }
            } catch {
                print("Ошибка обработки JSON: \(error.localizedDescription)")
            }
            
        }
        sessionDataTask.resume()
    }
    
    static func requestResident(url: String, completion: @escaping (_ name: String) -> Void) {
        let url = URL(string: url)!
        let session = URLSession.shared
        let sessionDataTask = session.dataTask(with: url) { data, response, error in
            if let error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            if  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 { return }
            
            guard let data else {
                print("Нет данных!")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = jsonData as? [String: Any] {
                    DispatchQueue.main.async { completion(dictionary["name"] as! String) }
                }
            } catch {
                print("Ошибка обработки JSON: \(error.localizedDescription)")
            }
        }
        sessionDataTask.resume()
    }
}

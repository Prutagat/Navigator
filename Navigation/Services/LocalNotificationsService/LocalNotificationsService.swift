//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Алексей Голованов on 07.04.2024.
//

import UIKit
import UserNotifications

final class LocalNotificationsService {
    
    static let shared = LocalNotificationsService()
    
    private let currentUserNotificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization(completion: @escaping (Result<Bool, NSError>) -> Void) {
        currentUserNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { isSuccess, error in
            if let error {
                completion(.failure(error as NSError))
            }
            completion(.success(isSuccess))
        }
    }
    
    func authorized(completion: @escaping (Bool) -> Void) {
        currentUserNotificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                completion(false)
            case .denied:
                completion(false)
            case .authorized:
                completion(true)
            case .provisional:
                completion(true)
            case .ephemeral:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
    }
    
    func addCalendarNotification(id: String, text: String) {
        
        let content = UNMutableNotificationContent()
        content.body = text
        
        var dateMatching = DateComponents()
        dateMatching.hour = 19
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        currentUserNotificationCenter.add(request)
    }
    
    func addTimeIntervalNotification(id: String, text: String, date: Date?) {
        guard let date else { return }
        
        if date.timeIntervalSinceNow < 0 {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.body = text
        
        var dateMatching = DateComponents()
        dateMatching.hour = 19
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        currentUserNotificationCenter.add(request)
    }
    
    func removeAllDeliveredNotifications() {
        currentUserNotificationCenter.removeAllDeliveredNotifications()
    }
}

extension LocalNotificationsService: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

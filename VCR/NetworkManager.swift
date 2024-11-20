//
//  NetworkManager.swift
//  VCR
//
//  Created by Faysal Mahmud on 20/11/24.
//

import Foundation

class NetworkManager: ObservableObject {
    @Published var notices: [Notice] = []
    @Published var ctAnnouncements: [CTAnnouncement] = []
    
    private let baseURL = "https://api.34.29.68.223.nip.io"
    
    func fetchNotices() {
        guard let url = URL(string: "\(baseURL)/api/notices") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decoded = try? JSONDecoder().decode([Notice].self, from: data) {
                    DispatchQueue.main.async {
                        self.notices = decoded
                    }
                    return
                }
            }
            // Handle error appropriately in production
            print("Failed to fetch notices")
        }.resume()
    }
    
    func fetchCTAnnouncements() {
        guard let url = URL(string: "\(baseURL)/api/ct-announcements") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decoded = try? JSONDecoder().decode([CTAnnouncement].self, from: data) {
                    DispatchQueue.main.async {
                        self.ctAnnouncements = decoded
                    }
                    return
                }
            }
            // Handle error appropriately in production
            print("Failed to fetch CT Announcements")
        }.resume()
    }
    
    func addNotice(date: String, day: String, time: String, noticeText: String, pass: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/add-notice") else { return }
        
        let body: [String: Any] = [
            "date": date,
            "day": day,
            "time": time,
            "notice": noticeText,
            "pass": pass
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let resp = try? JSONDecoder().decode(ResponseStatus.self, from: data) {
                    DispatchQueue.main.async {
                        completion(resp.status == "success")
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                completion(false)
            }
        }.resume()
    }
    
    func addCTAnnouncement(date: String, day: String, time: String, place: String, course_id: Int, topic: String, teacher_id: Int, pass: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/add-ct-announcement") else { return }
        
        let body: [String: Any] = [
            "date": date,
            "day": day,
            "time": time,
            "place": place,
            "course_id": course_id,
            "topic": topic,
            "teacher_id": teacher_id,
            "pass": pass
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let resp = try? JSONDecoder().decode(ResponseStatus.self, from: data) {
                    DispatchQueue.main.async {
                        completion(resp.status == "success")
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                completion(false)
            }
        }.resume()
    }
}

struct ResponseStatus: Codable {
    let status: String
}

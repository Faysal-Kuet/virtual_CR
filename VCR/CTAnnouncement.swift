//
//  CTAnnouncement.swift
//  VCR
//
//  Created by Faysal Mahmud on 20/11/24.
//

import Foundation

struct CTAnnouncement: Identifiable, Codable {
    let id: Int
    let date: String
    let day: String
    let time: String
    let place: String
    let course_id: Int
    let topic: String
    let teacher_id: Int
    let course: String
    let teacher: String
}

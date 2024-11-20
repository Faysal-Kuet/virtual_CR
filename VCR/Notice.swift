//
//  Notice.swift
//  VCR
//
//  Created by Faysal Mahmud on 20/11/24.
//

import Foundation

struct Notice: Identifiable, Codable {
    let id: Int
    let date: String
    let day: String
    let time: String
    let notice: String
}

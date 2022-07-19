//
//  Apod.swift
//  apod
//
//  Created by vivek on 16/07/22.
//

import Foundation
import CoreData

struct Apods: Codable {
    let apods: [Apod]
}

struct Apod: Codable {
    var copyright: String?
    var date: String?
    var explanation: String?
    var hdurl: String?
    var media_type: String?
    var service_version: String?
    var title: String?
    var url: String?
}


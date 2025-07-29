//
//  Review.swift
//  CheckEat-User
//
//  Created by Hee  on 7/27/25.
//
import Foundation

struct Review: Identifiable, Codable {
    var id: Int { food_id }
    let food_id: Int
    let revi_img: String?
    let revi_content: String
    let revi_reco_step: Int
}

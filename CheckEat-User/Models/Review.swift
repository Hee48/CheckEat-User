//
//  Review.swift
//  CheckEat-User
//

import Foundation

struct Review: Decodable, Identifiable {
    let revi_id: Int
    let food_id: Int
    let revi_img: String?
    let revi_content: String?
    let revi_reco_step: Int

    var id: Int { revi_id }
}

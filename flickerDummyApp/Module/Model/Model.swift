//
//  Model.swift
//  flickerDummyApp
//
//  Created by vandana mishra on 25/03/25.
//

struct Photo: Codable {
    let id: String
    let urls: PhotoURLs
}

struct PhotoURLs: Codable {
    let regular: String
}

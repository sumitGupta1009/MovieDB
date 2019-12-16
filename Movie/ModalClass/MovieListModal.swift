//
//  MovieListModal.swift
//  Movie
//
//  Created by Webwerks1 on 12/16/19.
//  Copyright © 2019 Webwerks1. All rights reserved.
//

import Foundation

struct MovieList : Codable, Hashable {
    let popularity : Double?
    let vote_count : Int?
    let poster_path : String?
    let id : Int64?
    let adult : Bool?
    let backdrop_path : String?
    let original_language : String?
    let title : String?
    let vote_average : Double?
    let overview : String?
    let release_date : String?
}

class apiResultModal : Codable{
    let page : Int?
    let total_results : Int?
    let total_pages : Int?
    let results : [MovieList]?
}

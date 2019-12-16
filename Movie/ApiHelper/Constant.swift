//
//  Constant.swift
//  Movie
//
//  Created by Webwerks1 on 12/13/19.
//  Copyright © 2019 Webwerks1. All rights reserved.
//

import Foundation

class ServiceApiPath {
    
    static let shared = ServiceApiPath()
     let baseUrl = "https://api.themoviedb.org/3"
     let popularMovie = "/movie/popular?api_key=b2c1941945e52bc3ddec31405535305e&language=en-US&page="
    let imageUrl = "https://image.tmdb.org/t/p/w500"
     let highestRated = "/movie/top_rated?api_key=b2c1941945e52bc3ddec31405535305e&language=en-US&page="
    let searchMovie = "/search/movie?api_key=b2c1941945e52bc3ddec31405535305e&language=en-US&query="
let empty = ""
}

//
//  MoviePosterCell.swift
//  Movie
//
//  Created by Webwerks1 on 12/13/19.
//  Copyright © 2019 Webwerks1. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviePosterCell: UICollectionViewCell {
    @IBOutlet weak var lbl_movieName: UILabel!
    @IBOutlet weak var img_movieBanner: UIImageView!
    override func awakeFromNib() {
        
    }
    
    func setAllData(movieList : MovieList){
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        
        self.img_movieBanner.image = UIImage.init(named: "search")
        self.lbl_movieName.text = movieList.title
        
        let imgPath = ServiceApiPath.shared.imageUrl + (movieList.poster_path ?? "")
        let placeHolderImage = UIImage(named: "search")

        if let url = URL(string: imgPath){
            self.img_movieBanner.af_setImage(withURL: url, placeholderImage: placeHolderImage)
        }else{
            self.img_movieBanner.image = placeHolderImage
        }
    }
}


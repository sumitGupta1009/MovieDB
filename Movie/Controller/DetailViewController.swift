//
//  DetailViewController.swift
//  Movie
//
//  Created by Webwerks1 on 12/16/19.
//  Copyright © 2019 Webwerks1. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {

    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var txtVDetail: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var imgPoster: UIImageView!
    var movieList : MovieList?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        // Do any additional setup after loading the view.
    }

    func setUpData(){
        let imgPath = ServiceApiPath.shared.imageUrl + (movieList?.poster_path ?? "")
        let placeHolderImage = UIImage(named: "search")
        
        if let url = URL(string: imgPath){
            self.imgPoster.af_setImage(withURL: url, placeholderImage: placeHolderImage)
        }else{
            self.imgPoster.image = placeHolderImage
        }
        
        self.lblTitle.text = movieList?.title
        self.txtVDetail.text = movieList?.overview
        let rate = (movieList?.vote_average)! * 10
        self.lblRating.text = "\(rate)%"
    let dt = movieList?.release_date?.getConvertedDate(fromFormat: "yyyy-MM-dd", toFormat: "MMM dd, yyyy")
        self.lblReleaseDate.text = dt
        
    }
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension String{
    func getConvertedDate(fromFormat : String, toFormat : String) -> String{
        let df = DateFormatter()
        df.dateFormat = fromFormat
        let date = df.date(from: self)
        df.dateFormat = toFormat
        return df.string(from: date!)
    }
}

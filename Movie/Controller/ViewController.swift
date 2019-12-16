//
//  ViewController.swift
//  Movie
//
//  Created by Webwerks1 on 12/13/19.
//  Copyright © 2019 Webwerks1. All rights reserved.
//

import UIKit
import DropDown

class ViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerView: CustomHeader!
    @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var view_filter: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var view_filterOption: UIView!
    @IBOutlet weak var lbl_filterName: UILabel!
    
    var movieModal = [MovieList]()
    var arrSearchModal = [MovieList]()
    var arrFilterModal = [MovieList]()

    let dropDown = DropDown()

    
    let cellID = "MoviePosterCell"
    var isSearch = false
    var isFilter = false
    var pageNumber = 1
    var searchPageNumber = 1
    var filterPageNumber = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setUI()
        configureHeader()
        configureCollectionView()
        callApi()
    }

    func setUI(){
        lbl_filterName.text = "Popular Movies"
        view_filterOption.layer.cornerRadius = 5.0
        view_filterOption.layer.masksToBounds = false
        view_filterOption.layer.borderWidth = 2
        view_filterOption.layer.borderColor = UIColor.white.cgColor
        dropDown.anchorView = view
        dropDown.dataSource = ["Popular Movies", "Highest Rated Movies"]
        dropDown.dismissMode = .onTap
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: view_filter.frame.height + headerView.bounds.height + 20)
 DropDown.startListeningToKeyboard()

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbl_filterName.text = item
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            self.isFilter = (index == 1) ? true : false

            self.callApi()
        }
    }
    
    @IBAction func btn_droDownClick(_ sender: Any) {
        dropDown.show()
    }
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func configureHeader(){
        headerView.delegate = self
        headerView.lbl_title.text = "Movies"
        headerView.lbl_title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        headerView.contentView.backgroundColor = #colorLiteral(red: 0.9070718884, green: 0.1097492203, blue: 0.1032067314, alpha: 1)
        
        headerView.btnRight.setImage(#imageLiteral(resourceName: "setting"), for: .normal)
        headerView.btnRight.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    func removeDuplicateModal(values: [MovieList]) -> [MovieList] {
        let uniques = Array(Set(values))
        return uniques
    }
}


extension ViewController{
    
    
    
    
}

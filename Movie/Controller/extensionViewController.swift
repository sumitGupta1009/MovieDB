//
//  extensionViewController.swift
//  Movie
//
//  Created by Webwerks1 on 12/16/19.
//  Copyright © 2019 Webwerks1. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    //MARK: support method
    func flipView() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromBottom, .showHideTransitionViews]
        
        UIView.transition(with: searchBar, duration: 0.3, options: transitionOptions, animations: {
        }) { (comp) in
            self.searchBar.isHidden = !self.searchBar.isHidden
        }
        
        UIView.transition(with: view_filter, duration: 0.3, options: transitionOptions, animations: {
        }) { (comp) in
            self.view_filter.isHidden = !self.view_filter.isHidden
        }
    }
    
    func showIndicator(){
        self.viewActivity.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopIndicator(){
        self.viewActivity.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    //Mark : ApiCall
    func callApi(){
        showIndicator()
        let webSerManager = WebServiceManager()
        webSerManager.requestAPI(serviceEndpoint: (!isFilter) ? EndpointItem.PopularMovie(pageNumber: "\(pageNumber)") : EndpointItem.HighestRated(pageNumber: "\(pageNumber)"), parameters: nil, objectType: apiResultModal.self, isHud: false, controller: self, success: { (apiResModal) in
            let modal = apiResModal.results
            if let movieMo = modal{
                if !self.isFilter{
                    if self.movieModal.count == 0{
                        self.movieModal = movieMo
                    }else{
                        self.movieModal.append(contentsOf: movieMo)
                    }
                }else{
                    if self.arrFilterModal.count == 0{
                        self.arrFilterModal = movieMo
                    }else{
                        self.arrFilterModal.append(contentsOf: movieMo)
                    }
                }
                DispatchQueue.main.async {
                    self.stopIndicator()
                    self.collectionView.reloadData()
                }
            }
            
        }) { (err) in
            print(err.errorMessage)
        }
    }
}

extension ViewController : CustomHeaderDelegate{
    //MARK: headerDelegate
    func onHeaderLeftBtnClick() {
    }
    
    func onHeaderRightBtnClick() {
        self.collectionView.setContentOffset(self.collectionView.contentOffset, animated: true)
        if searchBar.isHidden{
            headerView.btnRight.setImage(#imageLiteral(resourceName: "funnel"), for: .normal)
            dropDown.hide()
        }else{
            searchBar.text = ""
            headerView.btnRight.setImage(#imageLiteral(resourceName: "search"), for: .normal)
            isSearch = false
            searchPageNumber = 1
            isFilter = false
        }
        flipView()
    }
    
}

extension ViewController : UISearchBarDelegate{
    //MARK: UISearchbar delegate
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
        searchPageNumber = 1

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = false;
        searchPageNumber = 1

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
        searchPageNumber = 1

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
        searchPageNumber = 1

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            isSearch = false;
            searchPageNumber = 1
            self.collectionView.reloadData()
        } else if(searchText.count >= 2){
            fetchSearchApi(searchText: searchText)
        }
    }
    
    func fetchSearchApi(searchText : String){
        showIndicator()
        let webSerManager = WebServiceManager()
        webSerManager.requestAPI(serviceEndpoint: EndpointItem.SearchMovie(searchText: searchText, pageNumber: "\(searchPageNumber)"), parameters: nil, objectType: apiResultModal.self, isHud: false, controller: self, success: { (apiResModal) in
            let modal = apiResModal.results
            if let movieMo = modal{
                self.arrSearchModal = movieMo
                
                DispatchQueue.main.async {
                    self.isSearch = true;
                    self.stopIndicator()
                    self.collectionView.reloadData()
                }
            }
        }) { (err) in
            print(err.errorMessage)
        }
    }
}


extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    //MARK:  CollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isSearch && !isFilter{
            return movieModal.count
        }else if isSearch{
            return arrSearchModal.count
        }else{
            return arrFilterModal.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MoviePosterCell
        let modal = (!isSearch && !isFilter) ? movieModal[indexPath.row] : (isSearch) ? arrSearchModal[indexPath.row] : arrFilterModal[indexPath.row]
        cell.setAllData(movieList: modal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.movieList = movieModal[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height;
        let scrollContentSizeHeight = scrollView.contentSize.height;
        let scrollOffset = scrollView.contentOffset.y;
        
        if (scrollOffset + scrollViewHeight > (scrollContentSizeHeight * 0.80))
        {
            if !isSearch && !isFilter{
                pageNumber = pageNumber + 1
                searchPageNumber = 1
                filterPageNumber = 1
            }else if isSearch{
                searchPageNumber = searchPageNumber + 1
            }else if isFilter{
                filterPageNumber = filterPageNumber + 1
            }
            callApi()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    //MARK: CollectionView Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 2) - 12
        return CGSize(width: width, height: width)
    }
}



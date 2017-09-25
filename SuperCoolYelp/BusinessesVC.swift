//
//  BusinessesVC.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import KRProgressHUD
import CoreLocation

class BusinessesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocation?
    var businesses: [Business]!
    
    var loadingMoreView = UIActivityIndicatorView(activityIndicatorStyle: .gray )
    var isMoreDataLoading = false

    
    var preferences: Preferences = Preferences() {
        didSet {
            updateSearch(searchText: self.searchBar.text)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.delegate = self
        // Heads Up Display
        KRProgressHUD.set(style: .black)
        KRProgressHUD.set(font: .systemFont(ofSize: 15))
        KRProgressHUD.set(activityIndicatorViewStyle: .gradationColor(head: UIColor.YelpColors.Red, tail: UIColor.YelpColors.DarkRed))
        KRProgressHUD.show(withMessage: "Loading results...")
        
        updateSearch(searchText: "food")
        
        // Infinite scrolling indicator
        let tableFooterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        loadingMoreView.center = tableFooterView.center
        tableFooterView.insertSubview(loadingMoreView, at: 0)
        self.tableView.tableFooterView = tableFooterView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
    }

//    =========================================== TableView Methods ===========================================

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as? BusinessCell else {
            return BusinessCell()
        }
        cell.resultNumber = indexPath.row + 1
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil{
            return businesses.count
        } else {
            return 0
        }
        
    }
    
    //    =========================================== Other Methods ===========================================
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            print("startUpdatingLocation")
        }
    }
    
    // Updated location callback
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        print("didUpdateLocations called")
        // TODO: Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation!.coordinate.latitude)")
        print("user longitude = \(userLocation!.coordinate.longitude)")
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearch(searchText: searchBar.text)
        print("search bar search button clicked!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFiltersSegue" {
            // we wrapped our PreferencesTableViewController inside a UINavigationController
            let navController = segue.destination as! UINavigationController
            
            let filtersVC = navController.topViewController as! FiltersVC
            filtersVC.currentPrefs = self.preferences
            print("set filtersVC's prefs")
        }
    }
    
    
    
    
    func updateSearch(searchText: String?){
        let searchTerm = searchText ?? "food"
        let userLocation = self.userLocation ?? CLLocation(latitude: 37.785771, longitude: -122.406165)
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        
        let sort = preferences.getSortByEnum()
        let radius = preferences.getDistanceEnum()
        let categories = preferences.getArrayOfCategories()
        let deals = preferences.getDeals()
        let openNow = preferences.getOpenNow()
        
        KRProgressHUD.show(withMessage: "Loading results...")
        
        Business.searchWithTerm(term: searchTerm, userLocation: (lat, long), sort: sort, radius: radius, openNow: openNow, categories: categories, deals: deals, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            print(businesses ?? "none")
            self.tableView.reloadData()
            KRProgressHUD.showSuccess(withMessage: "Success!")
            
            })
        
        print("IN UPDATE SEARCH")
    }
//         Example of Yelp search with more search options specified
//        Business.searchWithTerm(term: searchTerm, sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
//         self.businesses = businesses
//         
//         for business in businesses {
//         print(business.name!)
//         print(business.address!)
//         }
//         }
 
 
    
    
    @IBAction func didSavePreferences(segue: UIStoryboardSegue) {
        if let prefsVC = segue.source as? FiltersVC {
            self.preferences = prefsVC.preferencesFromTableData()
        }
        
    }
    
    @IBAction func didCancelPreferences(segue: UIStoryboardSegue) {
        print("FILTERS CANCELLED")
    }
    
//    @IBAction func filterButtonClicked(_ sender: Any) {
//        if let filtersVC = storyboard?.instantiateViewController(withIdentifier: "FiltersVC"){
////            filtersVC.modalTransitionStyle = .coverVertical
//            filtersVC.isModalInPopover = true
//            self.navigationController?.pushViewController(filtersVC, animated: true)
//        }
//    }
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                self.loadingMoreView.startAnimating()
                
                if let searchTerm = searchBar.text {
                    Business.searchWithTerm(term: searchTerm, completion: { (businesses: [Business]?, error: Error?) -> Void in
                        
                        self.businesses = businesses
                        self.tableView.reloadData()
                        self.isMoreDataLoading = false
                        self.loadingMoreView.stopAnimating()
                    })
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    
}


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    struct YelpColors {
        static let Red = UIColor(netHex: 0xD32323)
        static let DarkRed = UIColor(netHex: 0xBD1F1F)
    }
}

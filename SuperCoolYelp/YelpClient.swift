//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

import AFNetworking
import BDBOAuth1Manager

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"

// V3
//let accessToken = "ddiiioFlmpKrwZGMsnN9RbJjg_zdQ7hi47vUs3c1-1_aXXEk76EYkxraKPmOAAxxhtKaSdrZV3T4AzBWOz3BmD0R-E7VOP7wyGX22UhETHr07nleZgJ6VShKp0zIWXYx"

enum YelpSortMode: Int {
    case bestMatched = 0, distance, highestRated, mostReviewed
}

enum YelpSearchRadius: Int {
    case bestMatched = 16093 // 10 miles
    case pointThreeMiles = 483
    case oneMile = 1609
    case fiveMiles = 8047
    case twentyMiles = 32187
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    //MARK: Shared Instance
    
    static let sharedInstance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
 //        https://api.yelp.com/v2/search?term=food&location=San+Francisco
        

//        let baseUrl = URL(string: "https://api.yelp.com/v3/businesses/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(_ term: String, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
//        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, completion: completion)
        return searchWithTerm(term, userLocation: nil, sort: nil, radius: nil, openNow: nil, categories: nil, deals: nil, completion: completion)
    }
    
    func searchWithTerm(_ term: String, userLocation: (Double, Double)?, sort: YelpSortMode?, radius: YelpSearchRadius?, openNow: Bool?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v3/search_api
        
        // Default the location to San Francisco
//        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "37.785771,-122.406165" as AnyObject]
        var parameters: [String : AnyObject] = ["term": term as AnyObject]
        
        if userLocation != nil {
            parameters["latitude"] = userLocation!.0 as AnyObject?
            parameters["longitude"] = userLocation!.1 as AnyObject?
        }
        
        if sort != nil {
            parameters["sort_by"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["categories"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil {
            parameters["deals"] = deals! as AnyObject?
        }
        
        if radius != nil {
            parameters["radius"] = radius!.rawValue as AnyObject?
        }
        
        if openNow != nil{
            parameters["open_now"] = openNow! as AnyObject?
        }
        
        print(parameters)
        
        return self.get("search", parameters: parameters,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any]{
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                if dictionaries != nil {
                                    completion(Business.businesses(array: dictionaries!), nil)
                                }
                            }
                        },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                            completion(nil, error)
                        })!
    }
}

//
//  Blockchain_API.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/30/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import Foundation


class BlockchainAPI {
    
    static func blockchainAPI(_ user: String, currentBeacon: String, barrelID: String, eventTime: String, colorHex: String) {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Cache-Control": "no-cache",
            "Postman-Token": "26a0ecef-12e2-1e8b-c0a7-398da5b84130"
        ]
        
        
        
        let postData = NSMutableData(data: "location=\(currentBeacon)".data(using: String.Encoding.utf8)!)
        postData.append("&user=\(user)".data(using: String.Encoding.utf8)!)
        postData.append("&barrelID=\(barrelID)".data(using: String.Encoding.utf8)!)
        postData.append("&eventTime=\(eventTime)".data(using: String.Encoding.utf8)!)
        postData.append("&hexColor=\(colorHex)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://blockchain.appsfight.com/v1.0/the-positive-company/mine-block/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
        })
        print(postData)
        
        dataTask.resume()

    }

}

//
//  ApiCalling.swift
//  Pratice_4_Bandana
//
//  Created by Rakesh Nangunoori on 29/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit

class ApiCalling: NSObject {
    
    static let shared: ApiCalling = {
        let instance = ApiCalling()
        return instance
    }()
    
    func getDetailsFromServer(url:String,compltionHandler:@escaping(_ response:NSDictionary?,_ error:NSError?)-> Void) {
        print(url)
        let finalUrl = URL(string: url)
        let request = URLRequest(url: finalUrl!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (Data, urlResponse, error) in
            if Data == nil{
                print("No data available")
            }else{
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: Data!, options: .mutableContainers)
                    print(jsonResult)
                    compltionHandler(jsonResult as! NSDictionary,nil)
                    
                }catch{
                    compltionHandler(nil,error as NSError)
                }
                
            }
        }
        task.resume()
    }

}

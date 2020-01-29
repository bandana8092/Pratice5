//
//  ViewModel.swift
//  Pratice_4_Bandana
//
//  Created by Rakesh Nangunoori on 29/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit
import Foundation

class ViewModel: NSObject {
    static let shared: ViewModel = {
             let instance = ViewModel()
             return instance
         }()
    var postModel = [PostModel]()
    var totalPages = Int()
    var currentPage = Int()
    var pageCount = Int()
    
    func getPosts(complitionHandler:@escaping(_ error:NSError?)-> Void){
        ApiCalling.shared.getDetailsFromServer(url: "\(BASE_URL)\(pageCount)") { (responseData, error) in
            if error == nil{
                print(responseData!)
                if responseData?.object(forKey: "nbPages") != nil{
                    let totalP = String(describing: responseData!.object(forKey: "nbPages")!)
                    self.totalPages = Int(totalP) ?? 0
                    
                }
                if responseData?.object(forKey: "page") != nil{
                    let currentP = String(describing: responseData!.object(forKey: "page")!)
                    self.currentPage = Int(currentP) ?? 0
                    
                }
                if  let arrObj = responseData?.object(forKey: "hits") as? NSArray{
                    for eachObj in arrObj{
                        let modelObj = PostModel(postModel: eachObj as! NSDictionary)
                        self.postModel.append(modelObj)
                    }
                    complitionHandler(nil)
                }else{
                    print("No data")
                }
            }else{
                complitionHandler(error)
            }
        }
    }
    
    func getUpdatedSwitchStatus(postModel:[PostModel],indexPath:IndexPath,compltionHandeler:@escaping(_ error:NSError?)-> Void){
        postModel[indexPath.row].switchStatus =  postModel[indexPath.row].switchStatus ? false: true
        compltionHandeler(nil)
    }
    
    func getDateFormatChanges(dateString:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm a"
        let dateReturn = dateFormatter1.string(from: date!)
        return dateReturn
    }
    
}

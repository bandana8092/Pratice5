//
//  ViewController.swift
//  Pratice_4_Bandana
//
//  Created by Rakesh Nangunoori on 29/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
    

    @IBOutlet weak var postsTV: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        GlobalMethod.shared.showActivityIndicator(view: self.view, targetVC: self)
          
          refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
          postsTV.addSubview(refreshControl) //
        if GlobalMethod.shared.isConnectedToNetwork() == true{
            ViewModel.shared.getPosts { (error) in
                      if error == nil{
                          DispatchQueue.main.async {
                            print("Bandana")
                              GlobalMethod.shared.hideActivityIndicator(view: self.view)
                              self.postsTV.reloadData()
                          }
                      }
                  }
        }
      
        
        // Do any additional setup after loading the view.
    }
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        if ViewModel.shared.totalPages > ViewModel.shared.currentPage {
            ViewModel.shared.pageCount = 0
            ViewModel.shared.postModel.removeAll()
            self.navigationItem.title = ""
            fetchMoreData()
            
        }
        refreshControl.endRefreshing()
        self.postsTV.reloadData()
                    
                        
    }
     
    func fetchMoreData(){
         if GlobalMethod.shared.isConnectedToNetwork() == true {
        ViewModel.shared.getPosts { (error) in
                   if error == nil{
                       DispatchQueue.main.async {
                        self.spinner.isHidden = true
                           self.postsTV.reloadData()
                       }
                   }
               }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ViewModel.shared.postModel.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostsTableViewCell
        cell.getUpdatedCell(postModel: ViewModel.shared.postModel, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ViewModel.shared.getUpdatedSwitchStatus(postModel: ViewModel.shared.postModel, indexPath: indexPath) { (error) in
            if error == nil{
                let fillteeredArr = ViewModel.shared.postModel.filter{$0.switchStatus == true}
                if fillteeredArr.count > 0{
                    self.navigationItem.title = "\(fillteeredArr.count)"
                }else{
                    self.navigationItem.title = "0"
                }
                self.postsTV.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ViewModel.shared.postModel.count - 1{
            self.spinner.isHidden = false
            self.spinner.startAnimating()
             if ViewModel.shared.totalPages > ViewModel.shared.currentPage
             {
                ViewModel.shared.pageCount += 1
                fetchMoreData()
            }
        }else{
            spinner.isHidden = true
        }
    }

}


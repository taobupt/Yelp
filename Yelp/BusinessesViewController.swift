//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    
    
    
    var isMoreDataLoading=false
    var loadingMoreView: InfiniteScrollActivityView?
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        tableView.delegate=self
        tableView.dataSource=self
        let searchBar=UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView=searchBar
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        
        
        
        
        
        
        
        let refreshControl=UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(BusinessesViewController.refreshControlAction(refreshControl:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
        
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight=120
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses=self.businesses{
            return businesses.count
        }else{
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:"BusinessCell" , for: indexPath) as! BusinessCell
        cell.business=businesses[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            
            let scrollViewContentHeight=tableView.contentSize.height
            let scrollOffsetThreshold=scrollViewContentHeight-tableView.bounds.height
            if(scrollView.contentOffset.y>scrollOffsetThreshold && tableView.isDragging){
                isMoreDataLoading=true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    
    func loadMoreData(){
        Business.searchWithTerm(term: "Thai",offset: 12, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.isMoreDataLoading=false
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
        }
        )
    }
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight=120
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
        )

    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        self.searchBar.showsCancelButton=true
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.searchBar.showsCancelButton=false
//        searchBar.text=""
//        searchBar.resignFirstResponder()
//        self.filteredBusiness=self.businesses
//        self.tableView.reloadData()
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if let businesses=self.businesses{
//            self.filteredBusiness=businesses.filter {((($0.name as AnyObject) as! String).range(of: searchText,options: .caseInsensitive) != nil)}
//        }
//        if searchText=="" {
//            self.filteredBusiness=businesses
//        }
//        tableView.reloadData()
//            
//    }
    
    
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let indexPath=tableView.indexPathForSelectedRow
        let index=indexPath?.row
        let detailViewController=segue.destination as! DetailsViewController
        var bussines=businesses[index!]
        detailViewController.longitude=bussines.longitude
        detailViewController.latitude=bussines.latitude
        
        
    }

    
    
}

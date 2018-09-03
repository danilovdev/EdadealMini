//
//  SearchViewController.swift
//  EdadealMiniV1
//
//  Created by Alexey Danilov on 02/09/2018.
//  Copyright © 2018 Alexey Danilov. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let identifier = "PurchaseCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureSearchBar()
        
        loadData()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func configureSearchBar() {
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        searchController.searchBar.placeholder = "Введите название продукта"
    }
    
    private func loadData() {
        let session = URLSession.shared
        let urlStr = "https://api.edadev.ru/intern/"
        guard let url = URL(string: urlStr) else { return }
        indicator.startAnimating()
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let jsonArray = json as? [[String: Any]] {
                    for itemDict in jsonArray {
                        let item = Item(dictionary: itemDict)
                        self.items.append(item)
                        
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                    }
                }
                
                
            } catch {
                
            }
        }
        task.resume()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PurchaseItemCell
        let item = items[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

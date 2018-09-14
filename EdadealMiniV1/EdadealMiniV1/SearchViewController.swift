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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var items = [Item]()
    
    private let cellId = "PurchaseCell"
    
    private var filteredItems = [(Item, [Range<String.Index>]?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureSearchBar()
        
        loadData()
    }
    
    private func configureTableView() {
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "PurchaseItemCell", bundle: nil), forCellReuseIdentifier: "PurchaseCell")
    }
    
    private func configureSearchBar() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            searchController.obscuresBackgroundDuringPresentation = false
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
                        UIView.transition(with: self.tableView,
                                          duration: 0.4,
                                          options: .transitionCrossDissolve,
                                          animations: {
                                            self.tableView.isHidden = false
                                            self.tableView.reloadData()
                                            self.indicator.stopAnimating()
                        })
                    }
                }
            } catch {
                
            }
        }
        task.resume()
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        guard searchText.count > 1 else {
            filteredItems = items.map { ($0, nil) }
            tableView.reloadData()
            return
        }
        
        filteredItems = items.filter {
            guard searchText.count > 1 else { return true }
            guard let description = $0.description else { return true }
            return description.lowercased().contains(searchText.lowercased())
            }
            .sorted(by: { item1, item2 -> Bool in
                guard let weight1 = item1.description!.calculateWeightForSubstring(substring: searchText),
                    let weight2 = item2.description!.calculateWeightForSubstring(substring: searchText) else { return false }
                switch (weight1.isStart, weight2.isStart) {
                case (true, true):
                    return weight1.index < weight2.index
                case (true, false):
                    return true
                case (false, true):
                    return false
                case (false, false):
                    return weight1.index < weight2.index
                }
            })
            .map {
                ($0, $0.description!.getAllSubranges(substring: searchText))
        }
        tableView.reloadData()
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredItems.count
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PurchaseItemCell
        let item: Item
        var ranges: [Range<String.Index>]?
        if isFiltering() {
            item = filteredItems[indexPath.row].0
            ranges = filteredItems[indexPath.row].1
        } else {
            item = items[indexPath.row]
        }
        cell.configure(item: item, mode: .purchase, ranges: ranges)
        return cell
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        filterContentForSearchText(text)
    }
}

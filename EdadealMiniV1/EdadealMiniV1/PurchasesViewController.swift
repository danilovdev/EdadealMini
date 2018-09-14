//
//  PurchasesViewController.swift
//  EdadealMiniV1
//
//  Created by Alexey Danilov on 02/09/2018.
//  Copyright © 2018 Alexey Danilov. All rights reserved.
//

import Foundation
import UIKit

protocol PurchaseItemCellDelegate: class {
    func didRemoveItem(for cell: PurchaseItemCell)
}

class PurchasesViewController: UIViewController {
    
    private let cellId = "PurchaseCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.reloadData()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "PurchaseItemCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
}

extension PurchasesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalValues.selectedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            as! PurchaseItemCell
        let item = GlobalValues.selectedItems[indexPath.row]
        cell.configure(item: item, mode: .remove)
        cell.delegate = self
        return cell
    }

}

extension PurchasesViewController: PurchaseItemCellDelegate {
    func didRemoveItem(for cell: PurchaseItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            tableView.beginUpdates()
            tableView.deleteRows(at:[indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

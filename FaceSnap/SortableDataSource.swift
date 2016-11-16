//
//  SortableDataSource.swift
//  FaceSnap
//
//  Created by Alexey Papin on 16.11.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CustomTitleConvertable {
    var title: String { get }
}

extension Tag: CustomTitleConvertable {
    
}

class SortableDataSource<SortType: CustomTitleConvertable>: NSObject, UITableViewDataSource where SortType: NSManagedObject {
    fileprivate let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    var results: [SortType] {
        return fetchedResultsController.fetchedObjects as! [SortType]
    }
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managetObjectContext moc: NSManagedObjectContext) {
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        executeFetch()
    }
    
    func executeFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("\(error)")
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return fetchedResultsController.fetchedObjects?.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "sortableItemCell")
        cell.selectionStyle = .none
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.textLabel?.text = "All \(SortType.self)s"
            cell.accessoryType = .checkmark
        case (1, _):
            guard let sortItem = fetchedResultsController.fetchedObjects?[indexPath.row] as? SortType else {
                break
            }
            cell.textLabel?.text = sortItem.title
        default:
            break
        }
        return cell
    }
}





































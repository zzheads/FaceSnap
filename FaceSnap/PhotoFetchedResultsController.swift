//
//  PhotoFetchedResultsController.swift
//  FaceSnap
//
//  Created by Alexey Papin on 16.11.16.
//  Copyright © 2016 zzheads. All rights reserved.
//

import CoreData
import UIKit

class PhotoFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsControllerDelegate {
    
    let collectionView: UICollectionView
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.delegate = self
        executeFetch()
    }
    
    func executeFetch() {
        do {
            try performFetch()
        } catch let error {
            print("Unresolved error \(error.localizedDescription)")
        }
    }
    
    func performFetch(withPredicate predicate: NSPredicate?) {
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        fetchRequest.predicate = predicate
        executeFetch()
    }
    
    // MARK - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
}

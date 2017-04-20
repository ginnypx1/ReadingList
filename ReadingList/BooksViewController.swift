//
//  BooksViewController.swift
//  ReadingList
//
//  Created by Ginny Pennekamp on 4/20/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class BooksViewController: CoreDataTableViewController {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title
        title = "Books to Read"
        
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        fr.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // MARK: Actions
    
    @IBAction func addNewBook(_ sender: AnyObject) {

        let bookToRead = Book(title: "New Book", context: fetchedResultsController!.managedObjectContext)
        print("Just added a book to read: \(bookToRead)")
    }
    
    // MARK: TableView Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Find the right notebook for this indexpath
        let bookToRead = fetchedResultsController!.object(at: indexPath) as! Book
        
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        
        // Sync notebook -> cell
        cell.textLabel?.text = bookToRead.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let context = fetchedResultsController?.managedObjectContext, let bookToRead = fetchedResultsController?.object(at: indexPath) as? Book, editingStyle == .delete {
            context.delete(bookToRead)
        }
    }
}


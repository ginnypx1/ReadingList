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
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    // MARK: - Life Cycle
    
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
    
    // MARK: - Allow user to enter title
    
    func addNewBookInAlert() {
        let alert = UIAlertController(title: "Add a New Book",
                                      message: "Please enter the title of the book you'd like to read.",
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            if let listName = textField.text {
                self.addBookToDatabase(title: listName)
            }
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // Add textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "War and Peace"
            textField.clearButtonMode = .whileEditing
        }
        
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func addBookToDatabase(title: String) {
        
        let bookToRead = Book(title: title, context: fetchedResultsController!.managedObjectContext)
        print("Just added a book to read: \(bookToRead)")
    }
    
    // MARK: - Actions
    
    @IBAction func addNewBook(_ sender: AnyObject) {
        
        addNewBookInAlert()
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bookToRead = fetchedResultsController!.object(at: indexPath) as! Book

        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        cell.textLabel?.text = bookToRead.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            
            if let context = fetchedResultsController?.managedObjectContext, let bookToRead = fetchedResultsController?.object(at: indexPath) as? Book, editingStyle == .delete {
                context.delete(bookToRead)
            }
        }
    }
    
    @IBAction func editTable(_ sender: UIBarButtonItem) {
        // allows table rows to be deleted
        tableView.setEditing(!tableView.isEditing, animated: true)
        // changes the text of the edit button
        if tableView.isEditing {
            self.editButton.title = "One"
        } else {
            self.editButton.title = "Two"
        }
    }
}


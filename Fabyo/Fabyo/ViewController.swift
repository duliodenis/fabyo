//
//  ViewController.swift
//  Fabyo
//
//  Created by Dulio Denis on 8/31/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var library: JSON = JSON.null
    
    let textCellIdentifier = "Cell"
    let bookSegueIdentifier = "BookView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        booksLookup()
    }


    func booksLookup() {
        let urlPath = NSURL(string: "https://librivox.org/api/feed/audiobooks/?format=json")!
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(urlPath) {
            data, response, error -> Void in
            
            if ((error) != nil) {
                print(error!.localizedDescription, terminator: "")
            }
            
            var jsonError : NSError?
            var jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            if ((jsonError) != nil) {
                print(jsonError!.localizedDescription, terminator: "")
            }
            // update the UITableView on the main thread
            dispatch_async(dispatch_get_main_queue()) {
                self.library = JSON(data: data!)
                
                let numberOfBooks = self.library["books"].count
                print("Results are \(numberOfBooks) books\n", terminator: "")
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    
    // MARK: - TableView Delegte Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let books = library["books"]
        return books.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) 
        
        let row = indexPath.row
        if let bookName = library["books"][row]["title"].string as String! {
            cell.textLabel?.text = bookName
        }
        
        if let authorFirstName = library["books"][row]["authors"][0]["first_name"].string as String! {
            if let authorLastName = library["books"][row]["authors"][0]["last_name"].string as String! {
                cell.detailTextLabel?.text = "\(authorFirstName) \(authorLastName)"
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation Control
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == bookSegueIdentifier {
            if let bookVC: BookViewController = segue.destinationViewController as? BookViewController {
                if let bookIndex = tableView.indexPathForSelectedRow?.row {
                    bookVC.book.title = library["books"][bookIndex]["title"].string
                    let description = library["books"][bookIndex]["description"].string
                    let cleanDescription = description!.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                    bookVC.book.description = cleanDescription
                }
            }
        }
    }

}


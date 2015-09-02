//
//  BookViewController.swift
//  Fabyo
//
//  Created by Dulio Denis on 9/1/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    var book = Book()

    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = book.title
        descriptionLabel.text = book.description
        formatLabels()
    }

    
    // MARK: - Label and Text Helper Methods
    
    func formatLabels() {
        // create a convenience labels array to iterate through all view labels
        var labelsArray = [titleLabel, descriptionLabel]
        
        // iterate through the labels to set their alignment and font
        for label in labelsArray {
            label.textAlignment = .Center
            
            switch label {
                
            case titleLabel:
                label.font = UIFont(name: "Avenir Next", size: 24)
                
            case descriptionLabel:
                label.font = UIFont(name: "Avenir Next", size: 14)
                
            default:
                label.font = UIFont(name: "Avenir Next", size: 14)
            }
        }
    }
}

//
//  RelatedTopicsTableViewController.swift
//  DuckDuckGo
//
//  Created by Ilgar Ilyasov on 6/8/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import UIKit
import CoreDuckDuckGo

class RelatedTopicsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let client = DuckDuckGoClient()
    var initialRelatedTopics = [RelatedTopic]()
    var relatedTopics = [RelatedTopic]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        client.performSearch(for: "the wire characters") { (result) in
            switch result {
            case .failure(let error):
                NSLog("Error: \(error)")
                // Show alert
                break
            case .success(let relatedTopics):
                self.relatedTopics = relatedTopics
            }
        }
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedTopics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        
        let topic = relatedTopics[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = topic.text
        
        return cell
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTopicDetail" {
            guard let destinationVC = segue.destination as? TopicDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let topic = relatedTopics[indexPath.row]
            destinationVC.topic = topic
        }
    }

}

extension RelatedTopicsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        client.performSearch(for: text) { (result) in
            switch result {
            case .failure(let error):
                NSLog("Error: \(error)")
                // Show alert
                break
            case .success(let relatedTopics):
                self.relatedTopics = relatedTopics
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // This variable will let us to load back previous data if user delete the entry
        initialRelatedTopics = relatedTopics
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            relatedTopics = initialRelatedTopics
            return
        }
        
        // Make everything lowercase and then check
        relatedTopics = initialRelatedTopics.filter { $0.text?.lowercased().contains(searchText.lowercased()) ?? false }
    }
    
}

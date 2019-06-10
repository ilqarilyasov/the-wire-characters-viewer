//
//  TopicDetailViewController.swift
//  DuckDuckGo
//
//  Created by Ilgar Ilyasov on 6/8/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import UIKit
import CoreDuckDuckGo

class TopicDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let loader = ImagerLoader()
    var topic: RelatedTopic? {
        didSet { updateViews() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let topic = topic else { return }
        loader.loadImage(for: topic) { (result) in
            switch result {
            case .failure(let error):
                NSLog("error: \(error)")
                // Show alert
                break
            case .success(let image):
                DispatchQueue.main.async {
                    self.topicImageView.image = image
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }

    
    // MARK: - Outlets
    
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var topicDescriptionLabel: UILabel!
    
    
    private func updateViews() {
        guard isViewLoaded,
            let topic = topic else { return }
        
        topicDescriptionLabel.numberOfLines = 0
        topicDescriptionLabel.text = topic.text
    }

}

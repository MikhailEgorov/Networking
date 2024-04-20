//
//  ImageViewController.swift
//  Networking
//
//  Created by Егоров Михаил on 19.08.2022.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        // stop activityIndicator when image download
        activityIndicator.hidesWhenStopped = true
        // func for download image from network (fetch)
        fetchImage()
    }
    // network request for download image
    private func fetchImage() {
        // create url from MainVC enum Link
        guard let url = URL(string: Link.imageURL.rawValue) else { return }
        
        // create URL session
        URLSession.shared.dataTask(with: url) { data, response, error in
        // extract optional properties: data, response, error
            guard let data = data, let response = response else {
                // show the reason, if it is impossible to extract the optional
                print(error?.localizedDescription ?? "No error description")
                return
            }
            print (response)
            //switch to main thread
            DispatchQueue.main.async {
                // image initialization and set in view
                guard let image = UIImage(data: data) else { return }
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }.resume()
    }
}

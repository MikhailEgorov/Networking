//
//  CourseCell.swift
//  Networking
//
//  Created by Егоров Михаил on 27.08.2022.
//

import UIKit

class CourseCell: UITableViewCell {
    
    @IBOutlet var courseImage: UIImageView!
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var numberOfLessons: UILabel!
    @IBOutlet var numberOfTests: UILabel!
    
    //func for pass model instance values to labels and image view
    func configure(with course: Course) {
        courseNameLabel.text = course.name
        numberOfLessons.text = "Number of lessons: \(course.numberOfLessons ?? 0)"
        numberOfTests.text = "Number of tests: \(course.numberOfTests ?? 0):"
        // easy way to get image from JSON
        //global thread mode to display after download
        NetworkManager.shared.fetchImage(from: course.imageUrl) { result in
            switch result {
            case .success(let imageData):
                self.courseImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configure(with courseV2: CourseV2) {
        courseNameLabel.text = courseV2.name
        numberOfLessons.text = "Number of lessons: \(courseV2.numberOfLessons ?? 0)"
        numberOfTests.text = "Number of tests: \(courseV2.numberOfTests ?? 0):"
        // easy way to get image from JSON
        //global thread mode to display after download
        NetworkManager.shared.fetchImage(from: courseV2.imageUrl) { result in
            switch result {
            case .success(let imageData):
                self.courseImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }

    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     */
}

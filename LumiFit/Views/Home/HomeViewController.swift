//
//  HomeViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/23.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var activityView: UIStackView!
    @IBOutlet weak var popularExerciseLabel: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var cardData: [ExerciseCardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a container view for the custom navigation bar item
        setUpNavigationItemUI()
        setUpActivityCardUI()
        setupCardData()
        setUpPopularExerciseUI()
        

    }

    // MARK: - UI Setup Functions
    fileprivate func setUpNavigationItemUI(){
        let containerView = UIView()

        // Create and configure the profile image view
        let profileImageView = UIImageView(image: UIImage(named: "profile"))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true

        // Create and configure the greeting label
        let greetingLabel = UILabel()
        greetingLabel.text = "Good day,"
        greetingLabel.font = UIFont.boldSystemFont(ofSize: 16)

        // Create and configure the name label
        let nameLabel = UILabel()
        nameLabel.text = "Austin"  // Replace with the actual user name
        nameLabel.font = UIFont.italicSystemFont(ofSize: 16)
        nameLabel.textColor = UIColor.systemBlue

        // Add the subviews to the container view
        containerView.addSubview(profileImageView)
        containerView.addSubview(greetingLabel)
        containerView.addSubview(nameLabel)

        // Disable autoresizing masks and set constraints manually
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Set constraints for profileImageView
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Set constraints for greetingLabel
        NSLayoutConstraint.activate([
            greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            greetingLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        // Set constraints for nameLabel
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: greetingLabel.trailingAnchor, constant: 4),
            nameLabel.centerYAnchor.constraint(equalTo: greetingLabel.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        // Set the container view's frame to properly contain all elements
        containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)

        // Create a UIBarButtonItem with the custom container view
        let customLeftItem = UIBarButtonItem(customView: containerView)
        
        // Set it as the leftBarButtonItem of the navigation item
        self.navigationItem.leftBarButtonItem = customLeftItem
    }
    
    fileprivate func setUpActivityCardUI(){
        let dailyActivityCard = ActivityCardView(frame: CGRect(x: 50, y: 100, width: 150, height: 150))
        dailyActivityCard.configure(image: UIImage(named: "foot_walk")!, title: "Daily Activity", backgroundColor: UIColor(named: "green_card")!, progress: 0.2)
            
        let workoutsCard = ActivityCardView(frame: CGRect(x: 220, y: 100, width: 150, height: 150))
        workoutsCard.configure(image: UIImage(systemName: "bicycle")!, title: "Workouts", backgroundColor: UIColor(named: "dark_green_card")!, progress: 0.6)
        self.activityView.addArrangedSubview(dailyActivityCard)
        self.activityView.addArrangedSubview(workoutsCard)
        self.activityView.distribution = .equalCentering
        self.activityView.spacing = 10
        
        self.activityView.alignment = .center
        NSLayoutConstraint.activate([
            dailyActivityCard.widthAnchor.constraint(equalToConstant: 150),
            dailyActivityCard.heightAnchor.constraint(equalToConstant: 180),
            workoutsCard.widthAnchor.constraint(equalToConstant: 150),
            workoutsCard.heightAnchor.constraint(equalToConstant: 180)
        ])
        
    }
    
    fileprivate func setUpPopularExerciseUI(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 300, height: 200)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
    }
    
    fileprivate func setupCardData() {
        cardData = [
            ExerciseCardModel(title: "Total Body Yoga - Deep Stretch", duration: "15 min", calories: "346 kcal", image: UIImage(named: "yoga")!, backgroundColor: UIColor.systemTeal),
            ExerciseCardModel(title: "Weight Loss Exercise Sessions", duration: "30 min", calories: "346 kcal", image: UIImage(named: "bicycling_exercise")!, backgroundColor: UIColor.systemGray)
            // Add more cards as needed
        ]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCardCell", for: indexPath) as! ExerciseCardCell
        let cardModel = cardData[indexPath.item]
        cell.configure(with: cardModel)
        return cell
    }
    
    
}

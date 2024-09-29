//
//  HomeViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/23.
//

import UIKit
import HealthKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var activityView: UIStackView!
    @IBOutlet weak var popularExerciseLabel: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var workoutProcessCollectionView: UICollectionView!
    var dailyActivityCard: ActivityCardView!
    var workoutsCard: ActivityCardView!
    
    private var cardData: [ExerciseCardModel] = []
    private var workoutProcessData: [WorkoutProcessModel] = [
        WorkoutProcessModel(title: "Walk", count: 0, type: "Steps", image: "walk_icon"),
        WorkoutProcessModel(title: "Exercise", count: 0, type: "Hours", image: "bicycle_icon"),
        WorkoutProcessModel(title: "Calories", count: 0, type: "Kcal", image: "bowl_icon"),
    ]
    private var videoData: [[URL]] = [
        [URL(string: "https://dd9dmyh9pfrll.cloudfront.net/step1.mp4")!,
        URL(string: "https://dd9dmyh9pfrll.cloudfront.net/step2.mp4")!,
        URL(string: "https://dd9dmyh9pfrll.cloudfront.net/step3.mp4")!,
         URL(string: "https://dd9dmyh9pfrll.cloudfront.net/step4.mp4")!],
        [URL(string: "https://dd9dmyh9pfrll.cloudfront.net/bf_step1.mp4")!,
        URL(string: "https://dd9dmyh9pfrll.cloudfront.net/bf_step2.mp4")!,
        URL(string: "https://dd9dmyh9pfrll.cloudfront.net/bf_step3.mp4")!,
         URL(string: "https://dd9dmyh9pfrll.cloudfront.net/bf_step4.mp4")!]
    ]
    
    var calorieViewModel = CalorieViewModel.shared
    var waterCalViewModel = WaterCalViewModel.shared
    var intakeViewModel = IntakeViewModel.shared
    
    let healthStore = HealthKitManager.shared.healthStore
    var stepCountQuery: HKObserverQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutProcessCollectionView.delegate = self
        workoutProcessCollectionView.dataSource = self

        setUpActivityCardUI()
        setupCardData()
        setUpPopularExerciseUI()
        
        fetchLatestHealthData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgress), name: .calorieProgressUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgress), name: .waterProgressUpdated, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task{
            await requestHealthAuthorization()
        }
        fetchLatestHealthData()
        collectionView.reloadData()
        workoutProcessCollectionView.reloadData()
        let updatedName = UserDefaults.standard.string(forKey: "name") ?? "John Doe"
        
        setUpNavigationItemUI(updatedName: updatedName)
    }
    
    // MARK: - Request HealthKit Authorization
    func requestHealthAuthorization() async {
        // Use your HealthKitManager's async authorization request
        await HealthKitManager.shared.requestHealthKitAuthorization()
        // Start observing step count changes after authorization
    }

    // MARK: - Fetch Health Data
    func fetchLatestHealthData() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        // Step count query using HKStatisticsQuery to sum all step samples
        let stepQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, statistics, error) in
            guard let sum = statistics?.sumQuantity() else {
                print("Error fetching steps: \(String(describing: error))")
                return
            }
            
            let stepCount = sum.doubleValue(for: HKUnit.count())
            DispatchQueue.main.async {
                self.updateWorkoutProcessData(stepCount: stepCount, exerciseTime: nil, calories: nil)
            }
        }
        
        // Exercise time query
        let exerciseQuery = HKSampleQuery(sampleType: exerciseType, predicate: predicate, limit: 0, sortDescriptors: nil) { (query, results, error) in
            guard let results = results as? [HKQuantitySample] else {
                print("Error fetching exercise time: \(String(describing: error))")
                return
            }
            
            // Sum all exercise samples for the day
            let totalExerciseMinutes = results.reduce(0) { sum, sample in
                return sum + sample.quantity.doubleValue(for: HKUnit.minute())
            }
            
            DispatchQueue.main.async {
                self.updateWorkoutProcessData(stepCount: nil, exerciseTime: totalExerciseMinutes, calories: nil)
            }
        }
        
        // Calorie query
        let calorieQuery = HKSampleQuery(sampleType: calorieType, predicate: predicate, limit: 0, sortDescriptors: nil) { (query, results, error) in
            guard let results = results as? [HKQuantitySample] else {
                print("Error fetching calories: \(String(describing: error))")
                return
            }
            
            // Sum all calorie samples for the day
            let totalCaloriesBurned = results.reduce(0) { sum, sample in
                return sum + sample.quantity.doubleValue(for: HKUnit.kilocalorie())
            }
            
            DispatchQueue.main.async {
                self.updateWorkoutProcessData(stepCount: nil, exerciseTime: nil, calories: totalCaloriesBurned)
            }
        }
        
        // Execute all queries
        healthStore.execute(stepQuery)
        healthStore.execute(exerciseQuery)
        healthStore.execute(calorieQuery)
    }


    func updateWorkoutProcessData(stepCount: Double?, exerciseTime: Double?, calories: Double?) {
        if let stepCount = stepCount {
            self.workoutProcessData[0].count = stepCount // Updating steps
        }
        if let exerciseTime = exerciseTime {
            self.workoutProcessData[1].count = exerciseTime // Updating exercise time
        }
        if let calories = calories {
            self.workoutProcessData[2].count = calories // Updating calories
        }
        workoutProcessCollectionView.reloadData()
        print("Updated workout process data", workoutProcessData)
    }


    // MARK: - UI Setup Functions
    fileprivate func setUpNavigationItemUI(updatedName: String){
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
        nameLabel.text = updatedName
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withSymbolicTraits([.traitBold, .traitItalic])
        nameLabel.font = UIFont(descriptor: fontDescriptor!, size: 20)
        nameLabel.textColor = UIColor(named: "dark_gray_card")!

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
        dailyActivityCard.configure(image: UIImage(named: "foot_walk")!, title: "Calorie Intake", backgroundColor: UIColor(named: "green_card")!, progress: calorieViewModel.progress)
            
        let workoutsCard = ActivityCardView(frame: CGRect(x: 220, y: 100, width: 150, height: 150))
        workoutsCard.configure(image: UIImage(named: "water_drop")!, title: "Water Intake", backgroundColor: UIColor(named: "dark_green_card")!, progress:         waterCalViewModel.progress)
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
        self.dailyActivityCard = dailyActivityCard
        self.workoutsCard = workoutsCard
        
    }
    
    @objc func updateProgress() {
        dailyActivityCard?.updateProgress(to: calorieViewModel.progress)
        workoutsCard?.updateProgress(to: waterCalViewModel.progress)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
            ExerciseCardModel(title: "Total Body Yoga - Deep Stretch", duration: "15 min", calories: "346 kcal", image: UIImage(named: "yoga")!, backgroundColor: UIColor(named: "dark_green_card")!),
            ExerciseCardModel(title: "Weight Loss Exercise Sessions", duration: "30 min", calories: "346 kcal", image: UIImage(named: "bicycling_exercise")!, backgroundColor: UIColor(named: "dark_gray_card")!)
            // Add more cards as needed
        ]
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return cardData.count
        } else if collectionView == self.workoutProcessCollectionView {
            return workoutProcessData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCardCell", for: indexPath) as! ExerciseCardCell
            let cardModel = cardData[indexPath.item]
            cell.configure(with: cardModel)
            return cell
        } else if collectionView == self.workoutProcessCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutProcessCell", for: indexPath) as! WorkoutCardCell
            let processModel = workoutProcessData[indexPath.item]
            cell.configure(with: processModel)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            let index = indexPath.row
            let selectedData = videoData[index]
                    
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let videoVC = storyboard.instantiateViewController(withIdentifier: "videoPlayerVC") as? VideoViewController {
                
                // Pass the selected data to the new view controller
                videoVC.videoURLs = selectedData
                
                // Push the new view controller onto the navigation stack
                self.navigationController?.pushViewController(videoVC, animated: true)
            }
        }
    }
    
}

extension Notification.Name {
    static let calorieProgressUpdated = Notification.Name("calorieProgressUpdated")
    static let waterProgressUpdated = Notification.Name("waterProgressUpdated")
}

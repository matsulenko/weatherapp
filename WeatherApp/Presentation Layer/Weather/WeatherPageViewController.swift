//
//  WeatherPageViewController.swift
//  WeatherApp
//
//  Created by Matsulenko on 27.09.2023.
//

import CoreLocation
import RealmSwift
import UIKit

final class WeatherPageViewController: UIPageViewController {
    
    let locationManager = CLLocationManager()

    private var pages: [WeatherViewController] = []
    
    private var currentIndex = 0
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = UIColor(named: "Background")
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(named: "Text")
        pageControl.currentPageIndicatorTintColor = UIColor(named: "Text")
        pageControl.preferredIndicatorImage = UIImage(systemName: "circle.fill")
        
        for i in 1..<pages.count {
            pageControl.setIndicatorImage(UIImage(systemName: "circle"), forPage: i)
        }

        return pageControl
    }()
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPages()
        addSubviews()
        setupView()
        setupNavigationBar()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupPages() {
        var updatedPages: [WeatherViewController] = []
        
        do {
            let realm = try Realm()
            let objects = realm.objects(LocationObject.self)
            for i in objects{
                if i.name == "Текущее местоположение" {
                    if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                        let newVC = WeatherViewController(isFromDeviceLocation: true, currentLocation: CLLocation(latitude: i.latitude, longitude: i.longitude))
                        newVC.locationName = i.name
                        updatedPages.insert(newVC, at: 0)
                    } else if objects.count == 1 {
                        let newVC = WeatherViewController(isFromDeviceLocation: false, currentLocation: nil)
                        updatedPages.append(newVC)
                    }
                } else {
                    let newVC = WeatherViewController(isFromDeviceLocation: false, currentLocation: CLLocation(latitude: i.latitude, longitude: i.longitude))
                    newVC.locationName = i.name
                    updatedPages.append(newVC)
                }
            }
            if updatedPages.count > 0 {
                pages = updatedPages
            } else {
                pages = [WeatherViewController(isFromDeviceLocation: true, currentLocation: nil)]
            }
        } catch {
            pages = [WeatherViewController(isFromDeviceLocation: true, currentLocation: nil)]
        }
    }
        
    private func setupView() {
        view.backgroundColor = UIColor(named: "Background")
        dataSource = self
        delegate = self
        pageControl.numberOfPages = pages.count
          
        currentIndex = 0
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        for i in pages {
            if i.currentLocation == nil {
                i.plusButton.addTarget(self, action: #selector(chooseLocation), for: .touchUpInside)
            }
        }
        locationManager.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(pageControl)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            pageControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: safeArea.topAnchor),
        ])
    }
        
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = menuButton(action: #selector(openSettings), image: UIImage(named: "Burger")!, width: 34, height: 18)
        self.navigationItem.rightBarButtonItem = menuButton(action: #selector(chooseLocation), image: UIImage(systemName: "plus")!, width: 25, height: 25)
        if pages.count == 1 {
            title = pages[0].title
        }
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Rubik-Light_Medium", size: 18)!]
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Background")
        appearance.titleTextAttributes = attributes
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func menuButton(action: Selector, image: UIImage, width: Double, height: Double) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.tintColor = UIColor(named: "Text")

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: width).isActive = true
        menuBarItem.tintColor = UIColor(named: "Text")

        return menuBarItem
    }
    
    @objc
    private func openSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .fullScreen
        guard let navigationController = self.navigationController else { return }
        navigationController.present(settingsVC, animated: true)
    }
    
    @objc
    private func chooseLocation() {
        let alert = UIAlertController(title: "Добавить город", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Название города"
            textField.autocapitalizationType = .words
        }
        
        alert.addAction(
            UIAlertAction(
                title: "Отмена",
                style: .cancel,
                handler: nil
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Ок",
                style: .default,
                handler: { [weak alert] _ in
                    guard let alert = alert, let textField = alert.textFields?.first else { return }
                    self.addLocation(name: textField.text)
                }
            )
        )

        present(alert, animated: true)
    }
    
    func addLocation(name: String?) {
        if name != nil {
            CLGeocoder().geocodeAddressString(name!) { [self] completion, error in
                let newVC = WeatherViewController(isFromDeviceLocation: false, currentLocation: completion?.first?.location)
                newVC.locationName = name
                if let latitude = completion?.first?.location?.coordinate.latitude, let longitude = completion?.first?.location?.coordinate.longitude {
                    let newLocation = Location(latitude: latitude, longitude: longitude, name: name)
                    pages.append(newVC)
                    RealmService().saveLocation(newLocation)
                }
                
                if pages[0].currentLocation == nil {
                    pages.remove(at: 0)
                }
                
                pageControl.numberOfPages = pages.count
                
                currentIndex = (pages.count - 1)
                if let lastVC = pages.last {
                    setViewControllers([lastVC], direction: .forward, animated: true, completion: nil)
                }
                if pages.count > 1 {
                    for i in 0...(pages.count - 2) {
                        pageControl.setIndicatorImage(UIImage(systemName: "circle"), forPage: (i))
                    }
                }
            }
        }
    }
}

extension WeatherPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
               let index = pages.firstIndex(of: currentViewController as! WeatherViewController) {
                currentIndex = index
                pageControl.currentPage = index
                self.title = pages[index].title
                for i in 0..<pages.count {
                    if i == index {
                        pageControl.setIndicatorImage(UIImage(systemName: "circle.fill"), forPage: i)
                    } else {
                        pageControl.setIndicatorImage(UIImage(systemName: "circle"), forPage: i)
                    }
                }
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if pages.count == 1 {
            return nil
        } else {
            guard let index = pages.firstIndex(of: viewController as! WeatherViewController) else { return nil }
            
            if index == 0 {
                return pages.last
            } else {
                return pages[index - 1]
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if pages.count == 1 {
            return nil
        } else {
            guard let index = pages.firstIndex(of: viewController as! WeatherViewController) else { return nil }
            
            if index == pages.count - 1 {
                return pages.first
            } else {
                return pages[index + 1]
            }
        }
    }
}

extension WeatherPageViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            for i in 0..<pages.count {
                if pages[i].isEmpty {
                    pages.remove(at: i)
                }
            }
                        
            do {
                let realm = try Realm()
                let objects = realm.objects(LocationObject.self)
                if let ifFromDeviceLocationVC = objects.first(where: {$0.name == "Текущее местоположение"}) {
                    let newVC = WeatherViewController(isFromDeviceLocation: true, currentLocation: CLLocation(latitude: ifFromDeviceLocationVC.latitude, longitude: ifFromDeviceLocationVC.longitude))
                    newVC.locationName = ifFromDeviceLocationVC.name
                    pages.insert(newVC, at: 0)
                } else {
                    pages.insert(WeatherViewController(isFromDeviceLocation: true, currentLocation: nil), at: 0)
                }
            } catch {
                pages = [WeatherViewController(isFromDeviceLocation: true, currentLocation: nil)]
            }
            
            pageControl.numberOfPages = pages.count
            
            currentIndex = 0
            if let firstVC = pages.first {
                setViewControllers([firstVC], direction: .reverse, animated: false, completion: nil)
                title = firstVC.title
            }
            
            if pages.count > 1 {
                for i in 1...(pages.count - 1) {
                    pageControl.setIndicatorImage(UIImage(systemName: "circle"), forPage: (i))
                }
            }
        }
    }
}

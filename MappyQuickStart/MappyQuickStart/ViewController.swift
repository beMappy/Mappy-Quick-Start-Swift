//
//  ViewController.swift
//  MappyQuickStart
//
//  Created by Mohamed Afsar on 23/06/22.
//

import UIKit
import Combine
import Mappy

class ViewController: UIViewController {
    private let venuesTableView = UITableView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    private let venuesService = VenuesService()
    private var venues = [Venue]()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Venues"
        addSubviews()
        
        // Get all the available venues
        activityIndicatorView.startAnimating()
        venuesService.getVenues()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error):
                    print("getVenues: Error: \(error)")
                }
                self?.activityIndicatorView.stopAnimating()
            }, receiveValue: { [weak self] venues in
                print("getVenues completion. venues.count: \(venues.count)")
                self?.venues = venues // Received venues
                self?.venuesTableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    private func addSubviews() {
        venuesTableView.dataSource = self
        venuesTableView.delegate = self
        venuesTableView.translatesAutoresizingMaskIntoConstraints = false
        venuesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(venuesTableView)
        NSLayoutConstraint.activate([
            venuesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            venuesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            venuesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            venuesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: activityIndicatorView.superview!.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: activityIndicatorView.superview!.centerYAnchor),
        ])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(venues[indexPath.row].data!.name!)\n\n\(venues[indexPath.row].data!.description!)"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mapsVC = MapsViewController()
        mapsVC.venueInfo = venues[indexPath.row]
        self.navigationController?.pushViewController(mapsVC, animated: true)
    }
}

//
//  MapsViewController.swift
//  MappyQuickStart
//
//  Created by Mohamed Afsar on 23/06/22.
//

import UIKit
import Mappy

class MapsViewController: UIViewController {
    var venueInfo: Venue?
    
    private var mapView = MapView()
    private var map: Map?
    private var sceneView = SceneView()
    private var scene: Scene?
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        addSubviews()
        guard let venueInfo = venueInfo else { return }
        activityIndicatorView.startAnimating()
        
        // Initialize and load the Map(2D) and Scene(3D)
        map = Map(mapInfo: venueInfo)
        map!.load { error in
            print("Map loaded. Error?: \(String(describing: error))")
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorView.stopAnimating()
                self?.mapView.map = self?.map
            }
        }
        
        scene = Scene(sceneInfo: venueInfo)
        scene!.load { error in
            print("Scene loaded. Error?: \(String(describing: error))")
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorView.stopAnimating()
                self?.sceneView.scene = self?.scene
            }
        }
    }
    
    func addSubviews() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        mapView.alpha = 1
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.alpha = 0
        view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let btn = UIButton(type: .roundedRect)
        btn.setTitle("3D", for: .normal)
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(self.toggleTapped(_:)), for: .touchUpInside)
        
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btn.widthAnchor.constraint(equalToConstant: 44),
            btn.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: activityIndicatorView.superview!.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: activityIndicatorView.superview!.centerYAnchor),
        ])
    }
    
    @objc func toggleTapped(_ button: UIButton) {
        var sceneAlpha: CGFloat = 0, mapAlpha: CGFloat = 1
        var btnTitle = "3D"
        if self.sceneView.alpha == 0 {
            sceneAlpha = 1; mapAlpha = 0; btnTitle = "2D"
        }
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.sceneView.alpha = sceneAlpha
            self?.mapView.alpha = mapAlpha
            button.setTitle(btnTitle, for: .normal)
        }, completion: nil)
    }
}

//
//  MapViewController.swift
//  Navigation
//
//  Created by Алексей Голованов on 11.12.2023.
//

import UIKit
import MapKit
import SnapKit

final class MapViewController: UIViewController {
    
    let coordinator: Coordinatable
    let locationManager = CLLocationManager()
    var destination: MKPointAnnotation?
    
    private var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        return mapView
    }()
    
    private var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Схема","Спутник","Гибрид"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var routeButton = CustomButton(title: "Построить маршрут", cornerRadius: 10) { [weak self] in
        self?.getRoute()
    }
    
    init(coordinator: Coordinatable) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        coordinator.navigationController.navigationBar.isHidden = true
    }
    
    @objc private func longTapOnMap(gestureRecognizer: UIGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        destination = annotation
        mapView.addAnnotation(annotation)
        routeButton.isHidden = false
    }
    
    @objc func changeSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            fatalError("Тип не распознан")
        }
    }
    
    private func setupView() {
        coordinator.navigationController.navigationBar.isHidden = false
        view.backgroundColor = .systemGray5
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        routeButton.isHidden = true
        
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTapOnMap)))
        mapView.delegate = self
        segmentedControl.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
    }
    
    private func setupConstraints() {
        view.addSubview(mapView)
        view.addSubview(segmentedControl)
        view.addSubview(routeButton)
        mapView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        routeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
            make.height.equalTo(40)
        }
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(routeButton.snp.top).offset(-16)
        }
    }
    
    func addAnnotation(coordinates: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    private func getRoute() {
        guard let destination else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))
        
        let derection = MKDirections(request: request)
        derection.calculate { [weak self] responce, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            guard let self else {
                return
            }
            
            if let responce, let route = responce.routes.first {
                self.mapView.removeOverlays(self.mapView.overlays)
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .green
            render.lineWidth = 4
            return render
        }
        return MKOverlayRenderer()
    }
}

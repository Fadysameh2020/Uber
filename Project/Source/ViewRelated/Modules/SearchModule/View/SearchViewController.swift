//
//  SearchViewController.swift
//  Uber
//
//  Created by Fady Sameh on 7/8/24.
//

import UIKit
import CoreLocation

protocol SearchViewControllerDelegate: AnyObject {
    func SearchViewController(
        _ vc: SearchViewController,
        didSelectLocationWith coordinates: CLLocationCoordinate2D?
    )
}

final class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.placeholder = "enter destination"
            searchTextField.layer.cornerRadius = 9
            searchTextField.leftViewMode = .always
            searchTextField.delegate = self
        }
    }
    
    @IBOutlet weak var locationsTableView: UITableView!{
        didSet {
            locationsTableView.delegate = self
            locationsTableView.dataSource = self
            locationsTableView.makeCorner(withRadius: 16)

            locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    var locations = [Location]()
    
    weak var delegate: SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCornerRadius()
    }
    
    private func setupCornerRadius() {
        // Setting the corner radius to the view's layer
        view.makeCorner(withRadius: 16)
    }
    
    
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        if let text = searchTextField.text, !text.isEmpty {
            LocationManager.shared.findLocations(with: text) { [weak self] locations in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.locations = locations
                    self.locationsTableView.reloadData()
                }
            }
        }
        return true
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = self.locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.backgroundColor = .secondarySystemBackground
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let coordinate = locations[indexPath.row].coordinates
        
        delegate?.SearchViewController(self, didSelectLocationWith: coordinate)
    }
    
}


extension UIView {
    func makeCorner(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.isOpaque = false
    }
}

//
//  CountriesWeatherViewController.swift
//  WeatherAppData
//
//  Created by Eva on 9/28/19.
//  Copyright © 2019 Eva. All rights reserved.
//
//
import UIKit
import CoreLocation
import AlertViewBuilder

fileprivate typealias CountrieDataSource  = UICollectionViewDiffableDataSource<CountriesWeatherViewController.Section, Countrie>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<CountriesWeatherViewController.Section, Countrie>

class CountriesWeatherViewController: UIViewController {
    
    let cellId = "cellId"
    private var country = [Countrie]()
    private var dataSource: CountrieDataSource!
    private var collectionView: UICollectionView! = nil
    private var reuseView = WeatherReuseView()
    private var countryData = [Country]()
    private var model : CurrentSingleWeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createData()
    }
}

extension CountriesWeatherViewController {
    
    private func createData() {
        displayActivityIndicator(shouldDisplay: true)
        RequestManager.getAllcountries(url: Config.kAllCountriesAPI, completionHandler: { (data) in
            self.displayActivityIndicator(shouldDisplay: false)
            self.countryData = data
            for code in self.countryData  {
                
                self.country.append(Countrie(name:code.name, capital: code.capital, image: code.flag))
            }
            self.configureHierarchy()
            self.configureDataSource()
        }) { (error) in
            self.displayActivityIndicator(shouldDisplay: false)
            print(error)
        }
    }
    
    
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 8, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureHierarchy() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemFill//.systemBackground
        
        collectionView.register(CountryCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        
        dataSource = CountrieDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, country) -> CountryCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! CountryCell
            cell.country = country
            return cell
        })
        
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(self.country)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

//MARK: - Collection View Delegates
extension CountriesWeatherViewController: UICollectionViewDelegate  {
    
    fileprivate enum Section {
        case main
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let country = dataSource.itemIdentifier(for: indexPath) else { return }
        
        var url = "q=" //+ "\(String(describing:country.capital))" + "\(String(","))" +  "\(String(describing:country.name))"
        
        if  !country.capital.isEmpty {
            url =  Config.kCurrentWeatherAPI + url + "\(String(describing:country.capital))" + "\(String(","))" +  "\(String(describing:country.name))" + Config.kWeatherAPIKey
        }else{
            url = Config.kCurrentWeatherAPI + url + "\(String(describing:country.name))" + Config.kWeatherAPIKey
        }
        
        RequestManager.getCurrentWeather(url: url, completionHandler: { (data) in
            self.model = data
            self.reuseView.contentMode = .scaleAspectFill
            self.reuseView.clipsToBounds = true
            self.reuseView.layer.cornerRadius =  0
            self.reuseView.layer.masksToBounds = true
            self.reuseView.setWeatherData(weather: self.model)
            _ = AlertViewBuilder() { (builder) in
                self.reuseView.contentView.backgroundColor = UIColor(red:0.29, green:0.42, blue:0.51, alpha:1.0)
                builder.addView(with: self.reuseView, tag: 0, height: 300)
                builder.addButton(with: "OK", backgroundColor: .white, titleColor: .black, font: UIFont.systemFont(ofSize: 15), height: 40, action: {
                    
                })
            }.build()
        }) {
            (error) in
            let alertController = UIAlertController(title: "CAN NOT FIND!", message: "", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}


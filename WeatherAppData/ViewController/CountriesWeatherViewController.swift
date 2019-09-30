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
    override func viewDidLoad() {
        super.viewDidLoad()
        createData()
        //configureHierarchy()
        // configureDataSource()
    }
}

extension CountriesWeatherViewController {
    
    private func createData() {
        
        RequestManager.getAllcountries(url: Config.kAllCountriesAPI, completionHandler: { (data) in
            self.countryData = data
            for code in self.countryData  {
                
                self.country.append(Countrie(name:code.name, capital: code.capital, image: code.flag))
            }
            self.configureHierarchy()
            self.configureDataSource()
        }) { (error) in
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
        
        let url = "q=" + "\(String(describing:country.capital))" + "\(String(","))" +  "\(String(describing:country.name))"
        
        self.reuseView.updateCurrentWeather(urlLocation : url)
        self.reuseView.layer.cornerRadius =  0
        self.reuseView.layer.masksToBounds = true
        
        _ = AlertViewBuilder() { (builder) in
            self.reuseView.contentView.backgroundColor = .black
            builder.addView(with: self.reuseView, tag: 0, height: 300)
            builder.addButton(with: "OK", backgroundColor: .white, titleColor: .black, font: UIFont.systemFont(ofSize: 15), height: 40, action: {
                
            })
        }.build()
        
    }
}


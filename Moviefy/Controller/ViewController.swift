//
//  ViewController.swift
//  Moviefy - Base
//
//  Created by Adriana González Martínez on 3/12/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var movies: [Movie] = []
    var collectionView: UICollectionView!
    var sections: [Section] = []
    private var popMovies: [Movie] = []
    
    
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.view.backgroundColor = UIColor.white
        fetchPopular()

        fetUpcoming()

    }
    
    func setupCollectionView() {
        let sections = self.sections
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return sections[sectionIndex].layoutSection()
        }
        collectionView = UICollectionView(frame: view.safeAreaLayoutGuide.layoutFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: MovieCell.identifier, bundle: .main), forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.register(UINib(nibName: TitleCell.identifier, bundle: .main), forCellWithReuseIdentifier: TitleCell.identifier)
        
        
        self.view.addSubview(collectionView)
    }
    
    func fetchPopular(){
        
        APIClient.shared.getPopularMovies { (result) in
            switch result{
            case let .success(movies):
                DispatchQueue.main.async {
//                    self.movies = movies
                    var basicSection = MovieSection()
                    self.sections.append(TitleSection(title: "Popular Movies"))

                    basicSection.numberOfItems = movies.count
                    basicSection.items = movies
                    self.sections.append(basicSection)
                    self.setupCollectionView()
                    
                }
            case let .failure(error):
                print(error)
            }
        }
    
    }
    
    func fetUpcoming() {
        APIClient.shared.getUpcomingMovies { (result) in
            switch result{
            case let .success(movies):
                DispatchQueue.main.async {
//                    self.popMovies = movies

                    var upCompingSection = MovieSection()
                    self.sections.append(TitleSection(title: "Now Playing Movies"))

                    upCompingSection.numberOfItems = movies.count
                    upCompingSection.items = movies
                    self.sections.append(upCompingSection)
                    self.setupCollectionView()
                    
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        switch sections[indexPath.section] {
            
//        case is MovieSection:
//            let section = sections[indexPath.section] as! MovieSection
//
//            return section.configureCell(collectionView: collectionView, indexPath: indexPath)
            
//        case is UpcomingSection:
//            let section = sections[indexPath.section] as! UpcomingSection
//
//            return section.configureCell(collectionView: collectionView, indexPath: indexPath)
        default:
            
            return sections[indexPath.section].configureCell(collectionView: collectionView, indexPath: indexPath)
        }
        
    }
}

extension ViewController: UICollectionViewDelegate {}

//
//  DataSourceBridger.swift
//  ProtocolTableViewNCollectionView
//
//  Created by Pofat Diuit on 2016/11/25.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import UIKit

class BridgeDataSource: NSObject {
    var numberOfSections: (() -> Int)!
    var numberOfItemsInSection: ((Int) -> Int)!
    var tableCellAtIndexPath: ((UITableView, IndexPath) -> UITableViewCell)?
    var collectionCellAtIndexPath: ((UICollectionView, IndexPath) -> UICollectionViewCell)?
    var headerTitle: ((Int) -> String?)!
    var footerTitle: ((Int) -> String?)!

}

extension BridgeDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItemsInSection(section)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.collectionCellAtIndexPath.map { $0(collectionView, indexPath) } ?? UICollectionViewCell()
    }
    
}

extension BridgeDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableCellAtIndexPath.map { $0(tableView, indexPath) } ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerTitle(section)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.footerTitle(section)
    }
}


/// A container to keep dataSource, cellConfig protocol instance and
class DataSourceProvider<D: DataSourceProtocol, C: ReusableViewConfigProtocol> where D.Item == C.Item {
    var dataSource: D
    let cellConfig: C
    
    fileprivate var bridgeDataSource: BridgeDataSource!
    
    init(dataSource: D, cellConfig: C) {
        self.dataSource = dataSource
        self.cellConfig = cellConfig
    }
}


// Limit following code to be only visible to UITableView instance
extension DataSourceProvider where C.View: UITableViewCell {
    
    var tableViewDataSource: UITableViewDataSource {
        return self.createTableViewDataSource()
    }
    
    private func createTableViewDataSource() -> BridgeDataSource {
        if bridgeDataSource == nil {
            let source = BridgeDataSource()
            
            source.numberOfSections = { () -> Int in
                print("giving numberOfSections")
                return self.dataSource.numberOfSections()
            }
            
            source.numberOfItemsInSection = { (section) -> Int in
                
                return self.dataSource.numberOfItems(inSection: section)
            }
            
            source.tableCellAtIndexPath = { (tableView, indexPath) -> UITableViewCell in
                let item = self.dataSource.item(atRow: indexPath.row, inSection: indexPath.section)
                
                return self.cellConfig.tableCellFor(item: item!, tableView: tableView, indexPath: indexPath)
            }
            
            source.headerTitle = { section in
                return self.dataSource.headerTitle(inSection: section)
            }
            
            source.footerTitle = { section in
                return self.dataSource.footerTitle(inSection: section)
            }
            
            bridgeDataSource = source
        }
        
        return bridgeDataSource
    }
}

// Limit following code to be only visible to UICollectionView instance
extension DataSourceProvider where C.View: UICollectionViewCell {
    var collectionViewDataSource: UICollectionViewDataSource {
        return self.createCollectionViewDataSource()
    }
    
    private func createCollectionViewDataSource() -> BridgeDataSource {
        if bridgeDataSource == nil {
            let source = BridgeDataSource()
            
            source.numberOfSections = { () -> Int in
                return self.dataSource.numberOfSections()
            }
            
            source.numberOfItemsInSection = { (section) -> Int in
                return self.dataSource.numberOfItems(inSection: section)
            }
            
            source.collectionCellAtIndexPath = { (collectionView, indexPath) -> UICollectionViewCell in
                let item = self.dataSource.item(atRow: indexPath.row, inSection: indexPath.section)
                
                return self.cellConfig.collectionCellFor(item: item!, collectionView: collectionView, indexPath: indexPath)
            }
            
            source.headerTitle = { section in
                return self.dataSource.headerTitle(inSection: section)
            }
            
            source.footerTitle = { section in
                return self.dataSource.footerTitle(inSection: section)
            }
            
            bridgeDataSource = source
        }
        
        return bridgeDataSource
    }
}

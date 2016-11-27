//
//  DataSource.swift
//  ProtocolTableViewNCollectionView
//
//  Created by Pofat Diuit on 2016/11/23.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation


/// Protocol to present section info
protocol SectionInfoPresentable {
    associatedtype Item
    var items: [Item] { get set }
    
    var headerTitle: String? { get }
    
    var footerTitle: String? { get }
}

struct Section<Item>: SectionInfoPresentable {
    
    var items: [Item]
    
    let headerTitle: String?
    
    let footerTitle: String?
}


/// Protocol to present data source
protocol DataSourceProtocol {
    associatedtype Item
    
    func numberOfSections() -> Int
    
    func numberOfItems(inSection section: Int) -> Int
    
    func item(atRow row: Int, inSection section: Int) -> Item?
    
    func headerTitle(inSection section: Int) -> String?
    
    func footerTitle(inSection section: Int) -> String?
}

struct DataSource<S: SectionInfoPresentable>: DataSourceProtocol {
    var sections: [S]

    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        guard section < sections.count else {
            assert(false, "Section index out of bound")
        }
        
        return sections[section].items.count
    }
    
    func item(atRow row: Int, inSection section: Int) -> S.Item? {
        guard section < sections.count, row < sections[section].items.count else {
            assert(false, "Index out of bounds")
        }
        
        return sections[section].items[row]
    }
    
    func headerTitle(inSection section: Int) -> String? {
        guard section < sections.count else {
            assert(false, "Section index out of bound")
        }
        
        return sections[section].headerTitle
    }
    
    func footerTitle(inSection section: Int) -> String? {
        guard section < sections.count else {
            assert(false, "Section index out of bound")
        }
        
        return sections[section].footerTitle
    }
}


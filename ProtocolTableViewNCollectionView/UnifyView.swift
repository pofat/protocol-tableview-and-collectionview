//
//  UnifyView.swift
//  ProtocolTableViewNCollectionView
//
//  Created by Pofat Diuit on 2016/11/23.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import UIKit


/// Protocol to unify UITableView & UICollectionView
protocol CellParentViewProtocol {
    associatedtype CellType: UIView
    
    func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType
}

extension UICollectionView: CellParentViewProtocol {
    typealias CellType = UICollectionViewCell
    
    func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}

extension UITableView: CellParentViewProtocol {
    typealias CellType = UITableViewCell
    
    func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}


/// Protocol to unify UITableViewCell & UICollectionViewCell
protocol ReusableViewProtocol {
    associatedtype ParentView: UIView, CellParentViewProtocol
    
    // Already implmented in both cells
    var reuseIdentifier: String? { get }
    
    // Already implmented in both cells
    func prepareForReuse()
    
}

extension UICollectionViewCell: ReusableViewProtocol {
    typealias ParentView = UICollectionView
}

extension UITableViewCell: ReusableViewProtocol {
    typealias ParentView = UITableView
}


/// Protocol to configure cells
protocol ReusableViewConfigProtocol {
    associatedtype Item
    associatedtype View: ReusableViewProtocol
    
    func reuseIdentifierFor(item: Item?, indexPath: IndexPath) -> String
    
    func configure(view: View, item: Item?, parentView: View.ParentView, indexPath: IndexPath) -> View
}

extension ReusableViewConfigProtocol where View: UITableViewCell {
    func tableCellFor(item: Item, tableView: UITableView, indexPath: IndexPath) -> View {
        let cellId = self.reuseIdentifierFor(item: item, indexPath: indexPath)
        
        // CellParentViewProtocol
        let cell = tableView.dequeueReusableCellFor(identifier: cellId, indexPath: indexPath) as! View
        
        return self.configure(view: cell, item: item, parentView: tableView, indexPath: indexPath)
    }
}

extension ReusableViewConfigProtocol where View: UICollectionViewCell {
    func collectionCellFor(item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> View {
        let cellId = self.reuseIdentifierFor(item: item, indexPath: indexPath)
        
        let cell = collectionView.dequeueReusableCellFor(identifier: cellId, indexPath: indexPath) as! View
        
        return self.configure(view: cell, item: item, parentView: collectionView, indexPath: indexPath)
    }
}


/// Struct to create and config cells
struct ViewConfig<Item, Cell: ReusableViewProtocol>: ReusableViewConfigProtocol {
    let reuseId: String
    let configureClosure: (Cell, Item?, Cell.ParentView, IndexPath) -> Cell
    
    // Implement ResuableViewConfigProtocol
    typealias View = Cell
    
    func reuseIdentifierFor(item: Item?, indexPath: IndexPath) -> String {
        return reuseId
    }
    
    func configure(view: View, item: Item?, parentView: View.ParentView, indexPath: IndexPath) -> View {
        return configureClosure(view, item, parentView, indexPath)
    }
}


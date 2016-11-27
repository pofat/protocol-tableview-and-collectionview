//
//  ViewController.swift
//  ProtocolTableViewNCollectionView
//
//  Created by Pofat Diuit on 2016/11/23.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Items for tableView
    let itemData: [String] = ["cell 1", "cell 2", "cell 3", "cell 4"]
    // Items for collectionView
    let itemData_c: [UIColor] = [.green, .red, .orange, .yellow]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setups for UITableView
        
        let section = Section(items: itemData, headerTitle: "My table header", footerTitle: "My table footer")
        let data = DataSource(sections: [section])
        
        let config = ViewConfig<String, UITableViewCell>(reuseId: "cellId") { (cell, model, view, indexPath) -> UITableViewCell in
            // Decorate cells
            cell.textLabel?.text = model
            return cell
        }
        
        let provider = DataSourceProvider(dataSource: data, cellConfig: config)
        
        // provider.collectionViewDataSource is not visible to UITableView instance
        tableView.dataSource = provider.tableViewDataSource
        
        /* Uncomment following line will make compiler complain */
        // tableView.dataSource = provider.collectionViewDataSource
        
        
        
        // Setups for UICollectionView
        
        let section_c = Section(items: itemData_c, headerTitle: "My collection header", footerTitle: "My collection footer")
        let data_c = DataSource(sections: [section_c])
        
        let config_c = ViewConfig<UIColor, UICollectionViewCell>(reuseId: "collectionCellId") { cell, model, view, indexPath in
            // Decorate cells
            cell.backgroundColor = model!
            return cell
        }
        
        let provider_c = DataSourceProvider(dataSource: data_c, cellConfig: config_c)
        
        // provider.tableViewDtaSource is not visible to UICollection instance
        collectionView.dataSource = provider_c.collectionViewDataSource
        
         /* Uncomment following line will make compiler complain */
        // collectionView.dataSource = provider_c.tableViewDataSource
    }


}

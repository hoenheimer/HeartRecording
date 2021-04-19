//
//  RecordingListViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import UIKit


class RecordingListViewController: AnaLargeTitleTableViewController {
    override func configure() {
        super.configure()
        
        setTitle(title: "Recording List")
        setHeaderView(headerView: nil)
        
        tableView.backgroundColor = .clear
        tableView.register(RecordingTableViewCell.self, forCellReuseIdentifier: String(NSStringFromClass(RecordingTableViewCell.self)))
        tableView.rowHeight = 119
    }
    
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DbManager.manager.models.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(NSStringFromClass(RecordingTableViewCell.self)), for: indexPath) as! RecordingTableViewCell
        cell.setModel(DbManager.manager.models[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = DbManager.manager.models[indexPath.row]
        let vc = DetailViewController(model: model)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

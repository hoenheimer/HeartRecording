//
//  RecordingListViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import UIKit
import SwipeCellKit


class RecordingListViewController: AnaLargeTitleTableViewController, SwipeTableViewCellDelegate {
    var emptyView: UIView!
    var emptyImageView: UIImageView!
    var emptyLabel: UILabel!
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func configure() {
        super.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dbDidChanged), name: NotificationName.DbChange, object: nil)
        
        setTitle(title: "Recording List")
        setHeaderView(headerView: nil)
        
        tableView.backgroundColor = .clear
        tableView.register(RecordingTableViewCell.self, forCellReuseIdentifier: String(NSStringFromClass(RecordingTableViewCell.self)))
        tableView.rowHeight = 119
        
        emptyView = UIView()
        emptyView.backgroundColor = .clear
        emptyView.isHidden = DbManager.manager.models.count > 0
        tableView.addSubview(emptyView)
        
        emptyImageView = UIImageView()
        emptyImageView.image = UIImage(named: "RecordingList_Empty")
        emptyView.addSubview(emptyImageView)
        
        emptyLabel = UILabel()
        emptyLabel.text = "No Data！"
        emptyLabel.textColor = .black
        emptyLabel.font = .systemFont(ofSize: 16)
        emptyView.addSubview(emptyLabel)
    }
    
    
    @objc func dbDidChanged() {
        tableView.reloadData()
        emptyView.isHidden = DbManager.manager.models.count > 0
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyImageView.sizeToFit()
        emptyImageView.setOrigin(x: 0, y: 0)
        emptyLabel.sizeToFit()
        emptyLabel.center = CGPoint(x: emptyImageView.halfWidth(), y: emptyImageView.maxY() - 2 + emptyLabel.halfHeight())
        emptyView.bounds = CGRect(origin: .zero, size: CGSize(width: emptyImageView.width(), height: emptyLabel.maxY()))
        emptyView.center = CGPoint(x: tableView.halfWidth(), y: 265)
    }
    
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DbManager.manager.models.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(NSStringFromClass(RecordingTableViewCell.self)), for: indexPath) as! RecordingTableViewCell
        cell.delegate = self
        cell.setModel(DbManager.manager.models[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = DbManager.manager.models[indexPath.row]
        let vc = DetailViewController(model: model)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - SwipeTableViewCellDelegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
            let edit = SwipeAction(style: .default, title: nil) {
                [weak self] (_, indexPath) in
                guard let self = self else { return }
                let model = DbManager.manager.models[indexPath.row]
                let vc = DetailViewController(model: model)
                vc.modalPresentationStyle = .fullScreen
                vc.editWhenAppear = true
                self.present(vc, animated: true, completion: nil)
            }
            edit.backgroundColor = .clear
            edit.image = UIImage(named: "RecordingList_Edit")
            
            let delete = SwipeAction(style: .default, title: nil) {
                (_, indexPath) in
                let model = DbManager.manager.models[indexPath.row]
                DbManager.manager.deleteModel(model)
            }
            delete.backgroundColor = .clear
            delete.image = UIImage(named: "RecordingList_Delete")
            
            return [delete, edit]
        } else {
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.backgroundColor = .clear
        options.maximumButtonWidth = 91
        return options
    }
}

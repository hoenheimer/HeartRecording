//
//  RecordingListViewController.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/19.
//

import UIKit
import SwipeCellKit


class RecordingListViewController: AnaLargeTitleTableViewController, SwipeTableViewCellDelegate {
	var hintImageView: UIImageView!
    var ana_emptyView: UIView!
    var ana_emptyImageView: UIImageView!
    var ana_emptyLabel: UILabel!
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setProRightBarItemIfNeeded()
	}
    
    
    override func configure() {
        super.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dbDidChanged), name: NotificationName.DbRecordChange, object: nil)
        
        setTitle(title: "Recording List")
		setProRightBarItemIfNeeded()
        setHeaderView(headerView: nil)
		
		hintImageView = UIImageView(image: UIImage(named: "Kick_Hint"))
		view.addSubview(hintImageView)
		view.sendSubviewToBack(hintImageView)
        
        ana_tableView.backgroundColor = .clear
        ana_tableView.register(RecordingTableViewCell.self, forCellReuseIdentifier: String(NSStringFromClass(RecordingTableViewCell.self)))
        ana_tableView.rowHeight = 110
        
        ana_emptyView = UIView()
        ana_emptyView.backgroundColor = .clear
        ana_emptyView.isHidden = DbManager.manager.models.count > 0
        ana_tableView.addSubview(ana_emptyView)
        
        ana_emptyImageView = UIImageView()
        ana_emptyImageView.image = UIImage(named: "RecordingList_Empty")
        ana_emptyView.addSubview(ana_emptyImageView)
        
        ana_emptyLabel = UILabel()
        ana_emptyLabel.text = "No Data!"
        ana_emptyLabel.textColor = .color(hexString: "#6a515e")
        ana_emptyLabel.font = UIFont(name: "Merriweather-Regular", size: 18)
        ana_emptyView.addSubview(ana_emptyLabel)
    }
    
    
    @objc func dbDidChanged() {
        ana_tableView.reloadData()
        ana_emptyView.isHidden = DbManager.manager.models.count > 0
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
		hintImageView.sizeToFit()
		hintImageView.setOrigin(x: 0, y: 0)
        ana_emptyImageView.sizeToFit()
        ana_emptyImageView.setOrigin(x: 0, y: 0)
        ana_emptyLabel.sizeToFit()
        ana_emptyLabel.center = CGPoint(x: ana_emptyImageView.halfWidth(), y: ana_emptyImageView.maxY() + 3 + ana_emptyLabel.halfHeight())
        ana_emptyView.bounds = CGRect(origin: .zero, size: CGSize(width: ana_emptyImageView.width(), height: ana_emptyLabel.maxY()))
		ana_emptyView.center = CGPoint(x: ana_tableView.halfWidth(), y: ana_tableView.height() * 0.45)
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
		FeedbackManager.feedback(type: .light)
        let model = DbManager.manager.models[indexPath.row]
		navigationController?.pushViewController(DetailViewController(model: model), animated: true)
    }
    
    
    // MARK: - SwipeTableViewCellDelegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
            let edit = SwipeAction(style: .default, title: nil) {
                [weak self] (_, indexPath) in
                guard let self = self else { return }
                let model = DbManager.manager.models[indexPath.row]
//                NameEditAlert.show(name: model.name, id: model.id!, vc: self, success: nil)
            }
            edit.backgroundColor = .clear
            edit.image = UIImage(named: "RecordingList_Edit")
            
            let delete = SwipeAction(style: .default, title: nil) {
                [weak self] (_, indexPath) in
                guard let self = self else { return }
                let vc = UIAlertController(title: nil, message: "Are you sure you want to delete this recording file?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "YES", style: .destructive) {
                    [indexPath, weak vc] (_) in
                    guard let vc = vc else { return }
                    let model = DbManager.manager.models[indexPath.row]
                    DbManager.manager.deleteModel(model)
                    vc.dismiss(animated: true, completion: nil)
                }
                vc.addAction(yes)
                let no = UIAlertAction(title: "NO", style: .cancel) {
                    [weak vc] _ in
                    guard let vc = vc else { return }
                    vc.dismiss(animated: true, completion: nil)
                }
                vc.addAction(no)
                self.present(vc, animated: true, completion: nil)
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

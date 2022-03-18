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
	var ana_nameEditView: NameEditView!
	
	var ana_editingNameModelId: Int?
    
    
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
        
        setTitle(title: "List")
		setProRightBarItemIfNeeded()
        setHeaderView(headerView: nil)
		
		hintImageView = UIImageView(image: UIImage(named: "Kick_Hint"))
		view.addSubview(hintImageView)
		view.sendSubviewToBack(hintImageView)
        
        ana_tableView.backgroundColor = .clear
        ana_tableView.register(RecordingTableViewCell.self, forCellReuseIdentifier: String(NSStringFromClass(RecordingTableViewCell.self)))
        ana_tableView.rowHeight = 114
        
        ana_emptyView = UIView()
        ana_emptyView.backgroundColor = .clear
        ana_emptyView.isHidden = DbManager.manager.models.count > 0
        ana_tableView.addSubview(ana_emptyView)
        
        ana_emptyImageView = UIImageView()
        ana_emptyImageView.image = UIImage(named: "RecordingList_Empty")
        ana_emptyView.addSubview(ana_emptyImageView)
        
        ana_emptyLabel = UILabel()
        ana_emptyLabel.text = "No Data!"
        ana_emptyLabel.textColor = .color(hexString: "#504278")
        ana_emptyLabel.font = UIFont(name: "Didot", size: 18)
        ana_emptyView.addSubview(ana_emptyLabel)
		
		ana_nameEditView = NameEditView()
		ana_nameEditView.savePipe.output.observeValues {
			[weak self] name in
			guard let self = self else { return }
			if self.ana_editingNameModelId != nil && name != nil {
				DbManager.manager.updateName(name!, id: self.ana_editingNameModelId!)
			}
		}
		view.addSubview(ana_nameEditView)
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
		ana_nameEditView.frame = view.bounds
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
				self.ana_editingNameModelId = model.id
				self.ana_nameEditView.show(content: model.name)
            }
            edit.backgroundColor = .clear
            edit.image = UIImage(named: "RecordingList_Edit")
            
            let delete = SwipeAction(style: .default, title: nil) {
                (_, indexPath) in
				let model = DbManager.manager.models[indexPath.row]
				RecordingListDeleteView.shared.show(model: model)
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

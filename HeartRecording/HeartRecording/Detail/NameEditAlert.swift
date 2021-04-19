//
//  NameEditAlert.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/20.
//

import Foundation


class NameEditAlert {
    class func show(name: String?, id: Int, vc: UIViewController, success:((String) -> Void)?) {
        let alert = UIAlertController(title: "Recording Name", message: nil, preferredStyle: .alert)
        alert.addTextField {
            textField in
            textField.placeholder = name
        }
        let done = UIAlertAction(title: "Done", style: .default) {
            [weak alert] _ in
            guard let alert = alert else { return }
            if let newName = alert.textFields?.first?.text {
                if newName.count > 0 {
                    DbManager.manager.updateName(newName, id: id)
                    if success != nil {
                        success!(newName)
                    }
                }
            }
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(done)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            [weak alert] _ in
            guard let alert = alert else { return }
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
}

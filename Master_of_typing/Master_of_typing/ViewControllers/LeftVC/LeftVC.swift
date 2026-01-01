//
//  LeftVC.swift
//  Master_of_typing
//
//  Created by Macbook Pro on 09/12/2025.
//

import Cocoa

class LeftVC: NSViewController {

    @IBOutlet weak var leftCollectionView: NSCollectionView!
    @IBOutlet weak var proButton: NSButton!
    @IBOutlet weak var proBox: NSBox!

    weak var delegate: GetSelectedViewControllerProtocol?
    var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)

    let array = [["title": "Lessons", "img": "imgLesson1"],
                 ["title": "Stats", "img": "imgStats1"],
                 ["title": "Practice", "img": "imgPractice1"],
                 ["title": "Dictation", "img": "imgDictation1"],
                 ["title": "Test", "img": "imgTest1"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftCollectionView.delegate = self
        leftCollectionView.dataSource = self
        proBox.isHidden = App.isPro
    }
    
    @IBAction func proButtonAction(_ sender: Any) {
        let vc = ProVC(nibName: "ProVC", bundle: nil)
        presentAsSheet(vc)
    }
}

extension LeftVC: NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier( "LeftCVC"), for: indexPath) as? LeftCVC else {return NSCollectionViewItem()}
        let item = indexPath.item
        let data = array[item]
        cell.view.wantsLayer = true
        cell.label.stringValue = data["title"] ?? ""
        cell.img.image = NSImage(named: data["img"] ?? "")
        
        if indexPath == selectedIndex{
            if item == 0 {
                cell.img.image = NSImage(named: "imgLesson2") ?? NSImage()
            }else if item == 1 {
                cell.img.image = NSImage(named: "imgStats2") ?? NSImage()

            }else if item == 2 {
                cell.img.image = NSImage(named: "imgPractice2") ?? NSImage()

            }else if item == 3 {
                cell.img.image = NSImage(named: "imgDictation2") ?? NSImage()

            }else if item == 4 {
                cell.img.image = NSImage(named: "imgTest2") ?? NSImage()

            }
            cell.box.isHidden = false
        }else{
            if item == 0 {
                cell.img.image = NSImage(named: "imgLesson1") ?? NSImage()
            }else if item == 1 {
                cell.img.image = NSImage(named: "imgStats1") ?? NSImage()

            }else if item == 2 {
                cell.img.image = NSImage(named: "imgPractice1") ?? NSImage()

            }else if item == 3 {
                cell.img.image = NSImage(named: "imgDictation1") ?? NSImage()

            }else if item == 4 {
                cell.img.image = NSImage(named: "imgTest1") ?? NSImage()

            }
            cell.box.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {return}
        selectedIndex = indexPath
        delegate?.getSelectedIndex(index: indexPath.item)
        collectionView.reloadData()
        collectionView.deselectAll(indexPath)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        NSSize(width: collectionView.frame.width , height: 70)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}

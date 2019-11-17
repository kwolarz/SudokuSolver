//
//  SudokuVC.swift
//  SudokuSolver
//
//  Created by Krzysztof Wolarz on 16/11/2019.
//  Copyright © 2019 Krzysztof Wolarz. All rights reserved.
//

import UIKit

class SudokuVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var gridCV: UICollectionView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //var indexes = [IndexPath]()
    
    var selectedX = Int()
    var selectedY = Int()
    
    var grid = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    
    var solvedGrid = [[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        solvedGrid = grid
        
        infoLabel.text = "Wypełnij odpowiednie pola i naciśnij SOLVE"
        gridCV.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //indexes.append(indexPath)
        let cell = collectionView.cellForItem(at: indexPath) as! SudokuCell
        cell.backgroundColor = .systemBlue
        let selected = grid[indexPath.section][indexPath.row]
        selectedX = indexPath.section
        selectedY = indexPath.row
        print(selected)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SudokuCell
        cell.backgroundColor = .tertiaryLabel

        //gridCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SudokuCell
        let item = solvedGrid[indexPath.section][indexPath.row]
        if item != 0{
            cell.valueLabel.text = String(item)
        }else {
            cell.valueLabel.text = ""
        }
        cell.backgroundColor = .tertiaryLabel
        //solvedGrid = grid
        return cell
    }
    
    
    //MARK: - Buttons fun
    @IBAction func button1(_ sender: UIButton) {setGridValue(index: 1)}
    @IBAction func button2(_ sender: UIButton) {setGridValue(index: 2)}
    @IBAction func button3(_ sender: UIButton) {setGridValue(index: 3)}
    @IBAction func button4(_ sender: UIButton) {setGridValue(index: 4)}
    @IBAction func button5(_ sender: UIButton) {setGridValue(index: 5)}
    @IBAction func button6(_ sender: UIButton) {setGridValue(index: 6)}
    @IBAction func button7(_ sender: UIButton) {setGridValue(index: 7)}
    @IBAction func button8(_ sender: UIButton) {setGridValue(index: 8)}
    @IBAction func button9(_ sender: UIButton) {setGridValue(index: 9)}
    
    func setGridValue(index: Int){
        solvedGrid[selectedX][selectedY] = index
        gridCV.reloadData()
        //gridCV.reloadItems(at: indexes)
        
    }
    
    //MARK: - Algorythm Magic
    func canInsert(x: Int, y: Int, value: Int) -> Bool{
        for i in 0...8{
            if value == solvedGrid[x][i] || value == solvedGrid[i][y] || value == solvedGrid[x/3*3+i%3][y/3*3+i/3]{
                return false
            }
        }
        return true
    }
    
    func next(x: Int, y: Int) -> Bool{
        if x == 8 && y == 8{return true}
        else if x == 8 {return self.solve(x: 0, y: y+1)}
        else {return self.solve(x: x+1, y: y)}
    }
    
    func solve(x: Int, y: Int) -> Bool{
        if solvedGrid[x][y] == 0{
            for i in 1...9{
                if canInsert(x: x, y: y, value: i){
                    solvedGrid[x][y] = i
                    if next(x: x, y: y){return true}
                }
            }
            solvedGrid[x][y] = 0
            return false
        }
        return next(x: x, y: y)
    }
    
    
    @IBAction func solveButtonClicked(_ sender: UIButton) {
        //solvedGrid = grid
        indicator.startAnimating()
        if solve(x: 0, y: 0){
            gridCV.reloadData()
            infoLabel.text = "Gotowe!"
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
        }else {
            infoLabel.text = "Niemożliwe do zrealizowania"
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
        }
    }
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        solvedGrid = grid
        gridCV.reloadData()
        infoLabel.text = "Wypełnij odpowiednie pola i naciśnij SOLVE"
    }
    
    
    //MARK: - number o cells
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return grid.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grid[section].count
    }
    
    //MARK: - How collection view looks
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 37, height: 37)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
    }
}

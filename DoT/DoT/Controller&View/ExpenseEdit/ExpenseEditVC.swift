//
//  ExpenseEditViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/21/24.
//

import UIKit
import PhotosUI

class ExpenseEditViewController: BaseViewController<ExpenseEditView> {
    
    private var categoryDataSource: UICollectionViewDiffableDataSource<CategoryCompositionalLayout, ExpenseCategory>!
    // private var photoDataSource: UICollectionViewDiffableDataSource<PhotoCompositionalLayout, AnyHashable>!
    let expenseEditVM = ExpenseEditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
        
        expenseEditVM.inputCheckSaveButtonEnabledListener.data = ()
    }
    
    override func configure() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        layoutView.mainScrollView.addGestureRecognizer(tapGesture)
        
        guard let tripDetailInfo = expenseEditVM.tripDetailInfo else { return }
        layoutView.configure(data: tripDetailInfo)
        
        layoutView.expenseTextField.addTarget(self, action: #selector(expenseValueChanged), for: .editingChanged)
        layoutView.placeTextField.addTarget(self, action: #selector(placeValueChanged), for: .editingChanged)
        layoutView.editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        layoutView.memoTextView.delegate = self
        
        layoutView.expenseTextField.delegate = self
        layoutView.placeTextField.delegate = self
    }
    
    override func bindData() {
        
        // Category 선택된 셀 이외 모두 선택 끄기
        expenseEditVM.outputCategoryButtonClickedListener.bind { [weak self] category in
            
            guard let self, let category else { return }
            
            for idx in 0 ..< ExpenseCategory.allCases.count {
                let indexPath = IndexPath(item: idx, section: 0)
                guard let cell = layoutView.categoryCollectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
                cell.update(data: category)
            }
        }
        
        // 수정 버튼 클릭 활성화 여부 체크
        expenseEditVM.outputCheckSaveButtonEnabledListener.bind { [weak self] isEnabled in
            
            guard let self else { return }
            
            layoutView.editButton.isEnabled = isEnabled
        }
        
        // 이미지 선택 시 사진 콜렉션뷰 업데이트
        expenseEditVM.outputImageDataListener.bind { [weak self] datas in
            
            guard let self else { return }
            
            update()
        }
    }
    
    override func configureNavigation() {
        
        navigationController?.topViewController?.title = "가나다라"
    }
    
    override func configureCollectionView() {
        
        layoutView.categoryCollectionView.showsHorizontalScrollIndicator = false
        
        // MARK: Category Collecion View
        let categoryRegistration = UICollectionView.CellRegistration<CategoryCollectionViewCell, ExpenseCategory> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self, let tripDetailInfo = expenseEditVM.tripDetailInfo else { return }
            
            // Category Button Selected
            expenseEditVM.inputCategoryButtonClickedListener.data = tripDetailInfo.category
            cell.configure(data: itemIdentifier)
            cell.categoryButton.tag = indexPath.item
            cell.categoryButton.addTarget(self, action: #selector(self.categoryButtonClicked), for: .touchUpInside)
            cell.update(data: tripDetailInfo.category)
        }
        
        categoryDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.categoryCollectionView) {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: categoryRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            
            return cell
        }
        
        // layoutView.photoCollectionView.showsHorizontalScrollIndicator = false
        
        // MARK: Photo Collecion View
        // let photoRegistration = UICollectionView.CellRegistration<PhotoCollectionViewCell, AnyHashable> { [weak self] cell, indexPath, itemIdentifier in
        //     
        //     guard let self else { return }
        //     
        //     let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageSelectedButtonTapped))
        //     cell.photoImageView.addGestureRecognizer(tapGesture)
        //     guard let imageData = itemIdentifier as? Data, let image = UIImage(data: imageData) else { return }
        //     
        //     cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        //     cell.deleteButton.tag = imageData.hashValue
        //     
        //     cell.configure(data: image)
        // }
        
        // photoDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.photoCollectionView) {collectionView, indexPath, itemIdentifier in
        //     
        //     let cell = collectionView.dequeueConfiguredReusableCell(using: photoRegistration,
        //                                                             for: indexPath,
        //                                                             item: itemIdentifier)
        //     
        //     return cell
        // }
    }
    
    // 지출 변경
    @objc private func expenseValueChanged(_ sender: UITextField) {
        
        guard let input = sender.text else { return }
        
        let result = input.convertDecimalString()
        sender.text = result
        
        expenseEditVM.inputExpenseListener.data = result
        expenseEditVM.inputCheckSaveButtonEnabledListener.data = ()
    }
    
    // 장소 입력
    @objc private func placeValueChanged(_ sender: UITextField) {
        
        guard let place = sender.text else { return }
        
        if place.isWhiteSpace() {
            sender.text = ""
        }
        
        expenseEditVM.inputPlaceListener.data = place
    }
    
    // 카테고리 선택 버튼 클릭
    @objc private func categoryButtonClicked(sender: UIButton) {
        
        guard let category = ExpenseCategory(rawValue: sender.tag) else { return }
        
        expenseEditVM.inputCategoryButtonClickedListener.data = category
    }
    
    // 수정 버튼 클릭
    @objc private func editButtonClicked(sender: UIButton) {
        
        expenseEditVM.inputEditButtonClickedListener.data = ()
    }
    
    // 사진첩 선택
    @objc private func imageSelectedButtonTapped(sender: UITapGestureRecognizer) {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        let phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
        
        present(phPicker, animated: true)
    }
    
    @objc private func deleteButtonClicked(sender: UIButton) {
        
        let dataHashVaulue = sender.tag
        var datas = expenseEditVM.inputImageDataListener.data
        
        for idx in 0 ..< datas.count {
            if datas[idx].hashValue == dataHashVaulue {
                datas.remove(at: idx)
                break
            }
        }
        
        expenseEditVM.inputImageDataListener.data = datas
    }
    
    // 키보드 내리기
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        
        layoutView.endEditing(true)
    }
}

extension ExpenseEditViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }
        
        expenseEditVM.inputImageDataListener.data = []
        
        for idx in 0 ..< results.count {
            
            let itemProvider = results[idx].itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] readingImage, error in
                    
                    guard let self, let image = readingImage as? UIImage else { return }
                    
                    guard let data = image.jpegData(compressionQuality: 1.0) else { return }
                    
                    self.expenseEditVM.inputImageDataListener.data.append(data)
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
}

extension ExpenseEditViewController: UITextFieldDelegate {
    
    // 소수점 3자리 이상부터는 입력 불가
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField != layoutView.expenseTextField { return true }
        
        guard let text = textField.text else { return true }
        
        return expenseEditVM.limitDecimalPoint(text, range: range.location)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension ExpenseEditViewController: UITextViewDelegate {
    
    // 메모 입력
    func textViewDidChange(_ textView: UITextView) {
        
        guard let memo = textView.text else { return }
        
        expenseEditVM.inputMemoListener.data = memo
    }
}

extension ExpenseEditViewController {
    
    private func update() {
        
        // Category Snapshot
        var categorySnapshot = NSDiffableDataSourceSnapshot<CategoryCompositionalLayout, ExpenseCategory>()
        categorySnapshot.appendSections([.category])
        
        categorySnapshot.appendItems(ExpenseCategory.allCases, toSection: .category)
        
        self.categoryDataSource.apply(categorySnapshot, animatingDifferences: true)
        
        // Photo Snapshot
        // var photoSnapshot = NSDiffableDataSourceSnapshot<PhotoCompositionalLayout, AnyHashable>()
        // photoSnapshot.appendSections([.photo])
        // 
        // let datas = self.expenseEditVM.outputImageDataListener.data
        // if !datas.isEmpty {
        //     photoSnapshot.appendItems(datas, toSection: .photo)
        // }
        // photoSnapshot.appendItems(["plus Photo"], toSection: .photo)
        
        
        // self.photoDataSource.apply(photoSnapshot, animatingDifferences: true)
    }
}

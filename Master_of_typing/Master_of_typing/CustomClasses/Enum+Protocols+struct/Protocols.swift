import Foundation
import AppKit

//protocol SelectFirstIndex: AnyObject {
//    func selectFirstIndex()
//}
//protocol GetTextForPrint: AnyObject{
//    func getTextForPrint(string: String)
//}
//protocol UserInteractionCheck: AnyObject{
//    func checkInteraction()
//    func makeDisableInteraction()
//}
//protocol GetImageFromPreview: AnyObject{
//    func getImage(image: NSImage)
//}
//protocol ImageScalingModeDelegate: AnyObject{
//    func didChangeImageScalingMode(_ mode: ImageScalingMode)
//    func makeImageAs(image: NSImage,mode: checkImageMode)
//    func applyImageFilet(filterName: FilterType)
//}
//protocol ShowPopUpTextView: AnyObject {
//    func showTextViewPopUp(text: String)
//}
//protocol LayerView: AnyObject {
//    var layer: CALayer? { get }
//    var superview: NSView? { get }
//}
protocol GetSelectedViewControllerProtocol: AnyObject {
    func getSelectedIndex(index: Int)
}
protocol GetSelectedIndexNameProtocol: AnyObject{
//    func getSelectedIndexName(name: String,view: LeftCVC)
}

protocol SpeechSpeedDelegate: AnyObject {
    func didChangeVoice(to voiceIdentifier: String)   // Apple uses identifier, not language code
    func didChangeSpeechSpeed(to multiplier: Float)   // 0.5 – 2.0
}

protocol LessonCompleted: AnyObject{
    func lessonCompleted()
}
//protocol UserInteractionEnable: AnyObject{
//    func enableInteraction()
//    func disableInteraction()
//    func passImageForOCR(image: NSImage)
//}

//protocol TextEditOption: AnyObject{
//    func fontMenu(fontName: String, fontSize: CGFloat)
//    func sizeMenu(fontName: String, fontSize: CGFloat)
//    func bold()
//    func italic()
//    func underline()
//    func strikeThrough()
//    func leftAlign()
//    func rightAlign()
//    func middleAlign()
//    func justfiedAlign()
//    func textColor()
//}
//protocol ResizeCollectionView: AnyObject{
//    func deleteItemImage()
//}
//protocol GetFileURLProtocol: AnyObject{
//    func downloadItem(index: IndexPath)
//    func printItem(index: IndexPath)
//    func shareItem(index: IndexPath,cellView: NSButton)
//    func renameItem(index: IndexPath)
//    func deleteItem(index: IndexPath)
//}

//protocol SideBarViewControllerChatDelegate: AnyObject {
//    func sideBarViewController(_ viewController: AiChatHistory, didSelectChat chat: CDChat)
//}

//protocol HistoryCollectionViewCellDelegate: AnyObject {
//    func historyCollectionViewCell(_ cell: AiChatHistory, didTapRenameChat chat: CDChat)
//    func historyCollectionViewCell(_ cell: AiChatHistory, didTapDeleteChat chat: CDChat)
//    func historyCollectionViewCell(_ cell: AiChatHistory, didTapShareChat chat: CDChat)
//}

//protocol TableViewCellDelegate: AnyObject {
//    func tableCellView(_ cell: NSTableCellView, didTapRegenrateForRow row: Int)
//    func tableCellView(_ cell: NSTableCellView, didTapLikeForRow row: Int)
//    func tableCellView(_ cell: NSTableCellView, didTapDislikeForRow row: Int)
//    func tableCellView(_ cell: NSTableCellView, didTapCopyForRow row: Int)
//    func tableCellView(_ cell: NSTableCellView, didTapShareForRow row: Int)
//    func tableCellView(_ cell: NSTableCellView, didTapSpeakForRow row: Int)
//}

//protocol CollectionViewDisabled: AnyObject {
//    func collectionViewDisabled()
//    func enableCollectionView()
//}
//protocol GetCompressFileURLProtocol: AnyObject{
//    func downloadItem(index: IndexPath)
//    func seeItem(index: IndexPath)
//    func deleteItem(index: IndexPath, cell: CompressPdfCVC)
//    func getCurrentView(view: CompressPdfCVC,indeX: IndexPath)
//    func makeUpdateFile(index: IndexPath,cell: CompressPdfCVC,url: URL)
//}
//protocol GoToSeeAllVCProtocol: AnyObject {
//    func goToSeeAllVC(index: IndexPath)
//}
//protocol GoToEditorVCImageProtocol: AnyObject{
//    func getImageandGoToEditor(image: NSImage)
//}
//protocol HistoryCoreDataModel: AnyObject {
//    func deleteHistory(index: IndexPath)
//    func renameHistory(index: IndexPath)
//    func printHistory(index: IndexPath)
//    func shareHistory(index: IndexPath,cellView: RecentCVC)
//}

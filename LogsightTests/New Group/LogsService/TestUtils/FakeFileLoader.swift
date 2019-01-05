import Foundation
@testable import Logsight

class FakeFileLoader: FileLoader {
    var delegate: FileLoaderDelegate?
    
    func startReadingExistingSecurityBookmarks() {}
    
    func loadFile(withURL url: URL) {}
    
    func stopReadingAndForget(application: Application) {}
}

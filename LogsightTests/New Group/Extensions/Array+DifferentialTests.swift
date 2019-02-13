import XCTest
import Quick
import Nimble
@testable import Logsight

class ArrayDifferentialTests: QuickSpec {

    let intComparison: (Int, Int) -> ComparisonResult = { a, b in
        if a < b { return .orderedAscending }
        else if a > b { return .orderedDescending }
        else { return .orderedSame }
    }
    
    override func spec() {
        describe("diffentialUpdateFilter") {
            context("when filter becomes more restrictive") {
                it("it only produce removals in the diff") {
                    let (newList, diffs) = [2, 3].differentialUpdateFilter(
                        unfilteredList: [1, 2, 3, 4],
                        wasKeeping: { [2, 3].contains($0) },
                        nowKeeps: { [2].contains($0) }
                    )
                    
                    expect(newList).to(equal([2]))
                    expect(diffs.added).to(beEmpty())
                    expect(diffs.removed).to(equal([1]))
                }
            }
            
            context("when filter becomes more inclusive") {
                it("it only produce additions in the diff") {
                    let (newList, diffs) = [2, 3].differentialUpdateFilter(
                        unfilteredList: [1, 2, 3, 4],
                        wasKeeping: { [2, 3].contains($0) },
                        nowKeeps: { [2, 3, 4].contains($0) }
                    )
                    
                    expect(newList).to(equal([2, 3, 4]))
                    expect(diffs.added).to(equal([2]))
                    expect(diffs.removed).to(beEmpty())
                }
            }
            
            context("when filter doesn't change") {
                it("it produces no diff") {
                    let (newList, diffs) = [2, 3].differentialUpdateFilter(
                        unfilteredList: [1, 2, 3, 4],
                        wasKeeping: { [2, 3].contains($0) },
                        nowKeeps: { [2, 3].contains($0) }
                    )
                    
                    expect(newList).to(equal([2, 3]))
                    expect(diffs.added).to(beEmpty())
                    expect(diffs.removed).to(beEmpty())
                }
            }
            
            context("when the filter changes entirely") {
                it("it produces the right diff") {
                    let (newList, diffs) = [2, 4].differentialUpdateFilter(
                        unfilteredList: [1, 2, 3, 4, 5, 6],
                        wasKeeping: { [2, 4].contains($0) },
                        nowKeeps: { [1, 2, 3, 5].contains($0) }
                    )
                    
                    expect(newList).to(equal([1, 2, 3, 5]))
                    expect(diffs.added).to(equal([0, 2, 3]))
                    expect(diffs.removed).to(equal([1]))
                }
            }
        }
        
        describe("differentialFilter") {
            context("when the initial list is empty") {
                let emptyList: [Int] = []
             
                it("does nothing") {
                    let (newList, diffs) = emptyList.differentialFilter(onlyKeep: { $0 == 1 })
                    
                    expect(newList).to(beEmpty())
                    expect(diffs.added).to(beEmpty())
                    expect(diffs.removed).to(beEmpty())
                }
            }
            
            context("when the list contains elements") {
                let list = [5, 6, 6, 10, 10, 12, 15]
                
                it("can filter out doublons, first and last elements") {
                    let (newList, diffs) = list.differentialFilter(onlyKeep: { [6, 12].contains($0) })
                    
                    expect(newList).to(equal([6, 6, 12]))
                    expect(diffs.added).to(beEmpty())
                    expect(diffs.removed).to(equal([6, 4, 3, 0]))
                }
                
                it("can filter everything") {
                    let (newList, diffs) = list.differentialFilter(onlyKeep: { elem in false })
                    
                    expect(newList).to(equal([]))
                    expect(diffs.added).to(beEmpty())
                    expect(diffs.removed).to(equal([Int](0..<7).reversed()))
                }
            }
        }
        
        describe("differentialAdd") {
            context("when the initial list is empty") {
                let emptyList: [Int] = []
                
                it("simply set the new items") {
                    let (newList, diffs) = emptyList.differentialAdd(
                        [1, 2, 3], orderWith: self.intComparison
                    )
                    
                    expect(newList).to(equal([1, 2, 3]))
                    expect(diffs.added).to(equal([0, 1, 2]))
                    expect(diffs.removed).to(beEmpty())
                }
            }
    
            context("when the initial list already contains elements") {
                let list = [5, 10, 15]
                
                it ("adds new bigger elements in the end") {
                    let (newList, diffs) = list.differentialAdd(
                        [16, 17], orderWith: self.intComparison
                    )
                    
                    expect(newList).to(equal([5, 10, 15, 16, 17]))
                    expect(diffs.added).to(equal([3, 4]))
                    expect(diffs.removed).to(beEmpty())
                }
                
                it ("adds new smaller elements at the beginning") {
                    let (newList, diffs) = list.differentialAdd(
                        [3, 4], orderWith: self.intComparison
                    )
                    
                    expect(newList).to(equal([3, 4, 5, 10, 15]))
                    expect(diffs.added).to(equal([0, 1]))
                    expect(diffs.removed).to(beEmpty())
                }
                
                it ("can combine adding at the begining, middle and end") {
                    let (newList, diffs) = list.differentialAdd(
                        [4, 8, 12, 13, 16], orderWith: self.intComparison
                    )
                    
                    expect(newList).to(equal([4, 5, 8, 10, 12, 13, 15, 16]))
                    expect(diffs.added).to(equal([0, 2, 4, 5, 7]))
                    expect(diffs.removed).to(beEmpty())
                }
                
                it("does nothing if new items is empty") {
                    let (newList, diffs) = list.differentialAdd(
                        [], orderWith: self.intComparison
                    )
                    
                    expect(newList).to(equal(list))
                    expect(diffs.added).to(beEmpty())
                    expect(diffs.removed).to(beEmpty())
                }
            }
            
            context("when a filter is used") {
                let list = [5, 10, 15]
                
                it("does't add items that don't pass the filters") {
                    let (newList, diffs) = list.differentialAdd(
                        [4, 8, 12, 13, 16],
                        filteredBy: { [4, 12, 16].contains($0) },
                        orderWith: self.intComparison
                    )
                    
                    expect(newList).to(equal([4, 5, 10, 12, 15, 16]))
                    expect(diffs.added).to(equal([0, 3, 5]))
                    expect(diffs.removed).to(beEmpty())
                }
            }
        }
    }
}

import Foundation

extension Array {
    
    /// Filters the `unfilteredList` using `nowKeeps`,
    /// and provide a list of diff, nowing what the
    /// previous filter `wasKeeping`.
    func differentialUpdateFilter(
        unfilteredList: [Element],
        wasKeeping oldFilter: (Element) -> Bool,
        nowKeeps newFilter: (Element) -> Bool
    ) ->([Element], Diffs) {
        var newList: [Element] = []
        var added: [Int] = []
        var removed: [Int] = []
        var currentIndexInPreviouslyFilteredList = 0
        
        // Loop through the complete list of items
        for item in unfilteredList {
            
            // If the item is now accepted, adds it to the result,
            // and adds its index in the `added` list if it wasn't
            // accepted by the old filter.
            if newFilter(item) {
                newList.append(item)
                
                if !oldFilter(item) {
                    added.append(newList.count - 1)
                }
            }
            
            // If the item is not accepted, doesn't add it to the
            // result, and if it was accepted before, add its old
            // index to the removed list.
            if !newFilter(item) && oldFilter(item) {
                removed.append(currentIndexInPreviouslyFilteredList)
            }
            
            // Increment the index to use for removals only
            // if the item was present in the previous list.
            if oldFilter(item) {
                currentIndexInPreviouslyFilteredList += 1
            }
        }
        
        return (newList, Diffs(added: added, removed: removed.reversed()))
    }
    
    /// Removes items that don't match the given filter from a list,
    /// and retains the changes through a list of diffs.
    func differentialFilter(
        onlyKeep filter: (Element) -> Bool
    ) -> ([Element], Diffs) {
        var newList: [Element] = []
        var removed: [Int] = []
        for (index, item) in self.enumerated() {
            if filter(item) {
                newList.append(item)
            } else {
                removed.append(index)
            }
        }
        
        return (newList, Diffs(removed: removed.reversed()))
    }

    /// Add new items to the list, respecting the order imposed by `orderWith`,
    /// and retaining the changes through a list of diffs.
    /// New items are expected to be already sorted.
    func differentialAdd(
        _ items: [Element],
        filteredBy filter: ((Element) -> Bool)? = nil,
        orderWith compare: (Element, Element) -> ComparisonResult
    ) -> ([Element], Diffs) {
        if self.isEmpty {
            return (items, Diffs(added: [Int](0..<items.count)))
        }
        
        // Get the first elligible new element
        guard let firstNewElement = items.first(where: { filter == nil || filter!($0) })
            else { return (self, Diffs()) }
        
        // Find the insertion point by going from the end
        // of the existing list to the beginning. This is
        // an optimization for the (largely dominant in
        // Logsight) case where we're adding new items
        // at the end of the list.
        var insertionPoint = self.count
        while insertionPoint > 0 && compare(self[insertionPoint - 1], firstNewElement) == .orderedDescending {
            insertionPoint -= 1
        }
        
        // From there, at each iteration, go up through the
        // list to find the new insertion point, until all
        // elements are added.
        var newList = self
        var added: [Int] = []
        for item in items {
            if filter != nil && !filter!(item) {
                continue
            }
            
            while newList.count > insertionPoint && compare(newList[insertionPoint], item) != .orderedDescending {
                insertionPoint += 1
            }
            
            newList.insert(item, at: insertionPoint)
            added.append(insertionPoint)
            insertionPoint = insertionPoint + 1
        }
        
        return (newList, Diffs(added: added))
    }
}

/// A diff in a list
struct Diffs {
    
    /// The list of rows that were added.
    let added: [Int]
    
    /// The list of rows that were removed, in reverse
    /// order so that it can be applied to a TableView
    /// update.
    let removed: [Int]
    
    init(added: [Int] = [], removed: [Int] = []) {
        self.added = added
        self.removed = removed
    }
}

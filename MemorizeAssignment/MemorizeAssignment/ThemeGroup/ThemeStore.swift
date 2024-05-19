import Foundation
import SwiftUI

extension UserDefaults {
    func themes(forKey key: String) -> [Theme] {
        if let jsonData = data(forKey: key),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            return decodedThemes
        }
        else {
            return []
        }
    }
    func set(_ themes: [Theme], forKey key: String) {
        let data = try? JSONEncoder().encode(themes)
        set(data, forKey: key)
    }
}


class ThemeStore: ObservableObject {
    let name: String
    
    var id: String { name }
    
    private var userDefaultsKey: String { "ThemeStore:" + name }
    
    var themes: [Theme] {
        get {
            UserDefaults.standard.themes(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                objectWillChange.send()
            }
        }
    }
    
    init(named name: String) {
        self.name = name
        if themes.isEmpty {
            themes = Theme.builtins
            if themes.isEmpty {
                themes = [Theme(name: "Warning", emojis: ["👍"], color:  RGBA(red:255, green: 0, blue: 0, alpha: 50))]
            }
        }
    }
    
    @Published private var _cursorIndex = 0
    
    var cursorIndex: Int {
        get { boundsCheckedThemeIndex(_cursorIndex)}
        set { _cursorIndex = boundsCheckedThemeIndex(newValue)}
    }
    
    private func boundsCheckedThemeIndex(_ index: Int) -> Int {
        var index = index % themes.count
        if index < 0 {
            index += themes.count
        }
        return index
    }
    
    // MARK: - Adding Palettes
    
    // these functions are the recommended way to add Palettes to the PaletteStore
    // since they try to avoid duplication of Identifiable-ly identical Palettes
    // by first removing/replacing any Palette with the same id that is already in palettes
    // it does not "remedy" existing duplication, it just does not "cause" new duplication
    
    func insert(_ theme: Theme, at insertionIndex: Int? = nil) -> Int { // "at" default is cursorIndex
        let insertionIndex = boundsCheckedThemeIndex(insertionIndex ?? cursorIndex)
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            themes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex)
            themes.replaceSubrange(insertionIndex...insertionIndex, with: [theme])
        }
        else if let index = themes.firstIndex(where: {$0.name == theme.name}){
            return index
        }
        else {
            themes.insert(theme, at: insertionIndex)
        }
        objectWillChange.send()
        return insertionIndex
    }
}

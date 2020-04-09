import Foundation

struct Note {
    let text: String
    let date: Date
}

enum NoteType {
    case newNote
    case updateNote
    case deleteNote
}

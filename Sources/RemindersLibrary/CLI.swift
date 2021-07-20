import ArgumentParser
import Foundation

private let reminders = Reminders()

private struct ShowLists: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Print the name of lists to pass to other commands")

    func run() {
        reminders.showLists()
    }
}

private struct Upcoming: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Show upcoming reminders")

    func run() {
        reminders.showUpcoming()
    }
}

private struct Show: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Print the items on the given list")

    @Argument(
        help: "The list to print items from, see 'show-lists' for names")
    var listName: String

    func run() {
        reminders.showListItems(withName: self.listName)
    }
}

private struct Anytime: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Print the anytime items on the given list")

    @Argument(
        help: "The list to print items from, see 'show-lists' for names")
    var listName: String

    func run() {
        reminders.showAnytimeListItems(withName: self.listName)
    }
}

private struct Add: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Add a reminder to a list")

    @Argument(
        help: "The list to add to, see 'show-lists' for names")
    var listName: String

    @Argument(
        parsing: .remaining,
        help: "The reminder contents")
    var reminder: [String]

    @Option(
        name: .shortAndLong,
        help: "The date the reminder is due")
    var dueDate: DateComponents?

    func run() {
        reminders.addReminder(
            string: self.reminder.joined(separator: " "),
            toListNamed: self.listName,
            dueDate: self.dueDate)
    }
}

private struct Complete: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Complete a reminder")

    @Argument(
        help: "The list to complete a reminder on, see 'show-lists' for names")
    var listName: String

    @Argument(
        help: "The index of the reminder to complete, see 'show' for indexes")
    var index: Int

    @Argument(
        help: "Complete an anytime reminder")
    var anytime: Bool?

    func run() {
        reminders.complete(itemAtIndex: self.index, onListNamed: self.listName, anytime: self.anytime)
    }
}

public struct CLI: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "reminders",
        abstract: "Interact with macOS Reminders from the command line",
        subcommands: [
            Add.self,
            Complete.self,
            Show.self,
            ShowLists.self,
            Upcoming.self,
            Anytime.self,
        ]
    )

    public init() {}
}

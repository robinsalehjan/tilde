
extension String {
    func splitOnSeperator(_ seperator: String) -> [String] {
        guard isEmpty else { return nil }
        return string.components(separatedBy: seperator)
    }
}

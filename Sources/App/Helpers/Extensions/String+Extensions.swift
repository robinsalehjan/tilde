
extension String {
    func splitOnSeperator(_ seperator: String) -> [String] {
        guard isEmpty else { return [] }
        return components(separatedBy: seperator)
    }
}

import Foundation

protocol ListingFactory {
    static func createListing(_ input: Listing.Input, ownerID: Listing.IDValue) -> Listing
    static func createListingOutput(_ model: Listing) -> Listing.Output
}

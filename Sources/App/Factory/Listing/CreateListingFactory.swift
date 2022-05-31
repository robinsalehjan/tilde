import Foundation

class CreateListingFactory: ListingFactory {
    static func createListing(_ input: Listing.Input, ownerID: Listing.IDValue) -> Listing {
        return Listing(
            title: input.title,
            caption: input.caption,
            category: input.category,
            likes: input.likes,
            size: input.size,
            currency: input.currency,
            askingPrice: input.askingPrice,
            isSold: input.isSold,
            ownerID: ownerID
        )
    }

    static func createListingOutput(_ model: Listing) -> Listing.Output {
        return Listing.Output(
            listingNumber: model.listingNumber,
            title: model.title,
            caption: model.caption,
            category: model.category,
            likes: model.likes,
            size: model.size,
            currency: model.currency,
            askingPrice: model.askingPrice,
            isSold: model.isSold,
            createdAt: model.createdAt?.formatted(date: .complete, time: .shortened).description
        )
    }
}

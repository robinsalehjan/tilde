import Foundation

class CreateListingFactory: ListingFactory {
    static func createListing(
        _ input: Listing.Input,
        ownerID: Listing.IDValue,
        categoryID: Category.IDValue?
    ) -> Listing {
        return Listing(
            title: input.title,
            caption: input.caption,
            likes: input.likes,
            size: input.size,
            currency: input.currency,
            askingPrice: input.askingPrice,
            isSold: input.isSold,
            ownerID: ownerID,
            categoryID: categoryID
        )
    }

    static func createListingOutput(
        _ model: Listing
    ) -> Listing.Output {
        return Listing.Output(
            listingNumber: model.listingNumber,
            title: model.title,
            caption: model.caption,
            category: model.category?.description ?? "",
            likes: model.likes,
            size: model.size,
            currency: model.currency,
            askingPrice: model.askingPrice,
            isSold: model.isSold,
            createdAt: model.createdAt?.formatted(date: .complete, time: .shortened).description
        )
    }
}

import Vapor

extension Response {
    public static func create(status: HTTPResponseStatus, mediaType: HTTPMediaType, body: Body? = nil) -> Response {
        var response: Response

        if let body = body {
            response = Response(status: status, body: body)
        } else {
            response = Response(status: status)
        }

        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: mediaType.type)

        return response
    }
}

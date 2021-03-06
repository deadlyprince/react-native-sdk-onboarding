//
//  HTDelegate.swift
//  HyperTrack
//
//  Created by Tapan Pandita on 02/03/17.
//  Copyright © 2017 HyperTrack. All rights reserved.
//

import Foundation
import CocoaLumberjack

/**
 The HyperTrack Error object. Contains an error type.
 */
@objc public class HyperTrackError: NSObject {

    /**
     Enum for various error types
     */
    public let type: HyperTrackErrorType

    @objc public let errorCode: HyperTrackErrorCode
    @objc public var errorMessage: String
    @objc public let displayErrorMessage: String

    init(_ type: HyperTrackErrorType) {
        self.type = type
        self.errorCode = HyperTrackError.getErrorCode(type)
        self.errorMessage = HyperTrackError.getErrorMessage(type)
        self.displayErrorMessage = HyperTrackError.getErrorMessage(type)
    }

    init(_ type: HyperTrackErrorType, responseData: Data?) {
        self.type = type
        self.errorCode = HyperTrackError.getErrorCode(type)
        self.errorMessage = HyperTrackError.getErrorMessage(type)
        self.displayErrorMessage = HyperTrackError.getErrorMessage(type)
        if let data = responseData {
            if let errorMessage =  String(data: data, encoding: .utf8) {
                self.errorMessage = errorMessage
            }
        }
    }

    internal func toDict() -> [String: Any] {
        let dict = [
            "code": self.errorCode.rawValue as Any,
            "message": self.errorMessage as Any
            ] as [String: Any]
        return dict
    }

    public func toJson() -> String {
        let dict = self.toDict()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            return jsonString ?? ""
        } catch {
            DDLogError("Error serializing object to JSON: " + error.localizedDescription)
            return ""
        }
    }

    static func getErrorCode(_ type: HyperTrackErrorType) -> HyperTrackErrorCode {
        switch type {
            /**
             Error for key not set
             */
        case HyperTrackErrorType.publishableKeyError:
            return HyperTrackErrorCode.publishableKeyError

            /**
             Error for user id not set
             */
        case HyperTrackErrorType.userIdError:
            return HyperTrackErrorCode.userIdError

            /**
             Error for location permissions
             */
        case HyperTrackErrorType.locationPermissionsError:
            return HyperTrackErrorCode.locationPermissionsError

            /**
             Error for location enabled
             */
        case HyperTrackErrorType.locationDisabledError:
            return HyperTrackErrorCode.locationDisabledError

            /**
             Invalid location error
             */
        case HyperTrackErrorType.invalidLocationError:
            return HyperTrackErrorCode.invalidLocationError

            /**
             Error while fetching ETA
             */
        case HyperTrackErrorType.invalidETAError:
            return HyperTrackErrorCode.invalidETAError

            /**
             Error for malformed json
             */
        case HyperTrackErrorType.jsonError:
            return HyperTrackErrorCode.jsonError

            /**
             Error for server errors
             */
        case HyperTrackErrorType.serverError:
            return HyperTrackErrorCode.serverError

            /**
             Error for invalid parameters
             */
        case HyperTrackErrorType.invalidParamsError:
            return HyperTrackErrorCode.invalidParamsError

            /**
             Unknown error
             */
        case HyperTrackErrorType.unknownError:
            return HyperTrackErrorCode.unknownError

        case .authorizationFailedError:
            return HyperTrackErrorCode.authorizationFailedError
        }
    }

    static func getErrorMessage(_ type: HyperTrackErrorType) -> String {
        switch type {
            /**
             Error for key not set
             */
        case HyperTrackErrorType.publishableKeyError:
            return "A publishable key has not been set"

            /**
             Error for user id not set
             */
        case HyperTrackErrorType.userIdError:
            return "A userId has not been set"

            /**
             Error for location permissions
             */
        case HyperTrackErrorType.locationPermissionsError:
            return "Location permissions are not enabled"

            /**
             Error for location enabled
             */
        case HyperTrackErrorType.locationDisabledError:
            return "Location services are not available"

            /**
             Invalid location error
             */
        case HyperTrackErrorType.invalidLocationError:
            return "Error fetching a valid Location"

            /**
             Error while fetching ETA
             */
        case HyperTrackErrorType.invalidETAError:
            return "Error while fetching eta. Please try again."

            /**
             Error for malformed json
             */
        case HyperTrackErrorType.jsonError:
            return "The server returned malformed json"

            /**
             Error for server errors
             */
        case HyperTrackErrorType.serverError:
            return "An error occurred communicating with the server"

            /**
             Error for invalid parameters
             */
        case HyperTrackErrorType.invalidParamsError:
            return "Invalid parameters supplied"

            /**
             Unknown error
             */
        case HyperTrackErrorType.unknownError:
            return "An unknown error occurred"

        case HyperTrackErrorType.authorizationFailedError:
            return "Authorization Failed. Check your publishable key."
        }
    }
}

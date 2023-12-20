import Foundation
import UIKit

public class TixngoProfile {
    private let firstName: String
    private let lastName: String
    private let gender: TixngoGender
    private let face: String?
    private let dateOfBirth: Date?
    private let nationality: String?
    private let passportNumber: String?
    private let idCardNumber: String?
    private let email: String?
    private let phoneNumber: String?
    private let address: TixngoAddress?
    private let birthCity: String?
    private let birthCountry: String?
    private let residenceCountry: String?
    
    public init (firstName: String, lastName: String, gender: TixngoGender, face: String?, dateOfBirth: Date?, nationality: String?,
          passportNumber: String?, idCardNumber: String?, email: String?, phoneNumber: String?, address: TixngoAddress?,
          birthCity: String?, birthCountry: String?, residenceCountry: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.face = face
        self.dateOfBirth = dateOfBirth
        self.nationality = nationality
        self.passportNumber = passportNumber
        self.idCardNumber = idCardNumber
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.birthCity = birthCity
        self.birthCountry = birthCountry
        self.residenceCountry = residenceCountry
    }
    
    func toJson() -> [String: Any] {
        var result: [String: Any] = [
            "firstName" : firstName,
            "lastName": lastName,
            "gender": gender.rawValue
        ]
        if let face = face {
            result["face"] = face
        }
        if let dateOfBirth = dateOfBirth {
            result["dateOfBirth"] = dateOfBirth.toDobString()
        }
        if let nationality = nationality {
            result["nationality"] = nationality
        }
        if let passportNumber = passportNumber {
            result["passportNumber"] = passportNumber
        }
        if let idCardNumber = idCardNumber {
            result["idCardNumber"] = idCardNumber
        }
        if let email = email {
            result["email"] = email
        }
        if let phoneNumber = phoneNumber {
            result["phoneNumber"] = phoneNumber
        }
        if let address = address {
            result["address"] = address.toJson()
        }
        if let birthCity = birthCity {
            result["birthCity"] = birthCity
        }
        if let birthCountry = birthCountry {
            result["birthCountry"] = birthCountry
        }
        if let residenceCountry = residenceCountry {
            result["residenceCountry"] = residenceCountry
        }
        return result
    }
    
}

public class TixngoAddress {
    private let line1: String
    private let line2: String?
    private let line3: String?
    private let city: String
    private let zip: String
    private let countryCode: String
    
    
    init (line1: String, line2: String?, line3: String?, city: String, zip: String, countryCode: String) {
        self.line1 = line1
        self.line2 = line2
        self.line3 = line3
        self.city = city
        self.zip = zip
        self.countryCode = countryCode
    }
    
    func toJson() -> [String: Any] {
        var result = [
            "line1" : line1,
            "city": city,
            "zip": zip,
            "countryCode": countryCode,
        ]
        if let line2 = line2 {
            result["line2"] = line2
        }
        if let line3 = line3 {
            result["line3"] = line3
        }
        return result
    }
    
}

public class TixngoPushNotification {
    private let data: [String: Any]?
    private let notification: [String: Any]?
    
    
    init? (_ userInfo: [String: Any?]) {
        var data = [String: Any]()
        var notification = [String: Any]()
        
        var messageId: String?
        for (key, value) in userInfo {
            if key == "gcm.message_id" || key == "google.message_id" || key == "message_id" {
                messageId = value as? String
                continue
            }
            if key == "aps" {
                let aps = value as! [String: Any]
                if let title = aps["alert"] as? String {
                    notification["title"] = title
                }
                if let alert = aps["alert"] as? [String: Any] {
                    notification["body"] = alert["body"]
                    notification["title"] = alert["title"]
                }
                continue
            }
            if !(key == "fcm_options" || key == "to" || key == "from" || key == "collapse_key" || key == "message_type" || key.hasPrefix("google.") || key.hasPrefix("gcm.")) {
                data[key] = value
            }
        }
        if messageId != nil {
            self.data = data
            self.notification = notification
        } else {
            return nil
        }
    }
    
    func toJson() -> [String: Any] {
        var result = [String: Any]()
        if let data = data {
            result["data"] = data
        }
        if let notification = notification {
            result["notification"] = notification
        }
        return result
    }
    
}

// Environments support by Tixngo
public enum TixngoEnv: String {
    case demo       = "DEMO"
    case int        = "INT"
    case val        = "VAL"
    case preprod    = "PREPROD"
    case prod       = "PROD"
}

public enum TixngoGender: String {
    case male       = "male"
    case female     = "female"
    case other      = "other"
    case unknown    = "unknown"
}

// All languages support by Tixngo
public enum TixngoLanguages: String {
    case en = "en"
    case ar = "ar"
    case de = "de"
    case ca = "ca"
    case es = "es"
    case fr = "fr"
    case no = "no"
}

public enum DisplayType: String {
    case present = "present"
    case embedded = "embedded"
}

public struct TixngoSDKConfig {
    var displayType: DisplayType = .present
    var existSignout: Bool = true
    var isHaveMenu: Bool = true
    
    public init(displayType: DisplayType = .present, isExistSignout: Bool = true, isHaveMenu: Bool = true) {
        self.displayType = displayType
        self.existSignout = isExistSignout
        self.isHaveMenu = isHaveMenu
    }
    
    var json: [String: Any?] {
        return ["displayType": displayType,
                "existSignOut": existSignout,
                "existMenu": isHaveMenu,
                ]
    }
}

fileprivate extension Date {
    func toDobString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

public struct TixngoConfiguration {
    let sskLicenseKey: String?
    let isEnableDebug: Bool
    let defaultEnv: TixngoEnv
    let isEnableWallet: Bool?
    let isCheckAppStatus: Bool?
    let supportLanguages: [TixngoLanguages]
    let defaultLanguage: TixngoLanguages?
    let theme: TixngoTheme?
    let appId: String?
      
    public init(licenseKey: String? = nil,
                isEnableDebug: Bool = false,
                defaultEnv: TixngoEnv,
                isEnableWallet: Bool?,
                isCheckAppStatus: Bool?,
                supportLanguages: [TixngoLanguages] = [],
                defaultLanguage: TixngoLanguages?,
                theme: TixngoTheme?,
                appId: String? = nil) {
        self.sskLicenseKey = licenseKey
        self.isEnableDebug = isEnableDebug
        self.defaultEnv = defaultEnv
        self.isEnableWallet = isEnableWallet
        self.isCheckAppStatus = isCheckAppStatus
        self.supportLanguages = supportLanguages
        self.defaultLanguage = defaultLanguage
        self.theme = theme
        self.appId = appId
    }
    
    var json: [String: Any?] {
        return ["sskLicenseKey": sskLicenseKey ?? "",
                "isEnableDebug": isEnableDebug,
                "defaultEnv": defaultEnv.rawValue,
                "isEnableWallet": isEnableWallet ?? false,
                "isCheckAppStatus": isCheckAppStatus ?? false,
                "supportLanguages": supportLanguages.map({$0.rawValue}),
                "defaultLanguage": defaultLanguage?.rawValue,
                "theme": theme?.json,
                "appId": appId ?? ""
                ]
    }
    
    static var `default`: TixngoConfiguration {
        let theme = TixngoTheme(font: "Qatar2022",
                                colors: TixngoColor(primary: .yellow, secondary: .red))
        return TixngoConfiguration(licenseKey: "MEYCIQDO4RS/aRJmaKnRZOaq9FOYNehpX9s4FqTdiNf6flbkcAIhANK7ToiL/EANI1vCIRchcny5SHI8cYbzz3KiyfeZf6SX",
                                   isEnableDebug: true,
                                   defaultEnv: .int,
                                   isEnableWallet: false,
                                   isCheckAppStatus: false,
                                   defaultLanguage: .en,
                                   theme: theme,
                                   appId: "")
    }
}

public struct TixngoTheme {
    let font: String
    let colors: TixngoColor?
    let buttons: TixngoButtons?
    
    public init(font: String, colors: TixngoColor? = nil, buttons: TixngoButtons? = nil) {
        self.font = font
        self.colors = colors
        self.buttons = buttons
    }
    
    var json: [String: Any?] {
        return ["font": font,
                "colors": colors?.json,
                "buttons": buttons?.json
                ]
    }
}

public struct TixngoColor {
    let primary: UIColor?
    let secondary: UIColor?
    let background: UIColor?
    let barcode: UIColor?
    let activationGreen: UIColor?
    let activationBlue: UIColor?
    let activationLightBlue: UIColor?
    let activationYellow: UIColor?
    let activationRed: UIColor?
    let activationBlack: UIColor?
    let greyBanner: UIColor?
    let redBanner: UIColor?
    let eventDetailPageBackground01: UIColor?
    let deleteAccountPageBackground01: UIColor?
    let pendingTransferItemBanner01: UIColor?
    let transferHistoryItemBanner01: UIColor?
    let transferHistoryItemBanner02: UIColor?
    let deletedTicketItemBanner01: UIColor?
    let tooltip: UIColor?
    let eventDetailPageBanner01: UIColor?
    let deleteAccountCompletedPageIcon01: UIColor?
    let greenBanner: UIColor?
    let ticketGeneralInfoIconColor: UIColor?
    let recipientConfirmationPageBackground01: UIColor?
    let transferCompletePageBackground01: UIColor?
    let myGroupColor01: UIColor?
    
    public init(primary: UIColor? = nil,
                secondary: UIColor? = nil,
                background: UIColor? = nil,
                barcode: UIColor? = nil,
                activationGreen: UIColor? = nil,
                activationBlue: UIColor? = nil,
                activationLightBlue: UIColor? = nil,
                activationYellow: UIColor? = nil,
                activationRed: UIColor? = nil,
                activationBlack: UIColor? = nil,
                greyBanner: UIColor? = nil,
                redBanner: UIColor? = nil,
                eventDetailPageBackground01: UIColor? = nil,
                deleteAccountPageBackground01: UIColor? = nil,
                pendingTransferItemBanner01: UIColor? = nil,
                transferHistoryItemBanner01: UIColor? = nil,
                transferHistoryItemBanner02: UIColor? = nil,
                deletedTicketItemBanner01: UIColor? = nil,
                tooltip: UIColor? = nil,
                eventDetailPageBanner01: UIColor? = nil,
                deleteAccountCompletedPageIcon01: UIColor? = nil,
                greenBanner: UIColor? = nil,
                ticketGeneralInfoIconColor: UIColor? = nil,
                recipientConfirmationPageBackground01: UIColor? = nil,
                transferCompletePageBackground01: UIColor? = nil,
                myGroupColor01: UIColor? = nil) {
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.barcode = barcode
        self.activationGreen = activationGreen
        self.activationBlue = activationBlue
        self.activationLightBlue = activationLightBlue
        self.activationYellow = activationYellow
        self.activationRed = activationRed
        self.activationBlack = activationBlack
        self.greyBanner = greyBanner
        self.redBanner = redBanner
        self.eventDetailPageBackground01 = eventDetailPageBackground01
        self.deleteAccountPageBackground01 = deleteAccountPageBackground01
        self.pendingTransferItemBanner01 = pendingTransferItemBanner01
        self.transferHistoryItemBanner01 = transferHistoryItemBanner01
        self.transferHistoryItemBanner02 = transferHistoryItemBanner02
        self.deletedTicketItemBanner01 = deletedTicketItemBanner01
        self.tooltip = tooltip
        self.eventDetailPageBanner01 = eventDetailPageBanner01
        self.deleteAccountCompletedPageIcon01 = deleteAccountCompletedPageIcon01
        self.greenBanner = greenBanner
        self.ticketGeneralInfoIconColor = ticketGeneralInfoIconColor
        self.recipientConfirmationPageBackground01 = recipientConfirmationPageBackground01
        self.transferCompletePageBackground01 = transferCompletePageBackground01
        self.myGroupColor01 = myGroupColor01
    }
    
    var json: [String: Any?] {
        return ["primary": primary?.hexStringFromColor,
                "secondary": secondary?.hexStringFromColor,
                "background": background?.hexStringFromColor,
                "barcode": barcode?.hexStringFromColor,
                "activationGreen": activationGreen?.hexStringFromColor,
                "activationBlue": activationBlue?.hexStringFromColor,
                "activationLightBlue": activationLightBlue?.hexStringFromColor,
                "activationYellow": activationYellow?.hexStringFromColor,
                "activationRed": activationRed?.hexStringFromColor,
                "activationBlack": activationBlack?.hexStringFromColor,
                "greyBanner": greyBanner?.hexStringFromColor,
                "redBanner": redBanner?.hexStringFromColor,
                "eventDetailPageBackground01": eventDetailPageBackground01?.hexStringFromColor,
                "deleteAccountPageBackground01": deleteAccountPageBackground01?.hexStringFromColor,
                "pendingTransferItemBanner01": pendingTransferItemBanner01?.hexStringFromColor,
                "transferHistoryItemBanner01": transferHistoryItemBanner01?.hexStringFromColor,
                "transferHistoryItemBanner02": transferHistoryItemBanner02?.hexStringFromColor,
                "deletedTicketItemBanner01": deletedTicketItemBanner01?.hexStringFromColor,
                "tooltip": tooltip?.hexStringFromColor,
                "eventDetailPageBanner01": eventDetailPageBanner01?.hexStringFromColor,
                "deleteAccountCompletedPageIcon01": deleteAccountCompletedPageIcon01?.hexStringFromColor,
                "greenBanner": greenBanner?.hexStringFromColor,
                "ticketGeneralInfoIconColor": ticketGeneralInfoIconColor?.hexStringFromColor,
                "recipientConfirmationPageBackground01": recipientConfirmationPageBackground01?.hexStringFromColor,
                "transferCompletePageBackground01": transferCompletePageBackground01?.hexStringFromColor,
                "myGroupColor01": myGroupColor01?.hexStringFromColor,
                ]
    }
}

public struct TixngoButtons {
    let primary: TixngoButtonStyle?
    let secondary: TixngoButtonStyle?
    let tertiary: TixngoButtonStyle?
    let submitReverted: TixngoButtonStyle?
    let submit: TixngoButtonStyle?
    let cancel: TixngoButtonStyle?
    let accept: TixngoButtonStyle?
    let reject: TixngoButtonStyle?
    let detail: TixngoButtonStyle?
    let detailReverted: TixngoButtonStyle?
    let delete: TixngoButtonStyle?
    let actionMenuSubmitButton01: TixngoButtonStyle?
    let ticketFreeSpaceInfoSubmitButton01: TixngoButtonStyle?
    let updateProfileTextButton01: TixngoButtonStyle?
    let deleteAccountPageButton01: TixngoButtonStyle?
    let pendingTransferItemCancelButton01: TixngoButtonStyle?
    let decisiveTransferPageAcceptButton01: TixngoButtonStyle?
    let decisiveTransferPageRejectButton01: TixngoButtonStyle?
    let reportIssueButton01: TixngoButtonStyle?
    let transferTicketOptionListSubmitButton01: TixngoButtonStyle?
    let recipientConfirmationPageSubmitButton02: TixngoButtonStyle?
    let transferCompletePageSubmitButton01: TixngoButtonStyle?
    let transferCompletePageSubmitButton02: TixngoButtonStyle?
    let modalSelectorSubmitButton01: TixngoButtonStyle?
    let myGroupTextButton01: TixngoButtonStyle?
    
    public init(primary: TixngoButtonStyle? = nil,
                secondary: TixngoButtonStyle? = nil,
                tertiary: TixngoButtonStyle? = nil,
                submitReverted: TixngoButtonStyle? = nil,
                submit: TixngoButtonStyle? = nil,
                cancel: TixngoButtonStyle? = nil,
                accept: TixngoButtonStyle? = nil,
                reject: TixngoButtonStyle? = nil,
                detail: TixngoButtonStyle? = nil,
                detailReverted: TixngoButtonStyle? = nil,
                delete: TixngoButtonStyle? = nil,
                actionMenuSubmitButton01: TixngoButtonStyle? = nil,
                ticketFreeSpaceInfoSubmitButton01: TixngoButtonStyle? = nil,
                updateProfileTextButton01: TixngoButtonStyle? = nil,
                deleteAccountPageButton01: TixngoButtonStyle? = nil,
                pendingTransferItemCancelButton01: TixngoButtonStyle? = nil,
                decisiveTransferPageAcceptButton01: TixngoButtonStyle? = nil,
                decisiveTransferPageRejectButton01: TixngoButtonStyle? = nil,
                reportIssueButton01: TixngoButtonStyle? = nil,
                transferTicketOptionListSubmitButton01: TixngoButtonStyle? = nil,
                recipientConfirmationPageSubmitButton02: TixngoButtonStyle? = nil,
                transferCompletePageSubmitButton01: TixngoButtonStyle? = nil,
                transferCompletePageSubmitButton02: TixngoButtonStyle? = nil,
                modalSelectorSubmitButton01: TixngoButtonStyle? = nil,
                myGroupTextButton01: TixngoButtonStyle? = nil) {
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
        self.submitReverted = submitReverted
        self.submit = submit
        self.cancel = cancel
        self.accept = accept
        self.reject = reject
        self.detail = detail
        self.detailReverted = detailReverted
        self.delete = delete
        self.actionMenuSubmitButton01 = actionMenuSubmitButton01
        self.ticketFreeSpaceInfoSubmitButton01 = ticketFreeSpaceInfoSubmitButton01
        self.updateProfileTextButton01 = updateProfileTextButton01
        self.deleteAccountPageButton01 = deleteAccountPageButton01
        self.pendingTransferItemCancelButton01 = pendingTransferItemCancelButton01
        self.decisiveTransferPageAcceptButton01 = decisiveTransferPageAcceptButton01
        self.decisiveTransferPageRejectButton01 = decisiveTransferPageRejectButton01
        self.reportIssueButton01 = reportIssueButton01
        self.transferTicketOptionListSubmitButton01 = transferTicketOptionListSubmitButton01
        self.recipientConfirmationPageSubmitButton02 = recipientConfirmationPageSubmitButton02
        self.transferCompletePageSubmitButton01 = transferCompletePageSubmitButton01
        self.transferCompletePageSubmitButton02 = transferCompletePageSubmitButton02
        self.modalSelectorSubmitButton01 = modalSelectorSubmitButton01
        self.myGroupTextButton01 = myGroupTextButton01
    }
    
    var json: [String: Any?] {
        return ["primary": primary?.json,
                "secondary": secondary?.json,
                "tertiary": tertiary?.json,
                "submitReverted": submitReverted?.json,
                "submit": submit?.json,
                "cancel": cancel?.json,
                "accept": accept?.json,
                "reject": reject?.json,
                "detail": detail?.json,
                "detailReverted": detailReverted?.json,
                "delete": delete?.json,
                "actionMenuSubmitButton01": actionMenuSubmitButton01?.json,
                "ticketFreeSpaceInfoSubmitButton01": ticketFreeSpaceInfoSubmitButton01?.json,
                "updateProfileTextButton01": updateProfileTextButton01?.json,
                "deleteAccountPageButton01": deleteAccountPageButton01?.json,
                "pendingTransferItemCancelButton01": pendingTransferItemCancelButton01?.json,
                "decisiveTransferPageAcceptButton01":
                    decisiveTransferPageAcceptButton01?.json,
                "decisiveTransferPageRejectButton01":
                    decisiveTransferPageRejectButton01?.json,
                "reportIssueButton01": reportIssueButton01?.json,
                "transferTicketOptionListSubmitButton01":
                    transferTicketOptionListSubmitButton01?.json,
                "recipientConfirmationPageSubmitButton02":
                    recipientConfirmationPageSubmitButton02?.json,
                "transferCompletePageSubmitButton01":
                    transferCompletePageSubmitButton01?.json,
                "transferCompletePageSubmitButton02":
                    transferCompletePageSubmitButton02?.json,
                "modalSelectorSubmitButton01": modalSelectorSubmitButton01?.json,
                "myGroupTextButton01": myGroupTextButton01?.json]
    }
}

public struct TixngoButtonStyle {
    let background: UIColor?
    let textColor: UIColor?
    let textFont: TixngoFont?
    let border: TixngoBorder?
    
    public init(background: UIColor? = nil,
                textColor: UIColor? = nil,
                textFont: TixngoFont? = nil,
                border: TixngoBorder? = nil) {
        self.background = background
        self.textColor = textColor
        self.textFont = textFont
        self.border = border
    }
    
    var json: [String: Any?] {
        return ["background": background?.hexStringFromColor,
                "textColor": textColor?.hexStringFromColor,
                "textFont": textFont?.json,
                "border": border?.json]
    }
}

public struct TixngoFont {
    public enum FontWeight: String {
        case bold = "bold"
        case w100 = "w100"
        case w200 = "w200"
        case w300 = "w300"
        case w400 = "w400"
        case w500 = "w500"
        case w600 = "w600"
        case w700 = "w700"
        case w800 = "w800"
        case w900 = "w900"
        case normal = "normal"
    }
    
    let name: String?
    let size: Double?
    let weight: FontWeight
    
    public init(name: String? = nil,
                size: Double? = nil,
                weight: FontWeight = .normal) {
        self.name = name
        self.size = size
        self.weight = weight
    }
    
    var json: [String: Any?] {
        return ["name": name,
                "size": size,
                "weight": weight.rawValue]
    }
}

public struct TixngoBorder {
    let width: Double?
    let color: UIColor?
    let radius: Double?
    
    public init(width: Double? = nil,
                color: UIColor? = nil,
                radius: Double? = nil) {
        self.width = width
        self.color = color
        self.radius = radius
    }
    
    var json: [String: Any?] {
        return ["borderWidth": width,
                "borderColor": color?.hexStringFromColor,
                "radius": radius]
    }
}

extension UIColor {
    var hexStringFromColor: String {
        let components = self.cgColor.components
        let count = components?.count ?? 0
        let r: CGFloat = count >= 1 ? (components?[0] ?? 0.0) : 0.0
        let g: CGFloat = count >= 2 ? (components?[1] ?? 0.0) : 0.0
        let b: CGFloat = count >= 3 ? (components?[2] ?? 0.0) : 0.0

        let hexString = String.init(format: "0xff%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        debugPrint("test convert: \(hexString)")
        return hexString
     }
}

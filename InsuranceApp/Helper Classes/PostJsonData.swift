//
//  PostJsonData.swift
//  InsuranceApp
//
//  Created by Sankalp on 20/12/21.
//

import Foundation
import UIKit

class PostJsonData : NSMutableDictionary
{
    private var myOriginal : NSDictionary!
    private let falseValue : Bool! = false
    private let intV : Int! = 0
    private let def = Common.sharedCommon.sharedUserDefaults()
    private let DeviceId = UIDevice.current.model.capitalized
    private let BrokerId = "PIBL"
    private var ifQNoIsAvail : Bool! = false
    private var companyData : NSDictionary!
    private let common = Common.sharedCommon
    
    enum type_Of_Value {
        case string_value
        case integer_value
        case float_value
        case bool_value
        case dict_value
        case array_value
    }
        
    func createMyDictForPostingData(ToGetQuaotationNumber getQNo: Bool, IfYesThen bankCode : String, andDict dict : NSDictionary) -> NSDictionary
    {
        ifQNoIsAvail = getQNo
        myOriginal = dict
        let myDict = NSMutableDictionary.init()

        myDict.setValue("", forKey: "ChassisAndBodyPriceRate")
        myDict.setValue(toCreateCoverageDataDetails(), forKey: "CoverageDetails")
        myDict.setValue(toCreateDiscountDetails(), forKey: "DiscountDetails")
        let quote_Key = def.string(forKey: "SubProductCode")!.replacingOccurrences(of: "MTR", with: "")+"Quotation"
        myDict.setValue(toCreateVehicleQuoatation(), forKey: quote_Key)
        if (!def.bool(forKey: "DontKnowPreviousInsurer"))
        {
            myDict.setValue(toCreatePrevPolicyInsurer(), forKey: "PrevPolicyInsurer")
            myDict.setValue(toCreatePreviousPolicyDetails(), forKey: "PreviousPolicyDetails")
        }
        if ( def.object(forKey:"RequestedAddOnList") != nil)
        {
            myDict.setValue(def.object(forKey:"RequestedAddOnList"), forKey: "RequestedAddOnList")
        }
        else
        {
            myDict.setValue(NSArray.init(), forKey: "RequestedAddOnList")
        }

        if (def.object(forKey: "CustomIDVAmount") != nil)
        {
            myDict.setValue(def.object(forKey: "CustomIDVAmount"), forKey: "CustomIDVAmount")
        }
        if (def.string(forKey: "SubProductCode")!.elementsEqual(Constant.MTRPV))
        {
            myDict.setValue(def.bool(forKey:"LimitedToOwnPremises"), forKey: "LimitedToOwnPremises")
        }
        if (ifQNoIsAvail)
        {
            myDict.setValue(NSArray.init(), forKey: "CompanyIdvDetails")
            myDict.setValue(def.string(forKey: "QuotationNumber"), forKey: "QuotationNumber")
            myDict.setValue(def.string(forKey: "PolicyStartDate"), forKey: "PolicyStartDate")
            myDict.setValue(def.string(forKey: "PolicyEndDate"), forKey: "PolicyEndDate")
            myDict.setValue(myOriginal.object(forKey: "CompanyName"), forKey: "CompanyName")
            myDict.setValue(myOriginal.object(forKey: "PlanId"), forKey: "PlanId")
            myDict.setValue(myOriginal.object(forKey: "CompanyCode"), forKey: "CompanyCode")
        }

        return addThoseForVehicle(myDict)
    }
    
    private func vehicleDetails() -> NSDictionary
    {
        let vehicleDetails = NSMutableDictionary.init()
        vehicleDetails.setValue(def.string(forKey:"RTOCityId"), forKey: "BimaPostRTOId")
        vehicleDetails.setValue(def.string(forKey:"ManufaturingDate"), forKey: "ManufaturingDate")
        vehicleDetails.setValue(def.string(forKey:"PurchaseDate"), forKey: "PurchaseDate")
        vehicleDetails.setValue(def.string(forKey:"RegistrationDate"), forKey: "RegistrationDate")
        vehicleDetails.setValue(def.integer(forKey:"VariantId"), forKey: "VariantCode")

        if (def.string(forKey:"RegistrationNumber") != nil)
        {
            vehicleDetails.setValue(def.string(forKey:"RegistrationNumber"), forKey: "RegistrationNumber")
        }
        else
        {
            var k = def.string(forKey: "RTOName")
            let m = " " + def.string(forKey: "RTOCityName")!
            k = k?.replacingOccurrences(of: m, with: "")
            k = k! + "-AB-1111"
            vehicleDetails.setValue(k, forKey: "RegistrationNumber")
        }
        
        if (def.string(forKey: "SubVariantCode") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "SubVariantCode"), forKey: "SubVariantCode")
        }
        if (def.string(forKey: "ManufaturingYear") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "ManufaturingYear"), forKey: "ManufaturingYear")
        }
        if (def.string(forKey: "RTOName") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "RTOName"), forKey: "RTOCode")
        }
        if (def.string(forKey: "ModelName") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "ModelName"), forKey: "ModelName")
        }
        if (def.string(forKey: "ModelId") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "ModelId"), forKey: "ModelCode")
        }
        if (def.string(forKey: "MakeName") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "MakeName"), forKey: "MakeName")
        }
        if (def.string(forKey: "MakeId") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "MakeId"), forKey: "MakeCode")
        }
        if (def.string(forKey: "RegistrationYear") != nil)
        {
            vehicleDetails.setValue(def.string(forKey:"RegistrationYear"), forKey: "RegistrationYear")
        }
        if (def.string(forKey: "RTOCityName") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "RTOCityName"), forKey: "RTOCityName")
        }
        if (def.string(forKey: "VariantName") != nil)
        {
            vehicleDetails.setValue(def.string(forKey:"VariantName")!, forKey: "VariantName")
        }
        if (def.string(forKey: "FuelType") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "FuelType"), forKey: "FuelType")
        }
        if (def.string(forKey: "FuelId") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "FuelId"), forKey: "FuelId")
        }
        if (def.string(forKey: "RTOZone") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "RTOZone"), forKey: "RTOZone")
        }
        if (def.string(forKey: "RTOCity") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "RTOCity"), forKey: "RTOCity")
        }
        if (def.string(forKey: "RTOState") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "RTOState"), forKey: "RTOState")
        }
        if (def.string(forKey: "RTOStateCode") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "RTOStateCode"), forKey: "RTOStateCode")
        }
        if (def.string(forKey: "ChassisNumber") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "ChassisNumber"), forKey: "ChassisNumber")
        }
        if (def.string(forKey: "EngineNumber") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "EngineNumber"), forKey: "EngineNumber")
        }
        if (def.string(forKey: "VehicleUsageType") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "VehicleUsageType"), forKey: "VehicleUsageType")
        }
        if (def.object(forKey: "NoOfWheels") != nil)
        {
            vehicleDetails.setValue(def.integer(forKey:"NoOfWheels"), forKey: "NoOfWheels")
        }
        if (def.object(forKey: "SeatingCapacity") != nil)
        {
            vehicleDetails.setValue(def.integer(forKey: "SeatingCapacity"), forKey: "SeatingCapacity")
        }
        if (def.object(forKey: "GVW") != nil)
        {
            vehicleDetails.setValue(def.integer(forKey:"GVW"), forKey: "GVW")
        }
        if (def.object(forKey: "CubicCapacity") != nil)
        {
            vehicleDetails.setValue(def.object(forKey: "CubicCapacity"), forKey: "CubicCapacity")
        }
        if (def.object(forKey: "VehicleSubType") != nil)
        {
            vehicleDetails.setValue(def.object(forKey:"VehicleSubType"), forKey: "VehicleSubType")
        }

        if (def.object(forKey: "Segment") != nil)
        {
            vehicleDetails.setValue(def.object(forKey:"Segment"), forKey: "Segment")
        }
        if (def.object(forKey: "CarryingCapacity") != nil)
        {
            vehicleDetails.setValue(def.object(forKey:"CarryingCapacity"), forKey: "CarryingCapacity")
        }
        if (def.object(forKey: "BiFuelType") != nil)
        {
            vehicleDetails.setValue(def.object(forKey:"BiFuelType"), forKey: "BiFuelType")
        }
        if (def.string(forKey: "BodyType") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "BodyType"), forKey: "BodyType")
        }
        if (def.string(forKey: "BodyColor") != nil)
        {
            vehicleDetails.setValue(def.string(forKey: "BodyColor"), forKey: "BodyColor")
        }
        if (def.object(forKey: "MVW") != nil)
        {
            vehicleDetails.setValue(def.object(forKey:"MVW"), forKey: "MVW")
        }
        if (def.object(forKey: "TrailerChassisNumber") != nil)
        {
            vehicleDetails.setValue(def.object(forKey:"TrailerChassisNumber"), forKey: "TrailerChassisNumber")
        }
        if (def.object(forKey: "NoOfTrailers") != nil)
        {
            vehicleDetails.setValue(def.object(forKey:"NoOfTrailers"), forKey: "NoOfTrailers")
        }
        if (def.object(forKey: "TrailersIDV") != nil)
        {
            vehicleDetails.setValue(def.object(forKey:"TrailersIDV"), forKey: "TrailersIDV")
        }
        if (def.object(forKey: "IsTrailerAvailable") != nil)
        {
            vehicleDetails.setValue(def.object(forKey:"IsTrailerAvailable"), forKey: "IsTrailerAvailable")
        }
        if (def.object(forKey: "TrailerRegistrationNumber") != nil)
        {
            vehicleDetails.setValue(def.object(forKey: "TrailerRegistrationNumber"), forKey: "TrailerRegistrationNumber")
        }
        if (def.object(forKey: "TrailerMake") != nil)
        {
            vehicleDetails.setValue(def.object(forKey: "TrailerMake"), forKey: "TrailerMake")
        }
        if (def.object(forKey: "VehicleBodyPrice") != nil)
        {
            vehicleDetails.setValue(def.object(forKey:"VehicleBodyPrice") , forKey: "VehicleBodyPrice")
        }
        return vehicleDetails
    }
   
    private func toCreateVehicleQuoatation() -> NSDictionary
    {
        let pcQuote = NSMutableDictionary.init()
        pcQuote.setValue(def.bool(forKey:"IsODOnly"), forKey: "IsODOnly")
        pcQuote.setValue(def.string(forKey:"RTOCityId"), forKey: "BPRtoId")
        pcQuote.setValue(def.bool(forKey:"DontKnowPreviousInsurer"), forKey: "DontKnowPreviousInsurer")
        pcQuote.setValue(def.bool(forKey:"IsThirdPartyOnly"), forKey: "IsThirdPartyOnly")
        pcQuote.setValue(def.string(forKey:"MakeId"), forKey: "MakeCode")
        pcQuote.setValue(def.string(forKey:"MakeName") , forKey: "MakeName")
        pcQuote.setValue(def.string(forKey:"ModelId"), forKey: "ModelCode")
        pcQuote.setValue(def.string(forKey:"ModelName"), forKey: "ModelName")
        pcQuote.setValue(def.string(forKey:"PolicyType"), forKey: "PolicyType")
        pcQuote.setValue(def.string(forKey:"RegistrationYear"), forKey: "RegistrationYear")
        pcQuote.setValue(def.string(forKey:"RequestTime"), forKey: "RequestTime")
        pcQuote.setValue(def.string(forKey:"RTOName"), forKey: "RTOCityName")
        pcQuote.setValue(BrokerId, forKey: "BrokerId")
        pcQuote.setValue(DeviceId, forKey: "DeviceId")
        pcQuote.setValue(def.object(forKey:"UserId"), forKey: "LoginUserId")
        pcQuote.setValue(def.integer(forKey:"VariantId"), forKey: "VariantCode")
        pcQuote.setValue(def.string(forKey:"VariantName")!, forKey: "VariantName")
        
        if (!def.bool(forKey:"DontKnowPreviousInsurer") && !((def.string(forKey: "PolicyType")?.elementsEqual("New"))!))
        {
            pcQuote.setValue(def.object(forKey:"PrevPolicyExpiryStatus"), forKey: "PrevPolicyExpiryStatus")
            pcQuote.setValue(def.string(forKey:"PolicyType"), forKey: "PreviousPolicyType")
            pcQuote.setValue(toCreatePrevPolicyInsurer(), forKey: "PrevPolicyInsurer")
            pcQuote.setValue(toCreatePreviousPolicyDetails(), forKey: "PreviousPolicyDetails")
        }
        return pcQuote
    }
    
    func companySpecificQuotation() -> NSDictionary
    {
        companyData = Common.sharedCommon.unArchiveMyDataForDictionary("StoredCompany")
        let specificQuotation = NSMutableDictionary.init()
        specificQuotation.setValue(def.bool(forKey:"IsWhatsappMessageAllow"), forKey: "IsWhatsappMessageAllow")
        specificQuotation.setValue(clientDetails(), forKey: "ClientDetails")
        specificQuotation.setValue(addressDetails(def.dictionary(forKey:"VehicleAddress")! as NSDictionary), forKey: "VehicleAddressDetails")
        specificQuotation.setValue(addressDetails(def.dictionary(forKey:"CommunicationAddress")! as NSDictionary), forKey: "CommunicationAddressDetails")
        specificQuotation.setValue(toCreateCoverageDataDetails(), forKey: "CoverageDetails")
        specificQuotation.setValue(toCreateDiscountDetails(), forKey: "DiscountDetails")
        let quote_Key = def.string(forKey: "SubProductCode")!.replacingOccurrences(of: "MTR", with: "")+"Quotation"
        specificQuotation.setValue(toCreateVehicleQuoatation(), forKey: quote_Key)
        specificQuotation.setValue(vehicleDetails(), forKey: "VehicleDetails")
        specificQuotation.setValue(def.string(forKey: "QuotationNumber"), forKey: "QuotationNumber")
        specificQuotation.setValue(companyData!.object(forKey:"CompanyCode"), forKey: "CompanyCode")
        specificQuotation.setValue(companyData!.object(forKey:"PlanCode"), forKey: "PlanCode")
        specificQuotation.setValue(companyData!.object(forKey:"IDVDepreciationRate"), forKey: "IDVDepreciationRate")
        specificQuotation.setValue(companyData!.object(forKey:"CompanyName"), forKey: "CompanyName")
        specificQuotation.setValue(companyData!.object(forKey:"PremiumYear"), forKey: "PremiumYear")
        specificQuotation.setValue(companyData!.object(forKey:"PlanId"), forKey: "PlanId")
        specificQuotation.setValue(companyData!.object(forKey:"PlanName"), forKey: "PlanName")
        specificQuotation.setValue(companyData!.object(forKey:"PolicyStartDate"), forKey: "PolicyStartDate")
        specificQuotation.setValue(companyData!.object(forKey:"PolicyEndDate"), forKey: "PolicyEndDate")
        specificQuotation.setValue(companyData!.object(forKey:"IsPaymentAllow"), forKey: "IsPaymentAllow")
        specificQuotation.setValue(falseValue, forKey: "IsRecalculateQuote")
        specificQuotation.setValue(def.bool(forKey:"LimitedToOwnPremises"), forKey: "LimitedToOwnPremises")
        specificQuotation.setValue(def.bool(forKey: "IsVehicleFinanced"), forKey: "IsVehicleFinanced")

        if (!def.bool(forKey:"DontKnowPreviousInsurer"))
        {
            specificQuotation.setValue(toCreatePrevPolicyInsurer(), forKey: "PrevPolicyInsurer")
            specificQuotation.setValue(toCreatePreviousPolicyDetails(), forKey: "PreviousPolicyDetails")
        }
        
        let aDict = def.dictionary(forKey: "NomineeAppointeeDetails")! as NSDictionary
        specificQuotation.setValue(aDict.object(forKey: "IsApointeeRequired"), forKey: "IsApointeeRequired")
        specificQuotation.setValue(aDict.object(forKey: "NomineeDateOfBirth"), forKey: "NomineeDateOfBirth")
        specificQuotation.setValue(aDict.object(forKey: "NomineeGender"), forKey: "NomineeGender")
        specificQuotation.setValue(aDict.object(forKey: "NomineeName"), forKey: "NomineeName")
        specificQuotation.setValue(aDict.object(forKey: "NomineeRelation"), forKey: "NomineeRelation")
        if (aDict.object(forKey: "IsApointeeRequired") as! Bool)
        {
            specificQuotation.setValue(aDict.object(forKey: "AppointeeDateOfBirth"), forKey: "AppointeeDateOfBirth")
            specificQuotation.setValue(aDict.object(forKey: "AppointeeName"), forKey: "AppointeeName")
            specificQuotation.setValue(aDict.object(forKey: "AppointeeRelation"), forKey: "AppointeeRelation")
        }
        else
        {
            specificQuotation.setValue("", forKey: "AppointeeName")
            specificQuotation.setValue("", forKey: "AppointeeRelation")
        }
        specificQuotation.setValue(def.bool(forKey: "HasValidPUC"), forKey: "HasValidPUC")

        if (def.bool(forKey: "HasValidPUC"))
        {
            specificQuotation.setValue(def.object(forKey: "PUCNumber"), forKey: "PUCNumber")
            specificQuotation.setValue(def.object(forKey: "PUCStartDate"), forKey: "PUCStartDate")
            specificQuotation.setValue(def.object(forKey: "PUCEndDate"), forKey: "PUCEndDate")
        }

        if (def.bool(forKey: "IsVehicleFinanced"))
        {
            specificQuotation.setValue(def.string(forKey: "FinancialInstAddress"), forKey: "FinancialInstAddress")
            specificQuotation.setValue(def.string(forKey: "FinancialInstName"), forKey: "FinancialInstName")
        }
        else {
            specificQuotation.setValue("", forKey: "FinancialInstAddress")
            specificQuotation.setValue("", forKey: "FinancialInstName")
        }
        specificQuotation.setValue(def.bool(forKey: "RegistrationAddressSame"), forKey: "IsRegistrationAddressSame")
        specificQuotation.setValue(NSArray.init(), forKey: "CompanyIdvDetails")
        specificQuotation.setValue(companyData!.object(forKey:"PremiumBreakUpDetails"), forKey: "PremiumBreakUpDetails")
        return addThoseForVehicle(specificQuotation)
    }
    
    private func addThoseForVehicle(_ dict : NSMutableDictionary) -> NSMutableDictionary
    {
        dict.setValue(def.string(forKey:"MakeName"), forKey: "MakeName")
        dict.setValue(def.string(forKey:"ModelName"), forKey: "ModelName")
        dict.setValue(def.string(forKey:"RTOName"), forKey: "RTOCityName")
        dict.setValue(def.string(forKey:"VariantName")!, forKey: "VariantName")
        dict.setValue(vehicleDetails(), forKey: "VehicleDetails")
        
        var ispos = falseValue
        let userID = (common.sharedUserDefaults().object(forKey: "UserId") as? String)

        if (userID != nil && !userID!.elementsEqual("0"))
        {
            let logInResp = common.unArchiveMyDataForDictionary("LoginResponse")
            ispos = (logInResp?.object(forKey: "IsPOS") as! Bool)
        }
        
        dict.setValue(ispos, forKey: "IsPOSIncluded")
        if (ispos!)
        {
            dict.setValue(def.object(forKey:"POSDetails"), forKey: "POSDetails")
        }
        else
        {
            dict.setValue(NSNull.init(), forKey: "POSDetails")
        }

        dict.setValue(def.bool(forKey:"PreviousPolicyDetailsRequired"), forKey: "PreviousPolicyDetailsRequired")

        return firstThem(dict)
    }
    
    
    private func addressDetails(_ dict : NSDictionary) -> NSDictionary
    {
        let addressDict = NSMutableDictionary.init()
        addressDict.setValue("INDIA", forKey: "Country")
        addressDict.setValue(dict.object(forKey:"RegistrationAddressSame"), forKey: "RegistrationAddressSame")
        addressDict.setValue(dict.object(forKey:"State"), forKey: "State")
        addressDict.setValue(dict.object(forKey:"StateCode"), forKey: "StateCode")
        addressDict.setValue(dict.object(forKey:"StateName"), forKey: "StateName")
        addressDict.setValue(dict.object(forKey:"City"), forKey: "City")
        addressDict.setValue(dict.object(forKey:"CityCode"), forKey: "CityCode")
        addressDict.setValue(dict.object(forKey:"CityName"), forKey: "CityName")
        addressDict.setValue(dict.object(forKey:"Pincode"), forKey: "Pincode")
        if ((dict.object(forKey: "Address1") != nil) && !(dict.object(forKey: "Address1") as! String).isEmpty)
        {
            addressDict.setValue(dict.object(forKey:"Address1"), forKey: "Address1")
        }
        else
        {
            addressDict.setValue("", forKey: "Address1")
        }

        if ((dict.object(forKey: "Address3") != nil) && !(dict.object(forKey: "Address3") as! String).isEmpty)
        {
            addressDict.setValue(dict.object(forKey:"Address3"), forKey: "Address3")
        }
        else
        {
            addressDict.setValue("", forKey: "Address3")
        }
        
        if ((dict.object(forKey: "Address2") != nil) && !(dict.object(forKey: "Address2") as! String).isEmpty)
        {
            addressDict.setValue(dict.object(forKey:"Address2"), forKey: "Address2")
        }
        else
        {
            addressDict.setValue("", forKey: "Address2")
        }
        return addressDict
    }
    
    private func firstThem(_ dict : NSMutableDictionary) -> NSMutableDictionary
    {
        dict.setValue(def.string(forKey:"PolicyType"), forKey: "PolicyType")
        if (def.string(forKey: "CarrierType") != nil)
        {
            dict.setValue(def.string(forKey: "CarrierType"), forKey: "CarrierType")
        }
        else
        {
            dict.setValue("", forKey: "CarrierType")
        }
        
//        if (def.integer(forKey: "ProductCode") != 1 || def.integer(forKey: "ProductCode") != 2)
//        {
//            dict.setValue("", forKey: "UWDiscount")
//            dict.setValue("", forKey: "UWLoadingDiscount")
//        }
        
        dict.setValue(def.bool(forKey:"InclusionIMT23"), forKey: "InclusionIMT23")
        dict.setValue(def.bool(forKey:"IsExistingPACover"), forKey: "IsExistingPACover")
        dict.setValue(def.bool(forKey:"IsBreakingCase"), forKey: "IsBreakingCase")
        dict.setValue(def.bool(forKey:"IsODOnly"), forKey: "IsODOnly")
        
        var ispos = falseValue
        let userID = (common.sharedUserDefaults().object(forKey: "UserId") as? String)

        if (userID != nil && !userID!.elementsEqual("0"))
        {
            let logInResp = common.unArchiveMyDataForDictionary("LoginResponse")
            ispos = (logInResp?.object(forKey: "IsPOS") as! Bool)
        }
        
        dict.setValue(ispos, forKey: "IsPOSIncluded")
        if (ispos!)
        {
            dict.setValue(def.object(forKey:"POSDetails"), forKey: "POSDetails")
        }
        else
        {
            dict.setValue(NSNull.init(), forKey: "POSDetails")
        }
        dict.setValue(def.object(forKey:"UserId"), forKey: "LoginUserId")
        dict.setValue(def.bool(forKey:"IsValidLicence"), forKey: "IsValidLicence")
        dict.setValue(String(intV), forKey: "NewBusinessPolicyType")
        dict.setValue(def.bool(forKey:"PrivateUse"), forKey: "PrivateUse")
        dict.setValue(def.bool(forKey:"DontKnowPreviousInsurer"), forKey: "DontKnowPreviousInsurer")
        dict.setValue(def.bool(forKey:"IsThirdPartyOnly"), forKey: "IsThirdPartyOnly")
        dict.setValue(def.string(forKey:"CustomerType"), forKey: "CustomerType")

        if ( def.string(forKey:"OrganizationName") != nil)
        {
            dict.setValue(def.string(forKey:"OrganizationName"), forKey: "OrganizationName")
        }
        else
        {
            dict.setValue(NSNull.init(), forKey: "OrganizationName")
        }
        dict.setValue(def.bool(forKey:"IsOwnerChanged"), forKey: "IsOwnerChanged")
        return thoseAreFixed(dict)
    }
        
    func clientDetails() -> NSDictionary
    {
        let clientDetails = NSMutableDictionary.init()
        let dict = def.object(forKey: "ClientDetails") as! NSDictionary
        if (dict.object(forKey:"PanCardNumber")  != nil)
        {
            clientDetails.setValue(dict.object(forKey:"PanCardNumber") as? String, forKey: "PanCardNumber")
        }
        else
        {
            clientDetails.setValue("", forKey: "PanCardNumber")
        }
        if (dict.object(forKey:"AadhaarNo")  != nil)
        {
            clientDetails.setValue(dict.object(forKey:"AadhaarNo") as? String, forKey: "AadhaarNo")
        }
        else
        {
            clientDetails.setValue("", forKey: "AadhaarNo")
        }
        if (dict.object(forKey:"AdditionalContactNumber")  != nil)
        {
            clientDetails.setValue(dict.object(forKey:"AdditionalContactNumber") as? String, forKey: "AdditionalContactNumber")
        }
        else
        {
            clientDetails.setValue("", forKey: "AdditionalContactNumber")
        }
        if (dict.object(forKey:"GSTIN")  != nil)
        {
            clientDetails.setValue(dict.object(forKey:"GSTIN") as? String, forKey: "GSTIN")
        }
        else
        {
            clientDetails.setValue("", forKey: "GSTIN")
        }

        clientDetails.setValue(dict.object(forKey:"DateOfBirth") as? String, forKey: "DateOfBirth")
        clientDetails.setValue(dict.object(forKey:"disabled") as? Bool, forKey: "disabled")
        clientDetails.setValue(dict.object(forKey:"EmailAddress") as? String, forKey: "EmailAddress")
        clientDetails.setValue(dict.object(forKey:"FirstName") as? String, forKey: "FirstName")
        clientDetails.setValue(dict.object(forKey:"Gender") as? String, forKey: "Gender")
        clientDetails.setValue(dict.object(forKey:"LastName") as? String, forKey: "LastName")
        clientDetails.setValue(dict.object(forKey:"MidName") as? String, forKey: "MidName")
        clientDetails.setValue(dict.object(forKey:"MaritalStatus") as? String, forKey: "MaritalStatus")
        clientDetails.setValue(dict.object(forKey:"MobileNumber") as? String, forKey: "MobileNumber")
        clientDetails.setValue(dict.object(forKey:"Occupation"), forKey: "Occupation")
        clientDetails.setValue(dict.object(forKey:"Title") as? String, forKey: "Title")

        return clientDetails
    }
    
    private func thoseAreFixed(_ dict : NSMutableDictionary) -> NSMutableDictionary
    {
        dict.setValue("PIBL", forKey: "BrokerId")
        dict.setValue(DeviceId, forKey: "DeviceId")
        dict.setValue(def.string(forKey:"ProductCode"), forKey: "ProductCode")
        dict.setValue(def.string(forKey:"SubProductCode"), forKey: "SubProductCode")
        print(dict)
        return dict
    }
    
    private func toCreateDiscountDetails() -> NSDictionary
    {
        let discountDetails = NSMutableDictionary.init()
        discountDetails.setValue(def.bool(forKey:"IsAgeDiscount"), forKey: "IsAgeDiscount")
        discountDetails.setValue(def.bool(forKey:"IsAntiTheftDevice"), forKey: "IsAntiTheftDevice")
        discountDetails.setValue(def.bool(forKey:"IsMemberOfAutomobileAssociation"), forKey: "IsMemberOfAutomobileAssociation")
        discountDetails.setValue(def.bool(forKey:"IsOccupationDiscount"), forKey: "IsOccupationDiscount")
        discountDetails.setValue(def.bool(forKey:"IsTPPDRestrictedto6000"), forKey: "IsTPPDRestrictedto6000")
        discountDetails.setValue(def.bool(forKey:"IsUseForHandicap"), forKey: "IsUseForHandicap")
        discountDetails.setValue(def.bool(forKey:"IsVoluntaryExcess"), forKey: "IsVoluntaryExcess")
        if (def.bool(forKey:"IsVoluntaryExcess"))
        {
            discountDetails.setValue(def.integer(forKey:"VoluntaryExcessAmount"), forKey: "VoluntaryExcessAmount")
        }
        else
        {
            discountDetails.setValue(intV, forKey: "VoluntaryExcessAmount")
        }

        if (def.bool(forKey:"IsMemberOfAutomobileAssociation"))
        {
            discountDetails.setValue(def.string(forKey:"AssociationName"), forKey: "AssociationName")
            discountDetails.setValue(def.string(forKey:"MembershipNumber"), forKey: "MembershipNumber")
            discountDetails.setValue(def.string(forKey:"MembershipExpiryDate"), forKey: "MembershipExpiryDate")
        }
        else
        {
            discountDetails.setValue("", forKey: "AssociationName")
        }

        discountDetails.setValue("", forKey: "OccupationName")
        return discountDetails
    }
    
    private func toCreateCoverageDataDetails() -> NSDictionary
    {
        let coverageDetails = NSMutableDictionary.init()
        coverageDetails.setValue(def.bool(forKey:"IsBiFuelKit"), forKey: "IsBiFuelKit")
        coverageDetails.setValue(def.bool(forKey:"IsElectricalAccessories"), forKey: "IsElectricalAccessories")
        coverageDetails.setValue(def.bool(forKey:"IsEmployeeLiability"), forKey: "IsEmployeeLiability")
        coverageDetails.setValue(def.bool(forKey:"IsFiberGlassFuelTank"), forKey: "IsFiberGlassFuelTank")
        coverageDetails.setValue(def.bool(forKey:"IsLegalLiablityPaidDriver"), forKey: "IsLegalLiablityPaidDriver")
        coverageDetails.setValue(def.bool(forKey:"IsNonElectricalAccessories"), forKey: "IsNonElectricalAccessories")
        coverageDetails.setValue(def.bool(forKey:"IsPACoverUnnamedPerson"), forKey: "IsPACoverUnnamedPerson")
        coverageDetails.setValue(def.bool(forKey:"IsCleanerLiability"), forKey: "IsCleanerLiability")
        coverageDetails.setValue(def.bool(forKey:"IsCooliesLiability"), forKey: "IsCooliesLiability")
        coverageDetails.setValue(def.bool(forKey:"IsNoOfFPP"), forKey: "IsNoOfFPP")
        coverageDetails.setValue(def.bool(forKey:"IsNoOfNFPP"), forKey: "IsNoOfNFPP")
        coverageDetails.setValue(def.bool(forKey:"IsPACleaner"), forKey: "IsPACleaner")
        coverageDetails.setValue(def.bool(forKey:"IsPAConductor"), forKey: "IsPAConductor")
        coverageDetails.setValue(def.bool(forKey:"IsPACoverPaidDriver"), forKey: "IsPACoverPaidDriver")
        coverageDetails.setValue(def.bool(forKey:"IsPACoverToOwnerDriver"), forKey: "IsPACoverToOwnerDriver")
        if (def.bool(forKey:"IsPACoverToOwnerDriver"))
        {
            coverageDetails.setValue(def.integer(forKey:"PACoverOwnerDriverAmount"), forKey: "PACoverOwnerDriverAmount")
        }
        else
        {
            coverageDetails.setValue(intV, forKey: "PACoverOwnerDriverAmount")
        }
        if (def.bool(forKey:"IsBiFuelKit"))
        {
            coverageDetails.setValue(def.integer(forKey:"BiFuelKitValue"), forKey: "BiFuelKitValue")
        }
        else
        {
            coverageDetails.setValue(intV, forKey: "BiFuelKitValue")
        }
        
        if (def.bool(forKey:"IsNonElectricalAccessories"))
        {
            coverageDetails.setValue(def.integer(forKey:"NonElectricalAccessoryAmount"), forKey: "NonElectricalAccessoryAmount")
        }
        else
        {
            coverageDetails.setValue(intV, forKey: "NonElectricalAccessoryAmount")
        }

        if (def.bool(forKey:"IsElectricalAccessories"))
        {
            coverageDetails.setValue(def.integer(forKey:"ElectricalAccessoryAmount"), forKey: "ElectricalAccessoryAmount")
        }
        else
        {
            coverageDetails.setValue(intV, forKey: "ElectricalAccessoryAmount")
        }

        if (def.bool(forKey:"IsEmployeeLiability"))
        {
            coverageDetails.setValue(def.integer(forKey:"NoOfLegalLiablityEmployee"), forKey: "NoOfLegalLiablityEmployee")
        }
        else
        {
            coverageDetails.setValue(intV, forKey: "NoOfLegalLiablityEmployee")
        }

        if (def.bool(forKey:"IsPACoverUnnamedPerson"))
        {
            coverageDetails.setValue(def.integer(forKey:"UnNamedSumInsured"), forKey: "UnNamedSumInsured")
        }
        else
        {
            coverageDetails.setValue(intV, forKey: "UnNamedSumInsured")
        }

        if (def.bool(forKey:"IsPACoverPaidDriver"))
        {
            coverageDetails.setValue(def.integer(forKey:"PaidDriverSumInsured"), forKey: "PaidDriverSumInsured")
        }
        else
        {
            coverageDetails.setValue(intV, forKey: "PaidDriverSumInsured")
        }
        if (def.bool(forKey:"IsNoOfNFPP"))
        {
            coverageDetails.setValue(def.integer(forKey:"NoOfNFPP"), forKey: "NoOfNFPP")
        }
        else
        {
            coverageDetails.setValue(intV, forKey: "NoOfNFPP")
        }
        if (def.bool(forKey:"IsNoOfFPP"))
        {
            coverageDetails.setValue(def.integer(forKey:"NoOfFPP"), forKey: "NoOfFPP")
        }
        else
        {
            coverageDetails.setValue(intV, forKey: "NoOfFPP")
        }
        return coverageDetails
    }
    
    private func toCreatePrevPolicyInsurer() -> NSDictionary
    {
        let prevPolicyInsurer = NSMutableDictionary.init()
        prevPolicyInsurer.setValue(def.string(forKey:"PrevPolicyInsurerCompanyCode"), forKey: "CompanyCode")
        prevPolicyInsurer.setValue(def.string(forKey:"PrevPolicyInsurerCShortName"), forKey: "CShortName")
        prevPolicyInsurer.setValue(def.string(forKey:"PrevPolicyInsurerId"), forKey: "Id")
        prevPolicyInsurer.setValue(def.string(forKey:"PrevPolicyInsurerCompanyName"), forKey: "Name")
        prevPolicyInsurer.setValue(def.integer(forKey:"PrevPolicyInsurerIndex"), forKey: "Index")//position of that company in list
        prevPolicyInsurer.setValue(def.bool(forKey:"PrevPolicyInsurerChecked"), forKey: "Checked")
        return prevPolicyInsurer
    }
    
    
    private func toCreatePreviousPolicyDetails() -> NSDictionary
    {

        let PreviousPolicyDetails = NSMutableDictionary.init()
        let k = def.dictionary(forKey: "PrevPolicyExpiryStatus")! as NSDictionary
        let v = Int(k.object(forKey: "Id") as! String)
        if (!def.bool(forKey: "DontKnowPreviousInsurer") && (v != 2))
        {
            PreviousPolicyDetails.setValue(def.string(forKey:"ExpiryDate"), forKey: "PolicyEndDate")
        }
        PreviousPolicyDetails.setValue(def.bool(forKey:"IsPreviousInsuranceClaimed"), forKey: "IsPreviousInsuranceClaimed")
        if (def.string(forKey:"PolicyNumber") != nil)
        {
            PreviousPolicyDetails.setValue(def.string(forKey:"PolicyNumber"), forKey: "PolicyNumber")
        }
        else
        {
            PreviousPolicyDetails.setValue("123456789", forKey: "PolicyNumber")
        }
        PreviousPolicyDetails.setValue(def.string(forKey:"PreviousPolicyCityName"), forKey: "CityName")
        PreviousPolicyDetails.setValue(def.string(forKey:"PreviousPolicyCity"), forKey: "City")
        if (def.integer(forKey:"ClaimedAmount") != 0)
        {
            PreviousPolicyDetails.setValue(def.integer(forKey:"ClaimedAmount"), forKey: "ClaimedAmount")
        }
        else
        {
            PreviousPolicyDetails.setValue(0, forKey: "ClaimedAmount")
        }
        PreviousPolicyDetails.setValue(def.string(forKey:"PreviousPolicyState"), forKey: "State")
        PreviousPolicyDetails.setValue(def.string(forKey:"PreviousPolicyStateName"), forKey: "StateName")
        PreviousPolicyDetails.setValue(def.integer(forKey:"PreviousNcbPercentage"), forKey: "PreviousNcbPercentage")
        PreviousPolicyDetails.setValue(def.integer(forKey:"PreviousPolicyType"), forKey: "PreviousPolicyType")
        PreviousPolicyDetails.setValue(def.string(forKey:"PrevPolicyInsurerId"), forKey: "InsurerCode")
        PreviousPolicyDetails.setValue(def.string(forKey:"PrevPolicyInsurerCompanyName"), forKey: "InsurerName")
        return PreviousPolicyDetails
    }
    
    private func companyReferanceDetails(_ specificQuote: NSDictionary) -> NSDictionary
    {
        let companyReferanceDetails = NSMutableDictionary.init()
        companyReferanceDetails.setValue(specificQuote.object(forKey:"CompanyCode"), forKey: "CompanyCode")
        companyReferanceDetails.setValue(specificQuote.object(forKey:"CompanyOrderNumber") , forKey: "CompanyOrderNumber")
        companyReferanceDetails.setValue(specificQuote.object(forKey:"PremiumYear"), forKey: "CompanyPremiumYear")
        companyReferanceDetails.setValue(specificQuote.object(forKey:"CompanyQuotationNumber") , forKey: "CompanyQuotationNumber")
        companyReferanceDetails.setValue(specificQuote.object(forKey:"ExtraParameter2"), forKey: "ExtraParameter2")
        companyReferanceDetails.setValue(specificQuote.object(forKey:"ExtraParameter1"), forKey: "ExtraParameter1")
        return companyReferanceDetails
    }
    
    func proposalData(_mobileNo mobile: String, _otpValue otpV: String, _paymentMode pay: String, _response refDict: NSDictionary?, _agency agency: String?, _location location: String?, _mode mode: String?) -> NSDictionary
    {
        let specificQuoteReq = Common.sharedCommon.unArchiveMyDataForDictionary("SpecificQuotationRequest")
        let specificQuoteRes = Common.sharedCommon.unArchiveMyDataForDictionary("SpecificQuotationResponse")
        let proposalData = NSMutableDictionary.init()
        proposalData.setValue(specificQuoteReq!.object(forKey:"PlanName"), forKey: "PlanName")
        proposalData.setValue(specificQuoteReq!.object(forKey:"QuotationNumber"), forKey: "QuotationNumber")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PlanId"), forKey: "PlanId")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PlanCode"), forKey: "PlanCode")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PolicyEndDate"), forKey: "PolicyEndDate")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PolicyStartDate"), forKey: "PolicyStartDate")
        proposalData.setValue(specificQuoteReq!.object(forKey:"CompanyCode"), forKey: "CompanyCode")
        proposalData.setValue(specificQuoteReq!.object(forKey:"CompanyName"), forKey: "CompanyName")
        proposalData.setValue(specificQuoteReq!.object(forKey:"VehicleAddressDetails"), forKey: "VehicleAddressDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"CommunicationAddressDetails"), forKey: "CommunicationAddressDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"ClientDetails"), forKey: "ClientDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"CoverageDetails"), forKey: "CoverageDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"DiscountDetails"), forKey: "DiscountDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey: "IsVehicleFinanced"), forKey: "IsVehicleFinanced")
        proposalData.setValue(specificQuoteReq!.object(forKey: "FinancialInstAddress"), forKey: "FinancialInstAddress")
        proposalData.setValue(specificQuoteReq!.object(forKey: "FinancialInstName"), forKey: "FinancialInstName")
        proposalData.setValue(intV, forKey: "FinancialInstAmount")
        proposalData.setValue(specificQuoteReq!.object(forKey: "PrevPolicyInsurer"), forKey: "PrevPolicyInsurer")
        proposalData.setValue(specificQuoteReq!.object(forKey: "PreviousPolicyDetails"), forKey: "PreviousPolicyDetails")
        proposalData.setValue(def.integer(forKey:"PreviousNcbPercentage"), forKey: "NCBDiscountPercentage")
        proposalData.setValue(specificQuoteReq!.object(forKey:"NomineeDateOfBirth"), forKey: "NomineeDateOfBirth")
        proposalData.setValue(specificQuoteReq!.object(forKey:"NomineeName"), forKey: "NomineeName")
        proposalData.setValue(specificQuoteReq!.object(forKey:"NomineeRelation"), forKey: "NomineeRelation")
        proposalData.setValue(specificQuoteReq!.object(forKey:"NomineeGender"), forKey: "NomineeGender")
        proposalData.setValue(specificQuoteRes!.object(forKey:"FinalPremium"), forKey: "TotalPremium")
        proposalData.setValue(specificQuoteReq!.object(forKey:"IsApointeeRequired"), forKey: "IsApointeeRequired")
        proposalData.setValue(specificQuoteReq!.object(forKey: "AppointeeDateOfBirth"), forKey: "AppointeeDateOfBirth")
        proposalData.setValue(specificQuoteReq!.object(forKey: "AppointeeName"), forKey: "AppointeeName")
        proposalData.setValue(specificQuoteReq!.object(forKey: "AppointeeRelation"), forKey: "AppointeeRelation")
        proposalData.setValue(specificQuoteReq!.object(forKey: "CompanyIdvDetails"), forKey: "CompanyIdvDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PremiumBreakUpDetails"), forKey: "PremiumBreakUpDetails")
        proposalData.setValue(specificQuoteRes!.object(forKey:"InsuredDeclaredValue"), forKey: "IDVSumInsured")
        if ( def.string(forKey:"RequestedAddOnList") != nil)
        {
            proposalData.setValue(def.string(forKey:"RequestedAddOnList"), forKey: "RequestedAddOnList")
        }
        else
        {
            proposalData.setValue(NSArray.init(), forKey: "RequestedAddOnList")
        }
        proposalData.setValue(specificQuoteReq!.object(forKey: "HasValidPUC"), forKey: "HasValidPUC")
        if (specificQuoteReq!.object(forKey: "HasValidPUC") as! Bool)
        {
            proposalData.setValue(specificQuoteReq!.object(forKey: "PUCNumber"), forKey: "PUCNumber")
            proposalData.setValue(specificQuoteReq!.object(forKey: "PUCStartDate"), forKey: "PUCStartDate")
            proposalData.setValue(specificQuoteReq!.object(forKey: "PUCEndDate"), forKey: "PUCEndDate")
        }
        proposalData.setValue(specificQuoteReq!.object(forKey:"VehicleDetails"), forKey: "VehicleDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PremiumYear"), forKey: "PremiumYear")
        proposalData.setValue(companyReferanceDetails(specificQuoteRes!), forKey: "CompanyReferanceDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey: "IsRegistrationAddressSame"), forKey: "IsRegistrationAddressSame")
        proposalData.setValue(specificQuoteRes!.object(forKey:"ExShowroomPrice"), forKey: "ExShowroomPrice")
        proposalData.setValue(mobile, forKey: "MobileNumberForOTP")
        proposalData.setValue(otpV, forKey: "OneTimePassword")
        proposalData.setValue(pay, forKey: "PaymentMode")
        proposalData.setValue(falseValue, forKey: "IsZeroepCoverForRollOver")
        proposalData.setValue(specificQuoteRes!.object(forKey:"IDVDepreciationRate"), forKey: "IDVDepreciationRate")
        proposalData.setValue(specificQuoteReq!.object(forKey:"IsWhatsappMessageAllow"), forKey: "IsWhatsappMessageAllow")
        proposalData.setValue(specificQuoteReq!.object(forKey:"LimitedToOwnPremises"), forKey: "LimitedToOwnPremises")
        proposalData.setValue(def.object(forKey:"UserId"), forKey: "UserId")
        proposalData.setValue(specificQuoteRes!.object(forKey:"InspectionRequired"), forKey: "InspectionRequired")
        proposalData.setValue(def.string(forKey:"ProductName"), forKey: "ProductName")
        if (agency != nil)
        {
            proposalData.setValue(agency, forKey: "InspectionAgencies")
        }
        if (location != nil)
        {
            proposalData.setValue(location, forKey: "InspectionLocationCode")
        }
        if (mode != nil)
        {
            proposalData.setValue(mode, forKey: "InspectionMode")
        }
        //        proposalData.setValue("", forKey: "ExtistingPACoverDetails")
        //        proposalData.setValue("", forKey: "ChassisAndBodyPriceRate")
        //        proposalData.setValue("", forKey: "PreviousTPPolicyDetails")
        return firstThem(proposalData)
    }
    
    func secondProposalRequest(_ refId: String, _ proposal: String?, _ rmcode : String?, region : String?, _ POSDetails : NSDictionary?, _ posInclude : Bool, _ BreakinId : Int?, _ paymentAllow : Bool!) ->NSDictionary
    {
        let specificQuoteReq = Common.sharedCommon.unArchiveMyDataForDictionary("ProposalRequest")
        let proposalData = NSMutableDictionary.init()
        proposalData.setValue(specificQuoteReq!.object(forKey:"PlanName"), forKey: "PlanName")
        proposalData.setValue(specificQuoteReq!.object(forKey:"QuotationNumber"), forKey: "QuotationNumber")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PlanId"), forKey: "PlanId")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PlanCode"), forKey: "PlanCode")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PolicyEndDate"), forKey: "PolicyEndDate")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PolicyStartDate"), forKey: "PolicyStartDate")
        proposalData.setValue(specificQuoteReq!.object(forKey:"CompanyCode"), forKey: "CompanyCode")
        proposalData.setValue(specificQuoteReq!.object(forKey:"CompanyName"), forKey: "CompanyName")
        proposalData.setValue(specificQuoteReq!.object(forKey:"VehicleAddressDetails"), forKey: "VehicleAddressDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"CommunicationAddressDetails"), forKey: "CommunicationAddressDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"ClientDetails"), forKey: "ClientDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"CoverageDetails"), forKey: "CoverageDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"DiscountDetails"), forKey: "DiscountDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey: "IsVehicleFinanced"), forKey: "IsVehicleFinanced")
        proposalData.setValue(specificQuoteReq!.object(forKey: "FinancialInstAddress"), forKey: "FinancialInstAddress")
        proposalData.setValue(specificQuoteReq!.object(forKey: "FinancialInstName"), forKey: "FinancialInstName")
        proposalData.setValue(intV, forKey: "FinancialInstAmount")
        proposalData.setValue(specificQuoteReq!.object(forKey: "PrevPolicyInsurer"), forKey: "PrevPolicyInsurer")
        proposalData.setValue(specificQuoteReq!.object(forKey: "PreviousPolicyDetails"), forKey: "PreviousPolicyDetails")
        proposalData.setValue(def.integer(forKey:"PreviousNcbPercentage"), forKey: "NCBDiscountPercentage")
        proposalData.setValue(specificQuoteReq!.object(forKey:"NomineeDateOfBirth"), forKey: "NomineeDateOfBirth")
        proposalData.setValue(specificQuoteReq!.object(forKey:"NomineeName"), forKey: "NomineeName")
        proposalData.setValue(specificQuoteReq!.object(forKey:"NomineeRelation"), forKey: "NomineeRelation")
        proposalData.setValue(specificQuoteReq!.object(forKey:"NomineeGender"), forKey: "NomineeGender")
        proposalData.setValue(specificQuoteReq!.object(forKey:"FinalPremium"), forKey: "TotalPremium")
        proposalData.setValue(specificQuoteReq!.object(forKey:"NomineeGender"), forKey: "NomineeGender")
        proposalData.setValue(specificQuoteReq!.object(forKey:"IsApointeeRequired"), forKey: "IsApointeeRequired")
        proposalData.setValue(specificQuoteReq!.object(forKey: "AppointeeDateOfBirth"), forKey: "AppointeeDateOfBirth")
        proposalData.setValue(specificQuoteReq!.object(forKey: "AppointeeName"), forKey: "AppointeeName")
        proposalData.setValue(specificQuoteReq!.object(forKey: "AppointeeRelation"), forKey: "AppointeeRelation")
        proposalData.setValue(specificQuoteReq!.object(forKey: "CompanyIdvDetails"), forKey: "CompanyIdvDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PremiumBreakUpDetails"), forKey: "PremiumBreakUpDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"InsuredDeclaredValue"), forKey: "IDVSumInsured")
        if ( def.string(forKey:"RequestedAddOnList") != nil)
        {
            proposalData.setValue(def.string(forKey:"RequestedAddOnList"), forKey: "RequestedAddOnList")
        }
        else
        {
            proposalData.setValue(NSArray.init(), forKey: "RequestedAddOnList")
        }
        proposalData.setValue(specificQuoteReq!.object(forKey: "HasValidPUC"), forKey: "HasValidPUC")
        if (specificQuoteReq!.object(forKey: "HasValidPUC") as! Bool)
        {
            proposalData.setValue(specificQuoteReq!.object(forKey: "PUCNumber"), forKey: "PUCNumber")
            proposalData.setValue(specificQuoteReq!.object(forKey: "PUCStartDate"), forKey: "PUCStartDate")
            proposalData.setValue(specificQuoteReq!.object(forKey: "PUCEndDate"), forKey: "PUCEndDate")
        }
        proposalData.setValue(specificQuoteReq!.object(forKey:"VehicleDetails"), forKey: "VehicleDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey:"PremiumYear"), forKey: "PremiumYear")
        proposalData.setValue(specificQuoteReq!.object(forKey: "CompanyReferanceDetails"), forKey: "CompanyReferanceDetails")
        proposalData.setValue(specificQuoteReq!.object(forKey: "IsRegistrationAddressSame"), forKey: "IsRegistrationAddressSame")
        proposalData.setValue(specificQuoteReq!.object(forKey:"ExShowroomPrice"), forKey: "ExShowroomPrice")
        proposalData.setValue(specificQuoteReq!.object(forKey: "MobileNumberForOTP"), forKey: "MobileNumberForOTP")
        proposalData.setValue(specificQuoteReq!.object(forKey: "OneTimePassword"), forKey: "OneTimePassword")
        proposalData.setValue(specificQuoteReq!.object(forKey: "PaymentMode"), forKey: "PaymentMode")
        proposalData.setValue(specificQuoteReq!.object(forKey: "IsZeroepCoverForRollOver"), forKey: "IsZeroepCoverForRollOver")
        proposalData.setValue(specificQuoteReq!.object(forKey:"IDVDepreciationRate"), forKey: "IDVDepreciationRate")
        proposalData.setValue(specificQuoteReq!.object(forKey:"IsWhatsappMessageAllow"), forKey: "IsWhatsappMessageAllow")
        proposalData.setValue(specificQuoteReq!.object(forKey:"LimitedToOwnPremises"), forKey: "LimitedToOwnPremises")
        proposalData.setValue(specificQuoteReq!.object(forKey: "UserId"), forKey: "UserId")
        proposalData.setValue(specificQuoteReq!.object(forKey:"InspectionRequired"), forKey: "InspectionRequired")
        proposalData.setValue(specificQuoteReq!.object(forKey:"ProductName"), forKey: "ProductName")
            proposalData.setValue(specificQuoteReq!.object(forKey:"InspectionAgencies"), forKey: "InspectionAgencies")
            proposalData.setValue(specificQuoteReq!.object(forKey:"InspectionLocationCode"), forKey: "InspectionLocationCode")
        proposalData.setValue(specificQuoteReq!.object(forKey:"InspectionMode"), forKey: "InspectionMode")

        //        proposalData.setValue("", forKey: "ExtistingPACoverDetails")
        //        proposalData.setValue("", forKey: "ChassisAndBodyPriceRate")
        //        proposalData.setValue("", forKey: "PreviousTPPolicyDetails")

            proposalData.setValue(BreakinId, forKey: "BreakinId")
            proposalData.setValue(posInclude, forKey: "IsPOSIncluded")
            if (posInclude)
            {
                proposalData.setValue(POSDetails, forKey: "POSDetails")
            }
            else
            {
                proposalData.setValue(NSNull.init(), forKey: "POSDetails")
            }
            
            proposalData.setValue(paymentAllow, forKey: "IsPaymentAllow")
            proposalData.setValue(proposal, forKey: "ProposalNumber")
            proposalData.setValue(rmcode, forKey: "RMCode")
            proposalData.setValue(region, forKey: "Region")
            proposalData.setValue(refId, forKey: "ReferenceId")

        return firstThem(proposalData)
    }

    func forwardPaymentDetailsToClient(_ uToken: String)-> NSDictionary
    {
        let forwardPayment = NSMutableDictionary.init()
        let requestDetails = NSMutableDictionary.init()
        requestDetails.setValue(forwradResponse(uToken), forKey: "request")
        requestDetails.setValue(forwradResponse(uToken), forKey: "proposalResponse")
        requestDetails.setValue(forwradResponse(uToken), forKey: "ProposalDetails")
        forwardPayment.setValue(requestDetails, forKey: "model")
        forwardPayment.setValue(def.object(forKey:"UserId"), forKey: "UserId")
        return forwardPayment
    }
    
    func forwradResponse(_ uToken: String) -> NSDictionary
    {
        let dicttt = clientDetails()
        let specificQuoteReq = Common.sharedCommon.unArchiveMyDataForDictionary("SpecificQuotationRequest")

        let forwardResp = NSMutableDictionary.init()
        forwardResp.setValue(dicttt.object(forKey:"EmailAddress"), forKey: "mailId")
        forwardResp.setValue(def.string(forKey: "QuotationNumber"), forKey: "quotationNo")
        forwardResp.setValue(uToken, forKey: "uniqueTokenNo")
        forwardResp.setValue(specificQuoteReq!.object(forKey:"PlanName"), forKey: "PlanName")
        forwardResp.setValue(dicttt.object(forKey:"FirstName"), forKey: "FirstName")
        forwardResp.setValue(dicttt.object(forKey:"LastName"), forKey: "LastName")
        forwardResp.setValue(specificQuoteReq!.object(forKey:"CompanyName"), forKey: "CompanyName")
        forwardResp.setValue(def.string(forKey:"ProductName"), forKey: "ProductName")
        forwardResp.setValue(specificQuoteReq!.object(forKey:"FinalPremium"), forKey: "Premium")
        return forwardResp
    }
    
    func createCompanyIDVDetailsArray(_ dict : NSDictionary) -> NSDictionary
    {
        let idvDict = NSMutableDictionary.init()
        idvDict.setValue(dict.object(forKey:"CompanyCode"), forKey: "CompanyCode")
        idvDict.setValue(dict.object(forKey:"MinInsuredDeclaredValue"), forKey: "MinIDV")
        idvDict.setValue(dict.object(forKey:"MaxInsuredDeclaredValue"), forKey: "MaxIDV")
        idvDict.setValue(dict.object(forKey:"PlanId"), forKey: "PlanId")
        idvDict.setValue(dict.object(forKey:"InsuredDeclaredValue"), forKey: "IDV")
        return idvDict
    }
    
    func createDictForHealth() -> NSDictionary
    {
        let newDict = NSMutableDictionary.init()
        newDict.setValue("", forKey: "")
        return thoseAreFixed(newDict)
    }
}

//
//  Constant.swift
//  InsuranceApp
//
//  Created by Sankalp on 24/05/22.
//

import Foundation
import UIKit

class Constant
{
//    static let cons = Constant()
    static let DeviceId = UIDevice.current.model.capitalized
    static let PIBL = "PIBL"
    
    static let qualifiyReq = "QualifiedPlanRequest"
    static let qualifiyResp = "QualifiedPlanResponse"
    static let specificReq = "SpecificQuotationRequest"
    static let specificResp = "SpecificQuotationResponse"
    static let proposalReq = "ProposalRequest"
    static let proposalResp = "ProposalResponse"
    static let finalProposalReq = "FinalProposalRequest"
    static let companyRef = "CompanyReferanceDetails"
    static let clientDetails = "ClientDetails"
    static let addressDetails = "AddressDetails"
    static let healthMemDet = "HealthMemberDetails"
    static let healthQue = "HealthQuestion"
    static let quotePEDDet = "QuotePEDDetail"
    static let Multi_Ind_Details = "MultiIndividualAdultChildDetails"
    static let vehicleDetails = "VehicleDetails"
    static let PrevPolicyDetails = "PreviousPolicyDetails"
    static let PrevPolicyInsurer = "PrevPolicyInsurer"
    static let CoverageDet = "CoverageDetails"
    static let DiscountDet = "DiscountDetails"
    static let quotationDet = "Quotation"
    static let commuAddDet = "CommunicationAddressDetails"
    static let vehAddDetails = "VehicleAddressDetails"
    static let premBrUpDet = "PremiumBreakUpDetails"
    static let assets = "assets"
    static let que_resp = "question_responses"
    static let proposer = "proposer"
    static let perm_add = "permanent_address"
    static let corres_add = "correspondence_address"
    static let _VehModel = "&Model="
    static let _premium = "&Premium="
    static let _regYr = "&RegYear="
    static let _renewNCB = "&RenewalNCB="

    
    static let buyAPI = "https://buy"
    static let apiAPI = "https://api"
    static let baseURL = ".probusinsurance.com/"
    static let insurance = "insurance/"
    static let car_insur = "car-insurance/"
    static let twowheel_insur = "two-wheeler-insurance/"
    static let comVehInsur = "commercial-vehicle-insurance/"
    static let goodsCarry_insur = "goods-carrying/"
    static let passCarry_insur = "passenger-carrying/"
    static let miscVeh_insur = "misc-d/"
    static let home = "Home/"
    static let forApi = "api/"
    static let motor = "Motor/"
    static let privatecar = "PrivateCar/"
    static let twowheeler = "TwoWheeler/"
    static let gc_pc_misc_insur = "GetCommercialInsuranceCompany/"
    static let goodCom = "GoodsCommercialVehicle/"
    static let passCom = "PassengerCommercialVehicle/"
    static let miscCom = "Miscellaneousvehicle/"
    static let addon = "AddOn"
    static let vehBodyType = "VehicleBodyType"
    static let VehUsagetype = "VehicleUsagetype"
    static let vehColor = "VehicleColor"
    static let stateBy = "StateByCompanyCode"
    static let cityBy = "CityByState"
    static let stateCode = "&stateCode="
    static let pin_check = "PincodeCheck?Pincode="
    static let validVehCheck = "ChkValidVehicleRegNoBySubProduct"
    static let quotationDetails = "GetUserDetailsFromQuotation"
    static let hypothet = "Hypothentication"
    static let rtoCity = "RTOcityJson"
    static let manufacturer = "ManufacturerJson"
    static let model = "AllModelJson"
    static let variant = "AllVariantJson"
    static let probusRenewal = "PreviousInsurerForBrokerRenewal"
    static let salutation = "Salutation"
    static let maritalStatus = "MaritalStatus"
    static let relationship = "NomineeRelationship"
    static let occupation = "Occupation"
    static let companyC = "?companyCode="
    static let companyId = "?companyId="
    static let _companyId = "&companyId="
    static let termLife = "life/termlife/"
    static let coverAmt = "CoverageAmountWithWord"
    static let VehRegiDetail = "GetRegistrationDetailMobile"
    static let GetDetProbusRenew = "GetDetailsForProbusRenewal"
    static let comp_spec_quote = "CompanySpecificQuotation"
    static let proposal = "Proposal"
    static let vehNo = "?vehicleNumber="
    static let tokenNum = "&token="
    static let _subprod = "&subproduct="
    static let _prodCode = "&productCode="
    static let _subProdCode = "&subProductCode="
    static let subProd_id = "?subProductId="
    static let mobNumb = "&mobileNumber="
    static let client = "Client/"
    static let sendToClient = "SendToClientMobile"
    static let gen_otp = "GenerateOTP"
    static let for_motor = "ForMotor"
    static let conf_val_otp = "ConfirmAndValidateOTP"
    static let _clientName = "&clientName="
    static let _emailId = "&emailId="
    static let quot_Num = "?quotationNumber="
    static let _quotationNum = "&quotationNumber="
    static let MTRPC = "MTRPC"
    static let HELIN = "HELIN"
    static let HELFM = "HELFM"
    static let MTRTW = "MTRTW"
    static let TRAIN = "TRAIN"
    static let TRAFM = "TRAFM"
    static let TRAMT = "TRAMT"
    static let TRAST = "TRAST"
    static let MTRPV = "MTRPV"
    static let MTRGV = "MTRGV"
    static let SMEWC = "SMEWC"
    static let SMEFB = "SMEFB"
    static let SMEMR = "SMEMR"
    static let SMEHO = "SMEHO"
    static let MTRMV = "MTRMV"
    static let MICMB = "MICMB"
    static let qualifyComp = "QualifiedCompany"
    static let companylogo = "img/companylogo/"
    static let brokerId = "?BrokerId="
    static let _device = "&DeviceId="
    static let _prevInsurerCode = "&previousInsurerCode="
    static let _prevPolicyNumb = "&previousPolicyNumber="
    static let _regNumb = "&registrationNumber="
    static let breakin_Yes = "?BreakIn=Yes"
    static let breakin_No = "?BreakIn=No"
    
    static let health = "health/"
    static let childRelate = "?childrelation="
    static let relation = "Relation"
    static let multi_ind = "multiindividual/"
    static let healthFamily = "Family/"
    static let individual = "Individual/"
    static let lifeInsur = "life-insurance/"
    static let homeInsur = "home-insurance/"
    static let buisnessInsur = "business-insurance/"
    static let indexx = "index"
    static let user_ID = "?userId="
}
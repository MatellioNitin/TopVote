//
//  Competition+Requests.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation

extension Survey {
    // MARK: * Instance methods
    
    static func getSurvey(surveyID: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ survey: Survey) -> Void) {
        Survey.provider.request(Survey.API.getSurvey(getSurveyId: surveyID)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let surveyObj: Survey = Survey.create(data: value)!
                    completion(surveyObj)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }

    static func setSurvey(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ surveys: Surveys) -> Void) {
        Survey.provider.request(Survey.API.setSurvey(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                     let surveyObj:Surveys = Survey.models(data: value)
                    
                   // let surveyObj: Surveys = Survey.create(data: value)!
                    completion(surveyObj)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }

}


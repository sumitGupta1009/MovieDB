
import UIKit
import Foundation
import Alamofire


class ErrorObject:NSObject {

    var errorMessage: String = ""
    var errorCode: Int = 0

    init(errCode:Int,errMessage:String) {
        super.init()
        self.errorCode = errCode
        self.errorMessage = errMessage
    }
}

enum NetworkEnvironment {
    case dev
    case production
}


enum EndpointItem {
    // MARK: User actions
    case PopularMovie(pageNumber : String)
    case HighestRated(pageNumber : String)
    case SearchMovie(searchText : String, pageNumber :String)
}

protocol ApiConfig {

    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
}

// MARK: - Extensions
extension EndpointItem: ApiConfig {

    var baseURL: String {
        switch WebServiceManager.networkEnviroment {
        case .dev: return ServiceApiPath.shared.baseUrl
        case .production: return ""
        }
    }

    var path: String {
        switch self {
        case .PopularMovie:
            return ServiceApiPath.shared.popularMovie
        case .HighestRated:
            return ServiceApiPath.shared.highestRated
        case .SearchMovie:
            return ServiceApiPath.shared.searchMovie
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .PopularMovie, .HighestRated, .SearchMovie:
            return .get
            /*default:
             return .get*/
        }
    }

    var headers: HTTPHeaders? {
        switch self {
//        case :
//            return ["content-type": "application/json",
//                    "AuthorizeToken" : "some value"]

        case .PopularMovie, .HighestRated, .SearchMovie:
            return ["AuthorizeToken" : "some value"]
        }
    }

   
    
    var url: URL {
        switch self {
        case .PopularMovie(let pageNumber):
            return URL(string: self.baseURL + self.path + pageNumber)!
        case .HighestRated(let pageNumber):
            return URL(string: self.baseURL + self.path + pageNumber)!
        case .SearchMovie(let searchText, let pageNumber):
            let url = self.baseURL + self.path + searchText + "&page=" + pageNumber
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

            return URL(string: urlString!)!
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
}

class WebServiceManager: NSObject {

    static let sharedInstance = WebServiceManager()
    static let networkEnviroment: NetworkEnvironment = .dev

    func requestAPI<T:Codable>(serviceEndpoint : EndpointItem, parameters : [String:Any]? = nil,  objectType : T.Type, isHud : Bool,controller : UIViewController, success : @escaping (_ responseData : T) -> Void, errorBlock: @escaping (_ errorData : ErrorObject) -> Void){

        DispatchQueue.main.async {
            // Show activity indicator and ignore user interaction
            UIApplication.shared.beginIgnoringInteractionEvents()
        }

        Alamofire.request(serviceEndpoint.url, method: serviceEndpoint.httpMethod, parameters: parameters, encoding: serviceEndpoint.encoding, headers : serviceEndpoint.headers).responseData { response in

            DispatchQueue.main.async {
                // Hide activity indicator and enable user interaction
                UIApplication.shared.endIgnoringInteractionEvents()
            }

            if response.response?.statusCode == 200 {
                if let data = response.data {
                    do {
                        let sysDataa = try JSONDecoder().decode(T.self, from: data)
                        print(sysDataa)
                    } catch let error{
                        print(error)
                    }
                }
                //return
            }
            switch response.result {
            case .success:
                do {
                    
                    if let JSONString = String(data: response.data!, encoding: String.Encoding.utf8)
                    {
                        print(JSONString)
                    }
                    // Hide activity indicator and
                    let sysData = try JSONDecoder().decode(T.self, from: response.data!)
                    DispatchQueue.main.async {
                        success(sysData)
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error)

            }
        }
    }

    func uploadFiles<T : Codable>(serviceEndpoint : EndpointItem, imageArray : [String:UIImage], parameters : [String:String], url : String, objectType : T.Type, controller : UIViewController, success : @escaping (_ responseData : T) -> Void,errorBlock: @escaping (_ errorData : ErrorObject) -> Void){

        DispatchQueue.main.async {
            // Hide activity indicator and enable user interaction
            UIApplication.shared.endIgnoringInteractionEvents()
        }

        let serviceURL = serviceEndpoint.url
        Alamofire.upload(multipartFormData: { (multipartFormData) in

            for (key,value) in imageArray {
                let image:UIImage?
                image = value
                if (image != nil) {
                    let jpegImage = image?.jpegData(compressionQuality: 1)
                    if(jpegImage != nil){
                        multipartFormData.append((image?.jpegData(compressionQuality: 1)!)!, withName: key, fileName: "\(key).jpeg", mimeType: "image/jpeg")
                    }else{
                        print("empty image")
                    }
                }else{
                    print("empty image")
                }
            }

            for (key,value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }

        }, to: serviceURL , headers: serviceEndpoint.headers )
        { (result) in

            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })

                upload.responseJSON(completionHandler: { (response) in

                    DispatchQueue.main.async {
                        // Hide activity indicator and enable user interaction
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    switch response.result {
                    case .success:
                        do {
                            _ = String(data: response.data!, encoding: String.Encoding.utf8) as String?
                            //print(backToString)
                            let sysData = try JSONDecoder().decode(T.self, from: response.data!) as T
                            //print(sysData)

                            DispatchQueue.main.async {
                                success(sysData)
                            }
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    case .failure(let error):
                        print(error)
                    }
                })

            case .failure(let encodingError):
                print(encodingError.localizedDescription)
            }
        }
    }
    func uploadFilesData<T : Codable>(serviceEndpoint : EndpointItem, fileData :Data,mimeType:String, parameters : [String:String],fileName:String, objectType : T.Type, controller : UIViewController, success : @escaping (_ responseData : T) -> Void,errorBlock: @escaping (_ errorData : ErrorObject) -> Void){

        DispatchQueue.main.async {
            // Hide activity indicator and enable user interaction
            UIApplication.shared.endIgnoringInteractionEvents()
        }

        let serviceURL = serviceEndpoint.url
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append((fileData), withName: "file", fileName:fileName, mimeType: mimeType)


            for (key,value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }

        }, to: serviceURL , headers: serviceEndpoint.headers )
        { (result) in

            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })

                upload.responseJSON(completionHandler: { (response) in

                    DispatchQueue.main.async {
                        // Hide activity indicator and enable user interaction
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    switch response.result {
                    case .success:
                        do {
                            _ = String(data: response.data!, encoding: String.Encoding.utf8) as String?
                            //print(backToString)
                            let sysData = try JSONDecoder().decode(T.self, from: response.data!) as T
                            //print(sysData)

                            DispatchQueue.main.async {
                                success(sysData)
                            }
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    case .failure(let error):
                        print(error)
                    }
                })

            case .failure(let encodingError):
                print(encodingError.localizedDescription)
            }
        }
    }

}

//
//  ConasysURL.h
//  Conasys
//
//  Created by user on 

#ifndef Conasys_ConasysURL_h
#define Conasys_ConasysURL_h


//#define BASE_SERVER_URL @"http://54.85.86.49/"

//#define BASE_SERVER_URL @"http://conasys-dev-01:8080/ConasysService.svc/"

//#define BASE_SERVER_URL @"http://192.168.2.5:8080/ConasysService.svc/"

//NEW URL on AUG 2014

//**************************
//******STAGING SERVER******
//**************************
//#define BASE_SERVER_URL @"http://54.187.5.206:80/ConasysService.svc/"

//**************************
//*****PRODUCTION SERVER****
//**************************
#define BASE_SERVER_URL @"http://api.homeinformationpackages.com/ConasysService.svc/"

#define URL_LOGIN [NSString stringWithFormat:@"%@AuthenticateUser", BASE_SERVER_URL]

//#define URL_PROJECT_LIST [NSString stringWithFormat:@"%@GetProjectList", BASE_SERVER_URL]
#define URL_PROJECT_LIST [NSString stringWithFormat:@"%@Builder", BASE_SERVER_URL]

#define URL_REGISTER_OWNER [NSString stringWithFormat:@"%@RegisterUser", BASE_SERVER_URL]

#define URL_EDIT_OWNER [NSString stringWithFormat:@"%@EditUser", BASE_SERVER_URL]

#define URL_SUBMIT_REVIEW [NSString stringWithFormat:@"%@SubmitDeficiencyReview", BASE_SERVER_URL]

#endif

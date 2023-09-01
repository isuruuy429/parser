import ballerina/log;
import ballerinax/health.fhir.r4.parser;
import ballerinax/health.fhir.r4.international401;

//import ballerinax/health.fhir.r4.uscore501;

//If both profile and targetModelType are not passed as parameters, extract profile from payload if exists and parse against that profile.
json payload1 = {
    "resourceType": "Patient",
    "id": "1",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "identifier": [
        {
            "use": "usual",
            "type": {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                        "code": "MR",
                        "display": "Medical Record Number"
                    }
                ],
                "text": "Medical Record Number"
            },
            "system": "http://hospital.smarthealthit.org",
            "value": "1032704"
        }
    ],
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "managingOrganization": {
        "reference": "Organization/1"
    }
};

//Extract the resourceType(mandatory field) from payload and derive the baseProfile and parse against the baseProfile.
json payload2 = {
    "resourceType": "Patient",
    "id": "1",
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Hart",
            "given": [
                "Peter",
                "James"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "managingOrganization": {
        "reference": "Organization/1"
    }
};

//If even unable to derive the baseProfile throw an FHIRParsingError.
json payload3 = {
    "resourceType": "Patients",
    "id": "1",
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Hart",
            "given": [
                "Peter",
                "James"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "fff",
    "managingOrganization": {
        "reference": "Organization/1"
    }
};

public function main() {
    do {
        // testing scenario 1
        // Check for resource profile passed as a parameter to parser function and parse against that profile.
        //uncommment -> import ballerinax/health.fhir.r4.uscore501;
        //Comment -> import ballerinax/health.fhir.r4.international401;

        // uscore501:USCorePatientProfile patientModel = <uscore501:USCorePatientProfile>check parser:parse(payload1, targetProfile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient");

        //Scenario 2
        //If profile is not passed as a parameter, check for targetModelType passed as a parameter to parser function and parse against that targetModelType.

        international401:Patient patientModel = <international401:Patient>check parser:parse(payload1, international401:Patient);

        // testing scenario 3
        //If both profile and targetModelType are not passed as parameters, extract profile from payload if exists and parse against that profile.
        // international401:Patient patientModel = <international401:Patient>check parser:parse(payload1);

        //Scenario 4
        //If all above 3 scenarios are unsuccessful, extract the resourceType(mandatory field) from payload and derive the baseProfile and parse against the baseProfile.
        // international401:Patient patientModel = <international401:Patient>check parser:parse(payload2);

        log:printInfo(string `Patient name: ${patientModel.name.toString()}`);
        log:printInfo(string `Patient gender: ${patientModel.gender.toString()}`);
        log:printInfo(string `Patient birthdate: ${patientModel.birthDate.toString()}`);
    } on fail error parseError {
        log:printError(string `Error occurred while parsing : ${parseError.message()}`, parseError);
    }
}

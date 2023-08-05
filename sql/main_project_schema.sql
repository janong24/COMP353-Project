-- TABLE CREATIONS--

-- Persons

CREATE TABLE Persons(
    PersonID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    DateOfBirth DATE,
    MedicareNumber VARCHAR(255),
    MedicareExpiry DATE,
    TelephoneNumber VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(50),
    Province VARCHAR(50),
    PostalCode VARCHAR(50),
    Citizenship VARCHAR(50),
    Email VARCHAR(255)
);

-- Infection

CREATE TABLE TypeOfInfections(
    TypeID INT PRIMARY KEY,
    TypeName VARCHAR(255)
);

INSERT INTO TypeOfInfections(TypeID, TypeName) 
VALUES (1, 'COVID-19'), 
       (2, 'SARS-CoV-2 Variant'), 
       (3, 'Other');

CREATE TABLE Infections(
    InfectionID INT PRIMARY KEY,
    DateOfInfection DATE,
    TypeID INT,
    PersonID INT,
    FOREIGN KEY (TypeID) REFERENCES TypeOfInfections(TypeID),
    FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)
);

-- Vaccinations
CREATE TABLE TypeOfVaccinations(
    VaccineID INT PRIMARY KEY,
    VaccineName VARCHAR(255)
);

INSERT INTO TypeOfVaccinations(VaccineID, VaccineName) 
VALUES (1, 'Pfizer'), 
       (2, 'Moderna'), 
       (3, 'AstraZeneca'), 
       (4, 'Johnson & Johnson');

CREATE TABLE Vaccinations(
    VaccinationID INT PRIMARY KEY,
    VaccinationDate DATE,
    DoseNumber INT,
    VaccineID INT,
    PersonID INT,
    FOREIGN KEY (VaccineID) REFERENCES TypeOfVaccinations(VaccineID),
    FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)
);

-- Ministry

CREATE TABLE Ministries(
    MinistryID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    Province VARCHAR(255),
    PostalCode VARCHAR(10),
    PhoneNumber VARCHAR(15),
    WebAddress VARCHAR(255),
    Capacity INT,
    MinisterOfEducationID INT,
    FOREIGN KEY (MinisterOfEducationID) REFERENCES Persons(PersonID)
);

-- EPSTS ----------------

-- Facilities ----------------

CREATE TABLE FacilityTypes (
    TypeID INT PRIMARY KEY,
    TypeName VARCHAR(255),
    SubTypeName VARCHAR(255)
);

INSERT INTO FacilityTypes(TypeID, TypeName, SubTypeName)
VALUES 
(1, 'Management', 'Head Office'),
(2, 'Management', 'General Management'),
(3, 'Education', 'Primary School'),
(4, 'Education', 'Middle School'),
(5, 'Education', 'High School');

CREATE TABLE PossibleFacilitiesTypes (
    FacilityID INT,
    TypeID INT,
    PRIMARY KEY (FacilityID, TypeID),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID),
    FOREIGN KEY (TypeID) REFERENCES FacilityTypes(TypeID)
);

CREATE TABLE Facilities (
    FacilityID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    Province VARCHAR(255),
    PostalCode VARCHAR(10),
    PhoneNumber VARCHAR(15),
    WebAddress VARCHAR(255),
    Capacity INT,
    MinistryID INT,
    FacilityTypeID INT,
    FOREIGN KEY (MinistryID) REFERENCES Ministries(MinistryID),
    FOREIGN KEY (FacilityTypeID) REFERENCES FacilityTypes(FacilityTypeID)
);

-- Employee

CREATE TABLE EmployeeType (
    EmployeeTypeID INT PRIMARY KEY,
    EmployeeType VARCHAR(255)
);

INSERT INTO EmployeeType(EmployeeTypeID, EmployeeType)
VALUES 
(1, 'Teacher'),
(2, 'Administrative Staff'),
(3, 'Support Staff'),
(4, 'Secretary'),
(5, 'Principal');

CREATE TABLE Specialization (
  SpecializationID INT PRIMARY KEY,
  Specialization VARCHAR(255)
);

CREATE TABLE EmployeeRegistrations (
    PersonID INT,
    FacilityID INT,
    StartDate DATE,
    EndDate DATE,
    EmployeeTypeID INT,
    SpecializationID INT,
    PRIMARY KEY (PersonID, FacilityID, StartDate),
    FOREIGN KEY (PersonID) REFERENCES Persons(PersonID),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID),
    FOREIGN KEY (EmployeeTypeID) REFERENCES EmployeeType(EmployeeTypeID),
    FOREIGN KEY (SpecializationID) REFERENCES Specialization(SpecializationID)
);

INSERT INTO Specialization (SpecializationID, Specialization)
VALUES 
(1, 'Math'),
(2, 'Science'),
(3, 'Arts'),
(4, 'School Counselor'),
(5, 'Program Director'),
(6, 'School Administrator');

-- Students 

CREATE TABLE SchoolType (
    SchoolTypeID INT PRIMARY KEY,
    SchoolType VARCHAR(255)
);

INSERT INTO SchoolType(SchoolTypeID, SchoolType)
VALUES 
(1, 'Elementary School'),
(2, 'Middle School'),
(3, 'High School');

CREATE TABLE StudentRegistrations (
    PersonID INT,
    FacilityID INT,
    StartDate DATE,
    EndDate DATE,
    SchoolTypeID INT,
    SchoolLevel INT,
    PRIMARY KEY (PersonID, FacilityID, StartDate),
    FOREIGN KEY (PersonID) REFERENCES Persons(PersonID),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID),
    FOREIGN KEY (SchoolTypeID) REFERENCES SchoolType(SchoolTypeID)
);

-- new additions

CREATE TABLE EmailContent(
  emailContentID INT PRIMARY KEY,
  emailSubject VARCHAR(255),
  emailBody VARCHAR(255),
  emailDate DATE
);

CREATE TABLE EmailLogs(
  emailContentID INT,
  facilityID INT,
  emailReceiverID INT,
  PRIMARY KEY (emailContentID, facilityID),
  FOREIGN KEY (emailContentID) REFERENCES EmailContent(emailContentID),
  FOREIGN KEY (facilityID) REFERENCES Facilities(facilityID),
  FOREIGN KEY (emailReceiverID) REFERENCES EmployeeRegistrations(PersonID)
);

-- TODO add constraints for conflicting schedules, vaccinations, and infections
-- NOTE: mysql doesnt rly support constraints might have to use triggers instead
CREATE TABLE Schedules(
  scheduleID INT PRIMARY KEY,
  personID INT,
  facilityID INT,
  startTime DATETIME,
  endTime DATETIME,
  FOREIGN KEY (personID) REFERENCES REFERENCES EmployeeRegistrations(PersonID),
  FOREIGN KEY (facilityID) REFERENCES Facilities(facilityID),
  CONSTRAINT CHK_TIME CHECK (startTime < endTime),
  CONSTRAINT CHK_ADV CHECK (
    DATE(startTime) <= DATE_ADD(CURRENT_DATE(), INTERVAL +4 WEEK)
  )
);

CREATE TABLE Assignments(
    assignmentID INT PRIMARY KEY,
    assignmentDescription VARCHAR(255),
    teacherID INT,
    facilityID INT,
    dueDate DATE,
    FOREIGN KEY (teacherID) REFERENCES EmployeeRegistrations(PersonID),
    FOREIGN KEY (facilityID) REFERENCES Facilities(facilityID)
);

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
  FOREIGN KEY (emailReceiverID) REFERENCES Persons(personID)
);

-- TODO add constraints for conflicting schedules, vaccinations, and infections
-- NOTE: mysql doesnt rly support constraints might have to use triggers instead
CREATE TABLE Schedules(
  scheduleID INT PRIMARY KEY,
  personID INT,
  facilityID INT,
  startTime DATETIME,
  endTime DATETIME,
  FOREIGN KEY (personID) REFERENCES Persons(personID),
  FOREIGN KEY (facilityID) REFERENCES Facilities(facilityID),
  CONSTRAINT CHK_TIME CHECK (startTime < endTime),
  CONSTRAINT CHK_ADV CHECK (
    DATE(startTime) <= DATE_ADD(CURRENT_DATE(), INTERVAL +4 WEEK)
  )
);
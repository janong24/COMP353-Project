-- Infected Teacher Trigger
DELIMITER |
CREATE TRIGGER TeacherInfectedTrigger
  AFTER INSERT ON Infections
  FOR EACH ROW
  BEGIN
    IF NEW.personID IN (
        SELECT personID
          FROM EmployeeRegistrations AS er
          JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
          WHERE et.employeeType = 'Teacher'
      )
      THEN  
        INSERT INTO EmailContent(emailSubject, emailBody, emailDate) VALUES (
          CONCAT('Warning - COVID-19 Infection of ', NEW.personID, ' on ', CAST(NEW.DateOfInfection AS CHAR)),
          CONCAT((SELECT CONCAT(firstName, lastName) FROM Persons WHERE Persons.personID = NEW.personID), ' who teaches at your school has been infected with COVID-19 on ', CAST(NEW.DateOfInfection AS CHAR)),
          CURRENT_DATE()
        );
        INSERT INTO EmailLogs VALUES (
          (
            SELECT emailContentID 
              FROM EmailContent 
              WHERE emailSubject COLLATE utf8mb4_general_ci = CONCAT('Warning - COVID-19 Infection of ', NEW.personID, ' on ', CAST(NEW.DateOfInfection AS CHAR))
          ),
          (
            SELECT MIN(facilityID)
              FROM EmployeeRegistrations AS er
              WHERE er.personID = NEW.personID
          ),
          (
            SELECT personID
              FROM EmployeeRegistrations AS er
              JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
              WHERE et.employeeType = 'Principal'
              AND er.facilityID = (
                SELECT MIN(facilityID)
                  FROM EmployeeRegistrations AS er
                  WHERE er.personID = NEW.personID
              )
          )
        );
        DELETE FROM Assignments
          WHERE Assignments.teacherID = NEW.personID
          AND Assignments.dueDate <= DATE_ADD(CURRENT_DATE(), INTERVAL 14 DAY)
          AND Assignments.dueDate >= CURRENT_DATE();
    END IF;
  END;
|

DELIMITER ;

-- NoConflictingScheduleTrigger
DELIMITER |
CREATE TRIGGER NoConflictingScheduleTrigger
  AFTER INSERT ON Schedules
  FOR EACH ROW
  BEGIN
    IF EXISTS (
      SELECT * FROM Schedules
        WHERE Schedules.personID = NEW.personID
        AND (
          NEW.startTime BETWEEN Schedules.startTime AND Schedules.endTime
          OR 
          NEW.endTime BETWEEN Schedules.startTime AND Schedules.endTime
        )
    )
      THEN  
      signal sqlstate '45000' set message_text = 'Cant schedule employee on conflicting times';
      DELETE FROM Schedules 
        WHERE Schedules.scheduleID = NEW.scheduleID;
    END IF;
  END;
|

DELIMITER ;


-- Trigger that checks if the person scheduled has been vaccinated in the past 6 months. 
-- Basically checks the number of vaccinations done in the past 6 months. If it returns 0, then an error is signaled. Otherwise the person is vaccinated in the past 6 months.
DELIMITER |
CREATE TRIGGER ScheduleVaccineCheck
  BEFORE INSERT ON Schedules
  FOR EACH ROW
  BEGIN
     DECLARE vaccineCount INT;
  
     SELECT COUNT(*) INTO vaccineCount
     FROM Vaccinations
     WHERE Vaccinations.PersonID = NEW.PersonID
     AND Vaccinations.VaccinationDate >= DATE_SUB(NEW.StartTime, INTERVAL 6 MONTH)
     AND Vaccinations.VaccinationDate <= NEW.StartTime
     AND Vaccinations.VaccineID IN (SELECT VaccineID FROM TypeOfVaccinations WHERE VaccineName = 'COVID-19');
  
     IF vaccineCount = 0 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot schedule employee without COVID-19 vaccination in the past six months';
     END IF;
END;
|
DELIMITER ;

-- Trigger that checks overlapping student registration dates.
-- Basically tries to look for atleast 1 registration with EndDate Null, or StartDate of new registration between a current registration witha  StartDate and EndDate.
DELIMITER |
CREATE TRIGGER CheckStudentRegistration
  BEFORE INSERT ON StudentRegistrations
  FOR EACH ROW
  BEGIN
     IF EXISTS (
        SELECT 1 
        FROM StudentRegistrations 
        WHERE StudentID = NEW.PersonID
        AND (
           (NEW.StartDate BETWEEN StartDate AND IFNULL(EndDate, NEW.StartDate))
           OR (NEW.EndDate IS NOT NULL AND NEW.EndDate BETWEEN StartDate AND IFNULL(EndDate, NEW.EndDate))
        )
     ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A student cannot be registered at more than one facility at the same time';
     END IF;
END;
|
DELIMITER ;

-- Trigger that checks overlapping employee registration dates. Same thing as Student registration
-- Basically tries to look for atleast 1 registration with EndDate Null, or StartDate of new registration between a current registration witha  StartDate and EndDate.
DELIMITER |
CREATE TRIGGER CheckEmployeeRegistration
BEFORE INSERT ON EmployeeRegistrations
FOR EACH ROW
BEGIN
   IF EXISTS (
      SELECT 1 
      FROM EmployeeRegistrations 
      WHERE EmployeeID = NEW.PersonID
      AND (
         (NEW.StartDate BETWEEN StartDate AND IFNULL(EndDate, NEW.StartDate))
         OR (NEW.EndDate IS NOT NULL AND NEW.EndDate BETWEEN StartDate AND IFNULL(EndDate, NEW.EndDate))
      )
   ) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'An employee cannot be registered at more than one facility at the same time';
   END IF;
END;
|
DELIMITER ;



DELIMITER |

CREATE TRIGGER SendWeeklyEmailSchedule
AFTER INSERT ON Schedules
FOR EACH ROW
BEGIN

   DECLARE startDate DATE;
   DECLARE endDate DATE;
   DECLARE emailSubject VARCHAR(255);
   DECLARE emailBody TEXT;
   DECLARE facilityName VARCHAR(255);
   DECLARE facilityAddress VARCHAR(255);
   DECLARE employeeFirstName VARCHAR(255);
   DECLARE employeeLastName VARCHAR(255);
   DECLARE employeeEmail VARCHAR(255);
   
   SET startDate = CURDATE() - INTERVAL DAYOFWEEK(CURDATE()) + 2 DAY;
   SET endDate = startDate + INTERVAL 6 DAY;
   
   SELECT Name, Address INTO facilityName, facilityAddress
   FROM Facilities 
   WHERE FacilityID = NEW.facilityID;

   SELECT FirstName, LastName, Email INTO employeeFirstName, employeeLastName, employeeEmail
   FROM Persons 
   WHERE PersonID = NEW.personID;

   SET emailSubject = CONCAT(facilityName, ' Schedule for ', startDate, ' to ', endDate);
   SET emailBody = CONCAT(
      'Facility Name: ', facilityName, '\n',
      'Facility Address: ', facilityAddress, '\n',
      'Employee First Name: ', employeeFirstName, '\n',
      'Employee Last Name: ', employeeLastName, '\n',
      'Employee Email: ', employeeEmail, '\n\n',
      'Details of the schedule for the coming week:\n',
      (SELECT IFNULL(CONCAT('Monday: ', TIME(startTime), ' - ', TIME(endTime)), 'Monday: No Assignment') 
       FROM Schedules WHERE personID = NEW.personID AND facilityID = NEW.facilityID AND DATE(startTime) = startDate), '\n',
      (SELECT IFNULL(CONCAT('Tuesday: ', TIME(startTime), ' - ', TIME(endTime)), 'Tuesday: No Assignment') 
       FROM Schedules WHERE personID = NEW.personID AND facilityID = NEW.facilityID AND DATE(startTime) = startDate + INTERVAL 1 DAY), '\n',
      (SELECT IFNULL(CONCAT('Wednesday: ', TIME(startTime), ' - ', TIME(endTime)), 'Wednesday: No Assignment') 
       FROM Schedules WHERE personID = NEW.personID AND facilityID = NEW.facilityID AND DATE(startTime) = startDate + INTERVAL 2 DAY), '\n',
      (SELECT IFNULL(CONCAT('Thursday: ', TIME(startTime), ' - ', TIME(endTime)), 'Thursday: No Assignment') 
       FROM Schedules WHERE personID = NEW.personID AND facilityID = NEW.facilityID AND DATE(startTime) = startDate + INTERVAL 3 DAY), '\n',
      (SELECT IFNULL(CONCAT('Friday: ', TIME(startTime), ' - ', TIME(endTime)), 'Friday: No Assignment') 
       FROM Schedules WHERE personID = NEW.personID AND facilityID = NEW.facilityID AND DATE(startTime) = startDate + INTERVAL 4 DAY), '\n',
      (SELECT IFNULL(CONCAT('Saturday: ', TIME(startTime), ' - ', TIME(endTime)), 'Saturday: No Assignment') 
       FROM Schedules WHERE personID = NEW.personID AND facilityID = NEW.facilityID AND DATE(startTime) = startDate + INTERVAL 5 DAY), '\n',
      (SELECT IFNULL(CONCAT('Sunday: ', TIME(startTime), ' - ', TIME(endTime)), 'Sunday: No Assignment') 
       FROM Schedules WHERE personID = NEW.personID AND facilityID = NEW.facilityID AND DATE(startTime) = startDate + INTERVAL 6 DAY)
   );

   -- Save email to log
   INSERT INTO EmailContent(emailSubject, emailBody, emailDate) VALUES(emailSubject, LEFT(emailBody, 255), CURDATE());
   INSERT INTO EmailLogs(emailContentID, facilityID, emailReceiverID) VALUES (LAST_INSERT_ID(), NEW.facilityID, NEW.personID);
END;
|
DELIMITER ;


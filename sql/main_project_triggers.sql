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
          CONCAT('Warning - COVID-19 Infection of ', NEW.personID, ' on ', CAST(CURRENT_DATE AS CHAR)),
          CONCAT((SELECT CONCAT(firstName, lastName) FROM Persons WHERE Persons.personID = NEW.personID), ' who teaches at your school has been infected with COVID-19 on ', CAST(NEW.dateOfInfection AS CHAR)),
          CURRENT_DATE()
        );
        INSERT INTO EmailLogs VALUES (
          (
            SELECT emailContentID 
              FROM EmailContent 
              WHERE emailSubject COLLATE utf8mb4_general_ci = CONCAT('Warning - COVID-19 Infection of ', NEW.personID, ' on ', CAST(CURRENT_DATE AS CHAR))
          ),
          (
            SELECT facilityID
              FROM EmployeeRegistrations AS er
              WHERE er.personID = NEW.personID
          ),
          (
            SELECT personID
              FROM EmployeeRegistrations AS er
              JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
              WHERE et.employeeType = 'Principal'
              AND er.facilityID = (
                SELECT facilityID
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
        WHERE StudentID = NEW.StudentID
        AND (
           (NEW.StartDate BETWEEN StartDate AND IFNULL(EndDate, NEW.StartDate))
           OR (NEW.EndDate IS NOT NULL AND NEW.EndDate BETWEEN StartDate AND IFNULL(EndDate, NEW.EndDate))
        )
     ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A student cannot be registered at more than one facility at the same time';
     END IF;
END;

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
      WHERE EmployeeID = NEW.EmployeeID
      AND (
         (NEW.StartDate BETWEEN StartDate AND IFNULL(EndDate, NEW.StartDate))
         OR (NEW.EndDate IS NOT NULL AND NEW.EndDate BETWEEN StartDate AND IFNULL(EndDate, NEW.EndDate))
      )
   ) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'An employee cannot be registered at more than one facility at the same time';
   END IF;
END;

DELIMITER ;

-- Infection Trigger
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
          'Warning - COVID-19 Infection of ' + NEW.personID + ' on ' + CURRENT_DATE,
          (SELECT CONCAT(firstName, lastName) FROM Persons WHERE Persons.personID = NEW.personID) + ' who teaches at your school has been infected with COVID-19 on ' + CONVERT(NEW.dateOfInfection, CHAR),
          CURRENT_DATE()
        );
        INSERT INTO EmailLogs VALUES (
          (
            SELECT emailContentID 
              FROM EmailContent 
              WHERE emailSubject = ('Warning - COVID-19 Infection of ' + NEW.personID + ' on ' + CURRENT_DATE)
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
              AND et.facilityID = (
                SELECT facilityID
                  FROM EmployeeRegistrations AS er
                  WHERE er.personID = NEW.personID
              )
          )
        );
        DELETE FROM Assignments AS a
          WHERE a.teacherID = NEW.personID
          AND dueDate <= DATE_ADD(CURRENT_DATE(), INTERVAL +14 DAY)
          AND dueDate >= CURRENT_DATE();
    END IF;
  END;

-- Trigger than checks if the person scheduled has been vaccinated in the past 6 months. Basically checks the number of vaccinations done in the past 6 months. If it returns 0, then an error is signaled. Otherwise the person is vaccinated in the past 6 months.
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

    

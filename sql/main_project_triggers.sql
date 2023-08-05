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
    

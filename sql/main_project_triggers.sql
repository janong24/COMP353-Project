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
        INSERT INTO Emails -- TODO;
        DELETE FROM Assignments AS a
          WHERE a.teacherID = NEW.personID
          AND dueDate <= DATE_ADD(CURRENT_DATE(), INTERVAL +14 DAY)
          AND dueDate >= CURRENT_DATE();
    END IF;
  END;
    

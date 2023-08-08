-- setting variables
SET @specificFacilityID := 1;
SET @specificEmployeeID := 1;
SET @specificPeriodStartTime := DATE('2012-01-01');
SET @specificPeriodEndTime := DATE('2024-01-01');

-- 8
SELECT f.name, f.address, f.city, f.province, f.postalCode, f.phoneNumber, f.webAddress, ft.typeName, r.totalEmployees, r2.principalFirstName, r2.principalLastName
  FROM Facilities AS f
  JOIN FacilityTypes AS ft ON f.facilityTypeID = ft.typeID
  JOIN (
    SELECT er.facilityID, COUNT(er.personID) AS 'totalEmployees'
      FROM EmployeeRegistrations AS er
      JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
      GROUP BY er.facilityID
  ) r ON f.facilityID = r.FacilityID
  JOIN (
    SELECT er.facilityID, et.employeeType, p.firstName AS 'principalFirstName', p.lastName AS 'principalLastName'
      FROM EmployeeRegistrations AS er
      JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
      JOIN Persons AS p ON er.personID = p.personID
      WHERE employeeType = 'Principal' OR employeeType = 'President'
  ) r2 ON f.facilityID = r2.facilityID
  ORDER BY f.province ASC, f.city ASC, ft.typeName ASC, r.totalEmployees ASC;

-- 9 
SELECT p.firstName, p.lastName, er.startDate, p.dateOfBirth, p.medicareNumber, p.telephoneNumber, p.address, p.city, p.province, p.postalCode, p.citizenship, p.email
  FROM Facilities AS f
  JOIN EmployeeRegistrations AS er ON f.facilityID = er.facilityID
  JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
  JOIN Persons AS p ON er.personID = p.personID
  WHERE f.facilityID = @specificFacilityID
  ORDER BY et.employeeType ASC, p.firstName ASC, p.lastName ASC;

-- 10
SELECT f.name, DATE(s.startTime) AS 'dayOfTheYear', s.startTime, s.endTime
  FROM Schedules AS s
  JOIN Facilities AS f ON s.facilityID = f.facilityID
  WHERE DATE(s.startTime) >= @specificPeriodStartTime
  AND DATE(s.endTime) <= @specificPeriodEndTime
  AND s.personID = @specificEmployeeID
  ORDER BY f.name, DATE(s.startTime), s.startTime;

-- 11
SELECT p.firstName, p.lastName, i.dateOfInfection, f.name
  FROM Persons AS p
  JOIN EmployeeRegistrations AS er ON p.personID = er.personID
  JOIN Facilities AS f ON er.facilityID = f.facilityID
  JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
  JOIN Infections AS i ON p.personID = i.personID
  WHERE et.employeeType = 'Teacher'
  ORDER BY f.name, p.firstName;

-- 12
SELECT *
  FROM EmailContent AS ec
  JOIN EmailLogs AS el ON ec.emailContentID = el.emailContentID
  WHERE el.facilityID = @specificFacilityID
  ORDER BY ec.emailDate;

-- 13
SELECT s.facilityID, p.firstName, p.lastName, ft.typeName AS 'role'
  FROM Schedules AS s
  JOIN Persons AS p ON s.personID = p.personID
  JOIN Facilities AS f ON s.facilityID = f.facilityID
  JOIN FacilityTypes AS ft ON f.facilityTypeID = ft.typeID
  JOIN EmployeeRegistrations AS er ON p.personID = er.personID
  JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
  WHERE et.employeeType = 'Teacher'
  AND DATE(s.startTime) >= DATE_ADD(CURRENT_DATE(), INTERVAL -14 DAY)
  AND DATE(s.endTime) <= CURRENT_DATE()
  AND s.facilityID = @specificFacilityID
  GROUP BY p.personID
  ORDER BY ft.typeName, p.firstName;

-- 14
SELECT s.facilityID, p.personID, SUM(TIMESTAMPDIFF(HOUR, s.startTime, s.endTime)) AS 'totalHours', s.startTime, s.endTime
  FROM Schedules AS s
  JOIN Persons AS p ON s.personID = p.personID
  JOIN EmployeeRegistrations AS er ON p.personID = er.personID
  JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
  WHERE et.employeeType = 'Teacher'
  AND DATE(s.startTime) >= @specificPeriodStartTime
  AND DATE(s.endTime) <= @specificPeriodEndTime
  AND s.facilityID = @specificFacilityID
  GROUP BY p.personID
  ORDER BY p.firstName, p.lastName;

-- 15
SELECT f.province, f.name, f.capacity, r.numberOfTeachersInfectedInPastTwoWeeks, r2.numberOfStudentsInfectedInPastTwoWeeks
  FROM Facilities AS f
  JOIN FacilityTypes AS ft ON f.facilityTypeID = ft.typeID
  JOIN (
    SELECT f.facilityID, COUNT(p.personID) AS 'numberOfTeachersInfectedInPastTwoWeeks'
      FROM Persons AS p
      JOIN EmployeeRegistrations AS er ON p.personID = er.personID
      JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
      JOIN Facilities AS f ON er.facilityID = f.facilityID
      JOIN Infections AS i ON p.personID = i.personID
      WHERE i.dateOfInfection >= DATE_ADD(CURRENT_DATE(), INTERVAL -14 DAY) AND CURRENT_DATE AND et.employeeType = 'Teacher'
      GROUP BY f.facilityID
  ) r ON f.facilityID = r.facilityID
  JOIN (
    SELECT f.facilityID, COUNT(p.personID) AS 'numberOfStudentsInfectedInPastTwoWeeks'
      FROM Persons AS p
      JOIN StudentRegistrations AS sr ON p.personID = sr.personID
      JOIN Facilities AS f ON sr.facilityID = f.facilityID
      JOIN Infections AS i ON p.personID = i.personID
      WHERE i.dateOfInfection >= DATE_ADD(CURRENT_DATE(), INTERVAL -14 DAY)
      GROUP BY f.facilityID
  ) r2 ON f.facilityID = r2.facilityID
  WHERE ft.subTypeName = 'High School'
  ORDER BY f.province, r.numberOfTeachersInfectedInPastTwoWeeks;

-- 16
SELECT p.firstName, p.lastName, p.city, r.numberOfManagementFacilities, r2.numberOfEducationalFacilities
  FROM Ministries AS m
  JOIN Persons AS p ON m.ministerOfEducationID = p.personID
  JOIN (
    SELECT f.ministryID, COUNT(f.facilityID) AS 'numberOfManagementFacilities'
      FROM Facilities AS f
      JOIN FacilityTypes AS ft ON f.facilityTypeID = ft.typeID
      WHERE ft.typeName = 'Management'
      GROUP BY f.ministryID
  ) r on m.MinistryID = r.ministryID
  JOIN (
    SELECT f.ministryID, COUNT(f.facilityID) AS 'numberOfEducationalFacilities'
      FROM Facilities AS f
      JOIN FacilityTypes AS ft ON f.facilityTypeID = ft.typeID
      WHERE ft.typeName = 'Education'
      GROUP BY f.ministryID
  ) r2 on m.MinistryID = r2.ministryID
  ORDER BY p.city ASC, r2.numberOfEducationalFacilities DESC;

-- 17 TODO TEST
SELECT p.firstName, p.lastName, r2.firstDayAsTeacher, ft.typeName, p.dateOfBirth, p.email, SUM(TIMESTAMPDIFF(HOUR, s.startTime, s.endTime)) AS 'totalHours'
  FROM EmployeeRegistrations AS er
  JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
  JOIN Persons AS p ON er.personID = p.personID
  JOIN Facilities AS f ON er.facilityID = f.facilityID
  JOIN FacilityTypes AS ft ON f.facilityTypeID = ft.typeID
  JOIN (
    SELECT i.personID, COUNT(i.infectionID)
      FROM Infections AS i
      GROUP BY i.personID
      HAVING COUNT(i.infectionID) >= 3
  ) r ON p.personID = r.personID
  JOIN (
    SELECT er.startDate AS 'firstDayAsTeacher', er.personID
      FROM EmployeeRegistrations AS er
      JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
      WHERE et.employeeType = 'Teacher'
  ) r2 ON p.personID = r2.personID
  WHERE et.employeeTypeID = 'Counselor' AND er.endDate IS NULL
  ORDER BY ft.role, p.firstName, p.lastName;
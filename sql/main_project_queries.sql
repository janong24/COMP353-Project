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
  LEFT JOIN (
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
  JOIN TypeOfInfections AS ti on i.TypeID = ti.TypeID
  WHERE et.employeeType = 'Teacher'
        AND ti.TypeName = 'COVID-19'
        AND i.dateOfInfection BETWEEN DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND CURDATE()
  ORDER BY f.name, p.firstName;

-- 12
SET @specificFacilityID := 7;

SELECT *
  FROM EmailContent AS ec
  JOIN EmailLogs AS el ON ec.emailContentID = el.emailContentID
  WHERE el.facilityID = @specificFacilityID
  ORDER BY ec.emailDate;

SET @specificFacilityID := 1;

-- 13
SELECT s.facilityID, p.firstName, p.lastName,
  CASE 
    WHEN ft.SubTypeName IN ('Primary School', 'Middle School') THEN 'elementary'
    ELSE 'secondary'
  END AS 'role'
FROM Schedules AS s
JOIN Persons AS p ON s.personID = p.personID
JOIN Facilities AS f ON s.facilityID = f.facilityID
JOIN FacilityTypes AS ft ON f.facilityTypeID = ft.typeID
JOIN EmployeeRegistrations AS er ON p.personID = er.personID
JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
WHERE et.employeeType = 'Teacher'
AND DATE(s.startTime) BETWEEN DATE_ADD(CURRENT_DATE(), INTERVAL -14 DAY) AND CURRENT_DATE()
AND s.facilityID = @specificFacilityID
GROUP BY p.personID
ORDER BY 
  CASE 
    WHEN ft.SubTypeName IN ('Primary School', 'Middle School') THEN 1
    ELSE 2
  END, p.firstName;


-- 14
SELECT p.personID, p.firstname, p.lastName, SUM(TIMESTAMPDIFF(HOUR, s.startTime, s.endTime)) AS 'totalHours'
  FROM Schedules AS s
  JOIN Persons AS p ON s.personID = p.personID
  JOIN EmployeeRegistrations AS er ON p.personID = er.personID
  JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
  WHERE et.employeeType = 'Teacher'
    AND DATE(s.startTime) >= @specificPeriodStartTime
    AND DATE(s.endTime) <= @specificPeriodEndTime
    AND s.facilityID = @specificFacilityID
  GROUP BY p.personID, p.firstName, p.lastName
  ORDER BY p.firstName, p.lastName;

-- 15
SELECT f.Province, f.Name AS SchoolName, f.Capacity, IFNULL(ti.TeacherCount, 0) AS TeachersInfectedCount, IFNULL(si.StudentCount, 0) AS StudentsInfectedCount
FROM Facilities f
LEFT JOIN (
  SELECT 
      f2.FacilityID, 
      COUNT(DISTINCT e.PersonID) AS TeacherCount
  FROM Facilities f2
  JOIN EmployeeRegistrations e ON f2.FacilityID = e.FacilityID
  JOIN Infections i ON e.PersonID = i.PersonID
  WHERE f2.FacilityTypeID = (SELECT TypeID FROM FacilityTypes WHERE SubTypeName = 'High School')
    AND i.DateOfInfection >= CURDATE() - INTERVAL 2 WEEK
    AND i.TypeID = (SELECT TypeID FROM TypeOfInfections WHERE TypeName = 'COVID-19')
    AND e.EmployeeTypeID = (SELECT EmployeeTypeID FROM EmployeeType WHERE EmployeeType = 'Teacher')
  GROUP BY f2.FacilityID
) AS ti ON f.FacilityID = ti.FacilityID
LEFT JOIN (
  SELECT 
      f3.FacilityID, 
      COUNT(DISTINCT s.PersonID) AS StudentCount
  FROM Facilities f3
  JOIN StudentRegistrations s ON f3.FacilityID = s.FacilityID
  JOIN Infections i ON s.PersonID = i.PersonID
  WHERE f3.FacilityTypeID = (SELECT TypeID FROM FacilityTypes WHERE SubTypeName = 'High School')
    AND i.DateOfInfection >= CURDATE() - INTERVAL 2 WEEK
    AND i.TypeID = (SELECT TypeID FROM TypeOfInfections WHERE TypeName = 'COVID-19')
    AND s.SchoolTypeID = (SELECT SchoolTypeID FROM SchoolType WHERE SchoolType = 'High School')
  GROUP BY f3.FacilityID
) AS si ON f.FacilityID = si.FacilityID
WHERE f.FacilityTypeID = (SELECT TypeID FROM FacilityTypes WHERE SubTypeName = 'High School')
ORDER BY f.Province ASC, IFNULL(ti.TeacherCount, 0) ASC;

-- 16
SELECT p.FirstName, p.LastName, p.City, IFNULL(r.numberOfManagementFacilities, 0) AS numberOfManagementFacilities, IFNULL(r2.numberOfEducationalFacilities, 0) AS numberOfEducationalFacilities
FROM Ministries AS m
JOIN Persons AS p ON m.MinisterOfEducationID = p.PersonID
LEFT JOIN (
  SELECT f.MinistryID, COUNT(f.FacilityID) AS numberOfManagementFacilities
  FROM Facilities AS f
  JOIN FacilityTypes AS ft ON f.FacilityTypeID = ft.TypeID
  WHERE ft.TypeName = 'Management'
  GROUP BY f.MinistryID
) r on m.MinistryID = r.MinistryID
LEFT JOIN (
  SELECT f.MinistryID, COUNT(f.FacilityID) AS numberOfEducationalFacilities
  FROM Facilities AS f
  JOIN FacilityTypes AS ft ON f.FacilityTypeID = ft.TypeID
  WHERE ft.TypeName = 'Education'
  GROUP BY f.MinistryID
) r2 on m.MinistryID = r2.MinistryID
ORDER BY p.City ASC, r2.numberOfEducationalFacilities DESC;

-- 17
SELECT p.PersonID, p.FirstName, p.LastName, MIN(er.StartDate) AS 'FirstDayAsTeacher', ft.TypeName AS 'Role', p.DateOfBirth, p.Email, SUM(TIMESTAMPDIFF(HOUR, s.startTime, s.endTime)) AS 'totalHours'
FROM Persons p
JOIN EmployeeRegistrations er ON p.PersonID = er.PersonID
JOIN EmployeeType et ON er.EmployeeTypeID = et.EmployeeTypeID
LEFT JOIN Specialization sp ON er.SpecializationID = sp.SpecializationID
LEFT JOIN Schedules s ON p.PersonID = s.personID
LEFT JOIN Facilities f ON er.FacilityID = f.FacilityID
LEFT JOIN FacilityTypes ft ON f.FacilityTypeID = ft.TypeID
WHERE 
  et.EmployeeType = 'Teacher' 
  AND sp.Specialization = 'School Counselor'
  AND er.EndDate IS NULL
  AND p.PersonID IN (
    SELECT i.PersonID 
    FROM Infections AS i
    JOIN TypeOfInfections toi ON i.TypeID = toi.TypeID
    WHERE toi.TypeName = 'COVID-19'
    GROUP BY i.PersonID
    HAVING COUNT(i.infectionID) >= 3
  )
GROUP BY p.PersonID, p.FirstName, p.LastName, ft.TypeName, p.DateOfBirth, p.Email
ORDER BY ft.TypeName ASC, p.FirstName ASC, p.LastName ASC;

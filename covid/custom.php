<?php require_once '../database.php';
require_once '../functions.php';

if(isset($_GET["query"]))  {
  $query = $_GET["query"];
} else {
  $query = "";
}

//variable initialization
$specificFacilityID = 1;
$specificEmployeeID = 1;
$specificPeriodStartTime = DATE('2012-01-01');
$specificPeriodEndTime = DATE('2022-01-01');

// SQL queries
switch ($query) {
  case "invalid":
    echo '<script>alert("Invalid choice.")</script>';
    $query = "";
    break;
  case "q8":
    $query = "
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
    ";
    break;
  case "q9":
    $query = "
    SELECT p.firstName, p.lastName, er.startDate, p.dateOfBirth, p.medicareNumber, p.telephoneNumber, p.address, p.city, p.province, p.postalCode, p.citizenship, p.email
    FROM Facilities AS f
    JOIN EmployeeRegistrations AS er ON f.facilityID = er.facilityID
    JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
    JOIN Persons AS p ON er.personID = p.personID
    WHERE f.facilityID = @specificFacilityID
    ORDER BY et.employeeType ASC, p.firstName ASC, p.lastName ASC;
    ";
    break;
  case "q10":
    $query = "
    SELECT f.name, DATE(s.startTime) AS 'dayOfTheYear', s.startTime, s.endTime
    FROM Schedules AS s
    JOIN Facilities AS f ON s.facilityID = f.facilityID
    WHERE DATE(s.startTime) >= specificPeriodStartTime
    AND DATE(s.endTime) <= specificPeriodEndTime
    ORDER BY f.name, DATE(s.startTime), s.startTime;
    ";
    break;
  case "q11":
    $query = "
    SELECT p.firstName, p.lastName, i.dateOfInfection, f.name
    FROM Persons AS p
    JOIN EmployeeRegistrations AS er ON p.personID = er.personID
    JOIN Facilities AS f ON er.facilityID = f.facilityID
    JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
    JOIN Infections AS i ON p.personID = i.personID
    WHERE et.employeeType = 'Teacher'
    ORDER BY f.name, p.firstName;
    ";
    break;
  case "q12":
    $query = "
    SELECT *
    FROM EmailContent AS ec
    JOIN EmailLogs AS el ON ec.emailContentID = el.emailContentID
    WHERE el.facilityID = specificFacilityID
    ORDER BY ec.emailDate;
    ";
    break;
  case "q13":
    $query = "
    SELECT p.firstName, p.lastName, ft.typeName AS 'role'
    FROM Schedules AS s
    JOIN Persons AS p ON s.personID = p.personID
    JOIN Facilities AS f ON s.facilityID = f.facilityID
    JOIN FacilityTypes AS ft ON f.facilityTypeID = ft.typeID
    JOIN EmployeeRegistrations AS er ON p.personID = er.personID
    JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
    WHERE et.employeeType = 'Teacher'
    AND DATE(s.startTime) >= DATE_ADD(CURRENT_DATE(), INTERVAL -14 DAY)
    AND DATE(s.endTime) <= CURRENT_DATE()
    ORDER BY ft.typeName, p.firstName;
    ";
    break;
  case "q14":
    $query = "
    SELECT s.facilityID, SUM(DATEDIFF(HOUR, s.endTime, s.startTime)) AS 'totalHours'
    FROM Schedules AS s
    JOIN Persons AS p ON s.personID = p.personID
    JOIN EmployeeRegistrations AS er ON p.personID = er.personID
    JOIN EmployeeType AS et ON er.employeeTypeID = et.employeeTypeID
    WHERE et.employeeType = 'Teacher'
    AND DATE(s.startTime) >= specificPeriodStartTime
    AND DATE(s.endTime) <= specificPeriodEndTime
    GROUP BY s.facilityID
    ORDER BY p.firstName, p.lastName;
    ";
    break;
  case "q15":
    $query = "
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
    ORDER BY f.province, r.teachersInfectedInPastTwoWeeks;
    ";
    break;
  case "q16":
    $query = "
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
    ";
    break;
  case "q17":
    $query = "
    SELECT p.firstName, p.lastName, r2.firstDayAsTeacher, ft.typeName, p.dateOfBirth, p.email
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
    ";
    break;
  case "q18":
    $query = "
    
    ";
}

// Execute query if not empty
if (!empty($query)) {
  $statement = $conn->prepare($query);
  $statement->execute();
  $data = $statement->fetchAll(PDO::FETCH_ASSOC);
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="../styles.css">
  <script src="https://kit.fontawesome.com/6ebd7b3ed7.js" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/gh/akjpro/form-anticlear/base.js"></script>
  <script>
    // Show/hide divs based on query selection
    function showDiv(select) {
      if (select.value == "q10") {
        document.getElementById('hidden_employees').style.display = "block";
        document.getElementById('hidden_facilities').style.display = "none";
      } 
      else if ((select.value == "q13") || (select.value =="q14")) {
        document.getElementById('hidden_employees').style.display = "none";
        document.getElementById('hidden_facilities').style.display = "block";
      } 
      else {
        document.getElementById('hidden_employees').style.display = "none";
        document.getElementById('hidden_facilities').style.display = "none";
      }
    }
  </script>
  <title>Custom Queries</title>
</head>
<body>
  <?php include_once ('../navbar.php'); ?>
  <div class="containerLeftMargin">
    <h2>Choose a custom query to execute from the dropdown below.</h2>

    <!-- Dynamic form showing list of queries and needed parameters as necessary. -->
    <form class="form-anticlear" action="../covid/custom.php" method="get">
      <select name="query" id="query" onchange="showDiv(this);">
        <option value="invalid" default>Choose One</option>
        <option value="q8">Q8. Get details of all facilities in the system.</option>
        <option value="q9">Q9. Get details of all the employees currently working in a specific facility.</option>
        <option value="q10">Q10. For a given employee, get the details of all the schedules she/he has been scheduled during a specific period of time.</option>
        <option value="q11">Q11. Get details of all the teachers who have been infected by COVID-19 in the past two weeks.</option>
        <option value="q12">Q12. List the emails generated by a given facility.</option>
        <option value="q13">Q13. For a given facility, generate a list of all the teachers who have been on schedule to work in the last two weeks.</option>
        <option value="q14">Q14. For a given facility, give the total hours scheduled for every teacher during a specific period.</option>
        <option value="q15">Q15. For every high school, provide data on COVID-19 infections.</option>
        <option value="q16">Q16. For every ministry in the system, provide its details.</option>
        <option value="q17">Q17. For every ministry in the system, provide its minister's details.</option>
        <option value="q18">Q18. Get details of the counselor(s) who are currently working and has been infected by COVID-19 at least three times.</option>
      </select>
      <select id="hidden_employees" name="employee">
        <p>Choose an employee:</p>
        <option value="">An employee</option>
      </select>
      <select id="hidden_facilities" name="facility">
        <p>Choose a facility:</p>
        <option value="">A facility</option>
      </select>
      <input type="submit" value="Submit">
    </form>

    <!-- Displays data from the selected custom query -->
    <?php if (!empty($data)) { ?>
    <table class="styled-table">
    <thead>
      <tr>
        <?php foreach ($data[0] as $key => $value) { ?>
          <td><?= $key?></td>
        <?php } ?>
        <?php unset($key); ?>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($data as $row) { ?>
        <tr>
          <?php foreach ($row as $key => $value) { ?>
            <td><?= $value; ?></td>
          <?php } ?>
        </tr>
      <?php } ?>
    </tbody>
    </table>
    <?php } ?>

    <button class="smallBtn" onclick="history.back()">Return to Previous Page</button>
  </div>
</body>
</html>
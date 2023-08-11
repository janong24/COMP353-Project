<?php

$employees = "SELECT DISTINCT Persons.* FROM EmployeeRegistrations JOIN Persons ON EmployeeRegistrations.PersonID = Persons.PersonID ORDER BY Persons.PersonID ASC;";
$students = "SELECT DISTINCT Persons.* FROM StudentRegistrations JOIN Persons ON StudentRegistrations.PersonID = Persons.PersonID ORDER BY Persons.PersonID ASC;";

?>
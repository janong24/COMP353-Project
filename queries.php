<?php

$employees = "SELECT DISTINCT p.* FROM EmployeeRegistrations er JOIN Persons p ON er.PersonID = p.PersonID ORDER BY p.PersonID ASC;";
$students = "SELECT DISTINCT p.* FROM StudentRegistrations sr JOIN Persons p ON sr.PersonID = p.PersonID ORDER BY p.PersonID ASC;";

?>
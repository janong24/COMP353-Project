<?php require_once 'database.php';

//retrieve all columns from a table
function getColumnNames ($table) {
  $sql = "SHOW COLUMNS FROM ".$table."";
  global $conn;
  try {
    $statement = $conn->prepare($sql);
    $statement->execute();
    $output = $statement->fetchAll(PDO::FETCH_COLUMN);
    return $output;
  } catch (PDOException $e) {
    trigger_error("Error: Failed to get column names from $table");
  }
}

//retrieve all names of facilities
function getFacilities () {
  $sql = "SELECT FacilityID, Name FROM facilities";
  global $conn;
  try {
    $statement = $conn->prepare($sql);
    $statement->execute();
    $data = $statement->fetchAll(PDO::FETCH_ASSOC);
    return $data;
  } catch (PDOException $e) {
    trigger_error("Error: Failed to get Facilities.");
  }
}

//retrieve all employees
function getEmployees () {
  $sql = "SELECT DISTINCT p.PersonID, p.FirstName, p.LastName FROM EmployeeRegistrations er JOIN Persons p ON er.PersonID = p.PersonID ORDER BY p.PersonID ASC;";
  global $conn;
  try {
    $statement = $conn->prepare($sql);
    $statement->execute();
    $data = $statement->fetchAll(PDO::FETCH_ASSOC);
    return $data;
  } catch (PDOException $e) {
    trigger_error("Error: Failed to get Employees.");
  }
}


//retrieve all columns from a table with their corresponding data type
function getColumnTypes ($table) {
  $sql = "DESCRIBE ".$table."";
  global $conn;
  try {
    $statement = $conn->prepare($sql);
    $statement->execute();
    $columns = $statement->fetchAll(PDO::FETCH_COLUMN);
    $output = array();
    foreach ($columns as $column) {
      $query = "DESCRIBE ".$table." ".$column."";
      $statement = $conn->prepare($query);
      $statement->execute();
      $data = $statement->fetch(PDO::FETCH_ASSOC);
      array_push($output, $data);
    }
    return $output;
  } catch (PDOException $e) {
    trigger_error("Error: Failed to get column names from $table");
  }
}

//retrieve all tables
function getTables () {
  $sql = "SHOW TABLES";
  global $conn;
  try {
    $statement = $conn->prepare($sql);
    $statement->execute();
    return $statement;
  } catch (PDOException $e) {
    trigger_error("Error: Failed to get tables from database");
  }
}


?>
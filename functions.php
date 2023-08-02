<?php require_once 'database.php';

//retrieve all records from a table
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

//sends emails to recipient
function sendMail($recipient) {

}

?>
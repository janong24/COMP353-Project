<?php require_once 'database.php';

function getColumnNames ($table) {
  $sql = "SHOW COLUMNS FROM $table";
  global $conn;
  try {
    $statement = $conn->prepare($sql);
    $statement->bindValue(':table', $table, PDO::PARAM_STR);
    $statement->execute();
    $output = array();
    while ($row = $statement->fetch(PDO::FETCH_ASSOC)) {
      $output[] = $row['COLUMN_NAME'];
    }
    return $output;
  } catch (PDOException $e) {
    trigger_error("Error: Failed to get column names from $table");
  }
}

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
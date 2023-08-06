<?php require_once '../database.php';
require_once '../functions.php';

  //grab the table name from the get action and remove it from the get array
  if(isset($_GET["table"]))  {
    $tableName = $_GET["table"];
    unset($_GET["table"]);
  } else {
    $tableName = "";
  }

  //grab the primary key from the get action and remove it from the get array
  if(isset($_GET["ID"]))  {
    $primaryKey = $_GET["ID"];
    unset($_GET["ID"]);
  } else {
    $primaryKey = "";
  }

  $columnNames = getColumnNames($tableName);

  //create the DDL statement
  $dml = "DELETE FROM " . $tableName . " WHERE " . $columnNames[0] . " = " . $primaryKey . ";";
  $query = $conn->prepare($dml);

    //execute the query
  if($query->execute()) {
    header("Location: ./success.php?table=" . $tableName . "");
  } else {
    header("Location: ./failure.php?table=" . $tableName . "");
  }
?>
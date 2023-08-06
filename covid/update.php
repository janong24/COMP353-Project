<?php include_once ('../database.php');
require_once '../functions.php';
//insertion code
//no longer requires validation because of the required attribute in the form

    //grab the table name from the get action and remove it from the get array
  if(isset($_POST["table"]))  {
    $tableName = $_POST["table"];
    unset($_POST["table"]);
  } else {
    $tableName = "";
  }

    //grab the primary key from the get action and remove it from the get array
  if(isset($_POST["ID"]))  {
    $primaryKey = $_POST["ID"];
    unset($_POST["ID"]);
  } else {
    $primaryKey = "";
  }

  //initialize variables
  global $conn;
  $colVals = array();
  $temp = "";
  $columnNames = getColumnNames($tableName);

  //loop through all the POST data and push them into the arrays
  foreach ($_POST as $key => $value) {
    if(is_numeric($value)) {
      $temp = $key . "=" . $value;
    }
    else {
      $temp = $key . "='" . $value . "'";
    }
    
    array_push($colVals, $temp);
  }

  //convert the arrays into strings
  $colValsWithCommas = implode(", ", $colVals);

  //create the DDL statement
  $ddl = "UPDATE " . $tableName . " SET " . $colValsWithCommas . " WHERE " . $columnNames[0] . " = " . $primaryKey . ";";
  print_r($ddl);
  $query = $conn->prepare($ddl);

  //execute the query
  if($query->execute()) {
    header("Location: ./success.php?table=" . $tableName . "");
  } else {
    header("Location: ./failure.php?table=" . $tableName . "");
  }
?>
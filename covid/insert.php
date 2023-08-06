<?php include_once ('../database.php');
//insertion code
//no longer requires validation because of the required attribute in the form

  //grab the table name from the get action and remove it from the get array
  if(isset($_POST["table"]))  {
    $tableName = $_POST["table"];
    unset($_POST["table"]);
  } else {
    $tableName = "";
  }

  //initialize variables
  global $conn;
  $keys = array();
  $values = array();

  //loop through all the POST data and push them into the arrays
  foreach ($_POST as $key => $value) {
    array_push($keys, $key);
    if(!is_numeric($value)) {
      $value = "'" . $value . "'";
    }
    array_push($values, $value);
  }

  //convert the arrays into strings
  $keysWithCommas = implode(", ", $keys);
  $valuesWithCommas = implode(", ", $values);

  //create the DDL statement
  $ddl = "INSERT INTO " . $tableName . " (" . $keysWithCommas . ") VALUES (" . $valuesWithCommas . ");";
  $query = $conn->prepare($ddl);

  //execute the query
  if($query->execute()) {
    header("Location: ./success.php?table=" . $tableName . "");
  } else {
    header("Location: ./failure.php?table=" . $tableName . "");
  }
?>
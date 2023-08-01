<?php require_once '../database.php';
require_once '../functions.php';

if(isset($_GET["ID"]) && isset($_GET["table"]))  {
  $tableName = $_GET["table"];
  $recordID = $_GET["ID"];
} else {
  $tableName = "";
  $recordID = "";
}

$columnNames = getColumnNames($tableName);

$query = "SELECT * FROM ".$tableName." WHERE ".$columnNames[0]." = ".$recordID."";
$statement = $conn->prepare($query);
$statement->execute();
$data = $statement->fetch(PDO::FETCH_ASSOC);

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="../styles.css">
  <script src="https://kit.fontawesome.com/6ebd7b3ed7.js" crossorigin="anonymous"></script>
  <title>Show Record</title>
</head>
<body>
  <?php include_once ('../navbar.php'); ?>
  <div class="containerLeftMargin">
      <p><b>Table:</b> <?= $tableName ?></p>
      <?php foreach ($data as $key => $value) { ?>
        <p><b><?php print_r($key); ?>:</b> <?php print_r($value); ?></p>
      <?php } ?>
    <button class="smallBtn" onclick="history.back()">Return to Previous Page</button>
  </div>
</body>
</html>

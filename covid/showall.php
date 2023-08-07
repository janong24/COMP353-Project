<?php require_once '../database.php';
require_once '../functions.php';

if(isset($_GET["table"]))  {
  $tableName = $_GET["table"];
} else {
  $tableName = "";
}

$columnNames = getColumnNames($tableName);

$query = "SELECT * FROM ".$tableName."";
$statement = $conn->prepare($query);
$statement->execute();

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="../styles.css">
  <script src="https://kit.fontawesome.com/6ebd7b3ed7.js" crossorigin="anonymous"></script>
  <title>EPSTS - Table <?= $tableName ?></title>
</head>
<body>
  <?php include_once ('../navbar.php'); ?>
  <br/><br/>
    <a class="topBtn" href="./create.php?table=<?=$tableName?>">Add a new entry</a>
  <table class="styled-table">
    <caption><h1>Table: <?= $tableName ?></h1></caption>
    <thead>
      <tr>
        <?php foreach ($columnNames as $row) { ?>
          <td><?= $row?></td>
        <?php } ?>
          <td>Actions</td>
      </tr>
    </thead>
    <tbody>
    <?php while ($row = $statement->fetch(PDO::FETCH_ASSOC, PDO::FETCH_ORI_NEXT)) { ?>

      <tr>
        <?php foreach ($row as $data) { ?>
          <td><?= $data; ?></td>
        <?php } ?>
        <td>
          <a href="./show.php?ID=<?=reset($row)?>&table=<?=$tableName?>">Show</a>
          <a href="./edit.php?ID=<?=reset($row)?>&table=<?=$tableName?>">Edit</a>
          <a href="./delete.php?ID=<?=reset($row)?>&table=<?=$tableName?>">Delete</a>  
        </td>
      </tr>
      <?php } ?>
    </tbody>
  </table>

  <button class="smallBtn" onclick="history.back()">Return to Previous Page</button>
</body>
</html>
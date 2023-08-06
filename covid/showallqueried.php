<?php require_once '../database.php';
require_once '../functions.php';
require_once '../queries.php';

if(isset($_GET["query"]))  {
  switch ($_GET["query"]) {
    case "Students":
      $dml = $students;
      $tableName = "Persons";
      break;
    case "Employees":
      $dml = $employees;
      $tableName = "Persons";
      break;
    case "":
      $dml = "";
      $tableName = "";
      break;
  }
}

$columnNames = getColumnNames($tableName);

$statement = $conn->prepare($dml);
$statement->execute();

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="../styles.css">
  <script src="https://kit.fontawesome.com/6ebd7b3ed7.js" crossorigin="anonymous"></script>
  <title>EPSTS - Table of <?= $_GET["query"] ?></title>
</head>
<body>
  <?php include_once ('../navbar.php'); ?>
  <br/><br/>
    <a class="topBtn" href="./create.php?table=<?=$tableName?>">Add a new entry.</a>
  <table class="styled-table">
    <caption><h1>Table of <?= $_GET["query"] ?></h1></caption>
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
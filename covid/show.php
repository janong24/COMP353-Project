<?php require_once '../database.php';

$persons = $conn->prepare("SELECT * FROM comp353.Persons WHERE PersonID = :PersonID");
$persons->bindParam(':PersonID', $_GET['PersonID']);
$tableName = $_GET['table'];
$persons->execute();

$person = $persons->fetch(PDO::FETCH_ASSOC);

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><?= $person["FirstName"] ?><?= $person["LastName"] ?></title>
</head>
<body>
  <h1>Table: <?= $tableName ?></h1>
  <h1><?= $person["FirstName"] ?><?= $person["LastName"] ?></h1>
  <h3>Person ID: <?= $person["PersonID"] ?></h3>
  <h3>First Name: <?= $person["FirstName"] ?></h3>
  <h3>Last Name: <?= $person["LastName"] ?></h3>
  <h3>DateOfBirth: <?= $person["DateOfBirth"] ?></h3>
</body>
</html>

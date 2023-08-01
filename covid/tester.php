<?php require_once '../database.php';
require_once '../functions.php';

$tableGET = $_GET["table"];

$query = "SELECT * FROM ".$tableGET."";
$columnList = $conn->prepare($query);
$columnList->execute();
$columnLists = $columnList->fetch(PDO::FETCH_ASSOC);


$output = getColumnNames($tableGET);

print_r($output);

// $persons = $conn->prepare("SHOW COLUMNS FROM persons;");
// $persons->execute();
// $person = $persons->fetch(PDO::FETCH_ASSOC);

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>
<body>
<?php foreach ($output as $row) { ?>
  <?= $row?>
<?php } ?>
</body>
</html>
<!-- Dynamic Row Fetching
<?php require_once '../database.php';

$persons = $conn->prepare("SHOW COLUMNS FROM persons;");
$persons->execute();

$person = $persons->fetch(PDO::FETCH_ASSOC);

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>
<body>
<?php while ($row = $persons->fetch(PDO::FETCH_ASSOC, PDO::FETCH_ORI_NEXT)) { ?>
  <?= $row["Field"] ?>
<?php } ?>
</body>
</html> -->
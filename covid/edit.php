<?php require_once '../database.php';
require_once '../functions.php';

  if(isset($_GET["table"]) && isset($_GET["ID"]))  {
    $tableName = $_GET["table"];
    $recordID = $_GET["ID"];
  } else {
    $tableName = "";
    $recordID = "";
  }

    //population code
    $columnList = getColumnTypes($tableName);
    $columnNames = getColumnNames($tableName);

    $query = "SELECT * FROM ".$tableName." WHERE ".$columnNames[0]." = ".$recordID."";
    $statement = $conn->prepare($query);
    $statement->execute();
    $data = $statement->fetch(PDO::FETCH_ASSOC);

    $iterator1 = new ArrayIterator($columnList);
    $iterator2 = new ArrayIterator($data);

    $multipleIterator = new MultipleIterator(MultipleIterator::MIT_NEED_ALL|MultipleIterator::MIT_KEYS_ASSOC);

    $multipleIterator->attachIterator($iterator1, 'column');
    $multipleIterator->attachIterator($iterator2, 'data');

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit an Entry</title>
  <link rel="stylesheet" href="../styles.css">
  <script src="https://kit.fontawesome.com/6ebd7b3ed7.js" crossorigin="anonymous"></script>
</head>
<body>
  <?php include_once ('../navbar.php'); ?>
  <div class="containerLeftMargin">
    <h1>Edit an Entry</h1>
    <form action="./update.php" method="post">
      <input type="hidden" name="table" value="<?= $tableName ?>">
      <input type="hidden" name="ID" value="<?= $recordID ?>">
      <?php foreach ($multipleIterator as $key => $value) { ?>
        <label for="<?= $key['data'] ?>"><b><?= $key['data'] ?></b> <?= $value['column']['Type'] ?></label><br/>
        <?php if($value['column']['Type'] == "date") { ?>
          <input type="date" name="<?= $key['data'] ?>" id="<?= $key['data'] ?>" value="<?= $value['data'] ?>" required><br/>
        <?php } else if(str_contains($value['column']['Type'], "int")) { ?>
          <input type="number" name="<?= $key['data'] ?>" id="<?= $key['data'] ?>" value="<?= $value['data'] ?>" required><br/>
        <?php } else if(str_contains($value['column']['Type'], "varchar")) { ?>
          <input type="text" name="<?= $key['data'] ?>" id="<?= $key['data'] ?>" value="<?= $value['data'] ?>" required><br/>
        <?php } ?>
      <?php } ?>
      <button class="submitBtn" type="submit">Edit</button>
    </form>

    <button class="smallBtn" onclick="history.back()">Return to Previous Page</button>
  </div>
</body>
</html>
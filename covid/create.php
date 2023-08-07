<?php require_once '../database.php';
require_once '../functions.php';

  if(isset($_GET["table"]))  {
    $tableName = $_GET["table"];
  } else {
    $tableName = "";
  }

    $columnList = getColumnTypes($tableName);
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add a New Entry</title>
  <link rel="stylesheet" href="../styles.css">
  <script src="https://kit.fontawesome.com/6ebd7b3ed7.js" crossorigin="anonymous"></script>
</head>
<body>
  <?php include_once ('../navbar.php'); ?>
  <div class="containerLeftMargin">
    <h1>Add a New Entry</h1>
    <form action="./insert.php" method="post">
      <input type="hidden" name="table" value="<?= $tableName ?>">
      <?php foreach ($columnList as $column) { ?>
        <label for="<?= $column['Field'] ?>"><b><?= $column['Field'] ?></b> <?= $column['Type'] ?></label><br/>
        <?php if($column['Type'] == "date") { ?>
          <input type="date" name="<?= $column['Field'] ?>" id="<?= $column['Field'] ?>" required><br/>
        <?php } else if(str_contains($column['Type'], "int")) { ?>
          <?php if(str_contains($column['Field'], "ID")) { ?>
            <label for="<?= $column['Field'] ?>">(Auto-generated)</label><br/>
          <?php } else {?>
            <input type="number" name="<?= $column['Field'] ?>" id="<?= $column['Field'] ?>" required><br/>
          <?php } ?>
        <?php } else if(str_contains($column['Type'], "varchar")) { ?>
          <input type="text" name="<?= $column['Field'] ?>" id="<?= $column['Field'] ?>" required><br/>
        <?php } ?>
      <?php } ?>
      <button class="submitBtn" type="submit">Add</button>
    </form>

    <button class="smallBtn" onclick="history.back()">Return to Previous Page</button>
  </div>
</body>
</html>
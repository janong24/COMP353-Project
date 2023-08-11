<?php require_once '../database.php';
require_once '../functions.php';

  if(isset($_GET["table"]))  {
    $tableName = $_GET["table"];
  } else {
    $tableName = "";
  }

    $facilities = getFacilities();
    $persons = getPersons();
    $employees = getEmployees();
    $ministries = getMinistries();
    $facilityTypes = getFacilityTypes();
    $vaccines = getVaccines();
    $schoolTypes = getSchoolTypes();
    
    $columnList = getColumnTypes($tableName);
    $primKey = FALSE;
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
        <?php if($column['Type'] == "datetime") { ?>
          <input type="datetime-local" name="<?= $column['Field'] ?>" id="<?= $column['Field'] ?>" required><br/>
        <?php } else if(strpos($column['Type'], "int") !== FALSE) { ?>
          <?php if(strpos($column['Field'], "ID") !== FALSE) { ?>
            <?php if ($primKey != TRUE) { ?>
              <label for="<?= $column['Field'] ?>">(Auto-generated)</label><br/>
              <?php $primKey = TRUE; ?>
            <?php } else {?>
              <!-- <select id="hidden_employees" name="employee" default="" required>
                  <?php foreach ($employees as $employee) { ?>
                  <?php $record = $employee['PersonID'] . ' - ' . $employee['FirstName'] . ' ' . $employee['LastName']?>
                  <option value="<?= $employee['PersonID'] ?>"><?= $record ?></option>
                <?php } ?>
              </select> -->
              <input type="number" name="<?= $column['Field'] ?>" id="<?= $column['Field'] ?>" required><br/>
            <?php } ?>
          <?php } else {?>
            <input type="number" name="<?= $column['Field'] ?>" id="<?= $column['Field'] ?>" required><br/>
          <?php } ?>
        <?php } else if(strpos($column['Type'], "varchar") !== FALSE) { ?>
          <input type="text" name="<?= $column['Field'] ?>" id="<?= $column['Field'] ?>" required><br/>
        <?php } ?>
      <?php } ?>
      <button class="submitBtn" type="submit">Add</button>
    </form>

    <button class="smallBtn" onclick="history.back()">Return to Previous Page</button>
  </div>
</body>
</html>
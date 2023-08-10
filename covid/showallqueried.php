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
  <script>
    //gathers the data from the table to be exported
    function exportTableToCSV(filename) {
                var csv = [];
                var rows = document.querySelectorAll("table tr");
                
                for (var i = 0; i < rows.length; i++) {
                    var row = [], cols = rows[i].querySelectorAll("td, th");
                for (var j = 0; j < cols.length - 1; j++) 
                    row.push('"' + cols[j].innerText + '"');
                csv.push(row.join(","));        
                }
                downloadCSV(csv.join("\n"), filename);
            }
            
    //downloads the data as a csv file
    function downloadCSV(csv, filename) {
        var csvFile;
        var downloadLink;
        csvFile = new Blob([csv], {type: "text/csv"});
        downloadLink = document.createElement("a");
        downloadLink.download = filename;
        downloadLink.href = window.URL.createObjectURL(csvFile);
        downloadLink.style.display = "none";
        document.body.appendChild(downloadLink);
        downloadLink.click();
    }
  </script>
  <title>EPSTS - Table of <?= $_GET["query"] ?></title>
</head>
<body>
  <?php include_once ('../navbar.php'); ?>
  <br/><br/>
    <a class="topBtn" href="./create.php?table=<?=$tableName?>">Add a new entry</a>
    <a class="topBtn" onclick="exportTableToCSV('Results.csv')">Export to CSV</a>
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
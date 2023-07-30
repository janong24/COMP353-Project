<?php require_once '../database.php';

$statement = $conn->prepare('SELECT * FROM comp353.Persons AS Persons');
$statement->execute();
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="../styles.css">
  <script src="https://kit.fontawesome.com/6ebd7b3ed7.js" crossorigin="anonymous"></script>
  <title>EPSTS - Table</title>
</head>
<body>
  <?php include_once ('../navbar.php'); ?>
  <button class="topBtn" href="./create.php">Add a new entry.</button>
  <table class="styled-table">
    <caption><h1>Table: Persons</h1></caption>
    <thead>
      <tr>
        <td>PersonID</td>
        <td>FirstName</td>
        <td>LastName</td>
        <td>DateOfBirth</td>
        <td>MedicareNumber</td>
        <td>MedicareExpiry</td>
        <td>TelephoneNumber</td>
        <td>Address</td>
        <td>City</td>
        <td>Province</td>
        <td>PostalCode</td>
        <td>Citizenship</td>
        <td>Email</td>
        <td>Actions</td>
      </tr>
    </thead>
    <tbody>
    <?php while ($row = $statement->fetch(PDO::FETCH_ASSOC, PDO::FETCH_ORI_NEXT)) { ?>
      <tr>
        <td><?= $row["PersonID"] ?></td>
        <td><?= $row["FirstName"] ?></td>
        <td><?= $row["LastName"] ?></td>
        <td><?= $row["DateOfBirth"] ?></td>
        <td><?= $row["MedicareNumber"] ?></td>
        <td><?= $row["TelephoneNumber"] ?></td>
        <td><?= $row["Address"] ?></td>
        <td><?= $row["City"] ?></td>
        <td><?= $row["Province"] ?></td>
        <td><?= $row["PostalCode"] ?></td>
        <td><?= $row["Citizenship"] ?></td>
        <td><?= $row["Email"] ?></td>
        <td>
          <a href="./show.php?PersonID=<?=$row["PersonID"]?>">Show</a>
          <a href="./edit.php?PersonID=<?=$row["PersonID"]?>">Edit</a>
          <a href="./delete.php?PersonID=<?=$row["PersonID"]?>">Delete</a>  
        </td>
      </tr>
      <?php } ?>
    </tbody>
  </table>

  <button class="smallBtn" onclick="history.back()">Return to Previous Page</button>
</body>
</html>
<?php require_once '../database.php';

if(isset($_POST["FirstName"]) 
    && isset($_POST["LastName"]) 
    && isset($_POST["DateOfBirth"])) {
      $persons = $conn->prepare("INSERT INTO COMP353.Persons (FirstName, LastName, DateOfBirth) 
                                    VALUES (:FirstName, :LastName, :DateOfBirth);");
      $persons->bindParam(':FirstName', $_POST['FirstName']);
      $persons->bindParam(':LastName', $_POST['LastName']);
      $persons->bindParam(':DateOfBirth', $_POST['DateOfBirth']);
  
  if($persons->execute()) header("Location: .");

  
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add a New Entry</title>
</head>
<body>
  <h1>Add a New Entry</h1>
  <form action="./create.php" method="post">
    <label for="FirstName">First Name</label><br/>
    <input type="text" name="FirstName" id="FirstName"><br/>
    <label for="LastName">Last Name</label><br/>
    <input type="text" name="LastName" id="LastName"><br/>
    <label for="DateOfBirth">Date of Birth</label><br/>
    <input type="date" name="DateOfBirth" id="DateOfBirth"><br/>
    <br/>
    <button type="submit">Add</button>
  </form>

  <button onclick="history.back()">Return to Previous Page</button>
</body>
</html>
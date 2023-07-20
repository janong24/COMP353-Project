<?php require_once '../database.php';

$persons = $conn->prepare("SELECT * FROM comp353.Persons as Persons WHERE Person.PersonID = :PersonID");
$persons->bindParam(':PersonID', $_GET['PersonID']);
$persons->execute();

$person = $persons->fetch(PDO::FETCH_ASSOC);

if(isset($_POST["FirstName"]) 
  && isset($_POST["LastName"]) 
  && isset($_POST["DateOfBirth"]) 
  && isset($_POST["PersonID"])) {
    $statement = $conn->prepare("UPDATE comp353.Persons SET 
                                FirstName = :FirstName, 
                                LastName = :LastName,
                                DateOfBirth = :DateOfBirth
                                WHERE PersonID = :PersonID;");
    $statement->bindParam(':FirstName', $_POST['FirstName']);
    $statement->bindParam(':LastName', $_POST['LastName']);
    $statement->bindParam(':DateOfBirth', $_POST['DateOfBirth']);
    $statement->bindParam(':PersonID', $_POST['PersonID']);
    
    if($statement->execute()) {
      header("Location: .");
    } else {
      header("Location: ./edit.php?PersonID=".$_POST["PersonID"]);
    }

}

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit an Entry</title>
</head>
<body>
  <h1>Edit an Entry</h1>
  <form action="./edit.php" method="post">
    <label for="FirstName">First Name</label><br/>
    <input type="text" name="FirstName" id="FirstName" value="<?= $person["FirstName"] ?>"><br/>
    <label for="LastName">Last Name</label><br/>
    <input type="text" name="LastName" id="LastName" value="<?= $person["LastName"] ?>"><br/>
    <label for="DateOfBirth">Date of Birth</label><br/>
    <input type="date" name="DateOfBirth" id="DateOfBirth" value="<?= $person["DateOfBirth"] ?>"><br/>
    <input type="hidden" name="PersonID" id="PersonID" value="<?= $person["PersonID"] ?>">
    <br/>
    <button type="submit">Update</button>
  </form>

  <button onclick="history.back()">Return to Previous Page</button>
</body>
</html>
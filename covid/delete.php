<?php require_once '../database.php';

$statement = $conn->prepare('DELETE FROM comp353.Persons WHERE Persons.PersonID = :PersonID;');
$statement->bindParam(':PersonID', $_GET['PersonID']);
$statement->execute();
header("Location: .");

?>
<?php 
  if(isset($_GET["table"]))  {
    $tableName = $_GET["table"];
    $url = "./showall.php?table=" . $tableName . "";
  } else {
    $tableName = "";
    $url = "./index.php";
  }

?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv='refresh' content='3; URL=<?=$url?>'>
  <link rel="stylesheet" href="../styles.css">
  <script src="https://kit.fontawesome.com/6ebd7b3ed7.js" crossorigin="anonymous"></script>
  <title>Failure</title>
</head>
<body>
  <div class="absCenter">
    <i class="fa fa-fw fa-10x fa-bounce fa-circle-xmark" style="color: green;"></i>
    <h1>The operation was a failure.</h1>
    <br/><br/>
    <p>Redirecting you back to where you came from...</p>
  </div>
</body>
</html>
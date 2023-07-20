<?php
//change when uploaded to concordia server
$server = 'localhost:3306'; 
$username = 'root';
$password = '';
$database = 'comp353';

try {
  $conn = new PDO("mysql:host=$server; dbname=$database;", $username, $password);
} catch (PDOException $e) {
  die('Connection Failed: ' . $e->getMessage());
}

?>
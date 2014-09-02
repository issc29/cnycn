<?php
$dsn = 'mysql:dbname=boroughs;host=127.0.0.1';
$user = 'root';
$password = 'ffgdb2014!';
try
{
    $dbh = new PDO($dsn, $user, $password);
    $input_street = $_GET['street_names'];
    $qry = $dbh->prepare('SELECT year_built from manhattan where street_names like ?');
     $qry->execute(array($input_street));
    $result = $qry->fetchColumn();
    echo $result; 
   
    header('HTTP/1.1 201 Created', true, 201);
}
catch(PDOException $e)
{
    header('HTTP/1.1 500 Internal Server Error');
}
?>
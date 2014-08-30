<?php
$dsn = 'mysql:dbname=stat_tracking;host=127.0.0.1';
$user = 'root';
$password = 'ffgdb2014!';
try
{
      $dbh = new PDO($dsn, $user, $password);
    $qry = $dbh->prepare('select latitude, longitude from search_log');
    $qry->execute();
    $result = $qry->fetchAll(PDO::FETCH_ASSOC);
      
    echo json_encode($result);

    header('Content-type: application/json');

    //header('HTTP/1.1 201 Created', true, 201);
}
catch(PDOException $e)
{
    header('HTTP/1.1 500 Internal Server Error');
}
?>

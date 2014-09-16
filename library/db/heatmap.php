<?php
$dbConn = parse_ini_file("dbprops.ini");
$dsn = $dbConn['url'];
$user = $dbConn['user'];
$password = $dbConn['password'];
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

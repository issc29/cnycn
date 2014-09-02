<?php
$dsn = 'mysql:dbname=stat_tracking;host=127.0.0.1';
$user = 'root';
$password = 'ffgdb2014!';
$ipaddress = '';

function get_client_ip() {
    $ipaddress = '';
    if ($_SERVER['HTTP_CLIENT_IP'])
        $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
    else if($_SERVER['HTTP_X_FORWARDED_FOR'])
        $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
    else if($_SERVER['HTTP_X_FORWARDED'])
        $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
    else if($_SERVER['HTTP_FORWARDED_FOR'])
        $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
    else if($_SERVER['HTTP_FORWARDED'])
        $ipaddress = $_SERVER['HTTP_FORWARDED'];
    else if($_SERVER['REMOTE_ADDR'])
        $ipaddress = $_SERVER['REMOTE_ADDR'];
    else
        $ipaddress = 'UNKNOWN';
    return $ipaddress;
}

try
{
    $dbh = new PDO($dsn, $user, $password);
    $ip_address = get_client_ip();
    $street_number = $_POST['street_number'];
    $street_name = $_POST['street_name'];
    $city = $_POST['city'];
    $state = $_POST['state'];
    $zipcode = $_POST['zipcode'];
    $longitude = $_POST['longitude'];
    $latitude = $_POST['latitude'];
    $qry = $dbh->prepare('INSERT INTO search_log (ip_address, street_number, street_name, city, state, zipcode, longitude, latitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
    $qry->execute(array($ip_address, $street_number, $street_name, $city, $state, $zipcode, $longitude, $latitude));
    header('HTTP/1.1 201 Created', true, 201);
}
catch(PDOException $e)
{
    header('HTTP/1.1 500 Internal Server Error');
}
?>

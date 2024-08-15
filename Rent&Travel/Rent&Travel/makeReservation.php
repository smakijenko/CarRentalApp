<?php
$servername = "";
$username = "";
$password = "";
$dbname = "";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$name = $conn->real_escape_string($_POST['name']);
$surname = $conn->real_escape_string($_POST['surname']);
$email = $conn->real_escape_string($_POST['email']);
$phoneNumber = $_POST['phoneNumber'];
$country = $conn->real_escape_string($_POST['country']);
$homeAddress = $conn->real_escape_string($_POST['homeAddress']);
$idCar = $_POST['idCar'];
$pickUpDate = $_POST['pickUpDate'];
$returnDate = $_POST['returnDate'];
$isInsurance = $_POST['isInsurance'];
$price = $_POST['price'];

$conn->begin_transaction();


$sqlClients = "INSERT INTO `clients` (`id`, `name`, `surname`, `email`, `phoneNumber`, `country`, `homeAddress`) VALUES (NULL, '$name', '$surname', '$email', '$phoneNumber', '$country', '$homeAddress');";

if ($conn->query($sqlClients)) {
    $clientId = $conn->insert_id;
    $sqlReservation = "INSERT INTO `reservations` (`idreservation`, `idclient`, `idcar`, `pickUpDate`, `returnDate`, `isInsurance`, `price`) VALUES (NULL, '$clientId', '$idCar', '$pickUpDate', '$returnDate', '$isInsurance', '$price');";
    if ($conn->query($sqlReservation)) {
        $conn->commit();
        echo "Reservation inserted successfully";
        }
    else {
        $conn->rollback();
        echo "Error inserting reservation: " . $conn->error;
    }
} 
else {
    $conn->rollback();
    echo "Error inserting client: " . $conn->error;
}
$conn->close();
?>

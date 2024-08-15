<?php
$servername = "";
$username = "";
$password = "";
$dbname = "";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$pickUpDate = $_POST['pickUpDate'];
$returnDate = $_POST['returnDate'];

$sql = "
SELECT c.*
FROM cars AS c
WHERE c.id NOT IN 
(
    SELECT r.idcar
    FROM reservations AS r
    WHERE '$pickUpDate' < r.returnDate
    AND '$returnDate' > r.pickUpDate
)
ORDER BY c.pricePerDay ASC
";

$result = $conn->query($sql);

$cars = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $row['id'] = (int)$row['id'];
        $row['fuelCons'] = (double)$row['fuelCons'];
        $row['maxPeople'] = (int)$row['maxPeople'];
        $row['pricePerDay'] = (int)$row['pricePerDay'];
        $cars[] = $row;        
    }
} else {
    echo "0 results";
}

$conn->close();

header('Content-Type: application/json');
echo json_encode($cars);
?>
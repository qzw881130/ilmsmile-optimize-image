<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;


//    [formID] => 232554068008454
//    [q9_fullName] => Array
//    (
            //    [first] => 钱
            //    [last] => 志伟
//    )
//    [q3_email] => qianzhiwei5921@gmail.com
//    [q4_message] => hi, 我想问一些事。


require_once '../../define.php';

$mail = new PHPMailer(true);

$toEmail = $_POST['q3_email'] ?? '';
$name = ($_POST['q9_fullName']['first'] ?? $_POST['q9_fullName']['first']) . ' ' . ($_POST['q9_fullName']['last'] ?? $_POST['q9_fullName']['last']);
$message = $_POST['q4_message'] ?? '';

$message = "<b>Test Message</b>";

$body = <<<EOF
    Hi,
    Guest Email: $toEmail
    Name: $name
    Message: $message
EOF;

/*https://github.com/PHPMailer/PHPMailer*/
try {
    //Server settings
    $mail->SMTPDebug = SMTP::DEBUG_SERVER;                      //Enable verbose debug output
    $mail->isSMTP();                                            //Send using SMTP
    $mail->Host       = $_SERVER['MAIL_HOST'];                     //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = $_SERVER['MAIL_USERNAME'];                     //SMTP username
    $mail->Password   = $_SERVER['MAIL_PASSWORD'];                               //SMTP password
    $mail->SMTPSecure = $_SERVER['MAIL_ENCRYPTION'] ?? 'ssl';            //Enable implicit TLS encryption
    $mail->Port       = $_SERVER['MAIL_PORT'] ?? PHPMailer::ENCRYPTION_SMTPS; //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`

    $mail->setFrom($_SERVER['MAIL_FROM_ADDRESS'], $_SERVER['MAIL_FROM_NAME']);
    $mail->addAddress($_SERVER['CONTACT_US_MAIL']);     //Add a recipient
    $mail->isHTML(true);                                  //Set email format to HTML
    $mail->Subject = 'Contant Us';
    $mail->Body    = $body;
    $mail->AltBody = '';

    $mail->send();
    echo 'Message has been sent';
    header('Location: finish.php');
} catch (Exception $e) {
    die("Message could not be sent. Mailer Error: {$mail->ErrorInfo}");
}
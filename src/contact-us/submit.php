<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require_once '../../define.php';

$mail = new PHPMailer(true);

$toEmail = $_POST['q3_email'] ?? '';
$name = ($_POST['q9_fullName']['first'] ?? $_POST['q9_fullName']['first']) . ' ' . ($_POST['q9_fullName']['last'] ?? $_POST['q9_fullName']['last']);
$message = $_POST['q4_message'] ?? '';

$loader = new \Twig\Loader\FilesystemLoader(SRC_ROOT . '/contact-us');
$twig = new \Twig\Environment($loader, []);

$baseUrl = sprintf('%s://%s', $_SERVER['REQUEST_SCHEME'] ,  $_SERVER['HTTP_HOST']);

$body = $twig->render('mail-template.html.twig', [
    'baseUrl' => $baseUrl,
    'styles' => file_get_contents(SRC_ROOT . '/contact-us/styles.css'),
    'toemail' => $toEmail,
    'name' => $name,
    'message' => str_replace("\n", "<br/>", $message),
    'date' => date('Y-m-d H:i:s')
]);

/*https://github.com/PHPMailer/PHPMailer*/
try {
    $mail->SMTPDebug = $_SERVER['IS_DEBUG_MAIL'] ?? 0;                      //Enable verbose debug output
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
    header('Location: /contact-us/finish.php');
} catch (Exception $e) {
    die("Message could not be sent. Mailer Error: {$mail->ErrorInfo}");
}
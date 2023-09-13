<?php
use Symfony\Component\Dotenv\Dotenv;

!defined('ROOT') && define('ROOT', dirname(__FILE__));
!defined('SRC_ROOT') && define('SRC_ROOT', ROOT . '/src');

require ROOT . '/vendor/autoload.php';

if(file_exists(ROOT . '/.env')){
    (new Dotenv())->load(ROOT.'/.env');
}


<?php
use Symfony\Component\Dotenv\Dotenv;

!defined('ROOT') && define('ROOT', dirname(__FILE__));

require ROOT . '/vendor/autoload.php';

if(file_exists(ROOT . '/.env')){
    (new Dotenv())->load(ROOT.'/.env');
}


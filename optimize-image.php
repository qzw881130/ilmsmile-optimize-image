<?php
#/static/images/focus01_img.jpg
#https://www.ilmsmile.com/static/images/focus01_img.jpg
//http://localhost:8008/static/images/focus01_img.jpg.webp
$wgetBin = '/usr/local/bin/wget';
$convertBin = '/usr/local/bin/convert';
if(!file_exists($wgetBin)) die('wget no exists!');
$localImageRoot = dirname(__FILE__) ;

$dstBaseUrl = 'https://www.ilmsmile.com';
$uri = isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : '';
$uri = preg_replace('/(\.webp)$/', '', $uri);
$ext = pathinfo($uri, PATHINFO_EXTENSION);
//$newFile = md5($realUri) . '.' . $ext;
$newFile = pathinfo($uri, PATHINFO_FILENAME);

$subPath = preg_replace('/(\/[\w_]+\.\w+)$/', '', $uri);

$newPath = $localImageRoot . $subPath;
if(!file_exists($newPath)) mkdir($newPath, 0755, true);

$newFilePath = $newPath . '/' . $newFile . '.' . $ext . '.webp';
$dstfileUrl = $dstBaseUrl . $uri;

if(!file_exists($newFilePath)){
    $cmd = sprintf('%s -q "%s" -O %s', $wgetBin, $dstfileUrl, $newFilePath);
    system($cmd);
    $oCmd = sprintf('%s -strip +profile "*"  -quality 65 %s %s', $convertBin, $newFilePath, $newFilePath);
    system($oCmd);
}
header('content-type:image/'.$ext);
$content = file_get_contents($newFilePath);
die($content);









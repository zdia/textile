<?php

require_once('classTextile.php');

$textile = new Textile;

// Version for getting input from commandline:
// 
// echo $textile->TextileThis($argv[1]);

// Version for getting the content in a file
// Output is sent to textile.html:

$file_parts = pathinfo($argv[1]);
$wiki = file_get_contents($file_parts['basename']);
$html = $textile->TextileThis($wiki);
// file_put_contents($file_parts['filename'].".html", $html);
file_put_contents("textile.html", $html);

// For untrusted user input, use TextileRestricted instead:
// echo $textile->TextileRestricted($in);

?>

<?php

// takes the content of the text widget and echoes it to the Textile parser

require_once('classTextile.php');

$textile = new Textile;

echo $textile->TextileThis($argv[1]);

// Version for passing the content in a file:
// 
// $file_parts = pathinfo($argv[1]);
// $wiki = file_get_contents($file_parts['basename']);
// $html = $textile->TextileThis($wiki);
// file_put_contents($file_parts['filename'].".html", $html);

// For untrusted user input, use TextileRestricted instead:
// echo $textile->TextileRestricted($in);

?>

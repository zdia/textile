<?php

// takes a filename from the commandline and converts its contents
// to a html format

require_once('classTextile.php');

$textile = new Textile;

// $file_parts = pathinfo($argv[1]);
// $wiki = file_get_contents($file_parts['basename']);
// $html = $textile->TextileThis($wiki);
echo $textile->TextileThis($argv[1]);

// file_put_contents($file_parts['filename'].".html", $html);

// For untrusted user input, use TextileRestricted instead:
// echo $textile->TextileRestricted($in);

?>

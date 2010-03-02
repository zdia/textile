<?php

//take the string from argv and convert it to html

require_once('classTextile.php');

$textile = new Textile;
echo $textile->TextileThis($argv[1]);

// For untrusted user input, use TextileRestricted instead:
// echo $textile->TextileRestricted($in);

?>

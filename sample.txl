This project intends to use Tcl/Tk to glue the Textile markup language (v2.0.0) with an Tk text widget (Tk 8.5). A menu will allow to send output to a browser (tested with Firefox 3.5.2).
Textile is a wiki markup language *implemented* in Textpattern and it is very convenient in use. Just for personal documentation purposes it is not necessary to use a whole CMS. 

So we take an simple text editor and enable it to produce Html Code. A browser will present immediately the web page. Tcl will glue all the well tested parts together.

Sample formattings taken from "http://www.textism.com/tools/textile/index.php":http://www.textism.com/tools/textile/index.php:

This is *bold* and _italic_ text

h2. H2 header

h3. H3 header

h4. H4 header

bq. This is a blockquoted paragraph

bq=. This is centered blockquoted text

bq>. This is left aligned blockquoted text

p{color:red}. It is easy in Textile to add colors.

Simple list colored:

#{color:blue} one
# two
# three

Well, that went well. How about we insert an <a href="/" title="watch out">old-fashioned hypertext link</a>? Will the quote marks in the tags get messed up? No!

"This is a link (optional title)":http://www.textism.com

table{border:1px solid black}.
|_. this|_. is|_. a|_. header|
<{background:gray}. |\2. this is|{background:red;width:200px}. a|^<>{height:200px}. row|
|this|<>{padding:10px}. is|^. another|(bob#bob). row|

An image:

!/common/textist.gif(optional alt text)!

h3. Coding

This <code>is some code, "isn't it"</code>. Watch those quote marks! Now for some preformatted text:

<pre>
<code>
$text = str_replace("<p>%::%</p>","",$text);
$text = str_replace("%::%</p>","",$text);
$text = str_replace("%::%","",$text);
</code>
</pre>

This isn't code.


So you see, my friends:

* The time is now
* The time is not later
* The time is not yesterday
* We must act




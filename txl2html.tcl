#!/bin/sh
# the next line restarts using wish \
exec tclsh8.5 "$0" ${1+"$@"}

# commandline tool to create Html code from Textile wiki formatted text
# 
# txl2html.tcl ?-option value? filename
# -o 	output name

# TODO:
# Check existence of php
# Define browser?
# Default directory
# config wie css-Pfad in txl2html.cfg speichern
#

# Im Arbeitsverzeichnis git/textile/homepage liegen die .txl Dateien \
für die Homepage, die erzeugten Html-Formate liegen in git/homepage

# Syntax Highlighting will be done in line-word-order at startup time and
# when refreshing is desired

package require Tcl 8.5

namespace eval textile {}

proc ::textile::Init {} {
	# init default values
	set ::textile::Destination ""
	set ::textile::css ""
	
	set ::textile::header \
{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<HEAD>
		<TITLE>zdia.homelinux.org</TITLE>
		<META http-equiv="content-type" content="text/html; charset=utf-8">
		<LINK REL="stylesheet" TYPE="text/css" title="Liste" HREF=}
		
	append textile::header $::textile::css
	append textile::header {>
	</HEAD>
	<body>
	}
	
	set ::textile::tail \
	{</body>
</html>
	}

}

proc textile::Usage {} {
	puts "Usage: txl2html.tcl ?-option value? filename
Options:
 -o, --output\tname of output-file
 --css\t\tname of CSS-file
 "
}

proc textile::ParseCommandline {} {
	#
	# parses options and name of Textile file in argv
	#
	# returns name of Textile file
	
	if { [ expr {$::argc % 2} ] == 0 } {
		puts "Wrong number of arguments\n"
		textile::Usage
		exit
	}
	
	# check filename
	set file [lindex $::argv end]
	if { ![ file exists $file ] } {
		puts "Error: File $file not found"
		exit
	} else {
		set optionList [lrange $::argv 0 end-1]
	}

	# parse options
	foreach {option value} $optionList {
		switch -glob -- $option {
			--output 	-
			-o				{ set ::textile::Destination $value	}
			
			--css			{	set ::textile::css $value }
			
			default	{
				puts "Error: Unknown option $option!"
				textile::Usage
				exit
			}
			
		} ;# end switch
	} ;# end foreach	
	
	return $file
}

proc ::textile::AddFrame { htmlFile } {
	# adds Html header and tail to Textile Html data
	
	set fh [open $htmlFile r]
	set body [read $fh]
	close $fh
	
	return "$::textile::header$body$::textile::tail"
}

proc textile::Convert { file } {
	# <html> etc wird von exec als File-Umleitung interpretiert
	# textile.php muss daher aus Datei ::textile::filename einlesen
	#
	# textile.php speichert output im aktuellen Ordner als temporäre Datei textile.html
	
	exec php textile.php $file

	if { $::textile::Destination ne "" } {
		set destination $::textile::Destination
	} else {
		set destination "[file rootname $file].html"
	}

	set page [textile::AddFrame textile.html]
	set fh [open $destination w+]
	puts $fh $page
	close $fh

	exec firefox $destination

}

# --------------------------------------------
# Main
# --------------------------------------------

textile::Init
textile::Convert [textile::ParseCommandline]

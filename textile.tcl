#!/bin/sh
# the next line restarts using wish \
exec tclsh8.5 "$0" ${1+"$@"}


# man kann Text eingeben und als html-Code ausgeben
# fertige html Seite einlesen (open) )und bearbeiten?
# mit Header abspeichern?

# Vermischung html und textile tut nicht gut
# also entweder komplette Seite als textile speichern
# und als textile bearbeiten
# oder explizit als html exportieren mit Option "Webseite"

# TODO:
# Check existence of php
# Define browser?
# Remember last files
# Default directory
# Write Tcl Textile textile::Parser?
# Add myPattern

# Im Arbeitsverzeichnis git/textile/homepage liegen die .txl Dateien \
für die Homepage, die erzeugten Html-Formate liegen in git/homepage

# Syntax Highlighting will be done in line-word-order at startup time and
# when refreshing is desired

package require Tk 8.5

namespace eval textile {}
namespace import ::msgcat::*

proc say_hello {	} {
	puts hello
}

proc textile::Init {	} {

	set ::textile::filename [lindex $::argv 0]
	set ::textile::DestinationDir /home/dia/Projekte/git/homepage/Kultur
	set ::textile::workingDir /home/dia/Projekte/git/textile/
	set ::textile::Preferences(Skeleton) 0
	set ::textile::css "../meer.css"
	
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
  set ::spaceOld "1.0"
  set ::markupList [dict create h3. blue]
}

proc textile::AddSkeleton { htmlFile } {
	
	set fh [open $htmlFile r]
	set body [read $fh]
	close $fh
	
	return "$::textile::header$body$::textile::tail"
}

proc textile::OpenFile { } {
	if { $::textile::filename eq "" } { set ::textile::filename [tk_getOpenFile] }
	
	wm title . $::textile::filename
	
	set fh [open $::textile::filename "r"]
	.wiki insert 1.0 [read $fh]
	close $fh
	
}

# zur Verfügung stehen page.html und textile.html *.txl
proc textile::Save {} {
	set fh [ open $::textile::filename "w" ]
	puts $fh [.wiki get 1.0 "end - 1 char"]
	close $fh
}

# saving a txl-file
proc textile::SaveAs {	} {
	set ::textile::filename [tk_getSaveFile]
	if { $::textile::filename == "" } {
		return
	}
	textile::Save
}

proc textile::CreateHtmlPage {	} {

# Option beim Speichern: mit html skeleton with header?
	
	set wiki [.wiki get 1.0 "end - 1 char"]
	
	# <html> etc wird von exec als File-Umleitung interpretiert
	# textile.php muss daher aus Datei ::textile::filename einlesen
	# textile.php speichert output als textile.html
	exec php textile.php $::textile::filename

	set htmlPage [AddSkeleton textile.html]
	# puts $htmlPage
	set filename [ file join $::textile::DestinationDir "[file rootname $textile::filename].html" ]
	set fh [open $filename w+]
	puts $fh $htmlPage
	close $fh

	puts "HTML: $filename\nCSS : $::textile::css"	
	exec firefox $filename
	
	# textile::Saveas
	
}

proc textile::Preferences {	} {
	font configure TkFixedFont -size 18
}

proc textile::Exit {	} {
	exit
}

proc textile::Help {	} {
	
}

proc textile::License {	} {
	
}

proc textile::About	{	} {
	
}

proc textile::Page {	} {
	set textile::Preferences(skeleton) 1
	textile::CreateHtmlPage
}

proc textile::IsMarkup { word } {
	puts [dict get $::markupList]
	if { [catch {set tag [dict get $::markupList $word] } oops] } {
		puts $oops
		return ""
	}
	# search the dict
	return $tag
}
  
proc textile::Parse { key } {
    # space = 65
    if { $key == 65 } {
      set spaceNew [.wiki index insert]
			set word [string trim [.wiki get $::spaceOld $spaceNew]]

      set tag [textile::IsMarkup $word]
      if { $tag ne "" } {
				# highlight
        .wiki tag add $tag $::spaceOld $spaceNew
        # create html output ... ?
      }
      set ::spaceOld $spaceNew
    }
}

proc textile::InitGUI { {filename ""} } {
# menu: 
# file: open, save, save as, export html; quit	
# display: show
# tools: ls

	# set file "test.txt"
	# set file tk_getOpendialog
	
	
	option add *Menu.tearOff 0
	menu .mbar
	. configure -menu .mbar
	
	# Struktur im menu_desc(ription):
	# label	widgetname {item tag command shortcut}

	set meta Control
	set menu_meta Ctrl
	
	if {[tk windowingsystem] == "aqua"}	{
		set meta Command
		set menu_meta Cmd
	}

	set ::textile::menu_desc {
		File	file	{"New ..." {} textile::say_hello "" ""
								"Open ..." {} textile::OpenFile $menu_meta O
								Save save textile::Save $menu_meta S
								"Save As ..." open textile::SaveAs "" ""
								separator "" "" "" ""
								"Create Html ..." open textile::CreateHtmlPage $menu_meta "E"
								"Create Html" "" textile::Page $menu_meta "H"
								separator "" "" "" ""
								"Preferences ..." {} textile::Preferences "" ""
								separator "" "" "" ""
								Exit {} textile::Exit $menu_meta X
								}	
		Edit	edit	{Header "" textile::Header $menu_meta H
								}
		Help	help	{ "Help ..." "" textile::Help "" ""
								"License ..." "" textile::License "" ""
								separator "" "" "" ""
								"About ..." "" textile::About "" ""
								}
	}	

	foreach {menu_name menu_widget menu_itemlist} $::textile::menu_desc {
		
		.mbar add cascade -label [mc $menu_name] -menu .mbar.$menu_widget
		menu .mbar.$menu_widget
		
		set taglist ""
		
		foreach {menu_item menu_tag menu_command meta_key shortcut} $menu_itemlist {
	
			# erstelle für jedes widget eine Tag-Liste
			lappend taglist $menu_tag
	
			if {$menu_item eq "separator"} {
				.mbar.$menu_widget add separator
			} else {
				eval set meta_key $meta_key
				set shortcut [join "$meta_key $shortcut" +]
				.mbar.$menu_widget add command -label [mc $menu_item] \
					-command $menu_command -accelerator $shortcut
			} 	
			set ::textile::tag_list($menu_widget) $taglist
		} 
	}
	wm protocol . WM_DELETE_WINDOW textile::Exit
	wm title . "Textile Wiki-Markup"
	
	set text [text .wiki -relief sunken -width 80 \
			-yscrollcommand ".vsb set" \
			-width 160 \
			-height 60 \
      -wrap word]
      
	.wiki tag configure blue -foreground blue -font {TkFixedFont 10 bold}
	
  # bind . <KeyPress> { textile::Parse %k }
  bind .wiki <Control-H> textile::CreateHtmlPage
  
	if {[tk windowingsystem] ne "aqua"} {
		ttk::scrollbar .vsb -orient vertical -command ".wiki yview"
	} else {
		scrollbar .vsb -orient vertical -command ".wiki yview"
	}

	pack .wiki -side left -fill both -expand 1
	pack .vsb -side right -fill y
	
	textile::OpenFile
	
	focus .wiki
}

# --------------------------------------------
# Main
# --------------------------------------------

textile::Init
textile::InitGUI 



# <LINK REL="alternate stylesheet" TYPE="text/css" title="Sonne" HREF="sonne.css">
# <LINK REL="alternate stylesheet" TYPE="text/css" title="baum" HREF="baum.css">

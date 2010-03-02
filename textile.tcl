# man kann Text eingeben und als html-Code ausgeben
# fertige html Seite einlesen (open) )und bearbeiten?
# mit Header abspeichern?

# Vermischung html und textile tut nicht gut
# also entweder komplette Seite als textile speichern
# und als textile bearbeiten
# oder explizit als html exportieren mit Option "Webseite"

package require Tk 8.5

namespace eval textile {}
namespace import ::msgcat::*

proc say_hello {  } {
	puts hello
}

proc textile::AddSkeleton {} {
	# set head Datei um ihn anpassen zu können, speichern unter einem Namen? projekt.header

	set tail "
	</BODY>
</HTML>"

	set header {
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<HTML>
  <HEAD>

    <TITLE>zdia.homelinux.org</TITLE>

    <META NAME="Generator" CONTENT="Tcl/Tk 8.5; http://www.tcl.tk/)">
    <META NAME="Author" CONTENT="Zbigniew Diaczyszyn">
    <META NAME="Copyright" CONTENT="Copyright (C) Feb 07, 2010 ">
    <META http-equiv="content-type" content="text/html; charset=utf-8">


    <LINK REV="made" HREF="mailto:">
    <LINK REL="stylesheet" TYPE="text/css" title="Meer" HREF="my.css">
  </HEAD>

	<BODY>
	}
	
	# .wiki auslesen, header einsetzen, anfügen .wiki, anfügen tail
	.wiki insert 1.0 $header
}

proc textile::open {  } {
	set ::textile::filename [tk_getOpenFile]
	set fh [open $::textile::filename "r"]
	.wiki insert 1.0 [read $fh]
	close $fh
}

proc textile::Save {} {
	set fh [ open $::textile::filename "w" ]
	puts $fh [.wiki get 1.0 "end - 1 char"]
	close $fh
}

proc textile::SaveAs {  } {
	set ::textile::filename [tk_getSaveFile]
	textile::Save
}

proc textile::Export {  } {
# Pfade überprüfen

# Option beim Speichern: mit html skeleton with header?
	
	# Das erste Zeichen darf kein "<" wie etwa in "<strong>" sein,
	# sonst will exec es als Umleitung interpretieren
	# "\n" verhindert das und textile ignoriert den Zeilenvorschub
	
	set wiki "\n[.wiki get 1.0 "end - 1 char"]"
	
# unter welchem Namen speichern?

	exec php textile.php $wiki > textile.html
	exec iceweasel "[pwd]/textile.html"
	
	# if {Preferences(Skeleton) == 1}
	if {$AddSkeleton} {
		textile::AddSkeleton
	}
	
	# textile::Saveas
	
}

proc textile::Preferences {  } {
	
}

proc textile::Exit {  } {
	exit
}

proc textile::Help {  } {
	
}

proc textile::License {  } {
	
}

proc textile::About  {  } {
	
}

proc textile::Init {  } {
	set ::textile::filename ""
	set textile::Preferences(Skeleton) 0
}

proc textile::InitGUI {} {
# menu: file: open, save, save as, export html; quit	display: show

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
								"Open ..." {} textile::open $menu_meta O
								Save save textile::Save $menu_meta S
								"Save As ..." open textile::SaveAs "" ""
								separator "" "" "" ""
								"Export ..." open textile::Export $menu_meta "E"
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
	
	text .wiki
	pack .wiki -fill both -expand 1
	focus .wiki
}

# --------------------------------------------
# Main
# --------------------------------------------

textile::Init
textile::InitGUI



#bindings etc



    # <LINK REL="alternate stylesheet" TYPE="text/css" title="Sonne" HREF="sonne.css">
    # <LINK REL="alternate stylesheet" TYPE="text/css" title="baum" HREF="baum.css">

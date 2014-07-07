#!/usr/local/bin/perl

#-------------------------------
# Beginner's text adventure.
# Program: "Pears Before Swine"
# Author: Irene P. Smith
# Date Created: June 26, 2014
#-------------------------------

$user_quit = "";	# Set to "true" when the user enters the command "quit"
$current_loc = 1;	# This is the location where you start.
$moves = 0;			# Incremented after every command
$score = 0;			# The score doesn't get incremented yet.
@locations = ();	# The array of location names and exits.
@things = ();		# The array of things (id #, name, initial location.)
#------------------------------------------------------------
# Set up the game by describing the situation.
#------------------------------------------------------------
show_welcome_msg();
init_locations();
init_things();

#------------------------------------------------------------
# This is the main loop. It will repeat until the user enters
# the command "quit"
#------------------------------------------------------------
do {
	# start by giving a description of the current location
	do_look();
	$new_command = get_command();
	do_command();
} until ($user_quit eq "true");

print "user_quit = $user_quit\nThanks for playing!\n\n";

#------------------------------------------------------------
# The rest of this file contains the definitions for the
# subroutines that do the work of getting and parsing the
# user's commands and executing the commands.
#------------------------------------------------------------

#------------------------------------------------------------
# This routine reads the file named "welcome.txt" and prints
# it to the screen.
#------------------------------------------------------------
sub show_welcome_msg {
	system("cls");
	open (welcome, "welcome.txt");
	while (<welcome>) {
		$chomp;
		print "$_";
	}
	close(welcome);
	return;
}

#------------------------------------------------------------
# Prints the prompt and then gets the user's command string,
# which it then returns to the calling program.
#------------------------------------------------------------
sub get_command {
	print "What do you want to do? ";
	$command = <STDIN>;
	chomp $command;
	return $command;
}

#------------------------------------------------------------
# This routine will get more complex as the game is
# developed. This routine will look for a valid verb and, if
# it finds it, it will look for an object to which the verb
# applies.
#------------------------------------------------------------
sub do_command {
	# First, see if the user wants to quit.
	if ($new_command =~ /quit/gi) {
		$user_quit = "true";
		return;
	}
	if ($new_command =~ /go/gi) {
		# look for a valid direction.
		if ($new_command =~ /north/gi) {
			do_move(1);
			return;
		}
		elsif ($new_command =~ /south/gi) {
			do_move(2);
			return;
		}
		elsif($new_command =~ /east/gi) {
			do_move(3);
			return;
		}
		elsif($new_command =~ /west/gi) {
			do_move(4);
			return;
		}
		elsif($new_command =~ /up/gi) {
			do_move(5);
			return;
		}
		elsif($new_command =~ /down/gi) {
			do_move(6);
			return;
		}
	}
	if($new_command =~ /look/gi) {
		do_look();
	}
}

#------------------------------------------------------------
# This routine will take care of the look command. It will be
# called at the beginning of each time through the loop in
# version 1, but in future versions, will only be called when
# "verbose" is set to true, or when the user actually enters
# the "look" command.
#------------------------------------------------------------
sub do_look {
	@dir_names = ("", "North", "South", "East", "West", "Up", "Down");
	
	# Print the location description.

	print "\n----------------------------------------------------------------------\n";
	print "Moves: $moves Score: $score\n";
	print "Location: $locations[$current_loc][0]";
	
	# List the exits.
	print " You can go: ";
	for($i = 1; $i <= 6; $i++) {
		if ($locations[$current_loc][$i] > 0) {
			print "$dir_names[$i] ";
		}
	}
	print "\n----------------------------------------------------------------------\n";
	print "\n";
	return;
}

#------------------------------------------------------------
# Moves to the location number at the appropriate array
# position in the array for the current location. If that
# array position holds a 0, it prints, "You can't go that
# way." and then returns. If there is a number other than 0,
# it sets current_loc to 0 and returns.
#------------------------------------------------------------
sub do_move {
	if ($locations[$current_loc][$_[0]] > 0) {
		$current_loc = $locations[$current_loc][$_[0]];
	} else {
		print "I'm sorry, but you can't go that way.\n";
	}
}

#------------------------------------------------------------
# This routine loads the information
# for room descriptions and exits
# from the text files.
#
# The format for the file in v1.0 is:
#   n, "Location Name", N, S, E, W, U, D
#
# Where n is the number of the location and N, S, E, W, U, D
# represent the locations numbers that will be the location
# numbers for the various exits.
#
# Future versions will add a verbose description for each of
# the locations in the games.
#------------------------------------------------------------
sub init_locations {
	# Open the locations file.
	open (locFile, 'locations.txt');
	while(<locFile>) {
		chomp;
		($locID, $locName,
			$exitN, $exitS,
			$exitE, $exitW,
			$exitU, $exitD) = split(", ");
		
		$locations[$locID][0] = $locName;
		$locations[$locID][1] = $exitN;
		$locations[$locID][2] = $exitS;
		$locations[$locID][3] = $exitE;
		$locations[$locID][4] = $exitW;
		$locations[$locID][5] = $exitU;
		$locations[$locID][6] = $exitD;
	}
}

#------------------------------------------------------------
# This routine loads the information for item descriptions
# and their initial locations.
#------------------------------------------------------------
sub init_things {
	# Open the things file.
	open (thingFile, 'things.txt');
	while (<thingFile>) {
		chomp;
		($thingID, $thingName, $thingLoc) = split(", ");
		
		$things[$thinkID][0] = $thingName;
		$things[$thinkID][1] = $thingLoc;
	}
		
}


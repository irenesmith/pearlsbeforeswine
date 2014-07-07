#!/usr/local/bin/perl
use v5.14;

#-------------------------------
# Beginner's text adventure.
# Program: "Pears Before Swine"
# Author: Irene P. Smith
# Date Created: June 26, 2014
#-------------------------------
use Readonly;
use XML::Simple;
use Data::Dumper;

<<<<<<< HEAD
$user_quit = "";	# Set to "true" when the user enters the command "quit"
$current_loc = 1;	# This is the location where you start.
$moves = 0;			# Incremented after every command
$score = 0;			# The score doesn't get incremented yet.
@locations = ();	# The array of location names and exits.
@things = ();		# The array of things (id #, name, initial location.)
=======
our $user_quit = "";	# Set to "true" when the user enters the command "quit"
our $current_loc = "1";	# This is the location where you start.
our $moves = 0;			# Incremented after every command
our $score = 0;			# The score doesn't get incremented yet.

#------------------------------------------------------------
# The following values are "constants" for the directions.
#------------------------------------------------------------
Readonly our $NORTH => 1;
Readonly our $SOUTH => 2;
Readonly our $EAST => 3;
Readonly our $WEST => 4;
Readonly our $UP => 5;
Readonly our $DOWN => 6;

>>>>>>> origin/master
#------------------------------------------------------------
# Set up the game by describing the situation.
#------------------------------------------------------------
show_welcome_msg();
<<<<<<< HEAD
init_locations();
init_things();
=======
our $locations = init_locations();
>>>>>>> origin/master

#------------------------------------------------------------
# This is the main loop. It will repeat until the user enters
# the command "quit"
#------------------------------------------------------------
do {
	# start by giving a description of the current location
	do_look();
	my $new_command = get_command();
	do_command($new_command);
} until ($user_quit eq "true");

print "Thanks for playing!\n\n";

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
		#$chomp;
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
	print "\nWhat do you want to do? ";
	my $command = <STDIN>;
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
	if ($_[0] =~ /quit/gi) {
		$user_quit = "true";
		return;
	}
	if ($_[0] =~ /go/gi) {
		# look for a valid direction.
		if ($_[0] =~ /north/gi) {
			do_move($NORTH);
			return;
		}
		elsif ($_[0] =~ /south/gi) {
			do_move($SOUTH);
			return;
		}
		elsif($_[0] =~ /east/gi) {
			do_move($EAST);
			return;
		}
		elsif($_[0] =~ /west/gi) {
			do_move($WEST);
			return;
		}
		elsif($_[0] =~ /up/gi) {
			do_move($UP);
			return;
		}
		elsif($_[0] =~ /down/gi) {
			do_move($DOWN);
			return;
		}
	}
	if($_[0] =~ /look/gi) {
		do_look();
		return;
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
	# Print the location description.
	#print Dumper($locations);

	print "\n----------------------------------------------------------------------\n";
	print "Moves: $moves Score: $score\n";
	print "Location: ";
	print $locations->{location}->{$current_loc}->{Name};
	
	# List the exits.
	print " You can go: ";
	if ($locations->{location}->{$current_loc}->{North} ne "0") {
		print "North ";
	}
	if ($locations->{location}->{$current_loc}->{South} ne "0") {
		print "South ";
	}
	if ($locations->{location}->{$current_loc}->{East} ne "0") {
		print "East ";
	}
	if ($locations->{location}->{$current_loc}->{West} ne "0") {
		print "West ";
	}
	if ($locations->{location}->{$current_loc}->{Up} ne "0") {
		print "Up ";
	}
	if ($locations->{location}->{$current_loc}->{Down} ne "0") {
		print "Down ";
	}
	print "\n----------------------------------------------------------------------\n";
	print "\n";
	print $locations->{location}->{$current_loc}->{Description};
	print "\n\n";
	$locations->{location}->{$current_loc}->{Visited} = 1;
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
	my $direction = $_[0];
	given($direction) {
		when($NORTH)
			{
				if ($locations->{location}->{$current_loc}->{North} ne "0") {
					$current_loc = $locations->{location}->{$current_loc}->{North};
					print "Moving to: $current_loc\n";
				}
			}
		when($SOUTH)
			{
				if ($locations->{location}->{$current_loc}->{South} ne "0") {
					$current_loc = $locations->{location}->{$current_loc}->{South};
					print "Moving to: $current_loc\n";
				}
			}
		when($EAST)
			{
				if ($locations->{location}->{$current_loc}->{East} ne "0") {
					$current_loc = $locations->{location}->{$current_loc}->{East};
					print "Moving to: $current_loc\n";
				}
			}
		when($WEST)
			{
				if ($locations->{location}->{$current_loc}->{West} ne "0") {
					$current_loc = $locations->{location}->{$current_loc}->{West};
					print "Moving to: $current_loc\n";
				}
			}
		when($UP)
			{
				if ($locations->{location}->{$current_loc}->{Up} ne "0") {
					$current_loc = $locations->{location}->{$current_loc}->{Up};
					print "Moving to: $current_loc\n";
				}
			}
		when($DOWN)
			{
				if ($locations->{location}->{$current_loc}->{Down} ne "0") {
					$current_loc = $locations->{location}->{$current_loc}->{Down};
					print "Moving to: $current_loc\n";
				}
			}
		default {
			"I'm sorry, but you can't go that way.\n";
			return;
		}
	}
	
	# If we get this far, the move worked. So increment
	# the moves counter.
	$moves = $moves + 1;
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
	my $xml = new XML::Simple(KeyAttr=> {location=>'ID'}, ForceArray => ['locations', 'location']);
	
	my $locs = $xml->XMLin("locations.xml");
	
	return $locs;
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


#!/usr/local/bin/perl

#-------------------------------
# Beginner's text adventure.
# Program: "Pears Before Swine"
# Author: Irene P. Smith
# Date Created: June 26, 2014
#-------------------------------

show_welcome_msg();

$user_quit = "";
print "user quit = $user_quit\n";

# This is the main loop. It will repeat until
# the user enters the command "quit"
do
{
	$new_command = get_command();
	
	do_command();
} until ($user_quit eq "true");

print "user_quit = $user_quit\nThanks for playing!\n\n";

########## Sub declarations below

#------------------------------------
# This routine reads the file named
# "welcome.txt" and prints it to the
# screen.
#------------------------------------
sub show_welcome_msg {
	open (welcome, "welcome.txt");
	while (<welcome>) {
		$chomp;
		print "$_";
	}
	close(welcome);
	return;
}

#--------------------------------------
# Prints the prompt and then gets the
# user's command string, which it
# then returns to the calling program.
#--------------------------------------
sub get_command {
	print "What do you want to do? ";
	$command = <STDIN>;
	chomp $command;
	return $command;
}

#------------------------------------
# This routine will get more complex
# as the game is developed. This
# routine will look for a valid verb
# and, if it finds it, it will look
# for an object to which the verb
# applies.
#------------------------------------
sub do_command {
	# First, see if the user wants to quit.
	if ($new_command =~ /quit/gi)
	{
		$user_quit = "true";
	}
}

#------------------------------------
# This routine will take care of the
# look command.
#------------------------------------
sub do_look {
	# Print the location description.
	
	# List the exits.
	
	return;
}

#------------------------------------
# This routine loads the information
# for room descriptions and exist
# from the text files.
#
# The format for the file is:
#   n
#   Room description
#	N, S, E, W
#------------------------------------
sub init_locations {
	# Open the descriptions file.
#!/usr/local/bin/perl

#-------------------------------------------------------------------------
# Simple Perl application: phone.pl
# Maintains a list of names, email addresses and phone numbers.
#
# Author:	Irene Smith
# Created:	July 9, 2014
#
# Works with commands entered on the command line or with menu selections
# within the program. Valid application commands:
#
# Add a new name to the list with all information:
# 	phone -a Last First email phone
#
# Add a new name to the list with prompts:
#	phone -a
#
# Look up a person (either by last name or by full name:
#	phone -f Last
#	phone -f Last First
#
# Get the count of names in the list:
#	phone -c
#-------------------------------------------------------------------------
our $FileName = "phonelist.txt"; # The phone list file.

#-------------------------------------------------------------------------
# Parse the command line. What does the user want to do?
#
# $#ARGV is the index of the last item in the @ARGV array.
# Since the array is zero-based, $#ARGV + 1 is the count of
# arguments that the user supplied.
#-------------------------------------------------------------------------
my $argCount = $#ARGV + 1;

#-------------------------------------------------------------------------
# If the argument count is zero, just print the list of names.
#-------------------------------------------------------------------------
if ($argCount == 0) {
	PrintList();
}

#-------------------------------------------------------------------------
# If there is only one argument, that limits the number of options.
# The user might want to add new names to the list using the
# interactive display or get a count of the number of entries
#-------------------------------------------------------------------------
if ($argCount == 1) {
	if($ARGV[0] eq "-c") {
		CountNames();
	} elsif ($ARGV[0] eq "-a") {
		InteractiveAdd();
	} elsif ($ARGV[0] eq "-f") {
		print "Sorry, I can't search if you don't tell me what to find.\n";
		print "Usage: perl phone.pl lastName\n";
		print "Or use: perl phone.pl lastName firstName\n";
	}
}

#-------------------------------------------------------------------------
# Now we've got two arguments. The user could be looking for a list of
# people with a particular last name.
#-------------------------------------------------------------------------
if ($argCount == 2) {
	if($ARGV[0] eq "-f") {
		FindByLast($ARGV[1]);
	}
}

#-------------------------------------------------------------------------
# Three arguments. The only command supported with 3 arguments is find.
# We are expecting a last name and a first name here. This is probably
# more of a brute force approach than necessary. I should probably check
# for the -f argument and then call FindName with either one argument or
# two, but this is quicker to implement.
#-------------------------------------------------------------------------
if ($argCount == 3) {
	if($ARGV[0] eq "-f") {
		FindName($ARGV[1], $ARGV[2]);
	}
}

#-------------------------------------------------------------------------
#-------------------------------------------------------------------------
if ($argCount == 5) {
	if($ARGV[0] eq "-a") {
		AppendToFile($ARGV[1], $ARGV[2], $ARGV[3], $ARGV[4]);
	}
}

#-------------------------------------------------------------------------
# End of the main program. Lines below here are sub procedures.
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
# PrintList()
#
# Print the entire list of names, neatly formatted. Call the program with
# no arguments in order to print the list.
#-------------------------------------------------------------------------
sub PrintList {
	# Display the entire list of names and phone numbers.
	open MY_FILE, "<", $FileName or die "Could not open \"$FileName\".";
	
	# If the file hadn't opened successfully, we wouldn't be here.
	# First print the header.
	PrintHeader();
	
	# Read each line of the file and display it on the screen.
	while(<MY_FILE>) {
		$chomp;
		($LastName, $FirstName, $Email, $PhoneNumber) = split(", ");
		
		# Concatenate the first and last names.
		my $FullName = $LastName . ", " . $FirstName;
		
		# printf again. In this case, we're printing the full name
		# followed by the email and phone number, each field is
		# displayed in a 25 character column, the same way that the
		# header is displayed above.
		printf("%-28s %-30s %-s", $FullName, $Email, $PhoneNumber);
	}
	close MY_FILE;
}

#-------------------------------------------------------------------------
# CountNames()
#
# This sub simply opens the file and counts the number of lines.
# Use: perl phone.pl -c to count the lines in the file.
#-------------------------------------------------------------------------
sub CountNames {
	# Open the file for reading.
	open MY_FILE, "<", $FileName or die "Could not open \"$FileName\".";
	
	# If the file hadn't opened successfully, we wouldn't be here.
	# Read each line of the file and count it.
	my $lineCount = 0;
	while(<MY_FILE>) {
		++$lineCount;
	}
	close MY_FILE;
	
	# Now print the total to the screen.
	print "There are $lineCount names in the file.\n";
}

#-------------------------------------------------------------------------
# Find all entries in the list that contain the last name the user is
# looking for. This isn't fancy. It just finds the records that match and
# then prints them on the screen.
#-------------------------------------------------------------------------
sub FindByLast {
	# Open the file for reading
	open MY_FILE, "<", $FileName or die "Could not open \"$FileName\".";
	
	# If the file hadn't opened successfully, we wouldn't be here.
	# Read each line of the file and display any lines that match
	# the last name we're looking for.

	# First print the header.
	PrintHeader();
	
	my $findCount = 0;
	
	while(<MY_FILE>) {
		$chomp;
		($LastName, $FirstName, $Email, $PhoneNumber) = split(", ");
		
		if ($LastName eq $_[0]) {
			# Concatenate the first and last names.
			my $FullName = $LastName . ", " . $FirstName;
			# Display the row.
			printf("%-28s %-30s %-s", $FullName, $Email, $PhoneNumber);
			# increment the count
			++$findCount;
		}
	}
	close MY_FILE;
	if ($findCount < 1) {
		print "Sorry, I didn't find any entries that match: $_[0].\n";
	}
}

#-------------------------------------------------------------------------
# This works the same as FindByLastName() but it searches for both names
# and then prints them to the screen.
#-------------------------------------------------------------------------
sub FindName {
	# Open the file for reading
	open MY_FILE, "<", $FileName or die "Could not open \"$FileName\".";
	
	# If the file hadn't opened successfully, we wouldn't be here.
	# Read each line of the file and display any lines that match
	# the last name we're looking for.

	# First print the header.
	PrintHeader();
	my $findCount = 0;
	
	while(<MY_FILE>) {
		$chomp;
		($LastName, $FirstName, $Email, $PhoneNumber) = split(", ");
		
		if ($LastName eq $_[0] && $FirstName eq $_[1]) {
			# Concatenate the first and last names.
			my $FullName = $LastName . ", " . $FirstName;
			# Display the row.
			printf("%-28s %-30s %-s", $FullName, $Email, $PhoneNumber);
			# increment the count
			++$findCount;
		}
	}
	close MY_FILE;
	if ($findCount < 1) {
		print "Sorry, I didn't find any entries that match: $_[0], $[1].\n";
	}
}

#-------------------------------------------------------------------------
# Usage: perl -a
#
# This sub procedure guides you through the add process. It will prompt
# you for first name, last name, email address, and phone number. The
# procedure uses regular expressions to check each entry. 
#-------------------------------------------------------------------------
sub InteractiveAdd {
	print "Who do you want to add today?\n";
	
	print "First name: ";
	my $firstName = <STDIN>;
	chomp $firstName;
	
	print "Last name: ";
	my $lastName = <STDIN>;
	chomp $lastName;
	
	print "Email: ";
	my $email = <STDIN>;
	chomp $email;
	
	print "Phone 999-999-9999: ";
	my $phone = <STDIN>;
	chomp $phone;
	
	AppendToFile($firstName, $lastName, $email, $phone);
}

#-------------------------------------------------------------------------
# Usage: perl -a lastName firstName email phone
#
# AppendToFile() opens the list for append (that's what ">>" means) and
# then writes the passed information to the file. It was written this way
# so that the InteractiveAdd() sub procedure can call AppendToFile after
# it successfully gathers the information from the user.
#-------------------------------------------------------------------------
sub AppendToFile {
	# Open the file for append
	open MY_FILE, ">>", $FileName or die "Could not open \"$FileName\".";
	
	# If the file hadn't opened successfully, we wouldn't be here.
	print MY_FILE "$_[0], $_[1], $_[2], $_[3]\n";
	close MY_FILE;
	print "Added: $_[0], $_[1], $_[2], $_[3]\n";
}

sub PrintHeader {
	# Perl printf is like the printf function in C. It makes
	# the data lines neater. The first two are displayed in a 26
	# character-wide column to space out the line and make it pretty.
	print "-------------------------------------------------------------------------\n";
	printf("%-28s %-30s %-s", "Name", "Email", "Phone\n");
	print "-------------------------------------------------------------------------\n";
}

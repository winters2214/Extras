
# Git Extras

 Little git extras.

## Installation

   $ make install

## git-count

 Output commit total:

    $ git count

    total 1844

 Output verbose commit count details:

    $ git count --all

	visionmedia (1285)
	Tj Holowaychuk (430)
	Aaron Heckmann (48)
	csausdev (34)
	ciaranj (26)
	Guillermo Rauch (6)
	Brian McKinney (2)
	Nick Poulden (2)
	Benny Wong (2)
	Justin Lilly (1)
	isaacs (1)
	Adam Sanderson (1)
	Viktor Kelemen (1)
	Gregory Ritter (1)
	Greg Ritter (1)
	ewoudj (1)
	James Herdman (1)
	Matt Colyer (1)

	total 1844

## git-release

 Release commit with the given <tag>.
	
	$ git release 0.1.0
 
 Does the following:

   - Commits changes (to changelog etc) with message "Release <tag>"
   - Tags with the given <tag>
   - Pushes the branch / tags
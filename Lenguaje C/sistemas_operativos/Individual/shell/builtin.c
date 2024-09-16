#include "builtin.h"

// returns true if the 'exit' call
// should be performed
//
// (It must not be called from here)
int
exit_shell(char *cmd)
{
	return (strcmp(cmd, "exit") == 0);
}

// returns true if "chdir" was performed
//  this means that if 'cmd' contains:
// 	1. $ cd directory (change to 'directory')
// 	2. $ cd (change to $HOME)
//  it has to be executed and then return true
//
//  Remember to update the 'prompt' with the
//  	new directory.
//
// Examples:
//  1. cmd = ['c','d', ' ', '/', 'b', 'i', 'n', '\0']
//  2. cmd = ['c','d', '\0']
int
cd(char *cmd)
{
	char *directorio;

	if (!strcmp(cmd, "cd")) {
		directorio = getenv("HOME");
	} else if (!strncmp(cmd, "cd ", 3)) {
		directorio = cmd + 3;
	} else {
		return 0;
	}
	if (chdir(directorio) == 0) {
		snprintf(prompt, sizeof prompt, "(%s)", getcwd(directorio, PRMTLEN));
	}
	status = 0;
	return EXIT_SHELL;
}

// returns true if 'pwd' was invoked
// in the command line
//
// (It has to be executed here and then
// 	return true)
int
pwd(char *cmd)
{
	if (!strcmp(cmd, "pwd")) {
		char buffer[PRMTLEN];
		printf("%s\n", getcwd(buffer, PRMTLEN));
		status = 0;
		return EXIT_SHELL;
	}
	return 0;
}

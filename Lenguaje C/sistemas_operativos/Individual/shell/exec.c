#include "exec.h"

// sets "key" with the key part of "arg"
// and null-terminates it
//
// Example:
//  - KEY=value
//  arg = ['K', 'E', 'Y', '=', 'v', 'a', 'l', 'u', 'e', '\0']
//  key = "KEY"
//
static void
get_environ_key(char *arg, char *key)
{
	int i;
	for (i = 0; arg[i] != '='; i++)
		key[i] = arg[i];

	key[i] = END_STRING;
}

// sets "value" with the value part of "arg"
// and null-terminates it
// "idx" should be the index in "arg" where "=" char
// resides
//
// Example:
//  - KEY=value
//  arg = ['K', 'E', 'Y', '=', 'v', 'a', 'l', 'u', 'e', '\0']
//  value = "value"
//
static void
get_environ_value(char *arg, char *value, int idx)
{
	size_t i, j;
	for (i = (idx + 1), j = 0; i < strlen(arg); i++, j++)
		value[j] = arg[i];

	value[j] = END_STRING;
}

// sets the environment variables received
// in the command line
//
// Hints:
// - use 'block_contains()' to
// 	get the index where the '=' is
// - 'get_environ_*()' can be useful here
static void
set_environ_vars(char **eargv, int eargc)
{
	for (int i = 0; i < eargc; i++) {
		char key[PRMTLEN];
		char value[PRMTLEN];
		get_environ_key(eargv[i], key);
		get_environ_value(eargv[i], value, block_contains(eargv[i], '='));
		setenv(key, value, 1);
	}
}

// opens the file in which the stdin/stdout/stderr
// flow will be redirected, and returns
// the file descriptor
//
// Find out what permissions it needs.
// Does it have to be closed after the execve(2) call?
//
// Hints:
// - if O_CREAT is used, add S_IWUSR and S_IRUSR
// 	to make it a readable normal file
static int
open_redir_fd(char *file, int flags)
{
	if (flags & O_CREAT) {
		return open(file, flags, S_IWUSR | S_IRUSR);
	}
	return open(file, flags);
}
// executes a command - does not return
//
// Hint:
// - check how the 'cmd' structs are defined
// 	in types.h
// - casting could be a good option

void
exec_cmd(struct cmd *cmd)
{
	// To be used in the different cases
	struct execcmd *e;
	struct backcmd *b;
	struct execcmd *r;
	struct pipecmd *p;
	switch (cmd->type) {
	case EXEC:
		e = (struct execcmd *) cmd;
		set_environ_vars(e->eargv, e->eargc);
		if (execvp(e->argv[0], e->argv) < 0)
			_exit(-1);
		break;

	case BACK: {
		b = (struct backcmd *) cmd;
		exec_cmd(b->c);
		break;
	}

	case REDIR: {
		r = (struct execcmd *) cmd;
		if (strlen(r->in_file) > 0) {
			int fd = open_redir_fd(r->in_file, O_RDONLY);
			if (dup2(fd, 0) < 0)
				exit(-1);
			close(fd);
		}
		if (strlen(r->out_file) > 0) {
			int fd = open_redir_fd(r->out_file,
			                       O_CREAT | O_TRUNC | O_RDWR);
			if (dup2(fd, 1) < 0)
				exit(-1);
			close(fd);
		}
		if (strlen(r->err_file) > 0) {
			if ((r->err_file)[0] != '&') {
				int fd = open_redir_fd(r->err_file,
				                       O_CREAT | O_WRONLY);
				if (dup2(fd, 2) < 0)
					exit(-1);
				close(fd);
			} else {
				dup2(1, 2);
			}
		}
		r->type = EXEC;
		exec_cmd((struct cmd *) r);
		break;
	}

	case PIPE: {
		p = (struct pipecmd *) cmd;
		int fds[2];
		int nuevo_pipe = pipe(fds);
		if (nuevo_pipe < 0)
			exit(-1);
		int proceso = fork();
		if (proceso < 0)
			exit(-1);
		if (proceso != 0) {
			close(fds[WRITE]);
			int proceso_hijo = fork();
			if (proceso_hijo < 0)
				exit(-1);
			if (proceso_hijo != 0) {
				close(fds[READ]);
				wait(NULL);
				wait(NULL);
			} else {
				dup2(fds[READ], 0);
				close(fds[READ]);
				exec_cmd(p->rightcmd);
				exit(0);
			}
		} else {
			close(fds[READ]);
			dup2(fds[WRITE], 1);
			close(fds[WRITE]);
			exec_cmd(p->leftcmd);
		}
		free_command(parsed_pipe);
		exit(status);
		break;
	}
	}
}

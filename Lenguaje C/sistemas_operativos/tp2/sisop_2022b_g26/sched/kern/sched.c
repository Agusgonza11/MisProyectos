#include <inc/assert.h>
#include <inc/x86.h>
#include <kern/spinlock.h>
#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/monitor.h>

struct env_history {
	// struct Env envs_stats;
	int execs_env;
	int calls_sched;
};

struct env_history history = { 0, 0 };

static void
print_statistics(void)
{
	cprintf("|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|\n");
	cprintf("|                              |\n");
	cprintf("|          Estatistics         |\n");
	cprintf("|                              |\n");
	cprintf("+------------------------------+\n");
	for (int i = 0; i < NENV; i++) {
		if (envs[i].env_runs == 0) {
			continue;
		}
		cprintf("|  Process ID: %d  Runs: %d   |\n",
		        envs[i].env_id,
		        envs[i].env_runs,
		        envs[i].env_status);
	}
	cprintf("+------------------------------+\n");
	cprintf("Procesos ejecutados: %d\n", history.execs_env);
	cprintf("Llamadas a scheduler: %d\n", history.calls_sched);
}

/*
Posible scheduling por prioridades para parte 3, la prioridad se setea
igual que el env_id, la idea es que recorra los env y se guarde el de
mayor prioridad y lo ejecute, la syscall lo que hara sera reducir esa
priority. (este algoritmo pasa 17/20 pruebas de la parte 2)
*/
void
por_prioridad(size_t envs_counter)
{
	size_t i = 0;
	size_t actual_env_id = (envs_counter) % NENV;
	size_t actual_priority = envs[actual_env_id].priority;
	size_t next_env_id = actual_env_id;
	while (i < NENV) {
		actual_env_id = (envs_counter + i) % NENV;
		if (envs[actual_env_id].priority > actual_priority) {
			actual_priority = envs[actual_env_id].priority;
			next_env_id = actual_env_id;
		}
		i++;
	}
	if (envs[next_env_id].env_status == ENV_RUNNABLE) {
		envs[next_env_id].priority--;
		history.execs_env++;
		env_run(&envs[next_env_id]);
	}
}

void
round_robin(size_t envs_counter)
{
	size_t i = 0;
	while (i < NENV) {
		size_t actual_env_id = (envs_counter + i) % NENV;
		if (envs[actual_env_id].env_status == ENV_RUNNABLE) {
			history.execs_env++;
			env_run(&envs[actual_env_id]);
		}
		i++;
	}
}

void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
	struct Env *idle = curenv;
	// Implement simple round-robin scheduling.
	//
	// Search through 'envs' for an ENV_RUNNABLE environment in
	// circular fashion starting just after the env this CPU was
	// last running.  Switch to the first such environment found.
	//
	// If no envs are runnable, but the environment previously
	// running on this CPU is still ENV_RUNNING, it's okay to
	// choose that environment.
	//
	// Never choose an environment that's currently running on
	// another CPU (env_status == ENV_RUNNING). If there are
	// no runnable environments, simply drop through to the code
	// below to halt the cpu.
	history.calls_sched++;
	int envs_counter = 0;

	if (idle) {
		envs_counter = ENVX(idle->env_id);
		envs_counter++;
	}

#ifdef ROUND_ROBIN
	round_robin(envs_counter);
#endif
#ifdef POR_PRIORIDADES
	por_prioridad(envs_counter);
#endif

	// Your code here
	// Wihtout scheduler, keep runing the last environment while it exists

	if (curenv) {
		if (curenv->env_status == ENV_RUNNING) {
			env_run(curenv);
		}
	}

	// sched_halt never returns
	sched_halt();
}

// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
		print_statistics();
		while (1)
			monitor(NULL);
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
	lcr3(PADDR(kern_pgdir));

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Once the scheduler has finishied it's work, print statistics on
	// performance. Your code here

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile("movl $0, %%ebp\n"
	             "movl %0, %%esp\n"
	             "pushl $0\n"
	             "pushl $0\n"
	             "sti\n"
	             "1:\n"
	             "hlt\n"
	             "jmp 1b\n"
	             :
	             : "a"(thiscpu->cpu_ts.ts_esp0));
}

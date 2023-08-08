/*
 * Your code here for context_switch
 *
 * It should restores the register values in the Trapframe with the 'iret' instruction.
 * This exits the kernel and starts executing some environment's code.
 *
 * This function does not return.
 */

.globl context_switch;
context_switch:
	add $4, %esp
	pop %eax /*eax holds the position of the struct trapframe*/
	/*add $4, %eax*/ /*eax holds the position of the push regs*/
	/*start pushing said registers in inverse order*/
	push 64(%eax)
	push 60(%eax)
	push 56(%eax)
/*
	mov 52(%eax), %ebx
	shr $2, %ebx
	shl $2, %ebx
	add $3, %ebx
	push %ebx
*/

	push 52(%eax) /*this one is the cs push*/
	push 48(%eax)
	/*until here we push on the stack the values required by iret*/
	push 36(%eax) /*this is register ds*/
	push 32(%eax) /*this is register %es*/
	push 28(%eax)
	push 24(%eax)
	push 20(%eax)
	push 16(%eax)
	push 12(%eax)
	push 8(%eax)
	push 4(%eax)
	push (%eax)
	popal
	/*registers already set*/
	pop %es 
	pop %ds
	/*from here, iret can be called*/
	iret
spin:
	jmp spin

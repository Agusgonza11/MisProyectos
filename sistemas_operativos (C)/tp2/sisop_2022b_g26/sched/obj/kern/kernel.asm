
obj/kern/kernel:     formato del fichero elf32-i386


Desensamblado de la sección .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 10 12 00       	mov    $0x121000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3

	# Enable large pages
	movl 	%cr4, %eax
f010001d:	0f 20 e0             	mov    %cr4,%eax
	orl 	$(CR4_PSE), %eax
f0100020:	83 c8 10             	or     $0x10,%eax
	movl 	%eax, %cr4
f0100023:	0f 22 e0             	mov    %eax,%cr4

	# Turn on paging.
	movl	%cr0, %eax
f0100026:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100029:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f010002e:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100031:	b8 38 00 10 f0       	mov    $0xf0100038,%eax
	jmp	*%eax
f0100036:	ff e0                	jmp    *%eax

f0100038 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f0100038:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f010003d:	bc 00 10 12 f0       	mov    $0xf0121000,%esp

	# now to C code
	call	i386_init
f0100042:	e8 83 01 00 00       	call   f01001ca <i386_init>

f0100047 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f0100047:	eb fe                	jmp    f0100047 <spin>

f0100049 <lcr3>:
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100049:	0f 22 d8             	mov    %eax,%cr3
}
f010004c:	c3                   	ret    

f010004d <xchg>:
	return tsc;
}

static inline uint32_t
xchg(volatile uint32_t *addr, uint32_t newval)
{
f010004d:	89 c1                	mov    %eax,%ecx
f010004f:	89 d0                	mov    %edx,%eax
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100051:	f0 87 01             	lock xchg %eax,(%ecx)
		     : "+m" (*addr), "=a" (result)
		     : "1" (newval)
		     : "cc");
	return result;
}
f0100054:	c3                   	ret    

f0100055 <lock_kernel>:

extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
f0100055:	55                   	push   %ebp
f0100056:	89 e5                	mov    %esp,%ebp
f0100058:	83 ec 14             	sub    $0x14,%esp
	spin_lock(&kernel_lock);
f010005b:	68 c0 23 12 f0       	push   $0xf01223c0
f0100060:	e8 ec 60 00 00       	call   f0106151 <spin_lock>
}
f0100065:	83 c4 10             	add    $0x10,%esp
f0100068:	c9                   	leave  
f0100069:	c3                   	ret    

f010006a <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
f010006a:	f3 0f 1e fb          	endbr32 
f010006e:	55                   	push   %ebp
f010006f:	89 e5                	mov    %esp,%ebp
f0100071:	56                   	push   %esi
f0100072:	53                   	push   %ebx
f0100073:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100076:	83 3d 80 8e 24 f0 00 	cmpl   $0x0,0xf0248e80
f010007d:	74 0f                	je     f010008e <_panic+0x24>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010007f:	83 ec 0c             	sub    $0xc,%esp
f0100082:	6a 00                	push   $0x0
f0100084:	e8 d8 0a 00 00       	call   f0100b61 <monitor>
f0100089:	83 c4 10             	add    $0x10,%esp
f010008c:	eb f1                	jmp    f010007f <_panic+0x15>
	panicstr = fmt;
f010008e:	89 35 80 8e 24 f0    	mov    %esi,0xf0248e80
	asm volatile("cli; cld");
f0100094:	fa                   	cli    
f0100095:	fc                   	cld    
	va_start(ap, fmt);
f0100096:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf(">>>\n>>> kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f0100099:	e8 ae 5d 00 00       	call   f0105e4c <cpunum>
f010009e:	ff 75 0c             	pushl  0xc(%ebp)
f01000a1:	ff 75 08             	pushl  0x8(%ebp)
f01000a4:	50                   	push   %eax
f01000a5:	68 00 65 10 f0       	push   $0xf0106500
f01000aa:	e8 ba 37 00 00       	call   f0103869 <cprintf>
	vcprintf(fmt, ap);
f01000af:	83 c4 08             	add    $0x8,%esp
f01000b2:	53                   	push   %ebx
f01000b3:	56                   	push   %esi
f01000b4:	e8 86 37 00 00       	call   f010383f <vcprintf>
	cprintf("\n>>>\n");
f01000b9:	c7 04 24 74 65 10 f0 	movl   $0xf0106574,(%esp)
f01000c0:	e8 a4 37 00 00       	call   f0103869 <cprintf>
f01000c5:	83 c4 10             	add    $0x10,%esp
f01000c8:	eb b5                	jmp    f010007f <_panic+0x15>

f01000ca <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f01000ca:	55                   	push   %ebp
f01000cb:	89 e5                	mov    %esp,%ebp
f01000cd:	53                   	push   %ebx
f01000ce:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f01000d1:	89 cb                	mov    %ecx,%ebx
f01000d3:	c1 eb 0c             	shr    $0xc,%ebx
f01000d6:	3b 1d 88 8e 24 f0    	cmp    0xf0248e88,%ebx
f01000dc:	73 0b                	jae    f01000e9 <_kaddr+0x1f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
	return (void *)(pa + KERNBASE);
f01000de:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f01000e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01000e7:	c9                   	leave  
f01000e8:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01000e9:	51                   	push   %ecx
f01000ea:	68 2c 65 10 f0       	push   $0xf010652c
f01000ef:	52                   	push   %edx
f01000f0:	50                   	push   %eax
f01000f1:	e8 74 ff ff ff       	call   f010006a <_panic>

f01000f6 <_paddr>:
	if ((uint32_t)kva < KERNBASE)
f01000f6:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01000fc:	76 07                	jbe    f0100105 <_paddr+0xf>
	return (physaddr_t)kva - KERNBASE;
f01000fe:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0100104:	c3                   	ret    
{
f0100105:	55                   	push   %ebp
f0100106:	89 e5                	mov    %esp,%ebp
f0100108:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010010b:	51                   	push   %ecx
f010010c:	68 50 65 10 f0       	push   $0xf0106550
f0100111:	52                   	push   %edx
f0100112:	50                   	push   %eax
f0100113:	e8 52 ff ff ff       	call   f010006a <_panic>

f0100118 <boot_aps>:
{
f0100118:	55                   	push   %ebp
f0100119:	89 e5                	mov    %esp,%ebp
f010011b:	56                   	push   %esi
f010011c:	53                   	push   %ebx
	code = KADDR(MPENTRY_PADDR);
f010011d:	b9 00 70 00 00       	mov    $0x7000,%ecx
f0100122:	ba 62 00 00 00       	mov    $0x62,%edx
f0100127:	b8 7a 65 10 f0       	mov    $0xf010657a,%eax
f010012c:	e8 99 ff ff ff       	call   f01000ca <_kaddr>
f0100131:	89 c6                	mov    %eax,%esi
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100133:	83 ec 04             	sub    $0x4,%esp
f0100136:	b8 4a 5a 10 f0       	mov    $0xf0105a4a,%eax
f010013b:	2d c8 59 10 f0       	sub    $0xf01059c8,%eax
f0100140:	50                   	push   %eax
f0100141:	68 c8 59 10 f0       	push   $0xf01059c8
f0100146:	56                   	push   %esi
f0100147:	e8 bd 56 00 00       	call   f0105809 <memmove>
	for (c = cpus; c < cpus + ncpu; c++) {
f010014c:	83 c4 10             	add    $0x10,%esp
f010014f:	bb 20 90 24 f0       	mov    $0xf0249020,%ebx
f0100154:	eb 4a                	jmp    f01001a0 <boot_aps+0x88>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100156:	89 d8                	mov    %ebx,%eax
f0100158:	2d 20 90 24 f0       	sub    $0xf0249020,%eax
f010015d:	c1 f8 02             	sar    $0x2,%eax
f0100160:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100166:	c1 e0 0f             	shl    $0xf,%eax
f0100169:	8d 80 00 20 25 f0    	lea    -0xfdae000(%eax),%eax
f010016f:	a3 84 8e 24 f0       	mov    %eax,0xf0248e84
		lapic_startap(c->cpu_id, PADDR(code));
f0100174:	89 f1                	mov    %esi,%ecx
f0100176:	ba 6d 00 00 00       	mov    $0x6d,%edx
f010017b:	b8 7a 65 10 f0       	mov    $0xf010657a,%eax
f0100180:	e8 71 ff ff ff       	call   f01000f6 <_paddr>
f0100185:	83 ec 08             	sub    $0x8,%esp
f0100188:	50                   	push   %eax
f0100189:	0f b6 03             	movzbl (%ebx),%eax
f010018c:	50                   	push   %eax
f010018d:	e8 2e 5e 00 00       	call   f0105fc0 <lapic_startap>
		while(c->cpu_status != CPU_STARTED)
f0100192:	83 c4 10             	add    $0x10,%esp
f0100195:	8b 43 04             	mov    0x4(%ebx),%eax
f0100198:	83 f8 01             	cmp    $0x1,%eax
f010019b:	75 f8                	jne    f0100195 <boot_aps+0x7d>
	for (c = cpus; c < cpus + ncpu; c++) {
f010019d:	83 c3 74             	add    $0x74,%ebx
f01001a0:	6b 05 c4 93 24 f0 74 	imul   $0x74,0xf02493c4,%eax
f01001a7:	05 20 90 24 f0       	add    $0xf0249020,%eax
f01001ac:	39 c3                	cmp    %eax,%ebx
f01001ae:	73 13                	jae    f01001c3 <boot_aps+0xab>
		if (c == cpus + cpunum())  // We've started already.
f01001b0:	e8 97 5c 00 00       	call   f0105e4c <cpunum>
f01001b5:	6b c0 74             	imul   $0x74,%eax,%eax
f01001b8:	05 20 90 24 f0       	add    $0xf0249020,%eax
f01001bd:	39 c3                	cmp    %eax,%ebx
f01001bf:	74 dc                	je     f010019d <boot_aps+0x85>
f01001c1:	eb 93                	jmp    f0100156 <boot_aps+0x3e>
}
f01001c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01001c6:	5b                   	pop    %ebx
f01001c7:	5e                   	pop    %esi
f01001c8:	5d                   	pop    %ebp
f01001c9:	c3                   	ret    

f01001ca <i386_init>:
{
f01001ca:	f3 0f 1e fb          	endbr32 
f01001ce:	55                   	push   %ebp
f01001cf:	89 e5                	mov    %esp,%ebp
f01001d1:	83 ec 0c             	sub    $0xc,%esp
	memset(__bss_start, 0, end - __bss_start);
f01001d4:	b8 08 a0 28 f0       	mov    $0xf028a008,%eax
f01001d9:	2d 00 80 24 f0       	sub    $0xf0248000,%eax
f01001de:	50                   	push   %eax
f01001df:	6a 00                	push   $0x0
f01001e1:	68 00 80 24 f0       	push   $0xf0248000
f01001e6:	e8 d0 55 00 00       	call   f01057bb <memset>
	cons_init();
f01001eb:	e8 08 07 00 00       	call   f01008f8 <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01001f0:	83 c4 08             	add    $0x8,%esp
f01001f3:	68 ac 1a 00 00       	push   $0x1aac
f01001f8:	68 86 65 10 f0       	push   $0xf0106586
f01001fd:	e8 67 36 00 00       	call   f0103869 <cprintf>
	mem_init();
f0100202:	e8 26 2a 00 00       	call   f0102c2d <mem_init>
	env_init();
f0100207:	e8 12 30 00 00       	call   f010321e <env_init>
	trap_init();
f010020c:	e8 77 37 00 00       	call   f0103988 <trap_init>
	mp_init();
f0100211:	e8 79 5a 00 00       	call   f0105c8f <mp_init>
	lapic_init();
f0100216:	e8 4b 5c 00 00       	call   f0105e66 <lapic_init>
	pic_init();
f010021b:	e8 fb 34 00 00       	call   f010371b <pic_init>
	lock_kernel();	
f0100220:	e8 30 fe ff ff       	call   f0100055 <lock_kernel>
	boot_aps();
f0100225:	e8 ee fe ff ff       	call   f0100118 <boot_aps>
	ENV_CREATE(user_hello, ENV_TYPE_USER);
f010022a:	83 c4 08             	add    $0x8,%esp
f010022d:	6a 00                	push   $0x0
f010022f:	68 f4 23 12 f0       	push   $0xf01223f4
f0100234:	e8 3a 31 00 00       	call   f0103373 <env_create>
	ENV_CREATE(user_hello, ENV_TYPE_USER);
f0100239:	83 c4 08             	add    $0x8,%esp
f010023c:	6a 00                	push   $0x0
f010023e:	68 f4 23 12 f0       	push   $0xf01223f4
f0100243:	e8 2b 31 00 00       	call   f0103373 <env_create>
	ENV_CREATE(user_hello, ENV_TYPE_USER);
f0100248:	83 c4 08             	add    $0x8,%esp
f010024b:	6a 00                	push   $0x0
f010024d:	68 f4 23 12 f0       	push   $0xf01223f4
f0100252:	e8 1c 31 00 00       	call   f0103373 <env_create>
	env_run(&envs[0]);
f0100257:	83 c4 04             	add    $0x4,%esp
f010025a:	ff 35 44 82 24 f0    	pushl  0xf0248244
f0100260:	e8 39 33 00 00       	call   f010359e <env_run>

f0100265 <mp_main>:
{
f0100265:	f3 0f 1e fb          	endbr32 
f0100269:	55                   	push   %ebp
f010026a:	89 e5                	mov    %esp,%ebp
f010026c:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f010026f:	8b 0d 8c 8e 24 f0    	mov    0xf0248e8c,%ecx
f0100275:	ba 79 00 00 00       	mov    $0x79,%edx
f010027a:	b8 7a 65 10 f0       	mov    $0xf010657a,%eax
f010027f:	e8 72 fe ff ff       	call   f01000f6 <_paddr>
f0100284:	e8 c0 fd ff ff       	call   f0100049 <lcr3>
	cprintf("SMP: CPU %d starting\n", cpunum());
f0100289:	e8 be 5b 00 00       	call   f0105e4c <cpunum>
f010028e:	83 ec 08             	sub    $0x8,%esp
f0100291:	50                   	push   %eax
f0100292:	68 a1 65 10 f0       	push   $0xf01065a1
f0100297:	e8 cd 35 00 00       	call   f0103869 <cprintf>
	lapic_init();
f010029c:	e8 c5 5b 00 00       	call   f0105e66 <lapic_init>
	env_init_percpu();
f01002a1:	e8 3d 2f 00 00       	call   f01031e3 <env_init_percpu>
	trap_init_percpu();
f01002a6:	e8 30 36 00 00       	call   f01038db <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01002ab:	e8 9c 5b 00 00       	call   f0105e4c <cpunum>
f01002b0:	6b c0 74             	imul   $0x74,%eax,%eax
f01002b3:	05 24 90 24 f0       	add    $0xf0249024,%eax
f01002b8:	ba 01 00 00 00       	mov    $0x1,%edx
f01002bd:	e8 8b fd ff ff       	call   f010004d <xchg>
	lock_kernel();
f01002c2:	e8 8e fd ff ff       	call   f0100055 <lock_kernel>
	sched_yield();
f01002c7:	e8 1a 42 00 00       	call   f01044e6 <sched_yield>

f01002cc <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt, ...)
{
f01002cc:	f3 0f 1e fb          	endbr32 
f01002d0:	55                   	push   %ebp
f01002d1:	89 e5                	mov    %esp,%ebp
f01002d3:	53                   	push   %ebx
f01002d4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01002d7:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002da:	ff 75 0c             	pushl  0xc(%ebp)
f01002dd:	ff 75 08             	pushl  0x8(%ebp)
f01002e0:	68 b7 65 10 f0       	push   $0xf01065b7
f01002e5:	e8 7f 35 00 00       	call   f0103869 <cprintf>
	vcprintf(fmt, ap);
f01002ea:	83 c4 08             	add    $0x8,%esp
f01002ed:	53                   	push   %ebx
f01002ee:	ff 75 10             	pushl  0x10(%ebp)
f01002f1:	e8 49 35 00 00       	call   f010383f <vcprintf>
	cprintf("\n");
f01002f6:	c7 04 24 e8 76 10 f0 	movl   $0xf01076e8,(%esp)
f01002fd:	e8 67 35 00 00       	call   f0103869 <cprintf>
	va_end(ap);
}
f0100302:	83 c4 10             	add    $0x10,%esp
f0100305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100308:	c9                   	leave  
f0100309:	c3                   	ret    

f010030a <inb>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010030a:	89 c2                	mov    %eax,%edx
f010030c:	ec                   	in     (%dx),%al
}
f010030d:	c3                   	ret    

f010030e <outb>:
{
f010030e:	89 c1                	mov    %eax,%ecx
f0100310:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100312:	89 ca                	mov    %ecx,%edx
f0100314:	ee                   	out    %al,(%dx)
}
f0100315:	c3                   	ret    

f0100316 <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f0100316:	55                   	push   %ebp
f0100317:	89 e5                	mov    %esp,%ebp
f0100319:	83 ec 08             	sub    $0x8,%esp
	inb(0x84);
f010031c:	b8 84 00 00 00       	mov    $0x84,%eax
f0100321:	e8 e4 ff ff ff       	call   f010030a <inb>
	inb(0x84);
f0100326:	b8 84 00 00 00       	mov    $0x84,%eax
f010032b:	e8 da ff ff ff       	call   f010030a <inb>
	inb(0x84);
f0100330:	b8 84 00 00 00       	mov    $0x84,%eax
f0100335:	e8 d0 ff ff ff       	call   f010030a <inb>
	inb(0x84);
f010033a:	b8 84 00 00 00       	mov    $0x84,%eax
f010033f:	e8 c6 ff ff ff       	call   f010030a <inb>
}
f0100344:	c9                   	leave  
f0100345:	c3                   	ret    

f0100346 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100346:	f3 0f 1e fb          	endbr32 
f010034a:	55                   	push   %ebp
f010034b:	89 e5                	mov    %esp,%ebp
f010034d:	83 ec 08             	sub    $0x8,%esp
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100350:	b8 fd 03 00 00       	mov    $0x3fd,%eax
f0100355:	e8 b0 ff ff ff       	call   f010030a <inb>
f010035a:	a8 01                	test   $0x1,%al
f010035c:	74 0f                	je     f010036d <serial_proc_data+0x27>
		return -1;
	return inb(COM1+COM_RX);
f010035e:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f0100363:	e8 a2 ff ff ff       	call   f010030a <inb>
f0100368:	0f b6 c0             	movzbl %al,%eax
}
f010036b:	c9                   	leave  
f010036c:	c3                   	ret    
		return -1;
f010036d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100372:	eb f7                	jmp    f010036b <serial_proc_data+0x25>

f0100374 <serial_putc>:
		cons_intr(serial_proc_data);
}

static void
serial_putc(int c)
{
f0100374:	55                   	push   %ebp
f0100375:	89 e5                	mov    %esp,%ebp
f0100377:	56                   	push   %esi
f0100378:	53                   	push   %ebx
f0100379:	89 c6                	mov    %eax,%esi
	int i;

	for (i = 0;
f010037b:	bb 00 00 00 00       	mov    $0x0,%ebx
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100380:	b8 fd 03 00 00       	mov    $0x3fd,%eax
f0100385:	e8 80 ff ff ff       	call   f010030a <inb>
f010038a:	a8 20                	test   $0x20,%al
f010038c:	75 12                	jne    f01003a0 <serial_putc+0x2c>
f010038e:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f0100394:	7f 0a                	jg     f01003a0 <serial_putc+0x2c>
	     i++)
		delay();
f0100396:	e8 7b ff ff ff       	call   f0100316 <delay>
	     i++)
f010039b:	83 c3 01             	add    $0x1,%ebx
f010039e:	eb e0                	jmp    f0100380 <serial_putc+0xc>

	outb(COM1 + COM_TX, c);
f01003a0:	89 f0                	mov    %esi,%eax
f01003a2:	0f b6 d0             	movzbl %al,%edx
f01003a5:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f01003aa:	e8 5f ff ff ff       	call   f010030e <outb>
}
f01003af:	5b                   	pop    %ebx
f01003b0:	5e                   	pop    %esi
f01003b1:	5d                   	pop    %ebp
f01003b2:	c3                   	ret    

f01003b3 <serial_init>:

static void
serial_init(void)
{
f01003b3:	55                   	push   %ebp
f01003b4:	89 e5                	mov    %esp,%ebp
f01003b6:	83 ec 08             	sub    $0x8,%esp
	// Turn off the FIFO
	outb(COM1+COM_FCR, 0);
f01003b9:	ba 00 00 00 00       	mov    $0x0,%edx
f01003be:	b8 fa 03 00 00       	mov    $0x3fa,%eax
f01003c3:	e8 46 ff ff ff       	call   f010030e <outb>

	// Set speed; requires DLAB latch
	outb(COM1+COM_LCR, COM_LCR_DLAB);
f01003c8:	ba 80 00 00 00       	mov    $0x80,%edx
f01003cd:	b8 fb 03 00 00       	mov    $0x3fb,%eax
f01003d2:	e8 37 ff ff ff       	call   f010030e <outb>
	outb(COM1+COM_DLL, (uint8_t) (115200 / 9600));
f01003d7:	ba 0c 00 00 00       	mov    $0xc,%edx
f01003dc:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f01003e1:	e8 28 ff ff ff       	call   f010030e <outb>
	outb(COM1+COM_DLM, 0);
f01003e6:	ba 00 00 00 00       	mov    $0x0,%edx
f01003eb:	b8 f9 03 00 00       	mov    $0x3f9,%eax
f01003f0:	e8 19 ff ff ff       	call   f010030e <outb>

	// 8 data bits, 1 stop bit, parity off; turn off DLAB latch
	outb(COM1+COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);
f01003f5:	ba 03 00 00 00       	mov    $0x3,%edx
f01003fa:	b8 fb 03 00 00       	mov    $0x3fb,%eax
f01003ff:	e8 0a ff ff ff       	call   f010030e <outb>

	// No modem controls
	outb(COM1+COM_MCR, 0);
f0100404:	ba 00 00 00 00       	mov    $0x0,%edx
f0100409:	b8 fc 03 00 00       	mov    $0x3fc,%eax
f010040e:	e8 fb fe ff ff       	call   f010030e <outb>
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);
f0100413:	ba 01 00 00 00       	mov    $0x1,%edx
f0100418:	b8 f9 03 00 00       	mov    $0x3f9,%eax
f010041d:	e8 ec fe ff ff       	call   f010030e <outb>

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100422:	b8 fd 03 00 00       	mov    $0x3fd,%eax
f0100427:	e8 de fe ff ff       	call   f010030a <inb>
f010042c:	3c ff                	cmp    $0xff,%al
f010042e:	0f 95 05 34 82 24 f0 	setne  0xf0248234
	(void) inb(COM1+COM_IIR);
f0100435:	b8 fa 03 00 00       	mov    $0x3fa,%eax
f010043a:	e8 cb fe ff ff       	call   f010030a <inb>
	(void) inb(COM1+COM_RX);
f010043f:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f0100444:	e8 c1 fe ff ff       	call   f010030a <inb>

}
f0100449:	c9                   	leave  
f010044a:	c3                   	ret    

f010044b <lpt_putc>:
// For information on PC parallel port programming, see the class References
// page.

static void
lpt_putc(int c)
{
f010044b:	55                   	push   %ebp
f010044c:	89 e5                	mov    %esp,%ebp
f010044e:	56                   	push   %esi
f010044f:	53                   	push   %ebx
f0100450:	89 c6                	mov    %eax,%esi
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100452:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100457:	b8 79 03 00 00       	mov    $0x379,%eax
f010045c:	e8 a9 fe ff ff       	call   f010030a <inb>
f0100461:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f0100467:	7f 0e                	jg     f0100477 <lpt_putc+0x2c>
f0100469:	84 c0                	test   %al,%al
f010046b:	78 0a                	js     f0100477 <lpt_putc+0x2c>
		delay();
f010046d:	e8 a4 fe ff ff       	call   f0100316 <delay>
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100472:	83 c3 01             	add    $0x1,%ebx
f0100475:	eb e0                	jmp    f0100457 <lpt_putc+0xc>
	outb(0x378+0, c);
f0100477:	89 f0                	mov    %esi,%eax
f0100479:	0f b6 d0             	movzbl %al,%edx
f010047c:	b8 78 03 00 00       	mov    $0x378,%eax
f0100481:	e8 88 fe ff ff       	call   f010030e <outb>
	outb(0x378+2, 0x08|0x04|0x01);
f0100486:	ba 0d 00 00 00       	mov    $0xd,%edx
f010048b:	b8 7a 03 00 00       	mov    $0x37a,%eax
f0100490:	e8 79 fe ff ff       	call   f010030e <outb>
	outb(0x378+2, 0x08);
f0100495:	ba 08 00 00 00       	mov    $0x8,%edx
f010049a:	b8 7a 03 00 00       	mov    $0x37a,%eax
f010049f:	e8 6a fe ff ff       	call   f010030e <outb>
}
f01004a4:	5b                   	pop    %ebx
f01004a5:	5e                   	pop    %esi
f01004a6:	5d                   	pop    %ebp
f01004a7:	c3                   	ret    

f01004a8 <cga_init>:
static uint16_t *crt_buf;
static uint16_t crt_pos;

static void
cga_init(void)
{
f01004a8:	55                   	push   %ebp
f01004a9:	89 e5                	mov    %esp,%ebp
f01004ab:	57                   	push   %edi
f01004ac:	56                   	push   %esi
f01004ad:	53                   	push   %ebx
f01004ae:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f01004b1:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01004b8:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01004bf:	5a a5 
	if (*cp != 0xA55A) {
f01004c1:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01004c8:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01004cc:	74 63                	je     f0100531 <cga_init+0x89>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f01004ce:	c7 05 30 82 24 f0 b4 	movl   $0x3b4,0xf0248230
f01004d5:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01004d8:	c7 45 e4 00 00 0b f0 	movl   $0xf00b0000,-0x1c(%ebp)
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f01004df:	8b 35 30 82 24 f0    	mov    0xf0248230,%esi
f01004e5:	ba 0e 00 00 00       	mov    $0xe,%edx
f01004ea:	89 f0                	mov    %esi,%eax
f01004ec:	e8 1d fe ff ff       	call   f010030e <outb>
	pos = inb(addr_6845 + 1) << 8;
f01004f1:	8d 7e 01             	lea    0x1(%esi),%edi
f01004f4:	89 f8                	mov    %edi,%eax
f01004f6:	e8 0f fe ff ff       	call   f010030a <inb>
f01004fb:	0f b6 d8             	movzbl %al,%ebx
f01004fe:	c1 e3 08             	shl    $0x8,%ebx
	outb(addr_6845, 15);
f0100501:	ba 0f 00 00 00       	mov    $0xf,%edx
f0100506:	89 f0                	mov    %esi,%eax
f0100508:	e8 01 fe ff ff       	call   f010030e <outb>
	pos |= inb(addr_6845 + 1);
f010050d:	89 f8                	mov    %edi,%eax
f010050f:	e8 f6 fd ff ff       	call   f010030a <inb>

	crt_buf = (uint16_t*) cp;
f0100514:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0100517:	89 0d 2c 82 24 f0    	mov    %ecx,0xf024822c
	pos |= inb(addr_6845 + 1);
f010051d:	0f b6 c0             	movzbl %al,%eax
f0100520:	09 c3                	or     %eax,%ebx
	crt_pos = pos;
f0100522:	66 89 1d 28 82 24 f0 	mov    %bx,0xf0248228
}
f0100529:	83 c4 1c             	add    $0x1c,%esp
f010052c:	5b                   	pop    %ebx
f010052d:	5e                   	pop    %esi
f010052e:	5f                   	pop    %edi
f010052f:	5d                   	pop    %ebp
f0100530:	c3                   	ret    
		*cp = was;
f0100531:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100538:	c7 05 30 82 24 f0 d4 	movl   $0x3d4,0xf0248230
f010053f:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100542:	c7 45 e4 00 80 0b f0 	movl   $0xf00b8000,-0x1c(%ebp)
f0100549:	eb 94                	jmp    f01004df <cga_init+0x37>

f010054b <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010054b:	55                   	push   %ebp
f010054c:	89 e5                	mov    %esp,%ebp
f010054e:	53                   	push   %ebx
f010054f:	83 ec 04             	sub    $0x4,%esp
f0100552:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100554:	ff d3                	call   *%ebx
f0100556:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100559:	74 29                	je     f0100584 <cons_intr+0x39>
		if (c == 0)
f010055b:	85 c0                	test   %eax,%eax
f010055d:	74 f5                	je     f0100554 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f010055f:	8b 0d 24 82 24 f0    	mov    0xf0248224,%ecx
f0100565:	8d 51 01             	lea    0x1(%ecx),%edx
f0100568:	88 81 20 80 24 f0    	mov    %al,-0xfdb7fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f010056e:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f0100574:	b8 00 00 00 00       	mov    $0x0,%eax
f0100579:	0f 44 d0             	cmove  %eax,%edx
f010057c:	89 15 24 82 24 f0    	mov    %edx,0xf0248224
f0100582:	eb d0                	jmp    f0100554 <cons_intr+0x9>
	}
}
f0100584:	83 c4 04             	add    $0x4,%esp
f0100587:	5b                   	pop    %ebx
f0100588:	5d                   	pop    %ebp
f0100589:	c3                   	ret    

f010058a <kbd_proc_data>:
{
f010058a:	f3 0f 1e fb          	endbr32 
f010058e:	55                   	push   %ebp
f010058f:	89 e5                	mov    %esp,%ebp
f0100591:	53                   	push   %ebx
f0100592:	83 ec 04             	sub    $0x4,%esp
	stat = inb(KBSTATP);
f0100595:	b8 64 00 00 00       	mov    $0x64,%eax
f010059a:	e8 6b fd ff ff       	call   f010030a <inb>
	if ((stat & KBS_DIB) == 0)
f010059f:	a8 01                	test   $0x1,%al
f01005a1:	0f 84 f7 00 00 00    	je     f010069e <kbd_proc_data+0x114>
	if (stat & KBS_TERR)
f01005a7:	a8 20                	test   $0x20,%al
f01005a9:	0f 85 f6 00 00 00    	jne    f01006a5 <kbd_proc_data+0x11b>
	data = inb(KBDATAP);
f01005af:	b8 60 00 00 00       	mov    $0x60,%eax
f01005b4:	e8 51 fd ff ff       	call   f010030a <inb>
	if (data == 0xE0) {
f01005b9:	3c e0                	cmp    $0xe0,%al
f01005bb:	74 61                	je     f010061e <kbd_proc_data+0x94>
	} else if (data & 0x80) {
f01005bd:	84 c0                	test   %al,%al
f01005bf:	78 70                	js     f0100631 <kbd_proc_data+0xa7>
	} else if (shift & E0ESC) {
f01005c1:	8b 15 00 80 24 f0    	mov    0xf0248000,%edx
f01005c7:	f6 c2 40             	test   $0x40,%dl
f01005ca:	74 0c                	je     f01005d8 <kbd_proc_data+0x4e>
		data |= 0x80;
f01005cc:	83 c8 80             	or     $0xffffff80,%eax
		shift &= ~E0ESC;
f01005cf:	83 e2 bf             	and    $0xffffffbf,%edx
f01005d2:	89 15 00 80 24 f0    	mov    %edx,0xf0248000
	shift |= shiftcode[data];
f01005d8:	0f b6 c0             	movzbl %al,%eax
f01005db:	0f b6 90 20 67 10 f0 	movzbl -0xfef98e0(%eax),%edx
f01005e2:	0b 15 00 80 24 f0    	or     0xf0248000,%edx
	shift ^= togglecode[data];
f01005e8:	0f b6 88 20 66 10 f0 	movzbl -0xfef99e0(%eax),%ecx
f01005ef:	31 ca                	xor    %ecx,%edx
f01005f1:	89 15 00 80 24 f0    	mov    %edx,0xf0248000
	c = charcode[shift & (CTL | SHIFT)][data];
f01005f7:	89 d1                	mov    %edx,%ecx
f01005f9:	83 e1 03             	and    $0x3,%ecx
f01005fc:	8b 0c 8d 00 66 10 f0 	mov    -0xfef9a00(,%ecx,4),%ecx
f0100603:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
f0100607:	0f b6 d8             	movzbl %al,%ebx
	if (shift & CAPSLOCK) {
f010060a:	f6 c2 08             	test   $0x8,%dl
f010060d:	74 5f                	je     f010066e <kbd_proc_data+0xe4>
		if ('a' <= c && c <= 'z')
f010060f:	89 d8                	mov    %ebx,%eax
f0100611:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100614:	83 f9 19             	cmp    $0x19,%ecx
f0100617:	77 49                	ja     f0100662 <kbd_proc_data+0xd8>
			c += 'A' - 'a';
f0100619:	83 eb 20             	sub    $0x20,%ebx
f010061c:	eb 0c                	jmp    f010062a <kbd_proc_data+0xa0>
		shift |= E0ESC;
f010061e:	83 0d 00 80 24 f0 40 	orl    $0x40,0xf0248000
		return 0;
f0100625:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010062a:	89 d8                	mov    %ebx,%eax
f010062c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010062f:	c9                   	leave  
f0100630:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100631:	8b 15 00 80 24 f0    	mov    0xf0248000,%edx
f0100637:	89 c1                	mov    %eax,%ecx
f0100639:	83 e1 7f             	and    $0x7f,%ecx
f010063c:	f6 c2 40             	test   $0x40,%dl
f010063f:	0f 44 c1             	cmove  %ecx,%eax
		shift &= ~(shiftcode[data] | E0ESC);
f0100642:	0f b6 c0             	movzbl %al,%eax
f0100645:	0f b6 80 20 67 10 f0 	movzbl -0xfef98e0(%eax),%eax
f010064c:	83 c8 40             	or     $0x40,%eax
f010064f:	0f b6 c0             	movzbl %al,%eax
f0100652:	f7 d0                	not    %eax
f0100654:	21 d0                	and    %edx,%eax
f0100656:	a3 00 80 24 f0       	mov    %eax,0xf0248000
		return 0;
f010065b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100660:	eb c8                	jmp    f010062a <kbd_proc_data+0xa0>
		else if ('A' <= c && c <= 'Z')
f0100662:	83 e8 41             	sub    $0x41,%eax
			c += 'a' - 'A';
f0100665:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100668:	83 f8 1a             	cmp    $0x1a,%eax
f010066b:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010066e:	f7 d2                	not    %edx
f0100670:	f6 c2 06             	test   $0x6,%dl
f0100673:	75 b5                	jne    f010062a <kbd_proc_data+0xa0>
f0100675:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010067b:	75 ad                	jne    f010062a <kbd_proc_data+0xa0>
		cprintf("Rebooting!\n");
f010067d:	83 ec 0c             	sub    $0xc,%esp
f0100680:	68 d1 65 10 f0       	push   $0xf01065d1
f0100685:	e8 df 31 00 00       	call   f0103869 <cprintf>
		outb(0x92, 0x3); // courtesy of Chris Frost
f010068a:	ba 03 00 00 00       	mov    $0x3,%edx
f010068f:	b8 92 00 00 00       	mov    $0x92,%eax
f0100694:	e8 75 fc ff ff       	call   f010030e <outb>
f0100699:	83 c4 10             	add    $0x10,%esp
f010069c:	eb 8c                	jmp    f010062a <kbd_proc_data+0xa0>
		return -1;
f010069e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01006a3:	eb 85                	jmp    f010062a <kbd_proc_data+0xa0>
		return -1;
f01006a5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01006aa:	e9 7b ff ff ff       	jmp    f010062a <kbd_proc_data+0xa0>

f01006af <cga_putc>:
{
f01006af:	55                   	push   %ebp
f01006b0:	89 e5                	mov    %esp,%ebp
f01006b2:	57                   	push   %edi
f01006b3:	56                   	push   %esi
f01006b4:	53                   	push   %ebx
f01006b5:	83 ec 0c             	sub    $0xc,%esp
		c |= 0x0700;
f01006b8:	89 c2                	mov    %eax,%edx
f01006ba:	80 ce 07             	or     $0x7,%dh
f01006bd:	a9 00 ff ff ff       	test   $0xffffff00,%eax
f01006c2:	0f 44 c2             	cmove  %edx,%eax
	switch (c & 0xff) {
f01006c5:	3c 0a                	cmp    $0xa,%al
f01006c7:	0f 84 f0 00 00 00    	je     f01007bd <cga_putc+0x10e>
f01006cd:	0f b6 d0             	movzbl %al,%edx
f01006d0:	83 fa 0a             	cmp    $0xa,%edx
f01006d3:	7f 46                	jg     f010071b <cga_putc+0x6c>
f01006d5:	83 fa 08             	cmp    $0x8,%edx
f01006d8:	0f 84 b5 00 00 00    	je     f0100793 <cga_putc+0xe4>
f01006de:	83 fa 09             	cmp    $0x9,%edx
f01006e1:	0f 85 e3 00 00 00    	jne    f01007ca <cga_putc+0x11b>
		cons_putc(' ');
f01006e7:	b8 20 00 00 00       	mov    $0x20,%eax
f01006ec:	e8 44 01 00 00       	call   f0100835 <cons_putc>
		cons_putc(' ');
f01006f1:	b8 20 00 00 00       	mov    $0x20,%eax
f01006f6:	e8 3a 01 00 00       	call   f0100835 <cons_putc>
		cons_putc(' ');
f01006fb:	b8 20 00 00 00       	mov    $0x20,%eax
f0100700:	e8 30 01 00 00       	call   f0100835 <cons_putc>
		cons_putc(' ');
f0100705:	b8 20 00 00 00       	mov    $0x20,%eax
f010070a:	e8 26 01 00 00       	call   f0100835 <cons_putc>
		cons_putc(' ');
f010070f:	b8 20 00 00 00       	mov    $0x20,%eax
f0100714:	e8 1c 01 00 00       	call   f0100835 <cons_putc>
		break;
f0100719:	eb 25                	jmp    f0100740 <cga_putc+0x91>
	switch (c & 0xff) {
f010071b:	83 fa 0d             	cmp    $0xd,%edx
f010071e:	0f 85 a6 00 00 00    	jne    f01007ca <cga_putc+0x11b>
		crt_pos -= (crt_pos % CRT_COLS);
f0100724:	0f b7 05 28 82 24 f0 	movzwl 0xf0248228,%eax
f010072b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100731:	c1 e8 16             	shr    $0x16,%eax
f0100734:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100737:	c1 e0 04             	shl    $0x4,%eax
f010073a:	66 a3 28 82 24 f0    	mov    %ax,0xf0248228
	if (crt_pos >= CRT_SIZE) {
f0100740:	66 81 3d 28 82 24 f0 	cmpw   $0x7cf,0xf0248228
f0100747:	cf 07 
f0100749:	0f 87 9e 00 00 00    	ja     f01007ed <cga_putc+0x13e>
	outb(addr_6845, 14);
f010074f:	8b 3d 30 82 24 f0    	mov    0xf0248230,%edi
f0100755:	ba 0e 00 00 00       	mov    $0xe,%edx
f010075a:	89 f8                	mov    %edi,%eax
f010075c:	e8 ad fb ff ff       	call   f010030e <outb>
	outb(addr_6845 + 1, crt_pos >> 8);
f0100761:	0f b7 1d 28 82 24 f0 	movzwl 0xf0248228,%ebx
f0100768:	8d 77 01             	lea    0x1(%edi),%esi
f010076b:	0f b6 d7             	movzbl %bh,%edx
f010076e:	89 f0                	mov    %esi,%eax
f0100770:	e8 99 fb ff ff       	call   f010030e <outb>
	outb(addr_6845, 15);
f0100775:	ba 0f 00 00 00       	mov    $0xf,%edx
f010077a:	89 f8                	mov    %edi,%eax
f010077c:	e8 8d fb ff ff       	call   f010030e <outb>
	outb(addr_6845 + 1, crt_pos);
f0100781:	0f b6 d3             	movzbl %bl,%edx
f0100784:	89 f0                	mov    %esi,%eax
f0100786:	e8 83 fb ff ff       	call   f010030e <outb>
}
f010078b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010078e:	5b                   	pop    %ebx
f010078f:	5e                   	pop    %esi
f0100790:	5f                   	pop    %edi
f0100791:	5d                   	pop    %ebp
f0100792:	c3                   	ret    
		if (crt_pos > 0) {
f0100793:	0f b7 15 28 82 24 f0 	movzwl 0xf0248228,%edx
f010079a:	66 85 d2             	test   %dx,%dx
f010079d:	74 b0                	je     f010074f <cga_putc+0xa0>
			crt_pos--;
f010079f:	83 ea 01             	sub    $0x1,%edx
f01007a2:	66 89 15 28 82 24 f0 	mov    %dx,0xf0248228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01007a9:	0f b7 d2             	movzwl %dx,%edx
f01007ac:	b0 00                	mov    $0x0,%al
f01007ae:	83 c8 20             	or     $0x20,%eax
f01007b1:	8b 0d 2c 82 24 f0    	mov    0xf024822c,%ecx
f01007b7:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
f01007bb:	eb 83                	jmp    f0100740 <cga_putc+0x91>
		crt_pos += CRT_COLS;
f01007bd:	66 83 05 28 82 24 f0 	addw   $0x50,0xf0248228
f01007c4:	50 
f01007c5:	e9 5a ff ff ff       	jmp    f0100724 <cga_putc+0x75>
		crt_buf[crt_pos++] = c;		/* write the character */
f01007ca:	0f b7 15 28 82 24 f0 	movzwl 0xf0248228,%edx
f01007d1:	8d 4a 01             	lea    0x1(%edx),%ecx
f01007d4:	66 89 0d 28 82 24 f0 	mov    %cx,0xf0248228
f01007db:	0f b7 d2             	movzwl %dx,%edx
f01007de:	8b 0d 2c 82 24 f0    	mov    0xf024822c,%ecx
f01007e4:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
		break;
f01007e8:	e9 53 ff ff ff       	jmp    f0100740 <cga_putc+0x91>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01007ed:	a1 2c 82 24 f0       	mov    0xf024822c,%eax
f01007f2:	83 ec 04             	sub    $0x4,%esp
f01007f5:	68 00 0f 00 00       	push   $0xf00
f01007fa:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100800:	52                   	push   %edx
f0100801:	50                   	push   %eax
f0100802:	e8 02 50 00 00       	call   f0105809 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f0100807:	8b 15 2c 82 24 f0    	mov    0xf024822c,%edx
f010080d:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100813:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0100819:	83 c4 10             	add    $0x10,%esp
f010081c:	66 c7 00 20 07       	movw   $0x720,(%eax)
f0100821:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100824:	39 d0                	cmp    %edx,%eax
f0100826:	75 f4                	jne    f010081c <cga_putc+0x16d>
		crt_pos -= CRT_COLS;
f0100828:	66 83 2d 28 82 24 f0 	subw   $0x50,0xf0248228
f010082f:	50 
f0100830:	e9 1a ff ff ff       	jmp    f010074f <cga_putc+0xa0>

f0100835 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100835:	55                   	push   %ebp
f0100836:	89 e5                	mov    %esp,%ebp
f0100838:	53                   	push   %ebx
f0100839:	83 ec 04             	sub    $0x4,%esp
f010083c:	89 c3                	mov    %eax,%ebx
	serial_putc(c);
f010083e:	e8 31 fb ff ff       	call   f0100374 <serial_putc>
	lpt_putc(c);
f0100843:	89 d8                	mov    %ebx,%eax
f0100845:	e8 01 fc ff ff       	call   f010044b <lpt_putc>
	cga_putc(c);
f010084a:	89 d8                	mov    %ebx,%eax
f010084c:	e8 5e fe ff ff       	call   f01006af <cga_putc>
}
f0100851:	83 c4 04             	add    $0x4,%esp
f0100854:	5b                   	pop    %ebx
f0100855:	5d                   	pop    %ebp
f0100856:	c3                   	ret    

f0100857 <serial_intr>:
{
f0100857:	f3 0f 1e fb          	endbr32 
	if (serial_exists)
f010085b:	80 3d 34 82 24 f0 00 	cmpb   $0x0,0xf0248234
f0100862:	75 01                	jne    f0100865 <serial_intr+0xe>
f0100864:	c3                   	ret    
{
f0100865:	55                   	push   %ebp
f0100866:	89 e5                	mov    %esp,%ebp
f0100868:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010086b:	b8 46 03 10 f0       	mov    $0xf0100346,%eax
f0100870:	e8 d6 fc ff ff       	call   f010054b <cons_intr>
}
f0100875:	c9                   	leave  
f0100876:	c3                   	ret    

f0100877 <kbd_intr>:
{
f0100877:	f3 0f 1e fb          	endbr32 
f010087b:	55                   	push   %ebp
f010087c:	89 e5                	mov    %esp,%ebp
f010087e:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100881:	b8 8a 05 10 f0       	mov    $0xf010058a,%eax
f0100886:	e8 c0 fc ff ff       	call   f010054b <cons_intr>
}
f010088b:	c9                   	leave  
f010088c:	c3                   	ret    

f010088d <kbd_init>:
{
f010088d:	55                   	push   %ebp
f010088e:	89 e5                	mov    %esp,%ebp
f0100890:	83 ec 08             	sub    $0x8,%esp
	kbd_intr();
f0100893:	e8 df ff ff ff       	call   f0100877 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f0100898:	83 ec 0c             	sub    $0xc,%esp
f010089b:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f01008a2:	25 fd ff 00 00       	and    $0xfffd,%eax
f01008a7:	50                   	push   %eax
f01008a8:	e8 e1 2d 00 00       	call   f010368e <irq_setmask_8259A>
}
f01008ad:	83 c4 10             	add    $0x10,%esp
f01008b0:	c9                   	leave  
f01008b1:	c3                   	ret    

f01008b2 <cons_getc>:
{
f01008b2:	f3 0f 1e fb          	endbr32 
f01008b6:	55                   	push   %ebp
f01008b7:	89 e5                	mov    %esp,%ebp
f01008b9:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f01008bc:	e8 96 ff ff ff       	call   f0100857 <serial_intr>
	kbd_intr();
f01008c1:	e8 b1 ff ff ff       	call   f0100877 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01008c6:	a1 20 82 24 f0       	mov    0xf0248220,%eax
	return 0;
f01008cb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f01008d0:	3b 05 24 82 24 f0    	cmp    0xf0248224,%eax
f01008d6:	74 1c                	je     f01008f4 <cons_getc+0x42>
		c = cons.buf[cons.rpos++];
f01008d8:	8d 48 01             	lea    0x1(%eax),%ecx
f01008db:	0f b6 90 20 80 24 f0 	movzbl -0xfdb7fe0(%eax),%edx
			cons.rpos = 0;
f01008e2:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f01008e7:	b8 00 00 00 00       	mov    $0x0,%eax
f01008ec:	0f 45 c1             	cmovne %ecx,%eax
f01008ef:	a3 20 82 24 f0       	mov    %eax,0xf0248220
}
f01008f4:	89 d0                	mov    %edx,%eax
f01008f6:	c9                   	leave  
f01008f7:	c3                   	ret    

f01008f8 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01008f8:	f3 0f 1e fb          	endbr32 
f01008fc:	55                   	push   %ebp
f01008fd:	89 e5                	mov    %esp,%ebp
f01008ff:	83 ec 08             	sub    $0x8,%esp
	cga_init();
f0100902:	e8 a1 fb ff ff       	call   f01004a8 <cga_init>
	kbd_init();
f0100907:	e8 81 ff ff ff       	call   f010088d <kbd_init>
	serial_init();
f010090c:	e8 a2 fa ff ff       	call   f01003b3 <serial_init>

	if (!serial_exists)
f0100911:	80 3d 34 82 24 f0 00 	cmpb   $0x0,0xf0248234
f0100918:	74 02                	je     f010091c <cons_init+0x24>
		cprintf("Serial port does not exist!\n");
}
f010091a:	c9                   	leave  
f010091b:	c3                   	ret    
		cprintf("Serial port does not exist!\n");
f010091c:	83 ec 0c             	sub    $0xc,%esp
f010091f:	68 dd 65 10 f0       	push   $0xf01065dd
f0100924:	e8 40 2f 00 00       	call   f0103869 <cprintf>
f0100929:	83 c4 10             	add    $0x10,%esp
}
f010092c:	eb ec                	jmp    f010091a <cons_init+0x22>

f010092e <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f010092e:	f3 0f 1e fb          	endbr32 
f0100932:	55                   	push   %ebp
f0100933:	89 e5                	mov    %esp,%ebp
f0100935:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100938:	8b 45 08             	mov    0x8(%ebp),%eax
f010093b:	e8 f5 fe ff ff       	call   f0100835 <cons_putc>
}
f0100940:	c9                   	leave  
f0100941:	c3                   	ret    

f0100942 <getchar>:

int
getchar(void)
{
f0100942:	f3 0f 1e fb          	endbr32 
f0100946:	55                   	push   %ebp
f0100947:	89 e5                	mov    %esp,%ebp
f0100949:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f010094c:	e8 61 ff ff ff       	call   f01008b2 <cons_getc>
f0100951:	85 c0                	test   %eax,%eax
f0100953:	74 f7                	je     f010094c <getchar+0xa>
		/* do nothing */;
	return c;
}
f0100955:	c9                   	leave  
f0100956:	c3                   	ret    

f0100957 <iscons>:

int
iscons(int fdnum)
{
f0100957:	f3 0f 1e fb          	endbr32 
	// used by readline
	return 1;
}
f010095b:	b8 01 00 00 00       	mov    $0x1,%eax
f0100960:	c3                   	ret    

f0100961 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100961:	f3 0f 1e fb          	endbr32 
f0100965:	55                   	push   %ebp
f0100966:	89 e5                	mov    %esp,%ebp
f0100968:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010096b:	68 20 68 10 f0       	push   $0xf0106820
f0100970:	68 3e 68 10 f0       	push   $0xf010683e
f0100975:	68 43 68 10 f0       	push   $0xf0106843
f010097a:	e8 ea 2e 00 00       	call   f0103869 <cprintf>
f010097f:	83 c4 0c             	add    $0xc,%esp
f0100982:	68 ac 68 10 f0       	push   $0xf01068ac
f0100987:	68 4c 68 10 f0       	push   $0xf010684c
f010098c:	68 43 68 10 f0       	push   $0xf0106843
f0100991:	e8 d3 2e 00 00       	call   f0103869 <cprintf>
	return 0;
}
f0100996:	b8 00 00 00 00       	mov    $0x0,%eax
f010099b:	c9                   	leave  
f010099c:	c3                   	ret    

f010099d <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f010099d:	f3 0f 1e fb          	endbr32 
f01009a1:	55                   	push   %ebp
f01009a2:	89 e5                	mov    %esp,%ebp
f01009a4:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01009a7:	68 55 68 10 f0       	push   $0xf0106855
f01009ac:	e8 b8 2e 00 00       	call   f0103869 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01009b1:	83 c4 08             	add    $0x8,%esp
f01009b4:	68 0c 00 10 00       	push   $0x10000c
f01009b9:	68 d4 68 10 f0       	push   $0xf01068d4
f01009be:	e8 a6 2e 00 00       	call   f0103869 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01009c3:	83 c4 0c             	add    $0xc,%esp
f01009c6:	68 0c 00 10 00       	push   $0x10000c
f01009cb:	68 0c 00 10 f0       	push   $0xf010000c
f01009d0:	68 fc 68 10 f0       	push   $0xf01068fc
f01009d5:	e8 8f 2e 00 00       	call   f0103869 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01009da:	83 c4 0c             	add    $0xc,%esp
f01009dd:	68 fd 64 10 00       	push   $0x1064fd
f01009e2:	68 fd 64 10 f0       	push   $0xf01064fd
f01009e7:	68 20 69 10 f0       	push   $0xf0106920
f01009ec:	e8 78 2e 00 00       	call   f0103869 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01009f1:	83 c4 0c             	add    $0xc,%esp
f01009f4:	68 9c 73 24 00       	push   $0x24739c
f01009f9:	68 9c 73 24 f0       	push   $0xf024739c
f01009fe:	68 44 69 10 f0       	push   $0xf0106944
f0100a03:	e8 61 2e 00 00       	call   f0103869 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100a08:	83 c4 0c             	add    $0xc,%esp
f0100a0b:	68 08 a0 28 00       	push   $0x28a008
f0100a10:	68 08 a0 28 f0       	push   $0xf028a008
f0100a15:	68 68 69 10 f0       	push   $0xf0106968
f0100a1a:	e8 4a 2e 00 00       	call   f0103869 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100a1f:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100a22:	b8 08 a0 28 f0       	mov    $0xf028a008,%eax
f0100a27:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100a2c:	c1 f8 0a             	sar    $0xa,%eax
f0100a2f:	50                   	push   %eax
f0100a30:	68 8c 69 10 f0       	push   $0xf010698c
f0100a35:	e8 2f 2e 00 00       	call   f0103869 <cprintf>
	return 0;
}
f0100a3a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a3f:	c9                   	leave  
f0100a40:	c3                   	ret    

f0100a41 <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
f0100a41:	55                   	push   %ebp
f0100a42:	89 e5                	mov    %esp,%ebp
f0100a44:	57                   	push   %edi
f0100a45:	56                   	push   %esi
f0100a46:	53                   	push   %ebx
f0100a47:	83 ec 5c             	sub    $0x5c,%esp
f0100a4a:	89 c3                	mov    %eax,%ebx
f0100a4c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100a4f:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100a56:	be 00 00 00 00       	mov    $0x0,%esi
f0100a5b:	eb 5d                	jmp    f0100aba <runcmd+0x79>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100a5d:	83 ec 08             	sub    $0x8,%esp
f0100a60:	0f be c0             	movsbl %al,%eax
f0100a63:	50                   	push   %eax
f0100a64:	68 6e 68 10 f0       	push   $0xf010686e
f0100a69:	e8 08 4d 00 00       	call   f0105776 <strchr>
f0100a6e:	83 c4 10             	add    $0x10,%esp
f0100a71:	85 c0                	test   %eax,%eax
f0100a73:	74 0a                	je     f0100a7f <runcmd+0x3e>
			*buf++ = 0;
f0100a75:	c6 03 00             	movb   $0x0,(%ebx)
f0100a78:	89 f7                	mov    %esi,%edi
f0100a7a:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100a7d:	eb 39                	jmp    f0100ab8 <runcmd+0x77>
		if (*buf == 0)
f0100a7f:	0f b6 03             	movzbl (%ebx),%eax
f0100a82:	84 c0                	test   %al,%al
f0100a84:	74 3b                	je     f0100ac1 <runcmd+0x80>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100a86:	83 fe 0f             	cmp    $0xf,%esi
f0100a89:	0f 84 86 00 00 00    	je     f0100b15 <runcmd+0xd4>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
f0100a8f:	8d 7e 01             	lea    0x1(%esi),%edi
f0100a92:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a96:	83 ec 08             	sub    $0x8,%esp
f0100a99:	0f be c0             	movsbl %al,%eax
f0100a9c:	50                   	push   %eax
f0100a9d:	68 6e 68 10 f0       	push   $0xf010686e
f0100aa2:	e8 cf 4c 00 00       	call   f0105776 <strchr>
f0100aa7:	83 c4 10             	add    $0x10,%esp
f0100aaa:	85 c0                	test   %eax,%eax
f0100aac:	75 0a                	jne    f0100ab8 <runcmd+0x77>
			buf++;
f0100aae:	83 c3 01             	add    $0x1,%ebx
		while (*buf && !strchr(WHITESPACE, *buf))
f0100ab1:	0f b6 03             	movzbl (%ebx),%eax
f0100ab4:	84 c0                	test   %al,%al
f0100ab6:	75 de                	jne    f0100a96 <runcmd+0x55>
			*buf++ = 0;
f0100ab8:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100aba:	0f b6 03             	movzbl (%ebx),%eax
f0100abd:	84 c0                	test   %al,%al
f0100abf:	75 9c                	jne    f0100a5d <runcmd+0x1c>
	}
	argv[argc] = 0;
f0100ac1:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100ac8:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100ac9:	85 f6                	test   %esi,%esi
f0100acb:	74 5f                	je     f0100b2c <runcmd+0xeb>
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100acd:	83 ec 08             	sub    $0x8,%esp
f0100ad0:	68 3e 68 10 f0       	push   $0xf010683e
f0100ad5:	ff 75 a8             	pushl  -0x58(%ebp)
f0100ad8:	e8 33 4c 00 00       	call   f0105710 <strcmp>
f0100add:	83 c4 10             	add    $0x10,%esp
f0100ae0:	85 c0                	test   %eax,%eax
f0100ae2:	74 57                	je     f0100b3b <runcmd+0xfa>
f0100ae4:	83 ec 08             	sub    $0x8,%esp
f0100ae7:	68 4c 68 10 f0       	push   $0xf010684c
f0100aec:	ff 75 a8             	pushl  -0x58(%ebp)
f0100aef:	e8 1c 4c 00 00       	call   f0105710 <strcmp>
f0100af4:	83 c4 10             	add    $0x10,%esp
f0100af7:	85 c0                	test   %eax,%eax
f0100af9:	74 3b                	je     f0100b36 <runcmd+0xf5>
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100afb:	83 ec 08             	sub    $0x8,%esp
f0100afe:	ff 75 a8             	pushl  -0x58(%ebp)
f0100b01:	68 90 68 10 f0       	push   $0xf0106890
f0100b06:	e8 5e 2d 00 00       	call   f0103869 <cprintf>
	return 0;
f0100b0b:	83 c4 10             	add    $0x10,%esp
f0100b0e:	be 00 00 00 00       	mov    $0x0,%esi
f0100b13:	eb 17                	jmp    f0100b2c <runcmd+0xeb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100b15:	83 ec 08             	sub    $0x8,%esp
f0100b18:	6a 10                	push   $0x10
f0100b1a:	68 73 68 10 f0       	push   $0xf0106873
f0100b1f:	e8 45 2d 00 00       	call   f0103869 <cprintf>
			return 0;
f0100b24:	83 c4 10             	add    $0x10,%esp
f0100b27:	be 00 00 00 00       	mov    $0x0,%esi
}
f0100b2c:	89 f0                	mov    %esi,%eax
f0100b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b31:	5b                   	pop    %ebx
f0100b32:	5e                   	pop    %esi
f0100b33:	5f                   	pop    %edi
f0100b34:	5d                   	pop    %ebp
f0100b35:	c3                   	ret    
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100b36:	b8 01 00 00 00       	mov    $0x1,%eax
			return commands[i].func(argc, argv, tf);
f0100b3b:	83 ec 04             	sub    $0x4,%esp
f0100b3e:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100b41:	ff 75 a4             	pushl  -0x5c(%ebp)
f0100b44:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100b47:	52                   	push   %edx
f0100b48:	56                   	push   %esi
f0100b49:	ff 14 85 0c 6a 10 f0 	call   *-0xfef95f4(,%eax,4)
f0100b50:	89 c6                	mov    %eax,%esi
f0100b52:	83 c4 10             	add    $0x10,%esp
f0100b55:	eb d5                	jmp    f0100b2c <runcmd+0xeb>

f0100b57 <mon_backtrace>:
{
f0100b57:	f3 0f 1e fb          	endbr32 
}
f0100b5b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b60:	c3                   	ret    

f0100b61 <monitor>:

void
monitor(struct Trapframe *tf)
{
f0100b61:	f3 0f 1e fb          	endbr32 
f0100b65:	55                   	push   %ebp
f0100b66:	89 e5                	mov    %esp,%ebp
f0100b68:	53                   	push   %ebx
f0100b69:	83 ec 10             	sub    $0x10,%esp
f0100b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100b6f:	68 b8 69 10 f0       	push   $0xf01069b8
f0100b74:	e8 f0 2c 00 00       	call   f0103869 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100b79:	c7 04 24 dc 69 10 f0 	movl   $0xf01069dc,(%esp)
f0100b80:	e8 e4 2c 00 00       	call   f0103869 <cprintf>

	if (tf != NULL)
f0100b85:	83 c4 10             	add    $0x10,%esp
f0100b88:	85 db                	test   %ebx,%ebx
f0100b8a:	74 0c                	je     f0100b98 <monitor+0x37>
		print_trapframe(tf);
f0100b8c:	83 ec 0c             	sub    $0xc,%esp
f0100b8f:	53                   	push   %ebx
f0100b90:	e8 f2 31 00 00       	call   f0103d87 <print_trapframe>
f0100b95:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100b98:	83 ec 0c             	sub    $0xc,%esp
f0100b9b:	68 a6 68 10 f0       	push   $0xf01068a6
f0100ba0:	e8 83 49 00 00       	call   f0105528 <readline>
		if (buf != NULL)
f0100ba5:	83 c4 10             	add    $0x10,%esp
f0100ba8:	85 c0                	test   %eax,%eax
f0100baa:	74 ec                	je     f0100b98 <monitor+0x37>
			if (runcmd(buf, tf) < 0)
f0100bac:	89 da                	mov    %ebx,%edx
f0100bae:	e8 8e fe ff ff       	call   f0100a41 <runcmd>
f0100bb3:	85 c0                	test   %eax,%eax
f0100bb5:	79 e1                	jns    f0100b98 <monitor+0x37>
				break;
	}
}
f0100bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100bba:	c9                   	leave  
f0100bbb:	c3                   	ret    

f0100bbc <invlpg>:
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0100bbc:	0f 01 38             	invlpg (%eax)
}
f0100bbf:	c3                   	ret    

f0100bc0 <lcr0>:
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0100bc0:	0f 22 c0             	mov    %eax,%cr0
}
f0100bc3:	c3                   	ret    

f0100bc4 <rcr0>:
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0100bc4:	0f 20 c0             	mov    %cr0,%eax
}
f0100bc7:	c3                   	ret    

f0100bc8 <lcr3>:
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100bc8:	0f 22 d8             	mov    %eax,%cr3
}
f0100bcb:	c3                   	ret    

f0100bcc <page2pa>:
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100bcc:	2b 05 90 8e 24 f0    	sub    0xf0248e90,%eax
f0100bd2:	c1 f8 03             	sar    $0x3,%eax
f0100bd5:	c1 e0 0c             	shl    $0xc,%eax
}
f0100bd8:	c3                   	ret    

f0100bd9 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100bd9:	55                   	push   %ebp
f0100bda:	89 e5                	mov    %esp,%ebp
f0100bdc:	56                   	push   %esi
f0100bdd:	53                   	push   %ebx
f0100bde:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100be0:	83 ec 0c             	sub    $0xc,%esp
f0100be3:	50                   	push   %eax
f0100be4:	e8 4e 2a 00 00       	call   f0103637 <mc146818_read>
f0100be9:	89 c6                	mov    %eax,%esi
f0100beb:	83 c3 01             	add    $0x1,%ebx
f0100bee:	89 1c 24             	mov    %ebx,(%esp)
f0100bf1:	e8 41 2a 00 00       	call   f0103637 <mc146818_read>
f0100bf6:	c1 e0 08             	shl    $0x8,%eax
f0100bf9:	09 f0                	or     %esi,%eax
}
f0100bfb:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100bfe:	5b                   	pop    %ebx
f0100bff:	5e                   	pop    %esi
f0100c00:	5d                   	pop    %ebp
f0100c01:	c3                   	ret    

f0100c02 <i386_detect_memory>:

static void
i386_detect_memory(void)
{
f0100c02:	55                   	push   %ebp
f0100c03:	89 e5                	mov    %esp,%ebp
f0100c05:	56                   	push   %esi
f0100c06:	53                   	push   %ebx
	size_t basemem, extmem, ext16mem, totalmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	basemem = nvram_read(NVRAM_BASELO);
f0100c07:	b8 15 00 00 00       	mov    $0x15,%eax
f0100c0c:	e8 c8 ff ff ff       	call   f0100bd9 <nvram_read>
f0100c11:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0100c13:	b8 17 00 00 00       	mov    $0x17,%eax
f0100c18:	e8 bc ff ff ff       	call   f0100bd9 <nvram_read>
f0100c1d:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0100c1f:	b8 34 00 00 00       	mov    $0x34,%eax
f0100c24:	e8 b0 ff ff ff       	call   f0100bd9 <nvram_read>

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (ext16mem)
f0100c29:	c1 e0 06             	shl    $0x6,%eax
f0100c2c:	74 2b                	je     f0100c59 <i386_detect_memory+0x57>
		totalmem = 16 * 1024 + ext16mem;
f0100c2e:	05 00 40 00 00       	add    $0x4000,%eax
	else if (extmem)
		totalmem = 1 * 1024 + extmem;
	else
		totalmem = basemem;

	npages = totalmem / (PGSIZE / 1024);
f0100c33:	89 c2                	mov    %eax,%edx
f0100c35:	c1 ea 02             	shr    $0x2,%edx
f0100c38:	89 15 88 8e 24 f0    	mov    %edx,0xf0248e88
	npages_basemem = basemem / (PGSIZE / 1024);

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0100c3e:	89 c2                	mov    %eax,%edx
f0100c40:	29 da                	sub    %ebx,%edx
f0100c42:	52                   	push   %edx
f0100c43:	53                   	push   %ebx
f0100c44:	50                   	push   %eax
f0100c45:	68 1c 6a 10 f0       	push   $0xf0106a1c
f0100c4a:	e8 1a 2c 00 00       	call   f0103869 <cprintf>
	        totalmem,
	        basemem,
	        totalmem - basemem);
}
f0100c4f:	83 c4 10             	add    $0x10,%esp
f0100c52:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100c55:	5b                   	pop    %ebx
f0100c56:	5e                   	pop    %esi
f0100c57:	5d                   	pop    %ebp
f0100c58:	c3                   	ret    
		totalmem = 1 * 1024 + extmem;
f0100c59:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0100c5f:	85 f6                	test   %esi,%esi
f0100c61:	0f 44 c3             	cmove  %ebx,%eax
f0100c64:	eb cd                	jmp    f0100c33 <i386_detect_memory+0x31>

f0100c66 <_kaddr>:
{
f0100c66:	55                   	push   %ebp
f0100c67:	89 e5                	mov    %esp,%ebp
f0100c69:	53                   	push   %ebx
f0100c6a:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0100c6d:	89 cb                	mov    %ecx,%ebx
f0100c6f:	c1 eb 0c             	shr    $0xc,%ebx
f0100c72:	3b 1d 88 8e 24 f0    	cmp    0xf0248e88,%ebx
f0100c78:	73 0b                	jae    f0100c85 <_kaddr+0x1f>
	return (void *)(pa + KERNBASE);
f0100c7a:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0100c80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100c83:	c9                   	leave  
f0100c84:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100c85:	51                   	push   %ecx
f0100c86:	68 2c 65 10 f0       	push   $0xf010652c
f0100c8b:	52                   	push   %edx
f0100c8c:	50                   	push   %eax
f0100c8d:	e8 d8 f3 ff ff       	call   f010006a <_panic>

f0100c92 <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
f0100c92:	55                   	push   %ebp
f0100c93:	89 e5                	mov    %esp,%ebp
f0100c95:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
f0100c98:	e8 2f ff ff ff       	call   f0100bcc <page2pa>
f0100c9d:	89 c1                	mov    %eax,%ecx
f0100c9f:	ba 58 00 00 00       	mov    $0x58,%edx
f0100ca4:	b8 11 74 10 f0       	mov    $0xf0107411,%eax
f0100ca9:	e8 b8 ff ff ff       	call   f0100c66 <_kaddr>
}
f0100cae:	c9                   	leave  
f0100caf:	c3                   	ret    

f0100cb0 <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100cb0:	55                   	push   %ebp
f0100cb1:	89 e5                	mov    %esp,%ebp
f0100cb3:	53                   	push   %ebx
f0100cb4:	83 ec 04             	sub    $0x4,%esp
f0100cb7:	89 d3                	mov    %edx,%ebx
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100cb9:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P))
f0100cbc:	8b 0c 90             	mov    (%eax,%edx,4),%ecx
		return ~0;
f0100cbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if (!(*pgdir & PTE_P))
f0100cc4:	f6 c1 01             	test   $0x1,%cl
f0100cc7:	74 14                	je     f0100cdd <check_va2pa+0x2d>
	if (*pgdir & PTE_PS)
f0100cc9:	f6 c1 80             	test   $0x80,%cl
f0100ccc:	74 15                	je     f0100ce3 <check_va2pa+0x33>
		return (physaddr_t) PGADDR(PDX(*pgdir), PTX(va), PGOFF(va));
f0100cce:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
f0100cd4:	89 d8                	mov    %ebx,%eax
f0100cd6:	25 ff ff 3f 00       	and    $0x3fffff,%eax
f0100cdb:	09 c8                	or     %ecx,%eax
	p = (pte_t *) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
}
f0100cdd:	83 c4 04             	add    $0x4,%esp
f0100ce0:	5b                   	pop    %ebx
f0100ce1:	5d                   	pop    %ebp
f0100ce2:	c3                   	ret    
	p = (pte_t *) KADDR(PTE_ADDR(*pgdir));
f0100ce3:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0100ce9:	ba 97 03 00 00       	mov    $0x397,%edx
f0100cee:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0100cf3:	e8 6e ff ff ff       	call   f0100c66 <_kaddr>
	if (!(p[PTX(va)] & PTE_P))
f0100cf8:	c1 eb 0c             	shr    $0xc,%ebx
f0100cfb:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0100d01:	8b 14 98             	mov    (%eax,%ebx,4),%edx
	return PTE_ADDR(p[PTX(va)]);
f0100d04:	89 d0                	mov    %edx,%eax
f0100d06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d0b:	f6 c2 01             	test   $0x1,%dl
f0100d0e:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0100d13:	0f 44 c1             	cmove  %ecx,%eax
f0100d16:	eb c5                	jmp    f0100cdd <check_va2pa+0x2d>

f0100d18 <_paddr>:
	if ((uint32_t)kva < KERNBASE)
f0100d18:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0100d1e:	76 07                	jbe    f0100d27 <_paddr+0xf>
	return (physaddr_t)kva - KERNBASE;
f0100d20:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0100d26:	c3                   	ret    
{
f0100d27:	55                   	push   %ebp
f0100d28:	89 e5                	mov    %esp,%ebp
f0100d2a:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100d2d:	51                   	push   %ecx
f0100d2e:	68 50 65 10 f0       	push   $0xf0106550
f0100d33:	52                   	push   %edx
f0100d34:	50                   	push   %eax
f0100d35:	e8 30 f3 ff ff       	call   f010006a <_panic>

f0100d3a <boot_alloc>:
{
f0100d3a:	55                   	push   %ebp
f0100d3b:	89 e5                	mov    %esp,%ebp
f0100d3d:	53                   	push   %ebx
f0100d3e:	83 ec 04             	sub    $0x4,%esp
	if (!nextfree) {
f0100d41:	83 3d 38 82 24 f0 00 	cmpl   $0x0,0xf0248238
f0100d48:	74 4b                	je     f0100d95 <boot_alloc+0x5b>
	uint32_t last = PADDR(nextfree + n);
f0100d4a:	8b 1d 38 82 24 f0    	mov    0xf0248238,%ebx
f0100d50:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
f0100d53:	ba 6d 00 00 00       	mov    $0x6d,%edx
f0100d58:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0100d5d:	e8 b6 ff ff ff       	call   f0100d18 <_paddr>
f0100d62:	89 c1                	mov    %eax,%ecx
	if (last >= PGSIZE * npages) {
f0100d64:	a1 88 8e 24 f0       	mov    0xf0248e88,%eax
f0100d69:	c1 e0 0c             	shl    $0xc,%eax
f0100d6c:	39 c8                	cmp    %ecx,%eax
f0100d6e:	76 38                	jbe    f0100da8 <boot_alloc+0x6e>
	nextfree = ROUNDUP(KADDR(last), PGSIZE);
f0100d70:	ba 73 00 00 00       	mov    $0x73,%edx
f0100d75:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0100d7a:	e8 e7 fe ff ff       	call   f0100c66 <_kaddr>
f0100d7f:	05 ff 0f 00 00       	add    $0xfff,%eax
f0100d84:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d89:	a3 38 82 24 f0       	mov    %eax,0xf0248238
}
f0100d8e:	89 d8                	mov    %ebx,%eax
f0100d90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100d93:	c9                   	leave  
f0100d94:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100d95:	ba 07 b0 28 f0       	mov    $0xf028b007,%edx
f0100d9a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100da0:	89 15 38 82 24 f0    	mov    %edx,0xf0248238
f0100da6:	eb a2                	jmp    f0100d4a <boot_alloc+0x10>
		panic("boot_alloc: Not enough memory\n");
f0100da8:	83 ec 04             	sub    $0x4,%esp
f0100dab:	68 58 6a 10 f0       	push   $0xf0106a58
f0100db0:	6a 6f                	push   $0x6f
f0100db2:	68 1f 74 10 f0       	push   $0xf010741f
f0100db7:	e8 ae f2 ff ff       	call   f010006a <_panic>

f0100dbc <check_kern_pgdir>:
{
f0100dbc:	55                   	push   %ebp
f0100dbd:	89 e5                	mov    %esp,%ebp
f0100dbf:	57                   	push   %edi
f0100dc0:	56                   	push   %esi
f0100dc1:	53                   	push   %ebx
f0100dc2:	83 ec 1c             	sub    $0x1c,%esp
	pgdir = kern_pgdir;
f0100dc5:	8b 3d 8c 8e 24 f0    	mov    0xf0248e8c,%edi
	n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
f0100dcb:	a1 88 8e 24 f0       	mov    0xf0248e88,%eax
f0100dd0:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100dd3:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0100dda:	25 00 f0 ff ff       	and    $0xfffff000,%eax
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0100ddf:	8b 0d 90 8e 24 f0    	mov    0xf0248e90,%ecx
f0100de5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f0100de8:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100ded:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0100df0:	89 c7                	mov    %eax,%edi
f0100df2:	39 fb                	cmp    %edi,%ebx
f0100df4:	73 49                	jae    f0100e3f <check_kern_pgdir+0x83>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0100df6:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0100dfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100dff:	e8 ac fe ff ff       	call   f0100cb0 <check_va2pa>
f0100e04:	89 c6                	mov    %eax,%esi
f0100e06:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100e09:	ba 53 03 00 00       	mov    $0x353,%edx
f0100e0e:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0100e13:	e8 00 ff ff ff       	call   f0100d18 <_paddr>
f0100e18:	01 d8                	add    %ebx,%eax
f0100e1a:	39 c6                	cmp    %eax,%esi
f0100e1c:	75 08                	jne    f0100e26 <check_kern_pgdir+0x6a>
	for (i = 0; i < n; i += PGSIZE)
f0100e1e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100e24:	eb cc                	jmp    f0100df2 <check_kern_pgdir+0x36>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0100e26:	68 78 6a 10 f0       	push   $0xf0106a78
f0100e2b:	68 2b 74 10 f0       	push   $0xf010742b
f0100e30:	68 53 03 00 00       	push   $0x353
f0100e35:	68 1f 74 10 f0       	push   $0xf010741f
f0100e3a:	e8 2b f2 ff ff       	call   f010006a <_panic>
f0100e3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0100e42:	a1 44 82 24 f0       	mov    0xf0248244,%eax
f0100e47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f0100e4a:	bb 00 00 00 00       	mov    $0x0,%ebx
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0100e4f:	8d 93 00 00 c0 ee    	lea    -0x11400000(%ebx),%edx
f0100e55:	89 f8                	mov    %edi,%eax
f0100e57:	e8 54 fe ff ff       	call   f0100cb0 <check_va2pa>
f0100e5c:	89 c6                	mov    %eax,%esi
f0100e5e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0100e61:	ba 58 03 00 00       	mov    $0x358,%edx
f0100e66:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0100e6b:	e8 a8 fe ff ff       	call   f0100d18 <_paddr>
f0100e70:	01 d8                	add    %ebx,%eax
f0100e72:	39 c6                	cmp    %eax,%esi
f0100e74:	75 36                	jne    f0100eac <check_kern_pgdir+0xf0>
	for (i = 0; i < n; i += PGSIZE)
f0100e76:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100e7c:	81 fb 00 f0 01 00    	cmp    $0x1f000,%ebx
f0100e82:	75 cb                	jne    f0100e4f <check_kern_pgdir+0x93>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0100e84:	8b 75 dc             	mov    -0x24(%ebp),%esi
f0100e87:	c1 e6 0c             	shl    $0xc,%esi
f0100e8a:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100e8f:	39 de                	cmp    %ebx,%esi
f0100e91:	76 4b                	jbe    f0100ede <check_kern_pgdir+0x122>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0100e93:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0100e99:	89 f8                	mov    %edi,%eax
f0100e9b:	e8 10 fe ff ff       	call   f0100cb0 <check_va2pa>
f0100ea0:	39 d8                	cmp    %ebx,%eax
f0100ea2:	75 21                	jne    f0100ec5 <check_kern_pgdir+0x109>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0100ea4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100eaa:	eb e3                	jmp    f0100e8f <check_kern_pgdir+0xd3>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0100eac:	68 ac 6a 10 f0       	push   $0xf0106aac
f0100eb1:	68 2b 74 10 f0       	push   $0xf010742b
f0100eb6:	68 58 03 00 00       	push   $0x358
f0100ebb:	68 1f 74 10 f0       	push   $0xf010741f
f0100ec0:	e8 a5 f1 ff ff       	call   f010006a <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0100ec5:	68 e0 6a 10 f0       	push   $0xf0106ae0
f0100eca:	68 2b 74 10 f0       	push   $0xf010742b
f0100ecf:	68 5c 03 00 00       	push   $0x35c
f0100ed4:	68 1f 74 10 f0       	push   $0xf010741f
f0100ed9:	e8 8c f1 ff ff       	call   f010006a <_panic>
f0100ede:	c7 45 dc 00 a0 24 f0 	movl   $0xf024a000,-0x24(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0100ee5:	b8 00 80 ff ef       	mov    $0xefff8000,%eax
f0100eea:	89 7d e4             	mov    %edi,-0x1c(%ebp)
f0100eed:	89 c7                	mov    %eax,%edi
f0100eef:	8d b7 00 80 ff ff    	lea    -0x8000(%edi),%esi
			assert(check_va2pa(pgdir, base + KSTKGAP + i) ==
f0100ef5:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100ef8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0100efb:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100f00:	89 75 d8             	mov    %esi,-0x28(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i) ==
f0100f03:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
f0100f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100f09:	e8 a2 fd ff ff       	call   f0100cb0 <check_va2pa>
f0100f0e:	89 c6                	mov    %eax,%esi
f0100f10:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100f13:	ba 64 03 00 00       	mov    $0x364,%edx
f0100f18:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0100f1d:	e8 f6 fd ff ff       	call   f0100d18 <_paddr>
f0100f22:	01 d8                	add    %ebx,%eax
f0100f24:	39 c6                	cmp    %eax,%esi
f0100f26:	75 4d                	jne    f0100f75 <check_kern_pgdir+0x1b9>
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0100f28:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100f2e:	81 fb 00 80 00 00    	cmp    $0x8000,%ebx
f0100f34:	75 cd                	jne    f0100f03 <check_kern_pgdir+0x147>
f0100f36:	8b 75 d8             	mov    -0x28(%ebp),%esi
f0100f39:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0100f3c:	89 f2                	mov    %esi,%edx
f0100f3e:	89 d8                	mov    %ebx,%eax
f0100f40:	e8 6b fd ff ff       	call   f0100cb0 <check_va2pa>
f0100f45:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100f48:	75 44                	jne    f0100f8e <check_kern_pgdir+0x1d2>
f0100f4a:	81 c6 00 10 00 00    	add    $0x1000,%esi
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0100f50:	39 fe                	cmp    %edi,%esi
f0100f52:	75 e8                	jne    f0100f3c <check_kern_pgdir+0x180>
f0100f54:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0100f57:	81 ef 00 00 01 00    	sub    $0x10000,%edi
f0100f5d:	81 45 dc 00 80 00 00 	addl   $0x8000,-0x24(%ebp)
	for (n = 0; n < NCPU; n++) {
f0100f64:	81 ff 00 80 f7 ef    	cmp    $0xeff78000,%edi
f0100f6a:	75 83                	jne    f0100eef <check_kern_pgdir+0x133>
f0100f6c:	89 df                	mov    %ebx,%edi
	for (i = 0; i < NPDENTRIES; i++) {
f0100f6e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f73:	eb 68                	jmp    f0100fdd <check_kern_pgdir+0x221>
			assert(check_va2pa(pgdir, base + KSTKGAP + i) ==
f0100f75:	68 08 6b 10 f0       	push   $0xf0106b08
f0100f7a:	68 2b 74 10 f0       	push   $0xf010742b
f0100f7f:	68 63 03 00 00       	push   $0x363
f0100f84:	68 1f 74 10 f0       	push   $0xf010741f
f0100f89:	e8 dc f0 ff ff       	call   f010006a <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0100f8e:	68 50 6b 10 f0       	push   $0xf0106b50
f0100f93:	68 2b 74 10 f0       	push   $0xf010742b
f0100f98:	68 66 03 00 00       	push   $0x366
f0100f9d:	68 1f 74 10 f0       	push   $0xf010741f
f0100fa2:	e8 c3 f0 ff ff       	call   f010006a <_panic>
			assert(pgdir[i] & PTE_P);
f0100fa7:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0100fab:	75 48                	jne    f0100ff5 <check_kern_pgdir+0x239>
f0100fad:	68 40 74 10 f0       	push   $0xf0107440
f0100fb2:	68 2b 74 10 f0       	push   $0xf010742b
f0100fb7:	68 71 03 00 00       	push   $0x371
f0100fbc:	68 1f 74 10 f0       	push   $0xf010741f
f0100fc1:	e8 a4 f0 ff ff       	call   f010006a <_panic>
				assert(pgdir[i] & PTE_P);
f0100fc6:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0100fc9:	f6 c2 01             	test   $0x1,%dl
f0100fcc:	74 2c                	je     f0100ffa <check_kern_pgdir+0x23e>
				assert(pgdir[i] & PTE_W);
f0100fce:	f6 c2 02             	test   $0x2,%dl
f0100fd1:	74 40                	je     f0101013 <check_kern_pgdir+0x257>
	for (i = 0; i < NPDENTRIES; i++) {
f0100fd3:	83 c0 01             	add    $0x1,%eax
f0100fd6:	3d 00 04 00 00       	cmp    $0x400,%eax
f0100fdb:	74 68                	je     f0101045 <check_kern_pgdir+0x289>
		switch (i) {
f0100fdd:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0100fe3:	83 fa 04             	cmp    $0x4,%edx
f0100fe6:	76 bf                	jbe    f0100fa7 <check_kern_pgdir+0x1eb>
			if (i >= PDX(KERNBASE)) {
f0100fe8:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0100fed:	77 d7                	ja     f0100fc6 <check_kern_pgdir+0x20a>
				assert(pgdir[i] == 0);
f0100fef:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0100ff3:	75 37                	jne    f010102c <check_kern_pgdir+0x270>
	for (i = 0; i < NPDENTRIES; i++) {
f0100ff5:	83 c0 01             	add    $0x1,%eax
f0100ff8:	eb e3                	jmp    f0100fdd <check_kern_pgdir+0x221>
				assert(pgdir[i] & PTE_P);
f0100ffa:	68 40 74 10 f0       	push   $0xf0107440
f0100fff:	68 2b 74 10 f0       	push   $0xf010742b
f0101004:	68 75 03 00 00       	push   $0x375
f0101009:	68 1f 74 10 f0       	push   $0xf010741f
f010100e:	e8 57 f0 ff ff       	call   f010006a <_panic>
				assert(pgdir[i] & PTE_W);
f0101013:	68 51 74 10 f0       	push   $0xf0107451
f0101018:	68 2b 74 10 f0       	push   $0xf010742b
f010101d:	68 76 03 00 00       	push   $0x376
f0101022:	68 1f 74 10 f0       	push   $0xf010741f
f0101027:	e8 3e f0 ff ff       	call   f010006a <_panic>
				assert(pgdir[i] == 0);
f010102c:	68 62 74 10 f0       	push   $0xf0107462
f0101031:	68 2b 74 10 f0       	push   $0xf010742b
f0101036:	68 78 03 00 00       	push   $0x378
f010103b:	68 1f 74 10 f0       	push   $0xf010741f
f0101040:	e8 25 f0 ff ff       	call   f010006a <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0101045:	83 ec 0c             	sub    $0xc,%esp
f0101048:	68 74 6b 10 f0       	push   $0xf0106b74
f010104d:	e8 17 28 00 00       	call   f0103869 <cprintf>
}
f0101052:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101055:	5b                   	pop    %ebx
f0101056:	5e                   	pop    %esi
f0101057:	5f                   	pop    %edi
f0101058:	5d                   	pop    %ebp
f0101059:	c3                   	ret    

f010105a <check_page_free_list>:
{
f010105a:	55                   	push   %ebp
f010105b:	89 e5                	mov    %esp,%ebp
f010105d:	57                   	push   %edi
f010105e:	56                   	push   %esi
f010105f:	53                   	push   %ebx
f0101060:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101063:	84 c0                	test   %al,%al
f0101065:	0f 85 3f 02 00 00    	jne    f01012aa <check_page_free_list+0x250>
	if (!page_free_list)
f010106b:	83 3d 40 82 24 f0 00 	cmpl   $0x0,0xf0248240
f0101072:	74 0a                	je     f010107e <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101074:	be 00 04 00 00       	mov    $0x400,%esi
f0101079:	e9 84 02 00 00       	jmp    f0101302 <check_page_free_list+0x2a8>
		panic("'page_free_list' is a null pointer!");
f010107e:	83 ec 04             	sub    $0x4,%esp
f0101081:	68 94 6b 10 f0       	push   $0xf0106b94
f0101086:	68 be 02 00 00       	push   $0x2be
f010108b:	68 1f 74 10 f0       	push   $0xf010741f
f0101090:	e8 d5 ef ff ff       	call   f010006a <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101095:	8b 1b                	mov    (%ebx),%ebx
f0101097:	85 db                	test   %ebx,%ebx
f0101099:	74 2d                	je     f01010c8 <check_page_free_list+0x6e>
		if (PDX(page2pa(pp)) < pdx_limit)
f010109b:	89 d8                	mov    %ebx,%eax
f010109d:	e8 2a fb ff ff       	call   f0100bcc <page2pa>
f01010a2:	c1 e8 16             	shr    $0x16,%eax
f01010a5:	39 f0                	cmp    %esi,%eax
f01010a7:	73 ec                	jae    f0101095 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f01010a9:	89 d8                	mov    %ebx,%eax
f01010ab:	e8 e2 fb ff ff       	call   f0100c92 <page2kva>
f01010b0:	83 ec 04             	sub    $0x4,%esp
f01010b3:	68 80 00 00 00       	push   $0x80
f01010b8:	68 97 00 00 00       	push   $0x97
f01010bd:	50                   	push   %eax
f01010be:	e8 f8 46 00 00       	call   f01057bb <memset>
f01010c3:	83 c4 10             	add    $0x10,%esp
f01010c6:	eb cd                	jmp    f0101095 <check_page_free_list+0x3b>
	first_free_page = (char *) boot_alloc(0);
f01010c8:	b8 00 00 00 00       	mov    $0x0,%eax
f01010cd:	e8 68 fc ff ff       	call   f0100d3a <boot_alloc>
f01010d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01010d5:	8b 1d 40 82 24 f0    	mov    0xf0248240,%ebx
		assert(pp >= pages);
f01010db:	8b 35 90 8e 24 f0    	mov    0xf0248e90,%esi
		assert(pp < pages + npages);
f01010e1:	a1 88 8e 24 f0       	mov    0xf0248e88,%eax
f01010e6:	8d 3c c6             	lea    (%esi,%eax,8),%edi
	int nfree_basemem = 0, nfree_extmem = 0;
f01010e9:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
f01010f0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01010f7:	e9 e0 00 00 00       	jmp    f01011dc <check_page_free_list+0x182>
		assert(pp >= pages);
f01010fc:	68 70 74 10 f0       	push   $0xf0107470
f0101101:	68 2b 74 10 f0       	push   $0xf010742b
f0101106:	68 d8 02 00 00       	push   $0x2d8
f010110b:	68 1f 74 10 f0       	push   $0xf010741f
f0101110:	e8 55 ef ff ff       	call   f010006a <_panic>
		assert(pp < pages + npages);
f0101115:	68 7c 74 10 f0       	push   $0xf010747c
f010111a:	68 2b 74 10 f0       	push   $0xf010742b
f010111f:	68 d9 02 00 00       	push   $0x2d9
f0101124:	68 1f 74 10 f0       	push   $0xf010741f
f0101129:	e8 3c ef ff ff       	call   f010006a <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f010112e:	68 b8 6b 10 f0       	push   $0xf0106bb8
f0101133:	68 2b 74 10 f0       	push   $0xf010742b
f0101138:	68 da 02 00 00       	push   $0x2da
f010113d:	68 1f 74 10 f0       	push   $0xf010741f
f0101142:	e8 23 ef ff ff       	call   f010006a <_panic>
		assert(page2pa(pp) != 0);
f0101147:	68 90 74 10 f0       	push   $0xf0107490
f010114c:	68 2b 74 10 f0       	push   $0xf010742b
f0101151:	68 dd 02 00 00       	push   $0x2dd
f0101156:	68 1f 74 10 f0       	push   $0xf010741f
f010115b:	e8 0a ef ff ff       	call   f010006a <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0101160:	68 a1 74 10 f0       	push   $0xf01074a1
f0101165:	68 2b 74 10 f0       	push   $0xf010742b
f010116a:	68 de 02 00 00       	push   $0x2de
f010116f:	68 1f 74 10 f0       	push   $0xf010741f
f0101174:	e8 f1 ee ff ff       	call   f010006a <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101179:	68 ec 6b 10 f0       	push   $0xf0106bec
f010117e:	68 2b 74 10 f0       	push   $0xf010742b
f0101183:	68 df 02 00 00       	push   $0x2df
f0101188:	68 1f 74 10 f0       	push   $0xf010741f
f010118d:	e8 d8 ee ff ff       	call   f010006a <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101192:	68 ba 74 10 f0       	push   $0xf01074ba
f0101197:	68 2b 74 10 f0       	push   $0xf010742b
f010119c:	68 e0 02 00 00       	push   $0x2e0
f01011a1:	68 1f 74 10 f0       	push   $0xf010741f
f01011a6:	e8 bf ee ff ff       	call   f010006a <_panic>
		assert(page2pa(pp) < EXTPHYSMEM ||
f01011ab:	89 d8                	mov    %ebx,%eax
f01011ad:	e8 e0 fa ff ff       	call   f0100c92 <page2kva>
f01011b2:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01011b5:	77 06                	ja     f01011bd <check_page_free_list+0x163>
			++nfree_extmem;
f01011b7:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
f01011bb:	eb 1d                	jmp    f01011da <check_page_free_list+0x180>
		assert(page2pa(pp) < EXTPHYSMEM ||
f01011bd:	68 10 6c 10 f0       	push   $0xf0106c10
f01011c2:	68 2b 74 10 f0       	push   $0xf010742b
f01011c7:	68 e1 02 00 00       	push   $0x2e1
f01011cc:	68 1f 74 10 f0       	push   $0xf010741f
f01011d1:	e8 94 ee ff ff       	call   f010006a <_panic>
			++nfree_basemem;
f01011d6:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01011da:	8b 1b                	mov    (%ebx),%ebx
f01011dc:	85 db                	test   %ebx,%ebx
f01011de:	74 77                	je     f0101257 <check_page_free_list+0x1fd>
		assert(pp >= pages);
f01011e0:	39 de                	cmp    %ebx,%esi
f01011e2:	0f 87 14 ff ff ff    	ja     f01010fc <check_page_free_list+0xa2>
		assert(pp < pages + npages);
f01011e8:	39 df                	cmp    %ebx,%edi
f01011ea:	0f 86 25 ff ff ff    	jbe    f0101115 <check_page_free_list+0xbb>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f01011f0:	89 d8                	mov    %ebx,%eax
f01011f2:	29 f0                	sub    %esi,%eax
f01011f4:	a8 07                	test   $0x7,%al
f01011f6:	0f 85 32 ff ff ff    	jne    f010112e <check_page_free_list+0xd4>
		assert(page2pa(pp) != 0);
f01011fc:	89 d8                	mov    %ebx,%eax
f01011fe:	e8 c9 f9 ff ff       	call   f0100bcc <page2pa>
f0101203:	85 c0                	test   %eax,%eax
f0101205:	0f 84 3c ff ff ff    	je     f0101147 <check_page_free_list+0xed>
		assert(page2pa(pp) != IOPHYSMEM);
f010120b:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0101210:	0f 84 4a ff ff ff    	je     f0101160 <check_page_free_list+0x106>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101216:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f010121b:	0f 84 58 ff ff ff    	je     f0101179 <check_page_free_list+0x11f>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101221:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0101226:	0f 84 66 ff ff ff    	je     f0101192 <check_page_free_list+0x138>
		assert(page2pa(pp) < EXTPHYSMEM ||
f010122c:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101231:	0f 87 74 ff ff ff    	ja     f01011ab <check_page_free_list+0x151>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0101237:	3d 00 70 00 00       	cmp    $0x7000,%eax
f010123c:	75 98                	jne    f01011d6 <check_page_free_list+0x17c>
f010123e:	68 d4 74 10 f0       	push   $0xf01074d4
f0101243:	68 2b 74 10 f0       	push   $0xf010742b
f0101248:	68 e4 02 00 00       	push   $0x2e4
f010124d:	68 1f 74 10 f0       	push   $0xf010741f
f0101252:	e8 13 ee ff ff       	call   f010006a <_panic>
	assert(nfree_basemem > 0);
f0101257:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f010125b:	7e 1b                	jle    f0101278 <check_page_free_list+0x21e>
	assert(nfree_extmem > 0);
f010125d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0101261:	7e 2e                	jle    f0101291 <check_page_free_list+0x237>
	cprintf("check_page_free_list() succeeded!\n");
f0101263:	83 ec 0c             	sub    $0xc,%esp
f0101266:	68 58 6c 10 f0       	push   $0xf0106c58
f010126b:	e8 f9 25 00 00       	call   f0103869 <cprintf>
}
f0101270:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101273:	5b                   	pop    %ebx
f0101274:	5e                   	pop    %esi
f0101275:	5f                   	pop    %edi
f0101276:	5d                   	pop    %ebp
f0101277:	c3                   	ret    
	assert(nfree_basemem > 0);
f0101278:	68 f1 74 10 f0       	push   $0xf01074f1
f010127d:	68 2b 74 10 f0       	push   $0xf010742b
f0101282:	68 ec 02 00 00       	push   $0x2ec
f0101287:	68 1f 74 10 f0       	push   $0xf010741f
f010128c:	e8 d9 ed ff ff       	call   f010006a <_panic>
	assert(nfree_extmem > 0);
f0101291:	68 03 75 10 f0       	push   $0xf0107503
f0101296:	68 2b 74 10 f0       	push   $0xf010742b
f010129b:	68 ed 02 00 00       	push   $0x2ed
f01012a0:	68 1f 74 10 f0       	push   $0xf010741f
f01012a5:	e8 c0 ed ff ff       	call   f010006a <_panic>
	if (!page_free_list)
f01012aa:	8b 1d 40 82 24 f0    	mov    0xf0248240,%ebx
f01012b0:	85 db                	test   %ebx,%ebx
f01012b2:	0f 84 c6 fd ff ff    	je     f010107e <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f01012b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
f01012bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01012be:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01012c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f01012c4:	89 d8                	mov    %ebx,%eax
f01012c6:	e8 01 f9 ff ff       	call   f0100bcc <page2pa>
f01012cb:	c1 e8 16             	shr    $0x16,%eax
f01012ce:	0f 95 c0             	setne  %al
f01012d1:	0f b6 c0             	movzbl %al,%eax
			*tp[pagetype] = pp;
f01012d4:	8b 54 85 e0          	mov    -0x20(%ebp,%eax,4),%edx
f01012d8:	89 1a                	mov    %ebx,(%edx)
			tp[pagetype] = &pp->pp_link;
f01012da:	89 5c 85 e0          	mov    %ebx,-0x20(%ebp,%eax,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f01012de:	8b 1b                	mov    (%ebx),%ebx
f01012e0:	85 db                	test   %ebx,%ebx
f01012e2:	75 e0                	jne    f01012c4 <check_page_free_list+0x26a>
		*tp[1] = 0;
f01012e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01012e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f01012ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01012f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01012f3:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f01012f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01012f8:	a3 40 82 24 f0       	mov    %eax,0xf0248240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01012fd:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101302:	8b 1d 40 82 24 f0    	mov    0xf0248240,%ebx
f0101308:	e9 8a fd ff ff       	jmp    f0101097 <check_page_free_list+0x3d>

f010130d <pa2page>:
	if (PGNUM(pa) >= npages)
f010130d:	c1 e8 0c             	shr    $0xc,%eax
f0101310:	3b 05 88 8e 24 f0    	cmp    0xf0248e88,%eax
f0101316:	73 0a                	jae    f0101322 <pa2page+0x15>
	return &pages[PGNUM(pa)];
f0101318:	8b 15 90 8e 24 f0    	mov    0xf0248e90,%edx
f010131e:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101321:	c3                   	ret    
{
f0101322:	55                   	push   %ebp
f0101323:	89 e5                	mov    %esp,%ebp
f0101325:	83 ec 0c             	sub    $0xc,%esp
		panic("pa2page called with invalid pa");
f0101328:	68 7c 6c 10 f0       	push   $0xf0106c7c
f010132d:	6a 51                	push   $0x51
f010132f:	68 11 74 10 f0       	push   $0xf0107411
f0101334:	e8 31 ed ff ff       	call   f010006a <_panic>

f0101339 <page_init>:
{
f0101339:	f3 0f 1e fb          	endbr32 
f010133d:	55                   	push   %ebp
f010133e:	89 e5                	mov    %esp,%ebp
f0101340:	56                   	push   %esi
f0101341:	53                   	push   %ebx
	for (i = 0; i < npages; i++) {
f0101342:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101347:	eb 23                	jmp    f010136c <page_init+0x33>
		pages[i].pp_link = page_free_list;
f0101349:	a1 90 8e 24 f0       	mov    0xf0248e90,%eax
f010134e:	8b 15 40 82 24 f0    	mov    0xf0248240,%edx
f0101354:	89 14 30             	mov    %edx,(%eax,%esi,1)
		pages[i].pp_ref = 0;
f0101357:	03 35 90 8e 24 f0    	add    0xf0248e90,%esi
f010135d:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)
		page_free_list = &pages[i];
f0101363:	89 35 40 82 24 f0    	mov    %esi,0xf0248240
	for (i = 0; i < npages; i++) {
f0101369:	83 c3 01             	add    $0x1,%ebx
f010136c:	39 1d 88 8e 24 f0    	cmp    %ebx,0xf0248e88
f0101372:	76 53                	jbe    f01013c7 <page_init+0x8e>
f0101374:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
		pages[i].pp_link = NULL;
f010137b:	a1 90 8e 24 f0       	mov    0xf0248e90,%eax
f0101380:	c7 04 d8 00 00 00 00 	movl   $0x0,(%eax,%ebx,8)
		if ((PGNUM(MPENTRY_PADDR)) == i)
f0101387:	83 fb 07             	cmp    $0x7,%ebx
f010138a:	74 dd                	je     f0101369 <page_init+0x30>
f010138c:	85 db                	test   %ebx,%ebx
f010138e:	74 d9                	je     f0101369 <page_init+0x30>
		if (i >= PGNUM(IOPHYSMEM) && i < PGNUM(EXTPHYSMEM))
f0101390:	8d 83 60 ff ff ff    	lea    -0xa0(%ebx),%eax
f0101396:	83 f8 5f             	cmp    $0x5f,%eax
f0101399:	76 ce                	jbe    f0101369 <page_init+0x30>
		if (i >= PGNUM(EXTPHYSMEM) && i < PGNUM(PADDR(boot_alloc(0))))
f010139b:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f01013a1:	76 a6                	jbe    f0101349 <page_init+0x10>
f01013a3:	b8 00 00 00 00       	mov    $0x0,%eax
f01013a8:	e8 8d f9 ff ff       	call   f0100d3a <boot_alloc>
f01013ad:	89 c1                	mov    %eax,%ecx
f01013af:	ba 45 01 00 00       	mov    $0x145,%edx
f01013b4:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f01013b9:	e8 5a f9 ff ff       	call   f0100d18 <_paddr>
f01013be:	c1 e8 0c             	shr    $0xc,%eax
f01013c1:	39 d8                	cmp    %ebx,%eax
f01013c3:	76 84                	jbe    f0101349 <page_init+0x10>
f01013c5:	eb a2                	jmp    f0101369 <page_init+0x30>
}
f01013c7:	5b                   	pop    %ebx
f01013c8:	5e                   	pop    %esi
f01013c9:	5d                   	pop    %ebp
f01013ca:	c3                   	ret    

f01013cb <page_alloc>:
{
f01013cb:	f3 0f 1e fb          	endbr32 
f01013cf:	55                   	push   %ebp
f01013d0:	89 e5                	mov    %esp,%ebp
f01013d2:	53                   	push   %ebx
f01013d3:	83 ec 04             	sub    $0x4,%esp
	if (!page_free_list)
f01013d6:	8b 1d 40 82 24 f0    	mov    0xf0248240,%ebx
f01013dc:	85 db                	test   %ebx,%ebx
f01013de:	74 13                	je     f01013f3 <page_alloc+0x28>
	page_free_list = free_page->pp_link;
f01013e0:	8b 03                	mov    (%ebx),%eax
f01013e2:	a3 40 82 24 f0       	mov    %eax,0xf0248240
	free_page->pp_link = NULL;
f01013e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if (alloc_flags & ALLOC_ZERO) {
f01013ed:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f01013f1:	75 07                	jne    f01013fa <page_alloc+0x2f>
}
f01013f3:	89 d8                	mov    %ebx,%eax
f01013f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01013f8:	c9                   	leave  
f01013f9:	c3                   	ret    
		memset(page2kva(free_page), 0, PGSIZE);
f01013fa:	89 d8                	mov    %ebx,%eax
f01013fc:	e8 91 f8 ff ff       	call   f0100c92 <page2kva>
f0101401:	83 ec 04             	sub    $0x4,%esp
f0101404:	68 00 10 00 00       	push   $0x1000
f0101409:	6a 00                	push   $0x0
f010140b:	50                   	push   %eax
f010140c:	e8 aa 43 00 00       	call   f01057bb <memset>
f0101411:	83 c4 10             	add    $0x10,%esp
f0101414:	eb dd                	jmp    f01013f3 <page_alloc+0x28>

f0101416 <page_free>:
{
f0101416:	f3 0f 1e fb          	endbr32 
f010141a:	55                   	push   %ebp
f010141b:	89 e5                	mov    %esp,%ebp
f010141d:	83 ec 08             	sub    $0x8,%esp
f0101420:	8b 45 08             	mov    0x8(%ebp),%eax
	if (pp->pp_ref)
f0101423:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101428:	75 14                	jne    f010143e <page_free+0x28>
	if (pp->pp_link)
f010142a:	83 38 00             	cmpl   $0x0,(%eax)
f010142d:	75 26                	jne    f0101455 <page_free+0x3f>
	pp->pp_link = page_free_list;
f010142f:	8b 15 40 82 24 f0    	mov    0xf0248240,%edx
f0101435:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0101437:	a3 40 82 24 f0       	mov    %eax,0xf0248240
}
f010143c:	c9                   	leave  
f010143d:	c3                   	ret    
		panic("page_free: pp_ref is nonzero\n");
f010143e:	83 ec 04             	sub    $0x4,%esp
f0101441:	68 14 75 10 f0       	push   $0xf0107514
f0101446:	68 74 01 00 00       	push   $0x174
f010144b:	68 1f 74 10 f0       	push   $0xf010741f
f0101450:	e8 15 ec ff ff       	call   f010006a <_panic>
		panic("page_free: pp_link is not NULL\n");
f0101455:	83 ec 04             	sub    $0x4,%esp
f0101458:	68 9c 6c 10 f0       	push   $0xf0106c9c
f010145d:	68 76 01 00 00       	push   $0x176
f0101462:	68 1f 74 10 f0       	push   $0xf010741f
f0101467:	e8 fe eb ff ff       	call   f010006a <_panic>

f010146c <check_page_alloc>:
{
f010146c:	55                   	push   %ebp
f010146d:	89 e5                	mov    %esp,%ebp
f010146f:	57                   	push   %edi
f0101470:	56                   	push   %esi
f0101471:	53                   	push   %ebx
f0101472:	83 ec 1c             	sub    $0x1c,%esp
	if (!pages)
f0101475:	83 3d 90 8e 24 f0 00 	cmpl   $0x0,0xf0248e90
f010147c:	74 0c                	je     f010148a <check_page_alloc+0x1e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010147e:	a1 40 82 24 f0       	mov    0xf0248240,%eax
f0101483:	be 00 00 00 00       	mov    $0x0,%esi
f0101488:	eb 1c                	jmp    f01014a6 <check_page_alloc+0x3a>
		panic("'pages' is a null pointer!");
f010148a:	83 ec 04             	sub    $0x4,%esp
f010148d:	68 32 75 10 f0       	push   $0xf0107532
f0101492:	68 00 03 00 00       	push   $0x300
f0101497:	68 1f 74 10 f0       	push   $0xf010741f
f010149c:	e8 c9 eb ff ff       	call   f010006a <_panic>
		++nfree;
f01014a1:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01014a4:	8b 00                	mov    (%eax),%eax
f01014a6:	85 c0                	test   %eax,%eax
f01014a8:	75 f7                	jne    f01014a1 <check_page_alloc+0x35>
	assert((pp0 = page_alloc(0)));
f01014aa:	83 ec 0c             	sub    $0xc,%esp
f01014ad:	6a 00                	push   $0x0
f01014af:	e8 17 ff ff ff       	call   f01013cb <page_alloc>
f01014b4:	89 c7                	mov    %eax,%edi
f01014b6:	83 c4 10             	add    $0x10,%esp
f01014b9:	85 c0                	test   %eax,%eax
f01014bb:	0f 84 d3 01 00 00    	je     f0101694 <check_page_alloc+0x228>
	assert((pp1 = page_alloc(0)));
f01014c1:	83 ec 0c             	sub    $0xc,%esp
f01014c4:	6a 00                	push   $0x0
f01014c6:	e8 00 ff ff ff       	call   f01013cb <page_alloc>
f01014cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01014ce:	83 c4 10             	add    $0x10,%esp
f01014d1:	85 c0                	test   %eax,%eax
f01014d3:	0f 84 d4 01 00 00    	je     f01016ad <check_page_alloc+0x241>
	assert((pp2 = page_alloc(0)));
f01014d9:	83 ec 0c             	sub    $0xc,%esp
f01014dc:	6a 00                	push   $0x0
f01014de:	e8 e8 fe ff ff       	call   f01013cb <page_alloc>
f01014e3:	89 c3                	mov    %eax,%ebx
f01014e5:	83 c4 10             	add    $0x10,%esp
f01014e8:	85 c0                	test   %eax,%eax
f01014ea:	0f 84 d6 01 00 00    	je     f01016c6 <check_page_alloc+0x25a>
	assert(pp1 && pp1 != pp0);
f01014f0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
f01014f3:	0f 84 e6 01 00 00    	je     f01016df <check_page_alloc+0x273>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01014f9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f01014fc:	0f 84 f6 01 00 00    	je     f01016f8 <check_page_alloc+0x28c>
f0101502:	39 c7                	cmp    %eax,%edi
f0101504:	0f 84 ee 01 00 00    	je     f01016f8 <check_page_alloc+0x28c>
	assert(page2pa(pp0) < npages * PGSIZE);
f010150a:	89 f8                	mov    %edi,%eax
f010150c:	e8 bb f6 ff ff       	call   f0100bcc <page2pa>
f0101511:	8b 0d 88 8e 24 f0    	mov    0xf0248e88,%ecx
f0101517:	c1 e1 0c             	shl    $0xc,%ecx
f010151a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f010151d:	39 c8                	cmp    %ecx,%eax
f010151f:	0f 83 ec 01 00 00    	jae    f0101711 <check_page_alloc+0x2a5>
	assert(page2pa(pp1) < npages * PGSIZE);
f0101525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101528:	e8 9f f6 ff ff       	call   f0100bcc <page2pa>
f010152d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
f0101530:	0f 86 f4 01 00 00    	jbe    f010172a <check_page_alloc+0x2be>
	assert(page2pa(pp2) < npages * PGSIZE);
f0101536:	89 d8                	mov    %ebx,%eax
f0101538:	e8 8f f6 ff ff       	call   f0100bcc <page2pa>
f010153d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
f0101540:	0f 86 fd 01 00 00    	jbe    f0101743 <check_page_alloc+0x2d7>
	fl = page_free_list;
f0101546:	a1 40 82 24 f0       	mov    0xf0248240,%eax
f010154b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	page_free_list = 0;
f010154e:	c7 05 40 82 24 f0 00 	movl   $0x0,0xf0248240
f0101555:	00 00 00 
	assert(!page_alloc(0));
f0101558:	83 ec 0c             	sub    $0xc,%esp
f010155b:	6a 00                	push   $0x0
f010155d:	e8 69 fe ff ff       	call   f01013cb <page_alloc>
f0101562:	83 c4 10             	add    $0x10,%esp
f0101565:	85 c0                	test   %eax,%eax
f0101567:	0f 85 ef 01 00 00    	jne    f010175c <check_page_alloc+0x2f0>
	page_free(pp0);
f010156d:	83 ec 0c             	sub    $0xc,%esp
f0101570:	57                   	push   %edi
f0101571:	e8 a0 fe ff ff       	call   f0101416 <page_free>
	page_free(pp1);
f0101576:	83 c4 04             	add    $0x4,%esp
f0101579:	ff 75 e4             	pushl  -0x1c(%ebp)
f010157c:	e8 95 fe ff ff       	call   f0101416 <page_free>
	page_free(pp2);
f0101581:	89 1c 24             	mov    %ebx,(%esp)
f0101584:	e8 8d fe ff ff       	call   f0101416 <page_free>
	assert((pp0 = page_alloc(0)));
f0101589:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101590:	e8 36 fe ff ff       	call   f01013cb <page_alloc>
f0101595:	89 c3                	mov    %eax,%ebx
f0101597:	83 c4 10             	add    $0x10,%esp
f010159a:	85 c0                	test   %eax,%eax
f010159c:	0f 84 d3 01 00 00    	je     f0101775 <check_page_alloc+0x309>
	assert((pp1 = page_alloc(0)));
f01015a2:	83 ec 0c             	sub    $0xc,%esp
f01015a5:	6a 00                	push   $0x0
f01015a7:	e8 1f fe ff ff       	call   f01013cb <page_alloc>
f01015ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01015af:	83 c4 10             	add    $0x10,%esp
f01015b2:	85 c0                	test   %eax,%eax
f01015b4:	0f 84 d4 01 00 00    	je     f010178e <check_page_alloc+0x322>
	assert((pp2 = page_alloc(0)));
f01015ba:	83 ec 0c             	sub    $0xc,%esp
f01015bd:	6a 00                	push   $0x0
f01015bf:	e8 07 fe ff ff       	call   f01013cb <page_alloc>
f01015c4:	89 c7                	mov    %eax,%edi
f01015c6:	83 c4 10             	add    $0x10,%esp
f01015c9:	85 c0                	test   %eax,%eax
f01015cb:	0f 84 d6 01 00 00    	je     f01017a7 <check_page_alloc+0x33b>
	assert(pp1 && pp1 != pp0);
f01015d1:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01015d4:	0f 84 e6 01 00 00    	je     f01017c0 <check_page_alloc+0x354>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01015da:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f01015dd:	0f 84 f6 01 00 00    	je     f01017d9 <check_page_alloc+0x36d>
f01015e3:	39 c3                	cmp    %eax,%ebx
f01015e5:	0f 84 ee 01 00 00    	je     f01017d9 <check_page_alloc+0x36d>
	assert(!page_alloc(0));
f01015eb:	83 ec 0c             	sub    $0xc,%esp
f01015ee:	6a 00                	push   $0x0
f01015f0:	e8 d6 fd ff ff       	call   f01013cb <page_alloc>
f01015f5:	83 c4 10             	add    $0x10,%esp
f01015f8:	85 c0                	test   %eax,%eax
f01015fa:	0f 85 f2 01 00 00    	jne    f01017f2 <check_page_alloc+0x386>
	memset(page2kva(pp0), 1, PGSIZE);
f0101600:	89 d8                	mov    %ebx,%eax
f0101602:	e8 8b f6 ff ff       	call   f0100c92 <page2kva>
f0101607:	83 ec 04             	sub    $0x4,%esp
f010160a:	68 00 10 00 00       	push   $0x1000
f010160f:	6a 01                	push   $0x1
f0101611:	50                   	push   %eax
f0101612:	e8 a4 41 00 00       	call   f01057bb <memset>
	page_free(pp0);
f0101617:	89 1c 24             	mov    %ebx,(%esp)
f010161a:	e8 f7 fd ff ff       	call   f0101416 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f010161f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101626:	e8 a0 fd ff ff       	call   f01013cb <page_alloc>
f010162b:	83 c4 10             	add    $0x10,%esp
f010162e:	85 c0                	test   %eax,%eax
f0101630:	0f 84 d5 01 00 00    	je     f010180b <check_page_alloc+0x39f>
	assert(pp && pp0 == pp);
f0101636:	39 c3                	cmp    %eax,%ebx
f0101638:	0f 85 e6 01 00 00    	jne    f0101824 <check_page_alloc+0x3b8>
	c = page2kva(pp);
f010163e:	e8 4f f6 ff ff       	call   f0100c92 <page2kva>
f0101643:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
		assert(c[i] == 0);
f0101649:	80 38 00             	cmpb   $0x0,(%eax)
f010164c:	0f 85 eb 01 00 00    	jne    f010183d <check_page_alloc+0x3d1>
f0101652:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f0101655:	39 d0                	cmp    %edx,%eax
f0101657:	75 f0                	jne    f0101649 <check_page_alloc+0x1dd>
	page_free_list = fl;
f0101659:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010165c:	a3 40 82 24 f0       	mov    %eax,0xf0248240
	page_free(pp0);
f0101661:	83 ec 0c             	sub    $0xc,%esp
f0101664:	53                   	push   %ebx
f0101665:	e8 ac fd ff ff       	call   f0101416 <page_free>
	page_free(pp1);
f010166a:	83 c4 04             	add    $0x4,%esp
f010166d:	ff 75 e4             	pushl  -0x1c(%ebp)
f0101670:	e8 a1 fd ff ff       	call   f0101416 <page_free>
	page_free(pp2);
f0101675:	89 3c 24             	mov    %edi,(%esp)
f0101678:	e8 99 fd ff ff       	call   f0101416 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010167d:	a1 40 82 24 f0       	mov    0xf0248240,%eax
f0101682:	83 c4 10             	add    $0x10,%esp
f0101685:	85 c0                	test   %eax,%eax
f0101687:	0f 84 c9 01 00 00    	je     f0101856 <check_page_alloc+0x3ea>
		--nfree;
f010168d:	83 ee 01             	sub    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101690:	8b 00                	mov    (%eax),%eax
f0101692:	eb f1                	jmp    f0101685 <check_page_alloc+0x219>
	assert((pp0 = page_alloc(0)));
f0101694:	68 4d 75 10 f0       	push   $0xf010754d
f0101699:	68 2b 74 10 f0       	push   $0xf010742b
f010169e:	68 08 03 00 00       	push   $0x308
f01016a3:	68 1f 74 10 f0       	push   $0xf010741f
f01016a8:	e8 bd e9 ff ff       	call   f010006a <_panic>
	assert((pp1 = page_alloc(0)));
f01016ad:	68 63 75 10 f0       	push   $0xf0107563
f01016b2:	68 2b 74 10 f0       	push   $0xf010742b
f01016b7:	68 09 03 00 00       	push   $0x309
f01016bc:	68 1f 74 10 f0       	push   $0xf010741f
f01016c1:	e8 a4 e9 ff ff       	call   f010006a <_panic>
	assert((pp2 = page_alloc(0)));
f01016c6:	68 79 75 10 f0       	push   $0xf0107579
f01016cb:	68 2b 74 10 f0       	push   $0xf010742b
f01016d0:	68 0a 03 00 00       	push   $0x30a
f01016d5:	68 1f 74 10 f0       	push   $0xf010741f
f01016da:	e8 8b e9 ff ff       	call   f010006a <_panic>
	assert(pp1 && pp1 != pp0);
f01016df:	68 8f 75 10 f0       	push   $0xf010758f
f01016e4:	68 2b 74 10 f0       	push   $0xf010742b
f01016e9:	68 0d 03 00 00       	push   $0x30d
f01016ee:	68 1f 74 10 f0       	push   $0xf010741f
f01016f3:	e8 72 e9 ff ff       	call   f010006a <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01016f8:	68 bc 6c 10 f0       	push   $0xf0106cbc
f01016fd:	68 2b 74 10 f0       	push   $0xf010742b
f0101702:	68 0e 03 00 00       	push   $0x30e
f0101707:	68 1f 74 10 f0       	push   $0xf010741f
f010170c:	e8 59 e9 ff ff       	call   f010006a <_panic>
	assert(page2pa(pp0) < npages * PGSIZE);
f0101711:	68 dc 6c 10 f0       	push   $0xf0106cdc
f0101716:	68 2b 74 10 f0       	push   $0xf010742b
f010171b:	68 0f 03 00 00       	push   $0x30f
f0101720:	68 1f 74 10 f0       	push   $0xf010741f
f0101725:	e8 40 e9 ff ff       	call   f010006a <_panic>
	assert(page2pa(pp1) < npages * PGSIZE);
f010172a:	68 fc 6c 10 f0       	push   $0xf0106cfc
f010172f:	68 2b 74 10 f0       	push   $0xf010742b
f0101734:	68 10 03 00 00       	push   $0x310
f0101739:	68 1f 74 10 f0       	push   $0xf010741f
f010173e:	e8 27 e9 ff ff       	call   f010006a <_panic>
	assert(page2pa(pp2) < npages * PGSIZE);
f0101743:	68 1c 6d 10 f0       	push   $0xf0106d1c
f0101748:	68 2b 74 10 f0       	push   $0xf010742b
f010174d:	68 11 03 00 00       	push   $0x311
f0101752:	68 1f 74 10 f0       	push   $0xf010741f
f0101757:	e8 0e e9 ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f010175c:	68 a1 75 10 f0       	push   $0xf01075a1
f0101761:	68 2b 74 10 f0       	push   $0xf010742b
f0101766:	68 18 03 00 00       	push   $0x318
f010176b:	68 1f 74 10 f0       	push   $0xf010741f
f0101770:	e8 f5 e8 ff ff       	call   f010006a <_panic>
	assert((pp0 = page_alloc(0)));
f0101775:	68 4d 75 10 f0       	push   $0xf010754d
f010177a:	68 2b 74 10 f0       	push   $0xf010742b
f010177f:	68 1f 03 00 00       	push   $0x31f
f0101784:	68 1f 74 10 f0       	push   $0xf010741f
f0101789:	e8 dc e8 ff ff       	call   f010006a <_panic>
	assert((pp1 = page_alloc(0)));
f010178e:	68 63 75 10 f0       	push   $0xf0107563
f0101793:	68 2b 74 10 f0       	push   $0xf010742b
f0101798:	68 20 03 00 00       	push   $0x320
f010179d:	68 1f 74 10 f0       	push   $0xf010741f
f01017a2:	e8 c3 e8 ff ff       	call   f010006a <_panic>
	assert((pp2 = page_alloc(0)));
f01017a7:	68 79 75 10 f0       	push   $0xf0107579
f01017ac:	68 2b 74 10 f0       	push   $0xf010742b
f01017b1:	68 21 03 00 00       	push   $0x321
f01017b6:	68 1f 74 10 f0       	push   $0xf010741f
f01017bb:	e8 aa e8 ff ff       	call   f010006a <_panic>
	assert(pp1 && pp1 != pp0);
f01017c0:	68 8f 75 10 f0       	push   $0xf010758f
f01017c5:	68 2b 74 10 f0       	push   $0xf010742b
f01017ca:	68 23 03 00 00       	push   $0x323
f01017cf:	68 1f 74 10 f0       	push   $0xf010741f
f01017d4:	e8 91 e8 ff ff       	call   f010006a <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01017d9:	68 bc 6c 10 f0       	push   $0xf0106cbc
f01017de:	68 2b 74 10 f0       	push   $0xf010742b
f01017e3:	68 24 03 00 00       	push   $0x324
f01017e8:	68 1f 74 10 f0       	push   $0xf010741f
f01017ed:	e8 78 e8 ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f01017f2:	68 a1 75 10 f0       	push   $0xf01075a1
f01017f7:	68 2b 74 10 f0       	push   $0xf010742b
f01017fc:	68 25 03 00 00       	push   $0x325
f0101801:	68 1f 74 10 f0       	push   $0xf010741f
f0101806:	e8 5f e8 ff ff       	call   f010006a <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f010180b:	68 b0 75 10 f0       	push   $0xf01075b0
f0101810:	68 2b 74 10 f0       	push   $0xf010742b
f0101815:	68 2a 03 00 00       	push   $0x32a
f010181a:	68 1f 74 10 f0       	push   $0xf010741f
f010181f:	e8 46 e8 ff ff       	call   f010006a <_panic>
	assert(pp && pp0 == pp);
f0101824:	68 ce 75 10 f0       	push   $0xf01075ce
f0101829:	68 2b 74 10 f0       	push   $0xf010742b
f010182e:	68 2b 03 00 00       	push   $0x32b
f0101833:	68 1f 74 10 f0       	push   $0xf010741f
f0101838:	e8 2d e8 ff ff       	call   f010006a <_panic>
		assert(c[i] == 0);
f010183d:	68 de 75 10 f0       	push   $0xf01075de
f0101842:	68 2b 74 10 f0       	push   $0xf010742b
f0101847:	68 2e 03 00 00       	push   $0x32e
f010184c:	68 1f 74 10 f0       	push   $0xf010741f
f0101851:	e8 14 e8 ff ff       	call   f010006a <_panic>
	assert(nfree == 0);
f0101856:	85 f6                	test   %esi,%esi
f0101858:	75 18                	jne    f0101872 <check_page_alloc+0x406>
	cprintf("check_page_alloc() succeeded!\n");
f010185a:	83 ec 0c             	sub    $0xc,%esp
f010185d:	68 3c 6d 10 f0       	push   $0xf0106d3c
f0101862:	e8 02 20 00 00       	call   f0103869 <cprintf>
}
f0101867:	83 c4 10             	add    $0x10,%esp
f010186a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010186d:	5b                   	pop    %ebx
f010186e:	5e                   	pop    %esi
f010186f:	5f                   	pop    %edi
f0101870:	5d                   	pop    %ebp
f0101871:	c3                   	ret    
	assert(nfree == 0);
f0101872:	68 e8 75 10 f0       	push   $0xf01075e8
f0101877:	68 2b 74 10 f0       	push   $0xf010742b
f010187c:	68 3b 03 00 00       	push   $0x33b
f0101881:	68 1f 74 10 f0       	push   $0xf010741f
f0101886:	e8 df e7 ff ff       	call   f010006a <_panic>

f010188b <page_decref>:
{
f010188b:	f3 0f 1e fb          	endbr32 
f010188f:	55                   	push   %ebp
f0101890:	89 e5                	mov    %esp,%ebp
f0101892:	83 ec 08             	sub    $0x8,%esp
f0101895:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0101898:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f010189c:	83 e8 01             	sub    $0x1,%eax
f010189f:	66 89 42 04          	mov    %ax,0x4(%edx)
f01018a3:	66 85 c0             	test   %ax,%ax
f01018a6:	74 02                	je     f01018aa <page_decref+0x1f>
}
f01018a8:	c9                   	leave  
f01018a9:	c3                   	ret    
		page_free(pp);
f01018aa:	83 ec 0c             	sub    $0xc,%esp
f01018ad:	52                   	push   %edx
f01018ae:	e8 63 fb ff ff       	call   f0101416 <page_free>
f01018b3:	83 c4 10             	add    $0x10,%esp
}
f01018b6:	eb f0                	jmp    f01018a8 <page_decref+0x1d>

f01018b8 <pgdir_walk>:
{
f01018b8:	f3 0f 1e fb          	endbr32 
f01018bc:	55                   	push   %ebp
f01018bd:	89 e5                	mov    %esp,%ebp
f01018bf:	56                   	push   %esi
f01018c0:	53                   	push   %ebx
f01018c1:	8b 75 0c             	mov    0xc(%ebp),%esi
	uintptr_t pdx = PDX(va);
f01018c4:	89 f3                	mov    %esi,%ebx
f01018c6:	c1 eb 16             	shr    $0x16,%ebx
	if (!pgdir[pdx] && create && (page = page_alloc(ALLOC_ZERO))) {
f01018c9:	c1 e3 02             	shl    $0x2,%ebx
f01018cc:	03 5d 08             	add    0x8(%ebp),%ebx
f01018cf:	83 3b 00             	cmpl   $0x0,(%ebx)
f01018d2:	75 06                	jne    f01018da <pgdir_walk+0x22>
f01018d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01018d8:	75 12                	jne    f01018ec <pgdir_walk+0x34>
	if (pgdir[pdx]) {
f01018da:	8b 0b                	mov    (%ebx),%ecx
	return NULL;
f01018dc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pgdir[pdx]) {
f01018e1:	85 c9                	test   %ecx,%ecx
f01018e3:	75 29                	jne    f010190e <pgdir_walk+0x56>
}
f01018e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01018e8:	5b                   	pop    %ebx
f01018e9:	5e                   	pop    %esi
f01018ea:	5d                   	pop    %ebp
f01018eb:	c3                   	ret    
	if (!pgdir[pdx] && create && (page = page_alloc(ALLOC_ZERO))) {
f01018ec:	83 ec 0c             	sub    $0xc,%esp
f01018ef:	6a 01                	push   $0x1
f01018f1:	e8 d5 fa ff ff       	call   f01013cb <page_alloc>
f01018f6:	83 c4 10             	add    $0x10,%esp
f01018f9:	85 c0                	test   %eax,%eax
f01018fb:	74 dd                	je     f01018da <pgdir_walk+0x22>
		page->pp_ref++;
f01018fd:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
		pgdir[pdx] = page2pa(page) | PTE_P | PTE_W | PTE_U;
f0101902:	e8 c5 f2 ff ff       	call   f0100bcc <page2pa>
f0101907:	83 c8 07             	or     $0x7,%eax
f010190a:	89 c1                	mov    %eax,%ecx
f010190c:	89 03                	mov    %eax,(%ebx)
		pte_t *pte = (pte_t *) KADDR(PTE_ADDR(pgdir[pdx]));
f010190e:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0101914:	ba a8 01 00 00       	mov    $0x1a8,%edx
f0101919:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f010191e:	e8 43 f3 ff ff       	call   f0100c66 <_kaddr>
		return pte + PTX(va);
f0101923:	c1 ee 0a             	shr    $0xa,%esi
f0101926:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f010192c:	01 f0                	add    %esi,%eax
f010192e:	eb b5                	jmp    f01018e5 <pgdir_walk+0x2d>

f0101930 <page_lookup>:
{
f0101930:	f3 0f 1e fb          	endbr32 
f0101934:	55                   	push   %ebp
f0101935:	89 e5                	mov    %esp,%ebp
f0101937:	53                   	push   %ebx
f0101938:	83 ec 08             	sub    $0x8,%esp
f010193b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *pte = pgdir_walk(pgdir, va, 0);
f010193e:	6a 00                	push   $0x0
f0101940:	ff 75 0c             	pushl  0xc(%ebp)
f0101943:	ff 75 08             	pushl  0x8(%ebp)
f0101946:	e8 6d ff ff ff       	call   f01018b8 <pgdir_walk>
	if (!pte || !(*pte && PTE_P))
f010194b:	83 c4 10             	add    $0x10,%esp
f010194e:	85 c0                	test   %eax,%eax
f0101950:	74 17                	je     f0101969 <page_lookup+0x39>
f0101952:	83 38 00             	cmpl   $0x0,(%eax)
f0101955:	74 17                	je     f010196e <page_lookup+0x3e>
	if (pte_store) {
f0101957:	85 db                	test   %ebx,%ebx
f0101959:	74 02                	je     f010195d <page_lookup+0x2d>
		*pte_store = pte;
f010195b:	89 03                	mov    %eax,(%ebx)
	uint32_t pte_ptr = PTE_ADDR(*pte);
f010195d:	8b 00                	mov    (%eax),%eax
f010195f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	return pa2page(pte_ptr);
f0101964:	e8 a4 f9 ff ff       	call   f010130d <pa2page>
}
f0101969:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010196c:	c9                   	leave  
f010196d:	c3                   	ret    
		return NULL;
f010196e:	b8 00 00 00 00       	mov    $0x0,%eax
f0101973:	eb f4                	jmp    f0101969 <page_lookup+0x39>

f0101975 <tlb_invalidate>:
{
f0101975:	f3 0f 1e fb          	endbr32 
f0101979:	55                   	push   %ebp
f010197a:	89 e5                	mov    %esp,%ebp
f010197c:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f010197f:	e8 c8 44 00 00       	call   f0105e4c <cpunum>
f0101984:	6b c0 74             	imul   $0x74,%eax,%eax
f0101987:	83 b8 28 90 24 f0 00 	cmpl   $0x0,-0xfdb6fd8(%eax)
f010198e:	74 16                	je     f01019a6 <tlb_invalidate+0x31>
f0101990:	e8 b7 44 00 00       	call   f0105e4c <cpunum>
f0101995:	6b c0 74             	imul   $0x74,%eax,%eax
f0101998:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f010199e:	8b 55 08             	mov    0x8(%ebp),%edx
f01019a1:	39 50 60             	cmp    %edx,0x60(%eax)
f01019a4:	75 08                	jne    f01019ae <tlb_invalidate+0x39>
		invlpg(va);
f01019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01019a9:	e8 0e f2 ff ff       	call   f0100bbc <invlpg>
}
f01019ae:	c9                   	leave  
f01019af:	c3                   	ret    

f01019b0 <page_remove>:
{
f01019b0:	f3 0f 1e fb          	endbr32 
f01019b4:	55                   	push   %ebp
f01019b5:	89 e5                	mov    %esp,%ebp
f01019b7:	56                   	push   %esi
f01019b8:	53                   	push   %ebx
f01019b9:	83 ec 14             	sub    $0x14,%esp
f01019bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01019bf:	8b 75 0c             	mov    0xc(%ebp),%esi
	uint32_t *pte = pgdir_walk(pgdir, va, 0);
f01019c2:	6a 00                	push   $0x0
f01019c4:	56                   	push   %esi
f01019c5:	53                   	push   %ebx
f01019c6:	e8 ed fe ff ff       	call   f01018b8 <pgdir_walk>
f01019cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct PageInfo *page_rmv = page_lookup(pgdir, va, &pte);
f01019ce:	83 c4 0c             	add    $0xc,%esp
f01019d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01019d4:	50                   	push   %eax
f01019d5:	56                   	push   %esi
f01019d6:	53                   	push   %ebx
f01019d7:	e8 54 ff ff ff       	call   f0101930 <page_lookup>
	if (!pte || !(*pte && PTE_P))
f01019dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01019df:	83 c4 10             	add    $0x10,%esp
f01019e2:	85 d2                	test   %edx,%edx
f01019e4:	74 05                	je     f01019eb <page_remove+0x3b>
f01019e6:	83 3a 00             	cmpl   $0x0,(%edx)
f01019e9:	75 07                	jne    f01019f2 <page_remove+0x42>
}
f01019eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01019ee:	5b                   	pop    %ebx
f01019ef:	5e                   	pop    %esi
f01019f0:	5d                   	pop    %ebp
f01019f1:	c3                   	ret    
	page_decref(page_rmv);
f01019f2:	83 ec 0c             	sub    $0xc,%esp
f01019f5:	50                   	push   %eax
f01019f6:	e8 90 fe ff ff       	call   f010188b <page_decref>
	*pte = 0;
f01019fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01019fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, va);
f0101a04:	83 c4 08             	add    $0x8,%esp
f0101a07:	56                   	push   %esi
f0101a08:	53                   	push   %ebx
f0101a09:	e8 67 ff ff ff       	call   f0101975 <tlb_invalidate>
f0101a0e:	83 c4 10             	add    $0x10,%esp
f0101a11:	eb d8                	jmp    f01019eb <page_remove+0x3b>

f0101a13 <boot_map_region>:
{
f0101a13:	55                   	push   %ebp
f0101a14:	89 e5                	mov    %esp,%ebp
f0101a16:	57                   	push   %edi
f0101a17:	56                   	push   %esi
f0101a18:	53                   	push   %ebx
f0101a19:	83 ec 1c             	sub    $0x1c,%esp
f0101a1c:	89 c6                	mov    %eax,%esi
f0101a1e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0101a21:	89 4d e0             	mov    %ecx,-0x20(%ebp)
	for (size_t i = 0; i < size; i += PGSIZE) {
f0101a24:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101a29:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
f0101a2c:	73 3a                	jae    f0101a68 <boot_map_region+0x55>
f0101a2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101a31:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
		pte_t *pte = pgdir_walk(pgdir, (void *) (va + i), 1);
f0101a34:	83 ec 04             	sub    $0x4,%esp
f0101a37:	6a 01                	push   $0x1
f0101a39:	57                   	push   %edi
f0101a3a:	56                   	push   %esi
f0101a3b:	e8 78 fe ff ff       	call   f01018b8 <pgdir_walk>
f0101a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		page_remove(pgdir, (void *) (va + i));
f0101a43:	83 c4 08             	add    $0x8,%esp
f0101a46:	57                   	push   %edi
f0101a47:	56                   	push   %esi
f0101a48:	e8 63 ff ff ff       	call   f01019b0 <page_remove>
		*pte = (pa + i) | perm | PTE_P;
f0101a4d:	89 d8                	mov    %ebx,%eax
f0101a4f:	03 45 08             	add    0x8(%ebp),%eax
f0101a52:	0b 45 0c             	or     0xc(%ebp),%eax
f0101a55:	83 c8 01             	or     $0x1,%eax
f0101a58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0101a5b:	89 02                	mov    %eax,(%edx)
	for (size_t i = 0; i < size; i += PGSIZE) {
f0101a5d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101a63:	83 c4 10             	add    $0x10,%esp
f0101a66:	eb c1                	jmp    f0101a29 <boot_map_region+0x16>
}
f0101a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101a6b:	5b                   	pop    %ebx
f0101a6c:	5e                   	pop    %esi
f0101a6d:	5f                   	pop    %edi
f0101a6e:	5d                   	pop    %ebp
f0101a6f:	c3                   	ret    

f0101a70 <mem_init_mp>:
{
f0101a70:	55                   	push   %ebp
f0101a71:	89 e5                	mov    %esp,%ebp
f0101a73:	57                   	push   %edi
f0101a74:	56                   	push   %esi
f0101a75:	53                   	push   %ebx
f0101a76:	83 ec 0c             	sub    $0xc,%esp
f0101a79:	bb 00 a0 24 f0       	mov    $0xf024a000,%ebx
f0101a7e:	bf 00 a0 28 f0       	mov    $0xf028a000,%edi
f0101a83:	be 00 80 ff ef       	mov    $0xefff8000,%esi
		boot_map_region(kern_pgdir,
f0101a88:	89 d9                	mov    %ebx,%ecx
f0101a8a:	ba 12 01 00 00       	mov    $0x112,%edx
f0101a8f:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0101a94:	e8 7f f2 ff ff       	call   f0100d18 <_paddr>
f0101a99:	83 ec 08             	sub    $0x8,%esp
f0101a9c:	6a 03                	push   $0x3
f0101a9e:	50                   	push   %eax
f0101a9f:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0101aa4:	89 f2                	mov    %esi,%edx
f0101aa6:	a1 8c 8e 24 f0       	mov    0xf0248e8c,%eax
f0101aab:	e8 63 ff ff ff       	call   f0101a13 <boot_map_region>
f0101ab0:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0101ab6:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for (int i = 0; i < NCPU; i++) {
f0101abc:	83 c4 10             	add    $0x10,%esp
f0101abf:	39 fb                	cmp    %edi,%ebx
f0101ac1:	75 c5                	jne    f0101a88 <mem_init_mp+0x18>
}
f0101ac3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101ac6:	5b                   	pop    %ebx
f0101ac7:	5e                   	pop    %esi
f0101ac8:	5f                   	pop    %edi
f0101ac9:	5d                   	pop    %ebp
f0101aca:	c3                   	ret    

f0101acb <page_insert>:
{
f0101acb:	f3 0f 1e fb          	endbr32 
f0101acf:	55                   	push   %ebp
f0101ad0:	89 e5                	mov    %esp,%ebp
f0101ad2:	57                   	push   %edi
f0101ad3:	56                   	push   %esi
f0101ad4:	53                   	push   %ebx
f0101ad5:	83 ec 10             	sub    $0x10,%esp
f0101ad8:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101adb:	8b 7d 10             	mov    0x10(%ebp),%edi
	pte_t *page_table = pgdir_walk(pgdir, va, 1);
f0101ade:	6a 01                	push   $0x1
f0101ae0:	57                   	push   %edi
f0101ae1:	ff 75 08             	pushl  0x8(%ebp)
f0101ae4:	e8 cf fd ff ff       	call   f01018b8 <pgdir_walk>
	if (!page_table)
f0101ae9:	83 c4 10             	add    $0x10,%esp
f0101aec:	85 c0                	test   %eax,%eax
f0101aee:	74 32                	je     f0101b22 <page_insert+0x57>
f0101af0:	89 c3                	mov    %eax,%ebx
	pp->pp_ref++;
f0101af2:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
	page_remove(pgdir, va);
f0101af7:	83 ec 08             	sub    $0x8,%esp
f0101afa:	57                   	push   %edi
f0101afb:	ff 75 08             	pushl  0x8(%ebp)
f0101afe:	e8 ad fe ff ff       	call   f01019b0 <page_remove>
	uint32_t new_pte = page2pa(pp) | perm | PTE_P;
f0101b03:	89 f0                	mov    %esi,%eax
f0101b05:	e8 c2 f0 ff ff       	call   f0100bcc <page2pa>
f0101b0a:	0b 45 14             	or     0x14(%ebp),%eax
f0101b0d:	83 c8 01             	or     $0x1,%eax
f0101b10:	89 03                	mov    %eax,(%ebx)
	return 0;
f0101b12:	83 c4 10             	add    $0x10,%esp
f0101b15:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101b1d:	5b                   	pop    %ebx
f0101b1e:	5e                   	pop    %esi
f0101b1f:	5f                   	pop    %edi
f0101b20:	5d                   	pop    %ebp
f0101b21:	c3                   	ret    
		return -E_NO_MEM;
f0101b22:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101b27:	eb f1                	jmp    f0101b1a <page_insert+0x4f>

f0101b29 <check_page_installed_pgdir>:
}

// check page_insert, page_remove, &c, with an installed kern_pgdir
static void
check_page_installed_pgdir(void)
{
f0101b29:	55                   	push   %ebp
f0101b2a:	89 e5                	mov    %esp,%ebp
f0101b2c:	57                   	push   %edi
f0101b2d:	56                   	push   %esi
f0101b2e:	53                   	push   %ebx
f0101b2f:	83 ec 18             	sub    $0x18,%esp
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101b32:	6a 00                	push   $0x0
f0101b34:	e8 92 f8 ff ff       	call   f01013cb <page_alloc>
f0101b39:	83 c4 10             	add    $0x10,%esp
f0101b3c:	85 c0                	test   %eax,%eax
f0101b3e:	0f 84 67 01 00 00    	je     f0101cab <check_page_installed_pgdir+0x182>
f0101b44:	89 c6                	mov    %eax,%esi
	assert((pp1 = page_alloc(0)));
f0101b46:	83 ec 0c             	sub    $0xc,%esp
f0101b49:	6a 00                	push   $0x0
f0101b4b:	e8 7b f8 ff ff       	call   f01013cb <page_alloc>
f0101b50:	89 c7                	mov    %eax,%edi
f0101b52:	83 c4 10             	add    $0x10,%esp
f0101b55:	85 c0                	test   %eax,%eax
f0101b57:	0f 84 67 01 00 00    	je     f0101cc4 <check_page_installed_pgdir+0x19b>
	assert((pp2 = page_alloc(0)));
f0101b5d:	83 ec 0c             	sub    $0xc,%esp
f0101b60:	6a 00                	push   $0x0
f0101b62:	e8 64 f8 ff ff       	call   f01013cb <page_alloc>
f0101b67:	89 c3                	mov    %eax,%ebx
f0101b69:	83 c4 10             	add    $0x10,%esp
f0101b6c:	85 c0                	test   %eax,%eax
f0101b6e:	0f 84 69 01 00 00    	je     f0101cdd <check_page_installed_pgdir+0x1b4>
	page_free(pp0);
f0101b74:	83 ec 0c             	sub    $0xc,%esp
f0101b77:	56                   	push   %esi
f0101b78:	e8 99 f8 ff ff       	call   f0101416 <page_free>
	memset(page2kva(pp1), 1, PGSIZE);
f0101b7d:	89 f8                	mov    %edi,%eax
f0101b7f:	e8 0e f1 ff ff       	call   f0100c92 <page2kva>
f0101b84:	83 c4 0c             	add    $0xc,%esp
f0101b87:	68 00 10 00 00       	push   $0x1000
f0101b8c:	6a 01                	push   $0x1
f0101b8e:	50                   	push   %eax
f0101b8f:	e8 27 3c 00 00       	call   f01057bb <memset>
	memset(page2kva(pp2), 2, PGSIZE);
f0101b94:	89 d8                	mov    %ebx,%eax
f0101b96:	e8 f7 f0 ff ff       	call   f0100c92 <page2kva>
f0101b9b:	83 c4 0c             	add    $0xc,%esp
f0101b9e:	68 00 10 00 00       	push   $0x1000
f0101ba3:	6a 02                	push   $0x2
f0101ba5:	50                   	push   %eax
f0101ba6:	e8 10 3c 00 00       	call   f01057bb <memset>
	page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W);
f0101bab:	6a 02                	push   $0x2
f0101bad:	68 00 10 00 00       	push   $0x1000
f0101bb2:	57                   	push   %edi
f0101bb3:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0101bb9:	e8 0d ff ff ff       	call   f0101acb <page_insert>
	assert(pp1->pp_ref == 1);
f0101bbe:	83 c4 20             	add    $0x20,%esp
f0101bc1:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101bc6:	0f 85 2a 01 00 00    	jne    f0101cf6 <check_page_installed_pgdir+0x1cd>
	assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0101bcc:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0101bd3:	01 01 01 
f0101bd6:	0f 85 33 01 00 00    	jne    f0101d0f <check_page_installed_pgdir+0x1e6>
	page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W);
f0101bdc:	6a 02                	push   $0x2
f0101bde:	68 00 10 00 00       	push   $0x1000
f0101be3:	53                   	push   %ebx
f0101be4:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0101bea:	e8 dc fe ff ff       	call   f0101acb <page_insert>
	assert(*(uint32_t *) PGSIZE == 0x02020202U);
f0101bef:	83 c4 10             	add    $0x10,%esp
f0101bf2:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0101bf9:	02 02 02 
f0101bfc:	0f 85 26 01 00 00    	jne    f0101d28 <check_page_installed_pgdir+0x1ff>
	assert(pp2->pp_ref == 1);
f0101c02:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101c07:	0f 85 34 01 00 00    	jne    f0101d41 <check_page_installed_pgdir+0x218>
	assert(pp1->pp_ref == 0);
f0101c0d:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101c12:	0f 85 42 01 00 00    	jne    f0101d5a <check_page_installed_pgdir+0x231>
	*(uint32_t *) PGSIZE = 0x03030303U;
f0101c18:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0101c1f:	03 03 03 
	assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0101c22:	89 d8                	mov    %ebx,%eax
f0101c24:	e8 69 f0 ff ff       	call   f0100c92 <page2kva>
f0101c29:	81 38 03 03 03 03    	cmpl   $0x3030303,(%eax)
f0101c2f:	0f 85 3e 01 00 00    	jne    f0101d73 <check_page_installed_pgdir+0x24a>
	page_remove(kern_pgdir, (void *) PGSIZE);
f0101c35:	83 ec 08             	sub    $0x8,%esp
f0101c38:	68 00 10 00 00       	push   $0x1000
f0101c3d:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0101c43:	e8 68 fd ff ff       	call   f01019b0 <page_remove>
	assert(pp2->pp_ref == 0);
f0101c48:	83 c4 10             	add    $0x10,%esp
f0101c4b:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101c50:	0f 85 36 01 00 00    	jne    f0101d8c <check_page_installed_pgdir+0x263>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101c56:	8b 1d 8c 8e 24 f0    	mov    0xf0248e8c,%ebx
f0101c5c:	89 f0                	mov    %esi,%eax
f0101c5e:	e8 69 ef ff ff       	call   f0100bcc <page2pa>
f0101c63:	89 c2                	mov    %eax,%edx
f0101c65:	8b 03                	mov    (%ebx),%eax
f0101c67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101c6c:	39 d0                	cmp    %edx,%eax
f0101c6e:	0f 85 31 01 00 00    	jne    f0101da5 <check_page_installed_pgdir+0x27c>
	kern_pgdir[0] = 0;
f0101c74:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	assert(pp0->pp_ref == 1);
f0101c7a:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101c7f:	0f 85 39 01 00 00    	jne    f0101dbe <check_page_installed_pgdir+0x295>
	pp0->pp_ref = 0;
f0101c85:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0101c8b:	83 ec 0c             	sub    $0xc,%esp
f0101c8e:	56                   	push   %esi
f0101c8f:	e8 82 f7 ff ff       	call   f0101416 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0101c94:	c7 04 24 f8 6d 10 f0 	movl   $0xf0106df8,(%esp)
f0101c9b:	e8 c9 1b 00 00       	call   f0103869 <cprintf>
}
f0101ca0:	83 c4 10             	add    $0x10,%esp
f0101ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101ca6:	5b                   	pop    %ebx
f0101ca7:	5e                   	pop    %esi
f0101ca8:	5f                   	pop    %edi
f0101ca9:	5d                   	pop    %ebp
f0101caa:	c3                   	ret    
	assert((pp0 = page_alloc(0)));
f0101cab:	68 4d 75 10 f0       	push   $0xf010754d
f0101cb0:	68 2b 74 10 f0       	push   $0xf010742b
f0101cb5:	68 5e 04 00 00       	push   $0x45e
f0101cba:	68 1f 74 10 f0       	push   $0xf010741f
f0101cbf:	e8 a6 e3 ff ff       	call   f010006a <_panic>
	assert((pp1 = page_alloc(0)));
f0101cc4:	68 63 75 10 f0       	push   $0xf0107563
f0101cc9:	68 2b 74 10 f0       	push   $0xf010742b
f0101cce:	68 5f 04 00 00       	push   $0x45f
f0101cd3:	68 1f 74 10 f0       	push   $0xf010741f
f0101cd8:	e8 8d e3 ff ff       	call   f010006a <_panic>
	assert((pp2 = page_alloc(0)));
f0101cdd:	68 79 75 10 f0       	push   $0xf0107579
f0101ce2:	68 2b 74 10 f0       	push   $0xf010742b
f0101ce7:	68 60 04 00 00       	push   $0x460
f0101cec:	68 1f 74 10 f0       	push   $0xf010741f
f0101cf1:	e8 74 e3 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 1);
f0101cf6:	68 f3 75 10 f0       	push   $0xf01075f3
f0101cfb:	68 2b 74 10 f0       	push   $0xf010742b
f0101d00:	68 65 04 00 00       	push   $0x465
f0101d05:	68 1f 74 10 f0       	push   $0xf010741f
f0101d0a:	e8 5b e3 ff ff       	call   f010006a <_panic>
	assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0101d0f:	68 5c 6d 10 f0       	push   $0xf0106d5c
f0101d14:	68 2b 74 10 f0       	push   $0xf010742b
f0101d19:	68 66 04 00 00       	push   $0x466
f0101d1e:	68 1f 74 10 f0       	push   $0xf010741f
f0101d23:	e8 42 e3 ff ff       	call   f010006a <_panic>
	assert(*(uint32_t *) PGSIZE == 0x02020202U);
f0101d28:	68 80 6d 10 f0       	push   $0xf0106d80
f0101d2d:	68 2b 74 10 f0       	push   $0xf010742b
f0101d32:	68 68 04 00 00       	push   $0x468
f0101d37:	68 1f 74 10 f0       	push   $0xf010741f
f0101d3c:	e8 29 e3 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 1);
f0101d41:	68 04 76 10 f0       	push   $0xf0107604
f0101d46:	68 2b 74 10 f0       	push   $0xf010742b
f0101d4b:	68 69 04 00 00       	push   $0x469
f0101d50:	68 1f 74 10 f0       	push   $0xf010741f
f0101d55:	e8 10 e3 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 0);
f0101d5a:	68 15 76 10 f0       	push   $0xf0107615
f0101d5f:	68 2b 74 10 f0       	push   $0xf010742b
f0101d64:	68 6a 04 00 00       	push   $0x46a
f0101d69:	68 1f 74 10 f0       	push   $0xf010741f
f0101d6e:	e8 f7 e2 ff ff       	call   f010006a <_panic>
	assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0101d73:	68 a4 6d 10 f0       	push   $0xf0106da4
f0101d78:	68 2b 74 10 f0       	push   $0xf010742b
f0101d7d:	68 6c 04 00 00       	push   $0x46c
f0101d82:	68 1f 74 10 f0       	push   $0xf010741f
f0101d87:	e8 de e2 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 0);
f0101d8c:	68 26 76 10 f0       	push   $0xf0107626
f0101d91:	68 2b 74 10 f0       	push   $0xf010742b
f0101d96:	68 6e 04 00 00       	push   $0x46e
f0101d9b:	68 1f 74 10 f0       	push   $0xf010741f
f0101da0:	e8 c5 e2 ff ff       	call   f010006a <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101da5:	68 d0 6d 10 f0       	push   $0xf0106dd0
f0101daa:	68 2b 74 10 f0       	push   $0xf010742b
f0101daf:	68 71 04 00 00       	push   $0x471
f0101db4:	68 1f 74 10 f0       	push   $0xf010741f
f0101db9:	e8 ac e2 ff ff       	call   f010006a <_panic>
	assert(pp0->pp_ref == 1);
f0101dbe:	68 37 76 10 f0       	push   $0xf0107637
f0101dc3:	68 2b 74 10 f0       	push   $0xf010742b
f0101dc8:	68 73 04 00 00       	push   $0x473
f0101dcd:	68 1f 74 10 f0       	push   $0xf010741f
f0101dd2:	e8 93 e2 ff ff       	call   f010006a <_panic>

f0101dd7 <mmio_map_region>:
{
f0101dd7:	f3 0f 1e fb          	endbr32 
f0101ddb:	55                   	push   %ebp
f0101ddc:	89 e5                	mov    %esp,%ebp
f0101dde:	53                   	push   %ebx
f0101ddf:	83 ec 04             	sub    $0x4,%esp
	pa = ROUNDDOWN(pa, PGSIZE);
f0101de2:	8b 45 08             	mov    0x8(%ebp),%eax
f0101de5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	size = ROUNDUP(size, PGSIZE);
f0101dea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101ded:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
f0101df3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (base + size >= MMIOLIM)
f0101df9:	8b 15 00 23 12 f0    	mov    0xf0122300,%edx
f0101dff:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
f0101e02:	81 f9 ff ff bf ef    	cmp    $0xefbfffff,%ecx
f0101e08:	77 24                	ja     f0101e2e <mmio_map_region+0x57>
	boot_map_region(kern_pgdir, base, size, pa, perm);
f0101e0a:	83 ec 08             	sub    $0x8,%esp
f0101e0d:	6a 1b                	push   $0x1b
f0101e0f:	50                   	push   %eax
f0101e10:	89 d9                	mov    %ebx,%ecx
f0101e12:	a1 8c 8e 24 f0       	mov    0xf0248e8c,%eax
f0101e17:	e8 f7 fb ff ff       	call   f0101a13 <boot_map_region>
	base += size;
f0101e1c:	a1 00 23 12 f0       	mov    0xf0122300,%eax
f0101e21:	01 c3                	add    %eax,%ebx
f0101e23:	89 1d 00 23 12 f0    	mov    %ebx,0xf0122300
}
f0101e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101e2c:	c9                   	leave  
f0101e2d:	c3                   	ret    
		panic("mmio_map_region: MMIOLIMIT overflow");
f0101e2e:	83 ec 04             	sub    $0x4,%esp
f0101e31:	68 24 6e 10 f0       	push   $0xf0106e24
f0101e36:	68 69 02 00 00       	push   $0x269
f0101e3b:	68 1f 74 10 f0       	push   $0xf010741f
f0101e40:	e8 25 e2 ff ff       	call   f010006a <_panic>

f0101e45 <check_page>:
{
f0101e45:	55                   	push   %ebp
f0101e46:	89 e5                	mov    %esp,%ebp
f0101e48:	57                   	push   %edi
f0101e49:	56                   	push   %esi
f0101e4a:	53                   	push   %ebx
f0101e4b:	83 ec 38             	sub    $0x38,%esp
	assert((pp0 = page_alloc(0)));
f0101e4e:	6a 00                	push   $0x0
f0101e50:	e8 76 f5 ff ff       	call   f01013cb <page_alloc>
f0101e55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101e58:	83 c4 10             	add    $0x10,%esp
f0101e5b:	85 c0                	test   %eax,%eax
f0101e5d:	0f 84 71 07 00 00    	je     f01025d4 <check_page+0x78f>
	assert((pp1 = page_alloc(0)));
f0101e63:	83 ec 0c             	sub    $0xc,%esp
f0101e66:	6a 00                	push   $0x0
f0101e68:	e8 5e f5 ff ff       	call   f01013cb <page_alloc>
f0101e6d:	89 c6                	mov    %eax,%esi
f0101e6f:	83 c4 10             	add    $0x10,%esp
f0101e72:	85 c0                	test   %eax,%eax
f0101e74:	0f 84 73 07 00 00    	je     f01025ed <check_page+0x7a8>
	assert((pp2 = page_alloc(0)));
f0101e7a:	83 ec 0c             	sub    $0xc,%esp
f0101e7d:	6a 00                	push   $0x0
f0101e7f:	e8 47 f5 ff ff       	call   f01013cb <page_alloc>
f0101e84:	89 c3                	mov    %eax,%ebx
f0101e86:	83 c4 10             	add    $0x10,%esp
f0101e89:	85 c0                	test   %eax,%eax
f0101e8b:	0f 84 75 07 00 00    	je     f0102606 <check_page+0x7c1>
	assert(pp1 && pp1 != pp0);
f0101e91:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
f0101e94:	0f 84 85 07 00 00    	je     f010261f <check_page+0x7da>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101e9a:	39 c6                	cmp    %eax,%esi
f0101e9c:	0f 84 96 07 00 00    	je     f0102638 <check_page+0x7f3>
f0101ea2:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101ea5:	0f 84 8d 07 00 00    	je     f0102638 <check_page+0x7f3>
	fl = page_free_list;
f0101eab:	a1 40 82 24 f0       	mov    0xf0248240,%eax
f0101eb0:	89 45 c8             	mov    %eax,-0x38(%ebp)
	page_free_list = 0;
f0101eb3:	c7 05 40 82 24 f0 00 	movl   $0x0,0xf0248240
f0101eba:	00 00 00 
	assert(!page_alloc(0));
f0101ebd:	83 ec 0c             	sub    $0xc,%esp
f0101ec0:	6a 00                	push   $0x0
f0101ec2:	e8 04 f5 ff ff       	call   f01013cb <page_alloc>
f0101ec7:	83 c4 10             	add    $0x10,%esp
f0101eca:	85 c0                	test   %eax,%eax
f0101ecc:	0f 85 7f 07 00 00    	jne    f0102651 <check_page+0x80c>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101ed2:	83 ec 04             	sub    $0x4,%esp
f0101ed5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101ed8:	50                   	push   %eax
f0101ed9:	6a 00                	push   $0x0
f0101edb:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0101ee1:	e8 4a fa ff ff       	call   f0101930 <page_lookup>
f0101ee6:	83 c4 10             	add    $0x10,%esp
f0101ee9:	85 c0                	test   %eax,%eax
f0101eeb:	0f 85 79 07 00 00    	jne    f010266a <check_page+0x825>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101ef1:	6a 02                	push   $0x2
f0101ef3:	6a 00                	push   $0x0
f0101ef5:	56                   	push   %esi
f0101ef6:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0101efc:	e8 ca fb ff ff       	call   f0101acb <page_insert>
f0101f01:	83 c4 10             	add    $0x10,%esp
f0101f04:	85 c0                	test   %eax,%eax
f0101f06:	0f 89 77 07 00 00    	jns    f0102683 <check_page+0x83e>
	page_free(pp0);
f0101f0c:	83 ec 0c             	sub    $0xc,%esp
f0101f0f:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101f12:	e8 ff f4 ff ff       	call   f0101416 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101f17:	6a 02                	push   $0x2
f0101f19:	6a 00                	push   $0x0
f0101f1b:	56                   	push   %esi
f0101f1c:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0101f22:	e8 a4 fb ff ff       	call   f0101acb <page_insert>
f0101f27:	83 c4 20             	add    $0x20,%esp
f0101f2a:	85 c0                	test   %eax,%eax
f0101f2c:	0f 85 6a 07 00 00    	jne    f010269c <check_page+0x857>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101f32:	8b 3d 8c 8e 24 f0    	mov    0xf0248e8c,%edi
f0101f38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f3b:	e8 8c ec ff ff       	call   f0100bcc <page2pa>
f0101f40:	89 c2                	mov    %eax,%edx
f0101f42:	8b 07                	mov    (%edi),%eax
f0101f44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101f49:	39 d0                	cmp    %edx,%eax
f0101f4b:	0f 85 64 07 00 00    	jne    f01026b5 <check_page+0x870>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101f51:	ba 00 00 00 00       	mov    $0x0,%edx
f0101f56:	89 f8                	mov    %edi,%eax
f0101f58:	e8 53 ed ff ff       	call   f0100cb0 <check_va2pa>
f0101f5d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101f60:	89 f0                	mov    %esi,%eax
f0101f62:	e8 65 ec ff ff       	call   f0100bcc <page2pa>
f0101f67:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101f6a:	0f 85 5e 07 00 00    	jne    f01026ce <check_page+0x889>
	assert(pp1->pp_ref == 1);
f0101f70:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101f75:	0f 85 6c 07 00 00    	jne    f01026e7 <check_page+0x8a2>
	assert(pp0->pp_ref == 1);
f0101f7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f7e:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101f83:	0f 85 77 07 00 00    	jne    f0102700 <check_page+0x8bb>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101f89:	6a 02                	push   $0x2
f0101f8b:	68 00 10 00 00       	push   $0x1000
f0101f90:	53                   	push   %ebx
f0101f91:	57                   	push   %edi
f0101f92:	e8 34 fb ff ff       	call   f0101acb <page_insert>
f0101f97:	83 c4 10             	add    $0x10,%esp
f0101f9a:	85 c0                	test   %eax,%eax
f0101f9c:	0f 85 77 07 00 00    	jne    f0102719 <check_page+0x8d4>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101fa2:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101fa7:	a1 8c 8e 24 f0       	mov    0xf0248e8c,%eax
f0101fac:	e8 ff ec ff ff       	call   f0100cb0 <check_va2pa>
f0101fb1:	89 c7                	mov    %eax,%edi
f0101fb3:	89 d8                	mov    %ebx,%eax
f0101fb5:	e8 12 ec ff ff       	call   f0100bcc <page2pa>
f0101fba:	39 c7                	cmp    %eax,%edi
f0101fbc:	0f 85 70 07 00 00    	jne    f0102732 <check_page+0x8ed>
	assert(pp2->pp_ref == 1);
f0101fc2:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101fc7:	0f 85 7e 07 00 00    	jne    f010274b <check_page+0x906>
	assert(!page_alloc(0));
f0101fcd:	83 ec 0c             	sub    $0xc,%esp
f0101fd0:	6a 00                	push   $0x0
f0101fd2:	e8 f4 f3 ff ff       	call   f01013cb <page_alloc>
f0101fd7:	83 c4 10             	add    $0x10,%esp
f0101fda:	85 c0                	test   %eax,%eax
f0101fdc:	0f 85 82 07 00 00    	jne    f0102764 <check_page+0x91f>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0101fe2:	6a 02                	push   $0x2
f0101fe4:	68 00 10 00 00       	push   $0x1000
f0101fe9:	53                   	push   %ebx
f0101fea:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0101ff0:	e8 d6 fa ff ff       	call   f0101acb <page_insert>
f0101ff5:	83 c4 10             	add    $0x10,%esp
f0101ff8:	85 c0                	test   %eax,%eax
f0101ffa:	0f 85 7d 07 00 00    	jne    f010277d <check_page+0x938>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102000:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102005:	a1 8c 8e 24 f0       	mov    0xf0248e8c,%eax
f010200a:	e8 a1 ec ff ff       	call   f0100cb0 <check_va2pa>
f010200f:	89 c7                	mov    %eax,%edi
f0102011:	89 d8                	mov    %ebx,%eax
f0102013:	e8 b4 eb ff ff       	call   f0100bcc <page2pa>
f0102018:	39 c7                	cmp    %eax,%edi
f010201a:	0f 85 76 07 00 00    	jne    f0102796 <check_page+0x951>
	assert(pp2->pp_ref == 1);
f0102020:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102025:	0f 85 84 07 00 00    	jne    f01027af <check_page+0x96a>
	assert(!page_alloc(0));
f010202b:	83 ec 0c             	sub    $0xc,%esp
f010202e:	6a 00                	push   $0x0
f0102030:	e8 96 f3 ff ff       	call   f01013cb <page_alloc>
f0102035:	83 c4 10             	add    $0x10,%esp
f0102038:	85 c0                	test   %eax,%eax
f010203a:	0f 85 88 07 00 00    	jne    f01027c8 <check_page+0x983>
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0102040:	8b 3d 8c 8e 24 f0    	mov    0xf0248e8c,%edi
f0102046:	8b 0f                	mov    (%edi),%ecx
f0102048:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010204e:	ba dc 03 00 00       	mov    $0x3dc,%edx
f0102053:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0102058:	e8 09 ec ff ff       	call   f0100c66 <_kaddr>
f010205d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f0102060:	83 ec 04             	sub    $0x4,%esp
f0102063:	6a 00                	push   $0x0
f0102065:	68 00 10 00 00       	push   $0x1000
f010206a:	57                   	push   %edi
f010206b:	e8 48 f8 ff ff       	call   f01018b8 <pgdir_walk>
f0102070:	89 c2                	mov    %eax,%edx
f0102072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102075:	83 c0 04             	add    $0x4,%eax
f0102078:	83 c4 10             	add    $0x10,%esp
f010207b:	39 d0                	cmp    %edx,%eax
f010207d:	0f 85 5e 07 00 00    	jne    f01027e1 <check_page+0x99c>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f0102083:	6a 06                	push   $0x6
f0102085:	68 00 10 00 00       	push   $0x1000
f010208a:	53                   	push   %ebx
f010208b:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0102091:	e8 35 fa ff ff       	call   f0101acb <page_insert>
f0102096:	83 c4 10             	add    $0x10,%esp
f0102099:	85 c0                	test   %eax,%eax
f010209b:	0f 85 59 07 00 00    	jne    f01027fa <check_page+0x9b5>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01020a1:	8b 3d 8c 8e 24 f0    	mov    0xf0248e8c,%edi
f01020a7:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020ac:	89 f8                	mov    %edi,%eax
f01020ae:	e8 fd eb ff ff       	call   f0100cb0 <check_va2pa>
f01020b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01020b6:	89 d8                	mov    %ebx,%eax
f01020b8:	e8 0f eb ff ff       	call   f0100bcc <page2pa>
f01020bd:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f01020c0:	0f 85 4d 07 00 00    	jne    f0102813 <check_page+0x9ce>
	assert(pp2->pp_ref == 1);
f01020c6:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01020cb:	0f 85 5b 07 00 00    	jne    f010282c <check_page+0x9e7>
	assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f01020d1:	83 ec 04             	sub    $0x4,%esp
f01020d4:	6a 00                	push   $0x0
f01020d6:	68 00 10 00 00       	push   $0x1000
f01020db:	57                   	push   %edi
f01020dc:	e8 d7 f7 ff ff       	call   f01018b8 <pgdir_walk>
f01020e1:	83 c4 10             	add    $0x10,%esp
f01020e4:	f6 00 04             	testb  $0x4,(%eax)
f01020e7:	0f 84 58 07 00 00    	je     f0102845 <check_page+0xa00>
	assert(kern_pgdir[0] & PTE_U);
f01020ed:	a1 8c 8e 24 f0       	mov    0xf0248e8c,%eax
f01020f2:	f6 00 04             	testb  $0x4,(%eax)
f01020f5:	0f 84 63 07 00 00    	je     f010285e <check_page+0xa19>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01020fb:	6a 02                	push   $0x2
f01020fd:	68 00 10 00 00       	push   $0x1000
f0102102:	53                   	push   %ebx
f0102103:	50                   	push   %eax
f0102104:	e8 c2 f9 ff ff       	call   f0101acb <page_insert>
f0102109:	83 c4 10             	add    $0x10,%esp
f010210c:	85 c0                	test   %eax,%eax
f010210e:	0f 85 63 07 00 00    	jne    f0102877 <check_page+0xa32>
	assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0102114:	83 ec 04             	sub    $0x4,%esp
f0102117:	6a 00                	push   $0x0
f0102119:	68 00 10 00 00       	push   $0x1000
f010211e:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0102124:	e8 8f f7 ff ff       	call   f01018b8 <pgdir_walk>
f0102129:	83 c4 10             	add    $0x10,%esp
f010212c:	f6 00 02             	testb  $0x2,(%eax)
f010212f:	0f 84 5b 07 00 00    	je     f0102890 <check_page+0xa4b>
	assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102135:	83 ec 04             	sub    $0x4,%esp
f0102138:	6a 00                	push   $0x0
f010213a:	68 00 10 00 00       	push   $0x1000
f010213f:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0102145:	e8 6e f7 ff ff       	call   f01018b8 <pgdir_walk>
f010214a:	83 c4 10             	add    $0x10,%esp
f010214d:	f6 00 04             	testb  $0x4,(%eax)
f0102150:	0f 85 53 07 00 00    	jne    f01028a9 <check_page+0xa64>
	assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f0102156:	6a 02                	push   $0x2
f0102158:	68 00 00 40 00       	push   $0x400000
f010215d:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102160:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0102166:	e8 60 f9 ff ff       	call   f0101acb <page_insert>
f010216b:	83 c4 10             	add    $0x10,%esp
f010216e:	85 c0                	test   %eax,%eax
f0102170:	0f 89 4c 07 00 00    	jns    f01028c2 <check_page+0xa7d>
	assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f0102176:	6a 02                	push   $0x2
f0102178:	68 00 10 00 00       	push   $0x1000
f010217d:	56                   	push   %esi
f010217e:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0102184:	e8 42 f9 ff ff       	call   f0101acb <page_insert>
f0102189:	83 c4 10             	add    $0x10,%esp
f010218c:	85 c0                	test   %eax,%eax
f010218e:	0f 85 47 07 00 00    	jne    f01028db <check_page+0xa96>
	assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102194:	83 ec 04             	sub    $0x4,%esp
f0102197:	6a 00                	push   $0x0
f0102199:	68 00 10 00 00       	push   $0x1000
f010219e:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f01021a4:	e8 0f f7 ff ff       	call   f01018b8 <pgdir_walk>
f01021a9:	83 c4 10             	add    $0x10,%esp
f01021ac:	f6 00 04             	testb  $0x4,(%eax)
f01021af:	0f 85 3f 07 00 00    	jne    f01028f4 <check_page+0xaaf>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01021b5:	8b 3d 8c 8e 24 f0    	mov    0xf0248e8c,%edi
f01021bb:	ba 00 00 00 00       	mov    $0x0,%edx
f01021c0:	89 f8                	mov    %edi,%eax
f01021c2:	e8 e9 ea ff ff       	call   f0100cb0 <check_va2pa>
f01021c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01021ca:	89 f0                	mov    %esi,%eax
f01021cc:	e8 fb e9 ff ff       	call   f0100bcc <page2pa>
f01021d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01021d4:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f01021d7:	0f 85 30 07 00 00    	jne    f010290d <check_page+0xac8>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01021dd:	ba 00 10 00 00       	mov    $0x1000,%edx
f01021e2:	89 f8                	mov    %edi,%eax
f01021e4:	e8 c7 ea ff ff       	call   f0100cb0 <check_va2pa>
f01021e9:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01021ec:	0f 85 34 07 00 00    	jne    f0102926 <check_page+0xae1>
	assert(pp1->pp_ref == 2);
f01021f2:	66 83 7e 04 02       	cmpw   $0x2,0x4(%esi)
f01021f7:	0f 85 42 07 00 00    	jne    f010293f <check_page+0xafa>
	assert(pp2->pp_ref == 0);
f01021fd:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102202:	0f 85 50 07 00 00    	jne    f0102958 <check_page+0xb13>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102208:	83 ec 0c             	sub    $0xc,%esp
f010220b:	6a 00                	push   $0x0
f010220d:	e8 b9 f1 ff ff       	call   f01013cb <page_alloc>
f0102212:	83 c4 10             	add    $0x10,%esp
f0102215:	39 c3                	cmp    %eax,%ebx
f0102217:	0f 85 54 07 00 00    	jne    f0102971 <check_page+0xb2c>
f010221d:	85 c0                	test   %eax,%eax
f010221f:	0f 84 4c 07 00 00    	je     f0102971 <check_page+0xb2c>
	page_remove(kern_pgdir, 0x0);
f0102225:	83 ec 08             	sub    $0x8,%esp
f0102228:	6a 00                	push   $0x0
f010222a:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0102230:	e8 7b f7 ff ff       	call   f01019b0 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102235:	8b 3d 8c 8e 24 f0    	mov    0xf0248e8c,%edi
f010223b:	ba 00 00 00 00       	mov    $0x0,%edx
f0102240:	89 f8                	mov    %edi,%eax
f0102242:	e8 69 ea ff ff       	call   f0100cb0 <check_va2pa>
f0102247:	83 c4 10             	add    $0x10,%esp
f010224a:	83 f8 ff             	cmp    $0xffffffff,%eax
f010224d:	0f 85 37 07 00 00    	jne    f010298a <check_page+0xb45>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102253:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102258:	89 f8                	mov    %edi,%eax
f010225a:	e8 51 ea ff ff       	call   f0100cb0 <check_va2pa>
f010225f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102262:	89 f0                	mov    %esi,%eax
f0102264:	e8 63 e9 ff ff       	call   f0100bcc <page2pa>
f0102269:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f010226c:	0f 85 31 07 00 00    	jne    f01029a3 <check_page+0xb5e>
	assert(pp1->pp_ref == 1);
f0102272:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102277:	0f 85 3f 07 00 00    	jne    f01029bc <check_page+0xb77>
	assert(pp2->pp_ref == 0);
f010227d:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102282:	0f 85 4d 07 00 00    	jne    f01029d5 <check_page+0xb90>
	assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f0102288:	6a 00                	push   $0x0
f010228a:	68 00 10 00 00       	push   $0x1000
f010228f:	56                   	push   %esi
f0102290:	57                   	push   %edi
f0102291:	e8 35 f8 ff ff       	call   f0101acb <page_insert>
f0102296:	83 c4 10             	add    $0x10,%esp
f0102299:	85 c0                	test   %eax,%eax
f010229b:	0f 85 4d 07 00 00    	jne    f01029ee <check_page+0xba9>
	assert(pp1->pp_ref);
f01022a1:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01022a6:	0f 84 5b 07 00 00    	je     f0102a07 <check_page+0xbc2>
	assert(pp1->pp_link == NULL);
f01022ac:	83 3e 00             	cmpl   $0x0,(%esi)
f01022af:	0f 85 6b 07 00 00    	jne    f0102a20 <check_page+0xbdb>
	page_remove(kern_pgdir, (void *) PGSIZE);
f01022b5:	83 ec 08             	sub    $0x8,%esp
f01022b8:	68 00 10 00 00       	push   $0x1000
f01022bd:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f01022c3:	e8 e8 f6 ff ff       	call   f01019b0 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01022c8:	8b 3d 8c 8e 24 f0    	mov    0xf0248e8c,%edi
f01022ce:	ba 00 00 00 00       	mov    $0x0,%edx
f01022d3:	89 f8                	mov    %edi,%eax
f01022d5:	e8 d6 e9 ff ff       	call   f0100cb0 <check_va2pa>
f01022da:	83 c4 10             	add    $0x10,%esp
f01022dd:	83 f8 ff             	cmp    $0xffffffff,%eax
f01022e0:	0f 85 53 07 00 00    	jne    f0102a39 <check_page+0xbf4>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01022e6:	ba 00 10 00 00       	mov    $0x1000,%edx
f01022eb:	89 f8                	mov    %edi,%eax
f01022ed:	e8 be e9 ff ff       	call   f0100cb0 <check_va2pa>
f01022f2:	83 f8 ff             	cmp    $0xffffffff,%eax
f01022f5:	0f 85 57 07 00 00    	jne    f0102a52 <check_page+0xc0d>
	assert(pp1->pp_ref == 0);
f01022fb:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102300:	0f 85 65 07 00 00    	jne    f0102a6b <check_page+0xc26>
	assert(pp2->pp_ref == 0);
f0102306:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010230b:	0f 85 73 07 00 00    	jne    f0102a84 <check_page+0xc3f>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102311:	83 ec 0c             	sub    $0xc,%esp
f0102314:	6a 00                	push   $0x0
f0102316:	e8 b0 f0 ff ff       	call   f01013cb <page_alloc>
f010231b:	83 c4 10             	add    $0x10,%esp
f010231e:	39 c6                	cmp    %eax,%esi
f0102320:	0f 85 77 07 00 00    	jne    f0102a9d <check_page+0xc58>
f0102326:	85 c0                	test   %eax,%eax
f0102328:	0f 84 6f 07 00 00    	je     f0102a9d <check_page+0xc58>
	assert(!page_alloc(0));
f010232e:	83 ec 0c             	sub    $0xc,%esp
f0102331:	6a 00                	push   $0x0
f0102333:	e8 93 f0 ff ff       	call   f01013cb <page_alloc>
f0102338:	83 c4 10             	add    $0x10,%esp
f010233b:	85 c0                	test   %eax,%eax
f010233d:	0f 85 73 07 00 00    	jne    f0102ab6 <check_page+0xc71>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102343:	8b 3d 8c 8e 24 f0    	mov    0xf0248e8c,%edi
f0102349:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010234c:	e8 7b e8 ff ff       	call   f0100bcc <page2pa>
f0102351:	89 c2                	mov    %eax,%edx
f0102353:	8b 07                	mov    (%edi),%eax
f0102355:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010235a:	39 d0                	cmp    %edx,%eax
f010235c:	0f 85 6d 07 00 00    	jne    f0102acf <check_page+0xc8a>
	kern_pgdir[0] = 0;
f0102362:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	assert(pp0->pp_ref == 1);
f0102368:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010236b:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102370:	0f 85 72 07 00 00    	jne    f0102ae8 <check_page+0xca3>
	pp0->pp_ref = 0;
f0102376:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102379:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	page_free(pp0);
f010237f:	83 ec 0c             	sub    $0xc,%esp
f0102382:	50                   	push   %eax
f0102383:	e8 8e f0 ff ff       	call   f0101416 <page_free>
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102388:	83 c4 0c             	add    $0xc,%esp
f010238b:	6a 01                	push   $0x1
f010238d:	68 00 10 40 00       	push   $0x401000
f0102392:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0102398:	e8 1b f5 ff ff       	call   f01018b8 <pgdir_walk>
f010239d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01023a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01023a3:	8b 3d 8c 8e 24 f0    	mov    0xf0248e8c,%edi
f01023a9:	8b 4f 04             	mov    0x4(%edi),%ecx
f01023ac:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01023b2:	ba 20 04 00 00       	mov    $0x420,%edx
f01023b7:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f01023bc:	e8 a5 e8 ff ff       	call   f0100c66 <_kaddr>
	assert(ptep == ptep1 + PTX(va));
f01023c1:	83 c0 04             	add    $0x4,%eax
f01023c4:	83 c4 10             	add    $0x10,%esp
f01023c7:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f01023ca:	0f 85 31 07 00 00    	jne    f0102b01 <check_page+0xcbc>
	kern_pgdir[PDX(va)] = 0;
f01023d0:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
	pp0->pp_ref = 0;
f01023d7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01023da:	89 f8                	mov    %edi,%eax
f01023dc:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)
	memset(page2kva(pp0), 0xFF, PGSIZE);
f01023e2:	e8 ab e8 ff ff       	call   f0100c92 <page2kva>
f01023e7:	83 ec 04             	sub    $0x4,%esp
f01023ea:	68 00 10 00 00       	push   $0x1000
f01023ef:	68 ff 00 00 00       	push   $0xff
f01023f4:	50                   	push   %eax
f01023f5:	e8 c1 33 00 00       	call   f01057bb <memset>
	page_free(pp0);
f01023fa:	89 3c 24             	mov    %edi,(%esp)
f01023fd:	e8 14 f0 ff ff       	call   f0101416 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0102402:	83 c4 0c             	add    $0xc,%esp
f0102405:	6a 01                	push   $0x1
f0102407:	6a 00                	push   $0x0
f0102409:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f010240f:	e8 a4 f4 ff ff       	call   f01018b8 <pgdir_walk>
	ptep = (pte_t *) page2kva(pp0);
f0102414:	89 f8                	mov    %edi,%eax
f0102416:	e8 77 e8 ff ff       	call   f0100c92 <page2kva>
f010241b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010241e:	89 c2                	mov    %eax,%edx
f0102420:	05 00 10 00 00       	add    $0x1000,%eax
f0102425:	83 c4 10             	add    $0x10,%esp
		assert((ptep[i] & PTE_P) == 0);
f0102428:	f6 02 01             	testb  $0x1,(%edx)
f010242b:	0f 85 e9 06 00 00    	jne    f0102b1a <check_page+0xcd5>
f0102431:	83 c2 04             	add    $0x4,%edx
	for (i = 0; i < NPTENTRIES; i++)
f0102434:	39 c2                	cmp    %eax,%edx
f0102436:	75 f0                	jne    f0102428 <check_page+0x5e3>
	kern_pgdir[0] = 0;
f0102438:	a1 8c 8e 24 f0       	mov    0xf0248e8c,%eax
f010243d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102443:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102446:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	page_free_list = fl;
f010244c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010244f:	89 0d 40 82 24 f0    	mov    %ecx,0xf0248240
	page_free(pp0);
f0102455:	83 ec 0c             	sub    $0xc,%esp
f0102458:	50                   	push   %eax
f0102459:	e8 b8 ef ff ff       	call   f0101416 <page_free>
	page_free(pp1);
f010245e:	89 34 24             	mov    %esi,(%esp)
f0102461:	e8 b0 ef ff ff       	call   f0101416 <page_free>
	page_free(pp2);
f0102466:	89 1c 24             	mov    %ebx,(%esp)
f0102469:	e8 a8 ef ff ff       	call   f0101416 <page_free>
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f010246e:	83 c4 08             	add    $0x8,%esp
f0102471:	68 01 10 00 00       	push   $0x1001
f0102476:	6a 00                	push   $0x0
f0102478:	e8 5a f9 ff ff       	call   f0101dd7 <mmio_map_region>
f010247d:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f010247f:	83 c4 08             	add    $0x8,%esp
f0102482:	68 00 10 00 00       	push   $0x1000
f0102487:	6a 00                	push   $0x0
f0102489:	e8 49 f9 ff ff       	call   f0101dd7 <mmio_map_region>
f010248e:	89 c6                	mov    %eax,%esi
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0102490:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f0102496:	83 c4 10             	add    $0x10,%esp
f0102499:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010249f:	0f 86 8e 06 00 00    	jbe    f0102b33 <check_page+0xcee>
f01024a5:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f01024aa:	0f 87 83 06 00 00    	ja     f0102b33 <check_page+0xcee>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f01024b0:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f01024b6:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f01024bc:	0f 87 8a 06 00 00    	ja     f0102b4c <check_page+0xd07>
f01024c2:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f01024c8:	0f 86 7e 06 00 00    	jbe    f0102b4c <check_page+0xd07>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01024ce:	89 da                	mov    %ebx,%edx
f01024d0:	09 f2                	or     %esi,%edx
f01024d2:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01024d8:	0f 85 87 06 00 00    	jne    f0102b65 <check_page+0xd20>
	assert(mm1 + 8096 <= mm2);
f01024de:	39 f0                	cmp    %esi,%eax
f01024e0:	0f 87 98 06 00 00    	ja     f0102b7e <check_page+0xd39>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01024e6:	8b 3d 8c 8e 24 f0    	mov    0xf0248e8c,%edi
f01024ec:	89 da                	mov    %ebx,%edx
f01024ee:	89 f8                	mov    %edi,%eax
f01024f0:	e8 bb e7 ff ff       	call   f0100cb0 <check_va2pa>
f01024f5:	85 c0                	test   %eax,%eax
f01024f7:	0f 85 9a 06 00 00    	jne    f0102b97 <check_page+0xd52>
	assert(check_va2pa(kern_pgdir, mm1 + PGSIZE) == PGSIZE);
f01024fd:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102503:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102506:	89 c2                	mov    %eax,%edx
f0102508:	89 f8                	mov    %edi,%eax
f010250a:	e8 a1 e7 ff ff       	call   f0100cb0 <check_va2pa>
f010250f:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102514:	0f 85 96 06 00 00    	jne    f0102bb0 <check_page+0xd6b>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f010251a:	89 f2                	mov    %esi,%edx
f010251c:	89 f8                	mov    %edi,%eax
f010251e:	e8 8d e7 ff ff       	call   f0100cb0 <check_va2pa>
f0102523:	85 c0                	test   %eax,%eax
f0102525:	0f 85 9e 06 00 00    	jne    f0102bc9 <check_page+0xd84>
	assert(check_va2pa(kern_pgdir, mm2 + PGSIZE) == ~0);
f010252b:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102531:	89 f8                	mov    %edi,%eax
f0102533:	e8 78 e7 ff ff       	call   f0100cb0 <check_va2pa>
f0102538:	83 f8 ff             	cmp    $0xffffffff,%eax
f010253b:	0f 85 a1 06 00 00    	jne    f0102be2 <check_page+0xd9d>
	assert(*pgdir_walk(kern_pgdir, (void *) mm1, 0) &
f0102541:	83 ec 04             	sub    $0x4,%esp
f0102544:	6a 00                	push   $0x0
f0102546:	53                   	push   %ebx
f0102547:	57                   	push   %edi
f0102548:	e8 6b f3 ff ff       	call   f01018b8 <pgdir_walk>
f010254d:	83 c4 10             	add    $0x10,%esp
f0102550:	f6 00 1a             	testb  $0x1a,(%eax)
f0102553:	0f 84 a2 06 00 00    	je     f0102bfb <check_page+0xdb6>
	assert(!(*pgdir_walk(kern_pgdir, (void *) mm1, 0) & PTE_U));
f0102559:	83 ec 04             	sub    $0x4,%esp
f010255c:	6a 00                	push   $0x0
f010255e:	53                   	push   %ebx
f010255f:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0102565:	e8 4e f3 ff ff       	call   f01018b8 <pgdir_walk>
f010256a:	83 c4 10             	add    $0x10,%esp
f010256d:	f6 00 04             	testb  $0x4,(%eax)
f0102570:	0f 85 9e 06 00 00    	jne    f0102c14 <check_page+0xdcf>
	*pgdir_walk(kern_pgdir, (void *) mm1, 0) = 0;
f0102576:	83 ec 04             	sub    $0x4,%esp
f0102579:	6a 00                	push   $0x0
f010257b:	53                   	push   %ebx
f010257c:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0102582:	e8 31 f3 ff ff       	call   f01018b8 <pgdir_walk>
f0102587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void *) mm1 + PGSIZE, 0) = 0;
f010258d:	83 c4 0c             	add    $0xc,%esp
f0102590:	6a 00                	push   $0x0
f0102592:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102595:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f010259b:	e8 18 f3 ff ff       	call   f01018b8 <pgdir_walk>
f01025a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void *) mm2, 0) = 0;
f01025a6:	83 c4 0c             	add    $0xc,%esp
f01025a9:	6a 00                	push   $0x0
f01025ab:	56                   	push   %esi
f01025ac:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f01025b2:	e8 01 f3 ff ff       	call   f01018b8 <pgdir_walk>
f01025b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	cprintf("check_page() succeeded!\n");
f01025bd:	c7 04 24 d1 76 10 f0 	movl   $0xf01076d1,(%esp)
f01025c4:	e8 a0 12 00 00       	call   f0103869 <cprintf>
}
f01025c9:	83 c4 10             	add    $0x10,%esp
f01025cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01025cf:	5b                   	pop    %ebx
f01025d0:	5e                   	pop    %esi
f01025d1:	5f                   	pop    %edi
f01025d2:	5d                   	pop    %ebp
f01025d3:	c3                   	ret    
	assert((pp0 = page_alloc(0)));
f01025d4:	68 4d 75 10 f0       	push   $0xf010754d
f01025d9:	68 2b 74 10 f0       	push   $0xf010742b
f01025de:	68 ac 03 00 00       	push   $0x3ac
f01025e3:	68 1f 74 10 f0       	push   $0xf010741f
f01025e8:	e8 7d da ff ff       	call   f010006a <_panic>
	assert((pp1 = page_alloc(0)));
f01025ed:	68 63 75 10 f0       	push   $0xf0107563
f01025f2:	68 2b 74 10 f0       	push   $0xf010742b
f01025f7:	68 ad 03 00 00       	push   $0x3ad
f01025fc:	68 1f 74 10 f0       	push   $0xf010741f
f0102601:	e8 64 da ff ff       	call   f010006a <_panic>
	assert((pp2 = page_alloc(0)));
f0102606:	68 79 75 10 f0       	push   $0xf0107579
f010260b:	68 2b 74 10 f0       	push   $0xf010742b
f0102610:	68 ae 03 00 00       	push   $0x3ae
f0102615:	68 1f 74 10 f0       	push   $0xf010741f
f010261a:	e8 4b da ff ff       	call   f010006a <_panic>
	assert(pp1 && pp1 != pp0);
f010261f:	68 8f 75 10 f0       	push   $0xf010758f
f0102624:	68 2b 74 10 f0       	push   $0xf010742b
f0102629:	68 b1 03 00 00       	push   $0x3b1
f010262e:	68 1f 74 10 f0       	push   $0xf010741f
f0102633:	e8 32 da ff ff       	call   f010006a <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102638:	68 bc 6c 10 f0       	push   $0xf0106cbc
f010263d:	68 2b 74 10 f0       	push   $0xf010742b
f0102642:	68 b2 03 00 00       	push   $0x3b2
f0102647:	68 1f 74 10 f0       	push   $0xf010741f
f010264c:	e8 19 da ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f0102651:	68 a1 75 10 f0       	push   $0xf01075a1
f0102656:	68 2b 74 10 f0       	push   $0xf010742b
f010265b:	68 b9 03 00 00       	push   $0x3b9
f0102660:	68 1f 74 10 f0       	push   $0xf010741f
f0102665:	e8 00 da ff ff       	call   f010006a <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f010266a:	68 48 6e 10 f0       	push   $0xf0106e48
f010266f:	68 2b 74 10 f0       	push   $0xf010742b
f0102674:	68 bc 03 00 00       	push   $0x3bc
f0102679:	68 1f 74 10 f0       	push   $0xf010741f
f010267e:	e8 e7 d9 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102683:	68 80 6e 10 f0       	push   $0xf0106e80
f0102688:	68 2b 74 10 f0       	push   $0xf010742b
f010268d:	68 bf 03 00 00       	push   $0x3bf
f0102692:	68 1f 74 10 f0       	push   $0xf010741f
f0102697:	e8 ce d9 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010269c:	68 b0 6e 10 f0       	push   $0xf0106eb0
f01026a1:	68 2b 74 10 f0       	push   $0xf010742b
f01026a6:	68 c3 03 00 00       	push   $0x3c3
f01026ab:	68 1f 74 10 f0       	push   $0xf010741f
f01026b0:	e8 b5 d9 ff ff       	call   f010006a <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01026b5:	68 d0 6d 10 f0       	push   $0xf0106dd0
f01026ba:	68 2b 74 10 f0       	push   $0xf010742b
f01026bf:	68 c4 03 00 00       	push   $0x3c4
f01026c4:	68 1f 74 10 f0       	push   $0xf010741f
f01026c9:	e8 9c d9 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01026ce:	68 e0 6e 10 f0       	push   $0xf0106ee0
f01026d3:	68 2b 74 10 f0       	push   $0xf010742b
f01026d8:	68 c5 03 00 00       	push   $0x3c5
f01026dd:	68 1f 74 10 f0       	push   $0xf010741f
f01026e2:	e8 83 d9 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 1);
f01026e7:	68 f3 75 10 f0       	push   $0xf01075f3
f01026ec:	68 2b 74 10 f0       	push   $0xf010742b
f01026f1:	68 c6 03 00 00       	push   $0x3c6
f01026f6:	68 1f 74 10 f0       	push   $0xf010741f
f01026fb:	e8 6a d9 ff ff       	call   f010006a <_panic>
	assert(pp0->pp_ref == 1);
f0102700:	68 37 76 10 f0       	push   $0xf0107637
f0102705:	68 2b 74 10 f0       	push   $0xf010742b
f010270a:	68 c7 03 00 00       	push   $0x3c7
f010270f:	68 1f 74 10 f0       	push   $0xf010741f
f0102714:	e8 51 d9 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102719:	68 10 6f 10 f0       	push   $0xf0106f10
f010271e:	68 2b 74 10 f0       	push   $0xf010742b
f0102723:	68 cb 03 00 00       	push   $0x3cb
f0102728:	68 1f 74 10 f0       	push   $0xf010741f
f010272d:	e8 38 d9 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102732:	68 4c 6f 10 f0       	push   $0xf0106f4c
f0102737:	68 2b 74 10 f0       	push   $0xf010742b
f010273c:	68 cc 03 00 00       	push   $0x3cc
f0102741:	68 1f 74 10 f0       	push   $0xf010741f
f0102746:	e8 1f d9 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 1);
f010274b:	68 04 76 10 f0       	push   $0xf0107604
f0102750:	68 2b 74 10 f0       	push   $0xf010742b
f0102755:	68 cd 03 00 00       	push   $0x3cd
f010275a:	68 1f 74 10 f0       	push   $0xf010741f
f010275f:	e8 06 d9 ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f0102764:	68 a1 75 10 f0       	push   $0xf01075a1
f0102769:	68 2b 74 10 f0       	push   $0xf010742b
f010276e:	68 d0 03 00 00       	push   $0x3d0
f0102773:	68 1f 74 10 f0       	push   $0xf010741f
f0102778:	e8 ed d8 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f010277d:	68 10 6f 10 f0       	push   $0xf0106f10
f0102782:	68 2b 74 10 f0       	push   $0xf010742b
f0102787:	68 d3 03 00 00       	push   $0x3d3
f010278c:	68 1f 74 10 f0       	push   $0xf010741f
f0102791:	e8 d4 d8 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102796:	68 4c 6f 10 f0       	push   $0xf0106f4c
f010279b:	68 2b 74 10 f0       	push   $0xf010742b
f01027a0:	68 d4 03 00 00       	push   $0x3d4
f01027a5:	68 1f 74 10 f0       	push   $0xf010741f
f01027aa:	e8 bb d8 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 1);
f01027af:	68 04 76 10 f0       	push   $0xf0107604
f01027b4:	68 2b 74 10 f0       	push   $0xf010742b
f01027b9:	68 d5 03 00 00       	push   $0x3d5
f01027be:	68 1f 74 10 f0       	push   $0xf010741f
f01027c3:	e8 a2 d8 ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f01027c8:	68 a1 75 10 f0       	push   $0xf01075a1
f01027cd:	68 2b 74 10 f0       	push   $0xf010742b
f01027d2:	68 d9 03 00 00       	push   $0x3d9
f01027d7:	68 1f 74 10 f0       	push   $0xf010741f
f01027dc:	e8 89 d8 ff ff       	call   f010006a <_panic>
	assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f01027e1:	68 7c 6f 10 f0       	push   $0xf0106f7c
f01027e6:	68 2b 74 10 f0       	push   $0xf010742b
f01027eb:	68 dd 03 00 00       	push   $0x3dd
f01027f0:	68 1f 74 10 f0       	push   $0xf010741f
f01027f5:	e8 70 d8 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f01027fa:	68 c0 6f 10 f0       	push   $0xf0106fc0
f01027ff:	68 2b 74 10 f0       	push   $0xf010742b
f0102804:	68 e0 03 00 00       	push   $0x3e0
f0102809:	68 1f 74 10 f0       	push   $0xf010741f
f010280e:	e8 57 d8 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102813:	68 4c 6f 10 f0       	push   $0xf0106f4c
f0102818:	68 2b 74 10 f0       	push   $0xf010742b
f010281d:	68 e1 03 00 00       	push   $0x3e1
f0102822:	68 1f 74 10 f0       	push   $0xf010741f
f0102827:	e8 3e d8 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 1);
f010282c:	68 04 76 10 f0       	push   $0xf0107604
f0102831:	68 2b 74 10 f0       	push   $0xf010742b
f0102836:	68 e2 03 00 00       	push   $0x3e2
f010283b:	68 1f 74 10 f0       	push   $0xf010741f
f0102840:	e8 25 d8 ff ff       	call   f010006a <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f0102845:	68 04 70 10 f0       	push   $0xf0107004
f010284a:	68 2b 74 10 f0       	push   $0xf010742b
f010284f:	68 e3 03 00 00       	push   $0x3e3
f0102854:	68 1f 74 10 f0       	push   $0xf010741f
f0102859:	e8 0c d8 ff ff       	call   f010006a <_panic>
	assert(kern_pgdir[0] & PTE_U);
f010285e:	68 48 76 10 f0       	push   $0xf0107648
f0102863:	68 2b 74 10 f0       	push   $0xf010742b
f0102868:	68 e4 03 00 00       	push   $0x3e4
f010286d:	68 1f 74 10 f0       	push   $0xf010741f
f0102872:	e8 f3 d7 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102877:	68 10 6f 10 f0       	push   $0xf0106f10
f010287c:	68 2b 74 10 f0       	push   $0xf010742b
f0102881:	68 e7 03 00 00       	push   $0x3e7
f0102886:	68 1f 74 10 f0       	push   $0xf010741f
f010288b:	e8 da d7 ff ff       	call   f010006a <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f0102890:	68 38 70 10 f0       	push   $0xf0107038
f0102895:	68 2b 74 10 f0       	push   $0xf010742b
f010289a:	68 e8 03 00 00       	push   $0x3e8
f010289f:	68 1f 74 10 f0       	push   $0xf010741f
f01028a4:	e8 c1 d7 ff ff       	call   f010006a <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f01028a9:	68 6c 70 10 f0       	push   $0xf010706c
f01028ae:	68 2b 74 10 f0       	push   $0xf010742b
f01028b3:	68 e9 03 00 00       	push   $0x3e9
f01028b8:	68 1f 74 10 f0       	push   $0xf010741f
f01028bd:	e8 a8 d7 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f01028c2:	68 a4 70 10 f0       	push   $0xf01070a4
f01028c7:	68 2b 74 10 f0       	push   $0xf010742b
f01028cc:	68 ed 03 00 00       	push   $0x3ed
f01028d1:	68 1f 74 10 f0       	push   $0xf010741f
f01028d6:	e8 8f d7 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f01028db:	68 e0 70 10 f0       	push   $0xf01070e0
f01028e0:	68 2b 74 10 f0       	push   $0xf010742b
f01028e5:	68 f0 03 00 00       	push   $0x3f0
f01028ea:	68 1f 74 10 f0       	push   $0xf010741f
f01028ef:	e8 76 d7 ff ff       	call   f010006a <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f01028f4:	68 6c 70 10 f0       	push   $0xf010706c
f01028f9:	68 2b 74 10 f0       	push   $0xf010742b
f01028fe:	68 f1 03 00 00       	push   $0x3f1
f0102903:	68 1f 74 10 f0       	push   $0xf010741f
f0102908:	e8 5d d7 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010290d:	68 1c 71 10 f0       	push   $0xf010711c
f0102912:	68 2b 74 10 f0       	push   $0xf010742b
f0102917:	68 f4 03 00 00       	push   $0x3f4
f010291c:	68 1f 74 10 f0       	push   $0xf010741f
f0102921:	e8 44 d7 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102926:	68 48 71 10 f0       	push   $0xf0107148
f010292b:	68 2b 74 10 f0       	push   $0xf010742b
f0102930:	68 f5 03 00 00       	push   $0x3f5
f0102935:	68 1f 74 10 f0       	push   $0xf010741f
f010293a:	e8 2b d7 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 2);
f010293f:	68 5e 76 10 f0       	push   $0xf010765e
f0102944:	68 2b 74 10 f0       	push   $0xf010742b
f0102949:	68 f7 03 00 00       	push   $0x3f7
f010294e:	68 1f 74 10 f0       	push   $0xf010741f
f0102953:	e8 12 d7 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 0);
f0102958:	68 26 76 10 f0       	push   $0xf0107626
f010295d:	68 2b 74 10 f0       	push   $0xf010742b
f0102962:	68 f8 03 00 00       	push   $0x3f8
f0102967:	68 1f 74 10 f0       	push   $0xf010741f
f010296c:	e8 f9 d6 ff ff       	call   f010006a <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102971:	68 78 71 10 f0       	push   $0xf0107178
f0102976:	68 2b 74 10 f0       	push   $0xf010742b
f010297b:	68 fb 03 00 00       	push   $0x3fb
f0102980:	68 1f 74 10 f0       	push   $0xf010741f
f0102985:	e8 e0 d6 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010298a:	68 9c 71 10 f0       	push   $0xf010719c
f010298f:	68 2b 74 10 f0       	push   $0xf010742b
f0102994:	68 ff 03 00 00       	push   $0x3ff
f0102999:	68 1f 74 10 f0       	push   $0xf010741f
f010299e:	e8 c7 d6 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01029a3:	68 48 71 10 f0       	push   $0xf0107148
f01029a8:	68 2b 74 10 f0       	push   $0xf010742b
f01029ad:	68 00 04 00 00       	push   $0x400
f01029b2:	68 1f 74 10 f0       	push   $0xf010741f
f01029b7:	e8 ae d6 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 1);
f01029bc:	68 f3 75 10 f0       	push   $0xf01075f3
f01029c1:	68 2b 74 10 f0       	push   $0xf010742b
f01029c6:	68 01 04 00 00       	push   $0x401
f01029cb:	68 1f 74 10 f0       	push   $0xf010741f
f01029d0:	e8 95 d6 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 0);
f01029d5:	68 26 76 10 f0       	push   $0xf0107626
f01029da:	68 2b 74 10 f0       	push   $0xf010742b
f01029df:	68 02 04 00 00       	push   $0x402
f01029e4:	68 1f 74 10 f0       	push   $0xf010741f
f01029e9:	e8 7c d6 ff ff       	call   f010006a <_panic>
	assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f01029ee:	68 c0 71 10 f0       	push   $0xf01071c0
f01029f3:	68 2b 74 10 f0       	push   $0xf010742b
f01029f8:	68 05 04 00 00       	push   $0x405
f01029fd:	68 1f 74 10 f0       	push   $0xf010741f
f0102a02:	e8 63 d6 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref);
f0102a07:	68 6f 76 10 f0       	push   $0xf010766f
f0102a0c:	68 2b 74 10 f0       	push   $0xf010742b
f0102a11:	68 06 04 00 00       	push   $0x406
f0102a16:	68 1f 74 10 f0       	push   $0xf010741f
f0102a1b:	e8 4a d6 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_link == NULL);
f0102a20:	68 7b 76 10 f0       	push   $0xf010767b
f0102a25:	68 2b 74 10 f0       	push   $0xf010742b
f0102a2a:	68 07 04 00 00       	push   $0x407
f0102a2f:	68 1f 74 10 f0       	push   $0xf010741f
f0102a34:	e8 31 d6 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102a39:	68 9c 71 10 f0       	push   $0xf010719c
f0102a3e:	68 2b 74 10 f0       	push   $0xf010742b
f0102a43:	68 0b 04 00 00       	push   $0x40b
f0102a48:	68 1f 74 10 f0       	push   $0xf010741f
f0102a4d:	e8 18 d6 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102a52:	68 f8 71 10 f0       	push   $0xf01071f8
f0102a57:	68 2b 74 10 f0       	push   $0xf010742b
f0102a5c:	68 0c 04 00 00       	push   $0x40c
f0102a61:	68 1f 74 10 f0       	push   $0xf010741f
f0102a66:	e8 ff d5 ff ff       	call   f010006a <_panic>
	assert(pp1->pp_ref == 0);
f0102a6b:	68 15 76 10 f0       	push   $0xf0107615
f0102a70:	68 2b 74 10 f0       	push   $0xf010742b
f0102a75:	68 0d 04 00 00       	push   $0x40d
f0102a7a:	68 1f 74 10 f0       	push   $0xf010741f
f0102a7f:	e8 e6 d5 ff ff       	call   f010006a <_panic>
	assert(pp2->pp_ref == 0);
f0102a84:	68 26 76 10 f0       	push   $0xf0107626
f0102a89:	68 2b 74 10 f0       	push   $0xf010742b
f0102a8e:	68 0e 04 00 00       	push   $0x40e
f0102a93:	68 1f 74 10 f0       	push   $0xf010741f
f0102a98:	e8 cd d5 ff ff       	call   f010006a <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102a9d:	68 20 72 10 f0       	push   $0xf0107220
f0102aa2:	68 2b 74 10 f0       	push   $0xf010742b
f0102aa7:	68 11 04 00 00       	push   $0x411
f0102aac:	68 1f 74 10 f0       	push   $0xf010741f
f0102ab1:	e8 b4 d5 ff ff       	call   f010006a <_panic>
	assert(!page_alloc(0));
f0102ab6:	68 a1 75 10 f0       	push   $0xf01075a1
f0102abb:	68 2b 74 10 f0       	push   $0xf010742b
f0102ac0:	68 14 04 00 00       	push   $0x414
f0102ac5:	68 1f 74 10 f0       	push   $0xf010741f
f0102aca:	e8 9b d5 ff ff       	call   f010006a <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102acf:	68 d0 6d 10 f0       	push   $0xf0106dd0
f0102ad4:	68 2b 74 10 f0       	push   $0xf010742b
f0102ad9:	68 17 04 00 00       	push   $0x417
f0102ade:	68 1f 74 10 f0       	push   $0xf010741f
f0102ae3:	e8 82 d5 ff ff       	call   f010006a <_panic>
	assert(pp0->pp_ref == 1);
f0102ae8:	68 37 76 10 f0       	push   $0xf0107637
f0102aed:	68 2b 74 10 f0       	push   $0xf010742b
f0102af2:	68 19 04 00 00       	push   $0x419
f0102af7:	68 1f 74 10 f0       	push   $0xf010741f
f0102afc:	e8 69 d5 ff ff       	call   f010006a <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102b01:	68 90 76 10 f0       	push   $0xf0107690
f0102b06:	68 2b 74 10 f0       	push   $0xf010742b
f0102b0b:	68 21 04 00 00       	push   $0x421
f0102b10:	68 1f 74 10 f0       	push   $0xf010741f
f0102b15:	e8 50 d5 ff ff       	call   f010006a <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102b1a:	68 a8 76 10 f0       	push   $0xf01076a8
f0102b1f:	68 2b 74 10 f0       	push   $0xf010742b
f0102b24:	68 2b 04 00 00       	push   $0x42b
f0102b29:	68 1f 74 10 f0       	push   $0xf010741f
f0102b2e:	e8 37 d5 ff ff       	call   f010006a <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0102b33:	68 44 72 10 f0       	push   $0xf0107244
f0102b38:	68 2b 74 10 f0       	push   $0xf010742b
f0102b3d:	68 3b 04 00 00       	push   $0x43b
f0102b42:	68 1f 74 10 f0       	push   $0xf010741f
f0102b47:	e8 1e d5 ff ff       	call   f010006a <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0102b4c:	68 6c 72 10 f0       	push   $0xf010726c
f0102b51:	68 2b 74 10 f0       	push   $0xf010742b
f0102b56:	68 3c 04 00 00       	push   $0x43c
f0102b5b:	68 1f 74 10 f0       	push   $0xf010741f
f0102b60:	e8 05 d5 ff ff       	call   f010006a <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102b65:	68 94 72 10 f0       	push   $0xf0107294
f0102b6a:	68 2b 74 10 f0       	push   $0xf010742b
f0102b6f:	68 3e 04 00 00       	push   $0x43e
f0102b74:	68 1f 74 10 f0       	push   $0xf010741f
f0102b79:	e8 ec d4 ff ff       	call   f010006a <_panic>
	assert(mm1 + 8096 <= mm2);
f0102b7e:	68 bf 76 10 f0       	push   $0xf01076bf
f0102b83:	68 2b 74 10 f0       	push   $0xf010742b
f0102b88:	68 40 04 00 00       	push   $0x440
f0102b8d:	68 1f 74 10 f0       	push   $0xf010741f
f0102b92:	e8 d3 d4 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102b97:	68 bc 72 10 f0       	push   $0xf01072bc
f0102b9c:	68 2b 74 10 f0       	push   $0xf010742b
f0102ba1:	68 42 04 00 00       	push   $0x442
f0102ba6:	68 1f 74 10 f0       	push   $0xf010741f
f0102bab:	e8 ba d4 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, mm1 + PGSIZE) == PGSIZE);
f0102bb0:	68 e0 72 10 f0       	push   $0xf01072e0
f0102bb5:	68 2b 74 10 f0       	push   $0xf010742b
f0102bba:	68 43 04 00 00       	push   $0x443
f0102bbf:	68 1f 74 10 f0       	push   $0xf010741f
f0102bc4:	e8 a1 d4 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102bc9:	68 10 73 10 f0       	push   $0xf0107310
f0102bce:	68 2b 74 10 f0       	push   $0xf010742b
f0102bd3:	68 44 04 00 00       	push   $0x444
f0102bd8:	68 1f 74 10 f0       	push   $0xf010741f
f0102bdd:	e8 88 d4 ff ff       	call   f010006a <_panic>
	assert(check_va2pa(kern_pgdir, mm2 + PGSIZE) == ~0);
f0102be2:	68 34 73 10 f0       	push   $0xf0107334
f0102be7:	68 2b 74 10 f0       	push   $0xf010742b
f0102bec:	68 45 04 00 00       	push   $0x445
f0102bf1:	68 1f 74 10 f0       	push   $0xf010741f
f0102bf6:	e8 6f d4 ff ff       	call   f010006a <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *) mm1, 0) &
f0102bfb:	68 60 73 10 f0       	push   $0xf0107360
f0102c00:	68 2b 74 10 f0       	push   $0xf010742b
f0102c05:	68 47 04 00 00       	push   $0x447
f0102c0a:	68 1f 74 10 f0       	push   $0xf010741f
f0102c0f:	e8 56 d4 ff ff       	call   f010006a <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *) mm1, 0) & PTE_U));
f0102c14:	68 a8 73 10 f0       	push   $0xf01073a8
f0102c19:	68 2b 74 10 f0       	push   $0xf010742b
f0102c1e:	68 49 04 00 00       	push   $0x449
f0102c23:	68 1f 74 10 f0       	push   $0xf010741f
f0102c28:	e8 3d d4 ff ff       	call   f010006a <_panic>

f0102c2d <mem_init>:
{
f0102c2d:	f3 0f 1e fb          	endbr32 
f0102c31:	55                   	push   %ebp
f0102c32:	89 e5                	mov    %esp,%ebp
f0102c34:	53                   	push   %ebx
f0102c35:	83 ec 04             	sub    $0x4,%esp
	i386_detect_memory();
f0102c38:	e8 c5 df ff ff       	call   f0100c02 <i386_detect_memory>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0102c3d:	b8 00 10 00 00       	mov    $0x1000,%eax
f0102c42:	e8 f3 e0 ff ff       	call   f0100d3a <boot_alloc>
f0102c47:	a3 8c 8e 24 f0       	mov    %eax,0xf0248e8c
	memset(kern_pgdir, 0, PGSIZE);
f0102c4c:	83 ec 04             	sub    $0x4,%esp
f0102c4f:	68 00 10 00 00       	push   $0x1000
f0102c54:	6a 00                	push   $0x0
f0102c56:	50                   	push   %eax
f0102c57:	e8 5f 2b 00 00       	call   f01057bb <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0102c5c:	8b 1d 8c 8e 24 f0    	mov    0xf0248e8c,%ebx
f0102c62:	89 d9                	mov    %ebx,%ecx
f0102c64:	ba 95 00 00 00       	mov    $0x95,%edx
f0102c69:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0102c6e:	e8 a5 e0 ff ff       	call   f0100d18 <_paddr>
f0102c73:	83 c8 05             	or     $0x5,%eax
f0102c76:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)
	uint32_t pages_size = npages * sizeof(struct PageInfo);
f0102c7c:	a1 88 8e 24 f0       	mov    0xf0248e88,%eax
f0102c81:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
	pages = (struct PageInfo *) boot_alloc(pages_size);
f0102c88:	89 d8                	mov    %ebx,%eax
f0102c8a:	e8 ab e0 ff ff       	call   f0100d3a <boot_alloc>
f0102c8f:	a3 90 8e 24 f0       	mov    %eax,0xf0248e90
	memset(pages, 0, pages_size);
f0102c94:	83 c4 0c             	add    $0xc,%esp
f0102c97:	53                   	push   %ebx
f0102c98:	6a 00                	push   $0x0
f0102c9a:	50                   	push   %eax
f0102c9b:	e8 1b 2b 00 00       	call   f01057bb <memset>
	envs = (struct Env *) boot_alloc(envs_size);
f0102ca0:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0102ca5:	e8 90 e0 ff ff       	call   f0100d3a <boot_alloc>
f0102caa:	a3 44 82 24 f0       	mov    %eax,0xf0248244
	memset(envs, 0, envs_size);
f0102caf:	83 c4 0c             	add    $0xc,%esp
f0102cb2:	68 00 f0 01 00       	push   $0x1f000
f0102cb7:	6a 00                	push   $0x0
f0102cb9:	50                   	push   %eax
f0102cba:	e8 fc 2a 00 00       	call   f01057bb <memset>
	page_init();
f0102cbf:	e8 75 e6 ff ff       	call   f0101339 <page_init>
	check_page_free_list(1);
f0102cc4:	b8 01 00 00 00       	mov    $0x1,%eax
f0102cc9:	e8 8c e3 ff ff       	call   f010105a <check_page_free_list>
	check_page_alloc();
f0102cce:	e8 99 e7 ff ff       	call   f010146c <check_page_alloc>
	check_page();
f0102cd3:	e8 6d f1 ff ff       	call   f0101e45 <check_page>
	boot_map_region(kern_pgdir,
f0102cd8:	8b 0d 90 8e 24 f0    	mov    0xf0248e90,%ecx
f0102cde:	ba bf 00 00 00       	mov    $0xbf,%edx
f0102ce3:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0102ce8:	e8 2b e0 ff ff       	call   f0100d18 <_paddr>
	                ROUNDUP(pages_size, PGSIZE),
f0102ced:	8d 8b ff 0f 00 00    	lea    0xfff(%ebx),%ecx
	boot_map_region(kern_pgdir,
f0102cf3:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102cf9:	83 c4 08             	add    $0x8,%esp
f0102cfc:	6a 05                	push   $0x5
f0102cfe:	50                   	push   %eax
f0102cff:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102d04:	a1 8c 8e 24 f0       	mov    0xf0248e8c,%eax
f0102d09:	e8 05 ed ff ff       	call   f0101a13 <boot_map_region>
	boot_map_region(kern_pgdir,
f0102d0e:	8b 0d 44 82 24 f0    	mov    0xf0248244,%ecx
f0102d14:	ba cb 00 00 00       	mov    $0xcb,%edx
f0102d19:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0102d1e:	e8 f5 df ff ff       	call   f0100d18 <_paddr>
f0102d23:	83 c4 08             	add    $0x8,%esp
f0102d26:	6a 05                	push   $0x5
f0102d28:	50                   	push   %eax
f0102d29:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f0102d2e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102d33:	a1 8c 8e 24 f0       	mov    0xf0248e8c,%eax
f0102d38:	e8 d6 ec ff ff       	call   f0101a13 <boot_map_region>
	boot_map_region(kern_pgdir,
f0102d3d:	83 c4 08             	add    $0x8,%esp
f0102d40:	6a 03                	push   $0x3
f0102d42:	6a 00                	push   $0x0
f0102d44:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102d49:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102d4e:	a1 8c 8e 24 f0       	mov    0xf0248e8c,%eax
f0102d53:	e8 bb ec ff ff       	call   f0101a13 <boot_map_region>
	mem_init_mp();
f0102d58:	e8 13 ed ff ff       	call   f0101a70 <mem_init_mp>
	check_kern_pgdir();
f0102d5d:	e8 5a e0 ff ff       	call   f0100dbc <check_kern_pgdir>
	lcr3(PADDR(kern_pgdir));
f0102d62:	8b 0d 8c 8e 24 f0    	mov    0xf0248e8c,%ecx
f0102d68:	ba e8 00 00 00       	mov    $0xe8,%edx
f0102d6d:	b8 1f 74 10 f0       	mov    $0xf010741f,%eax
f0102d72:	e8 a1 df ff ff       	call   f0100d18 <_paddr>
f0102d77:	e8 4c de ff ff       	call   f0100bc8 <lcr3>
	check_page_free_list(0);
f0102d7c:	b8 00 00 00 00       	mov    $0x0,%eax
f0102d81:	e8 d4 e2 ff ff       	call   f010105a <check_page_free_list>
	cr0 = rcr0();
f0102d86:	e8 39 de ff ff       	call   f0100bc4 <rcr0>
f0102d8b:	83 e0 f3             	and    $0xfffffff3,%eax
	cr0 &= ~(CR0_TS | CR0_EM);
f0102d8e:	0d 23 00 05 80       	or     $0x80050023,%eax
	lcr0(cr0);
f0102d93:	e8 28 de ff ff       	call   f0100bc0 <lcr0>
	check_page_installed_pgdir();
f0102d98:	e8 8c ed ff ff       	call   f0101b29 <check_page_installed_pgdir>
}
f0102d9d:	83 c4 10             	add    $0x10,%esp
f0102da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102da3:	c9                   	leave  
f0102da4:	c3                   	ret    

f0102da5 <user_mem_check>:
{
f0102da5:	f3 0f 1e fb          	endbr32 
f0102da9:	55                   	push   %ebp
f0102daa:	89 e5                	mov    %esp,%ebp
f0102dac:	57                   	push   %edi
f0102dad:	56                   	push   %esi
f0102dae:	53                   	push   %ebx
f0102daf:	83 ec 0c             	sub    $0xc,%esp
	uint32_t va_hi = ROUNDUP((uint32_t) va + len, PGSIZE);
f0102db2:	8b 45 10             	mov    0x10(%ebp),%eax
f0102db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0102db8:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f0102dbf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	if (va_hi > UTOP) {
f0102dc5:	81 ff 00 00 c0 ee    	cmp    $0xeec00000,%edi
f0102dcb:	77 11                	ja     f0102dde <user_mem_check+0x39>
	for (uint32_t va_act = ROUNDDOWN(va_lo, PGSIZE); va_act < va_hi;
f0102dcd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102dd0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
		if ((!pte) || ((*pte) & (perm | PTE_P)) != (perm | PTE_P)) {
f0102dd6:	8b 75 14             	mov    0x14(%ebp),%esi
f0102dd9:	83 ce 01             	or     $0x1,%esi
	for (uint32_t va_act = ROUNDDOWN(va_lo, PGSIZE); va_act < va_hi;
f0102ddc:	eb 13                	jmp    f0102df1 <user_mem_check+0x4c>
		user_mem_check_addr = va_lo;
f0102dde:	89 0d 3c 82 24 f0    	mov    %ecx,0xf024823c
		return -E_FAULT;
f0102de4:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0102de9:	eb 3c                	jmp    f0102e27 <user_mem_check+0x82>
	     va_act += PGSIZE) {
f0102deb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (uint32_t va_act = ROUNDDOWN(va_lo, PGSIZE); va_act < va_hi;
f0102df1:	39 fb                	cmp    %edi,%ebx
f0102df3:	73 3a                	jae    f0102e2f <user_mem_check+0x8a>
		pte = pgdir_walk(env->env_pgdir, (void *) va_act, 0);
f0102df5:	83 ec 04             	sub    $0x4,%esp
f0102df8:	6a 00                	push   $0x0
f0102dfa:	53                   	push   %ebx
f0102dfb:	8b 45 08             	mov    0x8(%ebp),%eax
f0102dfe:	ff 70 60             	pushl  0x60(%eax)
f0102e01:	e8 b2 ea ff ff       	call   f01018b8 <pgdir_walk>
		if ((!pte) || ((*pte) & (perm | PTE_P)) != (perm | PTE_P)) {
f0102e06:	83 c4 10             	add    $0x10,%esp
f0102e09:	85 c0                	test   %eax,%eax
f0102e0b:	74 08                	je     f0102e15 <user_mem_check+0x70>
f0102e0d:	89 f2                	mov    %esi,%edx
f0102e0f:	23 10                	and    (%eax),%edx
f0102e11:	39 d6                	cmp    %edx,%esi
f0102e13:	74 d6                	je     f0102deb <user_mem_check+0x46>
			user_mem_check_addr = (va_act > va_lo) ? va_act : va_lo;
f0102e15:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f0102e18:	0f 42 5d 0c          	cmovb  0xc(%ebp),%ebx
f0102e1c:	89 1d 3c 82 24 f0    	mov    %ebx,0xf024823c
			return -E_FAULT;
f0102e22:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0102e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102e2a:	5b                   	pop    %ebx
f0102e2b:	5e                   	pop    %esi
f0102e2c:	5f                   	pop    %edi
f0102e2d:	5d                   	pop    %ebp
f0102e2e:	c3                   	ret    
	return 0;
f0102e2f:	b8 00 00 00 00       	mov    $0x0,%eax
f0102e34:	eb f1                	jmp    f0102e27 <user_mem_check+0x82>

f0102e36 <user_mem_assert>:
{
f0102e36:	f3 0f 1e fb          	endbr32 
f0102e3a:	55                   	push   %ebp
f0102e3b:	89 e5                	mov    %esp,%ebp
f0102e3d:	53                   	push   %ebx
f0102e3e:	83 ec 04             	sub    $0x4,%esp
f0102e41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0102e44:	8b 45 14             	mov    0x14(%ebp),%eax
f0102e47:	83 c8 04             	or     $0x4,%eax
f0102e4a:	50                   	push   %eax
f0102e4b:	ff 75 10             	pushl  0x10(%ebp)
f0102e4e:	ff 75 0c             	pushl  0xc(%ebp)
f0102e51:	53                   	push   %ebx
f0102e52:	e8 4e ff ff ff       	call   f0102da5 <user_mem_check>
f0102e57:	83 c4 10             	add    $0x10,%esp
f0102e5a:	85 c0                	test   %eax,%eax
f0102e5c:	78 05                	js     f0102e63 <user_mem_assert+0x2d>
}
f0102e5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102e61:	c9                   	leave  
f0102e62:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0102e63:	83 ec 04             	sub    $0x4,%esp
f0102e66:	ff 35 3c 82 24 f0    	pushl  0xf024823c
f0102e6c:	ff 73 48             	pushl  0x48(%ebx)
f0102e6f:	68 dc 73 10 f0       	push   $0xf01073dc
f0102e74:	e8 f0 09 00 00       	call   f0103869 <cprintf>
		env_destroy(env);  // may not return
f0102e79:	89 1c 24             	mov    %ebx,(%esp)
f0102e7c:	e8 92 06 00 00       	call   f0103513 <env_destroy>
f0102e81:	83 c4 10             	add    $0x10,%esp
}
f0102e84:	eb d8                	jmp    f0102e5e <user_mem_assert+0x28>

f0102e86 <lgdt>:
	asm volatile("lgdt (%0)" : : "r" (p));
f0102e86:	0f 01 10             	lgdtl  (%eax)
}
f0102e89:	c3                   	ret    

f0102e8a <lldt>:
	asm volatile("lldt %0" : : "r" (sel));
f0102e8a:	0f 00 d0             	lldt   %ax
}
f0102e8d:	c3                   	ret    

f0102e8e <lcr3>:
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102e8e:	0f 22 d8             	mov    %eax,%cr3
}
f0102e91:	c3                   	ret    

f0102e92 <page2pa>:
	return (pp - pages) << PGSHIFT;
f0102e92:	2b 05 90 8e 24 f0    	sub    0xf0248e90,%eax
f0102e98:	c1 f8 03             	sar    $0x3,%eax
f0102e9b:	c1 e0 0c             	shl    $0xc,%eax
}
f0102e9e:	c3                   	ret    

f0102e9f <_kaddr>:
{
f0102e9f:	55                   	push   %ebp
f0102ea0:	89 e5                	mov    %esp,%ebp
f0102ea2:	53                   	push   %ebx
f0102ea3:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0102ea6:	89 cb                	mov    %ecx,%ebx
f0102ea8:	c1 eb 0c             	shr    $0xc,%ebx
f0102eab:	3b 1d 88 8e 24 f0    	cmp    0xf0248e88,%ebx
f0102eb1:	73 0b                	jae    f0102ebe <_kaddr+0x1f>
	return (void *)(pa + KERNBASE);
f0102eb3:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0102eb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102ebc:	c9                   	leave  
f0102ebd:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102ebe:	51                   	push   %ecx
f0102ebf:	68 2c 65 10 f0       	push   $0xf010652c
f0102ec4:	52                   	push   %edx
f0102ec5:	50                   	push   %eax
f0102ec6:	e8 9f d1 ff ff       	call   f010006a <_panic>

f0102ecb <page2kva>:
{
f0102ecb:	55                   	push   %ebp
f0102ecc:	89 e5                	mov    %esp,%ebp
f0102ece:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
f0102ed1:	e8 bc ff ff ff       	call   f0102e92 <page2pa>
f0102ed6:	89 c1                	mov    %eax,%ecx
f0102ed8:	ba 58 00 00 00       	mov    $0x58,%edx
f0102edd:	b8 11 74 10 f0       	mov    $0xf0107411,%eax
f0102ee2:	e8 b8 ff ff ff       	call   f0102e9f <_kaddr>
}
f0102ee7:	c9                   	leave  
f0102ee8:	c3                   	ret    

f0102ee9 <_paddr>:
	if ((uint32_t)kva < KERNBASE)
f0102ee9:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0102eef:	76 07                	jbe    f0102ef8 <_paddr+0xf>
	return (physaddr_t)kva - KERNBASE;
f0102ef1:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0102ef7:	c3                   	ret    
{
f0102ef8:	55                   	push   %ebp
f0102ef9:	89 e5                	mov    %esp,%ebp
f0102efb:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102efe:	51                   	push   %ecx
f0102eff:	68 50 65 10 f0       	push   $0xf0106550
f0102f04:	52                   	push   %edx
f0102f05:	50                   	push   %eax
f0102f06:	e8 5f d1 ff ff       	call   f010006a <_panic>

f0102f0b <env_setup_vm>:
// Returns 0 on success, < 0 on error.  Errors include:
//	-E_NO_MEM if page directory or table could not be allocated.
//
static int
env_setup_vm(struct Env *e)
{
f0102f0b:	55                   	push   %ebp
f0102f0c:	89 e5                	mov    %esp,%ebp
f0102f0e:	56                   	push   %esi
f0102f0f:	53                   	push   %ebx
f0102f10:	89 c6                	mov    %eax,%esi
	int r;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f0102f12:	83 ec 0c             	sub    $0xc,%esp
f0102f15:	6a 01                	push   $0x1
f0102f17:	e8 af e4 ff ff       	call   f01013cb <page_alloc>
f0102f1c:	83 c4 10             	add    $0x10,%esp
f0102f1f:	85 c0                	test   %eax,%eax
f0102f21:	74 4f                	je     f0102f72 <env_setup_vm+0x67>
f0102f23:	89 c3                	mov    %eax,%ebx
	//    - Note: In general, pp_ref is not maintained for
	//	physical pages mapped only above UTOP, but env_pgdir
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.
	e->env_pgdir = (uint32_t *) page2kva(p);
f0102f25:	e8 a1 ff ff ff       	call   f0102ecb <page2kva>
f0102f2a:	89 46 60             	mov    %eax,0x60(%esi)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f0102f2d:	83 ec 04             	sub    $0x4,%esp
f0102f30:	68 00 10 00 00       	push   $0x1000
f0102f35:	ff 35 8c 8e 24 f0    	pushl  0xf0248e8c
f0102f3b:	50                   	push   %eax
f0102f3c:	e8 2e 29 00 00       	call   f010586f <memcpy>
	p->pp_ref++;
f0102f41:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)


	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0102f46:	8b 5e 60             	mov    0x60(%esi),%ebx
f0102f49:	89 d9                	mov    %ebx,%ecx
f0102f4b:	ba c1 00 00 00       	mov    $0xc1,%edx
f0102f50:	b8 5a 77 10 f0       	mov    $0xf010775a,%eax
f0102f55:	e8 8f ff ff ff       	call   f0102ee9 <_paddr>
f0102f5a:	83 c8 05             	or     $0x5,%eax
f0102f5d:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)
	return 0;
f0102f63:	83 c4 10             	add    $0x10,%esp
f0102f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0102f6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0102f6e:	5b                   	pop    %ebx
f0102f6f:	5e                   	pop    %esi
f0102f70:	5d                   	pop    %ebp
f0102f71:	c3                   	ret    
		return -E_NO_MEM;
f0102f72:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0102f77:	eb f2                	jmp    f0102f6b <env_setup_vm+0x60>

f0102f79 <pa2page>:
	if (PGNUM(pa) >= npages)
f0102f79:	c1 e8 0c             	shr    $0xc,%eax
f0102f7c:	3b 05 88 8e 24 f0    	cmp    0xf0248e88,%eax
f0102f82:	73 0a                	jae    f0102f8e <pa2page+0x15>
	return &pages[PGNUM(pa)];
f0102f84:	8b 15 90 8e 24 f0    	mov    0xf0248e90,%edx
f0102f8a:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0102f8d:	c3                   	ret    
{
f0102f8e:	55                   	push   %ebp
f0102f8f:	89 e5                	mov    %esp,%ebp
f0102f91:	83 ec 0c             	sub    $0xc,%esp
		panic("pa2page called with invalid pa");
f0102f94:	68 7c 6c 10 f0       	push   $0xf0106c7c
f0102f99:	6a 51                	push   $0x51
f0102f9b:	68 11 74 10 f0       	push   $0xf0107411
f0102fa0:	e8 c5 d0 ff ff       	call   f010006a <_panic>

f0102fa5 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0102fa5:	55                   	push   %ebp
f0102fa6:	89 e5                	mov    %esp,%ebp
f0102fa8:	57                   	push   %edi
f0102fa9:	56                   	push   %esi
f0102faa:	53                   	push   %ebx
f0102fab:	83 ec 0c             	sub    $0xc,%esp
f0102fae:	89 c7                	mov    %eax,%edi
	uint32_t va_lo = ROUNDDOWN((uint32_t) va, PGSIZE);
f0102fb0:	89 d3                	mov    %edx,%ebx
f0102fb2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t va_hi = ROUNDUP((uint32_t) va + len, PGSIZE);
f0102fb8:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f0102fbf:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (va_hi > UTOP)
f0102fc5:	81 fe 00 00 c0 ee    	cmp    $0xeec00000,%esi
f0102fcb:	77 30                	ja     f0102ffd <region_alloc+0x58>
		panic("region_alloc: cannot map in high va\n");

	struct PageInfo *p;
	for (uint32_t va_act = va_lo; va_act < va_hi; va_act += PGSIZE) {
f0102fcd:	39 f3                	cmp    %esi,%ebx
f0102fcf:	73 71                	jae    f0103042 <region_alloc+0x9d>
		if (!(p = page_alloc(!ALLOC_ZERO)))
f0102fd1:	83 ec 0c             	sub    $0xc,%esp
f0102fd4:	6a 00                	push   $0x0
f0102fd6:	e8 f0 e3 ff ff       	call   f01013cb <page_alloc>
f0102fdb:	83 c4 10             	add    $0x10,%esp
f0102fde:	85 c0                	test   %eax,%eax
f0102fe0:	74 32                	je     f0103014 <region_alloc+0x6f>
			panic("region_alloc: could not alloc page\n");
		if (page_insert(e->env_pgdir, p, (uint32_t *) va_act, PTE_U | PTE_W))
f0102fe2:	6a 06                	push   $0x6
f0102fe4:	53                   	push   %ebx
f0102fe5:	50                   	push   %eax
f0102fe6:	ff 77 60             	pushl  0x60(%edi)
f0102fe9:	e8 dd ea ff ff       	call   f0101acb <page_insert>
f0102fee:	83 c4 10             	add    $0x10,%esp
f0102ff1:	85 c0                	test   %eax,%eax
f0102ff3:	75 36                	jne    f010302b <region_alloc+0x86>
	for (uint32_t va_act = va_lo; va_act < va_hi; va_act += PGSIZE) {
f0102ff5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102ffb:	eb d0                	jmp    f0102fcd <region_alloc+0x28>
		panic("region_alloc: cannot map in high va\n");
f0102ffd:	83 ec 04             	sub    $0x4,%esp
f0103000:	68 ec 76 10 f0       	push   $0xf01076ec
f0103005:	68 19 01 00 00       	push   $0x119
f010300a:	68 5a 77 10 f0       	push   $0xf010775a
f010300f:	e8 56 d0 ff ff       	call   f010006a <_panic>
			panic("region_alloc: could not alloc page\n");
f0103014:	83 ec 04             	sub    $0x4,%esp
f0103017:	68 14 77 10 f0       	push   $0xf0107714
f010301c:	68 1e 01 00 00       	push   $0x11e
f0103021:	68 5a 77 10 f0       	push   $0xf010775a
f0103026:	e8 3f d0 ff ff       	call   f010006a <_panic>
			panic("region_alloc: page_insert falied\n");
f010302b:	83 ec 04             	sub    $0x4,%esp
f010302e:	68 38 77 10 f0       	push   $0xf0107738
f0103033:	68 20 01 00 00       	push   $0x120
f0103038:	68 5a 77 10 f0       	push   $0xf010775a
f010303d:	e8 28 d0 ff ff       	call   f010006a <_panic>

	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
}
f0103042:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103045:	5b                   	pop    %ebx
f0103046:	5e                   	pop    %esi
f0103047:	5f                   	pop    %edi
f0103048:	5d                   	pop    %ebp
f0103049:	c3                   	ret    

f010304a <load_icode>:
// load_icode panics if it encounters problems.
//  - How might load_icode fail?  What might be wrong with the given input?
//
static void
load_icode(struct Env *e, uint8_t *binary)
{
f010304a:	55                   	push   %ebp
f010304b:	89 e5                	mov    %esp,%ebp
f010304d:	57                   	push   %edi
f010304e:	56                   	push   %esi
f010304f:	53                   	push   %ebx
f0103050:	83 ec 24             	sub    $0x24,%esp
f0103053:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103056:	89 d7                	mov    %edx,%edi
	//  You must also do something with the program's entry point,
	//  to make sure that the environment starts executing there.

	// Get elf file header
	struct Elf *elf = (struct Elf *) binary;
	cprintf("%p\n", elf);
f0103058:	52                   	push   %edx
f0103059:	68 65 77 10 f0       	push   $0xf0107765
f010305e:	e8 06 08 00 00       	call   f0103869 <cprintf>
	if (elf->e_magic != ELF_MAGIC)
f0103063:	83 c4 10             	add    $0x10,%esp
f0103066:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f010306c:	75 2a                	jne    f0103098 <load_icode+0x4e>
		panic("load_icode: not an elf file\n");

	lcr3(PADDR(e->env_pgdir));
f010306e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103071:	8b 48 60             	mov    0x60(%eax),%ecx
f0103074:	ba 63 01 00 00       	mov    $0x163,%edx
f0103079:	b8 5a 77 10 f0       	mov    $0xf010775a,%eax
f010307e:	e8 66 fe ff ff       	call   f0102ee9 <_paddr>
f0103083:	e8 06 fe ff ff       	call   f0102e8e <lcr3>

	struct Proghdr *ph, *ph_last;

	ph = (struct Proghdr *) ((char *) (binary) + elf->e_phoff);
f0103088:	89 fb                	mov    %edi,%ebx
f010308a:	03 5f 1c             	add    0x1c(%edi),%ebx
	ph_last = ph + elf->e_phnum;
f010308d:	0f b7 77 2c          	movzwl 0x2c(%edi),%esi
f0103091:	c1 e6 05             	shl    $0x5,%esi
f0103094:	01 de                	add    %ebx,%esi

	for (; ph < ph_last; ph++) {
f0103096:	eb 1a                	jmp    f01030b2 <load_icode+0x68>
		panic("load_icode: not an elf file\n");
f0103098:	83 ec 04             	sub    $0x4,%esp
f010309b:	68 69 77 10 f0       	push   $0xf0107769
f01030a0:	68 61 01 00 00       	push   $0x161
f01030a5:	68 5a 77 10 f0       	push   $0xf010775a
f01030aa:	e8 bb cf ff ff       	call   f010006a <_panic>
	for (; ph < ph_last; ph++) {
f01030af:	83 c3 20             	add    $0x20,%ebx
f01030b2:	39 f3                	cmp    %esi,%ebx
f01030b4:	73 3c                	jae    f01030f2 <load_icode+0xa8>
		if (ph->p_type != ELF_PROG_LOAD)
f01030b6:	83 3b 01             	cmpl   $0x1,(%ebx)
f01030b9:	75 f4                	jne    f01030af <load_icode+0x65>
			continue;

		region_alloc(e, (void *) ph->p_va, ph->p_memsz);
f01030bb:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01030be:	8b 53 08             	mov    0x8(%ebx),%edx
f01030c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01030c4:	e8 dc fe ff ff       	call   f0102fa5 <region_alloc>
		memset((uint32_t *) ph->p_va, 0x0, ph->p_memsz);
f01030c9:	83 ec 04             	sub    $0x4,%esp
f01030cc:	ff 73 14             	pushl  0x14(%ebx)
f01030cf:	6a 00                	push   $0x0
f01030d1:	ff 73 08             	pushl  0x8(%ebx)
f01030d4:	e8 e2 26 00 00       	call   f01057bb <memset>
		memcpy((uint32_t *) ph->p_va,
f01030d9:	83 c4 0c             	add    $0xc,%esp
f01030dc:	ff 73 10             	pushl  0x10(%ebx)
f01030df:	89 f8                	mov    %edi,%eax
f01030e1:	03 43 04             	add    0x4(%ebx),%eax
f01030e4:	50                   	push   %eax
f01030e5:	ff 73 08             	pushl  0x8(%ebx)
f01030e8:	e8 82 27 00 00       	call   f010586f <memcpy>
f01030ed:	83 c4 10             	add    $0x10,%esp
f01030f0:	eb bd                	jmp    f01030af <load_icode+0x65>
	}


	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.
	region_alloc(e, (void *) (USTACKTOP - PGSIZE), PGSIZE);
f01030f2:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01030f7:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01030fc:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01030ff:	89 f0                	mov    %esi,%eax
f0103101:	e8 9f fe ff ff       	call   f0102fa5 <region_alloc>

	// Setting entry point
	e->env_tf.tf_eip = elf->e_entry;
f0103106:	8b 47 18             	mov    0x18(%edi),%eax
f0103109:	89 46 30             	mov    %eax,0x30(%esi)

	lcr3(PADDR(kern_pgdir));
f010310c:	8b 0d 8c 8e 24 f0    	mov    0xf0248e8c,%ecx
f0103112:	ba 7d 01 00 00       	mov    $0x17d,%edx
f0103117:	b8 5a 77 10 f0       	mov    $0xf010775a,%eax
f010311c:	e8 c8 fd ff ff       	call   f0102ee9 <_paddr>
f0103121:	e8 68 fd ff ff       	call   f0102e8e <lcr3>
}
f0103126:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103129:	5b                   	pop    %ebx
f010312a:	5e                   	pop    %esi
f010312b:	5f                   	pop    %edi
f010312c:	5d                   	pop    %ebp
f010312d:	c3                   	ret    

f010312e <unlock_kernel>:

static inline void
unlock_kernel(void)
{
f010312e:	55                   	push   %ebp
f010312f:	89 e5                	mov    %esp,%ebp
f0103131:	83 ec 14             	sub    $0x14,%esp
	spin_unlock(&kernel_lock);
f0103134:	68 c0 23 12 f0       	push   $0xf01223c0
f0103139:	e8 79 30 00 00       	call   f01061b7 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f010313e:	f3 90                	pause  
}
f0103140:	83 c4 10             	add    $0x10,%esp
f0103143:	c9                   	leave  
f0103144:	c3                   	ret    

f0103145 <envid2env>:
{
f0103145:	f3 0f 1e fb          	endbr32 
f0103149:	55                   	push   %ebp
f010314a:	89 e5                	mov    %esp,%ebp
f010314c:	56                   	push   %esi
f010314d:	53                   	push   %ebx
f010314e:	8b 75 08             	mov    0x8(%ebp),%esi
f0103151:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f0103154:	85 f6                	test   %esi,%esi
f0103156:	74 2e                	je     f0103186 <envid2env+0x41>
	e = &envs[ENVX(envid)];
f0103158:	89 f3                	mov    %esi,%ebx
f010315a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103160:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103163:	03 1d 44 82 24 f0    	add    0xf0248244,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103169:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f010316d:	74 2e                	je     f010319d <envid2env+0x58>
f010316f:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103172:	75 29                	jne    f010319d <envid2env+0x58>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103174:	84 c0                	test   %al,%al
f0103176:	75 35                	jne    f01031ad <envid2env+0x68>
	*env_store = e;
f0103178:	8b 45 0c             	mov    0xc(%ebp),%eax
f010317b:	89 18                	mov    %ebx,(%eax)
	return 0;
f010317d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103182:	5b                   	pop    %ebx
f0103183:	5e                   	pop    %esi
f0103184:	5d                   	pop    %ebp
f0103185:	c3                   	ret    
		*env_store = curenv;
f0103186:	e8 c1 2c 00 00       	call   f0105e4c <cpunum>
f010318b:	6b c0 74             	imul   $0x74,%eax,%eax
f010318e:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f0103194:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103197:	89 02                	mov    %eax,(%edx)
		return 0;
f0103199:	89 f0                	mov    %esi,%eax
f010319b:	eb e5                	jmp    f0103182 <envid2env+0x3d>
		*env_store = 0;
f010319d:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01031a6:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01031ab:	eb d5                	jmp    f0103182 <envid2env+0x3d>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01031ad:	e8 9a 2c 00 00       	call   f0105e4c <cpunum>
f01031b2:	6b c0 74             	imul   $0x74,%eax,%eax
f01031b5:	39 98 28 90 24 f0    	cmp    %ebx,-0xfdb6fd8(%eax)
f01031bb:	74 bb                	je     f0103178 <envid2env+0x33>
f01031bd:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01031c0:	e8 87 2c 00 00       	call   f0105e4c <cpunum>
f01031c5:	6b c0 74             	imul   $0x74,%eax,%eax
f01031c8:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f01031ce:	3b 70 48             	cmp    0x48(%eax),%esi
f01031d1:	74 a5                	je     f0103178 <envid2env+0x33>
		*env_store = 0;
f01031d3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01031dc:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01031e1:	eb 9f                	jmp    f0103182 <envid2env+0x3d>

f01031e3 <env_init_percpu>:
{
f01031e3:	f3 0f 1e fb          	endbr32 
f01031e7:	55                   	push   %ebp
f01031e8:	89 e5                	mov    %esp,%ebp
f01031ea:	83 ec 08             	sub    $0x8,%esp
	lgdt(&gdt_pd);
f01031ed:	b8 20 23 12 f0       	mov    $0xf0122320,%eax
f01031f2:	e8 8f fc ff ff       	call   f0102e86 <lgdt>
	asm volatile("movw %%ax,%%gs" : : "a"(GD_UD | 3));
f01031f7:	b8 23 00 00 00       	mov    $0x23,%eax
f01031fc:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a"(GD_UD | 3));
f01031fe:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a"(GD_KD));
f0103200:	b8 10 00 00 00       	mov    $0x10,%eax
f0103205:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a"(GD_KD));
f0103207:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a"(GD_KD));
f0103209:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i"(GD_KT));
f010320b:	ea 12 32 10 f0 08 00 	ljmp   $0x8,$0xf0103212
	lldt(0);
f0103212:	b8 00 00 00 00       	mov    $0x0,%eax
f0103217:	e8 6e fc ff ff       	call   f0102e8a <lldt>
}
f010321c:	c9                   	leave  
f010321d:	c3                   	ret    

f010321e <env_init>:
{
f010321e:	f3 0f 1e fb          	endbr32 
f0103222:	55                   	push   %ebp
f0103223:	89 e5                	mov    %esp,%ebp
f0103225:	83 ec 08             	sub    $0x8,%esp
		envs[i].env_id = 0;
f0103228:	8b 15 44 82 24 f0    	mov    0xf0248244,%edx
f010322e:	8d 42 7c             	lea    0x7c(%edx),%eax
f0103231:	81 c2 7c f0 01 00    	add    $0x1f07c,%edx
f0103237:	c7 40 cc 00 00 00 00 	movl   $0x0,-0x34(%eax)
		envs[i].env_status = ENV_FREE;
f010323e:	c7 40 d8 00 00 00 00 	movl   $0x0,-0x28(%eax)
		envs[i].env_link = (envs + i + 1);
f0103245:	89 40 c8             	mov    %eax,-0x38(%eax)
f0103248:	83 c0 7c             	add    $0x7c,%eax
	for (int i = 0; i < NENV; i++) {
f010324b:	39 d0                	cmp    %edx,%eax
f010324d:	75 e8                	jne    f0103237 <env_init+0x19>
	envs[NENV - 1].env_link = NULL;
f010324f:	a1 44 82 24 f0       	mov    0xf0248244,%eax
f0103254:	c7 80 c8 ef 01 00 00 	movl   $0x0,0x1efc8(%eax)
f010325b:	00 00 00 
	env_free_list = envs;
f010325e:	a3 48 82 24 f0       	mov    %eax,0xf0248248
	env_init_percpu();
f0103263:	e8 7b ff ff ff       	call   f01031e3 <env_init_percpu>
}
f0103268:	c9                   	leave  
f0103269:	c3                   	ret    

f010326a <env_alloc>:
{
f010326a:	f3 0f 1e fb          	endbr32 
f010326e:	55                   	push   %ebp
f010326f:	89 e5                	mov    %esp,%ebp
f0103271:	53                   	push   %ebx
f0103272:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f0103275:	8b 1d 48 82 24 f0    	mov    0xf0248248,%ebx
f010327b:	85 db                	test   %ebx,%ebx
f010327d:	0f 84 e9 00 00 00    	je     f010336c <env_alloc+0x102>
	if ((r = env_setup_vm(e)) < 0)
f0103283:	89 d8                	mov    %ebx,%eax
f0103285:	e8 81 fc ff ff       	call   f0102f0b <env_setup_vm>
f010328a:	85 c0                	test   %eax,%eax
f010328c:	0f 88 d5 00 00 00    	js     f0103367 <env_alloc+0xfd>
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103292:	8b 43 48             	mov    0x48(%ebx),%eax
f0103295:	05 00 10 00 00       	add    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
f010329a:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f010329f:	ba 00 10 00 00       	mov    $0x1000,%edx
f01032a4:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01032a7:	89 da                	mov    %ebx,%edx
f01032a9:	2b 15 44 82 24 f0    	sub    0xf0248244,%edx
f01032af:	c1 fa 02             	sar    $0x2,%edx
f01032b2:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01032b8:	09 d0                	or     %edx,%eax
f01032ba:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f01032bd:	8b 45 0c             	mov    0xc(%ebp),%eax
f01032c0:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01032c3:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01032ca:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01032d1:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01032d8:	83 ec 04             	sub    $0x4,%esp
f01032db:	6a 44                	push   $0x44
f01032dd:	6a 00                	push   $0x0
f01032df:	53                   	push   %ebx
f01032e0:	e8 d6 24 00 00       	call   f01057bb <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f01032e5:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01032eb:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01032f1:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f01032f7:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f01032fe:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103304:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f010330b:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f0103312:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f0103316:	8b 43 44             	mov    0x44(%ebx),%eax
f0103319:	a3 48 82 24 f0       	mov    %eax,0xf0248248
	*newenv_store = e;
f010331e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103321:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103323:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103326:	e8 21 2b 00 00       	call   f0105e4c <cpunum>
f010332b:	6b c0 74             	imul   $0x74,%eax,%eax
f010332e:	83 c4 10             	add    $0x10,%esp
f0103331:	ba 00 00 00 00       	mov    $0x0,%edx
f0103336:	83 b8 28 90 24 f0 00 	cmpl   $0x0,-0xfdb6fd8(%eax)
f010333d:	74 11                	je     f0103350 <env_alloc+0xe6>
f010333f:	e8 08 2b 00 00       	call   f0105e4c <cpunum>
f0103344:	6b c0 74             	imul   $0x74,%eax,%eax
f0103347:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f010334d:	8b 50 48             	mov    0x48(%eax),%edx
f0103350:	83 ec 04             	sub    $0x4,%esp
f0103353:	53                   	push   %ebx
f0103354:	52                   	push   %edx
f0103355:	68 86 77 10 f0       	push   $0xf0107786
f010335a:	e8 0a 05 00 00       	call   f0103869 <cprintf>
	return 0;
f010335f:	83 c4 10             	add    $0x10,%esp
f0103362:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103367:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010336a:	c9                   	leave  
f010336b:	c3                   	ret    
		return -E_NO_FREE_ENV;
f010336c:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103371:	eb f4                	jmp    f0103367 <env_alloc+0xfd>

f0103373 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103373:	f3 0f 1e fb          	endbr32 
f0103377:	55                   	push   %ebp
f0103378:	89 e5                	mov    %esp,%ebp
f010337a:	83 ec 20             	sub    $0x20,%esp
	struct Env *env;
	int err = env_alloc(&env, 0x0);
f010337d:	6a 00                	push   $0x0
f010337f:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103382:	50                   	push   %eax
f0103383:	e8 e2 fe ff ff       	call   f010326a <env_alloc>
	if (err < 0)
f0103388:	83 c4 10             	add    $0x10,%esp
f010338b:	85 c0                	test   %eax,%eax
f010338d:	78 16                	js     f01033a5 <env_create+0x32>
		panic("env_create: %e\n", err);

	load_icode(env, binary);
f010338f:	8b 55 08             	mov    0x8(%ebp),%edx
f0103392:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103395:	e8 b0 fc ff ff       	call   f010304a <load_icode>
	env->env_type = type;
f010339a:	8b 55 0c             	mov    0xc(%ebp),%edx
f010339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01033a0:	89 50 50             	mov    %edx,0x50(%eax)
}
f01033a3:	c9                   	leave  
f01033a4:	c3                   	ret    
		panic("env_create: %e\n", err);
f01033a5:	50                   	push   %eax
f01033a6:	68 9b 77 10 f0       	push   $0xf010779b
f01033ab:	68 8d 01 00 00       	push   $0x18d
f01033b0:	68 5a 77 10 f0       	push   $0xf010775a
f01033b5:	e8 b0 cc ff ff       	call   f010006a <_panic>

f01033ba <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f01033ba:	f3 0f 1e fb          	endbr32 
f01033be:	55                   	push   %ebp
f01033bf:	89 e5                	mov    %esp,%ebp
f01033c1:	57                   	push   %edi
f01033c2:	56                   	push   %esi
f01033c3:	53                   	push   %ebx
f01033c4:	83 ec 1c             	sub    $0x1c,%esp
f01033c7:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f01033ca:	e8 7d 2a 00 00       	call   f0105e4c <cpunum>
f01033cf:	6b c0 74             	imul   $0x74,%eax,%eax
f01033d2:	39 b8 28 90 24 f0    	cmp    %edi,-0xfdb6fd8(%eax)
f01033d8:	74 45                	je     f010341f <env_free+0x65>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01033da:	8b 5f 48             	mov    0x48(%edi),%ebx
f01033dd:	e8 6a 2a 00 00       	call   f0105e4c <cpunum>
f01033e2:	6b c0 74             	imul   $0x74,%eax,%eax
f01033e5:	ba 00 00 00 00       	mov    $0x0,%edx
f01033ea:	83 b8 28 90 24 f0 00 	cmpl   $0x0,-0xfdb6fd8(%eax)
f01033f1:	74 11                	je     f0103404 <env_free+0x4a>
f01033f3:	e8 54 2a 00 00       	call   f0105e4c <cpunum>
f01033f8:	6b c0 74             	imul   $0x74,%eax,%eax
f01033fb:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f0103401:	8b 50 48             	mov    0x48(%eax),%edx
f0103404:	83 ec 04             	sub    $0x4,%esp
f0103407:	53                   	push   %ebx
f0103408:	52                   	push   %edx
f0103409:	68 ab 77 10 f0       	push   $0xf01077ab
f010340e:	e8 56 04 00 00       	call   f0103869 <cprintf>
f0103413:	83 c4 10             	add    $0x10,%esp
f0103416:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f010341d:	eb 75                	jmp    f0103494 <env_free+0xda>
		lcr3(PADDR(kern_pgdir));
f010341f:	8b 0d 8c 8e 24 f0    	mov    0xf0248e8c,%ecx
f0103425:	ba a1 01 00 00       	mov    $0x1a1,%edx
f010342a:	b8 5a 77 10 f0       	mov    $0xf010775a,%eax
f010342f:	e8 b5 fa ff ff       	call   f0102ee9 <_paddr>
f0103434:	e8 55 fa ff ff       	call   f0102e8e <lcr3>
f0103439:	eb 9f                	jmp    f01033da <env_free+0x20>
		pt = (pte_t *) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010343b:	83 ec 08             	sub    $0x8,%esp
f010343e:	89 d8                	mov    %ebx,%eax
f0103440:	c1 e0 0c             	shl    $0xc,%eax
f0103443:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103446:	50                   	push   %eax
f0103447:	ff 77 60             	pushl  0x60(%edi)
f010344a:	e8 61 e5 ff ff       	call   f01019b0 <page_remove>
f010344f:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103452:	83 c3 01             	add    $0x1,%ebx
f0103455:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f010345b:	74 08                	je     f0103465 <env_free+0xab>
			if (pt[pteno] & PTE_P)
f010345d:	f6 04 9e 01          	testb  $0x1,(%esi,%ebx,4)
f0103461:	74 ef                	je     f0103452 <env_free+0x98>
f0103463:	eb d6                	jmp    f010343b <env_free+0x81>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103465:	8b 47 60             	mov    0x60(%edi),%eax
f0103468:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010346b:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
		page_decref(pa2page(pa));
f0103472:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103475:	e8 ff fa ff ff       	call   f0102f79 <pa2page>
f010347a:	83 ec 0c             	sub    $0xc,%esp
f010347d:	50                   	push   %eax
f010347e:	e8 08 e4 ff ff       	call   f010188b <page_decref>
f0103483:	83 c4 10             	add    $0x10,%esp
f0103486:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f010348a:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f010348d:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103492:	74 38                	je     f01034cc <env_free+0x112>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103494:	8b 47 60             	mov    0x60(%edi),%eax
f0103497:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010349a:	8b 04 10             	mov    (%eax,%edx,1),%eax
f010349d:	a8 01                	test   $0x1,%al
f010349f:	74 e5                	je     f0103486 <env_free+0xcc>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f01034a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01034a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		pt = (pte_t *) KADDR(pa);
f01034a9:	89 c1                	mov    %eax,%ecx
f01034ab:	ba af 01 00 00       	mov    $0x1af,%edx
f01034b0:	b8 5a 77 10 f0       	mov    $0xf010775a,%eax
f01034b5:	e8 e5 f9 ff ff       	call   f0102e9f <_kaddr>
f01034ba:	89 c6                	mov    %eax,%esi
f01034bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01034bf:	c1 e0 14             	shl    $0x14,%eax
f01034c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01034c5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01034ca:	eb 91                	jmp    f010345d <env_free+0xa3>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01034cc:	8b 4f 60             	mov    0x60(%edi),%ecx
f01034cf:	ba bd 01 00 00       	mov    $0x1bd,%edx
f01034d4:	b8 5a 77 10 f0       	mov    $0xf010775a,%eax
f01034d9:	e8 0b fa ff ff       	call   f0102ee9 <_paddr>
	e->env_pgdir = 0;
f01034de:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	page_decref(pa2page(pa));
f01034e5:	e8 8f fa ff ff       	call   f0102f79 <pa2page>
f01034ea:	83 ec 0c             	sub    $0xc,%esp
f01034ed:	50                   	push   %eax
f01034ee:	e8 98 e3 ff ff       	call   f010188b <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01034f3:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f01034fa:	a1 48 82 24 f0       	mov    0xf0248248,%eax
f01034ff:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103502:	89 3d 48 82 24 f0    	mov    %edi,0xf0248248
}
f0103508:	83 c4 10             	add    $0x10,%esp
f010350b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010350e:	5b                   	pop    %ebx
f010350f:	5e                   	pop    %esi
f0103510:	5f                   	pop    %edi
f0103511:	5d                   	pop    %ebp
f0103512:	c3                   	ret    

f0103513 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103513:	f3 0f 1e fb          	endbr32 
f0103517:	55                   	push   %ebp
f0103518:	89 e5                	mov    %esp,%ebp
f010351a:	53                   	push   %ebx
f010351b:	83 ec 04             	sub    $0x4,%esp
f010351e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103521:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103525:	74 21                	je     f0103548 <env_destroy+0x35>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103527:	83 ec 0c             	sub    $0xc,%esp
f010352a:	53                   	push   %ebx
f010352b:	e8 8a fe ff ff       	call   f01033ba <env_free>

	if (curenv == e) {
f0103530:	e8 17 29 00 00       	call   f0105e4c <cpunum>
f0103535:	6b c0 74             	imul   $0x74,%eax,%eax
f0103538:	83 c4 10             	add    $0x10,%esp
f010353b:	39 98 28 90 24 f0    	cmp    %ebx,-0xfdb6fd8(%eax)
f0103541:	74 1e                	je     f0103561 <env_destroy+0x4e>
		// cprintf("[%08x] env_destroy %08x\n", curenv ? curenv->env_id : 0, e->env_id);
		curenv = NULL;
		// cprintf("[%08x] env_destroy %08x\n", curenv ? curenv->env_id : 0, e->env_id);
		sched_yield();
	}
}
f0103543:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103546:	c9                   	leave  
f0103547:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103548:	e8 ff 28 00 00       	call   f0105e4c <cpunum>
f010354d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103550:	39 98 28 90 24 f0    	cmp    %ebx,-0xfdb6fd8(%eax)
f0103556:	74 cf                	je     f0103527 <env_destroy+0x14>
		e->env_status = ENV_DYING;
f0103558:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f010355f:	eb e2                	jmp    f0103543 <env_destroy+0x30>
		curenv = NULL;
f0103561:	e8 e6 28 00 00       	call   f0105e4c <cpunum>
f0103566:	6b c0 74             	imul   $0x74,%eax,%eax
f0103569:	c7 80 28 90 24 f0 00 	movl   $0x0,-0xfdb6fd8(%eax)
f0103570:	00 00 00 
		sched_yield();
f0103573:	e8 6e 0f 00 00       	call   f01044e6 <sched_yield>

f0103578 <env_load_pgdir>:
//
// Loads environment page directory as a preparation for context_switch.
//
void
env_load_pgdir(struct Env *e)
{
f0103578:	f3 0f 1e fb          	endbr32 
f010357c:	55                   	push   %ebp
f010357d:	89 e5                	mov    %esp,%ebp
f010357f:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(e->env_pgdir));
f0103582:	8b 45 08             	mov    0x8(%ebp),%eax
f0103585:	8b 48 60             	mov    0x60(%eax),%ecx
f0103588:	ba e7 01 00 00       	mov    $0x1e7,%edx
f010358d:	b8 5a 77 10 f0       	mov    $0xf010775a,%eax
f0103592:	e8 52 f9 ff ff       	call   f0102ee9 <_paddr>
f0103597:	e8 f2 f8 ff ff       	call   f0102e8e <lcr3>
}
f010359c:	c9                   	leave  
f010359d:	c3                   	ret    

f010359e <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f010359e:	f3 0f 1e fb          	endbr32 
f01035a2:	55                   	push   %ebp
f01035a3:	89 e5                	mov    %esp,%ebp
f01035a5:	56                   	push   %esi
f01035a6:	53                   	push   %ebx
f01035a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (curenv) {
f01035aa:	e8 9d 28 00 00       	call   f0105e4c <cpunum>
f01035af:	6b c0 74             	imul   $0x74,%eax,%eax
f01035b2:	83 b8 28 90 24 f0 00 	cmpl   $0x0,-0xfdb6fd8(%eax)
f01035b9:	74 14                	je     f01035cf <env_run+0x31>
		if (curenv->env_status == ENV_RUNNING)
f01035bb:	e8 8c 28 00 00       	call   f0105e4c <cpunum>
f01035c0:	6b c0 74             	imul   $0x74,%eax,%eax
f01035c3:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f01035c9:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01035cd:	74 45                	je     f0103614 <env_run+0x76>
			curenv->env_status = ENV_RUNNABLE;
	}
	curenv = e;
f01035cf:	e8 78 28 00 00       	call   f0105e4c <cpunum>
f01035d4:	6b c0 74             	imul   $0x74,%eax,%eax
f01035d7:	89 98 28 90 24 f0    	mov    %ebx,-0xfdb6fd8(%eax)
	e->env_status = ENV_RUNNING;
f01035dd:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
	e->env_runs++;
f01035e4:	83 43 58 01          	addl   $0x1,0x58(%ebx)
	env_load_pgdir(e);
f01035e8:	83 ec 0c             	sub    $0xc,%esp
f01035eb:	53                   	push   %ebx
f01035ec:	e8 87 ff ff ff       	call   f0103578 <env_load_pgdir>
	//	e->env_tf to sensible values.
	// Your code here

	// Needed if we run with multiple procesors
	// Record the CPU we are running on for user-space debugging
	unlock_kernel();
f01035f1:	e8 38 fb ff ff       	call   f010312e <unlock_kernel>
	curenv->env_cpunum = cpunum();
f01035f6:	e8 51 28 00 00       	call   f0105e4c <cpunum>
f01035fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01035fe:	8b b0 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%esi
f0103604:	e8 43 28 00 00       	call   f0105e4c <cpunum>
f0103609:	89 46 5c             	mov    %eax,0x5c(%esi)

	// Step 2: Use context_switch() to restore the environment's
	//	   registers and drop into user mode in the
	//	   environment.
	// Your code here
	context_switch(&e->env_tf);
f010360c:	89 1c 24             	mov    %ebx,(%esp)
f010360f:	e8 a2 0d 00 00       	call   f01043b6 <context_switch>
			curenv->env_status = ENV_RUNNABLE;
f0103614:	e8 33 28 00 00       	call   f0105e4c <cpunum>
f0103619:	6b c0 74             	imul   $0x74,%eax,%eax
f010361c:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f0103622:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103629:	eb a4                	jmp    f01035cf <env_run+0x31>

f010362b <inb>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010362b:	89 c2                	mov    %eax,%edx
f010362d:	ec                   	in     (%dx),%al
}
f010362e:	c3                   	ret    

f010362f <outb>:
{
f010362f:	89 c1                	mov    %eax,%ecx
f0103631:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103633:	89 ca                	mov    %ecx,%edx
f0103635:	ee                   	out    %al,(%dx)
}
f0103636:	c3                   	ret    

f0103637 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103637:	f3 0f 1e fb          	endbr32 
f010363b:	55                   	push   %ebp
f010363c:	89 e5                	mov    %esp,%ebp
f010363e:	83 ec 08             	sub    $0x8,%esp
	outb(IO_RTC, reg);
f0103641:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
f0103645:	b8 70 00 00 00       	mov    $0x70,%eax
f010364a:	e8 e0 ff ff ff       	call   f010362f <outb>
	return inb(IO_RTC+1);
f010364f:	b8 71 00 00 00       	mov    $0x71,%eax
f0103654:	e8 d2 ff ff ff       	call   f010362b <inb>
f0103659:	0f b6 c0             	movzbl %al,%eax
}
f010365c:	c9                   	leave  
f010365d:	c3                   	ret    

f010365e <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f010365e:	f3 0f 1e fb          	endbr32 
f0103662:	55                   	push   %ebp
f0103663:	89 e5                	mov    %esp,%ebp
f0103665:	83 ec 08             	sub    $0x8,%esp
	outb(IO_RTC, reg);
f0103668:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
f010366c:	b8 70 00 00 00       	mov    $0x70,%eax
f0103671:	e8 b9 ff ff ff       	call   f010362f <outb>
	outb(IO_RTC+1, datum);
f0103676:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
f010367a:	b8 71 00 00 00       	mov    $0x71,%eax
f010367f:	e8 ab ff ff ff       	call   f010362f <outb>
}
f0103684:	c9                   	leave  
f0103685:	c3                   	ret    

f0103686 <outb>:
{
f0103686:	89 c1                	mov    %eax,%ecx
f0103688:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010368a:	89 ca                	mov    %ecx,%edx
f010368c:	ee                   	out    %al,(%dx)
}
f010368d:	c3                   	ret    

f010368e <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f010368e:	f3 0f 1e fb          	endbr32 
f0103692:	55                   	push   %ebp
f0103693:	89 e5                	mov    %esp,%ebp
f0103695:	56                   	push   %esi
f0103696:	53                   	push   %ebx
f0103697:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	irq_mask_8259A = mask;
f010369a:	66 89 1d a8 23 12 f0 	mov    %bx,0xf01223a8
	if (!didinit)
f01036a1:	80 3d 4c 82 24 f0 00 	cmpb   $0x0,0xf024824c
f01036a8:	75 07                	jne    f01036b1 <irq_setmask_8259A+0x23>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01036aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01036ad:	5b                   	pop    %ebx
f01036ae:	5e                   	pop    %esi
f01036af:	5d                   	pop    %ebp
f01036b0:	c3                   	ret    
f01036b1:	89 de                	mov    %ebx,%esi
	outb(IO_PIC1+1, (char)mask);
f01036b3:	0f b6 d3             	movzbl %bl,%edx
f01036b6:	b8 21 00 00 00       	mov    $0x21,%eax
f01036bb:	e8 c6 ff ff ff       	call   f0103686 <outb>
	outb(IO_PIC2+1, (char)(mask >> 8));
f01036c0:	0f b6 d7             	movzbl %bh,%edx
f01036c3:	b8 a1 00 00 00       	mov    $0xa1,%eax
f01036c8:	e8 b9 ff ff ff       	call   f0103686 <outb>
	cprintf("enabled interrupts:");
f01036cd:	83 ec 0c             	sub    $0xc,%esp
f01036d0:	68 c1 77 10 f0       	push   $0xf01077c1
f01036d5:	e8 8f 01 00 00       	call   f0103869 <cprintf>
f01036da:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01036dd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01036e2:	0f b7 f6             	movzwl %si,%esi
f01036e5:	f7 d6                	not    %esi
f01036e7:	eb 19                	jmp    f0103702 <irq_setmask_8259A+0x74>
			cprintf(" %d", i);
f01036e9:	83 ec 08             	sub    $0x8,%esp
f01036ec:	53                   	push   %ebx
f01036ed:	68 bb 7c 10 f0       	push   $0xf0107cbb
f01036f2:	e8 72 01 00 00       	call   f0103869 <cprintf>
f01036f7:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01036fa:	83 c3 01             	add    $0x1,%ebx
f01036fd:	83 fb 10             	cmp    $0x10,%ebx
f0103700:	74 07                	je     f0103709 <irq_setmask_8259A+0x7b>
		if (~mask & (1<<i))
f0103702:	0f a3 de             	bt     %ebx,%esi
f0103705:	73 f3                	jae    f01036fa <irq_setmask_8259A+0x6c>
f0103707:	eb e0                	jmp    f01036e9 <irq_setmask_8259A+0x5b>
	cprintf("\n");
f0103709:	83 ec 0c             	sub    $0xc,%esp
f010370c:	68 e8 76 10 f0       	push   $0xf01076e8
f0103711:	e8 53 01 00 00       	call   f0103869 <cprintf>
f0103716:	83 c4 10             	add    $0x10,%esp
f0103719:	eb 8f                	jmp    f01036aa <irq_setmask_8259A+0x1c>

f010371b <pic_init>:
{
f010371b:	f3 0f 1e fb          	endbr32 
f010371f:	55                   	push   %ebp
f0103720:	89 e5                	mov    %esp,%ebp
f0103722:	83 ec 08             	sub    $0x8,%esp
	didinit = 1;
f0103725:	c6 05 4c 82 24 f0 01 	movb   $0x1,0xf024824c
	outb(IO_PIC1+1, 0xFF);
f010372c:	ba ff 00 00 00       	mov    $0xff,%edx
f0103731:	b8 21 00 00 00       	mov    $0x21,%eax
f0103736:	e8 4b ff ff ff       	call   f0103686 <outb>
	outb(IO_PIC2+1, 0xFF);
f010373b:	ba ff 00 00 00       	mov    $0xff,%edx
f0103740:	b8 a1 00 00 00       	mov    $0xa1,%eax
f0103745:	e8 3c ff ff ff       	call   f0103686 <outb>
	outb(IO_PIC1, 0x11);
f010374a:	ba 11 00 00 00       	mov    $0x11,%edx
f010374f:	b8 20 00 00 00       	mov    $0x20,%eax
f0103754:	e8 2d ff ff ff       	call   f0103686 <outb>
	outb(IO_PIC1+1, IRQ_OFFSET);
f0103759:	ba 20 00 00 00       	mov    $0x20,%edx
f010375e:	b8 21 00 00 00       	mov    $0x21,%eax
f0103763:	e8 1e ff ff ff       	call   f0103686 <outb>
	outb(IO_PIC1+1, 1<<IRQ_SLAVE);
f0103768:	ba 04 00 00 00       	mov    $0x4,%edx
f010376d:	b8 21 00 00 00       	mov    $0x21,%eax
f0103772:	e8 0f ff ff ff       	call   f0103686 <outb>
	outb(IO_PIC1+1, 0x3);
f0103777:	ba 03 00 00 00       	mov    $0x3,%edx
f010377c:	b8 21 00 00 00       	mov    $0x21,%eax
f0103781:	e8 00 ff ff ff       	call   f0103686 <outb>
	outb(IO_PIC2, 0x11);			// ICW1
f0103786:	ba 11 00 00 00       	mov    $0x11,%edx
f010378b:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0103790:	e8 f1 fe ff ff       	call   f0103686 <outb>
	outb(IO_PIC2+1, IRQ_OFFSET + 8);	// ICW2
f0103795:	ba 28 00 00 00       	mov    $0x28,%edx
f010379a:	b8 a1 00 00 00       	mov    $0xa1,%eax
f010379f:	e8 e2 fe ff ff       	call   f0103686 <outb>
	outb(IO_PIC2+1, IRQ_SLAVE);		// ICW3
f01037a4:	ba 02 00 00 00       	mov    $0x2,%edx
f01037a9:	b8 a1 00 00 00       	mov    $0xa1,%eax
f01037ae:	e8 d3 fe ff ff       	call   f0103686 <outb>
	outb(IO_PIC2+1, 0x01);			// ICW4
f01037b3:	ba 01 00 00 00       	mov    $0x1,%edx
f01037b8:	b8 a1 00 00 00       	mov    $0xa1,%eax
f01037bd:	e8 c4 fe ff ff       	call   f0103686 <outb>
	outb(IO_PIC1, 0x68);             /* clear specific mask */
f01037c2:	ba 68 00 00 00       	mov    $0x68,%edx
f01037c7:	b8 20 00 00 00       	mov    $0x20,%eax
f01037cc:	e8 b5 fe ff ff       	call   f0103686 <outb>
	outb(IO_PIC1, 0x0a);             /* read IRR by default */
f01037d1:	ba 0a 00 00 00       	mov    $0xa,%edx
f01037d6:	b8 20 00 00 00       	mov    $0x20,%eax
f01037db:	e8 a6 fe ff ff       	call   f0103686 <outb>
	outb(IO_PIC2, 0x68);               /* OCW3 */
f01037e0:	ba 68 00 00 00       	mov    $0x68,%edx
f01037e5:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01037ea:	e8 97 fe ff ff       	call   f0103686 <outb>
	outb(IO_PIC2, 0x0a);               /* OCW3 */
f01037ef:	ba 0a 00 00 00       	mov    $0xa,%edx
f01037f4:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01037f9:	e8 88 fe ff ff       	call   f0103686 <outb>
	if (irq_mask_8259A != 0xFFFF)
f01037fe:	0f b7 05 a8 23 12 f0 	movzwl 0xf01223a8,%eax
f0103805:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103809:	75 02                	jne    f010380d <pic_init+0xf2>
}
f010380b:	c9                   	leave  
f010380c:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f010380d:	83 ec 0c             	sub    $0xc,%esp
f0103810:	0f b7 c0             	movzwl %ax,%eax
f0103813:	50                   	push   %eax
f0103814:	e8 75 fe ff ff       	call   f010368e <irq_setmask_8259A>
f0103819:	83 c4 10             	add    $0x10,%esp
}
f010381c:	eb ed                	jmp    f010380b <pic_init+0xf0>

f010381e <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f010381e:	f3 0f 1e fb          	endbr32 
f0103822:	55                   	push   %ebp
f0103823:	89 e5                	mov    %esp,%ebp
f0103825:	53                   	push   %ebx
f0103826:	83 ec 10             	sub    $0x10,%esp
f0103829:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f010382c:	ff 75 08             	pushl  0x8(%ebp)
f010382f:	e8 fa d0 ff ff       	call   f010092e <cputchar>
	(*cnt)++;
f0103834:	83 03 01             	addl   $0x1,(%ebx)
}
f0103837:	83 c4 10             	add    $0x10,%esp
f010383a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010383d:	c9                   	leave  
f010383e:	c3                   	ret    

f010383f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010383f:	f3 0f 1e fb          	endbr32 
f0103843:	55                   	push   %ebp
f0103844:	89 e5                	mov    %esp,%ebp
f0103846:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103850:	ff 75 0c             	pushl  0xc(%ebp)
f0103853:	ff 75 08             	pushl  0x8(%ebp)
f0103856:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103859:	50                   	push   %eax
f010385a:	68 1e 38 10 f0       	push   $0xf010381e
f010385f:	e8 00 19 00 00       	call   f0105164 <vprintfmt>
	return cnt;
}
f0103864:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103867:	c9                   	leave  
f0103868:	c3                   	ret    

f0103869 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103869:	f3 0f 1e fb          	endbr32 
f010386d:	55                   	push   %ebp
f010386e:	89 e5                	mov    %esp,%ebp
f0103870:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103873:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103876:	50                   	push   %eax
f0103877:	ff 75 08             	pushl  0x8(%ebp)
f010387a:	e8 c0 ff ff ff       	call   f010383f <vcprintf>
	va_end(ap);

	return cnt;
}
f010387f:	c9                   	leave  
f0103880:	c3                   	ret    

f0103881 <lidt>:
	asm volatile("lidt (%0)" : : "r" (p));
f0103881:	0f 01 18             	lidtl  (%eax)
}
f0103884:	c3                   	ret    

f0103885 <ltr>:
	asm volatile("ltr %0" : : "r" (sel));
f0103885:	0f 00 d8             	ltr    %ax
}
f0103888:	c3                   	ret    

f0103889 <rcr2>:
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0103889:	0f 20 d0             	mov    %cr2,%eax
}
f010388c:	c3                   	ret    

f010388d <read_eflags>:
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f010388d:	9c                   	pushf  
f010388e:	58                   	pop    %eax
}
f010388f:	c3                   	ret    

f0103890 <xchg>:
{
f0103890:	89 c1                	mov    %eax,%ecx
f0103892:	89 d0                	mov    %edx,%eax
	asm volatile("lock; xchgl %0, %1"
f0103894:	f0 87 01             	lock xchg %eax,(%ecx)
}
f0103897:	c3                   	ret    

f0103898 <trapname>:
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < ARRAY_SIZE(excnames))
f0103898:	83 f8 13             	cmp    $0x13,%eax
f010389b:	76 20                	jbe    f01038bd <trapname+0x25>
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
f010389d:	ba e4 77 10 f0       	mov    $0xf01077e4,%edx
	if (trapno == T_SYSCALL)
f01038a2:	83 f8 30             	cmp    $0x30,%eax
f01038a5:	74 13                	je     f01038ba <trapname+0x22>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01038a7:	83 e8 20             	sub    $0x20,%eax
		return "Hardware Interrupt";
f01038aa:	83 f8 0f             	cmp    $0xf,%eax
f01038ad:	ba d5 77 10 f0       	mov    $0xf01077d5,%edx
f01038b2:	b8 f0 77 10 f0       	mov    $0xf01077f0,%eax
f01038b7:	0f 46 d0             	cmovbe %eax,%edx
	return "(unknown trap)";
}
f01038ba:	89 d0                	mov    %edx,%eax
f01038bc:	c3                   	ret    
		return excnames[trapno];
f01038bd:	8b 14 85 a0 7b 10 f0 	mov    -0xfef8460(,%eax,4),%edx
f01038c4:	eb f4                	jmp    f01038ba <trapname+0x22>

f01038c6 <lock_kernel>:
{
f01038c6:	55                   	push   %ebp
f01038c7:	89 e5                	mov    %esp,%ebp
f01038c9:	83 ec 14             	sub    $0x14,%esp
	spin_lock(&kernel_lock);
f01038cc:	68 c0 23 12 f0       	push   $0xf01223c0
f01038d1:	e8 7b 28 00 00       	call   f0106151 <spin_lock>
}
f01038d6:	83 c4 10             	add    $0x10,%esp
f01038d9:	c9                   	leave  
f01038da:	c3                   	ret    

f01038db <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f01038db:	f3 0f 1e fb          	endbr32 
f01038df:	55                   	push   %ebp
f01038e0:	89 e5                	mov    %esp,%ebp
f01038e2:	57                   	push   %edi
f01038e3:	56                   	push   %esi
f01038e4:	53                   	push   %ebx
f01038e5:	83 ec 0c             	sub    $0xc,%esp
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	struct Taskstate *thists = &(thiscpu->cpu_ts);
f01038e8:	e8 5f 25 00 00       	call   f0105e4c <cpunum>
f01038ed:	6b f0 74             	imul   $0x74,%eax,%esi
f01038f0:	8d 9e 2c 90 24 f0    	lea    -0xfdb6fd4(%esi),%ebx
	uint8_t thisid = thiscpu->cpu_id;
f01038f6:	e8 51 25 00 00       	call   f0105e4c <cpunum>
f01038fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01038fe:	0f b6 90 20 90 24 f0 	movzbl -0xfdb6fe0(%eax),%edx

	thists->ts_esp0 = KSTACKTOP - thisid * (KSTKGAP + KSTKSIZE);
f0103905:	0f b6 c2             	movzbl %dl,%eax
f0103908:	89 c7                	mov    %eax,%edi
f010390a:	c1 e7 10             	shl    $0x10,%edi
f010390d:	b9 00 00 00 f0       	mov    $0xf0000000,%ecx
f0103912:	29 f9                	sub    %edi,%ecx
f0103914:	89 8e 30 90 24 f0    	mov    %ecx,-0xfdb6fd0(%esi)
	thists->ts_ss0 = GD_KD;
f010391a:	66 c7 86 34 90 24 f0 	movw   $0x10,-0xfdb6fcc(%esi)
f0103921:	10 00 
	thists->ts_iomb = sizeof(struct Taskstate);
f0103923:	66 c7 86 92 90 24 f0 	movw   $0x68,-0xfdb6f6e(%esi)
f010392a:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + thisid] = SEG16(
f010392c:	83 c0 05             	add    $0x5,%eax
f010392f:	66 c7 04 c5 40 23 12 	movw   $0x67,-0xfeddcc0(,%eax,8)
f0103936:	f0 67 00 
f0103939:	66 89 1c c5 42 23 12 	mov    %bx,-0xfeddcbe(,%eax,8)
f0103940:	f0 
f0103941:	89 d9                	mov    %ebx,%ecx
f0103943:	c1 e9 10             	shr    $0x10,%ecx
f0103946:	88 0c c5 44 23 12 f0 	mov    %cl,-0xfeddcbc(,%eax,8)
f010394d:	c6 04 c5 46 23 12 f0 	movb   $0x40,-0xfeddcba(,%eax,8)
f0103954:	40 
f0103955:	c1 eb 18             	shr    $0x18,%ebx
f0103958:	88 1c c5 47 23 12 f0 	mov    %bl,-0xfeddcb9(,%eax,8)
	        STS_T32A, (uint32_t)(thists), sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + thisid].sd_s = 0;
f010395f:	c6 04 c5 45 23 12 f0 	movb   $0x89,-0xfeddcbb(,%eax,8)
f0103966:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (thisid << 3));
f0103967:	0f b6 d2             	movzbl %dl,%edx
f010396a:	8d 04 d5 28 00 00 00 	lea    0x28(,%edx,8),%eax
f0103971:	e8 0f ff ff ff       	call   f0103885 <ltr>

	// Load the IDT
	lidt(&idt_pd);
f0103976:	b8 ac 23 12 f0       	mov    $0xf01223ac,%eax
f010397b:	e8 01 ff ff ff       	call   f0103881 <lidt>
}
f0103980:	83 c4 0c             	add    $0xc,%esp
f0103983:	5b                   	pop    %ebx
f0103984:	5e                   	pop    %esi
f0103985:	5f                   	pop    %edi
f0103986:	5d                   	pop    %ebp
f0103987:	c3                   	ret    

f0103988 <trap_init>:
{
f0103988:	f3 0f 1e fb          	endbr32 
f010398c:	55                   	push   %ebp
f010398d:	89 e5                	mov    %esp,%ebp
f010398f:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE], 0, GD_KT, &trap0, 0);
f0103992:	b8 2e 43 10 f0       	mov    $0xf010432e,%eax
f0103997:	66 a3 60 82 24 f0    	mov    %ax,0xf0248260
f010399d:	66 c7 05 62 82 24 f0 	movw   $0x8,0xf0248262
f01039a4:	08 00 
f01039a6:	c6 05 64 82 24 f0 00 	movb   $0x0,0xf0248264
f01039ad:	c6 05 65 82 24 f0 8e 	movb   $0x8e,0xf0248265
f01039b4:	c1 e8 10             	shr    $0x10,%eax
f01039b7:	66 a3 66 82 24 f0    	mov    %ax,0xf0248266
	SETGATE(idt[T_DEBUG], 0, GD_KT, &trap1, 0);
f01039bd:	b8 34 43 10 f0       	mov    $0xf0104334,%eax
f01039c2:	66 a3 68 82 24 f0    	mov    %ax,0xf0248268
f01039c8:	66 c7 05 6a 82 24 f0 	movw   $0x8,0xf024826a
f01039cf:	08 00 
f01039d1:	c6 05 6c 82 24 f0 00 	movb   $0x0,0xf024826c
f01039d8:	c6 05 6d 82 24 f0 8e 	movb   $0x8e,0xf024826d
f01039df:	c1 e8 10             	shr    $0x10,%eax
f01039e2:	66 a3 6e 82 24 f0    	mov    %ax,0xf024826e
	SETGATE(idt[T_NMI], 0, GD_KT, &trap2, 0);
f01039e8:	b8 3a 43 10 f0       	mov    $0xf010433a,%eax
f01039ed:	66 a3 70 82 24 f0    	mov    %ax,0xf0248270
f01039f3:	66 c7 05 72 82 24 f0 	movw   $0x8,0xf0248272
f01039fa:	08 00 
f01039fc:	c6 05 74 82 24 f0 00 	movb   $0x0,0xf0248274
f0103a03:	c6 05 75 82 24 f0 8e 	movb   $0x8e,0xf0248275
f0103a0a:	c1 e8 10             	shr    $0x10,%eax
f0103a0d:	66 a3 76 82 24 f0    	mov    %ax,0xf0248276
	SETGATE(idt[T_BRKPT], 0, GD_KT, &trap3, 3);
f0103a13:	b8 40 43 10 f0       	mov    $0xf0104340,%eax
f0103a18:	66 a3 78 82 24 f0    	mov    %ax,0xf0248278
f0103a1e:	66 c7 05 7a 82 24 f0 	movw   $0x8,0xf024827a
f0103a25:	08 00 
f0103a27:	c6 05 7c 82 24 f0 00 	movb   $0x0,0xf024827c
f0103a2e:	c6 05 7d 82 24 f0 ee 	movb   $0xee,0xf024827d
f0103a35:	c1 e8 10             	shr    $0x10,%eax
f0103a38:	66 a3 7e 82 24 f0    	mov    %ax,0xf024827e
	SETGATE(idt[T_OFLOW], 0, GD_KT, &trap4, 0);
f0103a3e:	b8 46 43 10 f0       	mov    $0xf0104346,%eax
f0103a43:	66 a3 80 82 24 f0    	mov    %ax,0xf0248280
f0103a49:	66 c7 05 82 82 24 f0 	movw   $0x8,0xf0248282
f0103a50:	08 00 
f0103a52:	c6 05 84 82 24 f0 00 	movb   $0x0,0xf0248284
f0103a59:	c6 05 85 82 24 f0 8e 	movb   $0x8e,0xf0248285
f0103a60:	c1 e8 10             	shr    $0x10,%eax
f0103a63:	66 a3 86 82 24 f0    	mov    %ax,0xf0248286
	SETGATE(idt[T_BOUND], 0, GD_KT, &trap5, 0);
f0103a69:	b8 4c 43 10 f0       	mov    $0xf010434c,%eax
f0103a6e:	66 a3 88 82 24 f0    	mov    %ax,0xf0248288
f0103a74:	66 c7 05 8a 82 24 f0 	movw   $0x8,0xf024828a
f0103a7b:	08 00 
f0103a7d:	c6 05 8c 82 24 f0 00 	movb   $0x0,0xf024828c
f0103a84:	c6 05 8d 82 24 f0 8e 	movb   $0x8e,0xf024828d
f0103a8b:	c1 e8 10             	shr    $0x10,%eax
f0103a8e:	66 a3 8e 82 24 f0    	mov    %ax,0xf024828e
	SETGATE(idt[T_ILLOP], 0, GD_KT, &trap6, 0);
f0103a94:	b8 52 43 10 f0       	mov    $0xf0104352,%eax
f0103a99:	66 a3 90 82 24 f0    	mov    %ax,0xf0248290
f0103a9f:	66 c7 05 92 82 24 f0 	movw   $0x8,0xf0248292
f0103aa6:	08 00 
f0103aa8:	c6 05 94 82 24 f0 00 	movb   $0x0,0xf0248294
f0103aaf:	c6 05 95 82 24 f0 8e 	movb   $0x8e,0xf0248295
f0103ab6:	c1 e8 10             	shr    $0x10,%eax
f0103ab9:	66 a3 96 82 24 f0    	mov    %ax,0xf0248296
	SETGATE(idt[T_DEVICE], 0, GD_KT, &trap7, 0);
f0103abf:	b8 58 43 10 f0       	mov    $0xf0104358,%eax
f0103ac4:	66 a3 98 82 24 f0    	mov    %ax,0xf0248298
f0103aca:	66 c7 05 9a 82 24 f0 	movw   $0x8,0xf024829a
f0103ad1:	08 00 
f0103ad3:	c6 05 9c 82 24 f0 00 	movb   $0x0,0xf024829c
f0103ada:	c6 05 9d 82 24 f0 8e 	movb   $0x8e,0xf024829d
f0103ae1:	c1 e8 10             	shr    $0x10,%eax
f0103ae4:	66 a3 9e 82 24 f0    	mov    %ax,0xf024829e
	SETGATE(idt[T_DBLFLT], 0, GD_KT, &trap8, 0);
f0103aea:	b8 5e 43 10 f0       	mov    $0xf010435e,%eax
f0103aef:	66 a3 a0 82 24 f0    	mov    %ax,0xf02482a0
f0103af5:	66 c7 05 a2 82 24 f0 	movw   $0x8,0xf02482a2
f0103afc:	08 00 
f0103afe:	c6 05 a4 82 24 f0 00 	movb   $0x0,0xf02482a4
f0103b05:	c6 05 a5 82 24 f0 8e 	movb   $0x8e,0xf02482a5
f0103b0c:	c1 e8 10             	shr    $0x10,%eax
f0103b0f:	66 a3 a6 82 24 f0    	mov    %ax,0xf02482a6
	SETGATE(idt[T_TSS], 0, GD_KT, &trap10, 0);
f0103b15:	b8 68 43 10 f0       	mov    $0xf0104368,%eax
f0103b1a:	66 a3 b0 82 24 f0    	mov    %ax,0xf02482b0
f0103b20:	66 c7 05 b2 82 24 f0 	movw   $0x8,0xf02482b2
f0103b27:	08 00 
f0103b29:	c6 05 b4 82 24 f0 00 	movb   $0x0,0xf02482b4
f0103b30:	c6 05 b5 82 24 f0 8e 	movb   $0x8e,0xf02482b5
f0103b37:	c1 e8 10             	shr    $0x10,%eax
f0103b3a:	66 a3 b6 82 24 f0    	mov    %ax,0xf02482b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, &trap11, 0);
f0103b40:	b8 6c 43 10 f0       	mov    $0xf010436c,%eax
f0103b45:	66 a3 b8 82 24 f0    	mov    %ax,0xf02482b8
f0103b4b:	66 c7 05 ba 82 24 f0 	movw   $0x8,0xf02482ba
f0103b52:	08 00 
f0103b54:	c6 05 bc 82 24 f0 00 	movb   $0x0,0xf02482bc
f0103b5b:	c6 05 bd 82 24 f0 8e 	movb   $0x8e,0xf02482bd
f0103b62:	c1 e8 10             	shr    $0x10,%eax
f0103b65:	66 a3 be 82 24 f0    	mov    %ax,0xf02482be
	SETGATE(idt[T_STACK], 0, GD_KT, &trap12, 0);
f0103b6b:	b8 70 43 10 f0       	mov    $0xf0104370,%eax
f0103b70:	66 a3 c0 82 24 f0    	mov    %ax,0xf02482c0
f0103b76:	66 c7 05 c2 82 24 f0 	movw   $0x8,0xf02482c2
f0103b7d:	08 00 
f0103b7f:	c6 05 c4 82 24 f0 00 	movb   $0x0,0xf02482c4
f0103b86:	c6 05 c5 82 24 f0 8e 	movb   $0x8e,0xf02482c5
f0103b8d:	c1 e8 10             	shr    $0x10,%eax
f0103b90:	66 a3 c6 82 24 f0    	mov    %ax,0xf02482c6
	SETGATE(idt[T_GPFLT], 0, GD_KT, &trap13, 0);
f0103b96:	b8 74 43 10 f0       	mov    $0xf0104374,%eax
f0103b9b:	66 a3 c8 82 24 f0    	mov    %ax,0xf02482c8
f0103ba1:	66 c7 05 ca 82 24 f0 	movw   $0x8,0xf02482ca
f0103ba8:	08 00 
f0103baa:	c6 05 cc 82 24 f0 00 	movb   $0x0,0xf02482cc
f0103bb1:	c6 05 cd 82 24 f0 8e 	movb   $0x8e,0xf02482cd
f0103bb8:	c1 e8 10             	shr    $0x10,%eax
f0103bbb:	66 a3 ce 82 24 f0    	mov    %ax,0xf02482ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, &trap14, 0);
f0103bc1:	b8 78 43 10 f0       	mov    $0xf0104378,%eax
f0103bc6:	66 a3 d0 82 24 f0    	mov    %ax,0xf02482d0
f0103bcc:	66 c7 05 d2 82 24 f0 	movw   $0x8,0xf02482d2
f0103bd3:	08 00 
f0103bd5:	c6 05 d4 82 24 f0 00 	movb   $0x0,0xf02482d4
f0103bdc:	c6 05 d5 82 24 f0 8e 	movb   $0x8e,0xf02482d5
f0103be3:	c1 e8 10             	shr    $0x10,%eax
f0103be6:	66 a3 d6 82 24 f0    	mov    %ax,0xf02482d6
	SETGATE(idt[T_FPERR], 0, GD_KT, &trap16, 0);
f0103bec:	b8 82 43 10 f0       	mov    $0xf0104382,%eax
f0103bf1:	66 a3 e0 82 24 f0    	mov    %ax,0xf02482e0
f0103bf7:	66 c7 05 e2 82 24 f0 	movw   $0x8,0xf02482e2
f0103bfe:	08 00 
f0103c00:	c6 05 e4 82 24 f0 00 	movb   $0x0,0xf02482e4
f0103c07:	c6 05 e5 82 24 f0 8e 	movb   $0x8e,0xf02482e5
f0103c0e:	c1 e8 10             	shr    $0x10,%eax
f0103c11:	66 a3 e6 82 24 f0    	mov    %ax,0xf02482e6
	SETGATE(idt[T_ALIGN], 0, GD_KT, &trap17, 0);
f0103c17:	b8 88 43 10 f0       	mov    $0xf0104388,%eax
f0103c1c:	66 a3 e8 82 24 f0    	mov    %ax,0xf02482e8
f0103c22:	66 c7 05 ea 82 24 f0 	movw   $0x8,0xf02482ea
f0103c29:	08 00 
f0103c2b:	c6 05 ec 82 24 f0 00 	movb   $0x0,0xf02482ec
f0103c32:	c6 05 ed 82 24 f0 8e 	movb   $0x8e,0xf02482ed
f0103c39:	c1 e8 10             	shr    $0x10,%eax
f0103c3c:	66 a3 ee 82 24 f0    	mov    %ax,0xf02482ee
	SETGATE(idt[T_MCHK], 0, GD_KT, &trap18, 0);
f0103c42:	b8 8c 43 10 f0       	mov    $0xf010438c,%eax
f0103c47:	66 a3 f0 82 24 f0    	mov    %ax,0xf02482f0
f0103c4d:	66 c7 05 f2 82 24 f0 	movw   $0x8,0xf02482f2
f0103c54:	08 00 
f0103c56:	c6 05 f4 82 24 f0 00 	movb   $0x0,0xf02482f4
f0103c5d:	c6 05 f5 82 24 f0 8e 	movb   $0x8e,0xf02482f5
f0103c64:	c1 e8 10             	shr    $0x10,%eax
f0103c67:	66 a3 f6 82 24 f0    	mov    %ax,0xf02482f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, &trap19, 0);
f0103c6d:	b8 92 43 10 f0       	mov    $0xf0104392,%eax
f0103c72:	66 a3 f8 82 24 f0    	mov    %ax,0xf02482f8
f0103c78:	66 c7 05 fa 82 24 f0 	movw   $0x8,0xf02482fa
f0103c7f:	08 00 
f0103c81:	c6 05 fc 82 24 f0 00 	movb   $0x0,0xf02482fc
f0103c88:	c6 05 fd 82 24 f0 8e 	movb   $0x8e,0xf02482fd
f0103c8f:	c1 e8 10             	shr    $0x10,%eax
f0103c92:	66 a3 fe 82 24 f0    	mov    %ax,0xf02482fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, &trap48, 3);
f0103c98:	b8 9e 43 10 f0       	mov    $0xf010439e,%eax
f0103c9d:	66 a3 e0 83 24 f0    	mov    %ax,0xf02483e0
f0103ca3:	66 c7 05 e2 83 24 f0 	movw   $0x8,0xf02483e2
f0103caa:	08 00 
f0103cac:	c6 05 e4 83 24 f0 00 	movb   $0x0,0xf02483e4
f0103cb3:	c6 05 e5 83 24 f0 ee 	movb   $0xee,0xf02483e5
f0103cba:	c1 e8 10             	shr    $0x10,%eax
f0103cbd:	66 a3 e6 83 24 f0    	mov    %ax,0xf02483e6
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, &trap32, 0);
f0103cc3:	b8 98 43 10 f0       	mov    $0xf0104398,%eax
f0103cc8:	66 a3 60 83 24 f0    	mov    %ax,0xf0248360
f0103cce:	66 c7 05 62 83 24 f0 	movw   $0x8,0xf0248362
f0103cd5:	08 00 
f0103cd7:	c6 05 64 83 24 f0 00 	movb   $0x0,0xf0248364
f0103cde:	c6 05 65 83 24 f0 8e 	movb   $0x8e,0xf0248365
f0103ce5:	c1 e8 10             	shr    $0x10,%eax
f0103ce8:	66 a3 66 83 24 f0    	mov    %ax,0xf0248366
	trap_init_percpu();
f0103cee:	e8 e8 fb ff ff       	call   f01038db <trap_init_percpu>
}
f0103cf3:	c9                   	leave  
f0103cf4:	c3                   	ret    

f0103cf5 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103cf5:	f3 0f 1e fb          	endbr32 
f0103cf9:	55                   	push   %ebp
f0103cfa:	89 e5                	mov    %esp,%ebp
f0103cfc:	53                   	push   %ebx
f0103cfd:	83 ec 0c             	sub    $0xc,%esp
f0103d00:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103d03:	ff 33                	pushl  (%ebx)
f0103d05:	68 03 78 10 f0       	push   $0xf0107803
f0103d0a:	e8 5a fb ff ff       	call   f0103869 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103d0f:	83 c4 08             	add    $0x8,%esp
f0103d12:	ff 73 04             	pushl  0x4(%ebx)
f0103d15:	68 12 78 10 f0       	push   $0xf0107812
f0103d1a:	e8 4a fb ff ff       	call   f0103869 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103d1f:	83 c4 08             	add    $0x8,%esp
f0103d22:	ff 73 08             	pushl  0x8(%ebx)
f0103d25:	68 21 78 10 f0       	push   $0xf0107821
f0103d2a:	e8 3a fb ff ff       	call   f0103869 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103d2f:	83 c4 08             	add    $0x8,%esp
f0103d32:	ff 73 0c             	pushl  0xc(%ebx)
f0103d35:	68 30 78 10 f0       	push   $0xf0107830
f0103d3a:	e8 2a fb ff ff       	call   f0103869 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103d3f:	83 c4 08             	add    $0x8,%esp
f0103d42:	ff 73 10             	pushl  0x10(%ebx)
f0103d45:	68 3f 78 10 f0       	push   $0xf010783f
f0103d4a:	e8 1a fb ff ff       	call   f0103869 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103d4f:	83 c4 08             	add    $0x8,%esp
f0103d52:	ff 73 14             	pushl  0x14(%ebx)
f0103d55:	68 4e 78 10 f0       	push   $0xf010784e
f0103d5a:	e8 0a fb ff ff       	call   f0103869 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103d5f:	83 c4 08             	add    $0x8,%esp
f0103d62:	ff 73 18             	pushl  0x18(%ebx)
f0103d65:	68 5d 78 10 f0       	push   $0xf010785d
f0103d6a:	e8 fa fa ff ff       	call   f0103869 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103d6f:	83 c4 08             	add    $0x8,%esp
f0103d72:	ff 73 1c             	pushl  0x1c(%ebx)
f0103d75:	68 6c 78 10 f0       	push   $0xf010786c
f0103d7a:	e8 ea fa ff ff       	call   f0103869 <cprintf>
}
f0103d7f:	83 c4 10             	add    $0x10,%esp
f0103d82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103d85:	c9                   	leave  
f0103d86:	c3                   	ret    

f0103d87 <print_trapframe>:
{
f0103d87:	f3 0f 1e fb          	endbr32 
f0103d8b:	55                   	push   %ebp
f0103d8c:	89 e5                	mov    %esp,%ebp
f0103d8e:	56                   	push   %esi
f0103d8f:	53                   	push   %ebx
f0103d90:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0103d93:	e8 b4 20 00 00       	call   f0105e4c <cpunum>
f0103d98:	83 ec 04             	sub    $0x4,%esp
f0103d9b:	50                   	push   %eax
f0103d9c:	53                   	push   %ebx
f0103d9d:	68 a2 78 10 f0       	push   $0xf01078a2
f0103da2:	e8 c2 fa ff ff       	call   f0103869 <cprintf>
	print_regs(&tf->tf_regs);
f0103da7:	89 1c 24             	mov    %ebx,(%esp)
f0103daa:	e8 46 ff ff ff       	call   f0103cf5 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103daf:	83 c4 08             	add    $0x8,%esp
f0103db2:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103db6:	50                   	push   %eax
f0103db7:	68 c0 78 10 f0       	push   $0xf01078c0
f0103dbc:	e8 a8 fa ff ff       	call   f0103869 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103dc1:	83 c4 08             	add    $0x8,%esp
f0103dc4:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103dc8:	50                   	push   %eax
f0103dc9:	68 d3 78 10 f0       	push   $0xf01078d3
f0103dce:	e8 96 fa ff ff       	call   f0103869 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103dd3:	8b 73 28             	mov    0x28(%ebx),%esi
f0103dd6:	89 f0                	mov    %esi,%eax
f0103dd8:	e8 bb fa ff ff       	call   f0103898 <trapname>
f0103ddd:	83 c4 0c             	add    $0xc,%esp
f0103de0:	50                   	push   %eax
f0103de1:	56                   	push   %esi
f0103de2:	68 e6 78 10 f0       	push   $0xf01078e6
f0103de7:	e8 7d fa ff ff       	call   f0103869 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103dec:	83 c4 10             	add    $0x10,%esp
f0103def:	39 1d 60 8a 24 f0    	cmp    %ebx,0xf0248a60
f0103df5:	0f 84 9f 00 00 00    	je     f0103e9a <print_trapframe+0x113>
	cprintf("  err  0x%08x", tf->tf_err);
f0103dfb:	83 ec 08             	sub    $0x8,%esp
f0103dfe:	ff 73 2c             	pushl  0x2c(%ebx)
f0103e01:	68 07 79 10 f0       	push   $0xf0107907
f0103e06:	e8 5e fa ff ff       	call   f0103869 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0103e0b:	83 c4 10             	add    $0x10,%esp
f0103e0e:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103e12:	0f 85 a7 00 00 00    	jne    f0103ebf <print_trapframe+0x138>
		        tf->tf_err & 1 ? "protection" : "not-present");
f0103e18:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0103e1b:	a8 01                	test   $0x1,%al
f0103e1d:	b9 7b 78 10 f0       	mov    $0xf010787b,%ecx
f0103e22:	ba 86 78 10 f0       	mov    $0xf0107886,%edx
f0103e27:	0f 44 ca             	cmove  %edx,%ecx
f0103e2a:	a8 02                	test   $0x2,%al
f0103e2c:	be 92 78 10 f0       	mov    $0xf0107892,%esi
f0103e31:	ba 98 78 10 f0       	mov    $0xf0107898,%edx
f0103e36:	0f 45 d6             	cmovne %esi,%edx
f0103e39:	a8 04                	test   $0x4,%al
f0103e3b:	b8 9d 78 10 f0       	mov    $0xf010789d,%eax
f0103e40:	be cd 79 10 f0       	mov    $0xf01079cd,%esi
f0103e45:	0f 44 c6             	cmove  %esi,%eax
f0103e48:	51                   	push   %ecx
f0103e49:	52                   	push   %edx
f0103e4a:	50                   	push   %eax
f0103e4b:	68 15 79 10 f0       	push   $0xf0107915
f0103e50:	e8 14 fa ff ff       	call   f0103869 <cprintf>
f0103e55:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103e58:	83 ec 08             	sub    $0x8,%esp
f0103e5b:	ff 73 30             	pushl  0x30(%ebx)
f0103e5e:	68 24 79 10 f0       	push   $0xf0107924
f0103e63:	e8 01 fa ff ff       	call   f0103869 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103e68:	83 c4 08             	add    $0x8,%esp
f0103e6b:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103e6f:	50                   	push   %eax
f0103e70:	68 33 79 10 f0       	push   $0xf0107933
f0103e75:	e8 ef f9 ff ff       	call   f0103869 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103e7a:	83 c4 08             	add    $0x8,%esp
f0103e7d:	ff 73 38             	pushl  0x38(%ebx)
f0103e80:	68 46 79 10 f0       	push   $0xf0107946
f0103e85:	e8 df f9 ff ff       	call   f0103869 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0103e8a:	83 c4 10             	add    $0x10,%esp
f0103e8d:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103e91:	75 3e                	jne    f0103ed1 <print_trapframe+0x14a>
}
f0103e93:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103e96:	5b                   	pop    %ebx
f0103e97:	5e                   	pop    %esi
f0103e98:	5d                   	pop    %ebp
f0103e99:	c3                   	ret    
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103e9a:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103e9e:	0f 85 57 ff ff ff    	jne    f0103dfb <print_trapframe+0x74>
		cprintf("  cr2  0x%08x\n", rcr2());
f0103ea4:	e8 e0 f9 ff ff       	call   f0103889 <rcr2>
f0103ea9:	83 ec 08             	sub    $0x8,%esp
f0103eac:	50                   	push   %eax
f0103ead:	68 f8 78 10 f0       	push   $0xf01078f8
f0103eb2:	e8 b2 f9 ff ff       	call   f0103869 <cprintf>
f0103eb7:	83 c4 10             	add    $0x10,%esp
f0103eba:	e9 3c ff ff ff       	jmp    f0103dfb <print_trapframe+0x74>
		cprintf("\n");
f0103ebf:	83 ec 0c             	sub    $0xc,%esp
f0103ec2:	68 e8 76 10 f0       	push   $0xf01076e8
f0103ec7:	e8 9d f9 ff ff       	call   f0103869 <cprintf>
f0103ecc:	83 c4 10             	add    $0x10,%esp
f0103ecf:	eb 87                	jmp    f0103e58 <print_trapframe+0xd1>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0103ed1:	83 ec 08             	sub    $0x8,%esp
f0103ed4:	ff 73 3c             	pushl  0x3c(%ebx)
f0103ed7:	68 55 79 10 f0       	push   $0xf0107955
f0103edc:	e8 88 f9 ff ff       	call   f0103869 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0103ee1:	83 c4 08             	add    $0x8,%esp
f0103ee4:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0103ee8:	50                   	push   %eax
f0103ee9:	68 64 79 10 f0       	push   $0xf0107964
f0103eee:	e8 76 f9 ff ff       	call   f0103869 <cprintf>
f0103ef3:	83 c4 10             	add    $0x10,%esp
}
f0103ef6:	eb 9b                	jmp    f0103e93 <print_trapframe+0x10c>

f0103ef8 <page_fault_handler>:
		sched_yield();
}

void
page_fault_handler(struct Trapframe *tf)
{
f0103ef8:	f3 0f 1e fb          	endbr32 
f0103efc:	55                   	push   %ebp
f0103efd:	89 e5                	mov    %esp,%ebp
f0103eff:	57                   	push   %edi
f0103f00:	56                   	push   %esi
f0103f01:	53                   	push   %ebx
f0103f02:	83 ec 3c             	sub    $0x3c,%esp
f0103f05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();
f0103f08:	e8 7c f9 ff ff       	call   f0103889 <rcr2>
f0103f0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Handle kernel-mode page faults.
	// If page fault happens in kernel-mode, panic
	if (!(tf->tf_cs & 0x3))
f0103f10:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103f14:	0f 84 1d 01 00 00    	je     f0104037 <page_fault_handler+0x13f>
	//
	// Hints:
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').
	if (curenv->env_pgfault_upcall) {
f0103f1a:	e8 2d 1f 00 00       	call   f0105e4c <cpunum>
f0103f1f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f22:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f0103f28:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0103f2c:	0f 84 8d 01 00 00    	je     f01040bf <page_fault_handler+0x1c7>
		uint32_t exstk = (UXSTACKTOP - PGSIZE);
		uint32_t exstk_top = (UXSTACKTOP - 1);
		struct UTrapframe utf;

		user_mem_assert(curenv, (void *) exstk, PGSIZE, PTE_U | PTE_W);
f0103f32:	e8 15 1f 00 00       	call   f0105e4c <cpunum>
f0103f37:	6a 06                	push   $0x6
f0103f39:	68 00 10 00 00       	push   $0x1000
f0103f3e:	68 00 f0 bf ee       	push   $0xeebff000
f0103f43:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f46:	ff b0 28 90 24 f0    	pushl  -0xfdb6fd8(%eax)
f0103f4c:	e8 e5 ee ff ff       	call   f0102e36 <user_mem_assert>

		utf.utf_fault_va = fault_va;
		utf.utf_err = tf->tf_err;
f0103f51:	8b 7b 2c             	mov    0x2c(%ebx),%edi

		utf.utf_regs = tf->tf_regs;
f0103f54:	8b 03                	mov    (%ebx),%eax
f0103f56:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103f59:	8b 43 04             	mov    0x4(%ebx),%eax
f0103f5c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103f5f:	8b 43 08             	mov    0x8(%ebx),%eax
f0103f62:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103f65:	8b 43 0c             	mov    0xc(%ebx),%eax
f0103f68:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103f6b:	8b 43 10             	mov    0x10(%ebx),%eax
f0103f6e:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0103f71:	8b 43 14             	mov    0x14(%ebx),%eax
f0103f74:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0103f77:	8b 43 18             	mov    0x18(%ebx),%eax
f0103f7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0103f7d:	8b 43 1c             	mov    0x1c(%ebx),%eax
f0103f80:	89 45 c0             	mov    %eax,-0x40(%ebp)
		utf.utf_eip = tf->tf_eip;
f0103f83:	8b 43 30             	mov    0x30(%ebx),%eax
f0103f86:	89 45 e0             	mov    %eax,-0x20(%ebp)
		utf.utf_eflags = tf->tf_eflags;
f0103f89:	8b 73 38             	mov    0x38(%ebx),%esi
		utf.utf_esp = tf->tf_esp;
f0103f8c:	8b 53 3c             	mov    0x3c(%ebx),%edx

		uint32_t tmp = utf.utf_esp;

		if (utf.utf_esp < exstk || utf.utf_esp > exstk_top) {
f0103f8f:	8d 82 00 10 40 11    	lea    0x11401000(%edx),%eax
f0103f95:	83 c4 10             	add    $0x10,%esp
f0103f98:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0103f9d:	0f 86 ab 00 00 00    	jbe    f010404e <page_fault_handler+0x156>
		} else {
			tmp -= sizeof(uint32_t);
			*(uint32_t *) (tmp) = 0;
			tmp -= sizeof(struct UTrapframe);
		}
		*(struct UTrapframe *) (tmp) = utf;
f0103fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103fa6:	a3 cb ff bf ee       	mov    %eax,0xeebfffcb
f0103fab:	89 3d cf ff bf ee    	mov    %edi,0xeebfffcf
f0103fb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103fb4:	a3 d3 ff bf ee       	mov    %eax,0xeebfffd3
f0103fb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103fbc:	a3 d7 ff bf ee       	mov    %eax,0xeebfffd7
f0103fc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103fc4:	a3 db ff bf ee       	mov    %eax,0xeebfffdb
f0103fc9:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103fcc:	a3 df ff bf ee       	mov    %eax,0xeebfffdf
f0103fd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103fd4:	a3 e3 ff bf ee       	mov    %eax,0xeebfffe3
f0103fd9:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0103fdc:	a3 e7 ff bf ee       	mov    %eax,0xeebfffe7
f0103fe1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0103fe4:	a3 eb ff bf ee       	mov    %eax,0xeebfffeb
f0103fe9:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0103fec:	a3 ef ff bf ee       	mov    %eax,0xeebfffef
f0103ff1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103ff4:	a3 f3 ff bf ee       	mov    %eax,0xeebffff3
f0103ff9:	89 35 f7 ff bf ee    	mov    %esi,0xeebffff7
f0103fff:	89 15 fb ff bf ee    	mov    %edx,0xeebffffb
			tmp = exstk_top - sizeof(struct UTrapframe);
f0104005:	b8 cb ff bf ee       	mov    $0xeebfffcb,%eax

		if (tmp < exstk || tmp > exstk_top)
			panic("page_fault_handler: exception stack overflow");

		tf->tf_esp = tmp;
f010400a:	89 43 3c             	mov    %eax,0x3c(%ebx)
		tf->tf_eip = (uint32_t) curenv->env_pgfault_upcall;
f010400d:	e8 3a 1e 00 00       	call   f0105e4c <cpunum>
f0104012:	6b c0 74             	imul   $0x74,%eax,%eax
f0104015:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f010401b:	8b 40 64             	mov    0x64(%eax),%eax
f010401e:	89 43 30             	mov    %eax,0x30(%ebx)
		env_run(curenv);
f0104021:	e8 26 1e 00 00       	call   f0105e4c <cpunum>
f0104026:	83 ec 0c             	sub    $0xc,%esp
f0104029:	6b c0 74             	imul   $0x74,%eax,%eax
f010402c:	ff b0 28 90 24 f0    	pushl  -0xfdb6fd8(%eax)
f0104032:	e8 67 f5 ff ff       	call   f010359e <env_run>
		panic("page fault in kernel mode\n");
f0104037:	83 ec 04             	sub    $0x4,%esp
f010403a:	68 77 79 10 f0       	push   $0xf0107977
f010403f:	68 3a 01 00 00       	push   $0x13a
f0104044:	68 92 79 10 f0       	push   $0xf0107992
f0104049:	e8 1c c0 ff ff       	call   f010006a <_panic>
			*(uint32_t *) (tmp) = 0;
f010404e:	c7 42 fc 00 00 00 00 	movl   $0x0,-0x4(%edx)
			tmp -= sizeof(struct UTrapframe);
f0104055:	8d 42 c8             	lea    -0x38(%edx),%eax
		*(struct UTrapframe *) (tmp) = utf;
f0104058:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010405b:	89 4a c8             	mov    %ecx,-0x38(%edx)
f010405e:	89 78 04             	mov    %edi,0x4(%eax)
f0104061:	8b 7d dc             	mov    -0x24(%ebp),%edi
f0104064:	89 78 08             	mov    %edi,0x8(%eax)
f0104067:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f010406a:	89 48 0c             	mov    %ecx,0xc(%eax)
f010406d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0104070:	89 48 10             	mov    %ecx,0x10(%eax)
f0104073:	8b 7d d0             	mov    -0x30(%ebp),%edi
f0104076:	89 78 14             	mov    %edi,0x14(%eax)
f0104079:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010407c:	89 48 18             	mov    %ecx,0x18(%eax)
f010407f:	8b 7d c8             	mov    -0x38(%ebp),%edi
f0104082:	89 78 1c             	mov    %edi,0x1c(%eax)
f0104085:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0104088:	89 48 20             	mov    %ecx,0x20(%eax)
f010408b:	8b 7d c0             	mov    -0x40(%ebp),%edi
f010408e:	89 78 24             	mov    %edi,0x24(%eax)
f0104091:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0104094:	89 48 28             	mov    %ecx,0x28(%eax)
f0104097:	89 70 2c             	mov    %esi,0x2c(%eax)
f010409a:	89 50 30             	mov    %edx,0x30(%eax)
		if (tmp < exstk || tmp > exstk_top)
f010409d:	3d ff ef bf ee       	cmp    $0xeebfefff,%eax
f01040a2:	0f 87 62 ff ff ff    	ja     f010400a <page_fault_handler+0x112>
			panic("page_fault_handler: exception stack overflow");
f01040a8:	83 ec 04             	sub    $0x4,%esp
f01040ab:	68 38 7b 10 f0       	push   $0xf0107b38
f01040b0:	68 75 01 00 00       	push   $0x175
f01040b5:	68 92 79 10 f0       	push   $0xf0107992
f01040ba:	e8 ab bf ff ff       	call   f010006a <_panic>
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01040bf:	8b 7b 30             	mov    0x30(%ebx),%edi
	        curenv->env_id,
f01040c2:	e8 85 1d 00 00       	call   f0105e4c <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01040c7:	57                   	push   %edi
f01040c8:	ff 75 e4             	pushl  -0x1c(%ebp)
	        curenv->env_id,
f01040cb:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01040ce:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f01040d4:	ff 70 48             	pushl  0x48(%eax)
f01040d7:	68 68 7b 10 f0       	push   $0xf0107b68
f01040dc:	e8 88 f7 ff ff       	call   f0103869 <cprintf>
	        fault_va,
	        tf->tf_eip);
	print_trapframe(tf);
f01040e1:	89 1c 24             	mov    %ebx,(%esp)
f01040e4:	e8 9e fc ff ff       	call   f0103d87 <print_trapframe>
	env_destroy(curenv);
f01040e9:	e8 5e 1d 00 00       	call   f0105e4c <cpunum>
f01040ee:	83 c4 04             	add    $0x4,%esp
f01040f1:	6b c0 74             	imul   $0x74,%eax,%eax
f01040f4:	ff b0 28 90 24 f0    	pushl  -0xfdb6fd8(%eax)
f01040fa:	e8 14 f4 ff ff       	call   f0103513 <env_destroy>
}
f01040ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104102:	5b                   	pop    %ebx
f0104103:	5e                   	pop    %esi
f0104104:	5f                   	pop    %edi
f0104105:	5d                   	pop    %ebp
f0104106:	c3                   	ret    

f0104107 <trap_dispatch>:
{
f0104107:	55                   	push   %ebp
f0104108:	89 e5                	mov    %esp,%ebp
f010410a:	53                   	push   %ebx
f010410b:	83 ec 04             	sub    $0x4,%esp
f010410e:	89 c3                	mov    %eax,%ebx
	switch (tf->tf_trapno) {
f0104110:	8b 40 28             	mov    0x28(%eax),%eax
f0104113:	83 f8 0e             	cmp    $0xe,%eax
f0104116:	74 57                	je     f010416f <trap_dispatch+0x68>
f0104118:	83 f8 30             	cmp    $0x30,%eax
f010411b:	74 60                	je     f010417d <trap_dispatch+0x76>
f010411d:	83 f8 03             	cmp    $0x3,%eax
f0104120:	74 3c                	je     f010415e <trap_dispatch+0x57>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0104122:	83 f8 27             	cmp    $0x27,%eax
f0104125:	74 77                	je     f010419e <trap_dispatch+0x97>
	switch (tf->tf_trapno - IRQ_OFFSET) {
f0104127:	83 f8 20             	cmp    $0x20,%eax
f010412a:	0f 84 88 00 00 00    	je     f01041b8 <trap_dispatch+0xb1>
	print_trapframe(tf);
f0104130:	83 ec 0c             	sub    $0xc,%esp
f0104133:	53                   	push   %ebx
f0104134:	e8 4e fc ff ff       	call   f0103d87 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0104139:	83 c4 10             	add    $0x10,%esp
f010413c:	66 83 7b 34 08       	cmpw   $0x8,0x34(%ebx)
f0104141:	74 7f                	je     f01041c2 <trap_dispatch+0xbb>
		env_destroy(curenv);
f0104143:	e8 04 1d 00 00       	call   f0105e4c <cpunum>
f0104148:	83 ec 0c             	sub    $0xc,%esp
f010414b:	6b c0 74             	imul   $0x74,%eax,%eax
f010414e:	ff b0 28 90 24 f0    	pushl  -0xfdb6fd8(%eax)
f0104154:	e8 ba f3 ff ff       	call   f0103513 <env_destroy>
		return;
f0104159:	83 c4 10             	add    $0x10,%esp
f010415c:	eb 0c                	jmp    f010416a <trap_dispatch+0x63>
		monitor(tf);
f010415e:	83 ec 0c             	sub    $0xc,%esp
f0104161:	53                   	push   %ebx
f0104162:	e8 fa c9 ff ff       	call   f0100b61 <monitor>
		return;
f0104167:	83 c4 10             	add    $0x10,%esp
}
f010416a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010416d:	c9                   	leave  
f010416e:	c3                   	ret    
		page_fault_handler(tf);
f010416f:	83 ec 0c             	sub    $0xc,%esp
f0104172:	53                   	push   %ebx
f0104173:	e8 80 fd ff ff       	call   f0103ef8 <page_fault_handler>
		return;
f0104178:	83 c4 10             	add    $0x10,%esp
f010417b:	eb ed                	jmp    f010416a <trap_dispatch+0x63>
		tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax,
f010417d:	83 ec 08             	sub    $0x8,%esp
f0104180:	ff 73 04             	pushl  0x4(%ebx)
f0104183:	ff 33                	pushl  (%ebx)
f0104185:	ff 73 10             	pushl  0x10(%ebx)
f0104188:	ff 73 18             	pushl  0x18(%ebx)
f010418b:	ff 73 14             	pushl  0x14(%ebx)
f010418e:	ff 73 1c             	pushl  0x1c(%ebx)
f0104191:	e8 c4 09 00 00       	call   f0104b5a <syscall>
f0104196:	89 43 1c             	mov    %eax,0x1c(%ebx)
		return;
f0104199:	83 c4 20             	add    $0x20,%esp
f010419c:	eb cc                	jmp    f010416a <trap_dispatch+0x63>
		cprintf("Spurious interrupt on irq 7\n");
f010419e:	83 ec 0c             	sub    $0xc,%esp
f01041a1:	68 9e 79 10 f0       	push   $0xf010799e
f01041a6:	e8 be f6 ff ff       	call   f0103869 <cprintf>
		print_trapframe(tf);
f01041ab:	89 1c 24             	mov    %ebx,(%esp)
f01041ae:	e8 d4 fb ff ff       	call   f0103d87 <print_trapframe>
		return;
f01041b3:	83 c4 10             	add    $0x10,%esp
f01041b6:	eb b2                	jmp    f010416a <trap_dispatch+0x63>
		lapic_eoi();
f01041b8:	e8 de 1d 00 00       	call   f0105f9b <lapic_eoi>
		sched_yield();
f01041bd:	e8 24 03 00 00       	call   f01044e6 <sched_yield>
		panic("unhandled trap in kernel");
f01041c2:	83 ec 04             	sub    $0x4,%esp
f01041c5:	68 bb 79 10 f0       	push   $0xf01079bb
f01041ca:	68 ed 00 00 00       	push   $0xed
f01041cf:	68 92 79 10 f0       	push   $0xf0107992
f01041d4:	e8 91 be ff ff       	call   f010006a <_panic>

f01041d9 <trap>:
{
f01041d9:	f3 0f 1e fb          	endbr32 
f01041dd:	55                   	push   %ebp
f01041de:	89 e5                	mov    %esp,%ebp
f01041e0:	57                   	push   %edi
f01041e1:	56                   	push   %esi
f01041e2:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f01041e5:	fc                   	cld    
	if (panicstr)
f01041e6:	83 3d 80 8e 24 f0 00 	cmpl   $0x0,0xf0248e80
f01041ed:	74 01                	je     f01041f0 <trap+0x17>
		asm volatile("hlt");
f01041ef:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f01041f0:	e8 57 1c 00 00       	call   f0105e4c <cpunum>
f01041f5:	6b c0 74             	imul   $0x74,%eax,%eax
f01041f8:	05 24 90 24 f0       	add    $0xf0249024,%eax
f01041fd:	ba 01 00 00 00       	mov    $0x1,%edx
f0104202:	e8 89 f6 ff ff       	call   f0103890 <xchg>
f0104207:	83 f8 02             	cmp    $0x2,%eax
f010420a:	74 52                	je     f010425e <trap+0x85>
	assert(!(read_eflags() & FL_IF));
f010420c:	e8 7c f6 ff ff       	call   f010388d <read_eflags>
f0104211:	f6 c4 02             	test   $0x2,%ah
f0104214:	75 4f                	jne    f0104265 <trap+0x8c>
	if ((tf->tf_cs & 3) == 3) {
f0104216:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f010421a:	83 e0 03             	and    $0x3,%eax
f010421d:	66 83 f8 03          	cmp    $0x3,%ax
f0104221:	74 5b                	je     f010427e <trap+0xa5>
	last_tf = tf;
f0104223:	89 35 60 8a 24 f0    	mov    %esi,0xf0248a60
	trap_dispatch(tf);
f0104229:	89 f0                	mov    %esi,%eax
f010422b:	e8 d7 fe ff ff       	call   f0104107 <trap_dispatch>
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104230:	e8 17 1c 00 00       	call   f0105e4c <cpunum>
f0104235:	6b c0 74             	imul   $0x74,%eax,%eax
f0104238:	83 b8 28 90 24 f0 00 	cmpl   $0x0,-0xfdb6fd8(%eax)
f010423f:	74 18                	je     f0104259 <trap+0x80>
f0104241:	e8 06 1c 00 00       	call   f0105e4c <cpunum>
f0104246:	6b c0 74             	imul   $0x74,%eax,%eax
f0104249:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f010424f:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104253:	0f 84 bf 00 00 00    	je     f0104318 <trap+0x13f>
		sched_yield();
f0104259:	e8 88 02 00 00       	call   f01044e6 <sched_yield>
		lock_kernel();
f010425e:	e8 63 f6 ff ff       	call   f01038c6 <lock_kernel>
f0104263:	eb a7                	jmp    f010420c <trap+0x33>
	assert(!(read_eflags() & FL_IF));
f0104265:	68 d4 79 10 f0       	push   $0xf01079d4
f010426a:	68 2b 74 10 f0       	push   $0xf010742b
f010426f:	68 07 01 00 00       	push   $0x107
f0104274:	68 92 79 10 f0       	push   $0xf0107992
f0104279:	e8 ec bd ff ff       	call   f010006a <_panic>
		lock_kernel();
f010427e:	e8 43 f6 ff ff       	call   f01038c6 <lock_kernel>
		assert(curenv);
f0104283:	e8 c4 1b 00 00       	call   f0105e4c <cpunum>
f0104288:	6b c0 74             	imul   $0x74,%eax,%eax
f010428b:	83 b8 28 90 24 f0 00 	cmpl   $0x0,-0xfdb6fd8(%eax)
f0104292:	74 3e                	je     f01042d2 <trap+0xf9>
		if (curenv->env_status == ENV_DYING) {
f0104294:	e8 b3 1b 00 00       	call   f0105e4c <cpunum>
f0104299:	6b c0 74             	imul   $0x74,%eax,%eax
f010429c:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f01042a2:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01042a6:	74 43                	je     f01042eb <trap+0x112>
		curenv->env_tf = *tf;
f01042a8:	e8 9f 1b 00 00       	call   f0105e4c <cpunum>
f01042ad:	6b c0 74             	imul   $0x74,%eax,%eax
f01042b0:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f01042b6:	b9 11 00 00 00       	mov    $0x11,%ecx
f01042bb:	89 c7                	mov    %eax,%edi
f01042bd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f01042bf:	e8 88 1b 00 00       	call   f0105e4c <cpunum>
f01042c4:	6b c0 74             	imul   $0x74,%eax,%eax
f01042c7:	8b b0 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%esi
f01042cd:	e9 51 ff ff ff       	jmp    f0104223 <trap+0x4a>
		assert(curenv);
f01042d2:	68 ed 79 10 f0       	push   $0xf01079ed
f01042d7:	68 2b 74 10 f0       	push   $0xf010742b
f01042dc:	68 0e 01 00 00       	push   $0x10e
f01042e1:	68 92 79 10 f0       	push   $0xf0107992
f01042e6:	e8 7f bd ff ff       	call   f010006a <_panic>
			env_free(curenv);
f01042eb:	e8 5c 1b 00 00       	call   f0105e4c <cpunum>
f01042f0:	83 ec 0c             	sub    $0xc,%esp
f01042f3:	6b c0 74             	imul   $0x74,%eax,%eax
f01042f6:	ff b0 28 90 24 f0    	pushl  -0xfdb6fd8(%eax)
f01042fc:	e8 b9 f0 ff ff       	call   f01033ba <env_free>
			curenv = NULL;
f0104301:	e8 46 1b 00 00       	call   f0105e4c <cpunum>
f0104306:	6b c0 74             	imul   $0x74,%eax,%eax
f0104309:	c7 80 28 90 24 f0 00 	movl   $0x0,-0xfdb6fd8(%eax)
f0104310:	00 00 00 
			sched_yield();
f0104313:	e8 ce 01 00 00       	call   f01044e6 <sched_yield>
		env_run(curenv);
f0104318:	e8 2f 1b 00 00       	call   f0105e4c <cpunum>
f010431d:	83 ec 0c             	sub    $0xc,%esp
f0104320:	6b c0 74             	imul   $0x74,%eax,%eax
f0104323:	ff b0 28 90 24 f0    	pushl  -0xfdb6fd8(%eax)
f0104329:	e8 70 f2 ff ff       	call   f010359e <env_run>

f010432e <trap0>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

TRAPHANDLER_NOEC(trap0, T_DIVIDE)
f010432e:	6a 00                	push   $0x0
f0104330:	6a 00                	push   $0x0
f0104332:	eb 70                	jmp    f01043a4 <_alltraps>

f0104334 <trap1>:
TRAPHANDLER_NOEC(trap1, T_DEBUG)
f0104334:	6a 00                	push   $0x0
f0104336:	6a 01                	push   $0x1
f0104338:	eb 6a                	jmp    f01043a4 <_alltraps>

f010433a <trap2>:
TRAPHANDLER_NOEC(trap2, T_NMI)
f010433a:	6a 00                	push   $0x0
f010433c:	6a 02                	push   $0x2
f010433e:	eb 64                	jmp    f01043a4 <_alltraps>

f0104340 <trap3>:
TRAPHANDLER_NOEC(trap3, T_BRKPT)
f0104340:	6a 00                	push   $0x0
f0104342:	6a 03                	push   $0x3
f0104344:	eb 5e                	jmp    f01043a4 <_alltraps>

f0104346 <trap4>:
TRAPHANDLER_NOEC(trap4, T_OFLOW)
f0104346:	6a 00                	push   $0x0
f0104348:	6a 04                	push   $0x4
f010434a:	eb 58                	jmp    f01043a4 <_alltraps>

f010434c <trap5>:
TRAPHANDLER_NOEC(trap5, T_BOUND)
f010434c:	6a 00                	push   $0x0
f010434e:	6a 05                	push   $0x5
f0104350:	eb 52                	jmp    f01043a4 <_alltraps>

f0104352 <trap6>:
TRAPHANDLER_NOEC(trap6, T_ILLOP)
f0104352:	6a 00                	push   $0x0
f0104354:	6a 06                	push   $0x6
f0104356:	eb 4c                	jmp    f01043a4 <_alltraps>

f0104358 <trap7>:
TRAPHANDLER_NOEC(trap7, T_DEVICE)
f0104358:	6a 00                	push   $0x0
f010435a:	6a 07                	push   $0x7
f010435c:	eb 46                	jmp    f01043a4 <_alltraps>

f010435e <trap8>:
TRAPHANDLER(trap8, T_DBLFLT)
f010435e:	6a 08                	push   $0x8
f0104360:	eb 42                	jmp    f01043a4 <_alltraps>

f0104362 <trap9>:
TRAPHANDLER_NOEC(trap9, 9)
f0104362:	6a 00                	push   $0x0
f0104364:	6a 09                	push   $0x9
f0104366:	eb 3c                	jmp    f01043a4 <_alltraps>

f0104368 <trap10>:
TRAPHANDLER(trap10, T_TSS)
f0104368:	6a 0a                	push   $0xa
f010436a:	eb 38                	jmp    f01043a4 <_alltraps>

f010436c <trap11>:
TRAPHANDLER(trap11, T_SEGNP)
f010436c:	6a 0b                	push   $0xb
f010436e:	eb 34                	jmp    f01043a4 <_alltraps>

f0104370 <trap12>:
TRAPHANDLER(trap12, T_STACK)
f0104370:	6a 0c                	push   $0xc
f0104372:	eb 30                	jmp    f01043a4 <_alltraps>

f0104374 <trap13>:
TRAPHANDLER(trap13, T_GPFLT)
f0104374:	6a 0d                	push   $0xd
f0104376:	eb 2c                	jmp    f01043a4 <_alltraps>

f0104378 <trap14>:
TRAPHANDLER(trap14, T_PGFLT)
f0104378:	6a 0e                	push   $0xe
f010437a:	eb 28                	jmp    f01043a4 <_alltraps>

f010437c <trap15>:
TRAPHANDLER_NOEC(trap15, 15)
f010437c:	6a 00                	push   $0x0
f010437e:	6a 0f                	push   $0xf
f0104380:	eb 22                	jmp    f01043a4 <_alltraps>

f0104382 <trap16>:
TRAPHANDLER_NOEC(trap16, T_FPERR)
f0104382:	6a 00                	push   $0x0
f0104384:	6a 10                	push   $0x10
f0104386:	eb 1c                	jmp    f01043a4 <_alltraps>

f0104388 <trap17>:
TRAPHANDLER(trap17, T_ALIGN)
f0104388:	6a 11                	push   $0x11
f010438a:	eb 18                	jmp    f01043a4 <_alltraps>

f010438c <trap18>:
TRAPHANDLER_NOEC(trap18, T_MCHK)
f010438c:	6a 00                	push   $0x0
f010438e:	6a 12                	push   $0x12
f0104390:	eb 12                	jmp    f01043a4 <_alltraps>

f0104392 <trap19>:
TRAPHANDLER_NOEC(trap19, T_SIMDERR)
f0104392:	6a 00                	push   $0x0
f0104394:	6a 13                	push   $0x13
f0104396:	eb 0c                	jmp    f01043a4 <_alltraps>

f0104398 <trap32>:

TRAPHANDLER_NOEC(trap32, IRQ_OFFSET + IRQ_TIMER)
f0104398:	6a 00                	push   $0x0
f010439a:	6a 20                	push   $0x20
f010439c:	eb 06                	jmp    f01043a4 <_alltraps>

f010439e <trap48>:

TRAPHANDLER_NOEC(trap48, T_SYSCALL)
f010439e:	6a 00                	push   $0x0
f01043a0:	6a 30                	push   $0x30
f01043a2:	eb 00                	jmp    f01043a4 <_alltraps>

f01043a4 <_alltraps>:

/*
 * Your code here for _alltraps
 */
_alltraps:
    pushl %ds
f01043a4:	1e                   	push   %ds
    pushl %es
f01043a5:	06                   	push   %es
    pushal
f01043a6:	60                   	pusha  

    mov $GD_KD, %eax
f01043a7:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %eax, %ds
f01043ac:	8e d8                	mov    %eax,%ds
    movw %eax, %es
f01043ae:	8e c0                	mov    %eax,%es

    pushl %esp
f01043b0:	54                   	push   %esp

f01043b1:	e8 23 fe ff ff       	call   f01041d9 <trap>

f01043b6 <context_switch>:
 * This function does not return.
 */

.globl context_switch;
context_switch:
	add $4, %esp
f01043b6:	83 c4 04             	add    $0x4,%esp
	pop %eax /*eax holds the position of the struct trapframe*/
f01043b9:	58                   	pop    %eax
	/*add $4, %eax*/ /*eax holds the position of the push regs*/
	/*start pushing said registers in inverse order*/
	push 64(%eax)
f01043ba:	ff 70 40             	pushl  0x40(%eax)
	push 60(%eax)
f01043bd:	ff 70 3c             	pushl  0x3c(%eax)
	push 56(%eax)
f01043c0:	ff 70 38             	pushl  0x38(%eax)
	shl $2, %ebx
	add $3, %ebx
	push %ebx
*/

	push 52(%eax) /*this one is the cs push*/
f01043c3:	ff 70 34             	pushl  0x34(%eax)
	push 48(%eax)
f01043c6:	ff 70 30             	pushl  0x30(%eax)
	/*until here we push on the stack the values required by iret*/
	push 36(%eax) /*this is register ds*/
f01043c9:	ff 70 24             	pushl  0x24(%eax)
	push 32(%eax) /*this is register %es*/
f01043cc:	ff 70 20             	pushl  0x20(%eax)
	push 28(%eax)
f01043cf:	ff 70 1c             	pushl  0x1c(%eax)
	push 24(%eax)
f01043d2:	ff 70 18             	pushl  0x18(%eax)
	push 20(%eax)
f01043d5:	ff 70 14             	pushl  0x14(%eax)
	push 16(%eax)
f01043d8:	ff 70 10             	pushl  0x10(%eax)
	push 12(%eax)
f01043db:	ff 70 0c             	pushl  0xc(%eax)
	push 8(%eax)
f01043de:	ff 70 08             	pushl  0x8(%eax)
	push 4(%eax)
f01043e1:	ff 70 04             	pushl  0x4(%eax)
	push (%eax)
f01043e4:	ff 30                	pushl  (%eax)
	popal
f01043e6:	61                   	popa   
	/*registers already set*/
	pop %es 
f01043e7:	07                   	pop    %es
	pop %ds
f01043e8:	1f                   	pop    %ds
	/*from here, iret can be called*/
	iret
f01043e9:	cf                   	iret   

f01043ea <spin>:
spin:
	jmp spin
f01043ea:	eb fe                	jmp    f01043ea <spin>

f01043ec <lcr3>:
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01043ec:	0f 22 d8             	mov    %eax,%cr3
}
f01043ef:	c3                   	ret    

f01043f0 <xchg>:
{
f01043f0:	89 c1                	mov    %eax,%ecx
f01043f2:	89 d0                	mov    %edx,%eax
	asm volatile("lock; xchgl %0, %1"
f01043f4:	f0 87 01             	lock xchg %eax,(%ecx)
}
f01043f7:	c3                   	ret    

f01043f8 <_paddr>:
	if ((uint32_t)kva < KERNBASE)
f01043f8:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01043fe:	76 07                	jbe    f0104407 <_paddr+0xf>
	return (physaddr_t)kva - KERNBASE;
f0104400:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0104406:	c3                   	ret    
{
f0104407:	55                   	push   %ebp
f0104408:	89 e5                	mov    %esp,%ebp
f010440a:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010440d:	51                   	push   %ecx
f010440e:	68 50 65 10 f0       	push   $0xf0106550
f0104413:	52                   	push   %edx
f0104414:	50                   	push   %eax
f0104415:	e8 50 bc ff ff       	call   f010006a <_panic>

f010441a <unlock_kernel>:
{
f010441a:	55                   	push   %ebp
f010441b:	89 e5                	mov    %esp,%ebp
f010441d:	83 ec 14             	sub    $0x14,%esp
	spin_unlock(&kernel_lock);
f0104420:	68 c0 23 12 f0       	push   $0xf01223c0
f0104425:	e8 8d 1d 00 00       	call   f01061b7 <spin_unlock>
	asm volatile("pause");
f010442a:	f3 90                	pause  
}
f010442c:	83 c4 10             	add    $0x10,%esp
f010442f:	c9                   	leave  
f0104430:	c3                   	ret    

f0104431 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104431:	f3 0f 1e fb          	endbr32 
f0104435:	55                   	push   %ebp
f0104436:	89 e5                	mov    %esp,%ebp
f0104438:	83 ec 08             	sub    $0x8,%esp
f010443b:	a1 44 82 24 f0       	mov    0xf0248244,%eax
f0104440:	8d 50 54             	lea    0x54(%eax),%edx
	int i;
	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	size_t total_env = 0;
	for (i = 0; i < NENV; i++) {
f0104443:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f0104448:	8b 02                	mov    (%edx),%eax
f010444a:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f010444d:	83 f8 02             	cmp    $0x2,%eax
f0104450:	76 2d                	jbe    f010447f <sched_halt+0x4e>
	for (i = 0; i < NENV; i++) {
f0104452:	83 c1 01             	add    $0x1,%ecx
f0104455:	83 c2 7c             	add    $0x7c,%edx
f0104458:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f010445e:	75 e8                	jne    f0104448 <sched_halt+0x17>
			break;
		}
	}

	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104460:	83 ec 0c             	sub    $0xc,%esp
f0104463:	68 f0 7b 10 f0       	push   $0xf0107bf0
f0104468:	e8 fc f3 ff ff       	call   f0103869 <cprintf>
f010446d:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104470:	83 ec 0c             	sub    $0xc,%esp
f0104473:	6a 00                	push   $0x0
f0104475:	e8 e7 c6 ff ff       	call   f0100b61 <monitor>
f010447a:	83 c4 10             	add    $0x10,%esp
f010447d:	eb f1                	jmp    f0104470 <sched_halt+0x3f>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f010447f:	e8 c8 19 00 00       	call   f0105e4c <cpunum>
f0104484:	6b c0 74             	imul   $0x74,%eax,%eax
f0104487:	c7 80 28 90 24 f0 00 	movl   $0x0,-0xfdb6fd8(%eax)
f010448e:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104491:	8b 0d 8c 8e 24 f0    	mov    0xf0248e8c,%ecx
f0104497:	ba 55 00 00 00       	mov    $0x55,%edx
f010449c:	b8 19 7c 10 f0       	mov    $0xf0107c19,%eax
f01044a1:	e8 52 ff ff ff       	call   f01043f8 <_paddr>
f01044a6:	e8 41 ff ff ff       	call   f01043ec <lcr3>

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f01044ab:	e8 9c 19 00 00       	call   f0105e4c <cpunum>
f01044b0:	6b c0 74             	imul   $0x74,%eax,%eax
f01044b3:	05 24 90 24 f0       	add    $0xf0249024,%eax
f01044b8:	ba 02 00 00 00       	mov    $0x2,%edx
f01044bd:	e8 2e ff ff ff       	call   f01043f0 <xchg>

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();
f01044c2:	e8 53 ff ff ff       	call   f010441a <unlock_kernel>
	             "sti\n"
	             "1:\n"
	             "hlt\n"
	             "jmp 1b\n"
	             :
	             : "a"(thiscpu->cpu_ts.ts_esp0));
f01044c7:	e8 80 19 00 00       	call   f0105e4c <cpunum>
f01044cc:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile("movl $0, %%ebp\n"
f01044cf:	8b 80 30 90 24 f0    	mov    -0xfdb6fd0(%eax),%eax
f01044d5:	bd 00 00 00 00       	mov    $0x0,%ebp
f01044da:	89 c4                	mov    %eax,%esp
f01044dc:	6a 00                	push   $0x0
f01044de:	6a 00                	push   $0x0
f01044e0:	fb                   	sti    
f01044e1:	f4                   	hlt    
f01044e2:	eb fd                	jmp    f01044e1 <sched_halt+0xb0>
}
f01044e4:	c9                   	leave  
f01044e5:	c3                   	ret    

f01044e6 <sched_yield>:
{
f01044e6:	f3 0f 1e fb          	endbr32 
f01044ea:	55                   	push   %ebp
f01044eb:	89 e5                	mov    %esp,%ebp
f01044ed:	53                   	push   %ebx
f01044ee:	83 ec 04             	sub    $0x4,%esp
	struct Env *idle = curenv;
f01044f1:	e8 56 19 00 00       	call   f0105e4c <cpunum>
f01044f6:	6b c0 74             	imul   $0x74,%eax,%eax
f01044f9:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
	int envs_counter = 0;
f01044ff:	b9 00 00 00 00       	mov    $0x0,%ecx
	if (idle) {
f0104504:	85 c0                	test   %eax,%eax
f0104506:	74 0c                	je     f0104514 <sched_yield+0x2e>
		envs_counter = ENVX(idle->env_id);
f0104508:	8b 48 48             	mov    0x48(%eax),%ecx
f010450b:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		envs_counter++;
f0104511:	83 c1 01             	add    $0x1,%ecx
		if (envs[actual_env_id].env_status == ENV_RUNNABLE) {
f0104514:	8b 1d 44 82 24 f0    	mov    0xf0248244,%ebx
f010451a:	89 ca                	mov    %ecx,%edx
f010451c:	81 c1 00 04 00 00    	add    $0x400,%ecx
		size_t actual_env_id = (envs_counter + i) % NENV;
f0104522:	89 d0                	mov    %edx,%eax
f0104524:	25 ff 03 00 00       	and    $0x3ff,%eax
		if (envs[actual_env_id].env_status == ENV_RUNNABLE) {
f0104529:	6b c0 7c             	imul   $0x7c,%eax,%eax
f010452c:	01 d8                	add    %ebx,%eax
f010452e:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f0104532:	74 36                	je     f010456a <sched_yield+0x84>
f0104534:	83 c2 01             	add    $0x1,%edx
	while (i < NENV) {
f0104537:	39 ca                	cmp    %ecx,%edx
f0104539:	75 e7                	jne    f0104522 <sched_yield+0x3c>
	if (curenv) {
f010453b:	e8 0c 19 00 00       	call   f0105e4c <cpunum>
f0104540:	6b c0 74             	imul   $0x74,%eax,%eax
f0104543:	83 b8 28 90 24 f0 00 	cmpl   $0x0,-0xfdb6fd8(%eax)
f010454a:	74 14                	je     f0104560 <sched_yield+0x7a>
		if (curenv->env_status == ENV_RUNNING) {
f010454c:	e8 fb 18 00 00       	call   f0105e4c <cpunum>
f0104551:	6b c0 74             	imul   $0x74,%eax,%eax
f0104554:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f010455a:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010455e:	74 13                	je     f0104573 <sched_yield+0x8d>
	sched_halt();
f0104560:	e8 cc fe ff ff       	call   f0104431 <sched_halt>
}
f0104565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104568:	c9                   	leave  
f0104569:	c3                   	ret    
			env_run(&envs[actual_env_id]);
f010456a:	83 ec 0c             	sub    $0xc,%esp
f010456d:	50                   	push   %eax
f010456e:	e8 2b f0 ff ff       	call   f010359e <env_run>
			env_run(curenv);
f0104573:	e8 d4 18 00 00       	call   f0105e4c <cpunum>
f0104578:	83 ec 0c             	sub    $0xc,%esp
f010457b:	6b c0 74             	imul   $0x74,%eax,%eax
f010457e:	ff b0 28 90 24 f0    	pushl  -0xfdb6fd8(%eax)
f0104584:	e8 15 f0 ff ff       	call   f010359e <env_run>

f0104589 <check_perm>:


static int
check_perm(int perm, pte_t *pte)
{
	if (perm & (~PTE_SYSCALL))
f0104589:	89 c1                	mov    %eax,%ecx
f010458b:	81 e1 f8 f1 ff ff    	and    $0xfffff1f8,%ecx
f0104591:	75 2f                	jne    f01045c2 <check_perm+0x39>
{
f0104593:	55                   	push   %ebp
f0104594:	89 e5                	mov    %esp,%ebp
f0104596:	53                   	push   %ebx
		return -E_INVAL;

	if (!(perm & PTE_P) || !(perm & PTE_U))
f0104597:	89 c3                	mov    %eax,%ebx
f0104599:	83 e3 05             	and    $0x5,%ebx
f010459c:	83 fb 05             	cmp    $0x5,%ebx
f010459f:	75 29                	jne    f01045ca <check_perm+0x41>
		return -E_INVAL;

	if (pte) {
f01045a1:	85 d2                	test   %edx,%edx
f01045a3:	74 35                	je     f01045da <check_perm+0x51>
		if (*pte && !(*pte & PTE_P))
f01045a5:	8b 12                	mov    (%edx),%edx
f01045a7:	85 d2                	test   %edx,%edx
f01045a9:	74 05                	je     f01045b0 <check_perm+0x27>
f01045ab:	f6 c2 01             	test   $0x1,%dl
f01045ae:	74 21                	je     f01045d1 <check_perm+0x48>
			return -E_INVAL;

		if ((perm & PTE_W) && !(*pte & PTE_W))
f01045b0:	83 e0 02             	and    $0x2,%eax
f01045b3:	74 23                	je     f01045d8 <check_perm+0x4f>
			return -E_INVAL;
f01045b5:	f6 c2 02             	test   $0x2,%dl
f01045b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01045bd:	0f 44 c8             	cmove  %eax,%ecx
f01045c0:	eb 18                	jmp    f01045da <check_perm+0x51>
		return -E_INVAL;
f01045c2:	b9 fd ff ff ff       	mov    $0xfffffffd,%ecx
	}
	return 0;
}
f01045c7:	89 c8                	mov    %ecx,%eax
f01045c9:	c3                   	ret    
		return -E_INVAL;
f01045ca:	b9 fd ff ff ff       	mov    $0xfffffffd,%ecx
f01045cf:	eb 09                	jmp    f01045da <check_perm+0x51>
			return -E_INVAL;
f01045d1:	b9 fd ff ff ff       	mov    $0xfffffffd,%ecx
f01045d6:	eb 02                	jmp    f01045da <check_perm+0x51>
	return 0;
f01045d8:	89 c1                	mov    %eax,%ecx
}
f01045da:	89 c8                	mov    %ecx,%eax
f01045dc:	5b                   	pop    %ebx
f01045dd:	5d                   	pop    %ebp
f01045de:	c3                   	ret    

f01045df <sys_getenvid>:
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
f01045df:	55                   	push   %ebp
f01045e0:	89 e5                	mov    %esp,%ebp
f01045e2:	83 ec 08             	sub    $0x8,%esp
	return curenv->env_id;
f01045e5:	e8 62 18 00 00       	call   f0105e4c <cpunum>
f01045ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01045ed:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f01045f3:	8b 40 48             	mov    0x48(%eax),%eax
}
f01045f6:	c9                   	leave  
f01045f7:	c3                   	ret    

f01045f8 <sys_cputs>:
{
f01045f8:	55                   	push   %ebp
f01045f9:	89 e5                	mov    %esp,%ebp
f01045fb:	56                   	push   %esi
f01045fc:	53                   	push   %ebx
f01045fd:	89 c6                	mov    %eax,%esi
f01045ff:	89 d3                	mov    %edx,%ebx
	user_mem_assert(curenv, s, len, PTE_P | PTE_W | PTE_U);
f0104601:	e8 46 18 00 00       	call   f0105e4c <cpunum>
f0104606:	6a 07                	push   $0x7
f0104608:	53                   	push   %ebx
f0104609:	56                   	push   %esi
f010460a:	6b c0 74             	imul   $0x74,%eax,%eax
f010460d:	ff b0 28 90 24 f0    	pushl  -0xfdb6fd8(%eax)
f0104613:	e8 1e e8 ff ff       	call   f0102e36 <user_mem_assert>
	cprintf("%.*s", len, s);
f0104618:	83 c4 0c             	add    $0xc,%esp
f010461b:	56                   	push   %esi
f010461c:	53                   	push   %ebx
f010461d:	68 26 7c 10 f0       	push   $0xf0107c26
f0104622:	e8 42 f2 ff ff       	call   f0103869 <cprintf>
}
f0104627:	83 c4 10             	add    $0x10,%esp
f010462a:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010462d:	5b                   	pop    %ebx
f010462e:	5e                   	pop    %esi
f010462f:	5d                   	pop    %ebp
f0104630:	c3                   	ret    

f0104631 <sys_env_set_status>:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
f0104631:	55                   	push   %ebp
f0104632:	89 e5                	mov    %esp,%ebp
f0104634:	53                   	push   %ebx
f0104635:	83 ec 14             	sub    $0x14,%esp
f0104638:	89 d3                	mov    %edx,%ebx
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	if ((status != ENV_RUNNABLE) && (status != ENV_NOT_RUNNABLE))
f010463a:	8d 52 fe             	lea    -0x2(%edx),%edx
f010463d:	f7 c2 fd ff ff ff    	test   $0xfffffffd,%edx
f0104643:	75 21                	jne    f0104666 <sys_env_set_status+0x35>
		return -E_INVAL;

	struct Env *env;
	int r;
	if ((r = envid2env(envid, &env, 1)))
f0104645:	83 ec 04             	sub    $0x4,%esp
f0104648:	6a 01                	push   $0x1
f010464a:	8d 55 f4             	lea    -0xc(%ebp),%edx
f010464d:	52                   	push   %edx
f010464e:	50                   	push   %eax
f010464f:	e8 f1 ea ff ff       	call   f0103145 <envid2env>
f0104654:	83 c4 10             	add    $0x10,%esp
f0104657:	85 c0                	test   %eax,%eax
f0104659:	75 06                	jne    f0104661 <sys_env_set_status+0x30>
		return r;

	env->env_status = status;
f010465b:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010465e:	89 5a 54             	mov    %ebx,0x54(%edx)
	return 0;
	// panic("sys_env_set_status not implemented");
}
f0104661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104664:	c9                   	leave  
f0104665:	c3                   	ret    
		return -E_INVAL;
f0104666:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010466b:	eb f4                	jmp    f0104661 <sys_env_set_status+0x30>

f010466d <sys_env_set_pgfault_upcall>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
f010466d:	55                   	push   %ebp
f010466e:	89 e5                	mov    %esp,%ebp
f0104670:	56                   	push   %esi
f0104671:	53                   	push   %ebx
f0104672:	83 ec 14             	sub    $0x14,%esp
f0104675:	89 d6                	mov    %edx,%esi
	struct Env *env;
	int r;
	if ((r = envid2env(envid, &env, 1)))
f0104677:	6a 01                	push   $0x1
f0104679:	8d 55 f4             	lea    -0xc(%ebp),%edx
f010467c:	52                   	push   %edx
f010467d:	50                   	push   %eax
f010467e:	e8 c2 ea ff ff       	call   f0103145 <envid2env>
f0104683:	89 c3                	mov    %eax,%ebx
f0104685:	83 c4 10             	add    $0x10,%esp
f0104688:	85 c0                	test   %eax,%eax
f010468a:	74 09                	je     f0104695 <sys_env_set_pgfault_upcall+0x28>
	user_mem_assert(env, func, PGSIZE, PTE_P | PTE_U);

	env->env_pgfault_upcall = func;
	return 0;
	// panic("sys_env_set_pgfault_upcall not implemented");
}
f010468c:	89 d8                	mov    %ebx,%eax
f010468e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104691:	5b                   	pop    %ebx
f0104692:	5e                   	pop    %esi
f0104693:	5d                   	pop    %ebp
f0104694:	c3                   	ret    
	user_mem_assert(env, func, PGSIZE, PTE_P | PTE_U);
f0104695:	6a 05                	push   $0x5
f0104697:	68 00 10 00 00       	push   $0x1000
f010469c:	56                   	push   %esi
f010469d:	ff 75 f4             	pushl  -0xc(%ebp)
f01046a0:	e8 91 e7 ff ff       	call   f0102e36 <user_mem_assert>
	env->env_pgfault_upcall = func;
f01046a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01046a8:	89 70 64             	mov    %esi,0x64(%eax)
	return 0;
f01046ab:	83 c4 10             	add    $0x10,%esp
f01046ae:	eb dc                	jmp    f010468c <sys_env_set_pgfault_upcall+0x1f>

f01046b0 <sys_env_destroy>:
{
f01046b0:	55                   	push   %ebp
f01046b1:	89 e5                	mov    %esp,%ebp
f01046b3:	53                   	push   %ebx
f01046b4:	83 ec 18             	sub    $0x18,%esp
	if ((r = envid2env(envid, &e, 1)) < 0)
f01046b7:	6a 01                	push   $0x1
f01046b9:	8d 55 f4             	lea    -0xc(%ebp),%edx
f01046bc:	52                   	push   %edx
f01046bd:	50                   	push   %eax
f01046be:	e8 82 ea ff ff       	call   f0103145 <envid2env>
f01046c3:	83 c4 10             	add    $0x10,%esp
f01046c6:	85 c0                	test   %eax,%eax
f01046c8:	78 4b                	js     f0104715 <sys_env_destroy+0x65>
	if (e == curenv)
f01046ca:	e8 7d 17 00 00       	call   f0105e4c <cpunum>
f01046cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01046d2:	6b c0 74             	imul   $0x74,%eax,%eax
f01046d5:	39 90 28 90 24 f0    	cmp    %edx,-0xfdb6fd8(%eax)
f01046db:	74 3d                	je     f010471a <sys_env_destroy+0x6a>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01046dd:	8b 5a 48             	mov    0x48(%edx),%ebx
f01046e0:	e8 67 17 00 00       	call   f0105e4c <cpunum>
f01046e5:	83 ec 04             	sub    $0x4,%esp
f01046e8:	53                   	push   %ebx
f01046e9:	6b c0 74             	imul   $0x74,%eax,%eax
f01046ec:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f01046f2:	ff 70 48             	pushl  0x48(%eax)
f01046f5:	68 46 7c 10 f0       	push   $0xf0107c46
f01046fa:	e8 6a f1 ff ff       	call   f0103869 <cprintf>
f01046ff:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0104702:	83 ec 0c             	sub    $0xc,%esp
f0104705:	ff 75 f4             	pushl  -0xc(%ebp)
f0104708:	e8 06 ee ff ff       	call   f0103513 <env_destroy>
	return 0;
f010470d:	83 c4 10             	add    $0x10,%esp
f0104710:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104718:	c9                   	leave  
f0104719:	c3                   	ret    
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f010471a:	e8 2d 17 00 00       	call   f0105e4c <cpunum>
f010471f:	83 ec 08             	sub    $0x8,%esp
f0104722:	6b c0 74             	imul   $0x74,%eax,%eax
f0104725:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f010472b:	ff 70 48             	pushl  0x48(%eax)
f010472e:	68 2b 7c 10 f0       	push   $0xf0107c2b
f0104733:	e8 31 f1 ff ff       	call   f0103869 <cprintf>
f0104738:	83 c4 10             	add    $0x10,%esp
f010473b:	eb c5                	jmp    f0104702 <sys_env_destroy+0x52>

f010473d <sys_cgetc>:
{
f010473d:	55                   	push   %ebp
f010473e:	89 e5                	mov    %esp,%ebp
f0104740:	83 ec 08             	sub    $0x8,%esp
	return cons_getc();
f0104743:	e8 6a c1 ff ff       	call   f01008b2 <cons_getc>
}
f0104748:	c9                   	leave  
f0104749:	c3                   	ret    

f010474a <sys_exofork>:
{
f010474a:	55                   	push   %ebp
f010474b:	89 e5                	mov    %esp,%ebp
f010474d:	57                   	push   %edi
f010474e:	56                   	push   %esi
f010474f:	83 ec 10             	sub    $0x10,%esp
	if ((r = env_alloc(&newenv, curenv->env_id)))
f0104752:	e8 f5 16 00 00       	call   f0105e4c <cpunum>
f0104757:	83 ec 08             	sub    $0x8,%esp
f010475a:	6b c0 74             	imul   $0x74,%eax,%eax
f010475d:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f0104763:	ff 70 48             	pushl  0x48(%eax)
f0104766:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104769:	50                   	push   %eax
f010476a:	e8 fb ea ff ff       	call   f010326a <env_alloc>
f010476f:	83 c4 10             	add    $0x10,%esp
f0104772:	85 c0                	test   %eax,%eax
f0104774:	74 07                	je     f010477d <sys_exofork+0x33>
}
f0104776:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104779:	5e                   	pop    %esi
f010477a:	5f                   	pop    %edi
f010477b:	5d                   	pop    %ebp
f010477c:	c3                   	ret    
	newenv->env_status = ENV_NOT_RUNNABLE;
f010477d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104780:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	newenv->env_tf = curenv->env_tf;
f0104787:	e8 c0 16 00 00       	call   f0105e4c <cpunum>
f010478c:	6b c0 74             	imul   $0x74,%eax,%eax
f010478f:	8b b0 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%esi
f0104795:	b9 11 00 00 00       	mov    $0x11,%ecx
f010479a:	8b 7d f4             	mov    -0xc(%ebp),%edi
f010479d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	newenv->env_tf.tf_regs.reg_eax = 0;
f010479f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01047a2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return newenv->env_id;
f01047a9:	8b 40 48             	mov    0x48(%eax),%eax
f01047ac:	eb c8                	jmp    f0104776 <sys_exofork+0x2c>

f01047ae <env_page_alloc>:
{
f01047ae:	55                   	push   %ebp
f01047af:	89 e5                	mov    %esp,%ebp
f01047b1:	57                   	push   %edi
f01047b2:	56                   	push   %esi
f01047b3:	53                   	push   %ebx
f01047b4:	83 ec 0c             	sub    $0xc,%esp
f01047b7:	89 c6                	mov    %eax,%esi
f01047b9:	89 d7                	mov    %edx,%edi
f01047bb:	89 cb                	mov    %ecx,%ebx
	int err = check_perm(perm, NULL);
f01047bd:	ba 00 00 00 00       	mov    $0x0,%edx
f01047c2:	89 c8                	mov    %ecx,%eax
f01047c4:	e8 c0 fd ff ff       	call   f0104589 <check_perm>
	if (err < 0)
f01047c9:	85 c0                	test   %eax,%eax
f01047cb:	78 1f                	js     f01047ec <env_page_alloc+0x3e>
	struct PageInfo *p = page_alloc(ALLOC_ZERO);
f01047cd:	83 ec 0c             	sub    $0xc,%esp
f01047d0:	6a 01                	push   $0x1
f01047d2:	e8 f4 cb ff ff       	call   f01013cb <page_alloc>
	if (!p)
f01047d7:	83 c4 10             	add    $0x10,%esp
f01047da:	85 c0                	test   %eax,%eax
f01047dc:	74 16                	je     f01047f4 <env_page_alloc+0x46>
	return page_insert(env->env_pgdir, p, va, perm);
f01047de:	53                   	push   %ebx
f01047df:	57                   	push   %edi
f01047e0:	50                   	push   %eax
f01047e1:	ff 76 60             	pushl  0x60(%esi)
f01047e4:	e8 e2 d2 ff ff       	call   f0101acb <page_insert>
f01047e9:	83 c4 10             	add    $0x10,%esp
}
f01047ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01047ef:	5b                   	pop    %ebx
f01047f0:	5e                   	pop    %esi
f01047f1:	5f                   	pop    %edi
f01047f2:	5d                   	pop    %ebp
f01047f3:	c3                   	ret    
		return -E_NO_MEM;
f01047f4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01047f9:	eb f1                	jmp    f01047ec <env_page_alloc+0x3e>

f01047fb <sys_page_alloc>:
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	if (((uint32_t) va >= UTOP) || ((uint32_t) va % PGSIZE))
f01047fb:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f0104801:	77 42                	ja     f0104845 <sys_page_alloc+0x4a>
{
f0104803:	55                   	push   %ebp
f0104804:	89 e5                	mov    %esp,%ebp
f0104806:	56                   	push   %esi
f0104807:	53                   	push   %ebx
f0104808:	83 ec 10             	sub    $0x10,%esp
f010480b:	89 d3                	mov    %edx,%ebx
f010480d:	89 ce                	mov    %ecx,%esi
	if (((uint32_t) va >= UTOP) || ((uint32_t) va % PGSIZE))
f010480f:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0104815:	75 34                	jne    f010484b <sys_page_alloc+0x50>
		return -E_INVAL;

	struct Env *env;
	int r;
	if ((r = envid2env(envid, &env, 1)))
f0104817:	83 ec 04             	sub    $0x4,%esp
f010481a:	6a 01                	push   $0x1
f010481c:	8d 55 f4             	lea    -0xc(%ebp),%edx
f010481f:	52                   	push   %edx
f0104820:	50                   	push   %eax
f0104821:	e8 1f e9 ff ff       	call   f0103145 <envid2env>
f0104826:	83 c4 10             	add    $0x10,%esp
f0104829:	85 c0                	test   %eax,%eax
f010482b:	74 07                	je     f0104834 <sys_page_alloc+0x39>
		return r;

	// cprintf("[%08x] page_alloc at %08x\n", env->env_id, va);
	return env_page_alloc(env, va, perm | PTE_U | PTE_P);
}
f010482d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104830:	5b                   	pop    %ebx
f0104831:	5e                   	pop    %esi
f0104832:	5d                   	pop    %ebp
f0104833:	c3                   	ret    
	return env_page_alloc(env, va, perm | PTE_U | PTE_P);
f0104834:	83 ce 05             	or     $0x5,%esi
f0104837:	89 f1                	mov    %esi,%ecx
f0104839:	89 da                	mov    %ebx,%edx
f010483b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010483e:	e8 6b ff ff ff       	call   f01047ae <env_page_alloc>
f0104843:	eb e8                	jmp    f010482d <sys_page_alloc+0x32>
		return -E_INVAL;
f0104845:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
f010484a:	c3                   	ret    
		return -E_INVAL;
f010484b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104850:	eb db                	jmp    f010482d <sys_page_alloc+0x32>

f0104852 <env_page_map>:
{
f0104852:	55                   	push   %ebp
f0104853:	89 e5                	mov    %esp,%ebp
f0104855:	56                   	push   %esi
f0104856:	53                   	push   %ebx
f0104857:	83 ec 14             	sub    $0x14,%esp
f010485a:	89 cb                	mov    %ecx,%ebx
f010485c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *page = page_lookup(srcenv->env_pgdir, srcva, &srcpte);
f010485f:	8d 4d f4             	lea    -0xc(%ebp),%ecx
f0104862:	51                   	push   %ecx
f0104863:	52                   	push   %edx
f0104864:	ff 70 60             	pushl  0x60(%eax)
f0104867:	e8 c4 d0 ff ff       	call   f0101930 <page_lookup>
	if (!page)
f010486c:	83 c4 10             	add    $0x10,%esp
f010486f:	85 c0                	test   %eax,%eax
f0104871:	74 28                	je     f010489b <env_page_map+0x49>
	if ((perm & PTE_W) & ~(PTE_W & *srcpte))
f0104873:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104876:	8b 12                	mov    (%edx),%edx
f0104878:	83 e2 02             	and    $0x2,%edx
f010487b:	f7 d2                	not    %edx
f010487d:	21 f2                	and    %esi,%edx
f010487f:	f6 c2 02             	test   $0x2,%dl
f0104882:	75 1e                	jne    f01048a2 <env_page_map+0x50>
	return page_insert(dstenv->env_pgdir, page, dstva, perm);
f0104884:	56                   	push   %esi
f0104885:	ff 75 08             	pushl  0x8(%ebp)
f0104888:	50                   	push   %eax
f0104889:	ff 73 60             	pushl  0x60(%ebx)
f010488c:	e8 3a d2 ff ff       	call   f0101acb <page_insert>
f0104891:	83 c4 10             	add    $0x10,%esp
}
f0104894:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104897:	5b                   	pop    %ebx
f0104898:	5e                   	pop    %esi
f0104899:	5d                   	pop    %ebp
f010489a:	c3                   	ret    
		return -E_INVAL;
f010489b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01048a0:	eb f2                	jmp    f0104894 <env_page_map+0x42>
		return -E_INVAL;
f01048a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01048a7:	eb eb                	jmp    f0104894 <env_page_map+0x42>

f01048a9 <sys_page_map>:
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva, envid_t dstenvid, void *dstva, int perm)
{
f01048a9:	55                   	push   %ebp
f01048aa:	89 e5                	mov    %esp,%ebp
f01048ac:	57                   	push   %edi
f01048ad:	56                   	push   %esi
f01048ae:	53                   	push   %ebx
f01048af:	83 ec 1c             	sub    $0x1c,%esp
f01048b2:	8b 7d 08             	mov    0x8(%ebp),%edi
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// Check both va are >= UTOP and page-aligned
	if (((uint32_t) srcva >= UTOP) || ((uint32_t) srcva % PGSIZE))
f01048b5:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f01048bb:	77 6d                	ja     f010492a <sys_page_map+0x81>
f01048bd:	89 d3                	mov    %edx,%ebx
f01048bf:	89 ce                	mov    %ecx,%esi
f01048c1:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01048c7:	75 68                	jne    f0104931 <sys_page_map+0x88>
		return -E_INVAL;
	if (((uint32_t) dstva >= UTOP) || ((uint32_t) dstva % PGSIZE))
f01048c9:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f01048cf:	77 67                	ja     f0104938 <sys_page_map+0x8f>
f01048d1:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f01048d7:	75 66                	jne    f010493f <sys_page_map+0x96>

	int r;  // For errors

	struct Env *srcenv;
	struct Env *dstenv;
	if ((r = envid2env(srcenvid, &srcenv, 1)))
f01048d9:	83 ec 04             	sub    $0x4,%esp
f01048dc:	6a 01                	push   $0x1
f01048de:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01048e1:	52                   	push   %edx
f01048e2:	50                   	push   %eax
f01048e3:	e8 5d e8 ff ff       	call   f0103145 <envid2env>
f01048e8:	83 c4 10             	add    $0x10,%esp
f01048eb:	85 c0                	test   %eax,%eax
f01048ed:	74 08                	je     f01048f7 <sys_page_map+0x4e>
	// cprintf("[%08x] dstenv %08x\n", dstenv->env_id, dstva);
	// cprintf("[%08x] srcenv %08x\n", srcenv->env_id, srcva);


	return env_page_map(srcenv, srcva, dstenv, dstva, PTE_P | PTE_U | perm);
}
f01048ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01048f2:	5b                   	pop    %ebx
f01048f3:	5e                   	pop    %esi
f01048f4:	5f                   	pop    %edi
f01048f5:	5d                   	pop    %ebp
f01048f6:	c3                   	ret    
	if ((r = envid2env(dstenvid, &dstenv, 1)))
f01048f7:	83 ec 04             	sub    $0x4,%esp
f01048fa:	6a 01                	push   $0x1
f01048fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01048ff:	50                   	push   %eax
f0104900:	56                   	push   %esi
f0104901:	e8 3f e8 ff ff       	call   f0103145 <envid2env>
f0104906:	83 c4 10             	add    $0x10,%esp
f0104909:	85 c0                	test   %eax,%eax
f010490b:	75 e2                	jne    f01048ef <sys_page_map+0x46>
	return env_page_map(srcenv, srcva, dstenv, dstva, PTE_P | PTE_U | perm);
f010490d:	83 ec 08             	sub    $0x8,%esp
f0104910:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104913:	83 c8 05             	or     $0x5,%eax
f0104916:	50                   	push   %eax
f0104917:	57                   	push   %edi
f0104918:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010491b:	89 da                	mov    %ebx,%edx
f010491d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104920:	e8 2d ff ff ff       	call   f0104852 <env_page_map>
f0104925:	83 c4 10             	add    $0x10,%esp
f0104928:	eb c5                	jmp    f01048ef <sys_page_map+0x46>
		return -E_INVAL;
f010492a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010492f:	eb be                	jmp    f01048ef <sys_page_map+0x46>
f0104931:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104936:	eb b7                	jmp    f01048ef <sys_page_map+0x46>
		return -E_INVAL;
f0104938:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010493d:	eb b0                	jmp    f01048ef <sys_page_map+0x46>
f010493f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104944:	eb a9                	jmp    f01048ef <sys_page_map+0x46>

f0104946 <sys_ipc_try_send>:
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
f0104946:	55                   	push   %ebp
f0104947:	89 e5                	mov    %esp,%ebp
f0104949:	57                   	push   %edi
f010494a:	56                   	push   %esi
f010494b:	53                   	push   %ebx
f010494c:	83 ec 30             	sub    $0x30,%esp
f010494f:	89 d7                	mov    %edx,%edi
f0104951:	89 ce                	mov    %ecx,%esi
	struct Env *dstenv;
	int r;
	if ((r = envid2env(envid, &dstenv, 0)))
f0104953:	6a 00                	push   $0x0
f0104955:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104958:	52                   	push   %edx
f0104959:	50                   	push   %eax
f010495a:	e8 e6 e7 ff ff       	call   f0103145 <envid2env>
f010495f:	89 c3                	mov    %eax,%ebx
f0104961:	83 c4 10             	add    $0x10,%esp
f0104964:	85 c0                	test   %eax,%eax
f0104966:	0f 85 93 00 00 00    	jne    f01049ff <sys_ipc_try_send+0xb9>
		return r;

	if (!dstenv->env_ipc_recving)
f010496c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010496f:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104973:	0f 84 90 00 00 00    	je     f0104a09 <sys_ipc_try_send+0xc3>
		return -E_IPC_NOT_RECV;

	if (((uint32_t) srcva >= UTOP)) {
f0104979:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f010497f:	77 4b                	ja     f01049cc <sys_ipc_try_send+0x86>
		dstenv->env_ipc_perm = 0;
		goto bail;
	}

	if ((uint32_t) srcva % PGSIZE)
f0104981:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
f0104987:	0f 85 83 00 00 00    	jne    f0104a10 <sys_ipc_try_send+0xca>
		return -E_INVAL;
	pte_t *srcpte;
	page_lookup(curenv->env_pgdir, srcva, &srcpte);
f010498d:	e8 ba 14 00 00       	call   f0105e4c <cpunum>
f0104992:	83 ec 04             	sub    $0x4,%esp
f0104995:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104998:	52                   	push   %edx
f0104999:	56                   	push   %esi
f010499a:	6b c0 74             	imul   $0x74,%eax,%eax
f010499d:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f01049a3:	ff 70 60             	pushl  0x60(%eax)
f01049a6:	e8 85 cf ff ff       	call   f0101930 <page_lookup>
	if (*srcpte && !(*srcpte & PTE_P))
f01049ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01049ae:	8b 00                	mov    (%eax),%eax
f01049b0:	83 c4 10             	add    $0x10,%esp
f01049b3:	85 c0                	test   %eax,%eax
f01049b5:	74 76                	je     f0104a2d <sys_ipc_try_send+0xe7>
f01049b7:	a8 01                	test   $0x1,%al
f01049b9:	74 5c                	je     f0104a17 <sys_ipc_try_send+0xd1>
		return -E_INVAL;
	if ((perm & PTE_W) && !(*srcpte & PTE_W))
f01049bb:	f6 45 08 02          	testb  $0x2,0x8(%ebp)
f01049bf:	74 72                	je     f0104a33 <sys_ipc_try_send+0xed>
f01049c1:	a8 02                	test   $0x2,%al
f01049c3:	75 6e                	jne    f0104a33 <sys_ipc_try_send+0xed>
		return -E_INVAL;
f01049c5:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01049ca:	eb 33                	jmp    f01049ff <sys_ipc_try_send+0xb9>
		dstenv->env_ipc_perm = 0;
f01049cc:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
			return r;
		dstenv->env_ipc_perm = perm;
	}

bail:
	dstenv->env_ipc_from = (envid_t) curenv->env_id;
f01049d3:	e8 74 14 00 00       	call   f0105e4c <cpunum>
f01049d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01049db:	6b c0 74             	imul   $0x74,%eax,%eax
f01049de:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f01049e4:	8b 40 48             	mov    0x48(%eax),%eax
f01049e7:	89 42 74             	mov    %eax,0x74(%edx)
	dstenv->env_ipc_recving = false;
f01049ea:	c6 42 68 00          	movb   $0x0,0x68(%edx)
	dstenv->env_ipc_value = value;
f01049ee:	89 7a 70             	mov    %edi,0x70(%edx)
	dstenv->env_tf.tf_regs.reg_eax = 0;
f01049f1:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	dstenv->env_status = ENV_RUNNABLE;
f01049f8:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	return 0;
}
f01049ff:	89 d8                	mov    %ebx,%eax
f0104a01:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104a04:	5b                   	pop    %ebx
f0104a05:	5e                   	pop    %esi
f0104a06:	5f                   	pop    %edi
f0104a07:	5d                   	pop    %ebp
f0104a08:	c3                   	ret    
		return -E_IPC_NOT_RECV;
f0104a09:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f0104a0e:	eb ef                	jmp    f01049ff <sys_ipc_try_send+0xb9>
		return -E_INVAL;
f0104a10:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a15:	eb e8                	jmp    f01049ff <sys_ipc_try_send+0xb9>
		return -E_INVAL;
f0104a17:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a1c:	eb e1                	jmp    f01049ff <sys_ipc_try_send+0xb9>
			return r;
f0104a1e:	89 c3                	mov    %eax,%ebx
f0104a20:	eb dd                	jmp    f01049ff <sys_ipc_try_send+0xb9>
			return r;
f0104a22:	89 c3                	mov    %eax,%ebx
f0104a24:	eb d9                	jmp    f01049ff <sys_ipc_try_send+0xb9>
		return -E_INVAL;
f0104a26:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a2b:	eb d2                	jmp    f01049ff <sys_ipc_try_send+0xb9>
	if ((perm & PTE_W) && !(*srcpte & PTE_W))
f0104a2d:	f6 45 08 02          	testb  $0x2,0x8(%ebp)
f0104a31:	75 f3                	jne    f0104a26 <sys_ipc_try_send+0xe0>
	if (dstenv->env_ipc_dstva) {
f0104a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a36:	8b 50 6c             	mov    0x6c(%eax),%edx
f0104a39:	85 d2                	test   %edx,%edx
f0104a3b:	74 96                	je     f01049d3 <sys_ipc_try_send+0x8d>
	perm |= PTE_U | PTE_P;
f0104a3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104a40:	83 c9 05             	or     $0x5,%ecx
		if ((r = env_page_alloc(dstenv, dstenv->env_ipc_dstva, perm)) < 0)
f0104a43:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0104a46:	e8 63 fd ff ff       	call   f01047ae <env_page_alloc>
f0104a4b:	85 c0                	test   %eax,%eax
f0104a4d:	78 cf                	js     f0104a1e <sys_ipc_try_send+0xd8>
		             curenv, srcva, dstenv, dstenv->env_ipc_dstva, perm)) <
f0104a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		if ((r = env_page_map(
f0104a52:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104a55:	8b 50 6c             	mov    0x6c(%eax),%edx
f0104a58:	89 55 cc             	mov    %edx,-0x34(%ebp)
		             curenv, srcva, dstenv, dstenv->env_ipc_dstva, perm)) <
f0104a5b:	e8 ec 13 00 00       	call   f0105e4c <cpunum>
		if ((r = env_page_map(
f0104a60:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a63:	83 ec 08             	sub    $0x8,%esp
f0104a66:	ff 75 d4             	pushl  -0x2c(%ebp)
f0104a69:	ff 75 cc             	pushl  -0x34(%ebp)
f0104a6c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0104a6f:	89 f2                	mov    %esi,%edx
f0104a71:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f0104a77:	e8 d6 fd ff ff       	call   f0104852 <env_page_map>
f0104a7c:	83 c4 10             	add    $0x10,%esp
f0104a7f:	85 c0                	test   %eax,%eax
f0104a81:	78 9f                	js     f0104a22 <sys_ipc_try_send+0xdc>
		dstenv->env_ipc_perm = perm;
f0104a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a86:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0104a89:	89 48 78             	mov    %ecx,0x78(%eax)
f0104a8c:	e9 42 ff ff ff       	jmp    f01049d3 <sys_ipc_try_send+0x8d>

f0104a91 <sys_page_unmap>:
{
f0104a91:	55                   	push   %ebp
f0104a92:	89 e5                	mov    %esp,%ebp
f0104a94:	56                   	push   %esi
f0104a95:	53                   	push   %ebx
f0104a96:	83 ec 10             	sub    $0x10,%esp
	if (((uint32_t) va >= UTOP) || ((uint32_t) va % PGSIZE))
f0104a99:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f0104a9f:	77 3f                	ja     f0104ae0 <sys_page_unmap+0x4f>
f0104aa1:	89 d3                	mov    %edx,%ebx
f0104aa3:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0104aa9:	75 3c                	jne    f0104ae7 <sys_page_unmap+0x56>
	if ((r = envid2env(envid, &env, 1)))
f0104aab:	83 ec 04             	sub    $0x4,%esp
f0104aae:	6a 01                	push   $0x1
f0104ab0:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0104ab3:	52                   	push   %edx
f0104ab4:	50                   	push   %eax
f0104ab5:	e8 8b e6 ff ff       	call   f0103145 <envid2env>
f0104aba:	89 c6                	mov    %eax,%esi
f0104abc:	83 c4 10             	add    $0x10,%esp
f0104abf:	85 c0                	test   %eax,%eax
f0104ac1:	74 09                	je     f0104acc <sys_page_unmap+0x3b>
}
f0104ac3:	89 f0                	mov    %esi,%eax
f0104ac5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104ac8:	5b                   	pop    %ebx
f0104ac9:	5e                   	pop    %esi
f0104aca:	5d                   	pop    %ebp
f0104acb:	c3                   	ret    
	page_remove(env->env_pgdir, va);
f0104acc:	83 ec 08             	sub    $0x8,%esp
f0104acf:	53                   	push   %ebx
f0104ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104ad3:	ff 70 60             	pushl  0x60(%eax)
f0104ad6:	e8 d5 ce ff ff       	call   f01019b0 <page_remove>
	return 0;
f0104adb:	83 c4 10             	add    $0x10,%esp
f0104ade:	eb e3                	jmp    f0104ac3 <sys_page_unmap+0x32>
		return -E_INVAL;
f0104ae0:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f0104ae5:	eb dc                	jmp    f0104ac3 <sys_page_unmap+0x32>
f0104ae7:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f0104aec:	eb d5                	jmp    f0104ac3 <sys_page_unmap+0x32>

f0104aee <sys_yield>:
{
f0104aee:	55                   	push   %ebp
f0104aef:	89 e5                	mov    %esp,%ebp
f0104af1:	83 ec 08             	sub    $0x8,%esp
	sched_yield();
f0104af4:	e8 ed f9 ff ff       	call   f01044e6 <sched_yield>

f0104af9 <sys_ipc_recv>:
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
f0104af9:	55                   	push   %ebp
f0104afa:	89 e5                	mov    %esp,%ebp
f0104afc:	53                   	push   %ebx
f0104afd:	83 ec 04             	sub    $0x4,%esp
f0104b00:	89 c3                	mov    %eax,%ebx
	curenv->env_ipc_recving = true;
f0104b02:	e8 45 13 00 00       	call   f0105e4c <cpunum>
f0104b07:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b0a:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f0104b10:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	if (((uint32_t) dstva >= UTOP) || ((uint32_t) dstva % PGSIZE))
f0104b14:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0104b1a:	77 08                	ja     f0104b24 <sys_ipc_recv+0x2b>
f0104b1c:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f0104b22:	74 0b                	je     f0104b2f <sys_ipc_recv+0x36>
	curenv->env_status = ENV_NOT_RUNNABLE;

	sys_yield();
	panic("sys_ipc_recv should not return!");
	return 0;
}
f0104b24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104b29:	83 c4 04             	add    $0x4,%esp
f0104b2c:	5b                   	pop    %ebx
f0104b2d:	5d                   	pop    %ebp
f0104b2e:	c3                   	ret    
	curenv->env_ipc_dstva = dstva;
f0104b2f:	e8 18 13 00 00       	call   f0105e4c <cpunum>
f0104b34:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b37:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f0104b3d:	89 58 6c             	mov    %ebx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0104b40:	e8 07 13 00 00       	call   f0105e4c <cpunum>
f0104b45:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b48:	8b 80 28 90 24 f0    	mov    -0xfdb6fd8(%eax),%eax
f0104b4e:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sys_yield();
f0104b55:	e8 94 ff ff ff       	call   f0104aee <sys_yield>

f0104b5a <syscall>:

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104b5a:	f3 0f 1e fb          	endbr32 
f0104b5e:	55                   	push   %ebp
f0104b5f:	89 e5                	mov    %esp,%ebp
f0104b61:	83 ec 08             	sub    $0x8,%esp
f0104b64:	8b 45 08             	mov    0x8(%ebp),%eax
f0104b67:	83 f8 0c             	cmp    $0xc,%eax
f0104b6a:	0f 87 ba 00 00 00    	ja     f0104c2a <syscall+0xd0>
f0104b70:	3e ff 24 85 60 7c 10 	notrack jmp *-0xfef83a0(,%eax,4)
f0104b77:	f0 
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.

	switch (syscallno) {
	case SYS_cputs:
		sys_cputs((char *) a1, a2);
f0104b78:	8b 55 10             	mov    0x10(%ebp),%edx
f0104b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104b7e:	e8 75 fa ff ff       	call   f01045f8 <sys_cputs>
		return 0;
f0104b83:	b8 00 00 00 00       	mov    $0x0,%eax
	case SYS_yield:
		sys_yield();  // No return
	default:
		return -E_INVAL;
	}
}
f0104b88:	c9                   	leave  
f0104b89:	c3                   	ret    
		return sys_getenvid();
f0104b8a:	e8 50 fa ff ff       	call   f01045df <sys_getenvid>
f0104b8f:	eb f7                	jmp    f0104b88 <syscall+0x2e>
		return sys_env_destroy(a1);
f0104b91:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104b94:	e8 17 fb ff ff       	call   f01046b0 <sys_env_destroy>
f0104b99:	eb ed                	jmp    f0104b88 <syscall+0x2e>
		return sys_cgetc();
f0104b9b:	e8 9d fb ff ff       	call   f010473d <sys_cgetc>
f0104ba0:	eb e6                	jmp    f0104b88 <syscall+0x2e>
		return sys_exofork();
f0104ba2:	e8 a3 fb ff ff       	call   f010474a <sys_exofork>
f0104ba7:	eb df                	jmp    f0104b88 <syscall+0x2e>
		return sys_env_set_status(a1, a2);
f0104ba9:	8b 55 10             	mov    0x10(%ebp),%edx
f0104bac:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104baf:	e8 7d fa ff ff       	call   f0104631 <sys_env_set_status>
f0104bb4:	eb d2                	jmp    f0104b88 <syscall+0x2e>
		return sys_page_alloc(a1, (void *) a2, a3);
f0104bb6:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0104bb9:	8b 55 10             	mov    0x10(%ebp),%edx
f0104bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104bbf:	e8 37 fc ff ff       	call   f01047fb <sys_page_alloc>
f0104bc4:	eb c2                	jmp    f0104b88 <syscall+0x2e>
		return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
f0104bc6:	83 ec 08             	sub    $0x8,%esp
f0104bc9:	ff 75 1c             	pushl  0x1c(%ebp)
f0104bcc:	ff 75 18             	pushl  0x18(%ebp)
f0104bcf:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0104bd2:	8b 55 10             	mov    0x10(%ebp),%edx
f0104bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104bd8:	e8 cc fc ff ff       	call   f01048a9 <sys_page_map>
f0104bdd:	83 c4 10             	add    $0x10,%esp
f0104be0:	eb a6                	jmp    f0104b88 <syscall+0x2e>
		return sys_page_unmap(a1, (void *) a2);
f0104be2:	8b 55 10             	mov    0x10(%ebp),%edx
f0104be5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104be8:	e8 a4 fe ff ff       	call   f0104a91 <sys_page_unmap>
f0104bed:	eb 99                	jmp    f0104b88 <syscall+0x2e>
		return sys_ipc_recv((void *) a1);
f0104bef:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104bf2:	e8 02 ff ff ff       	call   f0104af9 <sys_ipc_recv>
f0104bf7:	eb 8f                	jmp    f0104b88 <syscall+0x2e>
		return sys_ipc_try_send(a1, a2, (void *) a3, a4);
f0104bf9:	83 ec 0c             	sub    $0xc,%esp
f0104bfc:	ff 75 18             	pushl  0x18(%ebp)
f0104bff:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0104c02:	8b 55 10             	mov    0x10(%ebp),%edx
f0104c05:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104c08:	e8 39 fd ff ff       	call   f0104946 <sys_ipc_try_send>
f0104c0d:	83 c4 10             	add    $0x10,%esp
f0104c10:	e9 73 ff ff ff       	jmp    f0104b88 <syscall+0x2e>
		return sys_env_set_pgfault_upcall(a1, (void *) a2);
f0104c15:	8b 55 10             	mov    0x10(%ebp),%edx
f0104c18:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104c1b:	e8 4d fa ff ff       	call   f010466d <sys_env_set_pgfault_upcall>
f0104c20:	e9 63 ff ff ff       	jmp    f0104b88 <syscall+0x2e>
		sys_yield();  // No return
f0104c25:	e8 c4 fe ff ff       	call   f0104aee <sys_yield>
		return 0;
f0104c2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c2f:	e9 54 ff ff ff       	jmp    f0104b88 <syscall+0x2e>

f0104c34 <stab_binsearch>:
stab_binsearch(const struct Stab *stabs,
               int *region_left,
               int *region_right,
               int type,
               uintptr_t addr)
{
f0104c34:	55                   	push   %ebp
f0104c35:	89 e5                	mov    %esp,%ebp
f0104c37:	57                   	push   %edi
f0104c38:	56                   	push   %esi
f0104c39:	53                   	push   %ebx
f0104c3a:	83 ec 14             	sub    $0x14,%esp
f0104c3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104c40:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104c43:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104c46:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104c49:	8b 1a                	mov    (%edx),%ebx
f0104c4b:	8b 01                	mov    (%ecx),%eax
f0104c4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104c50:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104c57:	eb 23                	jmp    f0104c7c <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {  // no match in [l, m]
			l = true_m + 1;
f0104c59:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0104c5c:	eb 1e                	jmp    f0104c7c <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104c5e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104c61:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104c64:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104c68:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104c6b:	73 46                	jae    f0104cb3 <stab_binsearch+0x7f>
			*region_left = m;
f0104c6d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104c70:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0104c72:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0104c75:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104c7c:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104c7f:	7f 5f                	jg     f0104ce0 <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f0104c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104c84:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0104c87:	89 d0                	mov    %edx,%eax
f0104c89:	c1 e8 1f             	shr    $0x1f,%eax
f0104c8c:	01 d0                	add    %edx,%eax
f0104c8e:	89 c7                	mov    %eax,%edi
f0104c90:	d1 ff                	sar    %edi
f0104c92:	83 e0 fe             	and    $0xfffffffe,%eax
f0104c95:	01 f8                	add    %edi,%eax
f0104c97:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104c9a:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104c9e:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104ca0:	39 c3                	cmp    %eax,%ebx
f0104ca2:	7f b5                	jg     f0104c59 <stab_binsearch+0x25>
f0104ca4:	0f b6 0a             	movzbl (%edx),%ecx
f0104ca7:	83 ea 0c             	sub    $0xc,%edx
f0104caa:	39 f1                	cmp    %esi,%ecx
f0104cac:	74 b0                	je     f0104c5e <stab_binsearch+0x2a>
			m--;
f0104cae:	83 e8 01             	sub    $0x1,%eax
f0104cb1:	eb ed                	jmp    f0104ca0 <stab_binsearch+0x6c>
		} else if (stabs[m].n_value > addr) {
f0104cb3:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104cb6:	76 14                	jbe    f0104ccc <stab_binsearch+0x98>
			*region_right = m - 1;
f0104cb8:	83 e8 01             	sub    $0x1,%eax
f0104cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104cbe:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104cc1:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0104cc3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104cca:	eb b0                	jmp    f0104c7c <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104ccc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104ccf:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0104cd1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104cd5:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0104cd7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104cde:	eb 9c                	jmp    f0104c7c <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0104ce0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104ce4:	75 15                	jne    f0104cfb <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0104ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104ce9:	8b 00                	mov    (%eax),%eax
f0104ceb:	83 e8 01             	sub    $0x1,%eax
f0104cee:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104cf1:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0104cf3:	83 c4 14             	add    $0x14,%esp
f0104cf6:	5b                   	pop    %ebx
f0104cf7:	5e                   	pop    %esi
f0104cf8:	5f                   	pop    %edi
f0104cf9:	5d                   	pop    %ebp
f0104cfa:	c3                   	ret    
		for (l = *region_right;
f0104cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104cfe:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104d00:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104d03:	8b 0f                	mov    (%edi),%ecx
f0104d05:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104d08:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0104d0b:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0104d0f:	eb 03                	jmp    f0104d14 <stab_binsearch+0xe0>
		     l--)
f0104d11:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104d14:	39 c1                	cmp    %eax,%ecx
f0104d16:	7d 0a                	jge    f0104d22 <stab_binsearch+0xee>
		     l > *region_left && stabs[l].n_type != type;
f0104d18:	0f b6 1a             	movzbl (%edx),%ebx
f0104d1b:	83 ea 0c             	sub    $0xc,%edx
f0104d1e:	39 f3                	cmp    %esi,%ebx
f0104d20:	75 ef                	jne    f0104d11 <stab_binsearch+0xdd>
		*region_left = l;
f0104d22:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104d25:	89 07                	mov    %eax,(%edi)
}
f0104d27:	eb ca                	jmp    f0104cf3 <stab_binsearch+0xbf>

f0104d29 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104d29:	f3 0f 1e fb          	endbr32 
f0104d2d:	55                   	push   %ebp
f0104d2e:	89 e5                	mov    %esp,%ebp
f0104d30:	57                   	push   %edi
f0104d31:	56                   	push   %esi
f0104d32:	53                   	push   %ebx
f0104d33:	83 ec 4c             	sub    $0x4c,%esp
f0104d36:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104d39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104d3c:	c7 03 94 7c 10 f0    	movl   $0xf0107c94,(%ebx)
	info->eip_line = 0;
f0104d42:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0104d49:	c7 43 08 94 7c 10 f0 	movl   $0xf0107c94,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0104d50:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0104d57:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0104d5a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104d61:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104d67:	0f 86 21 01 00 00    	jbe    f0104e8e <debuginfo_eip+0x165>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0104d6d:	c7 45 b8 2a 8b 11 f0 	movl   $0xf0118b2a,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104d74:	c7 45 b4 35 4b 11 f0 	movl   $0xf0114b35,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0104d7b:	be 34 4b 11 f0       	mov    $0xf0114b34,%esi
		stabs = __STAB_BEGIN__;
f0104d80:	c7 45 bc 74 81 10 f0 	movl   $0xf0108174,-0x44(%ebp)
		    user_mem_check(curenv, stabstr, stabstr_end - stabstr, 0))
			return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104d87:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104d8a:	39 4d b4             	cmp    %ecx,-0x4c(%ebp)
f0104d8d:	0f 83 62 02 00 00    	jae    f0104ff5 <debuginfo_eip+0x2cc>
f0104d93:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f0104d97:	0f 85 5f 02 00 00    	jne    f0104ffc <debuginfo_eip+0x2d3>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104d9d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104da4:	2b 75 bc             	sub    -0x44(%ebp),%esi
f0104da7:	c1 fe 02             	sar    $0x2,%esi
f0104daa:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f0104db0:	83 e8 01             	sub    $0x1,%eax
f0104db3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104db6:	83 ec 08             	sub    $0x8,%esp
f0104db9:	57                   	push   %edi
f0104dba:	6a 64                	push   $0x64
f0104dbc:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104dbf:	89 d1                	mov    %edx,%ecx
f0104dc1:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104dc4:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104dc7:	89 f0                	mov    %esi,%eax
f0104dc9:	e8 66 fe ff ff       	call   f0104c34 <stab_binsearch>
	if (lfile == 0)
f0104dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104dd1:	83 c4 10             	add    $0x10,%esp
f0104dd4:	85 c0                	test   %eax,%eax
f0104dd6:	0f 84 27 02 00 00    	je     f0105003 <debuginfo_eip+0x2da>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104ddc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0104ddf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104de2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104de5:	83 ec 08             	sub    $0x8,%esp
f0104de8:	57                   	push   %edi
f0104de9:	6a 24                	push   $0x24
f0104deb:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0104dee:	89 d1                	mov    %edx,%ecx
f0104df0:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104df3:	89 f0                	mov    %esi,%eax
f0104df5:	e8 3a fe ff ff       	call   f0104c34 <stab_binsearch>

	if (lfun <= rfun) {
f0104dfa:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104dfd:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104e00:	83 c4 10             	add    $0x10,%esp
f0104e03:	39 d0                	cmp    %edx,%eax
f0104e05:	0f 8f 32 01 00 00    	jg     f0104f3d <debuginfo_eip+0x214>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104e0b:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0104e0e:	8d 34 8e             	lea    (%esi,%ecx,4),%esi
f0104e11:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f0104e14:	8b 36                	mov    (%esi),%esi
f0104e16:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104e19:	2b 4d b4             	sub    -0x4c(%ebp),%ecx
f0104e1c:	39 ce                	cmp    %ecx,%esi
f0104e1e:	73 06                	jae    f0104e26 <debuginfo_eip+0xfd>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104e20:	03 75 b4             	add    -0x4c(%ebp),%esi
f0104e23:	89 73 08             	mov    %esi,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104e26:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0104e29:	8b 4e 08             	mov    0x8(%esi),%ecx
f0104e2c:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0104e2f:	29 cf                	sub    %ecx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0104e31:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0104e34:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104e37:	83 ec 08             	sub    $0x8,%esp
f0104e3a:	6a 3a                	push   $0x3a
f0104e3c:	ff 73 08             	pushl  0x8(%ebx)
f0104e3f:	e8 57 09 00 00       	call   f010579b <strfind>
f0104e44:	2b 43 08             	sub    0x8(%ebx),%eax
f0104e47:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0104e4a:	83 c4 08             	add    $0x8,%esp
f0104e4d:	57                   	push   %edi
f0104e4e:	6a 44                	push   $0x44
f0104e50:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104e53:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104e56:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104e59:	89 f8                	mov    %edi,%eax
f0104e5b:	e8 d4 fd ff ff       	call   f0104c34 <stab_binsearch>
	if (lline <= rline) {
f0104e60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104e63:	83 c4 10             	add    $0x10,%esp
f0104e66:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0104e69:	7f 0b                	jg     f0104e76 <debuginfo_eip+0x14d>
		info->eip_line = stabs[lline].n_desc;
f0104e6b:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104e6e:	0f b7 44 87 06       	movzwl 0x6(%edi,%eax,4),%eax
f0104e73:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile && stabs[lline].n_type != N_SOL &&
f0104e76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104e79:	89 d0                	mov    %edx,%eax
f0104e7b:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104e7e:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104e81:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0104e85:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0104e89:	e9 cd 00 00 00       	jmp    f0104f5b <debuginfo_eip+0x232>
		if (user_mem_check(curenv, usd, sizeof(struct UserStabData), 0))
f0104e8e:	e8 b9 0f 00 00       	call   f0105e4c <cpunum>
f0104e93:	6a 00                	push   $0x0
f0104e95:	6a 10                	push   $0x10
f0104e97:	68 00 00 20 00       	push   $0x200000
f0104e9c:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e9f:	ff b0 28 90 24 f0    	pushl  -0xfdb6fd8(%eax)
f0104ea5:	e8 fb de ff ff       	call   f0102da5 <user_mem_check>
f0104eaa:	83 c4 10             	add    $0x10,%esp
f0104ead:	85 c0                	test   %eax,%eax
f0104eaf:	0f 85 32 01 00 00    	jne    f0104fe7 <debuginfo_eip+0x2be>
		stabs = usd->stabs;
f0104eb5:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0104ebb:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0104ebe:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0104ec4:	a1 08 00 20 00       	mov    0x200008,%eax
f0104ec9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0104ecc:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0104ed2:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if (user_mem_check(curenv, stabs, stab_end - stabs, 0) ||
f0104ed5:	e8 72 0f 00 00       	call   f0105e4c <cpunum>
f0104eda:	89 c2                	mov    %eax,%edx
f0104edc:	6a 00                	push   $0x0
f0104ede:	89 f0                	mov    %esi,%eax
f0104ee0:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0104ee3:	29 c8                	sub    %ecx,%eax
f0104ee5:	c1 f8 02             	sar    $0x2,%eax
f0104ee8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0104eee:	50                   	push   %eax
f0104eef:	51                   	push   %ecx
f0104ef0:	6b d2 74             	imul   $0x74,%edx,%edx
f0104ef3:	ff b2 28 90 24 f0    	pushl  -0xfdb6fd8(%edx)
f0104ef9:	e8 a7 de ff ff       	call   f0102da5 <user_mem_check>
f0104efe:	83 c4 10             	add    $0x10,%esp
f0104f01:	85 c0                	test   %eax,%eax
f0104f03:	0f 85 e5 00 00 00    	jne    f0104fee <debuginfo_eip+0x2c5>
		    user_mem_check(curenv, stabstr, stabstr_end - stabstr, 0))
f0104f09:	e8 3e 0f 00 00       	call   f0105e4c <cpunum>
f0104f0e:	6a 00                	push   $0x0
f0104f10:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0104f13:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0104f16:	29 ca                	sub    %ecx,%edx
f0104f18:	52                   	push   %edx
f0104f19:	51                   	push   %ecx
f0104f1a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f1d:	ff b0 28 90 24 f0    	pushl  -0xfdb6fd8(%eax)
f0104f23:	e8 7d de ff ff       	call   f0102da5 <user_mem_check>
		if (user_mem_check(curenv, stabs, stab_end - stabs, 0) ||
f0104f28:	83 c4 10             	add    $0x10,%esp
f0104f2b:	85 c0                	test   %eax,%eax
f0104f2d:	0f 84 54 fe ff ff    	je     f0104d87 <debuginfo_eip+0x5e>
			return -1;
f0104f33:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104f38:	e9 d2 00 00 00       	jmp    f010500f <debuginfo_eip+0x2e6>
		info->eip_fn_addr = addr;
f0104f3d:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0104f40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104f43:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0104f46:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104f49:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104f4c:	e9 e6 fe ff ff       	jmp    f0104e37 <debuginfo_eip+0x10e>
f0104f51:	83 e8 01             	sub    $0x1,%eax
f0104f54:	83 ea 0c             	sub    $0xc,%edx
	while (lline >= lfile && stabs[lline].n_type != N_SOL &&
f0104f57:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0104f5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0104f5e:	39 c7                	cmp    %eax,%edi
f0104f60:	7f 45                	jg     f0104fa7 <debuginfo_eip+0x27e>
f0104f62:	0f b6 0a             	movzbl (%edx),%ecx
f0104f65:	80 f9 84             	cmp    $0x84,%cl
f0104f68:	74 19                	je     f0104f83 <debuginfo_eip+0x25a>
f0104f6a:	80 f9 64             	cmp    $0x64,%cl
f0104f6d:	75 e2                	jne    f0104f51 <debuginfo_eip+0x228>
	       (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104f6f:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0104f73:	74 dc                	je     f0104f51 <debuginfo_eip+0x228>
f0104f75:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104f79:	74 11                	je     f0104f8c <debuginfo_eip+0x263>
f0104f7b:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104f7e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0104f81:	eb 09                	jmp    f0104f8c <debuginfo_eip+0x263>
f0104f83:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104f87:	74 03                	je     f0104f8c <debuginfo_eip+0x263>
f0104f89:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104f8c:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104f8f:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104f92:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0104f95:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0104f98:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0104f9b:	29 f8                	sub    %edi,%eax
f0104f9d:	39 c2                	cmp    %eax,%edx
f0104f9f:	73 06                	jae    f0104fa7 <debuginfo_eip+0x27e>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104fa1:	89 f8                	mov    %edi,%eax
f0104fa3:	01 d0                	add    %edx,%eax
f0104fa5:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0104fa7:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104faa:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104fad:	ba 00 00 00 00       	mov    $0x0,%edx
	if (lfun < rfun)
f0104fb2:	39 f0                	cmp    %esi,%eax
f0104fb4:	7d 59                	jge    f010500f <debuginfo_eip+0x2e6>
		for (lline = lfun + 1;
f0104fb6:	8d 50 01             	lea    0x1(%eax),%edx
f0104fb9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0104fbc:	89 d0                	mov    %edx,%eax
f0104fbe:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104fc1:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104fc4:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0104fc8:	eb 04                	jmp    f0104fce <debuginfo_eip+0x2a5>
			info->eip_fn_narg++;
f0104fca:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0104fce:	39 c6                	cmp    %eax,%esi
f0104fd0:	7e 38                	jle    f010500a <debuginfo_eip+0x2e1>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0104fd2:	0f b6 0a             	movzbl (%edx),%ecx
f0104fd5:	83 c0 01             	add    $0x1,%eax
f0104fd8:	83 c2 0c             	add    $0xc,%edx
f0104fdb:	80 f9 a0             	cmp    $0xa0,%cl
f0104fde:	74 ea                	je     f0104fca <debuginfo_eip+0x2a1>
	return 0;
f0104fe0:	ba 00 00 00 00       	mov    $0x0,%edx
f0104fe5:	eb 28                	jmp    f010500f <debuginfo_eip+0x2e6>
			return -1;
f0104fe7:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104fec:	eb 21                	jmp    f010500f <debuginfo_eip+0x2e6>
			return -1;
f0104fee:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104ff3:	eb 1a                	jmp    f010500f <debuginfo_eip+0x2e6>
		return -1;
f0104ff5:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104ffa:	eb 13                	jmp    f010500f <debuginfo_eip+0x2e6>
f0104ffc:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105001:	eb 0c                	jmp    f010500f <debuginfo_eip+0x2e6>
		return -1;
f0105003:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105008:	eb 05                	jmp    f010500f <debuginfo_eip+0x2e6>
	return 0;
f010500a:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010500f:	89 d0                	mov    %edx,%eax
f0105011:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105014:	5b                   	pop    %ebx
f0105015:	5e                   	pop    %esi
f0105016:	5f                   	pop    %edi
f0105017:	5d                   	pop    %ebp
f0105018:	c3                   	ret    

f0105019 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105019:	55                   	push   %ebp
f010501a:	89 e5                	mov    %esp,%ebp
f010501c:	57                   	push   %edi
f010501d:	56                   	push   %esi
f010501e:	53                   	push   %ebx
f010501f:	83 ec 1c             	sub    $0x1c,%esp
f0105022:	89 c7                	mov    %eax,%edi
f0105024:	89 d6                	mov    %edx,%esi
f0105026:	8b 45 08             	mov    0x8(%ebp),%eax
f0105029:	8b 55 0c             	mov    0xc(%ebp),%edx
f010502c:	89 d1                	mov    %edx,%ecx
f010502e:	89 c2                	mov    %eax,%edx
f0105030:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105033:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105036:	8b 45 10             	mov    0x10(%ebp),%eax
f0105039:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f010503c:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010503f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0105046:	39 c2                	cmp    %eax,%edx
f0105048:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f010504b:	72 3e                	jb     f010508b <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010504d:	83 ec 0c             	sub    $0xc,%esp
f0105050:	ff 75 18             	pushl  0x18(%ebp)
f0105053:	83 eb 01             	sub    $0x1,%ebx
f0105056:	53                   	push   %ebx
f0105057:	50                   	push   %eax
f0105058:	83 ec 08             	sub    $0x8,%esp
f010505b:	ff 75 e4             	pushl  -0x1c(%ebp)
f010505e:	ff 75 e0             	pushl  -0x20(%ebp)
f0105061:	ff 75 dc             	pushl  -0x24(%ebp)
f0105064:	ff 75 d8             	pushl  -0x28(%ebp)
f0105067:	e8 34 12 00 00       	call   f01062a0 <__udivdi3>
f010506c:	83 c4 18             	add    $0x18,%esp
f010506f:	52                   	push   %edx
f0105070:	50                   	push   %eax
f0105071:	89 f2                	mov    %esi,%edx
f0105073:	89 f8                	mov    %edi,%eax
f0105075:	e8 9f ff ff ff       	call   f0105019 <printnum>
f010507a:	83 c4 20             	add    $0x20,%esp
f010507d:	eb 13                	jmp    f0105092 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f010507f:	83 ec 08             	sub    $0x8,%esp
f0105082:	56                   	push   %esi
f0105083:	ff 75 18             	pushl  0x18(%ebp)
f0105086:	ff d7                	call   *%edi
f0105088:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f010508b:	83 eb 01             	sub    $0x1,%ebx
f010508e:	85 db                	test   %ebx,%ebx
f0105090:	7f ed                	jg     f010507f <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0105092:	83 ec 08             	sub    $0x8,%esp
f0105095:	56                   	push   %esi
f0105096:	83 ec 04             	sub    $0x4,%esp
f0105099:	ff 75 e4             	pushl  -0x1c(%ebp)
f010509c:	ff 75 e0             	pushl  -0x20(%ebp)
f010509f:	ff 75 dc             	pushl  -0x24(%ebp)
f01050a2:	ff 75 d8             	pushl  -0x28(%ebp)
f01050a5:	e8 06 13 00 00       	call   f01063b0 <__umoddi3>
f01050aa:	83 c4 14             	add    $0x14,%esp
f01050ad:	0f be 80 9e 7c 10 f0 	movsbl -0xfef8362(%eax),%eax
f01050b4:	50                   	push   %eax
f01050b5:	ff d7                	call   *%edi
}
f01050b7:	83 c4 10             	add    $0x10,%esp
f01050ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01050bd:	5b                   	pop    %ebx
f01050be:	5e                   	pop    %esi
f01050bf:	5f                   	pop    %edi
f01050c0:	5d                   	pop    %ebp
f01050c1:	c3                   	ret    

f01050c2 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f01050c2:	83 fa 01             	cmp    $0x1,%edx
f01050c5:	7f 13                	jg     f01050da <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
f01050c7:	85 d2                	test   %edx,%edx
f01050c9:	74 1c                	je     f01050e7 <getuint+0x25>
		return va_arg(*ap, unsigned long);
f01050cb:	8b 10                	mov    (%eax),%edx
f01050cd:	8d 4a 04             	lea    0x4(%edx),%ecx
f01050d0:	89 08                	mov    %ecx,(%eax)
f01050d2:	8b 02                	mov    (%edx),%eax
f01050d4:	ba 00 00 00 00       	mov    $0x0,%edx
f01050d9:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
f01050da:	8b 10                	mov    (%eax),%edx
f01050dc:	8d 4a 08             	lea    0x8(%edx),%ecx
f01050df:	89 08                	mov    %ecx,(%eax)
f01050e1:	8b 02                	mov    (%edx),%eax
f01050e3:	8b 52 04             	mov    0x4(%edx),%edx
f01050e6:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
f01050e7:	8b 10                	mov    (%eax),%edx
f01050e9:	8d 4a 04             	lea    0x4(%edx),%ecx
f01050ec:	89 08                	mov    %ecx,(%eax)
f01050ee:	8b 02                	mov    (%edx),%eax
f01050f0:	ba 00 00 00 00       	mov    $0x0,%edx
}
f01050f5:	c3                   	ret    

f01050f6 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f01050f6:	83 fa 01             	cmp    $0x1,%edx
f01050f9:	7f 0f                	jg     f010510a <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
f01050fb:	85 d2                	test   %edx,%edx
f01050fd:	74 18                	je     f0105117 <getint+0x21>
		return va_arg(*ap, long);
f01050ff:	8b 10                	mov    (%eax),%edx
f0105101:	8d 4a 04             	lea    0x4(%edx),%ecx
f0105104:	89 08                	mov    %ecx,(%eax)
f0105106:	8b 02                	mov    (%edx),%eax
f0105108:	99                   	cltd   
f0105109:	c3                   	ret    
		return va_arg(*ap, long long);
f010510a:	8b 10                	mov    (%eax),%edx
f010510c:	8d 4a 08             	lea    0x8(%edx),%ecx
f010510f:	89 08                	mov    %ecx,(%eax)
f0105111:	8b 02                	mov    (%edx),%eax
f0105113:	8b 52 04             	mov    0x4(%edx),%edx
f0105116:	c3                   	ret    
	else
		return va_arg(*ap, int);
f0105117:	8b 10                	mov    (%eax),%edx
f0105119:	8d 4a 04             	lea    0x4(%edx),%ecx
f010511c:	89 08                	mov    %ecx,(%eax)
f010511e:	8b 02                	mov    (%edx),%eax
f0105120:	99                   	cltd   
}
f0105121:	c3                   	ret    

f0105122 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105122:	f3 0f 1e fb          	endbr32 
f0105126:	55                   	push   %ebp
f0105127:	89 e5                	mov    %esp,%ebp
f0105129:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f010512c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105130:	8b 10                	mov    (%eax),%edx
f0105132:	3b 50 04             	cmp    0x4(%eax),%edx
f0105135:	73 0a                	jae    f0105141 <sprintputch+0x1f>
		*b->buf++ = ch;
f0105137:	8d 4a 01             	lea    0x1(%edx),%ecx
f010513a:	89 08                	mov    %ecx,(%eax)
f010513c:	8b 45 08             	mov    0x8(%ebp),%eax
f010513f:	88 02                	mov    %al,(%edx)
}
f0105141:	5d                   	pop    %ebp
f0105142:	c3                   	ret    

f0105143 <printfmt>:
{
f0105143:	f3 0f 1e fb          	endbr32 
f0105147:	55                   	push   %ebp
f0105148:	89 e5                	mov    %esp,%ebp
f010514a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f010514d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105150:	50                   	push   %eax
f0105151:	ff 75 10             	pushl  0x10(%ebp)
f0105154:	ff 75 0c             	pushl  0xc(%ebp)
f0105157:	ff 75 08             	pushl  0x8(%ebp)
f010515a:	e8 05 00 00 00       	call   f0105164 <vprintfmt>
}
f010515f:	83 c4 10             	add    $0x10,%esp
f0105162:	c9                   	leave  
f0105163:	c3                   	ret    

f0105164 <vprintfmt>:
{
f0105164:	f3 0f 1e fb          	endbr32 
f0105168:	55                   	push   %ebp
f0105169:	89 e5                	mov    %esp,%ebp
f010516b:	57                   	push   %edi
f010516c:	56                   	push   %esi
f010516d:	53                   	push   %ebx
f010516e:	83 ec 2c             	sub    $0x2c,%esp
f0105171:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0105174:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105177:	8b 7d 10             	mov    0x10(%ebp),%edi
f010517a:	e9 86 02 00 00       	jmp    f0105405 <vprintfmt+0x2a1>
		padc = ' ';
f010517f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
f0105183:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
f010518a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105191:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105198:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f010519d:	8d 47 01             	lea    0x1(%edi),%eax
f01051a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01051a3:	0f b6 17             	movzbl (%edi),%edx
f01051a6:	8d 42 dd             	lea    -0x23(%edx),%eax
f01051a9:	3c 55                	cmp    $0x55,%al
f01051ab:	0f 87 df 02 00 00    	ja     f0105490 <vprintfmt+0x32c>
f01051b1:	0f b6 c0             	movzbl %al,%eax
f01051b4:	3e ff 24 85 60 7d 10 	notrack jmp *-0xfef82a0(,%eax,4)
f01051bb:	f0 
f01051bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f01051bf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f01051c3:	eb d8                	jmp    f010519d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f01051c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01051c8:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f01051cc:	eb cf                	jmp    f010519d <vprintfmt+0x39>
f01051ce:	0f b6 d2             	movzbl %dl,%edx
f01051d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01051d4:	b8 00 00 00 00       	mov    $0x0,%eax
f01051d9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f01051dc:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01051df:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01051e3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01051e6:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01051e9:	83 f9 09             	cmp    $0x9,%ecx
f01051ec:	77 52                	ja     f0105240 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
f01051ee:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f01051f1:	eb e9                	jmp    f01051dc <vprintfmt+0x78>
			precision = va_arg(ap, int);
f01051f3:	8b 45 14             	mov    0x14(%ebp),%eax
f01051f6:	8d 50 04             	lea    0x4(%eax),%edx
f01051f9:	89 55 14             	mov    %edx,0x14(%ebp)
f01051fc:	8b 00                	mov    (%eax),%eax
f01051fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105201:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105204:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105208:	79 93                	jns    f010519d <vprintfmt+0x39>
				width = precision, precision = -1;
f010520a:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010520d:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105210:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105217:	eb 84                	jmp    f010519d <vprintfmt+0x39>
f0105219:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010521c:	85 c0                	test   %eax,%eax
f010521e:	ba 00 00 00 00       	mov    $0x0,%edx
f0105223:	0f 49 d0             	cmovns %eax,%edx
f0105226:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105229:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f010522c:	e9 6c ff ff ff       	jmp    f010519d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f0105231:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105234:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
f010523b:	e9 5d ff ff ff       	jmp    f010519d <vprintfmt+0x39>
f0105240:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105243:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105246:	eb bc                	jmp    f0105204 <vprintfmt+0xa0>
			lflag++;
f0105248:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f010524b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f010524e:	e9 4a ff ff ff       	jmp    f010519d <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
f0105253:	8b 45 14             	mov    0x14(%ebp),%eax
f0105256:	8d 50 04             	lea    0x4(%eax),%edx
f0105259:	89 55 14             	mov    %edx,0x14(%ebp)
f010525c:	83 ec 08             	sub    $0x8,%esp
f010525f:	56                   	push   %esi
f0105260:	ff 30                	pushl  (%eax)
f0105262:	ff d3                	call   *%ebx
			break;
f0105264:	83 c4 10             	add    $0x10,%esp
f0105267:	e9 96 01 00 00       	jmp    f0105402 <vprintfmt+0x29e>
			err = va_arg(ap, int);
f010526c:	8b 45 14             	mov    0x14(%ebp),%eax
f010526f:	8d 50 04             	lea    0x4(%eax),%edx
f0105272:	89 55 14             	mov    %edx,0x14(%ebp)
f0105275:	8b 00                	mov    (%eax),%eax
f0105277:	99                   	cltd   
f0105278:	31 d0                	xor    %edx,%eax
f010527a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010527c:	83 f8 08             	cmp    $0x8,%eax
f010527f:	7f 20                	jg     f01052a1 <vprintfmt+0x13d>
f0105281:	8b 14 85 c0 7e 10 f0 	mov    -0xfef8140(,%eax,4),%edx
f0105288:	85 d2                	test   %edx,%edx
f010528a:	74 15                	je     f01052a1 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
f010528c:	52                   	push   %edx
f010528d:	68 3d 74 10 f0       	push   $0xf010743d
f0105292:	56                   	push   %esi
f0105293:	53                   	push   %ebx
f0105294:	e8 aa fe ff ff       	call   f0105143 <printfmt>
f0105299:	83 c4 10             	add    $0x10,%esp
f010529c:	e9 61 01 00 00       	jmp    f0105402 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
f01052a1:	50                   	push   %eax
f01052a2:	68 b6 7c 10 f0       	push   $0xf0107cb6
f01052a7:	56                   	push   %esi
f01052a8:	53                   	push   %ebx
f01052a9:	e8 95 fe ff ff       	call   f0105143 <printfmt>
f01052ae:	83 c4 10             	add    $0x10,%esp
f01052b1:	e9 4c 01 00 00       	jmp    f0105402 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
f01052b6:	8b 45 14             	mov    0x14(%ebp),%eax
f01052b9:	8d 50 04             	lea    0x4(%eax),%edx
f01052bc:	89 55 14             	mov    %edx,0x14(%ebp)
f01052bf:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f01052c1:	85 c9                	test   %ecx,%ecx
f01052c3:	b8 af 7c 10 f0       	mov    $0xf0107caf,%eax
f01052c8:	0f 45 c1             	cmovne %ecx,%eax
f01052cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f01052ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01052d2:	7e 06                	jle    f01052da <vprintfmt+0x176>
f01052d4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f01052d8:	75 0d                	jne    f01052e7 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
f01052da:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01052dd:	89 c7                	mov    %eax,%edi
f01052df:	03 45 e0             	add    -0x20(%ebp),%eax
f01052e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01052e5:	eb 57                	jmp    f010533e <vprintfmt+0x1da>
f01052e7:	83 ec 08             	sub    $0x8,%esp
f01052ea:	ff 75 d8             	pushl  -0x28(%ebp)
f01052ed:	ff 75 cc             	pushl  -0x34(%ebp)
f01052f0:	e8 35 03 00 00       	call   f010562a <strnlen>
f01052f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01052f8:	29 c2                	sub    %eax,%edx
f01052fa:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01052fd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f0105300:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
f0105304:	89 5d 08             	mov    %ebx,0x8(%ebp)
f0105307:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
f0105309:	85 db                	test   %ebx,%ebx
f010530b:	7e 10                	jle    f010531d <vprintfmt+0x1b9>
					putch(padc, putdat);
f010530d:	83 ec 08             	sub    $0x8,%esp
f0105310:	56                   	push   %esi
f0105311:	57                   	push   %edi
f0105312:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105315:	83 eb 01             	sub    $0x1,%ebx
f0105318:	83 c4 10             	add    $0x10,%esp
f010531b:	eb ec                	jmp    f0105309 <vprintfmt+0x1a5>
f010531d:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0105320:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105323:	85 d2                	test   %edx,%edx
f0105325:	b8 00 00 00 00       	mov    $0x0,%eax
f010532a:	0f 49 c2             	cmovns %edx,%eax
f010532d:	29 c2                	sub    %eax,%edx
f010532f:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0105332:	eb a6                	jmp    f01052da <vprintfmt+0x176>
					putch(ch, putdat);
f0105334:	83 ec 08             	sub    $0x8,%esp
f0105337:	56                   	push   %esi
f0105338:	52                   	push   %edx
f0105339:	ff d3                	call   *%ebx
f010533b:	83 c4 10             	add    $0x10,%esp
f010533e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105341:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105343:	83 c7 01             	add    $0x1,%edi
f0105346:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f010534a:	0f be d0             	movsbl %al,%edx
f010534d:	85 d2                	test   %edx,%edx
f010534f:	74 42                	je     f0105393 <vprintfmt+0x22f>
f0105351:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105355:	78 06                	js     f010535d <vprintfmt+0x1f9>
f0105357:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f010535b:	78 1e                	js     f010537b <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
f010535d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0105361:	74 d1                	je     f0105334 <vprintfmt+0x1d0>
f0105363:	0f be c0             	movsbl %al,%eax
f0105366:	83 e8 20             	sub    $0x20,%eax
f0105369:	83 f8 5e             	cmp    $0x5e,%eax
f010536c:	76 c6                	jbe    f0105334 <vprintfmt+0x1d0>
					putch('?', putdat);
f010536e:	83 ec 08             	sub    $0x8,%esp
f0105371:	56                   	push   %esi
f0105372:	6a 3f                	push   $0x3f
f0105374:	ff d3                	call   *%ebx
f0105376:	83 c4 10             	add    $0x10,%esp
f0105379:	eb c3                	jmp    f010533e <vprintfmt+0x1da>
f010537b:	89 cf                	mov    %ecx,%edi
f010537d:	eb 0e                	jmp    f010538d <vprintfmt+0x229>
				putch(' ', putdat);
f010537f:	83 ec 08             	sub    $0x8,%esp
f0105382:	56                   	push   %esi
f0105383:	6a 20                	push   $0x20
f0105385:	ff d3                	call   *%ebx
			for (; width > 0; width--)
f0105387:	83 ef 01             	sub    $0x1,%edi
f010538a:	83 c4 10             	add    $0x10,%esp
f010538d:	85 ff                	test   %edi,%edi
f010538f:	7f ee                	jg     f010537f <vprintfmt+0x21b>
f0105391:	eb 6f                	jmp    f0105402 <vprintfmt+0x29e>
f0105393:	89 cf                	mov    %ecx,%edi
f0105395:	eb f6                	jmp    f010538d <vprintfmt+0x229>
			num = getint(&ap, lflag);
f0105397:	89 ca                	mov    %ecx,%edx
f0105399:	8d 45 14             	lea    0x14(%ebp),%eax
f010539c:	e8 55 fd ff ff       	call   f01050f6 <getint>
f01053a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01053a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f01053a7:	85 d2                	test   %edx,%edx
f01053a9:	78 0b                	js     f01053b6 <vprintfmt+0x252>
			num = getint(&ap, lflag);
f01053ab:	89 d1                	mov    %edx,%ecx
f01053ad:	89 c2                	mov    %eax,%edx
			base = 10;
f01053af:	b8 0a 00 00 00       	mov    $0xa,%eax
f01053b4:	eb 32                	jmp    f01053e8 <vprintfmt+0x284>
				putch('-', putdat);
f01053b6:	83 ec 08             	sub    $0x8,%esp
f01053b9:	56                   	push   %esi
f01053ba:	6a 2d                	push   $0x2d
f01053bc:	ff d3                	call   *%ebx
				num = -(long long) num;
f01053be:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01053c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01053c4:	f7 da                	neg    %edx
f01053c6:	83 d1 00             	adc    $0x0,%ecx
f01053c9:	f7 d9                	neg    %ecx
f01053cb:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01053ce:	b8 0a 00 00 00       	mov    $0xa,%eax
f01053d3:	eb 13                	jmp    f01053e8 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
f01053d5:	89 ca                	mov    %ecx,%edx
f01053d7:	8d 45 14             	lea    0x14(%ebp),%eax
f01053da:	e8 e3 fc ff ff       	call   f01050c2 <getuint>
f01053df:	89 d1                	mov    %edx,%ecx
f01053e1:	89 c2                	mov    %eax,%edx
			base = 10;
f01053e3:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
f01053e8:	83 ec 0c             	sub    $0xc,%esp
f01053eb:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
f01053ef:	57                   	push   %edi
f01053f0:	ff 75 e0             	pushl  -0x20(%ebp)
f01053f3:	50                   	push   %eax
f01053f4:	51                   	push   %ecx
f01053f5:	52                   	push   %edx
f01053f6:	89 f2                	mov    %esi,%edx
f01053f8:	89 d8                	mov    %ebx,%eax
f01053fa:	e8 1a fc ff ff       	call   f0105019 <printnum>
			break;
f01053ff:	83 c4 20             	add    $0x20,%esp
{
f0105402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105405:	83 c7 01             	add    $0x1,%edi
f0105408:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f010540c:	83 f8 25             	cmp    $0x25,%eax
f010540f:	0f 84 6a fd ff ff    	je     f010517f <vprintfmt+0x1b>
			if (ch == '\0')
f0105415:	85 c0                	test   %eax,%eax
f0105417:	0f 84 93 00 00 00    	je     f01054b0 <vprintfmt+0x34c>
			putch(ch, putdat);
f010541d:	83 ec 08             	sub    $0x8,%esp
f0105420:	56                   	push   %esi
f0105421:	50                   	push   %eax
f0105422:	ff d3                	call   *%ebx
f0105424:	83 c4 10             	add    $0x10,%esp
f0105427:	eb dc                	jmp    f0105405 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
f0105429:	89 ca                	mov    %ecx,%edx
f010542b:	8d 45 14             	lea    0x14(%ebp),%eax
f010542e:	e8 8f fc ff ff       	call   f01050c2 <getuint>
f0105433:	89 d1                	mov    %edx,%ecx
f0105435:	89 c2                	mov    %eax,%edx
			base = 8;
f0105437:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
f010543c:	eb aa                	jmp    f01053e8 <vprintfmt+0x284>
			putch('0', putdat);
f010543e:	83 ec 08             	sub    $0x8,%esp
f0105441:	56                   	push   %esi
f0105442:	6a 30                	push   $0x30
f0105444:	ff d3                	call   *%ebx
			putch('x', putdat);
f0105446:	83 c4 08             	add    $0x8,%esp
f0105449:	56                   	push   %esi
f010544a:	6a 78                	push   $0x78
f010544c:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
f010544e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105451:	8d 50 04             	lea    0x4(%eax),%edx
f0105454:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
f0105457:	8b 10                	mov    (%eax),%edx
f0105459:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f010545e:	83 c4 10             	add    $0x10,%esp
			base = 16;
f0105461:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
f0105466:	eb 80                	jmp    f01053e8 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
f0105468:	89 ca                	mov    %ecx,%edx
f010546a:	8d 45 14             	lea    0x14(%ebp),%eax
f010546d:	e8 50 fc ff ff       	call   f01050c2 <getuint>
f0105472:	89 d1                	mov    %edx,%ecx
f0105474:	89 c2                	mov    %eax,%edx
			base = 16;
f0105476:	b8 10 00 00 00       	mov    $0x10,%eax
f010547b:	e9 68 ff ff ff       	jmp    f01053e8 <vprintfmt+0x284>
			putch(ch, putdat);
f0105480:	83 ec 08             	sub    $0x8,%esp
f0105483:	56                   	push   %esi
f0105484:	6a 25                	push   $0x25
f0105486:	ff d3                	call   *%ebx
			break;
f0105488:	83 c4 10             	add    $0x10,%esp
f010548b:	e9 72 ff ff ff       	jmp    f0105402 <vprintfmt+0x29e>
			putch('%', putdat);
f0105490:	83 ec 08             	sub    $0x8,%esp
f0105493:	56                   	push   %esi
f0105494:	6a 25                	push   $0x25
f0105496:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105498:	83 c4 10             	add    $0x10,%esp
f010549b:	89 f8                	mov    %edi,%eax
f010549d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01054a1:	74 05                	je     f01054a8 <vprintfmt+0x344>
f01054a3:	83 e8 01             	sub    $0x1,%eax
f01054a6:	eb f5                	jmp    f010549d <vprintfmt+0x339>
f01054a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01054ab:	e9 52 ff ff ff       	jmp    f0105402 <vprintfmt+0x29e>
}
f01054b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01054b3:	5b                   	pop    %ebx
f01054b4:	5e                   	pop    %esi
f01054b5:	5f                   	pop    %edi
f01054b6:	5d                   	pop    %ebp
f01054b7:	c3                   	ret    

f01054b8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01054b8:	f3 0f 1e fb          	endbr32 
f01054bc:	55                   	push   %ebp
f01054bd:	89 e5                	mov    %esp,%ebp
f01054bf:	83 ec 18             	sub    $0x18,%esp
f01054c2:	8b 45 08             	mov    0x8(%ebp),%eax
f01054c5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01054c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01054cb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01054cf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01054d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01054d9:	85 c0                	test   %eax,%eax
f01054db:	74 26                	je     f0105503 <vsnprintf+0x4b>
f01054dd:	85 d2                	test   %edx,%edx
f01054df:	7e 22                	jle    f0105503 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01054e1:	ff 75 14             	pushl  0x14(%ebp)
f01054e4:	ff 75 10             	pushl  0x10(%ebp)
f01054e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01054ea:	50                   	push   %eax
f01054eb:	68 22 51 10 f0       	push   $0xf0105122
f01054f0:	e8 6f fc ff ff       	call   f0105164 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01054f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01054f8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01054fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01054fe:	83 c4 10             	add    $0x10,%esp
}
f0105501:	c9                   	leave  
f0105502:	c3                   	ret    
		return -E_INVAL;
f0105503:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105508:	eb f7                	jmp    f0105501 <vsnprintf+0x49>

f010550a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010550a:	f3 0f 1e fb          	endbr32 
f010550e:	55                   	push   %ebp
f010550f:	89 e5                	mov    %esp,%ebp
f0105511:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105514:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105517:	50                   	push   %eax
f0105518:	ff 75 10             	pushl  0x10(%ebp)
f010551b:	ff 75 0c             	pushl  0xc(%ebp)
f010551e:	ff 75 08             	pushl  0x8(%ebp)
f0105521:	e8 92 ff ff ff       	call   f01054b8 <vsnprintf>
	va_end(ap);

	return rc;
}
f0105526:	c9                   	leave  
f0105527:	c3                   	ret    

f0105528 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0105528:	f3 0f 1e fb          	endbr32 
f010552c:	55                   	push   %ebp
f010552d:	89 e5                	mov    %esp,%ebp
f010552f:	57                   	push   %edi
f0105530:	56                   	push   %esi
f0105531:	53                   	push   %ebx
f0105532:	83 ec 0c             	sub    $0xc,%esp
f0105535:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f0105538:	85 c0                	test   %eax,%eax
f010553a:	74 11                	je     f010554d <readline+0x25>
		cprintf("%s", prompt);
f010553c:	83 ec 08             	sub    $0x8,%esp
f010553f:	50                   	push   %eax
f0105540:	68 3d 74 10 f0       	push   $0xf010743d
f0105545:	e8 1f e3 ff ff       	call   f0103869 <cprintf>
f010554a:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f010554d:	83 ec 0c             	sub    $0xc,%esp
f0105550:	6a 00                	push   $0x0
f0105552:	e8 00 b4 ff ff       	call   f0100957 <iscons>
f0105557:	89 c7                	mov    %eax,%edi
f0105559:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010555c:	be 00 00 00 00       	mov    $0x0,%esi
f0105561:	eb 4b                	jmp    f01055ae <readline+0x86>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f0105563:	83 ec 08             	sub    $0x8,%esp
f0105566:	50                   	push   %eax
f0105567:	68 e4 7e 10 f0       	push   $0xf0107ee4
f010556c:	e8 f8 e2 ff ff       	call   f0103869 <cprintf>
			return NULL;
f0105571:	83 c4 10             	add    $0x10,%esp
f0105574:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0105579:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010557c:	5b                   	pop    %ebx
f010557d:	5e                   	pop    %esi
f010557e:	5f                   	pop    %edi
f010557f:	5d                   	pop    %ebp
f0105580:	c3                   	ret    
			if (echoing)
f0105581:	85 ff                	test   %edi,%edi
f0105583:	75 05                	jne    f010558a <readline+0x62>
			i--;
f0105585:	83 ee 01             	sub    $0x1,%esi
f0105588:	eb 24                	jmp    f01055ae <readline+0x86>
				cputchar('\b');
f010558a:	83 ec 0c             	sub    $0xc,%esp
f010558d:	6a 08                	push   $0x8
f010558f:	e8 9a b3 ff ff       	call   f010092e <cputchar>
f0105594:	83 c4 10             	add    $0x10,%esp
f0105597:	eb ec                	jmp    f0105585 <readline+0x5d>
				cputchar(c);
f0105599:	83 ec 0c             	sub    $0xc,%esp
f010559c:	53                   	push   %ebx
f010559d:	e8 8c b3 ff ff       	call   f010092e <cputchar>
f01055a2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01055a5:	88 9e 80 8a 24 f0    	mov    %bl,-0xfdb7580(%esi)
f01055ab:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01055ae:	e8 8f b3 ff ff       	call   f0100942 <getchar>
f01055b3:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01055b5:	85 c0                	test   %eax,%eax
f01055b7:	78 aa                	js     f0105563 <readline+0x3b>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01055b9:	83 f8 08             	cmp    $0x8,%eax
f01055bc:	0f 94 c2             	sete   %dl
f01055bf:	83 f8 7f             	cmp    $0x7f,%eax
f01055c2:	0f 94 c0             	sete   %al
f01055c5:	08 c2                	or     %al,%dl
f01055c7:	74 04                	je     f01055cd <readline+0xa5>
f01055c9:	85 f6                	test   %esi,%esi
f01055cb:	7f b4                	jg     f0105581 <readline+0x59>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01055cd:	83 fb 1f             	cmp    $0x1f,%ebx
f01055d0:	7e 0e                	jle    f01055e0 <readline+0xb8>
f01055d2:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01055d8:	7f 06                	jg     f01055e0 <readline+0xb8>
			if (echoing)
f01055da:	85 ff                	test   %edi,%edi
f01055dc:	74 c7                	je     f01055a5 <readline+0x7d>
f01055de:	eb b9                	jmp    f0105599 <readline+0x71>
		} else if (c == '\n' || c == '\r') {
f01055e0:	83 fb 0a             	cmp    $0xa,%ebx
f01055e3:	74 05                	je     f01055ea <readline+0xc2>
f01055e5:	83 fb 0d             	cmp    $0xd,%ebx
f01055e8:	75 c4                	jne    f01055ae <readline+0x86>
			if (echoing)
f01055ea:	85 ff                	test   %edi,%edi
f01055ec:	75 11                	jne    f01055ff <readline+0xd7>
			buf[i] = 0;
f01055ee:	c6 86 80 8a 24 f0 00 	movb   $0x0,-0xfdb7580(%esi)
			return buf;
f01055f5:	b8 80 8a 24 f0       	mov    $0xf0248a80,%eax
f01055fa:	e9 7a ff ff ff       	jmp    f0105579 <readline+0x51>
				cputchar('\n');
f01055ff:	83 ec 0c             	sub    $0xc,%esp
f0105602:	6a 0a                	push   $0xa
f0105604:	e8 25 b3 ff ff       	call   f010092e <cputchar>
f0105609:	83 c4 10             	add    $0x10,%esp
f010560c:	eb e0                	jmp    f01055ee <readline+0xc6>

f010560e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f010560e:	f3 0f 1e fb          	endbr32 
f0105612:	55                   	push   %ebp
f0105613:	89 e5                	mov    %esp,%ebp
f0105615:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105618:	b8 00 00 00 00       	mov    $0x0,%eax
f010561d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105621:	74 05                	je     f0105628 <strlen+0x1a>
		n++;
f0105623:	83 c0 01             	add    $0x1,%eax
f0105626:	eb f5                	jmp    f010561d <strlen+0xf>
	return n;
}
f0105628:	5d                   	pop    %ebp
f0105629:	c3                   	ret    

f010562a <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010562a:	f3 0f 1e fb          	endbr32 
f010562e:	55                   	push   %ebp
f010562f:	89 e5                	mov    %esp,%ebp
f0105631:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105634:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105637:	b8 00 00 00 00       	mov    $0x0,%eax
f010563c:	39 d0                	cmp    %edx,%eax
f010563e:	74 0d                	je     f010564d <strnlen+0x23>
f0105640:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0105644:	74 05                	je     f010564b <strnlen+0x21>
		n++;
f0105646:	83 c0 01             	add    $0x1,%eax
f0105649:	eb f1                	jmp    f010563c <strnlen+0x12>
f010564b:	89 c2                	mov    %eax,%edx
	return n;
}
f010564d:	89 d0                	mov    %edx,%eax
f010564f:	5d                   	pop    %ebp
f0105650:	c3                   	ret    

f0105651 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105651:	f3 0f 1e fb          	endbr32 
f0105655:	55                   	push   %ebp
f0105656:	89 e5                	mov    %esp,%ebp
f0105658:	53                   	push   %ebx
f0105659:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010565c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010565f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105664:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f0105668:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f010566b:	83 c0 01             	add    $0x1,%eax
f010566e:	84 d2                	test   %dl,%dl
f0105670:	75 f2                	jne    f0105664 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
f0105672:	89 c8                	mov    %ecx,%eax
f0105674:	5b                   	pop    %ebx
f0105675:	5d                   	pop    %ebp
f0105676:	c3                   	ret    

f0105677 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105677:	f3 0f 1e fb          	endbr32 
f010567b:	55                   	push   %ebp
f010567c:	89 e5                	mov    %esp,%ebp
f010567e:	53                   	push   %ebx
f010567f:	83 ec 10             	sub    $0x10,%esp
f0105682:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105685:	53                   	push   %ebx
f0105686:	e8 83 ff ff ff       	call   f010560e <strlen>
f010568b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f010568e:	ff 75 0c             	pushl  0xc(%ebp)
f0105691:	01 d8                	add    %ebx,%eax
f0105693:	50                   	push   %eax
f0105694:	e8 b8 ff ff ff       	call   f0105651 <strcpy>
	return dst;
}
f0105699:	89 d8                	mov    %ebx,%eax
f010569b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010569e:	c9                   	leave  
f010569f:	c3                   	ret    

f01056a0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01056a0:	f3 0f 1e fb          	endbr32 
f01056a4:	55                   	push   %ebp
f01056a5:	89 e5                	mov    %esp,%ebp
f01056a7:	56                   	push   %esi
f01056a8:	53                   	push   %ebx
f01056a9:	8b 75 08             	mov    0x8(%ebp),%esi
f01056ac:	8b 55 0c             	mov    0xc(%ebp),%edx
f01056af:	89 f3                	mov    %esi,%ebx
f01056b1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01056b4:	89 f0                	mov    %esi,%eax
f01056b6:	39 d8                	cmp    %ebx,%eax
f01056b8:	74 11                	je     f01056cb <strncpy+0x2b>
		*dst++ = *src;
f01056ba:	83 c0 01             	add    $0x1,%eax
f01056bd:	0f b6 0a             	movzbl (%edx),%ecx
f01056c0:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01056c3:	80 f9 01             	cmp    $0x1,%cl
f01056c6:	83 da ff             	sbb    $0xffffffff,%edx
f01056c9:	eb eb                	jmp    f01056b6 <strncpy+0x16>
	}
	return ret;
}
f01056cb:	89 f0                	mov    %esi,%eax
f01056cd:	5b                   	pop    %ebx
f01056ce:	5e                   	pop    %esi
f01056cf:	5d                   	pop    %ebp
f01056d0:	c3                   	ret    

f01056d1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01056d1:	f3 0f 1e fb          	endbr32 
f01056d5:	55                   	push   %ebp
f01056d6:	89 e5                	mov    %esp,%ebp
f01056d8:	56                   	push   %esi
f01056d9:	53                   	push   %ebx
f01056da:	8b 75 08             	mov    0x8(%ebp),%esi
f01056dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01056e0:	8b 55 10             	mov    0x10(%ebp),%edx
f01056e3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01056e5:	85 d2                	test   %edx,%edx
f01056e7:	74 21                	je     f010570a <strlcpy+0x39>
f01056e9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01056ed:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01056ef:	39 c2                	cmp    %eax,%edx
f01056f1:	74 14                	je     f0105707 <strlcpy+0x36>
f01056f3:	0f b6 19             	movzbl (%ecx),%ebx
f01056f6:	84 db                	test   %bl,%bl
f01056f8:	74 0b                	je     f0105705 <strlcpy+0x34>
			*dst++ = *src++;
f01056fa:	83 c1 01             	add    $0x1,%ecx
f01056fd:	83 c2 01             	add    $0x1,%edx
f0105700:	88 5a ff             	mov    %bl,-0x1(%edx)
f0105703:	eb ea                	jmp    f01056ef <strlcpy+0x1e>
f0105705:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0105707:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f010570a:	29 f0                	sub    %esi,%eax
}
f010570c:	5b                   	pop    %ebx
f010570d:	5e                   	pop    %esi
f010570e:	5d                   	pop    %ebp
f010570f:	c3                   	ret    

f0105710 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105710:	f3 0f 1e fb          	endbr32 
f0105714:	55                   	push   %ebp
f0105715:	89 e5                	mov    %esp,%ebp
f0105717:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010571a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f010571d:	0f b6 01             	movzbl (%ecx),%eax
f0105720:	84 c0                	test   %al,%al
f0105722:	74 0c                	je     f0105730 <strcmp+0x20>
f0105724:	3a 02                	cmp    (%edx),%al
f0105726:	75 08                	jne    f0105730 <strcmp+0x20>
		p++, q++;
f0105728:	83 c1 01             	add    $0x1,%ecx
f010572b:	83 c2 01             	add    $0x1,%edx
f010572e:	eb ed                	jmp    f010571d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105730:	0f b6 c0             	movzbl %al,%eax
f0105733:	0f b6 12             	movzbl (%edx),%edx
f0105736:	29 d0                	sub    %edx,%eax
}
f0105738:	5d                   	pop    %ebp
f0105739:	c3                   	ret    

f010573a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010573a:	f3 0f 1e fb          	endbr32 
f010573e:	55                   	push   %ebp
f010573f:	89 e5                	mov    %esp,%ebp
f0105741:	53                   	push   %ebx
f0105742:	8b 45 08             	mov    0x8(%ebp),%eax
f0105745:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105748:	89 c3                	mov    %eax,%ebx
f010574a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010574d:	eb 06                	jmp    f0105755 <strncmp+0x1b>
		n--, p++, q++;
f010574f:	83 c0 01             	add    $0x1,%eax
f0105752:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105755:	39 d8                	cmp    %ebx,%eax
f0105757:	74 16                	je     f010576f <strncmp+0x35>
f0105759:	0f b6 08             	movzbl (%eax),%ecx
f010575c:	84 c9                	test   %cl,%cl
f010575e:	74 04                	je     f0105764 <strncmp+0x2a>
f0105760:	3a 0a                	cmp    (%edx),%cl
f0105762:	74 eb                	je     f010574f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105764:	0f b6 00             	movzbl (%eax),%eax
f0105767:	0f b6 12             	movzbl (%edx),%edx
f010576a:	29 d0                	sub    %edx,%eax
}
f010576c:	5b                   	pop    %ebx
f010576d:	5d                   	pop    %ebp
f010576e:	c3                   	ret    
		return 0;
f010576f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105774:	eb f6                	jmp    f010576c <strncmp+0x32>

f0105776 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105776:	f3 0f 1e fb          	endbr32 
f010577a:	55                   	push   %ebp
f010577b:	89 e5                	mov    %esp,%ebp
f010577d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105780:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105784:	0f b6 10             	movzbl (%eax),%edx
f0105787:	84 d2                	test   %dl,%dl
f0105789:	74 09                	je     f0105794 <strchr+0x1e>
		if (*s == c)
f010578b:	38 ca                	cmp    %cl,%dl
f010578d:	74 0a                	je     f0105799 <strchr+0x23>
	for (; *s; s++)
f010578f:	83 c0 01             	add    $0x1,%eax
f0105792:	eb f0                	jmp    f0105784 <strchr+0xe>
			return (char *) s;
	return 0;
f0105794:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105799:	5d                   	pop    %ebp
f010579a:	c3                   	ret    

f010579b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010579b:	f3 0f 1e fb          	endbr32 
f010579f:	55                   	push   %ebp
f01057a0:	89 e5                	mov    %esp,%ebp
f01057a2:	8b 45 08             	mov    0x8(%ebp),%eax
f01057a5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01057a9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01057ac:	38 ca                	cmp    %cl,%dl
f01057ae:	74 09                	je     f01057b9 <strfind+0x1e>
f01057b0:	84 d2                	test   %dl,%dl
f01057b2:	74 05                	je     f01057b9 <strfind+0x1e>
	for (; *s; s++)
f01057b4:	83 c0 01             	add    $0x1,%eax
f01057b7:	eb f0                	jmp    f01057a9 <strfind+0xe>
			break;
	return (char *) s;
}
f01057b9:	5d                   	pop    %ebp
f01057ba:	c3                   	ret    

f01057bb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01057bb:	f3 0f 1e fb          	endbr32 
f01057bf:	55                   	push   %ebp
f01057c0:	89 e5                	mov    %esp,%ebp
f01057c2:	57                   	push   %edi
f01057c3:	56                   	push   %esi
f01057c4:	53                   	push   %ebx
f01057c5:	8b 55 08             	mov    0x8(%ebp),%edx
f01057c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
f01057cb:	85 c9                	test   %ecx,%ecx
f01057cd:	74 33                	je     f0105802 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01057cf:	89 d0                	mov    %edx,%eax
f01057d1:	09 c8                	or     %ecx,%eax
f01057d3:	a8 03                	test   $0x3,%al
f01057d5:	75 23                	jne    f01057fa <memset+0x3f>
		c &= 0xFF;
f01057d7:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01057db:	89 d8                	mov    %ebx,%eax
f01057dd:	c1 e0 08             	shl    $0x8,%eax
f01057e0:	89 df                	mov    %ebx,%edi
f01057e2:	c1 e7 18             	shl    $0x18,%edi
f01057e5:	89 de                	mov    %ebx,%esi
f01057e7:	c1 e6 10             	shl    $0x10,%esi
f01057ea:	09 f7                	or     %esi,%edi
f01057ec:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
f01057ee:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01057f1:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
f01057f3:	89 d7                	mov    %edx,%edi
f01057f5:	fc                   	cld    
f01057f6:	f3 ab                	rep stos %eax,%es:(%edi)
f01057f8:	eb 08                	jmp    f0105802 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01057fa:	89 d7                	mov    %edx,%edi
f01057fc:	8b 45 0c             	mov    0xc(%ebp),%eax
f01057ff:	fc                   	cld    
f0105800:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
f0105802:	89 d0                	mov    %edx,%eax
f0105804:	5b                   	pop    %ebx
f0105805:	5e                   	pop    %esi
f0105806:	5f                   	pop    %edi
f0105807:	5d                   	pop    %ebp
f0105808:	c3                   	ret    

f0105809 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105809:	f3 0f 1e fb          	endbr32 
f010580d:	55                   	push   %ebp
f010580e:	89 e5                	mov    %esp,%ebp
f0105810:	57                   	push   %edi
f0105811:	56                   	push   %esi
f0105812:	8b 45 08             	mov    0x8(%ebp),%eax
f0105815:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105818:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010581b:	39 c6                	cmp    %eax,%esi
f010581d:	73 32                	jae    f0105851 <memmove+0x48>
f010581f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105822:	39 c2                	cmp    %eax,%edx
f0105824:	76 2b                	jbe    f0105851 <memmove+0x48>
		s += n;
		d += n;
f0105826:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105829:	89 fe                	mov    %edi,%esi
f010582b:	09 ce                	or     %ecx,%esi
f010582d:	09 d6                	or     %edx,%esi
f010582f:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105835:	75 0e                	jne    f0105845 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105837:	83 ef 04             	sub    $0x4,%edi
f010583a:	8d 72 fc             	lea    -0x4(%edx),%esi
f010583d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105840:	fd                   	std    
f0105841:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105843:	eb 09                	jmp    f010584e <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105845:	83 ef 01             	sub    $0x1,%edi
f0105848:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010584b:	fd                   	std    
f010584c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010584e:	fc                   	cld    
f010584f:	eb 1a                	jmp    f010586b <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105851:	89 c2                	mov    %eax,%edx
f0105853:	09 ca                	or     %ecx,%edx
f0105855:	09 f2                	or     %esi,%edx
f0105857:	f6 c2 03             	test   $0x3,%dl
f010585a:	75 0a                	jne    f0105866 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010585c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010585f:	89 c7                	mov    %eax,%edi
f0105861:	fc                   	cld    
f0105862:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105864:	eb 05                	jmp    f010586b <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
f0105866:	89 c7                	mov    %eax,%edi
f0105868:	fc                   	cld    
f0105869:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010586b:	5e                   	pop    %esi
f010586c:	5f                   	pop    %edi
f010586d:	5d                   	pop    %ebp
f010586e:	c3                   	ret    

f010586f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010586f:	f3 0f 1e fb          	endbr32 
f0105873:	55                   	push   %ebp
f0105874:	89 e5                	mov    %esp,%ebp
f0105876:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0105879:	ff 75 10             	pushl  0x10(%ebp)
f010587c:	ff 75 0c             	pushl  0xc(%ebp)
f010587f:	ff 75 08             	pushl  0x8(%ebp)
f0105882:	e8 82 ff ff ff       	call   f0105809 <memmove>
}
f0105887:	c9                   	leave  
f0105888:	c3                   	ret    

f0105889 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105889:	f3 0f 1e fb          	endbr32 
f010588d:	55                   	push   %ebp
f010588e:	89 e5                	mov    %esp,%ebp
f0105890:	56                   	push   %esi
f0105891:	53                   	push   %ebx
f0105892:	8b 45 08             	mov    0x8(%ebp),%eax
f0105895:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105898:	89 c6                	mov    %eax,%esi
f010589a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010589d:	39 f0                	cmp    %esi,%eax
f010589f:	74 1c                	je     f01058bd <memcmp+0x34>
		if (*s1 != *s2)
f01058a1:	0f b6 08             	movzbl (%eax),%ecx
f01058a4:	0f b6 1a             	movzbl (%edx),%ebx
f01058a7:	38 d9                	cmp    %bl,%cl
f01058a9:	75 08                	jne    f01058b3 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01058ab:	83 c0 01             	add    $0x1,%eax
f01058ae:	83 c2 01             	add    $0x1,%edx
f01058b1:	eb ea                	jmp    f010589d <memcmp+0x14>
			return (int) *s1 - (int) *s2;
f01058b3:	0f b6 c1             	movzbl %cl,%eax
f01058b6:	0f b6 db             	movzbl %bl,%ebx
f01058b9:	29 d8                	sub    %ebx,%eax
f01058bb:	eb 05                	jmp    f01058c2 <memcmp+0x39>
	}

	return 0;
f01058bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01058c2:	5b                   	pop    %ebx
f01058c3:	5e                   	pop    %esi
f01058c4:	5d                   	pop    %ebp
f01058c5:	c3                   	ret    

f01058c6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01058c6:	f3 0f 1e fb          	endbr32 
f01058ca:	55                   	push   %ebp
f01058cb:	89 e5                	mov    %esp,%ebp
f01058cd:	8b 45 08             	mov    0x8(%ebp),%eax
f01058d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01058d3:	89 c2                	mov    %eax,%edx
f01058d5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01058d8:	39 d0                	cmp    %edx,%eax
f01058da:	73 09                	jae    f01058e5 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
f01058dc:	38 08                	cmp    %cl,(%eax)
f01058de:	74 05                	je     f01058e5 <memfind+0x1f>
	for (; s < ends; s++)
f01058e0:	83 c0 01             	add    $0x1,%eax
f01058e3:	eb f3                	jmp    f01058d8 <memfind+0x12>
			break;
	return (void *) s;
}
f01058e5:	5d                   	pop    %ebp
f01058e6:	c3                   	ret    

f01058e7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01058e7:	f3 0f 1e fb          	endbr32 
f01058eb:	55                   	push   %ebp
f01058ec:	89 e5                	mov    %esp,%ebp
f01058ee:	57                   	push   %edi
f01058ef:	56                   	push   %esi
f01058f0:	53                   	push   %ebx
f01058f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01058f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01058f7:	eb 03                	jmp    f01058fc <strtol+0x15>
		s++;
f01058f9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01058fc:	0f b6 01             	movzbl (%ecx),%eax
f01058ff:	3c 20                	cmp    $0x20,%al
f0105901:	74 f6                	je     f01058f9 <strtol+0x12>
f0105903:	3c 09                	cmp    $0x9,%al
f0105905:	74 f2                	je     f01058f9 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
f0105907:	3c 2b                	cmp    $0x2b,%al
f0105909:	74 2a                	je     f0105935 <strtol+0x4e>
	int neg = 0;
f010590b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0105910:	3c 2d                	cmp    $0x2d,%al
f0105912:	74 2b                	je     f010593f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105914:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f010591a:	75 0f                	jne    f010592b <strtol+0x44>
f010591c:	80 39 30             	cmpb   $0x30,(%ecx)
f010591f:	74 28                	je     f0105949 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105921:	85 db                	test   %ebx,%ebx
f0105923:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105928:	0f 44 d8             	cmove  %eax,%ebx
f010592b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105930:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105933:	eb 46                	jmp    f010597b <strtol+0x94>
		s++;
f0105935:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105938:	bf 00 00 00 00       	mov    $0x0,%edi
f010593d:	eb d5                	jmp    f0105914 <strtol+0x2d>
		s++, neg = 1;
f010593f:	83 c1 01             	add    $0x1,%ecx
f0105942:	bf 01 00 00 00       	mov    $0x1,%edi
f0105947:	eb cb                	jmp    f0105914 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105949:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010594d:	74 0e                	je     f010595d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f010594f:	85 db                	test   %ebx,%ebx
f0105951:	75 d8                	jne    f010592b <strtol+0x44>
		s++, base = 8;
f0105953:	83 c1 01             	add    $0x1,%ecx
f0105956:	bb 08 00 00 00       	mov    $0x8,%ebx
f010595b:	eb ce                	jmp    f010592b <strtol+0x44>
		s += 2, base = 16;
f010595d:	83 c1 02             	add    $0x2,%ecx
f0105960:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105965:	eb c4                	jmp    f010592b <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0105967:	0f be d2             	movsbl %dl,%edx
f010596a:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f010596d:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105970:	7d 3a                	jge    f01059ac <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105972:	83 c1 01             	add    $0x1,%ecx
f0105975:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105979:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f010597b:	0f b6 11             	movzbl (%ecx),%edx
f010597e:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105981:	89 f3                	mov    %esi,%ebx
f0105983:	80 fb 09             	cmp    $0x9,%bl
f0105986:	76 df                	jbe    f0105967 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
f0105988:	8d 72 9f             	lea    -0x61(%edx),%esi
f010598b:	89 f3                	mov    %esi,%ebx
f010598d:	80 fb 19             	cmp    $0x19,%bl
f0105990:	77 08                	ja     f010599a <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105992:	0f be d2             	movsbl %dl,%edx
f0105995:	83 ea 57             	sub    $0x57,%edx
f0105998:	eb d3                	jmp    f010596d <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
f010599a:	8d 72 bf             	lea    -0x41(%edx),%esi
f010599d:	89 f3                	mov    %esi,%ebx
f010599f:	80 fb 19             	cmp    $0x19,%bl
f01059a2:	77 08                	ja     f01059ac <strtol+0xc5>
			dig = *s - 'A' + 10;
f01059a4:	0f be d2             	movsbl %dl,%edx
f01059a7:	83 ea 37             	sub    $0x37,%edx
f01059aa:	eb c1                	jmp    f010596d <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
f01059ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01059b0:	74 05                	je     f01059b7 <strtol+0xd0>
		*endptr = (char *) s;
f01059b2:	8b 75 0c             	mov    0xc(%ebp),%esi
f01059b5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f01059b7:	89 c2                	mov    %eax,%edx
f01059b9:	f7 da                	neg    %edx
f01059bb:	85 ff                	test   %edi,%edi
f01059bd:	0f 45 c2             	cmovne %edx,%eax
}
f01059c0:	5b                   	pop    %ebx
f01059c1:	5e                   	pop    %esi
f01059c2:	5f                   	pop    %edi
f01059c3:	5d                   	pop    %ebp
f01059c4:	c3                   	ret    
f01059c5:	66 90                	xchg   %ax,%ax
f01059c7:	90                   	nop

f01059c8 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01059c8:	fa                   	cli    

	xorw    %ax, %ax
f01059c9:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01059cb:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01059cd:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01059cf:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01059d1:	0f 01 16             	lgdtl  (%esi)
f01059d4:	7c 70                	jl     f0105a46 <gdtdesc+0x2>
	movl    %cr0, %eax
f01059d6:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01059d9:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01059dd:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01059e0:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01059e6:	08 00                	or     %al,(%eax)

f01059e8 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01059e8:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01059ec:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01059ee:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01059f0:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01059f2:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01059f6:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01059f8:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01059fa:	b8 00 10 12 00       	mov    $0x121000,%eax
	movl    %eax, %cr3
f01059ff:	0f 22 d8             	mov    %eax,%cr3

	# Enable large pages
	movl %cr4, %eax
f0105a02:	0f 20 e0             	mov    %cr4,%eax
	orl $(CR4_PSE), %eax
f0105a05:	83 c8 10             	or     $0x10,%eax
	movl %eax, %cr4
f0105a08:	0f 22 e0             	mov    %eax,%cr4

	# Turn on paging.
	movl    %cr0, %eax
f0105a0b:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105a0e:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105a13:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0105a16:	8b 25 84 8e 24 f0    	mov    0xf0248e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105a1c:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105a21:	b8 65 02 10 f0       	mov    $0xf0100265,%eax
	call    *%eax
f0105a26:	ff d0                	call   *%eax

f0105a28 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105a28:	eb fe                	jmp    f0105a28 <spin>
f0105a2a:	66 90                	xchg   %ax,%ax

f0105a2c <gdt>:
	...
f0105a34:	ff                   	(bad)  
f0105a35:	ff 00                	incl   (%eax)
f0105a37:	00 00                	add    %al,(%eax)
f0105a39:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105a40:	00                   	.byte 0x0
f0105a41:	92                   	xchg   %eax,%edx
f0105a42:	cf                   	iret   
	...

f0105a44 <gdtdesc>:
f0105a44:	17                   	pop    %ss
f0105a45:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f0105a4a <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105a4a:	90                   	nop

f0105a4b <inb>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105a4b:	89 c2                	mov    %eax,%edx
f0105a4d:	ec                   	in     (%dx),%al
}
f0105a4e:	c3                   	ret    

f0105a4f <outb>:
{
f0105a4f:	89 c1                	mov    %eax,%ecx
f0105a51:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105a53:	89 ca                	mov    %ecx,%edx
f0105a55:	ee                   	out    %al,(%dx)
}
f0105a56:	c3                   	ret    

f0105a57 <sum>:
#define MPIOINTR  0x03  // One per bus interrupt source
#define MPLINTR   0x04  // One per system interrupt source

static uint8_t
sum(void *addr, int len)
{
f0105a57:	55                   	push   %ebp
f0105a58:	89 e5                	mov    %esp,%ebp
f0105a5a:	56                   	push   %esi
f0105a5b:	53                   	push   %ebx
f0105a5c:	89 c6                	mov    %eax,%esi
	int i, sum;

	sum = 0;
f0105a5e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < len; i++)
f0105a63:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105a68:	39 d1                	cmp    %edx,%ecx
f0105a6a:	7d 0b                	jge    f0105a77 <sum+0x20>
		sum += ((uint8_t *)addr)[i];
f0105a6c:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
f0105a70:	01 d8                	add    %ebx,%eax
	for (i = 0; i < len; i++)
f0105a72:	83 c1 01             	add    $0x1,%ecx
f0105a75:	eb f1                	jmp    f0105a68 <sum+0x11>
	return sum;
}
f0105a77:	5b                   	pop    %ebx
f0105a78:	5e                   	pop    %esi
f0105a79:	5d                   	pop    %ebp
f0105a7a:	c3                   	ret    

f0105a7b <_kaddr>:
{
f0105a7b:	55                   	push   %ebp
f0105a7c:	89 e5                	mov    %esp,%ebp
f0105a7e:	53                   	push   %ebx
f0105a7f:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0105a82:	89 cb                	mov    %ecx,%ebx
f0105a84:	c1 eb 0c             	shr    $0xc,%ebx
f0105a87:	3b 1d 88 8e 24 f0    	cmp    0xf0248e88,%ebx
f0105a8d:	73 0b                	jae    f0105a9a <_kaddr+0x1f>
	return (void *)(pa + KERNBASE);
f0105a8f:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0105a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105a98:	c9                   	leave  
f0105a99:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105a9a:	51                   	push   %ecx
f0105a9b:	68 2c 65 10 f0       	push   $0xf010652c
f0105aa0:	52                   	push   %edx
f0105aa1:	50                   	push   %eax
f0105aa2:	e8 c3 a5 ff ff       	call   f010006a <_panic>

f0105aa7 <mpsearch1>:

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105aa7:	55                   	push   %ebp
f0105aa8:	89 e5                	mov    %esp,%ebp
f0105aaa:	57                   	push   %edi
f0105aab:	56                   	push   %esi
f0105aac:	53                   	push   %ebx
f0105aad:	83 ec 0c             	sub    $0xc,%esp
f0105ab0:	89 c7                	mov    %eax,%edi
f0105ab2:	89 d6                	mov    %edx,%esi
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105ab4:	89 c1                	mov    %eax,%ecx
f0105ab6:	ba 57 00 00 00       	mov    $0x57,%edx
f0105abb:	b8 81 80 10 f0       	mov    $0xf0108081,%eax
f0105ac0:	e8 b6 ff ff ff       	call   f0105a7b <_kaddr>
f0105ac5:	89 c3                	mov    %eax,%ebx
f0105ac7:	8d 0c 3e             	lea    (%esi,%edi,1),%ecx
f0105aca:	ba 57 00 00 00       	mov    $0x57,%edx
f0105acf:	b8 81 80 10 f0       	mov    $0xf0108081,%eax
f0105ad4:	e8 a2 ff ff ff       	call   f0105a7b <_kaddr>
f0105ad9:	89 c6                	mov    %eax,%esi

	for (; mp < end; mp++)
f0105adb:	eb 03                	jmp    f0105ae0 <mpsearch1+0x39>
f0105add:	83 c3 10             	add    $0x10,%ebx
f0105ae0:	39 f3                	cmp    %esi,%ebx
f0105ae2:	73 29                	jae    f0105b0d <mpsearch1+0x66>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105ae4:	83 ec 04             	sub    $0x4,%esp
f0105ae7:	6a 04                	push   $0x4
f0105ae9:	68 91 80 10 f0       	push   $0xf0108091
f0105aee:	53                   	push   %ebx
f0105aef:	e8 95 fd ff ff       	call   f0105889 <memcmp>
f0105af4:	83 c4 10             	add    $0x10,%esp
f0105af7:	85 c0                	test   %eax,%eax
f0105af9:	75 e2                	jne    f0105add <mpsearch1+0x36>
		    sum(mp, sizeof(*mp)) == 0)
f0105afb:	ba 10 00 00 00       	mov    $0x10,%edx
f0105b00:	89 d8                	mov    %ebx,%eax
f0105b02:	e8 50 ff ff ff       	call   f0105a57 <sum>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105b07:	84 c0                	test   %al,%al
f0105b09:	75 d2                	jne    f0105add <mpsearch1+0x36>
f0105b0b:	eb 05                	jmp    f0105b12 <mpsearch1+0x6b>
			return mp;
	return NULL;
f0105b0d:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105b12:	89 d8                	mov    %ebx,%eax
f0105b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105b17:	5b                   	pop    %ebx
f0105b18:	5e                   	pop    %esi
f0105b19:	5f                   	pop    %edi
f0105b1a:	5d                   	pop    %ebp
f0105b1b:	c3                   	ret    

f0105b1c <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) if there is no EBDA, in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp *
mpsearch(void)
{
f0105b1c:	55                   	push   %ebp
f0105b1d:	89 e5                	mov    %esp,%ebp
f0105b1f:	83 ec 08             	sub    $0x8,%esp
	struct mp *mp;

	static_assert(sizeof(*mp) == 16);

	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);
f0105b22:	b9 00 04 00 00       	mov    $0x400,%ecx
f0105b27:	ba 6f 00 00 00       	mov    $0x6f,%edx
f0105b2c:	b8 81 80 10 f0       	mov    $0xf0108081,%eax
f0105b31:	e8 45 ff ff ff       	call   f0105a7b <_kaddr>

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105b36:	0f b7 50 0e          	movzwl 0xe(%eax),%edx
f0105b3a:	85 d2                	test   %edx,%edx
f0105b3c:	74 24                	je     f0105b62 <mpsearch+0x46>
		p <<= 4;	// Translate from segment to PA
f0105b3e:	89 d0                	mov    %edx,%eax
f0105b40:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105b43:	ba 00 04 00 00       	mov    $0x400,%edx
f0105b48:	e8 5a ff ff ff       	call   f0105aa7 <mpsearch1>
f0105b4d:	85 c0                	test   %eax,%eax
f0105b4f:	75 0f                	jne    f0105b60 <mpsearch+0x44>
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
		if ((mp = mpsearch1(p - 1024, 1024)))
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f0105b51:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105b56:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105b5b:	e8 47 ff ff ff       	call   f0105aa7 <mpsearch1>
}
f0105b60:	c9                   	leave  
f0105b61:	c3                   	ret    
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105b62:	0f b7 40 13          	movzwl 0x13(%eax),%eax
f0105b66:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105b69:	2d 00 04 00 00       	sub    $0x400,%eax
f0105b6e:	ba 00 04 00 00       	mov    $0x400,%edx
f0105b73:	e8 2f ff ff ff       	call   f0105aa7 <mpsearch1>
f0105b78:	85 c0                	test   %eax,%eax
f0105b7a:	75 e4                	jne    f0105b60 <mpsearch+0x44>
f0105b7c:	eb d3                	jmp    f0105b51 <mpsearch+0x35>

f0105b7e <mpconfig>:
// Search for an MP configuration table.  For now, don't accept the
// default configurations (physaddr == 0).
// Check for the correct signature, checksum, and version.
static struct mpconf *
mpconfig(struct mp **pmp)
{
f0105b7e:	55                   	push   %ebp
f0105b7f:	89 e5                	mov    %esp,%ebp
f0105b81:	57                   	push   %edi
f0105b82:	56                   	push   %esi
f0105b83:	53                   	push   %ebx
f0105b84:	83 ec 1c             	sub    $0x1c,%esp
f0105b87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f0105b8a:	e8 8d ff ff ff       	call   f0105b1c <mpsearch>
f0105b8f:	89 c6                	mov    %eax,%esi
f0105b91:	85 c0                	test   %eax,%eax
f0105b93:	0f 84 ef 00 00 00    	je     f0105c88 <mpconfig+0x10a>
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f0105b99:	8b 48 04             	mov    0x4(%eax),%ecx
f0105b9c:	85 c9                	test   %ecx,%ecx
f0105b9e:	74 6e                	je     f0105c0e <mpconfig+0x90>
f0105ba0:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0105ba4:	75 68                	jne    f0105c0e <mpconfig+0x90>
		cprintf("SMP: Default configurations not implemented\n");
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
f0105ba6:	ba 90 00 00 00       	mov    $0x90,%edx
f0105bab:	b8 81 80 10 f0       	mov    $0xf0108081,%eax
f0105bb0:	e8 c6 fe ff ff       	call   f0105a7b <_kaddr>
f0105bb5:	89 c3                	mov    %eax,%ebx
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105bb7:	83 ec 04             	sub    $0x4,%esp
f0105bba:	6a 04                	push   $0x4
f0105bbc:	68 96 80 10 f0       	push   $0xf0108096
f0105bc1:	50                   	push   %eax
f0105bc2:	e8 c2 fc ff ff       	call   f0105889 <memcmp>
f0105bc7:	83 c4 10             	add    $0x10,%esp
f0105bca:	85 c0                	test   %eax,%eax
f0105bcc:	75 57                	jne    f0105c25 <mpconfig+0xa7>
		cprintf("SMP: Incorrect MP configuration table signature\n");
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0105bce:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105bd2:	0f b7 d7             	movzwl %di,%edx
f0105bd5:	89 d8                	mov    %ebx,%eax
f0105bd7:	e8 7b fe ff ff       	call   f0105a57 <sum>
f0105bdc:	84 c0                	test   %al,%al
f0105bde:	75 5c                	jne    f0105c3c <mpconfig+0xbe>
		cprintf("SMP: Bad MP configuration checksum\n");
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
f0105be0:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
f0105be4:	3c 01                	cmp    $0x1,%al
f0105be6:	74 04                	je     f0105bec <mpconfig+0x6e>
f0105be8:	3c 04                	cmp    $0x4,%al
f0105bea:	75 67                	jne    f0105c53 <mpconfig+0xd5>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105bec:	0f b7 53 28          	movzwl 0x28(%ebx),%edx
f0105bf0:	0f b7 c7             	movzwl %di,%eax
f0105bf3:	01 d8                	add    %ebx,%eax
f0105bf5:	e8 5d fe ff ff       	call   f0105a57 <sum>
f0105bfa:	02 43 2a             	add    0x2a(%ebx),%al
f0105bfd:	75 6f                	jne    f0105c6e <mpconfig+0xf0>
		cprintf("SMP: Bad MP configuration extended checksum\n");
		return NULL;
	}
	*pmp = mp;
f0105bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105c02:	89 30                	mov    %esi,(%eax)
	return conf;
}
f0105c04:	89 d8                	mov    %ebx,%eax
f0105c06:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105c09:	5b                   	pop    %ebx
f0105c0a:	5e                   	pop    %esi
f0105c0b:	5f                   	pop    %edi
f0105c0c:	5d                   	pop    %ebp
f0105c0d:	c3                   	ret    
		cprintf("SMP: Default configurations not implemented\n");
f0105c0e:	83 ec 0c             	sub    $0xc,%esp
f0105c11:	68 f4 7e 10 f0       	push   $0xf0107ef4
f0105c16:	e8 4e dc ff ff       	call   f0103869 <cprintf>
		return NULL;
f0105c1b:	83 c4 10             	add    $0x10,%esp
f0105c1e:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c23:	eb df                	jmp    f0105c04 <mpconfig+0x86>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105c25:	83 ec 0c             	sub    $0xc,%esp
f0105c28:	68 24 7f 10 f0       	push   $0xf0107f24
f0105c2d:	e8 37 dc ff ff       	call   f0103869 <cprintf>
		return NULL;
f0105c32:	83 c4 10             	add    $0x10,%esp
f0105c35:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c3a:	eb c8                	jmp    f0105c04 <mpconfig+0x86>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105c3c:	83 ec 0c             	sub    $0xc,%esp
f0105c3f:	68 58 7f 10 f0       	push   $0xf0107f58
f0105c44:	e8 20 dc ff ff       	call   f0103869 <cprintf>
		return NULL;
f0105c49:	83 c4 10             	add    $0x10,%esp
f0105c4c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c51:	eb b1                	jmp    f0105c04 <mpconfig+0x86>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105c53:	83 ec 08             	sub    $0x8,%esp
f0105c56:	0f b6 c0             	movzbl %al,%eax
f0105c59:	50                   	push   %eax
f0105c5a:	68 7c 7f 10 f0       	push   $0xf0107f7c
f0105c5f:	e8 05 dc ff ff       	call   f0103869 <cprintf>
		return NULL;
f0105c64:	83 c4 10             	add    $0x10,%esp
f0105c67:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c6c:	eb 96                	jmp    f0105c04 <mpconfig+0x86>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105c6e:	83 ec 0c             	sub    $0xc,%esp
f0105c71:	68 9c 7f 10 f0       	push   $0xf0107f9c
f0105c76:	e8 ee db ff ff       	call   f0103869 <cprintf>
		return NULL;
f0105c7b:	83 c4 10             	add    $0x10,%esp
f0105c7e:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c83:	e9 7c ff ff ff       	jmp    f0105c04 <mpconfig+0x86>
		return NULL;
f0105c88:	89 c3                	mov    %eax,%ebx
f0105c8a:	e9 75 ff ff ff       	jmp    f0105c04 <mpconfig+0x86>

f0105c8f <mp_init>:

void
mp_init(void)
{
f0105c8f:	f3 0f 1e fb          	endbr32 
f0105c93:	55                   	push   %ebp
f0105c94:	89 e5                	mov    %esp,%ebp
f0105c96:	57                   	push   %edi
f0105c97:	56                   	push   %esi
f0105c98:	53                   	push   %ebx
f0105c99:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105c9c:	c7 05 c0 93 24 f0 20 	movl   $0xf0249020,0xf02493c0
f0105ca3:	90 24 f0 
	if ((conf = mpconfig(&mp)) == 0)
f0105ca6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105ca9:	e8 d0 fe ff ff       	call   f0105b7e <mpconfig>
f0105cae:	85 c0                	test   %eax,%eax
f0105cb0:	0f 84 e5 00 00 00    	je     f0105d9b <mp_init+0x10c>
f0105cb6:	89 c7                	mov    %eax,%edi
		return;
	ismp = 1;
f0105cb8:	c7 05 00 90 24 f0 01 	movl   $0x1,0xf0249000
f0105cbf:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105cc2:	8b 40 24             	mov    0x24(%eax),%eax
f0105cc5:	a3 00 a0 28 f0       	mov    %eax,0xf028a000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105cca:	8d 77 2c             	lea    0x2c(%edi),%esi
f0105ccd:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105cd2:	eb 38                	jmp    f0105d0c <mp_init+0x7d>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105cd4:	f6 46 03 02          	testb  $0x2,0x3(%esi)
f0105cd8:	74 11                	je     f0105ceb <mp_init+0x5c>
				bootcpu = &cpus[ncpu];
f0105cda:	6b 05 c4 93 24 f0 74 	imul   $0x74,0xf02493c4,%eax
f0105ce1:	05 20 90 24 f0       	add    $0xf0249020,%eax
f0105ce6:	a3 c0 93 24 f0       	mov    %eax,0xf02493c0
			if (ncpu < NCPU) {
f0105ceb:	a1 c4 93 24 f0       	mov    0xf02493c4,%eax
f0105cf0:	83 f8 07             	cmp    $0x7,%eax
f0105cf3:	7f 33                	jg     f0105d28 <mp_init+0x99>
				cpus[ncpu].cpu_id = ncpu;
f0105cf5:	6b d0 74             	imul   $0x74,%eax,%edx
f0105cf8:	88 82 20 90 24 f0    	mov    %al,-0xfdb6fe0(%edx)
				ncpu++;
f0105cfe:	83 c0 01             	add    $0x1,%eax
f0105d01:	a3 c4 93 24 f0       	mov    %eax,0xf02493c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105d06:	83 c6 14             	add    $0x14,%esi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105d09:	83 c3 01             	add    $0x1,%ebx
f0105d0c:	0f b7 47 22          	movzwl 0x22(%edi),%eax
f0105d10:	39 d8                	cmp    %ebx,%eax
f0105d12:	76 4f                	jbe    f0105d63 <mp_init+0xd4>
		switch (*p) {
f0105d14:	0f b6 06             	movzbl (%esi),%eax
f0105d17:	84 c0                	test   %al,%al
f0105d19:	74 b9                	je     f0105cd4 <mp_init+0x45>
f0105d1b:	8d 50 ff             	lea    -0x1(%eax),%edx
f0105d1e:	80 fa 03             	cmp    $0x3,%dl
f0105d21:	77 1c                	ja     f0105d3f <mp_init+0xb0>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105d23:	83 c6 08             	add    $0x8,%esi
			continue;
f0105d26:	eb e1                	jmp    f0105d09 <mp_init+0x7a>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105d28:	83 ec 08             	sub    $0x8,%esp
f0105d2b:	0f b6 46 01          	movzbl 0x1(%esi),%eax
f0105d2f:	50                   	push   %eax
f0105d30:	68 cc 7f 10 f0       	push   $0xf0107fcc
f0105d35:	e8 2f db ff ff       	call   f0103869 <cprintf>
f0105d3a:	83 c4 10             	add    $0x10,%esp
f0105d3d:	eb c7                	jmp    f0105d06 <mp_init+0x77>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105d3f:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105d42:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105d45:	50                   	push   %eax
f0105d46:	68 f4 7f 10 f0       	push   $0xf0107ff4
f0105d4b:	e8 19 db ff ff       	call   f0103869 <cprintf>
			ismp = 0;
f0105d50:	c7 05 00 90 24 f0 00 	movl   $0x0,0xf0249000
f0105d57:	00 00 00 
			i = conf->entry;
f0105d5a:	0f b7 5f 22          	movzwl 0x22(%edi),%ebx
f0105d5e:	83 c4 10             	add    $0x10,%esp
f0105d61:	eb a6                	jmp    f0105d09 <mp_init+0x7a>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105d63:	a1 c0 93 24 f0       	mov    0xf02493c0,%eax
f0105d68:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105d6f:	83 3d 00 90 24 f0 00 	cmpl   $0x0,0xf0249000
f0105d76:	74 2b                	je     f0105da3 <mp_init+0x114>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105d78:	83 ec 04             	sub    $0x4,%esp
f0105d7b:	ff 35 c4 93 24 f0    	pushl  0xf02493c4
f0105d81:	0f b6 00             	movzbl (%eax),%eax
f0105d84:	50                   	push   %eax
f0105d85:	68 9b 80 10 f0       	push   $0xf010809b
f0105d8a:	e8 da da ff ff       	call   f0103869 <cprintf>

	if (mp->imcrp) {
f0105d8f:	83 c4 10             	add    $0x10,%esp
f0105d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105d95:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105d99:	75 2e                	jne    f0105dc9 <mp_init+0x13a>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105d9e:	5b                   	pop    %ebx
f0105d9f:	5e                   	pop    %esi
f0105da0:	5f                   	pop    %edi
f0105da1:	5d                   	pop    %ebp
f0105da2:	c3                   	ret    
		ncpu = 1;
f0105da3:	c7 05 c4 93 24 f0 01 	movl   $0x1,0xf02493c4
f0105daa:	00 00 00 
		lapicaddr = 0;
f0105dad:	c7 05 00 a0 28 f0 00 	movl   $0x0,0xf028a000
f0105db4:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105db7:	83 ec 0c             	sub    $0xc,%esp
f0105dba:	68 14 80 10 f0       	push   $0xf0108014
f0105dbf:	e8 a5 da ff ff       	call   f0103869 <cprintf>
		return;
f0105dc4:	83 c4 10             	add    $0x10,%esp
f0105dc7:	eb d2                	jmp    f0105d9b <mp_init+0x10c>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105dc9:	83 ec 0c             	sub    $0xc,%esp
f0105dcc:	68 40 80 10 f0       	push   $0xf0108040
f0105dd1:	e8 93 da ff ff       	call   f0103869 <cprintf>
		outb(0x22, 0x70);   // Select IMCR
f0105dd6:	ba 70 00 00 00       	mov    $0x70,%edx
f0105ddb:	b8 22 00 00 00       	mov    $0x22,%eax
f0105de0:	e8 6a fc ff ff       	call   f0105a4f <outb>
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105de5:	b8 23 00 00 00       	mov    $0x23,%eax
f0105dea:	e8 5c fc ff ff       	call   f0105a4b <inb>
f0105def:	83 c8 01             	or     $0x1,%eax
f0105df2:	0f b6 d0             	movzbl %al,%edx
f0105df5:	b8 23 00 00 00       	mov    $0x23,%eax
f0105dfa:	e8 50 fc ff ff       	call   f0105a4f <outb>
f0105dff:	83 c4 10             	add    $0x10,%esp
f0105e02:	eb 97                	jmp    f0105d9b <mp_init+0x10c>

f0105e04 <outb>:
{
f0105e04:	89 c1                	mov    %eax,%ecx
f0105e06:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105e08:	89 ca                	mov    %ecx,%edx
f0105e0a:	ee                   	out    %al,(%dx)
}
f0105e0b:	c3                   	ret    

f0105e0c <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0105e0c:	8b 0d 04 a0 28 f0    	mov    0xf028a004,%ecx
f0105e12:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105e15:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0105e17:	a1 04 a0 28 f0       	mov    0xf028a004,%eax
f0105e1c:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105e1f:	c3                   	ret    

f0105e20 <_kaddr>:
{
f0105e20:	55                   	push   %ebp
f0105e21:	89 e5                	mov    %esp,%ebp
f0105e23:	53                   	push   %ebx
f0105e24:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0105e27:	89 cb                	mov    %ecx,%ebx
f0105e29:	c1 eb 0c             	shr    $0xc,%ebx
f0105e2c:	3b 1d 88 8e 24 f0    	cmp    0xf0248e88,%ebx
f0105e32:	73 0b                	jae    f0105e3f <_kaddr+0x1f>
	return (void *)(pa + KERNBASE);
f0105e34:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0105e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105e3d:	c9                   	leave  
f0105e3e:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105e3f:	51                   	push   %ecx
f0105e40:	68 2c 65 10 f0       	push   $0xf010652c
f0105e45:	52                   	push   %edx
f0105e46:	50                   	push   %eax
f0105e47:	e8 1e a2 ff ff       	call   f010006a <_panic>

f0105e4c <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0105e4c:	f3 0f 1e fb          	endbr32 
	if (lapic)
f0105e50:	8b 15 04 a0 28 f0    	mov    0xf028a004,%edx
		return lapic[ID] >> 24;
	return 0;
f0105e56:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0105e5b:	85 d2                	test   %edx,%edx
f0105e5d:	74 06                	je     f0105e65 <cpunum+0x19>
		return lapic[ID] >> 24;
f0105e5f:	8b 42 20             	mov    0x20(%edx),%eax
f0105e62:	c1 e8 18             	shr    $0x18,%eax
}
f0105e65:	c3                   	ret    

f0105e66 <lapic_init>:
{
f0105e66:	f3 0f 1e fb          	endbr32 
	if (!lapicaddr)
f0105e6a:	a1 00 a0 28 f0       	mov    0xf028a000,%eax
f0105e6f:	85 c0                	test   %eax,%eax
f0105e71:	75 01                	jne    f0105e74 <lapic_init+0xe>
f0105e73:	c3                   	ret    
{
f0105e74:	55                   	push   %ebp
f0105e75:	89 e5                	mov    %esp,%ebp
f0105e77:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0105e7a:	68 00 10 00 00       	push   $0x1000
f0105e7f:	50                   	push   %eax
f0105e80:	e8 52 bf ff ff       	call   f0101dd7 <mmio_map_region>
f0105e85:	a3 04 a0 28 f0       	mov    %eax,0xf028a004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0105e8a:	ba 27 01 00 00       	mov    $0x127,%edx
f0105e8f:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105e94:	e8 73 ff ff ff       	call   f0105e0c <lapicw>
	lapicw(TDCR, X1);
f0105e99:	ba 0b 00 00 00       	mov    $0xb,%edx
f0105e9e:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105ea3:	e8 64 ff ff ff       	call   f0105e0c <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105ea8:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105ead:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105eb2:	e8 55 ff ff ff       	call   f0105e0c <lapicw>
	lapicw(TICR, 10000000); 
f0105eb7:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105ebc:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105ec1:	e8 46 ff ff ff       	call   f0105e0c <lapicw>
	if (thiscpu != bootcpu)
f0105ec6:	e8 81 ff ff ff       	call   f0105e4c <cpunum>
f0105ecb:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ece:	05 20 90 24 f0       	add    $0xf0249020,%eax
f0105ed3:	83 c4 10             	add    $0x10,%esp
f0105ed6:	39 05 c0 93 24 f0    	cmp    %eax,0xf02493c0
f0105edc:	74 0f                	je     f0105eed <lapic_init+0x87>
		lapicw(LINT0, MASKED);
f0105ede:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105ee3:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105ee8:	e8 1f ff ff ff       	call   f0105e0c <lapicw>
	lapicw(LINT1, MASKED);
f0105eed:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105ef2:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105ef7:	e8 10 ff ff ff       	call   f0105e0c <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0105efc:	a1 04 a0 28 f0       	mov    0xf028a004,%eax
f0105f01:	8b 40 30             	mov    0x30(%eax),%eax
f0105f04:	c1 e8 10             	shr    $0x10,%eax
f0105f07:	a8 fc                	test   $0xfc,%al
f0105f09:	75 7c                	jne    f0105f87 <lapic_init+0x121>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105f0b:	ba 33 00 00 00       	mov    $0x33,%edx
f0105f10:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105f15:	e8 f2 fe ff ff       	call   f0105e0c <lapicw>
	lapicw(ESR, 0);
f0105f1a:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f1f:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105f24:	e8 e3 fe ff ff       	call   f0105e0c <lapicw>
	lapicw(ESR, 0);
f0105f29:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f2e:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105f33:	e8 d4 fe ff ff       	call   f0105e0c <lapicw>
	lapicw(EOI, 0);
f0105f38:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f3d:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105f42:	e8 c5 fe ff ff       	call   f0105e0c <lapicw>
	lapicw(ICRHI, 0);
f0105f47:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f4c:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105f51:	e8 b6 fe ff ff       	call   f0105e0c <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105f56:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105f5b:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105f60:	e8 a7 fe ff ff       	call   f0105e0c <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0105f65:	8b 15 04 a0 28 f0    	mov    0xf028a004,%edx
f0105f6b:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105f71:	f6 c4 10             	test   $0x10,%ah
f0105f74:	75 f5                	jne    f0105f6b <lapic_init+0x105>
	lapicw(TPR, 0);
f0105f76:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f7b:	b8 20 00 00 00       	mov    $0x20,%eax
f0105f80:	e8 87 fe ff ff       	call   f0105e0c <lapicw>
}
f0105f85:	c9                   	leave  
f0105f86:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0105f87:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105f8c:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105f91:	e8 76 fe ff ff       	call   f0105e0c <lapicw>
f0105f96:	e9 70 ff ff ff       	jmp    f0105f0b <lapic_init+0xa5>

f0105f9b <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f0105f9b:	f3 0f 1e fb          	endbr32 
	if (lapic)
f0105f9f:	83 3d 04 a0 28 f0 00 	cmpl   $0x0,0xf028a004
f0105fa6:	74 17                	je     f0105fbf <lapic_eoi+0x24>
{
f0105fa8:	55                   	push   %ebp
f0105fa9:	89 e5                	mov    %esp,%ebp
f0105fab:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0105fae:	ba 00 00 00 00       	mov    $0x0,%edx
f0105fb3:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105fb8:	e8 4f fe ff ff       	call   f0105e0c <lapicw>
}
f0105fbd:	c9                   	leave  
f0105fbe:	c3                   	ret    
f0105fbf:	c3                   	ret    

f0105fc0 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0105fc0:	f3 0f 1e fb          	endbr32 
f0105fc4:	55                   	push   %ebp
f0105fc5:	89 e5                	mov    %esp,%ebp
f0105fc7:	56                   	push   %esi
f0105fc8:	53                   	push   %ebx
f0105fc9:	8b 75 08             	mov    0x8(%ebp),%esi
f0105fcc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	uint16_t *wrv;

	// "The BSP must initialize CMOS shutdown code to 0AH
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
f0105fcf:	ba 0f 00 00 00       	mov    $0xf,%edx
f0105fd4:	b8 70 00 00 00       	mov    $0x70,%eax
f0105fd9:	e8 26 fe ff ff       	call   f0105e04 <outb>
	outb(IO_RTC+1, 0x0A);
f0105fde:	ba 0a 00 00 00       	mov    $0xa,%edx
f0105fe3:	b8 71 00 00 00       	mov    $0x71,%eax
f0105fe8:	e8 17 fe ff ff       	call   f0105e04 <outb>
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
f0105fed:	b9 67 04 00 00       	mov    $0x467,%ecx
f0105ff2:	ba 98 00 00 00       	mov    $0x98,%edx
f0105ff7:	b8 b8 80 10 f0       	mov    $0xf01080b8,%eax
f0105ffc:	e8 1f fe ff ff       	call   f0105e20 <_kaddr>
	wrv[0] = 0;
f0106001:	66 c7 00 00 00       	movw   $0x0,(%eax)
	wrv[1] = addr >> 4;
f0106006:	89 da                	mov    %ebx,%edx
f0106008:	c1 ea 04             	shr    $0x4,%edx
f010600b:	66 89 50 02          	mov    %dx,0x2(%eax)

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f010600f:	c1 e6 18             	shl    $0x18,%esi
f0106012:	89 f2                	mov    %esi,%edx
f0106014:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106019:	e8 ee fd ff ff       	call   f0105e0c <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f010601e:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106023:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106028:	e8 df fd ff ff       	call   f0105e0c <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f010602d:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106032:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106037:	e8 d0 fd ff ff       	call   f0105e0c <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010603c:	c1 eb 0c             	shr    $0xc,%ebx
f010603f:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106042:	89 f2                	mov    %esi,%edx
f0106044:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106049:	e8 be fd ff ff       	call   f0105e0c <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010604e:	89 da                	mov    %ebx,%edx
f0106050:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106055:	e8 b2 fd ff ff       	call   f0105e0c <lapicw>
		lapicw(ICRHI, apicid << 24);
f010605a:	89 f2                	mov    %esi,%edx
f010605c:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106061:	e8 a6 fd ff ff       	call   f0105e0c <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106066:	89 da                	mov    %ebx,%edx
f0106068:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010606d:	e8 9a fd ff ff       	call   f0105e0c <lapicw>
		microdelay(200);
	}
}
f0106072:	5b                   	pop    %ebx
f0106073:	5e                   	pop    %esi
f0106074:	5d                   	pop    %ebp
f0106075:	c3                   	ret    

f0106076 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106076:	f3 0f 1e fb          	endbr32 
f010607a:	55                   	push   %ebp
f010607b:	89 e5                	mov    %esp,%ebp
f010607d:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106080:	8b 55 08             	mov    0x8(%ebp),%edx
f0106083:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106089:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010608e:	e8 79 fd ff ff       	call   f0105e0c <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106093:	8b 15 04 a0 28 f0    	mov    0xf028a004,%edx
f0106099:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010609f:	f6 c4 10             	test   $0x10,%ah
f01060a2:	75 f5                	jne    f0106099 <lapic_ipi+0x23>
		;
}
f01060a4:	c9                   	leave  
f01060a5:	c3                   	ret    

f01060a6 <xchg>:
{
f01060a6:	89 c1                	mov    %eax,%ecx
f01060a8:	89 d0                	mov    %edx,%eax
	asm volatile("lock; xchgl %0, %1"
f01060aa:	f0 87 01             	lock xchg %eax,(%ecx)
}
f01060ad:	c3                   	ret    

f01060ae <get_caller_pcs>:
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01060ae:	89 e9                	mov    %ebp,%ecx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f01060b0:	ba 00 00 00 00       	mov    $0x0,%edx
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01060b5:	81 f9 ff ff 7f ef    	cmp    $0xef7fffff,%ecx
f01060bb:	76 3f                	jbe    f01060fc <get_caller_pcs+0x4e>
f01060bd:	83 fa 09             	cmp    $0x9,%edx
f01060c0:	7f 3a                	jg     f01060fc <get_caller_pcs+0x4e>
{
f01060c2:	55                   	push   %ebp
f01060c3:	89 e5                	mov    %esp,%ebp
f01060c5:	53                   	push   %ebx
			break;
		pcs[i] = ebp[1];          // saved %eip
f01060c6:	8b 59 04             	mov    0x4(%ecx),%ebx
f01060c9:	89 1c 90             	mov    %ebx,(%eax,%edx,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f01060cc:	8b 09                	mov    (%ecx),%ecx
	for (i = 0; i < 10; i++){
f01060ce:	83 c2 01             	add    $0x1,%edx
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01060d1:	81 f9 ff ff 7f ef    	cmp    $0xef7fffff,%ecx
f01060d7:	76 11                	jbe    f01060ea <get_caller_pcs+0x3c>
f01060d9:	83 fa 09             	cmp    $0x9,%edx
f01060dc:	7e e8                	jle    f01060c6 <get_caller_pcs+0x18>
f01060de:	eb 0a                	jmp    f01060ea <get_caller_pcs+0x3c>
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f01060e0:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
	for (; i < 10; i++)
f01060e7:	83 c2 01             	add    $0x1,%edx
f01060ea:	83 fa 09             	cmp    $0x9,%edx
f01060ed:	7e f1                	jle    f01060e0 <get_caller_pcs+0x32>
}
f01060ef:	5b                   	pop    %ebx
f01060f0:	5d                   	pop    %ebp
f01060f1:	c3                   	ret    
		pcs[i] = 0;
f01060f2:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
	for (; i < 10; i++)
f01060f9:	83 c2 01             	add    $0x1,%edx
f01060fc:	83 fa 09             	cmp    $0x9,%edx
f01060ff:	7e f1                	jle    f01060f2 <get_caller_pcs+0x44>
f0106101:	c3                   	ret    

f0106102 <holding>:

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f0106102:	83 38 00             	cmpl   $0x0,(%eax)
f0106105:	75 06                	jne    f010610d <holding+0xb>
f0106107:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010610c:	c3                   	ret    
{
f010610d:	55                   	push   %ebp
f010610e:	89 e5                	mov    %esp,%ebp
f0106110:	53                   	push   %ebx
f0106111:	83 ec 04             	sub    $0x4,%esp
	return lock->locked && lock->cpu == thiscpu;
f0106114:	8b 58 08             	mov    0x8(%eax),%ebx
f0106117:	e8 30 fd ff ff       	call   f0105e4c <cpunum>
f010611c:	6b c0 74             	imul   $0x74,%eax,%eax
f010611f:	05 20 90 24 f0       	add    $0xf0249020,%eax
f0106124:	39 c3                	cmp    %eax,%ebx
f0106126:	0f 94 c0             	sete   %al
f0106129:	0f b6 c0             	movzbl %al,%eax
}
f010612c:	83 c4 04             	add    $0x4,%esp
f010612f:	5b                   	pop    %ebx
f0106130:	5d                   	pop    %ebp
f0106131:	c3                   	ret    

f0106132 <__spin_initlock>:
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106132:	f3 0f 1e fb          	endbr32 
f0106136:	55                   	push   %ebp
f0106137:	89 e5                	mov    %esp,%ebp
f0106139:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f010613c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106142:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106145:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106148:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f010614f:	5d                   	pop    %ebp
f0106150:	c3                   	ret    

f0106151 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106151:	f3 0f 1e fb          	endbr32 
f0106155:	55                   	push   %ebp
f0106156:	89 e5                	mov    %esp,%ebp
f0106158:	53                   	push   %ebx
f0106159:	83 ec 04             	sub    $0x4,%esp
f010615c:	8b 5d 08             	mov    0x8(%ebp),%ebx
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f010615f:	89 d8                	mov    %ebx,%eax
f0106161:	e8 9c ff ff ff       	call   f0106102 <holding>
f0106166:	85 c0                	test   %eax,%eax
f0106168:	74 20                	je     f010618a <spin_lock+0x39>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f010616a:	8b 5b 04             	mov    0x4(%ebx),%ebx
f010616d:	e8 da fc ff ff       	call   f0105e4c <cpunum>
f0106172:	83 ec 0c             	sub    $0xc,%esp
f0106175:	53                   	push   %ebx
f0106176:	50                   	push   %eax
f0106177:	68 c8 80 10 f0       	push   $0xf01080c8
f010617c:	6a 41                	push   $0x41
f010617e:	68 2a 81 10 f0       	push   $0xf010812a
f0106183:	e8 e2 9e ff ff       	call   f010006a <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0106188:	f3 90                	pause  
	while (xchg(&lk->locked, 1) != 0)
f010618a:	ba 01 00 00 00       	mov    $0x1,%edx
f010618f:	89 d8                	mov    %ebx,%eax
f0106191:	e8 10 ff ff ff       	call   f01060a6 <xchg>
f0106196:	85 c0                	test   %eax,%eax
f0106198:	75 ee                	jne    f0106188 <spin_lock+0x37>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f010619a:	e8 ad fc ff ff       	call   f0105e4c <cpunum>
f010619f:	6b c0 74             	imul   $0x74,%eax,%eax
f01061a2:	05 20 90 24 f0       	add    $0xf0249020,%eax
f01061a7:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f01061aa:	8d 43 0c             	lea    0xc(%ebx),%eax
f01061ad:	e8 fc fe ff ff       	call   f01060ae <get_caller_pcs>
#endif
}
f01061b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01061b5:	c9                   	leave  
f01061b6:	c3                   	ret    

f01061b7 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f01061b7:	f3 0f 1e fb          	endbr32 
f01061bb:	55                   	push   %ebp
f01061bc:	89 e5                	mov    %esp,%ebp
f01061be:	57                   	push   %edi
f01061bf:	56                   	push   %esi
f01061c0:	53                   	push   %ebx
f01061c1:	83 ec 4c             	sub    $0x4c,%esp
f01061c4:	8b 75 08             	mov    0x8(%ebp),%esi
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
f01061c7:	89 f0                	mov    %esi,%eax
f01061c9:	e8 34 ff ff ff       	call   f0106102 <holding>
f01061ce:	85 c0                	test   %eax,%eax
f01061d0:	74 22                	je     f01061f4 <spin_unlock+0x3d>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f01061d2:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f01061d9:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	// The xchg instruction is atomic (i.e. uses the "lock" prefix) with
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
f01061e0:	ba 00 00 00 00       	mov    $0x0,%edx
f01061e5:	89 f0                	mov    %esi,%eax
f01061e7:	e8 ba fe ff ff       	call   f01060a6 <xchg>
}
f01061ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01061ef:	5b                   	pop    %ebx
f01061f0:	5e                   	pop    %esi
f01061f1:	5f                   	pop    %edi
f01061f2:	5d                   	pop    %ebp
f01061f3:	c3                   	ret    
		memmove(pcs, lk->pcs, sizeof pcs);
f01061f4:	83 ec 04             	sub    $0x4,%esp
f01061f7:	6a 28                	push   $0x28
f01061f9:	8d 46 0c             	lea    0xc(%esi),%eax
f01061fc:	50                   	push   %eax
f01061fd:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106200:	53                   	push   %ebx
f0106201:	e8 03 f6 ff ff       	call   f0105809 <memmove>
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106206:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106209:	0f b6 38             	movzbl (%eax),%edi
f010620c:	8b 76 04             	mov    0x4(%esi),%esi
f010620f:	e8 38 fc ff ff       	call   f0105e4c <cpunum>
f0106214:	57                   	push   %edi
f0106215:	56                   	push   %esi
f0106216:	50                   	push   %eax
f0106217:	68 f4 80 10 f0       	push   $0xf01080f4
f010621c:	e8 48 d6 ff ff       	call   f0103869 <cprintf>
f0106221:	83 c4 20             	add    $0x20,%esp
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106224:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106227:	eb 1c                	jmp    f0106245 <spin_unlock+0x8e>
				cprintf("  %08x\n", pcs[i]);
f0106229:	83 ec 08             	sub    $0x8,%esp
f010622c:	ff 36                	pushl  (%esi)
f010622e:	68 51 81 10 f0       	push   $0xf0108151
f0106233:	e8 31 d6 ff ff       	call   f0103869 <cprintf>
f0106238:	83 c4 10             	add    $0x10,%esp
f010623b:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f010623e:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106241:	39 c3                	cmp    %eax,%ebx
f0106243:	74 40                	je     f0106285 <spin_unlock+0xce>
f0106245:	89 de                	mov    %ebx,%esi
f0106247:	8b 03                	mov    (%ebx),%eax
f0106249:	85 c0                	test   %eax,%eax
f010624b:	74 38                	je     f0106285 <spin_unlock+0xce>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f010624d:	83 ec 08             	sub    $0x8,%esp
f0106250:	57                   	push   %edi
f0106251:	50                   	push   %eax
f0106252:	e8 d2 ea ff ff       	call   f0104d29 <debuginfo_eip>
f0106257:	83 c4 10             	add    $0x10,%esp
f010625a:	85 c0                	test   %eax,%eax
f010625c:	78 cb                	js     f0106229 <spin_unlock+0x72>
					pcs[i] - info.eip_fn_addr);
f010625e:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106260:	83 ec 04             	sub    $0x4,%esp
f0106263:	89 c2                	mov    %eax,%edx
f0106265:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106268:	52                   	push   %edx
f0106269:	ff 75 b0             	pushl  -0x50(%ebp)
f010626c:	ff 75 b4             	pushl  -0x4c(%ebp)
f010626f:	ff 75 ac             	pushl  -0x54(%ebp)
f0106272:	ff 75 a8             	pushl  -0x58(%ebp)
f0106275:	50                   	push   %eax
f0106276:	68 3a 81 10 f0       	push   $0xf010813a
f010627b:	e8 e9 d5 ff ff       	call   f0103869 <cprintf>
f0106280:	83 c4 20             	add    $0x20,%esp
f0106283:	eb b6                	jmp    f010623b <spin_unlock+0x84>
		panic("spin_unlock");
f0106285:	83 ec 04             	sub    $0x4,%esp
f0106288:	68 59 81 10 f0       	push   $0xf0108159
f010628d:	6a 67                	push   $0x67
f010628f:	68 2a 81 10 f0       	push   $0xf010812a
f0106294:	e8 d1 9d ff ff       	call   f010006a <_panic>
f0106299:	66 90                	xchg   %ax,%ax
f010629b:	66 90                	xchg   %ax,%ax
f010629d:	66 90                	xchg   %ax,%ax
f010629f:	90                   	nop

f01062a0 <__udivdi3>:
f01062a0:	f3 0f 1e fb          	endbr32 
f01062a4:	55                   	push   %ebp
f01062a5:	57                   	push   %edi
f01062a6:	56                   	push   %esi
f01062a7:	53                   	push   %ebx
f01062a8:	83 ec 1c             	sub    $0x1c,%esp
f01062ab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f01062af:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01062b3:	8b 74 24 34          	mov    0x34(%esp),%esi
f01062b7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01062bb:	85 d2                	test   %edx,%edx
f01062bd:	75 19                	jne    f01062d8 <__udivdi3+0x38>
f01062bf:	39 f3                	cmp    %esi,%ebx
f01062c1:	76 4d                	jbe    f0106310 <__udivdi3+0x70>
f01062c3:	31 ff                	xor    %edi,%edi
f01062c5:	89 e8                	mov    %ebp,%eax
f01062c7:	89 f2                	mov    %esi,%edx
f01062c9:	f7 f3                	div    %ebx
f01062cb:	89 fa                	mov    %edi,%edx
f01062cd:	83 c4 1c             	add    $0x1c,%esp
f01062d0:	5b                   	pop    %ebx
f01062d1:	5e                   	pop    %esi
f01062d2:	5f                   	pop    %edi
f01062d3:	5d                   	pop    %ebp
f01062d4:	c3                   	ret    
f01062d5:	8d 76 00             	lea    0x0(%esi),%esi
f01062d8:	39 f2                	cmp    %esi,%edx
f01062da:	76 14                	jbe    f01062f0 <__udivdi3+0x50>
f01062dc:	31 ff                	xor    %edi,%edi
f01062de:	31 c0                	xor    %eax,%eax
f01062e0:	89 fa                	mov    %edi,%edx
f01062e2:	83 c4 1c             	add    $0x1c,%esp
f01062e5:	5b                   	pop    %ebx
f01062e6:	5e                   	pop    %esi
f01062e7:	5f                   	pop    %edi
f01062e8:	5d                   	pop    %ebp
f01062e9:	c3                   	ret    
f01062ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01062f0:	0f bd fa             	bsr    %edx,%edi
f01062f3:	83 f7 1f             	xor    $0x1f,%edi
f01062f6:	75 48                	jne    f0106340 <__udivdi3+0xa0>
f01062f8:	39 f2                	cmp    %esi,%edx
f01062fa:	72 06                	jb     f0106302 <__udivdi3+0x62>
f01062fc:	31 c0                	xor    %eax,%eax
f01062fe:	39 eb                	cmp    %ebp,%ebx
f0106300:	77 de                	ja     f01062e0 <__udivdi3+0x40>
f0106302:	b8 01 00 00 00       	mov    $0x1,%eax
f0106307:	eb d7                	jmp    f01062e0 <__udivdi3+0x40>
f0106309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106310:	89 d9                	mov    %ebx,%ecx
f0106312:	85 db                	test   %ebx,%ebx
f0106314:	75 0b                	jne    f0106321 <__udivdi3+0x81>
f0106316:	b8 01 00 00 00       	mov    $0x1,%eax
f010631b:	31 d2                	xor    %edx,%edx
f010631d:	f7 f3                	div    %ebx
f010631f:	89 c1                	mov    %eax,%ecx
f0106321:	31 d2                	xor    %edx,%edx
f0106323:	89 f0                	mov    %esi,%eax
f0106325:	f7 f1                	div    %ecx
f0106327:	89 c6                	mov    %eax,%esi
f0106329:	89 e8                	mov    %ebp,%eax
f010632b:	89 f7                	mov    %esi,%edi
f010632d:	f7 f1                	div    %ecx
f010632f:	89 fa                	mov    %edi,%edx
f0106331:	83 c4 1c             	add    $0x1c,%esp
f0106334:	5b                   	pop    %ebx
f0106335:	5e                   	pop    %esi
f0106336:	5f                   	pop    %edi
f0106337:	5d                   	pop    %ebp
f0106338:	c3                   	ret    
f0106339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106340:	89 f9                	mov    %edi,%ecx
f0106342:	b8 20 00 00 00       	mov    $0x20,%eax
f0106347:	29 f8                	sub    %edi,%eax
f0106349:	d3 e2                	shl    %cl,%edx
f010634b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010634f:	89 c1                	mov    %eax,%ecx
f0106351:	89 da                	mov    %ebx,%edx
f0106353:	d3 ea                	shr    %cl,%edx
f0106355:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106359:	09 d1                	or     %edx,%ecx
f010635b:	89 f2                	mov    %esi,%edx
f010635d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106361:	89 f9                	mov    %edi,%ecx
f0106363:	d3 e3                	shl    %cl,%ebx
f0106365:	89 c1                	mov    %eax,%ecx
f0106367:	d3 ea                	shr    %cl,%edx
f0106369:	89 f9                	mov    %edi,%ecx
f010636b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010636f:	89 eb                	mov    %ebp,%ebx
f0106371:	d3 e6                	shl    %cl,%esi
f0106373:	89 c1                	mov    %eax,%ecx
f0106375:	d3 eb                	shr    %cl,%ebx
f0106377:	09 de                	or     %ebx,%esi
f0106379:	89 f0                	mov    %esi,%eax
f010637b:	f7 74 24 08          	divl   0x8(%esp)
f010637f:	89 d6                	mov    %edx,%esi
f0106381:	89 c3                	mov    %eax,%ebx
f0106383:	f7 64 24 0c          	mull   0xc(%esp)
f0106387:	39 d6                	cmp    %edx,%esi
f0106389:	72 15                	jb     f01063a0 <__udivdi3+0x100>
f010638b:	89 f9                	mov    %edi,%ecx
f010638d:	d3 e5                	shl    %cl,%ebp
f010638f:	39 c5                	cmp    %eax,%ebp
f0106391:	73 04                	jae    f0106397 <__udivdi3+0xf7>
f0106393:	39 d6                	cmp    %edx,%esi
f0106395:	74 09                	je     f01063a0 <__udivdi3+0x100>
f0106397:	89 d8                	mov    %ebx,%eax
f0106399:	31 ff                	xor    %edi,%edi
f010639b:	e9 40 ff ff ff       	jmp    f01062e0 <__udivdi3+0x40>
f01063a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01063a3:	31 ff                	xor    %edi,%edi
f01063a5:	e9 36 ff ff ff       	jmp    f01062e0 <__udivdi3+0x40>
f01063aa:	66 90                	xchg   %ax,%ax
f01063ac:	66 90                	xchg   %ax,%ax
f01063ae:	66 90                	xchg   %ax,%ax

f01063b0 <__umoddi3>:
f01063b0:	f3 0f 1e fb          	endbr32 
f01063b4:	55                   	push   %ebp
f01063b5:	57                   	push   %edi
f01063b6:	56                   	push   %esi
f01063b7:	53                   	push   %ebx
f01063b8:	83 ec 1c             	sub    $0x1c,%esp
f01063bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01063bf:	8b 74 24 30          	mov    0x30(%esp),%esi
f01063c3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01063c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01063cb:	85 c0                	test   %eax,%eax
f01063cd:	75 19                	jne    f01063e8 <__umoddi3+0x38>
f01063cf:	39 df                	cmp    %ebx,%edi
f01063d1:	76 5d                	jbe    f0106430 <__umoddi3+0x80>
f01063d3:	89 f0                	mov    %esi,%eax
f01063d5:	89 da                	mov    %ebx,%edx
f01063d7:	f7 f7                	div    %edi
f01063d9:	89 d0                	mov    %edx,%eax
f01063db:	31 d2                	xor    %edx,%edx
f01063dd:	83 c4 1c             	add    $0x1c,%esp
f01063e0:	5b                   	pop    %ebx
f01063e1:	5e                   	pop    %esi
f01063e2:	5f                   	pop    %edi
f01063e3:	5d                   	pop    %ebp
f01063e4:	c3                   	ret    
f01063e5:	8d 76 00             	lea    0x0(%esi),%esi
f01063e8:	89 f2                	mov    %esi,%edx
f01063ea:	39 d8                	cmp    %ebx,%eax
f01063ec:	76 12                	jbe    f0106400 <__umoddi3+0x50>
f01063ee:	89 f0                	mov    %esi,%eax
f01063f0:	89 da                	mov    %ebx,%edx
f01063f2:	83 c4 1c             	add    $0x1c,%esp
f01063f5:	5b                   	pop    %ebx
f01063f6:	5e                   	pop    %esi
f01063f7:	5f                   	pop    %edi
f01063f8:	5d                   	pop    %ebp
f01063f9:	c3                   	ret    
f01063fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106400:	0f bd e8             	bsr    %eax,%ebp
f0106403:	83 f5 1f             	xor    $0x1f,%ebp
f0106406:	75 50                	jne    f0106458 <__umoddi3+0xa8>
f0106408:	39 d8                	cmp    %ebx,%eax
f010640a:	0f 82 e0 00 00 00    	jb     f01064f0 <__umoddi3+0x140>
f0106410:	89 d9                	mov    %ebx,%ecx
f0106412:	39 f7                	cmp    %esi,%edi
f0106414:	0f 86 d6 00 00 00    	jbe    f01064f0 <__umoddi3+0x140>
f010641a:	89 d0                	mov    %edx,%eax
f010641c:	89 ca                	mov    %ecx,%edx
f010641e:	83 c4 1c             	add    $0x1c,%esp
f0106421:	5b                   	pop    %ebx
f0106422:	5e                   	pop    %esi
f0106423:	5f                   	pop    %edi
f0106424:	5d                   	pop    %ebp
f0106425:	c3                   	ret    
f0106426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010642d:	8d 76 00             	lea    0x0(%esi),%esi
f0106430:	89 fd                	mov    %edi,%ebp
f0106432:	85 ff                	test   %edi,%edi
f0106434:	75 0b                	jne    f0106441 <__umoddi3+0x91>
f0106436:	b8 01 00 00 00       	mov    $0x1,%eax
f010643b:	31 d2                	xor    %edx,%edx
f010643d:	f7 f7                	div    %edi
f010643f:	89 c5                	mov    %eax,%ebp
f0106441:	89 d8                	mov    %ebx,%eax
f0106443:	31 d2                	xor    %edx,%edx
f0106445:	f7 f5                	div    %ebp
f0106447:	89 f0                	mov    %esi,%eax
f0106449:	f7 f5                	div    %ebp
f010644b:	89 d0                	mov    %edx,%eax
f010644d:	31 d2                	xor    %edx,%edx
f010644f:	eb 8c                	jmp    f01063dd <__umoddi3+0x2d>
f0106451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106458:	89 e9                	mov    %ebp,%ecx
f010645a:	ba 20 00 00 00       	mov    $0x20,%edx
f010645f:	29 ea                	sub    %ebp,%edx
f0106461:	d3 e0                	shl    %cl,%eax
f0106463:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106467:	89 d1                	mov    %edx,%ecx
f0106469:	89 f8                	mov    %edi,%eax
f010646b:	d3 e8                	shr    %cl,%eax
f010646d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106471:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106475:	8b 54 24 04          	mov    0x4(%esp),%edx
f0106479:	09 c1                	or     %eax,%ecx
f010647b:	89 d8                	mov    %ebx,%eax
f010647d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106481:	89 e9                	mov    %ebp,%ecx
f0106483:	d3 e7                	shl    %cl,%edi
f0106485:	89 d1                	mov    %edx,%ecx
f0106487:	d3 e8                	shr    %cl,%eax
f0106489:	89 e9                	mov    %ebp,%ecx
f010648b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010648f:	d3 e3                	shl    %cl,%ebx
f0106491:	89 c7                	mov    %eax,%edi
f0106493:	89 d1                	mov    %edx,%ecx
f0106495:	89 f0                	mov    %esi,%eax
f0106497:	d3 e8                	shr    %cl,%eax
f0106499:	89 e9                	mov    %ebp,%ecx
f010649b:	89 fa                	mov    %edi,%edx
f010649d:	d3 e6                	shl    %cl,%esi
f010649f:	09 d8                	or     %ebx,%eax
f01064a1:	f7 74 24 08          	divl   0x8(%esp)
f01064a5:	89 d1                	mov    %edx,%ecx
f01064a7:	89 f3                	mov    %esi,%ebx
f01064a9:	f7 64 24 0c          	mull   0xc(%esp)
f01064ad:	89 c6                	mov    %eax,%esi
f01064af:	89 d7                	mov    %edx,%edi
f01064b1:	39 d1                	cmp    %edx,%ecx
f01064b3:	72 06                	jb     f01064bb <__umoddi3+0x10b>
f01064b5:	75 10                	jne    f01064c7 <__umoddi3+0x117>
f01064b7:	39 c3                	cmp    %eax,%ebx
f01064b9:	73 0c                	jae    f01064c7 <__umoddi3+0x117>
f01064bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
f01064bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01064c3:	89 d7                	mov    %edx,%edi
f01064c5:	89 c6                	mov    %eax,%esi
f01064c7:	89 ca                	mov    %ecx,%edx
f01064c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01064ce:	29 f3                	sub    %esi,%ebx
f01064d0:	19 fa                	sbb    %edi,%edx
f01064d2:	89 d0                	mov    %edx,%eax
f01064d4:	d3 e0                	shl    %cl,%eax
f01064d6:	89 e9                	mov    %ebp,%ecx
f01064d8:	d3 eb                	shr    %cl,%ebx
f01064da:	d3 ea                	shr    %cl,%edx
f01064dc:	09 d8                	or     %ebx,%eax
f01064de:	83 c4 1c             	add    $0x1c,%esp
f01064e1:	5b                   	pop    %ebx
f01064e2:	5e                   	pop    %esi
f01064e3:	5f                   	pop    %edi
f01064e4:	5d                   	pop    %ebp
f01064e5:	c3                   	ret    
f01064e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01064ed:	8d 76 00             	lea    0x0(%esi),%esi
f01064f0:	29 fe                	sub    %edi,%esi
f01064f2:	19 c3                	sbb    %eax,%ebx
f01064f4:	89 f2                	mov    %esi,%edx
f01064f6:	89 d9                	mov    %ebx,%ecx
f01064f8:	e9 1d ff ff ff       	jmp    f010641a <__umoddi3+0x6a>

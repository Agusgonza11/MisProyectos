# sched.md

### Utilizar gdb para visualizar el cambio de contexto:
(gdb) x/10x $esp
0xeffffe68:     0x00000000      0xf010058a      0xeffffe80      0xf0100556
0xeffffe78:     0x00000002      0x00000064      0xeffffe90      0xf0100875
0xeffffe88:     0xf010743d      0x00000064
(gdb) x/10x 0xf010058a
0xf010058a <kbd_proc_data>:     0xfb1e0ff3      0x53e58955      0xb804ec83      0x00000064
0xf010059a <kbd_proc_data+16>:  0xfffd6be8      0x0f01a8ff      0x0000f784      0x0f20a800
0xf01005aa <kbd_proc_data+32>:  0x0000f685      0x0060b800
(gdb) p/x *(struct Trapframe*)(0xf010058a)
$1 = {tf_regs = {reg_edi = 0xfb1e0ff3, reg_esi = 0x53e58955, 
    reg_ebp = 0xb804ec83, reg_oesp = 0x64, reg_ebx = 0xfffd6be8, 
    reg_edx = 0xf01a8ff, reg_ecx = 0xf784, reg_eax = 0xf20a800}, tf_es = 0xf685, 
  tf_padding1 = 0x0, tf_ds = 0xb800, tf_padding2 = 0x60, tf_trapno = 0x51e80000, 
  tf_err = 0x3cfffffd, tf_eip = 0x846174e0, tf_cs = 0x78c0, tf_padding3 = 0x8b70, 
  tf_eflags = 0x24800015, tf_esp = 0x40c2f6f0, tf_ss = 0xc74, 
  tf_padding4 = 0xc883}  
  
(gdb) p $pc
$1 = (void (*)()) 0xf010035a <serial_proc_data+20>
(gdb) add-symbol-file obj/user/hello 0xf010035a
add symbol table from file "obj/user/hello" at
        .text_addr = 0xf010035a
(y or n) y
Reading symbols from obj/user/hello...
(gdb) p $pc
$2 = (void (*)()) 0xf010035a <serial_proc_data+20>  
  
  
### Funcionamiento Scheduling por prioridades implementado en sched_yield:
Cuando se llame a sched_yield, dependiendo la politica elegida en tiempo de compilacion se decidira
si utilizar el metodo round robin o la politica por prioridades implementada para la parte 3.  
Esta funciona basicamente seteandole una prioridad a cada proceso, que a priori sera la misma que el id.  
Esto significa que los ultimos procesos en crearse seran los de mayor prioridad, ya entrando en el algoritmo lo primero
que se hace es tomar el primer proceso como maxima prioridad, luego basicamente se van recorriendo todos los procesos
y revisando si tiene mayor prioridad que ese primero que se eligio, si no es asi, simplemente sigue recorriendo, si tiene mayor prioridad,
toma ese nuevo proceso como el mas siguiente a ejecutar.  
Finalmente sale del ciclo y accede a ese proceso que nos guardamos y lo ejecuta.  
Como recorre todos los procesos una vez la complejidad algoritmica seria O(n).  
Las syscalls sys_get_priority y sys_reduce_priority simplemente devuelven la prioridad actual y la reducen respectivamente.  
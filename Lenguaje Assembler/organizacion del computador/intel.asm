global	main
extern	gets
extern	sscanf
extern	fopen
extern	fread
extern	fclose


;padron par, nro 106086

section		.data

	archivo		db	"vacunacion.dat",0
	mode		db	"rb",0
	
	msjProvincia	db	"Ingrese el codigo de la provincia: ",0
	
	msjCantidad		db	"Ingrese la cantidad de habitantes de la provincia: ",0
	
	msjErrorApert	db	"Hubo un error en la apertura del archivo",0

	registro	times	0	db	''
		dni		times	4	db	0
		codigo				db 	0
		edad				db	0
		eof		times	2	db	' '


	matriz		times	96	dd	0
	
	contVacunados	dd	0
	
	formato		db	'%i',0
	
	msjFalse	db	"La cantidad de vacunados es menor a la del %50 de la poblacion",0	
	msjTrue		db	"La cantidad de vacunados es mayor a la del %50 de la poblacion",0	

section		.bss

	archHandle		resq	1

	regValido		resb	1	;'S' Valido, 'N' Invalido
	
	columna			resb	1
	
	provincia		resd	1
	cantidad		resd	1

	provIng			resb	5
	cantIng			resb	5
	
section	.text

main

	call	abrirArch
	
	cmp		qword[archHandle],0	;Si hubo un error en la apertura
	jle		errorApert
	
	call	leerArch

	call	cantVacunados

finProg:
	ret
	
	
;---------------------------------------------------
;Rutinas internas-----------------------------------
;---------------------------------------------------

abrirArch:
	mov		rcx,archivo
	mov		rdx,mode
	call	fopen		
	mov		qword[archHandle],rax	
	
	ret
	
	
errorApert:
	mov		rcx,msjErrorApert
	call	puts
	jmp		finProg
	
	
leerArch:
	
leerReg:
	mov		rcx,registro
	mov		rdx,8			
	mov		r8,1
	mov		r9,qword[archHandle]
	call	fread
	
	cmp		rax,0			;si esto da 0, significa que llego al final del archivo
	jle		finReg
	
	call	VALREG	
	cmp		byte[regValido],'N'	;Si el registro es invalido, leo el proximo registro
	je		leerReg
	
	call	sumarMatriz
	
	jmp		leerReg
	
finReg:
	mov		rcx,qword[archHandle]
	call	fclose
	ret
	
	
VALREG:
	mov		byte[regValido],'N'
	
	cmp		byte[codigo],1
	jl		finValreg
	cmp		byte[codigo],24		;aca chequeo que el codigo de provincia este en el rango de 1:24
	jg		finValreg
	
	cmp		byte[edad],35
	jl		finValreg			;aca chequeo que nadie tiene una edad menor a 35
	
	mov		byte[regValido],'S'	;Si llego hasta aca, significa que todo es valido
	
finValreg:
	ret
	
	
sumarMatriz:
	;Primero voy a chequear a que columna debo ir segun el rango de edad
	call	calcularCol

	mov		rax,0
	mov		rbx,0		;lo seteo en 0 en caso de cualquier error
	
	sub		byte[columna],1
	mov		al,byte[columna]
	
	mov		bl,4		;cada elemento de la matriz es de 4 bytes
	mul		bl
	
	mov		rdx,rax		;me guardo el desplazamiento de columnas en rdx
	
	sub		byte[codigo],1
	mov		al,byte[codigo]
	
	mov		bl,16		;4 columnas x 4 bytes = 16
	mul		bl
	
	add		rax,rdx		;el desplazamiento total queda en rax
	
	mov		ebx,dword[matriz + rax]
	inc		ebx
	mov		dword[matriz + rax],ebx

	ret
	
	
calcularCol:
	;aca voy determinando a que columna ira cada persona
	cmp		byte[edad],39
	jle		col1
	
	cmp		byte[edad],49
	jle		col2
	
	cmp		byte[edad],59
	jle		col3
	
	cmp		byte[edad],60
	jge		col4
	
col1:
	mov		byte[columna],1
	jmp		finCalculo
col2:
	mov		byte[columna],2
	jmp		finCalculo
col3:
	mov		byte[columna],3
	jmp		finCalculo
col4:
	mov		byte[columna],4
	jmp		finCalculo

finCalculo:
	ret	
	
	
cantVacunados:
	mov		dword[contVacunados],0	

ingProvincia:
	mov		rcx,msjProvincia
	call	puts
	
	mov		rcx,provIng
	call	gets
	
	mov		rcx,provIng
	mov		rdx,formato
	mov		r8,provincia
	call	sscanf
	cmp		rax,1
	jl		ingProvincia
	
ingCantidad:
	mov		rcx,msjCantidad
	call	puts
	
	mov		rcx,cantIng
	call	gets
	
	mov		rcx,cantIng
	mov		rdx,formato
	mov		r8,cantidad
	call	sscanf
	cmp		rax,1
	jl		ingCantidad
	
	;calculo el desplazamiento 
	sub		dword[provincia],1
	mov		rax,0
	mov		eax,dword[provincia]
	mov		bl,16
	mov		rdi,rax				;paso al rdi el desplazamiento a la fila, o sea, la provincia
	
	
	;aca empiezo a sumar
	mov		rcx,4	;cantidad de columnas a recorrer
	mov		rbx,0
next:
	push	rcx
	
	mov		ebx,dword[matriz + rdi]	;recupero el dato de la matriz en esa posicion
	
	add		dword[contVacunados],ebx
	
	add		rdi,4		;avanzo al proximo elemento de la fila
	
	pop		rcx
	
	loop	next
	
	
	;aca digo que si la cantidad de habitantes es menos a
	;la de vacunados (cosa que no tendria sentido pero no
	;sabia como considerarlo) entonces es true
	mov		rbx,0						
	mov		ebx,dword[cantidad]
	cmp		ebx,dword[contVacunados]		
	jle		vacunadosTrue			
	
	;y aca hago el chequeo regular 
	mov		rbx,0
	mov		ebx,dword[cantidad]
	div		ebx,2
	mov		ebx,eax
	cmp		ebx,dword[contVacunados]	;si la division a la mitad de la cantidad de habitantes
	jle		vacunadosTrue				;es menor a la de vacunados, entonces es verdadero

vacunadosFalse:
	mov		rcx,msjFalse
	call	puts
	jmp		finCant											
		
	
vacunadosTrue:
	mov		rcx,msjTrue
	call	puts

finCant:
	ret
	
	
	
	
	
	
	
	
	
	
	
	
	
	

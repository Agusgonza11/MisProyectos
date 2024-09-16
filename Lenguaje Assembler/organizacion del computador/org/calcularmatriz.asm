; Una matriz cuyos elementos son enteros de 2 bytes(word) solicitar por teclado numero de fila y
; columna y realizar la sumatoria de los elementos de la fila elegida a partir de la columna
; y mostrar el resultado por pantalla. Validar que los datos son validos

global	main
extern	printf
extern	puts
extern	gets
extern	sscanf

section	.data
	msjIngFilCol	db		"Ingrese fila (1 a 5) y columna (1 a 5): ",0
	msjInputFilCol	db		"%hi  %hi",0
	
	matriz		dw	1,1,1,1,1
				dw	2,2,2,2,2
				dw	3,3,3,3,3
				dw	4,4,4,4,4
				dw	5,5,5,5,5
				
	msjSum			db		"La sumatoria es: %i",10,0
	
section	.bss
	fila		resw	1
	columna		resw	1
	inputValido	resb	1 ; S valido N invalido
	sumatoria	resd	1
	desplaz		resw	1
	inputFilCol	resb	50

section	.text
main:
	sub rsp,8

pedirDatos:
	;Pido la fila y la columna
	mov		rdi,msjIngFilCol
	call	puts
	
	;Recibo la fila y la columna
	mov		rdi,inputFilCol
	call	gets
	
	call	validarFyC
	
	cmp		byte[inputValido],'N'
	je		pedirDatos
	
	call	calcDesplazar
	
	call	calcSumatoria

	mov		rdi,msjSum
	mov		edi,dword[sumatoria] ;dword tiene 32 bits por eso ebx
	call	printf

eof:
    add     rsp,8
	ret	
	
	
validarFyC:
	mov		byte[inputValido],'N'
	
	mov		rdi,inputFilCol
	mov		rsi,msjInputFilCol ;"%hi  %hi" ingresa el primero en fila
	mov		rdx,fila           ; y el segundo en columna
	mov		rcx,columna
	call	sscanf
	
	;verifica que se haya ingresado bien
	cmp		rax,2
	jl		invalido
	
	;verifico que esten en el rango de 1 y 5
	cmp		word[fila],1
	jl		invalido
	cmp		word[fila],5
	jg		invalido
	
	cmp		word[columna],1
	jl		invalido
	cmp		word[columna],5
	jg 		invalido
	
	mov		byte[inputValido],'S'
	
invalido:	
	ret

	
calcDesplazar:
	mov		bx,word[fila]
	dec		bx
	imul	bx,bx,10 ; 10 longfila= longElemento * cantidad de columnas
	
	mov		word[desplaz],bx
	
	mov		bx,word[columna]
	dec		bx
	imul	bx,bx,2
	
	add		word[desplaz],bx
	
	ret
	
calcSumatoria:
	mov		dword[sumatoria],0 ;la inicializo en 0
	
	mov		rdi,0
	mov		di,6
	sub		di,word[columna]

	mov		rsi,0
	mov		si,word[desplaz]
sumarProx:
	mov		rax,0
	mov		ax,word[matriz + rsi]
	
	add		dword[sumatoria],eax
	
	add		rsi,2
	
	loop	sumarProx ;la instruccion loop resta de rdi y 
				  	  ;si es igaul a 0 corta
	
	ret
	
	
	
	
	
	
	
	
	
	
	

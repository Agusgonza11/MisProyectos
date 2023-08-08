global	main
extern  puts
extern  printf
extern	gets
extern 	sscanf

section	.data
	msj			db		"Ingrese el año de nacimiento: ",0
	msjFinal	db		"Tu edad es: %hi",10,0
	
	
	bufferFecha	dq		0
	
	fecha		times	0	db	''
		dia		times	2	db	' '
		barra1	times	1	db	' '
		mes		times	2	db	' '
		barra2	times	1	db	' '
		anio	times	4	db	' '
		
	anioFormat	db		'%hi',0
	anioStr		db		'****',0
	anioNum		dw		0
	


section	.bss
	anioValido	resb	1
	edad		resw	1
	plusRsp		resq	1 

section	.text
main:

pedirFecha:
	mov		rdi,msj
	call	puts
	
	mov		rdi,fecha
	call	gets
	
	call	validarAnio
	cmp		byte[anioValido],'N'
	je		pedirFecha
	
	

	call	calcularEdad
	mov		rdi,msjFinal
	mov		rsi,[edad]
	call	printf
	ret
	
	
validarAnio:
	mov		byte[anioValido],'N'
	
	mov		rcx,4
	mov		rbx,0
next:
	cmp		byte[anio+rbx],'0'
	jl		anioError
	cmp		byte[anio+rbx],'9'
	jg		anioError
	inc		rbx
	loop	next
	
	mov		rcx,4
	mov		rsi,anio
	mov		rdi,anioStr
	rep	movsb
	
	mov		rdi,anioStr
	mov		rsi,anioFormat
	mov		rdx,anioNum
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

	mov		byte[anioValido],'S'
	
anioError:
	ret
	
	
calcularEdad:
	mov		word[edad],0
	
	mov		di,2020
	sub		di,word[anioNum]
	mov		word[edad],di
	
	ret
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

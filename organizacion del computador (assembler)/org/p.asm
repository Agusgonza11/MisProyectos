global main
extern puts
extern gets
extern sscanf
extern printf


section    	.data
	msjIngObj		db	"Nombre del objeto...[max 8 caracteres]: ",0

	obj		times	20	dq ' ' 


	msj		db	"%s ",10,13,0
	

	

section		.bss

	plusRsp		resq	1 

	nombre		resq	1
	nombre2		resq	1
	

section    	.text


main:	

	call	agregar
	
	call	imprimir


	ret
	
	
agregar:


	mov		rdi,msjIngObj
	call	puts
	mov		rdi,nombre
	call	gets
	
	
	mov		rcx,8
	lea		rsi,[nombre]
	lea		rdi,[obj + 0]
	rep	movsb
	
	mov		rdi,msjIngObj
	call	puts
	mov		rdi,nombre
	call	gets
	

	mov		rcx,8
	lea		rsi,[nombre]
	lea		rdi,[obj + 8]
	rep	movsb
	
	



	ret
	
	
	
	
	
	
	
imprimir:


	lea		rdx,[obj + 0]
	
	mov		rdi,msj
	mov		rsi,rdx
	sub		rax,rax
	call	printf
	

	lea		rdx,[obj + 8]
	
	mov		rdi,msj
	mov		rsi,rdx
	sub		rax,rax
	call	printf
	
	

	
	ret
	
	
	
	
checkAlign:
	push rax
	push rbx
;	push rcx
	push rdx
	push rdi

	mov   qword[plusRsp],0
	mov		rdx,0

	mov		rax,rsp		
	add     rax,8		;para sumar lo q restó la CALL 
	add		rax,32	;para sumar lo que restaron las PUSH
	
	mov		rbx,16
	idiv	rbx			;rdx:rax / 16   resto queda en RDX

	cmp     rdx,0		;Resto = 0?
	je		finCheckAlign
;mov rdi,msj
;call puts
	mov   qword[plusRsp],8
finCheckAlign:
	pop rdi
	pop rdx
;	pop rcx
	pop rbx
	pop rax
	ret

	
	
	
	
	
	
	
	
	
	

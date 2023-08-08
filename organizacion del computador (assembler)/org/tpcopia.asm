global main
extern puts
extern gets
extern sscanf
extern printf


section    	.data
	msjCantObj		db	"Cuantos objetos va a enviar..[0-20]: ",0
	msjIngObj		db	"Nombre del objeto...[max 20 caracteres]: ",0
	msjIngDestino	db	"Ingrese el destino del objeto: ",0
	msjPesoObj		db	"Ingrese el peso del objeto: ",0
	
	msj			db	"%s",10,13,0
	msjj			db	"% hi",10,13,0
	
	msjErrorDestino	db	"El destino ingresado es incorrecto",0
	
	vectorDestinos	db	'Mar del Plata  Mendoza        Salta          '  
	
	objMarpla		times	25	dq ' ' ;los objetos a este destino
	pesosMarpla		times	20	dw ' ' ;los pesos de esos objetos
	cantMar			dq	1			   ;la cantidad de objetos
	
	objMendoza		times	25	dq ' '
	pesosMendoza	times	20	dw ' '
	cantMend		dq	1
	
	objSalta		times	25	dq ' '
	pesosSalta		times	20	dw ' '
	cantSalt		dq	1
	
	pesoStr			db	'**',0
	pesoFormat		db	'%hi',0
	pesoIng			dw	0
	
	cantStr			db	'**',0
	cantFormat		db	'%hi',0
	
	
	sumatoriaPesos	dw	0
	pesoActual		dw	0
	
	marplaImp		db	"|| Mar del plata | ",0
	mendozaImp		db	"|| Mendoza | ",0
	saltaImp		db	"|| Salta | ",0
	
	
	msjImpObjeto	db	" %s",0
	msjImpPeso		db	"(p%hi)  ",0
	
	saltoLinea		db	" |",10,13,0
	
	
section		.bss
	Cantobj		resb	10
	destIng		resb	30
	PesoObj		resw	1
	
	cantTotal	resw	1
	

	validoDest	resb	1
	validoCant	resb	1
	validoPeso	resb	1
	
	plusRsp		resq	1 
	nombreObj	resq	1
	
section    	.text


main:
    sub rsp,8
pedirCant:
	;Pide la cantidad de objetos
	mov		rdi,msjCantObj
	call	puts

	mov		rdi,Cantobj
	call	gets
	
	call	ValidarCantidad ;validar que esta entre 0 y 20
	cmp		byte[validoCant],'N'
	je		pedirCant
	
pedirDest:
	;Ingresar el destino del objeto
	mov		rdi,msjIngDestino
	call	puts
	
	;Destino ingresado
	mov		rdi,destIng
	call	gets
	
	call	ValidarDestino 
	cmp		byte[validoDest],'N'
	je		pedirDest
		
pedirObj:
	;Pide el nombre del objeto
	mov		rdi,msjIngObj
	call	puts
	
	mov		rdi,nombreObj
	call	gets
	
pedirPeso:
	;Pide el peso del objeto
	mov		rdi,msjPesoObj
	call	puts
	
	mov		rdi,PesoObj
	call	gets
	
	call	ValidarPeso 
	cmp		byte[validoPeso],'N'
	je		pedirPeso
	
guardaObj:
	;Veo adonde tengo que agregar el objeto
	cmp		dword[destIng],'Mar '
	je		agregarMarpla
	
	cmp		dword[destIng],'Salt'
	je		agregarSalta
	
	cmp		dword[destIng],'Mend'
	je		agregarMendoza


decrementCant:	
	;reduzco en uno la cantidad y vuelvo a pedir un nuevo objeto
	dec		word[cantTotal]
	cmp		word[cantTotal],0
	je		imprimirPaq
	jmp		pedirDest
	
imprimirPaq:
	call	ImprimirPaquetes
	
endprog:
    add     rsp,8
	ret
	
	
;---------------------------------------------------------
ValidarCantidad:
	mov		byte[validoCant],'N'
	

	mov		rdi,Cantobj
	mov		rsi,cantFormat
	mov		rdx,cantTotal
	call	checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]
		
	cmp		word[cantTotal],1
	jl		cantFin
	cmp		word[cantTotal],20
	jg		cantFin
	
	mov		byte[validoCant],'S'
cantFin:
	ret
;--------------------------------------
;Validar el destino ingresado
ValidarDestino:
	mov		byte[validoDest],'S'
	
	mov		rbx,0
	mov		rcx,3
	
SiguienteDest:
	push	rcx
	mov		rcx,15
	lea		rsi,[destIng]
	lea		rdi,[vectorDestinos+rbx]
	repe cmpsb	
	
	pop		rcx
	je		destinOK
	add		rbx,15
	loop	SiguienteDest
	
	mov		rdi,msjErrorDestino
	call	puts
	
	mov		byte[validoDest],'N'
destinOK:
	ret
;--------------------------------------
;Valida el peso del objeto
ValidarPeso:
	mov		byte[validoPeso],'N'
	
	mov		rdi,PesoObj
	mov		rsi,pesoFormat
	mov		rdx,pesoIng
	call	checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]
	
	cmp		word[pesoIng],1
	jl		pesoFin
	cmp		word[pesoIng],17
	jg		pesoFin
	
	mov		byte[validoPeso],'S'
pesoFin:
	ret	


;--------------------------------------
agregarMarpla:
	;Calculo el desplazamiento para el vector objetos
	mov		rdi,qword[cantMar]
	sub		rdi,1
	imul	rdi,rdi,8
	;Guardo el nombre del objeto en el vector
	mov		rsi,0
	mov		rsi,rdi
	mov		qword[objMarpla + rsi],nombreObj
	
	mov		rbx,rsi
	mov		rdi,msj
	mov		rsi,[objMarpla + rbx]
	sub		rax,rax
	call	printf


	
	mov		rbx,0
	mov		rdi,msj
	mov		rsi,[objMarpla + rbx]
	sub		rax,rax
	call	printf
	

	
	
	
	;Aumento la cantidad de objetos en ese destino
	mov		rdi,qword[cantMar]
	inc		rdi
	mov		qword[cantMar],rdi
	

	jmp		decrementCant
;---------------------------------------
agregarMendoza:
	;Calculo el desplazamiento para el vector objetos
	mov		rdi,[cantMend]
	sub		rdi,1
	imul	rdi,rdi,10
	;Guardo el nombre del objeto en el vector
	mov		rsi,0
	mov		rsi,rdi
	mov		qword[objMendoza + rsi],nombreObj
	
	;Calculo el desplazamiento para el vector pesos
	mov		rdi,[cantMend]
	sub		rdi,1
	imul	rdi,rdi,2
	;Guardo el peso del objeto en el vector
	mov		rsi,0
	mov		rsi,rdi
	mov		qword[pesosMendoza + rsi],PesoObj
	
	;Aumento la cantidad de objetos en ese destino
	mov		rdi,[cantMend]
	inc		rdi
	mov		[cantMend],rdi
	jmp		decrementCant
;---------------------------------------
agregarSalta:
	;Calculo el desplazamiento para el vector objetos
	mov		rdi,[cantSalt]
	sub		rdi,1
	imul	rdi,rdi,10
	;Guardo el nombre del objeto en el vector
	mov		rsi,0
	mov		rsi,rdi
	mov		qword[objSalta + rsi],nombreObj

	;Calculo el desplazamiento para el vector pesos
	mov		rdi,[cantSalt]
	sub		rdi,1
	imul	rdi,rdi,2
	;Guardo el peso del objeto en el vector
	mov		rsi,0
	mov		rsi,rdi
	mov		qword[pesosSalta + rsi],PesoObj

	;Aumento la cantidad de objetos en ese destino
	mov		rdi,[cantSalt]
	inc		rdi
	mov		[cantSalt],rdi
	jmp		decrementCant
	
	
;---------------------------------------
ImprimirPaquetes:

	cmp		qword[cantMar],1 ;si hay objetos a ese destino
	jg		impMarpla        ;imprimo los paquetes a ese destino
	

finImpresion:
	ret
;---------------------------------------

;---------------------------------------
impMarpla:

	mov		rdi,[cantMar]
	sub		rdi,1
	mov		[cantMar],rdi
	jmp		encabezadoMar

impCabezadoMar:
	cmp		qword[cantMar],1 
	jle		finImpresion
encabezadoMar:
	mov		word[sumatoriaPesos],0
	mov		rdi,marplaImp ;imprimo el encabezado del destino
	sub		rax,rax
	call	printf

impPesosMar:
	;Calculo el desplazamiento para el vector objetos
	mov		rdi,qword[cantMar]
	sub		rdi,1
	imul	rdi,rdi,8
	mov		rbx,0
	mov		rbx,rdi
	
	mov		rdi,msjImpObjeto 
	mov		rsi,qword[objMarpla + rbx]      ;aca imprimo el objeto
	sub		rax,rax
	call	printf
	
	mov		rdi,msjj
	mov		rsi,rbx
	sub		rax,rax
	call	printf

	cmp		qword[cantMar],1   ;si se terminaron, termino
	jle		SaltoLineaMar

	mov		rdi,qword[cantMar]
	sub		rdi,1
	mov		qword[cantMar],rdi      ;reduzco la cantidad de objetos de ese destino

	jmp		impPesosMar

SaltoLineaMar:

	mov		rdi,saltoLinea ;imprimo el salto de linea
	sub		rax,rax
	call	printf
	jmp		impCabezadoMar

;---------------------------------------










;---------------------------------------
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



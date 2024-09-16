global main
extern puts
extern gets
extern sscanf
extern printf


section    	.data
	msjCantObj		db	"Cuantos objetos va a enviar..[1-20]: ",0
	msjIngObj		db	"Nombre del objeto...[max 8 caracteres]: ",0
	msjIngDestino	db	"Ingrese el destino del objeto: ",0
	msjPesoObj		db	"Ingrese el peso del objeto: ",0
	msjAgregado		db	"Se agrego el objeto exitosamente",0
	
	msjErrorDestino	db	"El destino ingresado es incorrecto",0
	msjErrorPeso	db	"Ingrese un peso valido (1/17)",0
	msjErrorCant	db	"Ingrese una cantidad de objetos valida (1/20)",0
	
	vectorDestinos	db	'Mar del Plata  Mendoza        Salta          '  
	
	objMarpla		times	20	dq ' ' ;los objetos a este destino
	pesosMarpla		times	20	dw 0   ;los pesos de esos objetos
	cantMar			dq	1			   ;la cantidad de objetos
	
	objMendoza		times	20	dq ' '
	pesosMendoza	times	20	dw 0
	cantMend		dq	1
	
	objSalta		times	20	dq ' '
	pesosSalta		times	20	dw 0
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
	
	saltoLinea		db	" ||",10,13,0
	

section		.bss
	Cantobj		resb	10
	destIng		resb	30
	nombreObj	resq	1
	PesoObj		resw	5
	
	cantTotal	resw	1
	

	validoDest	resb	1
	validoCant	resb	1
	validoPeso	resb	1
	
	plusRsp		resq	1 
	
	
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
	
	mov		byte[destIng],0
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

	mov		rdi,msjAgregado
	call	puts
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
	jmp		cantFinValido
cantFin:
	mov		rdi,msjErrorCant
	call	puts
cantFinValido:
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
	jmp		pesoFinValido
pesoFin:
	mov		rdi,msjErrorPeso
	call	puts
pesoFinValido:
	ret	


;--------------------------------------
agregarMarpla:
	;Calculo el desplazamiento para el vector objetos
	mov		rdi,qword[cantMar]
	sub		rdi,1
	imul	rdi,rdi,8
	;Guardo el nombre del objeto en el vector
	mov		rdx,0
	mov		rdx,rdi
	
	mov		rcx,8
	lea		rsi,[nombreObj]
	lea		rdi,[objMarpla + rdx]
	rep	movsb
	
	;Calculo el desplazamiento para el vector pesos
	mov		rdi,qword[cantMar]
	sub		rdi,1
	imul	rdi,rdi,2
	;Guardo el peso del objeto en el vector
	mov		rsi,0
	mov		rsi,rdi
	mov		dx,word[pesosMarpla + rsi]
	add		dx,word[pesoIng]
	mov		word[pesosMarpla + rsi],dx
	
	;Aumento la cantidad de objetos en ese destino
	mov		rdi,qword[cantMar]
	inc		rdi
	mov		qword[cantMar],rdi	
	jmp		decrementCant
;---------------------------------------
agregarMendoza:
	;Calculo el desplazamiento para el vector objetos
	mov		rdi,qword[cantMend]
	sub		rdi,1
	imul	rdi,rdi,8
	;Guardo el nombre del objeto en el vector
	mov		rdx,0
	mov		rdx,rdi
	
	mov		rcx,8
	lea		rsi,[nombreObj]
	lea		rdi,[objMendoza + rdx]
	rep	movsb
	
	;Calculo el desplazamiento para el vector pesos
	mov		rdi,qword[cantMend]
	sub		rdi,1
	imul	rdi,rdi,2
	;Guardo el peso del objeto en el vector
	mov		rsi,0
	mov		rsi,rdi
	mov		dx,word[pesosMendoza + rsi]
	add		dx,word[pesoIng]
	mov		word[pesosMendoza + rsi],dx
	
	;Aumento la cantidad de objetos en ese destino
	mov		rdi,qword[cantMend]
	inc		rdi
	mov		qword[cantMend],rdi	
	jmp		decrementCant
;---------------------------------------
agregarSalta:
	;Calculo el desplazamiento para el vector objetos
	mov		rdi,qword[cantSalt]
	sub		rdi,1
	imul	rdi,rdi,8
	;Guardo el nombre del objeto en el vector
	mov		rdx,0
	mov		rdx,rdi
	
	mov		rcx,8
	lea		rsi,[nombreObj]
	lea		rdi,[objSalta + rdx]
	rep	movsb
	
	;Calculo el desplazamiento para el vector pesos
	mov		rdi,qword[cantSalt]
	sub		rdi,1
	imul	rdi,rdi,2
	;Guardo el peso del objeto en el vector
	mov		rsi,0
	mov		rsi,rdi
	mov		dx,word[pesosSalta + rsi]
	add		dx,word[pesoIng]
	mov		word[pesosSalta + rsi],dx
	
	;Aumento la cantidad de objetos en ese destino
	mov		rdi,qword[cantSalt]
	inc		rdi
	mov		qword[cantSalt],rdi	
	jmp		decrementCant
	
;---------------------------------------
ImprimirPaquetes:

	cmp		qword[cantMar],1 ;si hay objetos a ese destino
	jg		impMarpla        ;imprimo los paquetes a ese destino
	
sigImpresion:
	cmp		qword[cantMend],1 
	jg		impMend 
sigImpresion2:
	cmp		qword[cantSalt],1 
	jg		impSalt


finImpresion:
	ret
;---------------------------------------
;---------------------------------------
impMarpla:

	mov		rdi,qword[cantMar]
	sub		rdi,1
	mov		qword[cantMar],rdi
	jmp		encabezadoMar

impCabezadoMar:
	cmp		qword[cantMar],1 
	jle		sigImpresion
encabezadoMar:
	mov		word[sumatoriaPesos],0
	mov		rdi,marplaImp ;imprimo el encabezado del destino
	sub		rax,rax
	call	printf

impPesosMar:
	;Calculo el desplazamiento para el vector pesos
	mov		rdi,qword[cantMar]
	sub		rdi,1
	imul	rdi,rdi,2
	
	mov		rbx,rdi
	mov		word[pesoActual],0

	mov		dx,word[pesosMarpla + rbx]
	add		word[pesoActual],dx		

	mov		di,word[pesoActual]
	add		word[sumatoriaPesos],di   ;sumo el peso a la sumatoria
	
	cmp		word[sumatoriaPesos],17 ;si sobrepase los 17kg, reseteo
	jg		SaltoLineaMar2
	
	;Calculo el desplazamiento para el vector objetos
	mov		rdi,qword[cantMar]
	sub		rdi,1
	imul	rdi,rdi,8
	mov		rbx,0
	mov		rbx,rdi
	
	lea		rdx,[objMarpla + rbx] 
	mov		rdi,msjImpObjeto 
	mov		rsi,rdx			     ;aca imprimo el objeto
	sub		rax,rax
	call	printf

	mov		rdi,msjImpPeso
	mov		rsi,[pesoActual]      ;aca imprimo el peso
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

SaltoLineaMar2:

	mov		rdi,saltoLinea ;imprimo el salto de linea
	sub		rax,rax
	call	printf
	jmp		encabezadoMar

;---------------------------------------
impMend:

	mov		rdi,qword[cantMend]
	sub		rdi,1
	mov		qword[cantMend],rdi
	jmp		encabezadoMend

impCabezadoMend:
	cmp		qword[cantMend],1 
	jle		sigImpresion2
encabezadoMend:
	mov		word[sumatoriaPesos],0
	mov		rdi,mendozaImp ;imprimo el encabezado del destino
	sub		rax,rax
	call	printf

impPesosMend:
	;Calculo el desplazamiento para el vector pesos
	mov		rdi,qword[cantMend]
	sub		rdi,1
	imul	rdi,rdi,2
	
	mov		rbx,rdi
	mov		word[pesoActual],0

	mov		dx,word[pesosMendoza + rbx]
	add		word[pesoActual],dx		

	mov		di,word[pesoActual]
	add		word[sumatoriaPesos],di   ;sumo el peso a la sumatoria
	
	cmp		word[sumatoriaPesos],17 ;si sobrepase los 17kg, reseteo
	jg		SaltoLineaMend2
	
	;Calculo el desplazamiento para el vector objetos
	mov		rdi,qword[cantMend]
	sub		rdi,1
	imul	rdi,rdi,8
	mov		rbx,0
	mov		rbx,rdi
	
	lea		rdx,[objMendoza + rbx] 
	mov		rdi,msjImpObjeto 
	mov		rsi,rdx			     ;aca imprimo el objeto
	sub		rax,rax
	call	printf

	mov		rdi,msjImpPeso
	mov		rsi,[pesoActual]      ;aca imprimo el peso
	sub		rax,rax
	call	printf

	cmp		qword[cantMend],1   ;si se terminaron, termino
	jle		SaltoLineaMend

	mov		rdi,qword[cantMend]
	sub		rdi,1
	mov		qword[cantMend],rdi      ;reduzco la cantidad de objetos de ese destino

	jmp		impPesosMend

SaltoLineaMend:

	mov		rdi,saltoLinea ;imprimo el salto de linea
	sub		rax,rax
	call	printf
	jmp		impCabezadoMend

SaltoLineaMend2:

	mov		rdi,saltoLinea ;imprimo el salto de linea
	sub		rax,rax
	call	printf
	jmp		encabezadoMend
	
;---------------------------------------
impSalt:

	mov		rdi,qword[cantSalt]
	sub		rdi,1
	mov		qword[cantSalt],rdi
	jmp		encabezadoSalt

impCabezadoSalt:
	cmp		qword[cantSalt],1 
	jle		sigImpresion2
encabezadoSalt:
	mov		word[sumatoriaPesos],0
	mov		rdi,saltaImp ;imprimo el encabezado del destino
	sub		rax,rax
	call	printf

impPesosSalt:
	;Calculo el desplazamiento para el vector pesos
	mov		rdi,qword[cantSalt]
	sub		rdi,1
	imul	rdi,rdi,2
	
	mov		rbx,rdi
	mov		word[pesoActual],0

	mov		dx,word[pesosSalta + rbx]
	add		word[pesoActual],dx		

	mov		di,word[pesoActual]
	add		word[sumatoriaPesos],di   ;sumo el peso a la sumatoria
	
	cmp		word[sumatoriaPesos],17 ;si sobrepase los 17kg, reseteo
	jg		SaltoLineaSalt2
	
	;Calculo el desplazamiento para el vector objetos
	mov		rdi,qword[cantSalt]
	sub		rdi,1
	imul	rdi,rdi,8
	mov		rbx,0
	mov		rbx,rdi
	
	lea		rdx,[objSalta + rbx] 
	mov		rdi,msjImpObjeto 
	mov		rsi,rdx			     ;aca imprimo el objeto
	sub		rax,rax
	call	printf

	mov		rdi,msjImpPeso
	mov		rsi,[pesoActual]      ;aca imprimo el peso
	sub		rax,rax
	call	printf

	cmp		qword[cantSalt],1   ;si se terminaron, termino
	jle		SaltoLineaSalt

	mov		rdi,qword[cantSalt]
	sub		rdi,1
	mov		qword[cantSalt],rdi      ;reduzco la cantidad de objetos de ese destino

	jmp		impPesosSalt

SaltoLineaSalt:

	mov		rdi,saltoLinea ;imprimo el salto de linea
	sub		rax,rax
	call	printf
	jmp		impCabezadoSalt

SaltoLineaSalt2:

	mov		rdi,saltoLinea ;imprimo el salto de linea
	sub		rax,rax
	call	printf
	jmp		encabezadoSalt
;--------------------------------------






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



; Dado un archivo en formato texto que contiene informacion sobre autos llamado listado.txt
; donde cada linea del archivo representa un registro de informacion de un auto con los campos: 
;   marca:							10 caracteres
;   año de fabricacion:				4 caracteres
;   patente:						7 caracteres
;	precio							7 caracteres
; Se pide codificar un programa en assembler intel que lea cada registro del archivo listado y guarde
; en un nuevo archivo en formato binario llamado seleccionados.dat las patentes y el precio de aquellos autos
; cuyo año de fabricación esté entre 2010 y 2019 inclusive
; Como los datos del archivo pueden ser incorrectos, se deberan validar mediante una rutina interna.
; Se deberá validar Marca (que sea Fiat, Ford, Chevrolet o Peugeot), año (que sea un valor
; numérico y que cumpla la condicion indicada del rango) y precio que sea un valor numerico.


global	main
extern  puts
extern  printf
extern  fopen
extern  fclose
extern  fgets
extern  sscanf
extern  fwrite

section	.data
	fileListado		db	"listado.txt",0
	modeListado		db	"r",0		;read | texto | abrir o error
	msjErrOpenLis	db	"Error en apertura de archivo Listado",0
    handleListado	dq	0

	fileSeleccion	db	"seleccion.dat",0
	modeSeleccion	db	"wb",0
	msjErrOpenSel   db	"Error en apertura de archivo seleccion",0
	handleSeleccion	dq	0

	regListado		times	0 	db ''	;Longitud total del registro: 28 + eol = 29
	  marca			times	10	db ' '
	  anio			times	4	db ' '
	  patente		times	7	db ' '
	  precio		times	7	db ' '
	  EOL			times	1	db ' '	;Byte para guardar el fin de linea q está en el archivo
	  ZERO_BINA		times	1	db ' '	;Byte para guardar el 0 binario que agrega la fgets

	vecMarcas		db	"Ford      Chevrolet Peugeot   Fiat      ",0

	anioStr	 		db '****',0
	anioFormat	    db '%hi',0	;16 bits (word)
	anioNum			dw	0		;16 bits (word)  

	precioStr 		db '*******',0
	precioFormat    db "%d",0 ; '%i',0	;32 bits (double word)

	regSeleccion	times	0	db	'' ;11 bytes en total
	 patenteSel		times	7	db ' ' ;7 bytes
	 precioSel					dd 0   ;4 bytes

	charFormat		db '%c',10,0

	;*** Mensajes para debug
	msjInicio   db  "Iniciando...",0
	msjAperturaOk db "Apertura Listado ok",0
	msjAperturaOkS db "Apertura Seleccion ok",0
	msjLeyendo	db	"leyendo...",0

section .bss
    datoValido		resb	1
    regsitroValido	resb 1
	plusRsp		resq	1 

section  .text
main:
	;Abro archivo listado
    mov		rdi,fileListado ;RCX
    mov     rsi,modeListado ;RDX
    call	fopen

    cmp     rax,0
    jle     errorOpenLis
    mov     [handleListado],rax

mov     rdi,msjAperturaOk
call    puts

	;Abro archivo seleccion
	mov		rdi,fileSeleccion
	mov		rsi,modeSeleccion
	call	fopen

	cmp		rax,0
	jle		errorOpenSel
	mov		[handleSeleccion],rax

mov     rdi,msjAperturaOkS
call    puts

    ;LEO EL ARCHIVO LISTADO
leerRegsitro:
    mov     rdi,regListado
    mov     rsi,30              
    mov     rdx,[handleListado]       
    call    fgets
    cmp     rax,0
    jle     closeFiles	

mov rdi,msjLeyendo
call puts  

	;Valido registro
	call	validarRegistro
    cmp		byte[regsitroValido],'N'
    je		leerRegsitro

	;Copio Patnte al campo del registro del archivo
	mov		rcx,7
	mov		rsi,patente
	mov		rdi,patenteSel
	rep	movsb	

	;Copio campo precio a otro campo q tiene el 0 binario al final
	mov		rcx,7
	mov		rsi,precio
	mov		rdi,precioStr
	rep	movsb

	;Convierto precio a numerico
	mov		rdi,precioStr        ;rcx
	mov		rsi,precioFormat      ;rdx
	mov		rdx,precioSel         ;r8
	call	checkAlign      ;no va en Windows
	sub		rsp,[plusRsp]   ;sub rsp,32
	call	sscanf
	add		rsp,[plusRsp]   ;add rsp,32

	;Guardo registro en archivo Seleccion
	mov		rdi,regSeleccion			;Parametro 1: dir area de memoria con los datos a copiar
	mov		rsi,11						;Parametro 2: longitud del registro
	mov		rdx,1						;Parametro 3: cantidad de registros
	mov		rcx,[handleSeleccion]		;Parametro 4: handle del archivo
	call	fwrite

	jmp    leerRegsitro

;----Mensajes de error
errorOpenLis:
	mov		rdi,msjErrOpenLis ;RCX
	call	puts
	jmp		endProg
errorOpenSel:
    mov     rdi,msjErrOpenSel
    call    puts
	;Cierro archivo Listado
	mov		rdi,[handleListado]	;Parametro 1: handle del archivo
	call	fclose				;CIERRO archivo
	jmp		endProg
closeFiles:
    mov     rdi,[handleListado]
    call    fclose
	mov		rdi,[handleSeleccion]	;Parametro 1: handle del archivo
	call	fclose					;CIERRO archivo
endProg:
ret

;------------------------------------------------------
;------------------------------------------------------
;   RUTINAS INTERNAS
;------------------------------------------------------
validarRegistro:
    mov     byte[regsitroValido],'N'

    call    validarMarca
    cmp     byte[datoValido],'N'
    je      finValidarRegistro

    call    validarAnio
    cmp     byte[datoValido],'N'
    je      finValidarRegistro

	call	validarPrecio
    cmp     byte[datoValido],'N'
    je      finValidarRegistro

    mov     byte[regsitroValido],'S'

finValidarRegistro:
ret

;------------------------------------------------------
;VALIDAR MARCA
validarMarca:
	mov     byte[datoValido],'S'

	mov     rbx,0
	mov     rcx,4
nextMarca:
	push    rcx
	mov     rcx,10
	lea     rsi,[marca]  ; = mov rsi,marca
    lea     rdi,[vecMarcas+rbx]
	repe cmpsb

	pop     rcx
	je		marcaOk
	add		rbx,10
	loop	nextMarca

	mov     byte[datoValido],'N'
marcaOk:
mov	rsi,[datoValido]
call printf_char
ret

;------------------------------------------------------
;VALIDAR AÑO
validarAnio:
	mov     byte[datoValido],'N'

	mov		rcx,4
	mov		rbx,0
nextDigito:
	cmp		byte[anio+rbx],'0'
	jl		anioError
	cmp		byte[anio+rbx],'9'
	jg		anioError
	inc		rbx
	loop	nextDigito

	mov		rcx,4
	mov		rsi,anio
	mov		rdi,anioStr
	rep	movsb

	mov		rdi,anioStr        ;rcx
	mov		rsi,anioFormat      ;rdx
	mov		rdx,anioNum         ;r8
	call	checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

; Verifico si el año esta comprendido en el rango 2010 - 2019
	cmp		word[anioNum],2010
	jl		anioError
	cmp		word[anioNum],2019
	jg		anioError 

	mov		byte[datoValido],'S'
anioError:
mov	rsi,[datoValido]
call printf_char
ret

;------------------------------------------------------
;VALIDAR PRECIO
validarPrecio:
	mov     byte[datoValido],'N'

	mov		rcx,7 ;longitud del campo 'precio'
	mov		rbx,0
nextDigitoP:
	cmp		byte[precio+rbx],'0'
	jl		precioError
	cmp		byte[precio+rbx],'9'
	jg		precioError
	inc		rbx
	loop	nextDigitoP

	mov     byte[datoValido],'S'

precioError:
mov	rsi,[datoValido]
call printf_char
ret

;------------------------------------------------------
;PRINTF_CHAR
printf_char:
	mov		rdi,charFormat	;PRIMER PARAMETRO DE printf. El segundo se carga afuera en rsi
	sub		rax,rax
	call	printf
ret

;----------------------------------------
;----------------------------------------
; ****	checkAlign ****
;----------------------------------------
;----------------------------------------
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

se dispone de una matriz c que representa un calendario de actividades de una persona
la matriz c esta formada por 7 columnas corresponden a los dias de la semana
y 6 filas que son las semanas que puede tener un mes
cada elemento de la matriz es un bpf s/signo de 2 bytes (word)
que representara la cantidad de actividades que realizara dicho dia en la semana
ademas se dispone de un archivo de entrada llamado calen.dat
donde cada registro tiene  el siguiente formato:
-dia de la semana: caracter de 2 bytes
-semana: binario de 1 byte
-actividad: caracter de longitud 20 con la descripcion
como la informacion del archivo puede ser erronea se disponde de una rutina interna llamada Valcal para su validacion
se pide realizar un programa que actualice la matriz c con aquellos registros validos.
al finalizar se solicitara el ingreso de una semana y se debe generar un listado indicando la cantidad de actividades


global	main
extern	printf
extern	gets
extern	sscanf
extern	fopen
extern	fread
extern	fclose

section		.data

	fileName	db	"CALEN.dat",0
	mode		db	"rb",0

	matriz		times	42	dw	0

	registro	times	0	db	""
		dia		times	2	db	" " ;Aca es un caracter
		semana			1	db	0	;Aca es 0 porque es un binario, osea que ya viene en forma de numero
		activ	times	20	db	" "
		eof		times	2	db	" "
		
	dias			db	"DOLUMAMIJUVISA",0	;Este es el formato en el que viene dia
		
	msjSemana		db	"Ingrese la semana: ",0
	msjErrorOpen	db	"Error en la apertura del archivo",0
	
	numFormat		db	'%i'	;%i 32 bits / %lli 64 bits

	diasImp			db	"Domingo        ",0
					db	"Lunes	        ",0
					db	"Martes	        ",0
					db	"Miercoles      ",0
					db	"Jueves	        ",0
					db	"Viernes        ",0
					db	"Sabado         ",0

	msjCant			db	"%lli",10,13,0

section		.bss
	
	fileHandle	resq	1
	esValid		resb	1
	diabin		resb	1
	
	nroIng		resd	1
	
	buffer		resb	10
	
section	.text
;--------------------------------------------------------------------	
main
	;Primero que nada se abre el archivo
	call	abrirArch
	
	cmp		qword[fileHandle],0 	;Si es 0 hubo un error en la apertura
	jle		errorOpen
	
	call	leerArch
	
	call	listar

endProg:
	ret
	
;------------------------------------------------------------------
	
errorOpen:
	mov		rcx,msjErrorOpen
	call	puts
	jmp		endProg
	
abrirArch:
	mov		rcx,fileName
	mov		rdx,mode
	call	fopen		;Abre el archivo y deja la lectura en rax
	
	qword[fileHandle],rax	;paso la lectura del archivo al handle
	
	ret
	
;--------------------------------------------------------------------	
	
leerArch:

leerReg:
	mov		rcx,registro	;direccion area de memoria donde se copia
	mov		rdx,23			;Longitud del registro
	mov		r8,1			;cantidad de registros (siempre llevara 1)
	mov		r9,qword[fileHandle]	;handle del archivo
	call	fread

	cmp		rax,0		;si esto da 0, significa que llego al final del archivo
	jle		eof
	
	;Si llego aca significa que pude leer el registro del archivo
	call	VALCAL		;llamo a la funcion que valida el registro
	cmp		byte[esValid],'N'
	je		leerReg

	
	call	sumarAct	;Esta sera para modificar la matriz segun el registro leido
						;en este caso sumar uno a la actividad de ese dia
	jmp		leerReg

eof:
	mov		rcx,qword[fileHandle] ;cierro el archivo cuando llego a eof
	call	fclose
	
	ret
	
	
;--------------------------------------------------------------------		
	
VALCAL:
	;Hago una validacion por tabla con el vector dias
	
	mov		rbx,0
	mov		rcx,7	;El largo del vector, osea la cantida de veces que quiero iterar
					;Son 7 dias por lo tanto es 7
	mov		rax,0
compDia:
	inc		rax
	push	rcx

	mov		rcx,2				;El largo de cada elemento, el largo es 2, por lo 
								;tanto queremos que vaya comparando cada 2 bytes
								
	lea		rsi,[dia]			;Direccion origen
	lea		rdi,[dias + rbx]	;Direccion destino
	repe	cmpsb	;Compara dos string, pasandole la direccion origen y la direccion destino
	
	pop		rcx
	je		diaValido		;Comparo para saber si ya encontre ese elemento en el vector
	add		rbx,2			;le sumo al rbx para avanzar en el vector
	loop	compDia
	
	jmp		invalido		;Si llega aca, se termino la iteracion por lo tanto no
							;encontro el elemento


diaValido:
	mov		byte[diabin],al		;paso el dia en binario a una variable
	
	;me voy a lo siguiente que debo validar, en este caso la semana que sera un binario
	cmp		byte[semana],1		;minimo del largo
	jl		invalido
	cmp		byte[semana],6		;maximo del largo
	jg		invalido
	
	mov		byte[esValid],'S'

finValidar:	
	ret
	
invalido:	
	mov		byte[esValid],'N'
	jmp		finValidar
	
	
	
;--------------------------------------------------------------------		
	
sumarAct:
	;Desplazamiento de una matriz
	;(col - 1) * longitud elemento + (fil - 1) * longitud elemento * cant. col
	;[Desplaz. col] + [Desplaz. filas]
	
	mov		rax,0
	mov		rbx,0
	
	;primero le desplazamiento columnas
	sub		byte[diabin],1		;resto a diabin 1 para hacer el desplaz columnas
	mov		al,byte[diabin]		;copio al registro AL
	
	mov		bl,2				;cada elemento de la matriz ocupa 2 bytes
	mul		bl					;multiplico col * 2
	
	mov		rdx,rax				;copio en rdx el desplazamiento de columnas
	
	;ahora el desplazamiento filas
	sub		byte[semana],1      ;resto a diabin 1 para hacer el desplaz filas
	mov		al,byte[semana]		;copio al registro AL
	
	mov		bl,14				;cant columnas * longitud elemento = 14
	mul		bl					;resultado de la multiplicacion en ax
	
	add		rax,rdx				;dejo en rax la suma del desplazamiento total
	
	
	;Ahora obtenemos el valor de la matriz en esa posicion
	mov		bx,word[matriz + rax]	;dejo en bx el dato de la matriz en esa posicion
	
	inc		bx					;modifico el dato de bx
	
	mov		word[matriz + rax],bx	;modifico el valor de la matriz en esa posicion
	
	ret
	
;--------------------------------------------------------------------	
	
	
listar:
ingresoSemana:
	mov		rax,msjSemana
	call	puts
	
	mov		rax,buffer		;le paso el parametro para que el usuario ingrese la semana
	call	gets
	
	mov		rax,buffer
	mov		rdx,numFormat
	mov		r8,nroIng
	call	sscanf			;convierte lo que hay en el buffer en formato numerico
	
	cmp		rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		ingresoSemana
	
	cmp		dword[nroIng],1 ;chequeo que el numero ingresado esta en el rango
	jl		ingresoSemana
	cmp		dword[nroIng],6
	jg		ingresoSemana
	

	sub		dword[nroIng],1		;resto 1 para para hacer el desplazamiento filas
	
	mov		rax,0
	mov		eax,dword[nroIng]
	
	mov		bl,14				;cant columnas * longitud elemento = 14
	mul		bl

	mov		rdi,rax			;paso el desplazamiento al rdi
	
	;Aca empiezo a imprimir
	mov		rcx,7			;cantidad de columnas a recorrer
	mov		rsi,0
	mov		rbx,0

siguienteImpr:
	push	rcx
	
	lea		rcx[diasImp + rsi]	;Aca estoy recorriendo el vector de encabezados
	call	printf
	
	mov		bx,word[matriz + rdi];recupero el dato que se encuentra en la matriz en esa posicion

	mov		rcx,msjCant		
	mov		rdx,rbx			;imprimo ese dato de la matriz
	call	prinf

	add		rdi,2			;Avanzo al proximo elemento de la fila
	add		rsi,15			;Avanzo 15 bytes que es lo que hay en el vector diasImp
	
	pop		rcx
	
	loop	siguienteImpr
	
	ret
	
	
	
	
	
	
	
	
	
	



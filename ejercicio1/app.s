	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.equ KEY_L, 0b00000001  // Valor del GPIO para la tecla L
	.globl main

FunctionFondo:
		mov x2, SCREEN_HEIGH         // Y Size
	loop1:
		mov x1, SCREEN_WIDTH         // X Size
	loop0:
		stur w10,[x0]  // Colorear el pixel N
		add x0,x0,4    // Siguiente pixel
		sub x1,x1,1    // Decrementar contador X
		cbnz x1,loop0  // Si no terminó la fila, salto
		sub x2,x2,1    // Decrementar contador Y
		cbnz x2,loop1  // Si no es la última fila, salto

		mov x0, x20 // Guarda la dirección base del framebuffer en x0
		mov x12, 640 //Salto de cada cordenada Y
	ret

FunctionTriangulo:
	mov x14, x2
loopYT:
	mov x13, x1
loopXT:
	mul x11, x14, x12
	add x11, x11, x13 // x11 = x +( y * 640)
	lsl x11, x11, 2 // x11 = 4* (x +( y * 640))
	add x11, x0, x11

	stur w10,[x11]
	add x13, x13, 1
	add x11, x1, x9 //ANCHO
	sub x11, x13, x11 // x13 = 0, 1, 2, ... 
	cmp x11, 0 
	bge exitXT
	b loopXT
exitXT:
	add x14, x14, 1
	add x1, x1, 1
	sub x9, x9, 2
	add x11, x2, x15 //ALTO
	sub x11, x14, x11
	cmp x11, 0
	bge exitT
	b loopYT
exitT:
	ret


FunctionCuadrado :
	mov x14, x2
loopYC:
	mov x13, x1
loopXC:
	mul x11, x14, x12
	add x11, x11, x13 // x11 = x +( y * 640)
	lsl x11, x11, 2 // x11 = 4* (x +( y * 640))
	add x11, x0, x11
	
	stur w10,[x11]
	add x13, x13, 1
	add x11, x1, x9 //ANCHO
	sub x11, x13, x11 // x13 = 0, 1, 2, ... , 199 
	cmp x11, 0 
	bge exitXC
	b loopXC
exitXC:
	add x14, x14, 1
	add x11, x2, x15 //ALTO
	sub x11, x14, x11
	cmp x11, 0
	bge exitC
	b loopYC
exitC:
	ret

FunctionLinux:
	//LINUX
	
	movz x10, 0x00, lsl 16
    movk x10, 0x1AFD, lsl 00
	bl FunctionFondo

	movz x10, 0x00, lsl 16
    movk x10, 0x0001, lsl 00

	mov x9, 210 //Ancho
	mov x15, 300 //Alto
	mov x2, 210
	mov x1, 200 
	bl FunctionCuadrado

	movz x10, 0xFF, lsl 16
    movk x10, 0xFFFF, lsl 00

	mov x9, 150 //Ancho
	mov x15, 300 //Alto
	mov x2, 230
	mov x1, 230 
	bl FunctionCuadrado

	movz x10, 0x00, lsl 16
    movk x10, 0x0001, lsl 00

	mov x9, 125 //Ancho
	mov x15, 100 //Alto
	mov x2, 110
	mov x1, 240 
	bl FunctionCuadrado

	movz x10, 0xFF, lsl 16
    movk x10, 0xFFFF, lsl 00

	mov x9, 95 //Ancho
	mov x15, 50 //Alto
	mov x2, 160
	mov x1, 255
	bl FunctionCuadrado

	movz x10, 0xFF, lsl 16
    movk x10, 0xFFFF, lsl 00

	mov x9, 40 //Ancho
	mov x15, 50 //Alto
	mov x2, 120
	mov x1, 255
	bl FunctionCuadrado
	
	movz x10, 0xFF, lsl 16
    movk x10, 0xFFFF, lsl 00

	mov x9, 40 //Ancho
	mov x15, 50 //Alto
	mov x2, 120
	mov x1, 310
	bl FunctionCuadrado

	movz x10, 0xFC, lsl 16
    movk x10, 0x4B08, lsl 00

	mov x9, 45 //Ancho
	mov x15, 23 //Alto
	mov x2, 160
	mov x1, 280
	bl FunctionTriangulo

	/*mov x9, 25 //Ancho
	mov x15, 50 //Alto
	mov x2, 160
	mov x1, 290
	bl FunctionCuadrado*/

	movz x10, 0x00, lsl 16
    movk x10, 0x0000, lsl 00

	mov x9, 15 //Ancho
	mov x15, 25 //Alto
	mov x2, 130
	mov x1, 320
	bl FunctionCuadrado

	mov x9, 15 //Ancho
	mov x15, 25 //Alto
	mov x2, 130
	mov x1, 270
	bl FunctionCuadrado

	ret
	
main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0x00, lsl 16
    movk x10, 0x1AFD, lsl 00
	bl FunctionFondo

FunctionWindows :
	//WINDOWS
	//bl FunctionFondo
	movz x10, 0xFF, lsl 16
    movk x10, 0x2E01, lsl 00

	mov x9, 120 //Ancho
	mov x15, 80 //Alto
	mov x2, 120
	mov x1, 160 
	bl FunctionCuadrado
	//-----------------------------
	movz x10, 0x00, lsl 16
    movk x10, 0x0D7B, lsl 00

	mov x2, 205
	mov x1, 160 
	bl FunctionCuadrado
	//-----------------------------
	movz x10, 0x0B, lsl 16
    movk x10, 0x8A48, lsl 00

	mov x2, 120
	mov x1, 285 
	bl FunctionCuadrado
	//-----------------------------
	movz x10, 0xFF, lsl 16
    movk x10, 0xE504, lsl 00

	mov x2, 205
	mov x1, 285
	bl FunctionCuadrado
	//-----------------------------

    // Ejemplo de uso de gpios
    mov x9, GPIO_BASE

    // Atención: se utilizan registros w porque la documentación de broadcom
    // indica que los registros que estamos leyendo y escribiendo son de 32 bits

    // Setea gpios 0 - 9 como lectura
    str wzr, [x9, GPIO_GPFSEL0]

InfLoop:
    // Verificar si se ha presionado la tecla "L"
    ldr w10, [x9, GPIO_GPLEV0]
    and w11, w10, KEY_L
    cmp w11, KEY_L
    bne SkipFunctionLinux

    // Si se presionó la tecla "L", llamar a la función FunctionLinux
    bl FunctionLinux

SkipFunctionLinux:
    b InfLoop

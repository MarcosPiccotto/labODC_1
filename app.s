	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.equ KEY_W, 0b00000010  // Valor del GPIO para la tecla W
    .equ KEY_L, 0b00000001  // Valor del GPIO para la tecla L

	.globl main

FunctionCuadrado:
//CORDENADAS
	mov x14, x2
loopY:
	mov x13, x1
loopX:
	mul x11, x14, x12
	add x11, x11, x13 // x11 = x +( y * 640)
	lsl x11, x11, 2 // x11 = 4* (x +( y * 640))
	add x11, x0, x11
	
	stur w10,[x11]
	add x13, x13, 1
	add x11, x1, x9 //ANCHO
	sub x11, x13, x11 // x13 = 0, 1, 2, ... , 199 
	cmp x11, 0 
	bge exitX
	b loopX
exitX:
	add x14, x14, 1
	add x11, x2, x15 //ALTO
	sub x11, x14, x11
	cmp x11, 0
	bge exit
	b loopY
exit:
	ret

FunctionWindows :
	//WINDOWS
	bl FunctionFondo
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
	
	ret

FunctionLinux:

	//LINUX
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
	mov x15, 30 //Alto
	mov x2, 160
	mov x1, 280
	bl FunctionCuadrado

	mov x9, 25 //Ancho
	mov x15, 50 //Alto
	mov x2, 160
	mov x1, 290
	bl FunctionCuadrado

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
	
FunctionFondo:
		movz x10, 0x00, lsl 16
		movk x10, 0x1AFD, lsl 00
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

main:
    // x0 contiene la direccion base del framebuffer
    mov x20, x0 // Guarda la dirección base del framebuffer en x20
    //---------------- CODE HERE ------------------------------------
	bl FunctionFondo

    // Ejemplo de uso de gpios
    mov x9, GPIO_BASE

    // Configura gpios 0 - 9 como entradas
    ldr x10, [x9, GPIO_GPFSEL0]   // Lee el valor actual de GPIO_GPFSEL0
    bfi x10, xzr, #0, #3          // Establece los bits 0-2 como ceros (modo de entrada)
    str x10, [x9, GPIO_GPFSEL0]   // Guarda el valor modificado en GPIO_GPFSEL0

InfLoop:
    // Lee el estado de los GPIO 0 - 31
    ldr w10, [x9, GPIO_GPLEV0]

    cmp w10, KEY_W
    beq WindowsCheck

	ldr w10, [x9, GPIO_GPLEV0]
	cmp w10, KEY_L
    beq LinuxCheck

	bl InfLoop
LinuxCheck:
    // Lee el estado de los GPIO 0 - 31 nuevamente para comprobar la tecla L
    ldr w10, [x9, GPIO_GPLEV0]

    cmp w10, KEY_L
      // Si no se presionó la tecla L, vuelve al bucle principal

    bl FunctionLinux
    b InfLoop

WindowsCheck:
    bl FunctionWindows
    b InfLoop

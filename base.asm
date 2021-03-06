;－－－－－－大端小端的含义（详细解释－－>http://www.cnblogs.com/wuyuegb2312/archive/2013/06/08/3126510.html）
;一个16进制数有两个字节组成，例如：A9。
;高字节就是指16进制数的前8位（权重高的8位），如上例中的A。
;低字节就是指16进制数的后8位（权重低的8位），如上例中的9。

;－－－－－－－以下应用于8086CPU－－－－－－－－－－
8086 CPU 本书学习的寄存器有： ax,bx,cx,dx,si,di,bp,sp,cs,ss,ds,es,flag

; 通用寄存器：ax,bx,cx,dx－(ah 16-8,al 0-7)
ax,bx,cx,dx,;－－16位寄存器 1个字
ah,al,;－－8位寄存器 1个字节

;－－注意：在进行数据传送或位数运算时，指令的两个操作对象的 位数 应当一致！

;物理地址－－CPU访问内存单元时，要给出内存单元的地址。所有内存单元构成的存储空间是一个一位的线性空间，每一个内存单元在这个空间中都有唯一的地址，我们将这个唯一的地址称为物理地址。
;8086CPU 给出物理地址的方法：
;  物理地址 ＝ 段地址 ＊ 16 ＋偏移地址
;举例： 123C8H = 1230H * 16 + 00C8H

;cpu中，用16位寄存器来存储一个字。

;－－注意：“段地址 ＊ 16” 更为常用说法是左移4位，“位”－二进制的位数。（数据的位移的n位数 ＝ 该数据 ＊ 2的n次方）

;提供段地址的部件：段地址在8086CPU的 段寄存器 中存放。
;段寄存器：cs, ds, ss, es,
;8086CPU要访问内存时由这4个段寄存器提供内存单元的 段地址 。

;CS 为代码段寄存器 IP 为指令指针寄存器， 它们指示了CPU当前要读取指令的地址（ CS:IP 它们的内容提供了CPU要执行指令的地址）。8086机中，在任意时刻，CPU将 CS:IP 指向的内容当作指令执行。
;CPU的工作过程简要描述如下：
; 1）从CS:IP指向的内存单元读取指令，读取的指令进入指令缓冲区
; 2）IP＝IP＋所读取指令的长度，从而指向下一条指令
; 3）执行指令。转到 1），重复这个过程。

;－－注意：mov指令被称为传送指令。但是，mov指令不能用于设置CS,IP的值，能够改变CS,IP的值的指令被统称为转移指令。

;转移指令一：jmp指令
;同时修改CS，IP的内容，可用形如"jmp 段地址:偏移地址"的指令格式完成。功能为：用指令中给出的段地址修改CS,偏移地址修改IP。
;仅修改IP的内容，可用形容"jmp 某一合法寄存器"的指令完成，比如：jmp ax 功能：用寄存器中的值修改IP。

;关于代码段和代码段的执行：
;在编程时，可根据需要，将一组内存段缘定义为一个段。将长度为n的一组代码，存在这一组地址连续，起始地址为16倍数的内存单元中，我们可以认为，这段内存时用来存放代码的，从而定义一个代码段。
;如果要执行该代码段，可使用 jmp CS:IP 或是 mov ax,该段起始地址 jmp ax

; DS 和[address]
;CPU要读写一个内存单元的时候，必须先给出这个内存单元的地址，内存地址由段地址＋偏移地址 组成。
;DS寄存器 通常用来存放访问数据的段地址。
;举例：
	mov bx,1000H
	mov ds,bx
	mov al,[0]
;上面三条指令将10000H（1000:0）中的数据读到al中。
;[...] 表示一个内存单元，[...]中的0 表示内存单元的偏移地址。
;指令执行时 CPU自动取ds中的数据位内存单元的段地址。
;8086CPU不支持将数据直接送入段寄存器的操作（硬件设计问题），DS是一个段寄存器，所以 mov ds,1000H 这条指令时非法的。
;故只能用一个寄存器来进行中转。
;相反即为 将数据从寄存器送入内存单元（ mov [0],al )

; 入栈指令：push 出栈指令：pop 
	push ax	;将寄存器中的数据送入栈中
	pop ax	;将栈顶中的数据取出送入ax
;8086CPU的出入栈操作以字为单位进行。
;“字”型数据用两个单元（字节）存放，高地址存放高8位，低地址存放低8位

;段寄存器SS 存放栈顶段地址，寄存器SP 存放栈顶偏移地址	===>>>>任意时刻，SS:SP指向栈顶数据；push和pop 执行时，CPU从SS和SP中得到栈顶地址
;8086CPU中，入栈时栈顶从高地址向低地址方向增长。
;执行 内存单元 与 内存单元 出入栈操作时，可以只给出内存单元的偏移地址，段地址在指令执行时从 ds 中取得。
	mov ax,1000H
	mov ds,ax
	push [0]	;将1000:0中的数据压入栈中（栈也是内存单元组成的喔）
	pop [2]

;执行push pop指令需要两步操作：push时，CPU操作=》先改变SP，后向SS:SP处传送；pop时，CPU操作=》先读取SS:SP处数据，后改变SP。
;－－注意：PUSH，POP等栈操作指令，修改的只是SP。也就是说，栈顶的变化范围为：0～FFFFH
;提供：SS，SP指示栈顶；改变SP后写内存的入栈指令；读内存的后改变SP的出栈指令。这就是8086CPU提供的栈操作。
;-----------《栈的综述》P67------------
;-----------《段的综述》P69------------
;数据段：将段地址放在DS中，用mov,add,sub等访问内存的指令时，CPU就将我们定义的数据段中的内容当作数据来访问；
;代码段：将段地址放在CS中，将段中第一条指令的偏移地址放在SP中，这样CPU就将执行我们定义的代码段中指令；
;栈段  ：将段地址放在SS中，将栈顶单元的偏移地址放在SP中，这样CPU在需要进行栈操作的时候，比如执行push,pop指令等，就将我们定义的栈段当作栈空间执行。

;内存单元（例：[bx],[0]) 的描述 见P95

;loop指令
;格式：loop 标号
;CPU执行loop指令的时候，进行两部操作，1）cx = cx - 1; 2)判断cx中的值，不为零则跳转至标号处执行程序，如果为零则向下继续执行。
;通常（是通常喔）我们用loop指令来实现循环功能，cx中存放循环次数。
;cx 和 loop指令相配合实现循环功能的程序框架如下：
	mov cx,循环次数

s:;标号
	;需循环执行的程序段
	loop s


;段前缀：在访问内存单元的指令中，用于显示的指明内存单元的段地址的"ds:" "cs:" "ss:" "es" ,在汇编语言中称为段前缀
	mov ax,cs:[0] ;段前缀cs
	mov ax,[bx] ;内存单元偏移地址由bx给出，段地址默认在ds中（无段前缀）

; "dw" : 定义字型数据。dw即"define word"(多个数据时用逗号隔开： dw 0123h,0456h ...)
; "dw" 作用：用它定义数据，即————用它开辟内存空间（一般用做栈空间）

; 将 数据、代码、栈 放入不同的段 见P130-133
; CPU 到底如何处理我们定义的段中内容，是当作指令执行，当数据访问，还是当栈空间，完全靠程序中具体的汇编指令，和汇编指令对 CS：IP、SS：SP、DS等寄存器的设置来决定。

; and指令：逻辑与指令，按位进行与运算。
;通过该指令可将操作对象的相应位设置为0，其他位不变。

; or指令：逻辑或指令，按位进行或运算。
;通过该指令可将操作对象的相应位设置为1，其他位不变。

;可以用[bx+idata]的方式进行数组的处理

; si 和 di 是8086CPU中和 bx 功能相近的寄存器，si 和 di 不能够分成两个8位寄存器来使用。

; bp：只要在[...]中使用寄存器 bp，而指令中没有显示的给出段地址，段地址就默认在 ss 中。

;进行数据处理的机器指令 大致分为3类：读取、写入、运算。在机器指令这一层来讲，并不关心数据的值是多少，而关心指令执行前一刻，它将要处理的数据所在的位置。所要处理数据可在的3个位置：CPU内部、内存、端口。
	mov bx,[0]	;内存，ds:0单元
	mov bx,ax	;CPU内部，ax寄存器
	mov bx,1	;CPU内部，指令缓冲期（端口？文中没有明确说明）p162
;8086CPU部分寻址方式见 p164

; div 除法指令，
;使用 div 需要注意：1）除数：有8位和16位2种，在一个reg或内存单元中。2）被除数：默认放在AX 或DX 和AX 中，（被除数大于16位时，DX放高16位，AX放低16位） 3）结果：除数为8位，AL存储商，AH存储余数；除数为16位，AX存储商，DX存放余数。

;可以修改 IP，或同时修改 CS 和 IP 的指令统称为转移指令。概括讲，转移指令就是可以控制CPU执行内存中某处代码的指令。

;8086CPU 转移行为有以下几类：
	jmp ax 			;只修改IP 称为段内转移
	jmp 10000:0 	;同时修改 CS和IP 称为段间转移
;由于转移指令对 IP 的修改范围不同，段内转移又分为：短转移和近转移。
;短转移IP范围：-128 ～ 127
;近转移IP范围：-32768 ～ 32767

;8086CPU的转移指令分为以下几类：
;无条件转移指令（如：jmp）
;条件转移指令
;虚幻指令（如：loop）
;过程
;中断

; jmp指令：无条件转移指令，可只修改IP，也可同时修改 CS和IP。
; jmp指令要给出两种信息：1）转移的目的地址。 2）转移的距离（段间、段内短转移、段内近转移）

; jmp指令 依据位移进行转移（具体内容见p177起～ 重点！！！如果忘了 需要重复看！！）
;几种转移地址的使用 同样见p177起～

;jcxz指令：有条件转移指令，所有有条件转移指令都是短转移（应该指的8086），在对应的机器码中包含转移的位移，而不是目的地址。对IP的修改范围为：-128 ～ 127
;jcxz 指令格式：jcxz 标号（ if(cx ==0),转移到标号处执行）

; loop指令：循环指令，所有循环指令都是短转移（应指8086） 剩余描述见p185

; 根据 位移 进行转移的意义 ：方便程序段在内存中的浮动装配 具体描述见p186

; call 和 ret 都是转移指令，都能修改IP 或同时修改 CS和IP。

; ret指令用栈中的数据，修改IP内容，实现近转移。
; retf指令用栈中的数据，修改CS和IP的内容，实现远转移。
; ret retf 具体操作见p190

; CPU 执行 call指令时，进行两部操作：
; 1）将当前的IP或CS和IP压入栈；
; 2）转移。
; call指令不能实现短转移，除此以外，call指令实现转移的方法和jmp指令的原理相同。
; call指令多种操作见p192  call 与 ret 配合使用同在

;CPU内部的寄存器中，有一种特殊的寄存器（对于不同的处理机，个数和结构都可能不同）具有以下3种作用：
; 1）用来存储相关指令的某些执行结果；
; 2）用来为CPU执行相关指令提供行为依据；
; 3）用来控制CPU的相关工作方式。
;这种特殊的寄存器在8086CPU中，被称为标志寄存器。8086CPU的标志寄存器有16位，其中存储的信息通常被称为程序状态字（PSW).  （标志寄存器简称FLAG）

;flag 和其他寄存器不一样，flag是按位起作用，每一位都有专门的含义，记录特定的信息。

;flag第6位：ZF，零标志位。记录相关指令执行后，其结果是否为0。如果结果为0，那么ZF=1，反之ZF=0.

;flag第2位：PF，奇偶标志位。记录相关指令执行后，结果所有bit位中1的个数是否为偶数，如果是，PF=1，反之为奇数，那么PF=0.

;flag第7位：SF，符号标志位。记录相关指令执行后，结果是否为负，如果是，SF=1，反之SF=0.

;flag第0位：CF，进位标志位。进行无符号数运算时，记录运算结果的最高有效位向更高位的进位值，或从更高位的借位值。具体见 p216

;flag第11位：OF，溢出标志位。一般情况，OF记录了有符号数运算的结果是否发生溢出，如果是，OF=1，反之OF=0.

;CF 和 OF 的区别：CF针对无符号数运算的结果，OF针对有符号数运算的结果。

;flag第10位：DF，方向标志位。串处理指令中，控制每次操作后si,di的增减。
;DF = 0 每次操作后 si,di递增。
;DF = 1 每次操作后 si,di递减。
;cld 指令：将标志寄存器的DF位 置0
;std 指令：将标志寄存器的DF位 置1

;movsb,movsw :串传送指令，movsb字节传送，movsw字传送，需要配合rep使用。
;rep 指令：根据 cx 的值，重复执行后面的串传送指令（后面的其他指令是否同样可以重复执行）
;格式 rep movsb 或 rep movsw 具体描述和示例见p231

;adc 带进位加法指令，利用CF位上记录的进位值。
;指令格式：adc 操作对象1，操作对象2
;功能 	：操作对象1 = 操作对象1 + 操作对象2 + CF
例如指令：adc ax,bx 实现功能为：(ax) = (ax) + (bx) + CF 

;sbb 带借位减法指令，利用CF位上记录的借位值。
;指令格式：sbb 操作对象1，操作对象2
;功能 	：操作对象1 = 操作对象1 - 操作对象2 - CF
例如指令：sbb ax,bx 实现功能为：(ax) = (ax) - (bx) - CF 
;sbb指令执行后，将对CF进行设置。

;cmp 比较指令，功能相当于减法指令，只是不保存。cmp指令执行后，将对标志寄存器产生影响。其他相关指令通过识别这些被影响的标志寄存器位来得知比较结果。具体描述见p222
;格式：cmp 操作对象1，操作对象2

;条件转移指令除了jcxz 其他见p225

; pushf 将标志寄存器的值压栈，popf 从栈中弹出数据，送入标志寄存器中。
; pushf 和 popf ,为直接访问标志寄存器提供了一种方法。

; 8086CPU 内中断的产生：
; 1）除法错误，比如 div指令产生的除法溢出
; 2）单步执行
; 3）执行into指令
; 4）执行int指令
; 8086CPU用称为中断类型码的数据来标识中断信息的来源。中断类型码为一个字节型数据，可以表示256种中断信息的来源。
; 上述4种中断源，在8086CPU中的中断类型码如下：
; 1) 除法错误：0
; 2）单步执行：1
; 3）执行into指令：4
; 4）执行int指令，该指令的格式为int n,指令中的n为字节型立即数，是提供给CPU的中断类型码。

; 中断处理程序、中断向量表、中断过程 见P237-238

; 因为CPU随时都可能检测到中断信息，也就是说CPU随时都可能执行中断处理程序，所以中断处理程序 必 须 常 驻 内 存 。

; iret (interrupt return)中断返回，中断服务程序的最后一条指令
; 功能用汇编语法描述：
 pop IP
 pop CS
 popf

 ;int指令 格式：int n ；n为中断类型码，功能：引发中断过程。

 ;端口读写指令：in、out：分别用于从端口读取数据和往端口写入数据。
 ;CPU最多定位64KB不同的端口，地址范围：0～65535

 ; 注意 在in和out指令中，只能使用ax 和 al 来存放端口读入的数据或发送到端口中的数据。

 ;shl、shr 逻辑位移指令，shl:左移指令、shr:右移指令

 ;===============指令系统总结p285==============
 ;1）数据传送指令
 	mov
 	push
 	pop
 	pushf
 	popf
 	xchg
;2）算术运算指令 :影响标志寄存器sf zf of pf af位
	add 
	sub
	adc 
	sbb 
	inc
	dec
	cmp 
	imul 
	idiv 
	aaa
;3）逻辑指令：除了not 其他指令都影响标志寄存器
	and 
	or 
	not 
	xor
	test 
	shl
	shr 
	sal 
	sar
	rol
	ror
	rcl
	rcr
;4）转移指令
	jmp
	jcxz,je,jb,ja,jnb,jna
	loop
	call,ret,retf
	int,iret
;5）处理机控制指令:对标志寄存器或其他处理机状态进行设置
	cld
	std
	cli
	sti
	nop
	clc 
	cmc
	stc
	hlt
	wait
	esc
	lock
;6）串处理指令
	movsb
	movsw
	cmps
	scas
	lods
	stos
	;使用以上串处理指令批量数据处理需要和 rep,repe,repne等前缀指令配合使用。


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   8086   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;通用寄存器用途

;EAX，AX 累加器
;在算数运算中作为累加器（显示）
;在乘法（除法）操作中，存放乘数和乘积（存放被除数，商和余数）（隐含）
;在串操作指令中存放操作数（隐含）
;在DOS、BIOS的功能调用中存放功能号（AH）（显示）
;在一般操作中存放操作数或结果（显示）

;EBX,BX 基址寄存器
;在间接寻址或基址变址寻址时用于基址寄存器（显示）
;在一般操作中存放操作数或结果（显示）

;ECX,CX 计数器
;在循环指令中，作为循环次数计数器（隐含）
;在移位操作时用于移位次数计数器（显示）
;在串操作时可作为循环次数计数器（显示） 

;EDX,DX 数据寄存器
;在16位乘法中用于存放乘积高位（隐含）
;在32位除以16位除法中用于存放被除数高位及余数（隐含）
;I/O指令间接寻址时用于存放端口地址寄存器（隐含）

;ESP，SP 堆栈指针寄存器
;在堆栈操作中用作堆栈指针（隐含）

;EBP,BP 基址指针寄存器
;在相对堆栈段的基址加变址寻址时用于基址寄存器（显示）
;在利用堆栈来向子程序传递参数时用于基址寄存器（显示）

;ESI,SI 源变址寄存器
;间接寻址时用于地址寄存器和变址寄存器（显示）
;串操作时用于源变址寄存器(隐含)

;EDI Di 目的变址寄存器
;间接寻址时用于地址寄存器和变址寄存器（显示）
;串操作时用于源变址寄存器(隐含)






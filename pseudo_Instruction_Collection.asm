;=================================================================================
;======================================16位=======================================
;=================================================================================

assume cs:codesg	;assume:设置寄存器（例:cs）与某一个段相关联

;标号（例：codesg) 表示为段的名称，指代一个地址。
codesg segment		; segment 和 ends 一对成对使用的伪指令，功能:定义一个段
	.				
	.
	.
codesg ends

; “end”：end除了通知编译器程序结束外，还可以通知编译器程序入口的位置。

code segment
	start:
	.
	.
	.
code ends
end start

db 1	;字节型数据(dbyte) 				数据：01H 	占1个字节
dw 1	;字型数据 (dword)					数据：0001H 	占1个字
dd 1	;dword型数据（double word，双字）	数据：00000001H 占2个字

dup ;数据重复伪指令，与 db、dw、dd等数据定义的伪指令配合使用，用来进行数据的重复。
公式：db 重复次数 dup (需重复的数据内容)
例子可见p171

offset ;由编译器处理的符号，功能：取得标号的偏移地址。例子见 p175
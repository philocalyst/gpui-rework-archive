
/tmp/gpui-style-startup-current-target/release/examples/literal_startup:     file format elf64-x86-64


Disassembly of section .text:

00000000004ec050 <literal_startup::single_width_probe>:
  4ec050:	53                   	push   %rbx
  4ec051:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  4ec058:	48 89 fb             	mov    %rdi,%rbx
  4ec05b:	0f 10 05 0e c4 b5 ff 	movups -0x4a3bf2(%rip),%xmm0        # 48470 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272>
  4ec062:	0f 11 84 24 e8 00 00 	movups %xmm0,0xe8(%rsp)
  4ec069:	00 
  4ec06a:	0f 10 0d 0f c4 b5 ff 	movups -0x4a3bf1(%rip),%xmm1        # 48480 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x10>
  4ec071:	0f 11 8c 24 f8 00 00 	movups %xmm1,0xf8(%rsp)
  4ec078:	00 
  4ec079:	0f 10 15 10 c4 b5 ff 	movups -0x4a3bf0(%rip),%xmm2        # 48490 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x20>
  4ec080:	0f 11 94 24 08 01 00 	movups %xmm2,0x108(%rsp)
  4ec087:	00 
  4ec088:	0f 10 1d 11 c4 b5 ff 	movups -0x4a3bef(%rip),%xmm3        # 484a0 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x30>
  4ec08f:	0f 11 9c 24 18 01 00 	movups %xmm3,0x118(%rsp)
  4ec096:	00 
  4ec097:	0f 10 25 12 c4 b5 ff 	movups -0x4a3bee(%rip),%xmm4        # 484b0 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x40>
  4ec09e:	0f 11 a4 24 28 01 00 	movups %xmm4,0x128(%rsp)
  4ec0a5:	00 
  4ec0a6:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  4ec0ad:	00 03 00 
  4ec0b0:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  4ec0b7:	00 
  4ec0b8:	0f 57 ed             	xorps  %xmm5,%xmm5
  4ec0bb:	0f 11 6c 24 18       	movups %xmm5,0x18(%rsp)
  4ec0c0:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  4ec0c7:	00 00 
  4ec0c9:	48 c7 44 24 30 08 00 	movq   $0x8,0x30(%rsp)
  4ec0d0:	00 00 
  4ec0d2:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  4ec0d9:	00 00 
  4ec0db:	48 c7 44 24 40 ff ff 	movq   $0xffffffffffffffff,0x40(%rsp)
  4ec0e2:	ff ff 
  4ec0e4:	0f 10 ac 24 d8 00 00 	movups 0xd8(%rsp),%xmm5
  4ec0eb:	00 
  4ec0ec:	0f 11 6c 24 48       	movups %xmm5,0x48(%rsp)
  4ec0f1:	0f 11 44 24 58       	movups %xmm0,0x58(%rsp)
  4ec0f6:	0f 11 4c 24 68       	movups %xmm1,0x68(%rsp)
  4ec0fb:	0f 11 54 24 78       	movups %xmm2,0x78(%rsp)
  4ec100:	0f 11 9c 24 88 00 00 	movups %xmm3,0x88(%rsp)
  4ec107:	00 
  4ec108:	0f 11 a4 24 98 00 00 	movups %xmm4,0x98(%rsp)
  4ec10f:	00 
  4ec110:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  4ec117:	00 
  4ec118:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  4ec11f:	00 00 00 00 00 
  4ec124:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  4ec129:	0f 11 84 24 b8 00 00 	movups %xmm0,0xb8(%rsp)
  4ec130:	00 
  4ec131:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  4ec136:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  4ec13d:	00 
  4ec13e:	c6 84 24 d0 00 00 00 	movb   $0x0,0xd0(%rsp)
  4ec145:	00 
  4ec146:	89 f0                	mov    %esi,%eax
  4ec148:	0f 57 c0             	xorps  %xmm0,%xmm0
  4ec14b:	f2 48 0f 2a c0       	cvtsi2sd %rax,%xmm0
  4ec150:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  4ec157:	00 
  4ec158:	f2 0f 11 44 24 08    	movsd  %xmm0,0x8(%rsp)
  4ec15e:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
  4ec163:	48 89 e1             	mov    %rsp,%rcx
  4ec166:	ba 01 00 00 00       	mov    $0x1,%edx
  4ec16b:	e8 b0 d8 00 00       	call   4f9a20 <<gpui::element::El>::property_operand::<f64>>
  4ec170:	48 89 d8             	mov    %rbx,%rax
  4ec173:	48 81 c4 40 01 00 00 	add    $0x140,%rsp
  4ec17a:	5b                   	pop    %rbx
  4ec17b:	c3                   	ret

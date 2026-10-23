
/tmp/gpui-caret-transaction-bin/d54-caret-pair-measure:     file format elf64-x86-64


Disassembly of section .text:

000000000067cba0 <<gpui_canvas::text::planner::Planner>::shape>:
  67cba0:	55                   	push   %rbp
  67cba1:	41 57                	push   %r15
  67cba3:	41 56                	push   %r14
  67cba5:	41 55                	push   %r13
  67cba7:	41 54                	push   %r12
  67cba9:	53                   	push   %rbx
  67cbaa:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  67cbb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  67cbb8:	00 
  67cbb9:	48 81 ec b8 01 00 00 	sub    $0x1b8,%rsp
  67cbc0:	44 89 8c 24 1c 02 00 	mov    %r9d,0x21c(%rsp)
  67cbc7:	00 
  67cbc8:	f3 0f 11 8c 24 ac 01 	movss  %xmm1,0x1ac(%rsp)
  67cbcf:	00 00 
  67cbd1:	44 89 84 24 a8 01 00 	mov    %r8d,0x1a8(%rsp)
  67cbd8:	00 
  67cbd9:	f3 0f 11 44 24 7c    	movss  %xmm0,0x7c(%rsp)
  67cbdf:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  67cbe4:	48 89 bc 24 78 03 00 	mov    %rdi,0x378(%rsp)
  67cbeb:	00 
  67cbec:	4c 8d 24 0a          	lea    (%rdx,%rcx,1),%r12
  67cbf0:	48 85 c9             	test   %rcx,%rcx
  67cbf3:	48 89 34 24          	mov    %rsi,(%rsp)
  67cbf7:	4c 89 a4 24 40 01 00 	mov    %r12,0x140(%rsp)
  67cbfe:	00 
  67cbff:	48 89 94 24 38 01 00 	mov    %rdx,0x138(%rsp)
  67cc06:	00 
  67cc07:	0f 84 98 03 00 00    	je     67cfa5 <<gpui_canvas::text::planner::Planner>::shape+0x405>
  67cc0d:	49 89 d6             	mov    %rdx,%r14
  67cc10:	48 8d 86 78 0a 00 00 	lea    0xa78(%rsi),%rax
  67cc17:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  67cc1c:	48 8d bc 24 bc 0c 00 	lea    0xcbc(%rsp),%rdi
  67cc23:	00 
  67cc24:	48 8d 46 38          	lea    0x38(%rsi),%rax
  67cc28:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  67cc2d:	48 8d 46 3c          	lea    0x3c(%rsi),%rax
  67cc31:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  67cc36:	48 8d 46 58          	lea    0x58(%rsi),%rax
  67cc3a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  67cc3f:	48 8d 46 5c          	lea    0x5c(%rsi),%rax
  67cc43:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  67cc48:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%rsp)
  67cc4f:	00 
  67cc50:	48 8d b4 24 e0 06 00 	lea    0x6e0(%rsp),%rsi
  67cc57:	00 
  67cc58:	4c 8b 05 e1 c5 10 00 	mov    0x10c5e1(%rip),%r8        # 789240 <_DYNAMIC+0x428>
  67cc5f:	eb 28                	jmp    67cc89 <<gpui_canvas::text::planner::Planner>::shape+0xe9>
  67cc61:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67cc68:	0f 1f 84 00 00 00 00 
  67cc6f:	00 
  67cc70:	41 8d 87 d8 df ff ff 	lea    -0x2028(%r15),%eax
  67cc77:	83 f8 02             	cmp    $0x2,%eax
  67cc7a:	0f 83 e1 00 00 00    	jae    67cd61 <<gpui_canvas::text::planner::Planner>::shape+0x1c1>
  67cc80:	4d 39 e6             	cmp    %r12,%r14
  67cc83:	0f 84 be 02 00 00    	je     67cf47 <<gpui_canvas::text::planner::Planner>::shape+0x3a7>
  67cc89:	45 0f b6 3e          	movzbl (%r14),%r15d
  67cc8d:	45 84 ff             	test   %r15b,%r15b
  67cc90:	78 1e                	js     67ccb0 <<gpui_canvas::text::planner::Planner>::shape+0x110>
  67cc92:	49 ff c6             	inc    %r14
  67cc95:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  67cc9c:	0f 8e 9e 00 00 00    	jle    67cd40 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  67cca2:	eb cc                	jmp    67cc70 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  67cca4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  67ccab:	00 00 00 00 00 
  67ccb0:	44 89 f8             	mov    %r15d,%eax
  67ccb3:	83 e0 1f             	and    $0x1f,%eax
  67ccb6:	41 0f b6 56 01       	movzbl 0x1(%r14),%edx
  67ccbb:	83 e2 3f             	and    $0x3f,%edx
  67ccbe:	41 80 ff df          	cmp    $0xdf,%r15b
  67ccc2:	76 3d                	jbe    67cd01 <<gpui_canvas::text::planner::Planner>::shape+0x161>
  67ccc4:	41 0f b6 4e 02       	movzbl 0x2(%r14),%ecx
  67ccc9:	c1 e2 06             	shl    $0x6,%edx
  67cccc:	83 e1 3f             	and    $0x3f,%ecx
  67cccf:	09 d1                	or     %edx,%ecx
  67ccd1:	41 80 ff f0          	cmp    $0xf0,%r15b
  67ccd5:	72 44                	jb     67cd1b <<gpui_canvas::text::planner::Planner>::shape+0x17b>
  67ccd7:	45 0f b6 7e 03       	movzbl 0x3(%r14),%r15d
  67ccdc:	49 83 c6 04          	add    $0x4,%r14
  67cce0:	83 e0 07             	and    $0x7,%eax
  67cce3:	c1 e0 12             	shl    $0x12,%eax
  67cce6:	c1 e1 06             	shl    $0x6,%ecx
  67cce9:	41 83 e7 3f          	and    $0x3f,%r15d
  67cced:	41 09 cf             	or     %ecx,%r15d
  67ccf0:	41 09 c7             	or     %eax,%r15d
  67ccf3:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  67ccfa:	7e 44                	jle    67cd40 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  67ccfc:	e9 6f ff ff ff       	jmp    67cc70 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  67cd01:	49 83 c6 02          	add    $0x2,%r14
  67cd05:	c1 e0 06             	shl    $0x6,%eax
  67cd08:	09 d0                	or     %edx,%eax
  67cd0a:	41 89 c7             	mov    %eax,%r15d
  67cd0d:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  67cd14:	7e 2a                	jle    67cd40 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  67cd16:	e9 55 ff ff ff       	jmp    67cc70 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  67cd1b:	49 83 c6 03          	add    $0x3,%r14
  67cd1f:	c1 e0 0c             	shl    $0xc,%eax
  67cd22:	09 c1                	or     %eax,%ecx
  67cd24:	41 89 cf             	mov    %ecx,%r15d
  67cd27:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  67cd2e:	0f 8f 3c ff ff ff    	jg     67cc70 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  67cd34:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  67cd3b:	00 00 00 00 00 
  67cd40:	41 83 ff 0a          	cmp    $0xa,%r15d
  67cd44:	0f 84 36 ff ff ff    	je     67cc80 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  67cd4a:	41 83 ff 0d          	cmp    $0xd,%r15d
  67cd4e:	0f 84 2c ff ff ff    	je     67cc80 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  67cd54:	41 81 ff 85 00 00 00 	cmp    $0x85,%r15d
  67cd5b:	0f 84 1f ff ff ff    	je     67cc80 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  67cd61:	48 89 fd             	mov    %rdi,%rbp
  67cd64:	48 8d 3d 05 23 10 00 	lea    0x102305(%rip),%rdi        # 77f070 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x480>
  67cd6b:	49 89 f5             	mov    %rsi,%r13
  67cd6e:	44 89 fe             	mov    %r15d,%esi
  67cd71:	4c 89 c3             	mov    %r8,%rbx
  67cd74:	ff 15 4e c9 10 00    	call   *0x10c94e(%rip)        # 7896c8 <_DYNAMIC+0x8b0>
  67cd7a:	49 89 d8             	mov    %rbx,%r8
  67cd7d:	4c 89 ee             	mov    %r13,%rsi
  67cd80:	48 89 ef             	mov    %rbp,%rdi
  67cd83:	84 c0                	test   %al,%al
  67cd85:	0f 85 f5 fe ff ff    	jne    67cc80 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  67cd8b:	41 bc 0a 00 00 00    	mov    $0xa,%r12d
  67cd91:	41 83 ff 20          	cmp    $0x20,%r15d
  67cd95:	0f 82 5f 02 00 00    	jb     67cffa <<gpui_canvas::text::planner::Planner>::shape+0x45a>
  67cd9b:	41 8d 47 81          	lea    -0x7f(%r15),%eax
  67cd9f:	83 f8 21             	cmp    $0x21,%eax
  67cda2:	0f 82 52 02 00 00    	jb     67cffa <<gpui_canvas::text::planner::Planner>::shape+0x45a>
  67cda8:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  67cdad:	44 89 fe             	mov    %r15d,%esi
  67cdb0:	e8 eb 3a 00 00       	call   6808a0 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  67cdb5:	49 89 d8             	mov    %rbx,%r8
  67cdb8:	4c 89 ee             	mov    %r13,%rsi
  67cdbb:	a8 01                	test   $0x1,%al
  67cdbd:	4c 8b a4 24 40 01 00 	mov    0x140(%rsp),%r12
  67cdc4:	00 
  67cdc5:	74 0c                	je     67cdd3 <<gpui_canvas::text::planner::Planner>::shape+0x233>
  67cdc7:	48 89 ef             	mov    %rbp,%rdi
  67cdca:	66 85 d2             	test   %dx,%dx
  67cdcd:	0f 85 ad fe ff ff    	jne    67cc80 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  67cdd3:	48 8b 0c 24          	mov    (%rsp),%rcx
  67cdd7:	48 8b 81 40 0a 00 00 	mov    0xa40(%rcx),%rax
  67cdde:	41 bc 0b 00 00 00    	mov    $0xb,%r12d
  67cde4:	80 78 38 01          	cmpb   $0x1,0x38(%rax)
  67cde8:	0f 85 0c 02 00 00    	jne    67cffa <<gpui_canvas::text::planner::Planner>::shape+0x45a>
  67cdee:	48 83 79 30 00       	cmpq   $0x0,0x30(%rcx)
  67cdf3:	0f 85 f0 00 00 00    	jne    67cee9 <<gpui_canvas::text::planner::Planner>::shape+0x349>
  67cdf9:	ba 48 ab 03 00       	mov    $0x3ab48,%edx
  67cdfe:	48 89 f7             	mov    %rsi,%rdi
  67ce01:	48 8d 35 94 8c 9a ff 	lea    -0x65736c(%rip),%rsi        # 25a9c <gpui_canvas::text::ARABIC_BYTES>
  67ce08:	31 c9                	xor    %ecx,%ecx
  67ce0a:	41 ff d0             	call   *%r8
  67ce0d:	83 bc 24 e0 06 00 00 	cmpl   $0xffffffff,0x6e0(%rsp)
  67ce14:	ff 
  67ce15:	0f 84 b4 2b 00 00    	je     67f9cf <<gpui_canvas::text::planner::Planner>::shape+0x2e2f>
  67ce1b:	8b 84 24 b8 0c 00 00 	mov    0xcb8(%rsp),%eax
  67ce22:	89 84 24 00 01 00 00 	mov    %eax,0x100(%rsp)
  67ce29:	0f 10 45 00          	movups 0x0(%rbp),%xmm0
  67ce2d:	0f 10 4d 0c          	movups 0xc(%rbp),%xmm1
  67ce31:	0f 29 84 24 90 04 00 	movaps %xmm0,0x490(%rsp)
  67ce38:	00 
  67ce39:	0f 11 8c 24 9c 04 00 	movups %xmm1,0x49c(%rsp)
  67ce40:	00 
  67ce41:	ba 14 69 00 00       	mov    $0x6914,%edx
  67ce46:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67ce4d:	00 
  67ce4e:	48 8d 35 8f 37 9e ff 	lea    -0x61c871(%rip),%rsi        # 605e4 <gpui_canvas::text::HEBREW_BYTES>
  67ce55:	31 c9                	xor    %ecx,%ecx
  67ce57:	ff 15 e3 c3 10 00    	call   *0x10c3e3(%rip)        # 789240 <_DYNAMIC+0x428>
  67ce5d:	83 bc 24 e0 06 00 00 	cmpl   $0xffffffff,0x6e0(%rsp)
  67ce64:	ff 
  67ce65:	0f 84 79 2b 00 00    	je     67f9e4 <<gpui_canvas::text::planner::Planner>::shape+0x2e44>
  67ce6b:	8b 94 24 b8 0c 00 00 	mov    0xcb8(%rsp),%edx
  67ce72:	48 8d 84 24 bc 0c 00 	lea    0xcbc(%rsp),%rax
  67ce79:	00 
  67ce7a:	0f 10 00             	movups (%rax),%xmm0
  67ce7d:	0f 10 48 0c          	movups 0xc(%rax),%xmm1
  67ce81:	0f 29 84 24 e0 02 00 	movaps %xmm0,0x2e0(%rsp)
  67ce88:	00 
  67ce89:	0f 11 8c 24 ec 02 00 	movups %xmm1,0x2ec(%rsp)
  67ce90:	00 
  67ce91:	48 8b 04 24          	mov    (%rsp),%rax
  67ce95:	48 c7 40 30 01 00 00 	movq   $0x1,0x30(%rax)
  67ce9c:	00 
  67ce9d:	8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%ecx
  67cea4:	89 48 38             	mov    %ecx,0x38(%rax)
  67cea7:	0f 10 84 24 9c 04 00 	movups 0x49c(%rsp),%xmm0
  67ceae:	00 
  67ceaf:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  67ceb4:	0f 11 41 0c          	movups %xmm0,0xc(%rcx)
  67ceb8:	0f 28 84 24 90 04 00 	movaps 0x490(%rsp),%xmm0
  67cebf:	00 
  67cec0:	0f 11 01             	movups %xmm0,(%rcx)
  67cec3:	89 94 24 c0 01 00 00 	mov    %edx,0x1c0(%rsp)
  67ceca:	89 50 58             	mov    %edx,0x58(%rax)
  67cecd:	0f 10 84 24 ec 02 00 	movups 0x2ec(%rsp),%xmm0
  67ced4:	00 
  67ced5:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67ceda:	0f 11 40 0c          	movups %xmm0,0xc(%rax)
  67cede:	0f 28 84 24 e0 02 00 	movaps 0x2e0(%rsp),%xmm0
  67cee5:	00 
  67cee6:	0f 11 00             	movups %xmm0,(%rax)
  67cee9:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  67ceee:	44 89 fe             	mov    %r15d,%esi
  67cef1:	e8 aa 39 00 00       	call   6808a0 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  67cef6:	66 85 d2             	test   %dx,%dx
  67cef9:	0f 95 c1             	setne  %cl
  67cefc:	20 c1                	and    %al,%cl
  67cefe:	88 4c 24 38          	mov    %cl,0x38(%rsp)
  67cf02:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  67cf07:	44 89 fe             	mov    %r15d,%esi
  67cf0a:	e8 91 39 00 00       	call   6808a0 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  67cf0f:	66 85 d2             	test   %dx,%dx
  67cf12:	0f 95 c1             	setne  %cl
  67cf15:	20 c1                	and    %al,%cl
  67cf17:	00 c9                	add    %cl,%cl
  67cf19:	0a 4c 24 38          	or     0x38(%rsp),%cl
  67cf1d:	0f 84 d7 00 00 00    	je     67cffa <<gpui_canvas::text::planner::Planner>::shape+0x45a>
  67cf23:	8b 44 24 28          	mov    0x28(%rsp),%eax
  67cf27:	08 c8                	or     %cl,%al
  67cf29:	89 44 24 28          	mov    %eax,0x28(%rsp)
  67cf2d:	4c 8b a4 24 40 01 00 	mov    0x140(%rsp),%r12
  67cf34:	00 
  67cf35:	4d 39 e6             	cmp    %r12,%r14
  67cf38:	48 89 ef             	mov    %rbp,%rdi
  67cf3b:	4c 89 ee             	mov    %r13,%rsi
  67cf3e:	49 89 d8             	mov    %rbx,%r8
  67cf41:	0f 85 42 fd ff ff    	jne    67cc89 <<gpui_canvas::text::planner::Planner>::shape+0xe9>
  67cf47:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  67cf4b:	f6 c1 01             	test   $0x1,%cl
  67cf4e:	0f 84 c7 00 00 00    	je     67d01b <<gpui_canvas::text::planner::Planner>::shape+0x47b>
  67cf54:	48 8b 04 24          	mov    (%rsp),%rax
  67cf58:	48 83 b8 48 0a 00 00 	cmpq   $0x0,0xa48(%rax)
  67cf5f:	00 
  67cf60:	0f 85 b5 00 00 00    	jne    67d01b <<gpui_canvas::text::planner::Planner>::shape+0x47b>
  67cf66:	48 8d 35 2b f1 10 00 	lea    0x10f12b(%rip),%rsi        # 78c098 <gpui_canvas::text::ARABIC_FONT>
  67cf6d:	48 8d 15 28 8b 9a ff 	lea    -0x6574d8(%rip),%rdx        # 25a9c <gpui_canvas::text::ARABIC_BYTES>
  67cf74:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67cf7b:	00 
  67cf7c:	b9 48 ab 03 00       	mov    $0x3ab48,%ecx
  67cf81:	45 31 c0             	xor    %r8d,%r8d
  67cf84:	e8 37 6d fe ff       	call   663cc0 <<gpui_canvas::text::FontFace>::shared_static>
  67cf89:	83 bc 24 e0 06 00 00 	cmpl   $0x1,0x6e0(%rsp)
  67cf90:	01 
  67cf91:	75 19                	jne    67cfac <<gpui_canvas::text::planner::Planner>::shape+0x40c>
  67cf93:	44 8b a4 24 e4 06 00 	mov    0x6e4(%rsp),%r12d
  67cf9a:	00 
  67cf9b:	44 8b bc 24 e8 06 00 	mov    0x6e8(%rsp),%r15d
  67cfa2:	00 
  67cfa3:	eb 55                	jmp    67cffa <<gpui_canvas::text::planner::Planner>::shape+0x45a>
  67cfa5:	31 c9                	xor    %ecx,%ecx
  67cfa7:	e9 86 00 00 00       	jmp    67d032 <<gpui_canvas::text::planner::Planner>::shape+0x492>
  67cfac:	48 8b 04 24          	mov    (%rsp),%rax
  67cfb0:	4c 8d b8 48 0a 00 00 	lea    0xa48(%rax),%r15
  67cfb7:	4c 8b a4 24 e8 06 00 	mov    0x6e8(%rsp),%r12
  67cfbe:	00 
  67cfbf:	49 8b 07             	mov    (%r15),%rax
  67cfc2:	48 85 c0             	test   %rax,%rax
  67cfc5:	74 0f                	je     67cfd6 <<gpui_canvas::text::planner::Planner>::shape+0x436>
  67cfc7:	f0 48 ff 08          	lock decq (%rax)
  67cfcb:	75 09                	jne    67cfd6 <<gpui_canvas::text::planner::Planner>::shape+0x436>
  67cfcd:	4c 89 ff             	mov    %r15,%rdi
  67cfd0:	ff 15 a2 c0 10 00    	call   *0x10c0a2(%rip)        # 789078 <_DYNAMIC+0x260>
  67cfd6:	48 8b 3c 24          	mov    (%rsp),%rdi
  67cfda:	4c 89 a7 48 0a 00 00 	mov    %r12,0xa48(%rdi)
  67cfe1:	be 01 00 00 00       	mov    $0x1,%esi
  67cfe6:	e8 b5 35 00 00       	call   6805a0 <<gpui_canvas::text::planner::Planner>::register>
  67cfeb:	83 f8 ff             	cmp    $0xffffffff,%eax
  67cfee:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  67cff2:	74 27                	je     67d01b <<gpui_canvas::text::planner::Planner>::shape+0x47b>
  67cff4:	41 89 c4             	mov    %eax,%r12d
  67cff7:	45 31 ff             	xor    %r15d,%r15d
  67cffa:	44 89 a4 24 98 00 00 	mov    %r12d,0x98(%rsp)
  67d001:	00 
  67d002:	44 89 bc 24 9c 00 00 	mov    %r15d,0x9c(%rsp)
  67d009:	00 
  67d00a:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67d011:	00 ff ff ff ff 
  67d016:	e9 bc 2e 00 00       	jmp    67fed7 <<gpui_canvas::text::planner::Planner>::shape+0x3337>
  67d01b:	f6 c1 02             	test   $0x2,%cl
  67d01e:	74 12                	je     67d032 <<gpui_canvas::text::planner::Planner>::shape+0x492>
  67d020:	48 8b 04 24          	mov    (%rsp),%rax
  67d024:	48 83 b8 50 0a 00 00 	cmpq   $0x0,0xa50(%rax)
  67d02b:	00 
  67d02c:	0f 84 03 26 00 00    	je     67f635 <<gpui_canvas::text::planner::Planner>::shape+0x2a95>
  67d032:	48 c7 84 24 98 02 00 	movq   $0xffffffffffffffff,0x298(%rsp)
  67d039:	00 ff ff ff ff 
  67d03e:	48 8d 05 75 ea bd ff 	lea    -0x42158b(%rip),%rax        # 25baba <anon.64833d011ffcdbd320bea14ca6b085cb.71.llvm.13881470238705795165+0x2bd>
  67d045:	48 89 84 24 a0 02 00 	mov    %rax,0x2a0(%rsp)
  67d04c:	00 
  67d04d:	48 c7 84 24 a8 02 00 	movq   $0xc,0x2a8(%rsp)
  67d054:	00 0c 00 00 00 
  67d059:	48 c7 84 24 b0 02 00 	movq   $0xffffffffffffffff,0x2b0(%rsp)
  67d060:	00 ff ff ff ff 
  67d065:	48 8d 05 5a ea bd ff 	lea    -0x4215a6(%rip),%rax        # 25bac6 <anon.64833d011ffcdbd320bea14ca6b085cb.71.llvm.13881470238705795165+0x2c9>
  67d06c:	48 89 84 24 b8 02 00 	mov    %rax,0x2b8(%rsp)
  67d073:	00 
  67d074:	48 c7 84 24 c0 02 00 	movq   $0x11,0x2c0(%rsp)
  67d07b:	00 11 00 00 00 
  67d080:	48 c7 84 24 c8 02 00 	movq   $0xffffffffffffffff,0x2c8(%rsp)
  67d087:	00 ff ff ff ff 
  67d08c:	4c 8d 35 44 ea bd ff 	lea    -0x4215bc(%rip),%r14        # 25bad7 <anon.64833d011ffcdbd320bea14ca6b085cb.71.llvm.13881470238705795165+0x2da>
  67d093:	4c 89 b4 24 d0 02 00 	mov    %r14,0x2d0(%rsp)
  67d09a:	00 
  67d09b:	48 c7 84 24 d8 02 00 	movq   $0x11,0x2d8(%rsp)
  67d0a2:	00 11 00 00 00 
  67d0a7:	f6 c1 01             	test   $0x1,%cl
  67d0aa:	75 1c                	jne    67d0c8 <<gpui_canvas::text::planner::Planner>::shape+0x528>
  67d0ac:	4c 8d bc 24 b0 02 00 	lea    0x2b0(%rsp),%r15
  67d0b3:	00 
  67d0b4:	b8 01 00 00 00       	mov    $0x1,%eax
  67d0b9:	48 89 84 24 f8 01 00 	mov    %rax,0x1f8(%rsp)
  67d0c0:	00 
  67d0c1:	f6 c1 02             	test   $0x2,%cl
  67d0c4:	75 24                	jne    67d0ea <<gpui_canvas::text::planner::Planner>::shape+0x54a>
  67d0c6:	eb 5a                	jmp    67d122 <<gpui_canvas::text::planner::Planner>::shape+0x582>
  67d0c8:	4c 8d bc 24 c8 02 00 	lea    0x2c8(%rsp),%r15
  67d0cf:	00 
  67d0d0:	48 89 84 24 b8 02 00 	mov    %rax,0x2b8(%rsp)
  67d0d7:	00 
  67d0d8:	b8 02 00 00 00       	mov    $0x2,%eax
  67d0dd:	48 89 84 24 f8 01 00 	mov    %rax,0x1f8(%rsp)
  67d0e4:	00 
  67d0e5:	f6 c1 02             	test   $0x2,%cl
  67d0e8:	74 38                	je     67d122 <<gpui_canvas::text::planner::Planner>::shape+0x582>
  67d0ea:	49 8b 37             	mov    (%r15),%rsi
  67d0ed:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  67d0f1:	77 14                	ja     67d107 <<gpui_canvas::text::planner::Planner>::shape+0x567>
  67d0f3:	48 85 f6             	test   %rsi,%rsi
  67d0f6:	74 0f                	je     67d107 <<gpui_canvas::text::planner::Planner>::shape+0x567>
  67d0f8:	49 8b 7f 08          	mov    0x8(%r15),%rdi
  67d0fc:	ba 01 00 00 00       	mov    $0x1,%edx
  67d101:	ff 15 49 bf 10 00    	call   *0x10bf49(%rip)        # 789050 <_DYNAMIC+0x238>
  67d107:	49 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%r15)
  67d10e:	4d 89 77 08          	mov    %r14,0x8(%r15)
  67d112:	49 c7 47 10 11 00 00 	movq   $0x11,0x10(%r15)
  67d119:	00 
  67d11a:	48 ff 84 24 f8 01 00 	incq   0x1f8(%rsp)
  67d121:	00 
  67d122:	48 c7 84 24 d8 00 00 	movq   $0x0,0xd8(%rsp)
  67d129:	00 00 00 00 00 
  67d12e:	48 c7 84 24 e0 00 00 	movq   $0x4,0xe0(%rsp)
  67d135:	00 04 00 00 00 
  67d13a:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  67d141:	00 00 00 00 00 
  67d146:	48 c7 84 24 48 01 00 	movq   $0xffffffffffffffff,0x148(%rsp)
  67d14d:	00 ff ff ff ff 
  67d152:	f6 84 24 a8 01 00 00 	testb  $0x1,0x1a8(%rsp)
  67d159:	01 
  67d15a:	75 11                	jne    67d16d <<gpui_canvas::text::planner::Planner>::shape+0x5cd>
  67d15c:	f3 0f 10 05 78 06 9a 	movss  -0x65f988(%rip),%xmm0        # 1d7dc <GCC_except_table0+0x98>
  67d163:	ff 
  67d164:	f3 0f 11 84 24 ac 01 	movss  %xmm0,0x1ac(%rsp)
  67d16b:	00 00 
  67d16d:	48 8b 04 24          	mov    (%rsp),%rax
  67d171:	48 8d 48 78          	lea    0x78(%rax),%rcx
  67d175:	48 89 8c 24 70 03 00 	mov    %rcx,0x370(%rsp)
  67d17c:	00 
  67d17d:	48 8d 88 38 06 00 00 	lea    0x638(%rax),%rcx
  67d184:	48 89 8c 24 68 03 00 	mov    %rcx,0x368(%rsp)
  67d18b:	00 
  67d18c:	48 05 c8 08 00 00    	add    $0x8c8,%rax
  67d192:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  67d197:	4c 8d b4 24 f0 02 00 	lea    0x2f0(%rsp),%r14
  67d19e:	00 
  67d19f:	0f 57 c0             	xorps  %xmm0,%xmm0
  67d1a2:	0f 29 84 24 70 02 00 	movaps %xmm0,0x270(%rsp)
  67d1a9:	00 
  67d1aa:	f3 0f 11 44 24 50    	movss  %xmm0,0x50(%rsp)
  67d1b0:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  67d1b6:	4c 8d a4 24 98 04 00 	lea    0x498(%rsp),%r12
  67d1bd:	00 
  67d1be:	48 8d 05 eb 1f 10 00 	lea    0x101feb(%rip),%rax        # 77f1b0 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x5c0>
  67d1c5:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  67d1ca:	48 8d 05 d7 22 10 00 	lea    0x1022d7(%rip),%rax        # 77f4a8 <anon.d4a86088305c8823b863e6abd2e38045.35.llvm.4134324091787671213>
  67d1d1:	48 89 84 24 60 02 00 	mov    %rax,0x260(%rsp)
  67d1d8:	00 
  67d1d9:	48 c7 84 24 f0 01 00 	movq   $0x0,0x1f0(%rsp)
  67d1e0:	00 00 00 00 00 
  67d1e5:	31 db                	xor    %ebx,%ebx
  67d1e7:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  67d1ee:	00 
  67d1ef:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  67d1f4:	31 c0                	xor    %eax,%eax
  67d1f6:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  67d1fb:	83 fe fe             	cmp    $0xfffffffe,%esi
  67d1fe:	75 20                	jne    67d220 <<gpui_canvas::text::planner::Planner>::shape+0x680>
  67d200:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
  67d205:	4c 3b 8c 24 40 01 00 	cmp    0x140(%rsp),%r9
  67d20c:	00 
  67d20d:	74 25                	je     67d234 <<gpui_canvas::text::planner::Planner>::shape+0x694>
  67d20f:	41 0f b6 09          	movzbl (%r9),%ecx
  67d213:	84 c9                	test   %cl,%cl
  67d215:	78 38                	js     67d24f <<gpui_canvas::text::planner::Planner>::shape+0x6af>
  67d217:	49 8d 51 01          	lea    0x1(%r9),%rdx
  67d21b:	e9 8c 00 00 00       	jmp    67d2ac <<gpui_canvas::text::planner::Planner>::shape+0x70c>
  67d220:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  67d225:	89 f1                	mov    %esi,%ecx
  67d227:	4c 8b 84 24 50 03 00 	mov    0x350(%rsp),%r8
  67d22e:	00 
  67d22f:	e9 81 00 00 00       	jmp    67d2b5 <<gpui_canvas::text::planner::Planner>::shape+0x715>
  67d234:	c7 44 24 74 fe ff ff 	movl   $0xfffffffe,0x74(%rsp)
  67d23b:	ff 
  67d23c:	b1 01                	mov    $0x1,%cl
  67d23e:	89 4c 24 44          	mov    %ecx,0x44(%rsp)
  67d242:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  67d247:	48 89 de             	mov    %rbx,%rsi
  67d24a:	e9 ea 01 00 00       	jmp    67d439 <<gpui_canvas::text::planner::Planner>::shape+0x899>
  67d24f:	49 89 c0             	mov    %rax,%r8
  67d252:	89 c8                	mov    %ecx,%eax
  67d254:	83 e0 1f             	and    $0x1f,%eax
  67d257:	41 0f b6 79 01       	movzbl 0x1(%r9),%edi
  67d25c:	83 e7 3f             	and    $0x3f,%edi
  67d25f:	80 f9 e0             	cmp    $0xe0,%cl
  67d262:	72 2d                	jb     67d291 <<gpui_canvas::text::planner::Planner>::shape+0x6f1>
  67d264:	41 0f b6 71 02       	movzbl 0x2(%r9),%esi
  67d269:	c1 e7 06             	shl    $0x6,%edi
  67d26c:	83 e6 3f             	and    $0x3f,%esi
  67d26f:	09 fe                	or     %edi,%esi
  67d271:	80 f9 f0             	cmp    $0xf0,%cl
  67d274:	72 28                	jb     67d29e <<gpui_canvas::text::planner::Planner>::shape+0x6fe>
  67d276:	49 8d 51 04          	lea    0x4(%r9),%rdx
  67d27a:	41 0f b6 49 03       	movzbl 0x3(%r9),%ecx
  67d27f:	83 e0 07             	and    $0x7,%eax
  67d282:	c1 e0 12             	shl    $0x12,%eax
  67d285:	c1 e6 06             	shl    $0x6,%esi
  67d288:	83 e1 3f             	and    $0x3f,%ecx
  67d28b:	09 f1                	or     %esi,%ecx
  67d28d:	09 c1                	or     %eax,%ecx
  67d28f:	eb 18                	jmp    67d2a9 <<gpui_canvas::text::planner::Planner>::shape+0x709>
  67d291:	49 8d 51 02          	lea    0x2(%r9),%rdx
  67d295:	c1 e0 06             	shl    $0x6,%eax
  67d298:	09 f8                	or     %edi,%eax
  67d29a:	89 c1                	mov    %eax,%ecx
  67d29c:	eb 0b                	jmp    67d2a9 <<gpui_canvas::text::planner::Planner>::shape+0x709>
  67d29e:	49 8d 51 03          	lea    0x3(%r9),%rdx
  67d2a2:	c1 e0 0c             	shl    $0xc,%eax
  67d2a5:	09 c6                	or     %eax,%esi
  67d2a7:	89 f1                	mov    %esi,%ecx
  67d2a9:	4c 89 c0             	mov    %r8,%rax
  67d2ac:	49 89 c0             	mov    %rax,%r8
  67d2af:	4c 29 c8             	sub    %r9,%rax
  67d2b2:	48 01 d0             	add    %rdx,%rax
  67d2b5:	c7 44 24 74 fe ff ff 	movl   $0xfffffffe,0x74(%rsp)
  67d2bc:	ff 
  67d2bd:	40 b6 01             	mov    $0x1,%sil
  67d2c0:	89 74 24 44          	mov    %esi,0x44(%rsp)
  67d2c4:	83 f9 0c             	cmp    $0xc,%ecx
  67d2c7:	7e 27                	jle    67d2f0 <<gpui_canvas::text::planner::Planner>::shape+0x750>
  67d2c9:	83 f9 0d             	cmp    $0xd,%ecx
  67d2cc:	0f 84 39 01 00 00    	je     67d40b <<gpui_canvas::text::planner::Planner>::shape+0x86b>
  67d2d2:	81 f9 85 00 00 00    	cmp    $0x85,%ecx
  67d2d8:	74 24                	je     67d2fe <<gpui_canvas::text::planner::Planner>::shape+0x75e>
  67d2da:	81 f9 29 20 00 00    	cmp    $0x2029,%ecx
  67d2e0:	74 1c                	je     67d2fe <<gpui_canvas::text::planner::Planner>::shape+0x75e>
  67d2e2:	eb 69                	jmp    67d34d <<gpui_canvas::text::planner::Planner>::shape+0x7ad>
  67d2e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  67d2eb:	00 00 00 00 00 
  67d2f0:	83 f9 ff             	cmp    $0xffffffff,%ecx
  67d2f3:	0f 84 03 01 00 00    	je     67d3fc <<gpui_canvas::text::planner::Planner>::shape+0x85c>
  67d2f9:	83 f9 0a             	cmp    $0xa,%ecx
  67d2fc:	75 4f                	jne    67d34d <<gpui_canvas::text::planner::Planner>::shape+0x7ad>
  67d2fe:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  67d303:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
  67d309:	0f 83 0d 01 00 00    	jae    67d41c <<gpui_canvas::text::planner::Planner>::shape+0x87c>
  67d30f:	49 8d 70 01          	lea    0x1(%r8),%rsi
  67d313:	83 f9 0d             	cmp    $0xd,%ecx
  67d316:	0f 84 63 20 00 00    	je     67f37f <<gpui_canvas::text::planner::Planner>::shape+0x27df>
  67d31c:	4d 89 c7             	mov    %r8,%r15
  67d31f:	e9 0d 01 00 00       	jmp    67d431 <<gpui_canvas::text::planner::Planner>::shape+0x891>
  67d324:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  67d32b:	00 00 00 00 00 
  67d330:	81 f9 29 20 00 00    	cmp    $0x2029,%ecx
  67d336:	0f 84 d4 00 00 00    	je     67d410 <<gpui_canvas::text::planner::Planner>::shape+0x870>
  67d33c:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  67d341:	81 f9 85 00 00 00    	cmp    $0x85,%ecx
  67d347:	0f 84 c3 00 00 00    	je     67d410 <<gpui_canvas::text::planner::Planner>::shape+0x870>
  67d34d:	48 3b 94 24 40 01 00 	cmp    0x140(%rsp),%rdx
  67d354:	00 
  67d355:	0f 84 a1 00 00 00    	je     67d3fc <<gpui_canvas::text::planner::Planner>::shape+0x85c>
  67d35b:	49 89 c0             	mov    %rax,%r8
  67d35e:	0f b6 0a             	movzbl (%rdx),%ecx
  67d361:	84 c9                	test   %cl,%cl
  67d363:	78 0b                	js     67d370 <<gpui_canvas::text::planner::Planner>::shape+0x7d0>
  67d365:	48 8d 42 01          	lea    0x1(%rdx),%rax
  67d369:	eb 65                	jmp    67d3d0 <<gpui_canvas::text::planner::Planner>::shape+0x830>
  67d36b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  67d370:	89 c8                	mov    %ecx,%eax
  67d372:	83 e0 1f             	and    $0x1f,%eax
  67d375:	0f b6 7a 01          	movzbl 0x1(%rdx),%edi
  67d379:	83 e7 3f             	and    $0x3f,%edi
  67d37c:	80 f9 df             	cmp    $0xdf,%cl
  67d37f:	76 2e                	jbe    67d3af <<gpui_canvas::text::planner::Planner>::shape+0x80f>
  67d381:	0f b6 72 02          	movzbl 0x2(%rdx),%esi
  67d385:	c1 e7 06             	shl    $0x6,%edi
  67d388:	83 e6 3f             	and    $0x3f,%esi
  67d38b:	09 fe                	or     %edi,%esi
  67d38d:	80 f9 f0             	cmp    $0xf0,%cl
  67d390:	72 2d                	jb     67d3bf <<gpui_canvas::text::planner::Planner>::shape+0x81f>
  67d392:	48 8d 7a 04          	lea    0x4(%rdx),%rdi
  67d396:	0f b6 4a 03          	movzbl 0x3(%rdx),%ecx
  67d39a:	83 e0 07             	and    $0x7,%eax
  67d39d:	c1 e0 12             	shl    $0x12,%eax
  67d3a0:	c1 e6 06             	shl    $0x6,%esi
  67d3a3:	83 e1 3f             	and    $0x3f,%ecx
  67d3a6:	09 f1                	or     %esi,%ecx
  67d3a8:	09 c1                	or     %eax,%ecx
  67d3aa:	48 89 f8             	mov    %rdi,%rax
  67d3ad:	eb 21                	jmp    67d3d0 <<gpui_canvas::text::planner::Planner>::shape+0x830>
  67d3af:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  67d3b3:	c1 e0 06             	shl    $0x6,%eax
  67d3b6:	09 f8                	or     %edi,%eax
  67d3b8:	89 c1                	mov    %eax,%ecx
  67d3ba:	48 89 f0             	mov    %rsi,%rax
  67d3bd:	eb 11                	jmp    67d3d0 <<gpui_canvas::text::planner::Planner>::shape+0x830>
  67d3bf:	48 8d 4a 03          	lea    0x3(%rdx),%rcx
  67d3c3:	c1 e0 0c             	shl    $0xc,%eax
  67d3c6:	09 c6                	or     %eax,%esi
  67d3c8:	48 89 c8             	mov    %rcx,%rax
  67d3cb:	89 f1                	mov    %esi,%ecx
  67d3cd:	0f 1f 00             	nopl   (%rax)
  67d3d0:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  67d3d5:	48 29 d0             	sub    %rdx,%rax
  67d3d8:	4c 01 c0             	add    %r8,%rax
  67d3db:	81 f9 84 00 00 00    	cmp    $0x84,%ecx
  67d3e1:	0f 8f 49 ff ff ff    	jg     67d330 <<gpui_canvas::text::planner::Planner>::shape+0x790>
  67d3e7:	83 f9 0a             	cmp    $0xa,%ecx
  67d3ea:	74 24                	je     67d410 <<gpui_canvas::text::planner::Planner>::shape+0x870>
  67d3ec:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  67d3f1:	83 f9 0d             	cmp    $0xd,%ecx
  67d3f4:	0f 85 53 ff ff ff    	jne    67d34d <<gpui_canvas::text::planner::Planner>::shape+0x7ad>
  67d3fa:	eb 14                	jmp    67d410 <<gpui_canvas::text::planner::Planner>::shape+0x870>
  67d3fc:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  67d401:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  67d406:	48 89 de             	mov    %rbx,%rsi
  67d409:	eb 2e                	jmp    67d439 <<gpui_canvas::text::planner::Planner>::shape+0x899>
  67d40b:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  67d410:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
  67d416:	0f 82 f3 fe ff ff    	jb     67d30f <<gpui_canvas::text::planner::Planner>::shape+0x76f>
  67d41c:	81 f9 00 08 00 00    	cmp    $0x800,%ecx
  67d422:	be 03 00 00 00       	mov    $0x3,%esi
  67d427:	48 83 de 00          	sbb    $0x0,%rsi
  67d42b:	4d 89 c7             	mov    %r8,%r15
  67d42e:	4c 01 c6             	add    %r8,%rsi
  67d431:	c7 44 24 44 00 00 00 	movl   $0x0,0x44(%rsp)
  67d438:	00 
  67d439:	4c 89 f9             	mov    %r15,%rcx
  67d43c:	48 29 d9             	sub    %rbx,%rcx
  67d43f:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  67d444:	0f 82 1c 2c 00 00    	jb     680066 <<gpui_canvas::text::planner::Planner>::shape+0x34c6>
  67d44a:	48 85 db             	test   %rbx,%rbx
  67d44d:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  67d454:	00 
  67d455:	74 2f                	je     67d486 <<gpui_canvas::text::planner::Planner>::shape+0x8e6>
  67d457:	48 3b 5c 24 48       	cmp    0x48(%rsp),%rbx
  67d45c:	73 22                	jae    67d480 <<gpui_canvas::text::planner::Planner>::shape+0x8e0>
  67d45e:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  67d465:	00 
  67d466:	80 3c 18 bf          	cmpb   $0xbf,(%rax,%rbx,1)
  67d46a:	7f 1a                	jg     67d486 <<gpui_canvas::text::planner::Planner>::shape+0x8e6>
  67d46c:	e9 f5 2b 00 00       	jmp    680066 <<gpui_canvas::text::planner::Planner>::shape+0x34c6>
  67d471:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67d478:	0f 1f 84 00 00 00 00 
  67d47f:	00 
  67d480:	0f 85 e0 2b 00 00    	jne    680066 <<gpui_canvas::text::planner::Planner>::shape+0x34c6>
  67d486:	4d 85 ff             	test   %r15,%r15
  67d489:	74 2b                	je     67d4b6 <<gpui_canvas::text::planner::Planner>::shape+0x916>
  67d48b:	4c 3b 7c 24 48       	cmp    0x48(%rsp),%r15
  67d490:	73 1e                	jae    67d4b0 <<gpui_canvas::text::planner::Planner>::shape+0x910>
  67d492:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  67d499:	00 
  67d49a:	42 80 3c 38 c0       	cmpb   $0xc0,(%rax,%r15,1)
  67d49f:	7d 15                	jge    67d4b6 <<gpui_canvas::text::planner::Planner>::shape+0x916>
  67d4a1:	e9 c0 2b 00 00       	jmp    680066 <<gpui_canvas::text::planner::Planner>::shape+0x34c6>
  67d4a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  67d4ad:	00 00 00 
  67d4b0:	0f 85 b0 2b 00 00    	jne    680066 <<gpui_canvas::text::planner::Planner>::shape+0x34c6>
  67d4b6:	48 89 b4 24 58 03 00 	mov    %rsi,0x358(%rsp)
  67d4bd:	00 
  67d4be:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  67d4c5:	00 
  67d4c6:	48 8d 0c 18          	lea    (%rax,%rbx,1),%rcx
  67d4ca:	48 8d bc 24 68 04 00 	lea    0x468(%rsp),%rdi
  67d4d1:	00 
  67d4d2:	48 8b b4 24 70 03 00 	mov    0x370(%rsp),%rsi
  67d4d9:	00 
  67d4da:	48 8b 94 24 68 03 00 	mov    0x368(%rsp),%rdx
  67d4e1:	00 
  67d4e2:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  67d4e7:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
  67d4ec:	f3 0f 10 05 78 02 9a 	movss  -0x65fd88(%rip),%xmm0        # 1d76c <GCC_except_table0+0x28>
  67d4f3:	ff 
  67d4f4:	45 31 c9             	xor    %r9d,%r9d
  67d4f7:	e8 14 6d fe ff       	call   664210 <<parley::context::LayoutContext<()>>::ranged_builder>
  67d4fc:	48 8d bc 24 68 04 00 	lea    0x468(%rsp),%rdi
  67d503:	00 
  67d504:	48 8d b4 24 98 02 00 	lea    0x298(%rsp),%rsi
  67d50b:	00 
  67d50c:	48 8b 94 24 f8 01 00 	mov    0x1f8(%rsp),%rdx
  67d513:	00 
  67d514:	e8 17 65 ff ff       	call   673a30 <<parley::builder::RangedBuilder<()>>::push_default::<&[parlance::font_family::FontFamilyName]>>
  67d519:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  67d51f:	f3 0f 11 84 24 e4 06 	movss  %xmm0,0x6e4(%rsp)
  67d526:	00 00 
  67d528:	c6 84 24 e0 06 00 00 	movb   $0x1,0x6e0(%rsp)
  67d52f:	01 
  67d530:	48 8d bc 24 68 04 00 	lea    0x468(%rsp),%rdi
  67d537:	00 
  67d538:	48 8d b4 24 e0 06 00 	lea    0x6e0(%rsp),%rsi
  67d53f:	00 
  67d540:	e8 bb 63 ff ff       	call   673900 <<parley::builder::RangedBuilder<()>>::push_default::<parley::style::StyleProperty<()>>>
  67d545:	66 c7 84 24 e0 06 00 	movw   $0x117,0x6e0(%rsp)
  67d54c:	00 17 01 
  67d54f:	48 8d bc 24 68 04 00 	lea    0x468(%rsp),%rdi
  67d556:	00 
  67d557:	48 8d b4 24 e0 06 00 	lea    0x6e0(%rsp),%rsi
  67d55e:	00 
  67d55f:	e8 9c 63 ff ff       	call   673900 <<parley::builder::RangedBuilder<()>>::push_default::<parley::style::StyleProperty<()>>>
  67d564:	48 8d bc 24 68 04 00 	lea    0x468(%rsp),%rdi
  67d56b:	00 
  67d56c:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  67d571:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  67d576:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  67d57b:	e8 10 37 ff ff       	call   670c90 <<parley::builder::RangedBuilder<()>>::build_into::<&str>>
  67d580:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67d587:	00 
  67d588:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  67d58d:	e8 de ce ff ff       	call   67a470 <<parley::layout::line_break::BreakLines<()>>::new>
  67d592:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67d599:	00 
  67d59a:	f3 0f 10 84 24 ac 01 	movss  0x1ac(%rsp),%xmm0
  67d5a1:	00 00 
  67d5a3:	e8 a8 bf ff ff       	call   679550 <<parley::layout::line_break::BreakLines<()>>::break_remaining>
  67d5a8:	80 bc 24 1c 02 00 00 	cmpb   $0x0,0x21c(%rsp)
  67d5af:	00 
  67d5b0:	74 1e                	je     67d5d0 <<gpui_canvas::text::planner::Planner>::shape+0xa30>
  67d5b2:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  67d5b9:	00 ff 
  67d5bb:	0f 85 ff 01 00 00    	jne    67d7c0 <<gpui_canvas::text::planner::Planner>::shape+0xc20>
  67d5c1:	31 c0                	xor    %eax,%eax
  67d5c3:	e9 7e 01 00 00       	jmp    67d746 <<gpui_canvas::text::planner::Planner>::shape+0xba6>
  67d5c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  67d5cf:	00 
  67d5d0:	48 85 db             	test   %rbx,%rbx
  67d5d3:	0f 85 57 01 00 00    	jne    67d730 <<gpui_canvas::text::planner::Planner>::shape+0xb90>
  67d5d9:	4c 3b 7c 24 48       	cmp    0x48(%rsp),%r15
  67d5de:	0f 85 4c 01 00 00    	jne    67d730 <<gpui_canvas::text::planner::Planner>::shape+0xb90>
  67d5e4:	48 8b 04 24          	mov    (%rsp),%rax
  67d5e8:	48 83 b8 e0 09 00 00 	cmpq   $0x1,0x9e0(%rax)
  67d5ef:	01 
  67d5f0:	0f 85 3a 01 00 00    	jne    67d730 <<gpui_canvas::text::planner::Planner>::shape+0xb90>
  67d5f6:	48 8b 14 24          	mov    (%rsp),%rdx
  67d5fa:	48 8b 82 d8 09 00 00 	mov    0x9d8(%rdx),%rax
  67d601:	48 8d 48 70          	lea    0x70(%rax),%rcx
  67d605:	48 89 8c 24 e8 06 00 	mov    %rcx,0x6e8(%rsp)
  67d60c:	00 
  67d60d:	48 c7 84 24 f0 06 00 	movq   $0x0,0x6f0(%rsp)
  67d614:	00 00 00 00 00 
  67d619:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  67d61e:	48 89 b4 24 f8 06 00 	mov    %rsi,0x6f8(%rsp)
  67d625:	00 
  67d626:	48 c7 84 24 28 07 00 	movq   $0x0,0x728(%rsp)
  67d62d:	00 00 00 00 00 
  67d632:	48 89 94 24 90 04 00 	mov    %rdx,0x490(%rsp)
  67d639:	00 
  67d63a:	48 c7 84 24 00 07 00 	movq   $0x0,0x700(%rsp)
  67d641:	00 00 00 00 00 
  67d646:	48 89 8c 24 e0 06 00 	mov    %rcx,0x6e0(%rsp)
  67d64d:	00 
  67d64e:	48 8b 78 10          	mov    0x10(%rax),%rdi
  67d652:	48 8b 70 18          	mov    0x18(%rax),%rsi
  67d656:	48 8b 92 f8 09 00 00 	mov    0x9f8(%rdx),%rdx
  67d65d:	48 39 fe             	cmp    %rdi,%rsi
  67d660:	0f 82 ac 26 00 00    	jb     67fd12 <<gpui_canvas::text::planner::Planner>::shape+0x3172>
  67d666:	48 39 d6             	cmp    %rdx,%rsi
  67d669:	0f 87 a3 26 00 00    	ja     67fd12 <<gpui_canvas::text::planner::Planner>::shape+0x3172>
  67d66f:	48 8b 04 24          	mov    (%rsp),%rax
  67d673:	48 8b 80 f0 09 00 00 	mov    0x9f0(%rax),%rax
  67d67a:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  67d67e:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  67d682:	48 8d 14 b6          	lea    (%rsi,%rsi,4),%rdx
  67d686:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  67d68a:	48 89 8c 24 00 07 00 	mov    %rcx,0x700(%rsp)
  67d691:	00 
  67d692:	48 89 84 24 08 07 00 	mov    %rax,0x708(%rsp)
  67d699:	00 
  67d69a:	48 c7 84 24 10 07 00 	movq   $0x0,0x710(%rsp)
  67d6a1:	00 00 00 00 00 
  67d6a6:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  67d6ab:	48 89 84 24 18 07 00 	mov    %rax,0x718(%rsp)
  67d6b2:	00 
  67d6b3:	c7 84 24 20 07 00 00 	movl   $0x0,0x720(%rsp)
  67d6ba:	00 00 00 00 
  67d6be:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  67d6c5:	00 
  67d6c6:	48 8d b4 24 28 07 00 	lea    0x728(%rsp),%rsi
  67d6cd:	00 
  67d6ce:	48 8d 94 24 90 04 00 	lea    0x490(%rsp),%rdx
  67d6d5:	00 
  67d6d6:	e8 45 bf fe ff       	call   669620 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>
  67d6db:	48 c7 84 24 f0 06 00 	movq   $0x1,0x6f0(%rsp)
  67d6e2:	00 01 00 00 00 
  67d6e7:	84 c0                	test   %al,%al
  67d6e9:	75 45                	jne    67d730 <<gpui_canvas::text::planner::Planner>::shape+0xb90>
  67d6eb:	48 c7 84 24 00 07 00 	movq   $0x0,0x700(%rsp)
  67d6f2:	00 00 00 00 00 
  67d6f7:	48 83 bc 24 28 07 00 	cmpq   $0x0,0x728(%rsp)
  67d6fe:	00 00 
  67d700:	0f 84 35 1d 00 00    	je     67f43b <<gpui_canvas::text::planner::Planner>::shape+0x289b>
  67d706:	48 8d bc 24 28 07 00 	lea    0x728(%rsp),%rdi
  67d70d:	00 
  67d70e:	48 8d b4 24 50 07 00 	lea    0x750(%rsp),%rsi
  67d715:	00 
  67d716:	48 8d 94 24 90 04 00 	lea    0x490(%rsp),%rdx
  67d71d:	00 
  67d71e:	e8 fd be fe ff       	call   669620 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>
  67d723:	84 c0                	test   %al,%al
  67d725:	0f 84 10 1d 00 00    	je     67f43b <<gpui_canvas::text::planner::Planner>::shape+0x289b>
  67d72b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  67d730:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  67d737:	00 ff 
  67d739:	0f 85 81 00 00 00    	jne    67d7c0 <<gpui_canvas::text::planner::Planner>::shape+0xc20>
  67d73f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  67d746:	48 c7 84 24 48 01 00 	movq   $0x0,0x148(%rsp)
  67d74d:	00 00 00 00 00 
  67d752:	48 c7 84 24 50 01 00 	movq   $0x4,0x150(%rsp)
  67d759:	00 04 00 00 00 
  67d75e:	48 8d 8c 24 50 01 00 	lea    0x150(%rsp),%rcx
  67d765:	00 
  67d766:	0f 57 c0             	xorps  %xmm0,%xmm0
  67d769:	0f 11 41 08          	movups %xmm0,0x8(%rcx)
  67d76d:	48 c7 84 24 68 01 00 	movq   $0x4,0x168(%rsp)
  67d774:	00 04 00 00 00 
  67d779:	48 c7 84 24 70 01 00 	movq   $0x0,0x170(%rsp)
  67d780:	00 00 00 00 00 
  67d785:	48 89 84 24 78 01 00 	mov    %rax,0x178(%rsp)
  67d78c:	00 
  67d78d:	48 c7 84 24 80 01 00 	movq   $0x4,0x180(%rsp)
  67d794:	00 04 00 00 00 
  67d799:	48 c7 84 24 88 01 00 	movq   $0x0,0x188(%rsp)
  67d7a0:	00 00 00 00 00 
  67d7a5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  67d7aa:	89 84 24 90 01 00 00 	mov    %eax,0x190(%rsp)
  67d7b1:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  67d7b7:	f3 0f 11 84 24 94 01 	movss  %xmm0,0x194(%rsp)
  67d7be:	00 00 
  67d7c0:	4c 89 bc 24 28 01 00 	mov    %r15,0x128(%rsp)
  67d7c7:	00 
  67d7c8:	48 89 9c 24 30 01 00 	mov    %rbx,0x130(%rsp)
  67d7cf:	00 
  67d7d0:	48 8b 04 24          	mov    (%rsp),%rax
  67d7d4:	48 8b 98 e0 09 00 00 	mov    0x9e0(%rax),%rbx
  67d7db:	48 85 db             	test   %rbx,%rbx
  67d7de:	0f 84 0c 01 00 00    	je     67d8f0 <<gpui_canvas::text::planner::Planner>::shape+0xd50>
  67d7e4:	48 8b a8 d8 09 00 00 	mov    0x9d8(%rax),%rbp
  67d7eb:	45 31 ff             	xor    %r15d,%r15d
  67d7ee:	45 31 ed             	xor    %r13d,%r13d
  67d7f1:	eb 19                	jmp    67d80c <<gpui_canvas::text::planner::Planner>::shape+0xc6c>
  67d7f3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67d7fa:	84 00 00 00 00 00 
  67d800:	49 ff c7             	inc    %r15
  67d803:	49 39 df             	cmp    %rbx,%r15
  67d806:	0f 84 e7 00 00 00    	je     67d8f3 <<gpui_canvas::text::planner::Planner>::shape+0xd53>
  67d80c:	49 6b c7 70          	imul   $0x70,%r15,%rax
  67d810:	48 01 e8             	add    %rbp,%rax
  67d813:	4c 89 ac 24 e0 06 00 	mov    %r13,0x6e0(%rsp)
  67d81a:	00 
  67d81b:	48 c7 84 24 e8 06 00 	movq   $0x0,0x6e8(%rsp)
  67d822:	00 00 00 00 00 
  67d827:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  67d82c:	48 89 8c 24 f0 06 00 	mov    %rcx,0x6f0(%rsp)
  67d833:	00 
  67d834:	48 89 84 24 f8 06 00 	mov    %rax,0x6f8(%rsp)
  67d83b:	00 
  67d83c:	44 89 bc 24 00 07 00 	mov    %r15d,0x700(%rsp)
  67d843:	00 
  67d844:	c6 84 24 a8 07 00 00 	movb   $0x2,0x7a8(%rsp)
  67d84b:	02 
  67d84c:	c7 84 24 b0 07 00 00 	movl   $0x0,0x7b0(%rsp)
  67d853:	00 00 00 00 
  67d857:	48 8d bc 24 e0 02 00 	lea    0x2e0(%rsp),%rdi
  67d85e:	00 
  67d85f:	48 8d b4 24 e8 06 00 	lea    0x6e8(%rsp),%rsi
  67d866:	00 
  67d867:	e8 b4 63 00 00       	call   683c20 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  67d86c:	83 bc 24 e0 02 00 00 	cmpl   $0x1,0x2e0(%rsp)
  67d873:	01 
  67d874:	75 8a                	jne    67d800 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  67d876:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  67d87d:	00 00 00 
  67d880:	49 8b 46 38          	mov    0x38(%r14),%rax
  67d884:	49 89 44 24 40       	mov    %rax,0x40(%r12)
  67d889:	41 0f 10 46 f8       	movups -0x8(%r14),%xmm0
  67d88e:	41 0f 10 4e 08       	movups 0x8(%r14),%xmm1
  67d893:	41 0f 10 56 18       	movups 0x18(%r14),%xmm2
  67d898:	41 0f 10 5e 28       	movups 0x28(%r14),%xmm3
  67d89d:	41 0f 11 5c 24 30    	movups %xmm3,0x30(%r12)
  67d8a3:	41 0f 11 54 24 20    	movups %xmm2,0x20(%r12)
  67d8a9:	41 0f 11 4c 24 10    	movups %xmm1,0x10(%r12)
  67d8af:	41 0f 11 04 24       	movups %xmm0,(%r12)
  67d8b4:	4c 89 ac 24 90 04 00 	mov    %r13,0x490(%rsp)
  67d8bb:	00 
  67d8bc:	4c 89 ee             	mov    %r13,%rsi
  67d8bf:	4c 89 e2             	mov    %r12,%rdx
  67d8c2:	e8 b9 c6 fe ff       	call   669f80 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut>
  67d8c7:	49 89 c5             	mov    %rax,%r13
  67d8ca:	48 8d bc 24 e0 02 00 	lea    0x2e0(%rsp),%rdi
  67d8d1:	00 
  67d8d2:	48 8d b4 24 e8 06 00 	lea    0x6e8(%rsp),%rsi
  67d8d9:	00 
  67d8da:	e8 41 63 00 00       	call   683c20 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  67d8df:	80 bc 24 e0 02 00 00 	cmpb   $0x0,0x2e0(%rsp)
  67d8e6:	00 
  67d8e7:	75 97                	jne    67d880 <<gpui_canvas::text::planner::Planner>::shape+0xce0>
  67d8e9:	e9 12 ff ff ff       	jmp    67d800 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  67d8ee:	66 90                	xchg   %ax,%ax
  67d8f0:	45 31 ed             	xor    %r13d,%r13d
  67d8f3:	48 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%rsi
  67d8fa:	00 
  67d8fb:	48 89 f0             	mov    %rsi,%rax
  67d8fe:	4c 01 e8             	add    %r13,%rax
  67d901:	0f 92 c1             	setb   %cl
  67d904:	48 3d 01 80 00 00    	cmp    $0x8001,%rax
  67d90a:	0f 93 c0             	setae  %al
  67d90d:	08 c8                	or     %cl,%al
  67d90f:	0f 85 c4 1c 00 00    	jne    67f5d9 <<gpui_canvas::text::planner::Planner>::shape+0x2a39>
  67d915:	48 8b ac 24 30 01 00 	mov    0x130(%rsp),%rbp
  67d91c:	00 
  67d91d:	4c 8b bc 24 28 01 00 	mov    0x128(%rsp),%r15
  67d924:	00 
  67d925:	49 39 ef             	cmp    %rbp,%r15
  67d928:	74 14                	je     67d93e <<gpui_canvas::text::planner::Planner>::shape+0xd9e>
  67d92a:	48 8b 84 24 d8 00 00 	mov    0xd8(%rsp),%rax
  67d931:	00 
  67d932:	48 29 f0             	sub    %rsi,%rax
  67d935:	49 39 c5             	cmp    %rax,%r13
  67d938:	0f 87 35 1c 00 00    	ja     67f573 <<gpui_canvas::text::planner::Planner>::shape+0x29d3>
  67d93e:	48 85 ed             	test   %rbp,%rbp
  67d941:	74 26                	je     67d969 <<gpui_canvas::text::planner::Planner>::shape+0xdc9>
  67d943:	0f 57 c0             	xorps  %xmm0,%xmm0
  67d946:	f3 0f 11 84 24 c8 00 	movss  %xmm0,0xc8(%rsp)
  67d94d:	00 00 
  67d94f:	49 39 ef             	cmp    %rbp,%r15
  67d952:	75 4b                	jne    67d99f <<gpui_canvas::text::planner::Planner>::shape+0xdff>
  67d954:	48 8b 0c 24          	mov    (%rsp),%rcx
  67d958:	48 8b 81 e0 09 00 00 	mov    0x9e0(%rcx),%rax
  67d95f:	48 85 c0             	test   %rax,%rax
  67d962:	75 7c                	jne    67d9e0 <<gpui_canvas::text::planner::Planner>::shape+0xe40>
  67d964:	e9 9e 14 00 00       	jmp    67ee07 <<gpui_canvas::text::planner::Planner>::shape+0x2267>
  67d969:	48 8b 04 24          	mov    (%rsp),%rax
  67d96d:	48 83 b8 e0 09 00 00 	cmpq   $0x0,0x9e0(%rax)
  67d974:	00 
  67d975:	74 0e                	je     67d985 <<gpui_canvas::text::planner::Planner>::shape+0xde5>
  67d977:	48 8b 80 d8 09 00 00 	mov    0x9d8(%rax),%rax
  67d97e:	f3 0f 10 40 24       	movss  0x24(%rax),%xmm0
  67d983:	eb 03                	jmp    67d988 <<gpui_canvas::text::planner::Planner>::shape+0xde8>
  67d985:	0f 57 c0             	xorps  %xmm0,%xmm0
  67d988:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  67d98e:	0f 57 c0             	xorps  %xmm0,%xmm0
  67d991:	f3 0f 11 84 24 c8 00 	movss  %xmm0,0xc8(%rsp)
  67d998:	00 00 
  67d99a:	49 39 ef             	cmp    %rbp,%r15
  67d99d:	74 b5                	je     67d954 <<gpui_canvas::text::planner::Planner>::shape+0xdb4>
  67d99f:	83 bc 24 a8 01 00 00 	cmpl   $0x0,0x1a8(%rsp)
  67d9a6:	00 
  67d9a7:	74 0e                	je     67d9b7 <<gpui_canvas::text::planner::Planner>::shape+0xe17>
  67d9a9:	48 8b 04 24          	mov    (%rsp),%rax
  67d9ad:	f3 0f 10 80 28 0a 00 	movss  0xa28(%rax),%xmm0
  67d9b4:	00 
  67d9b5:	eb 0c                	jmp    67d9c3 <<gpui_canvas::text::planner::Planner>::shape+0xe23>
  67d9b7:	48 8b 04 24          	mov    (%rsp),%rax
  67d9bb:	f3 0f 10 80 2c 0a 00 	movss  0xa2c(%rax),%xmm0
  67d9c2:	00 
  67d9c3:	f3 0f 11 84 24 c8 00 	movss  %xmm0,0xc8(%rsp)
  67d9ca:	00 00 
  67d9cc:	48 8b 0c 24          	mov    (%rsp),%rcx
  67d9d0:	48 8b 81 e0 09 00 00 	mov    0x9e0(%rcx),%rax
  67d9d7:	48 85 c0             	test   %rax,%rax
  67d9da:	0f 84 27 14 00 00    	je     67ee07 <<gpui_canvas::text::planner::Planner>::shape+0x2267>
  67d9e0:	48 8b 89 d8 09 00 00 	mov    0x9d8(%rcx),%rcx
  67d9e7:	48 6b c0 70          	imul   $0x70,%rax,%rax
  67d9eb:	48 89 8c 24 88 00 00 	mov    %rcx,0x88(%rsp)
  67d9f2:	00 
  67d9f3:	48 01 c8             	add    %rcx,%rax
  67d9f6:	48 89 84 24 48 03 00 	mov    %rax,0x348(%rsp)
  67d9fd:	00 
  67d9fe:	c7 44 24 6c 00 00 00 	movl   $0x0,0x6c(%rsp)
  67da05:	00 
  67da06:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  67da0d:	00 ff 
  67da0f:	74 2d                	je     67da3e <<gpui_canvas::text::planner::Planner>::shape+0xe9e>
  67da11:	49 39 ef             	cmp    %rbp,%r15
  67da14:	75 3b                	jne    67da51 <<gpui_canvas::text::planner::Planner>::shape+0xeb1>
  67da16:	31 db                	xor    %ebx,%ebx
  67da18:	45 31 ed             	xor    %r13d,%r13d
  67da1b:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  67da22:	00 
  67da23:	48 8b 8c 24 70 01 00 	mov    0x170(%rsp),%rcx
  67da2a:	00 
  67da2b:	48 89 8c 24 48 02 00 	mov    %rcx,0x248(%rsp)
  67da32:	00 
  67da33:	80 78 68 02          	cmpb   $0x2,0x68(%rax)
  67da37:	74 41                	je     67da7a <<gpui_canvas::text::planner::Planner>::shape+0xeda>
  67da39:	e9 df 01 00 00       	jmp    67dc1d <<gpui_canvas::text::planner::Planner>::shape+0x107d>
  67da3e:	8b 4c 24 6c          	mov    0x6c(%rsp),%ecx
  67da42:	89 c8                	mov    %ecx,%eax
  67da44:	48 89 84 24 48 02 00 	mov    %rax,0x248(%rsp)
  67da4b:	00 
  67da4c:	e9 e4 03 00 00       	jmp    67de35 <<gpui_canvas::text::planner::Planner>::shape+0x1295>
  67da51:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  67da58:	00 
  67da59:	4c 8b 28             	mov    (%rax),%r13
  67da5c:	48 8b 58 08          	mov    0x8(%rax),%rbx
  67da60:	48 8b 8c 24 70 01 00 	mov    0x170(%rsp),%rcx
  67da67:	00 
  67da68:	48 89 8c 24 48 02 00 	mov    %rcx,0x248(%rsp)
  67da6f:	00 
  67da70:	80 78 68 02          	cmpb   $0x2,0x68(%rax)
  67da74:	0f 85 a3 01 00 00    	jne    67dc1d <<gpui_canvas::text::planner::Planner>::shape+0x107d>
  67da7a:	4c 89 6c 24 18       	mov    %r13,0x18(%rsp)
  67da7f:	48 8b 78 10          	mov    0x10(%rax),%rdi
  67da83:	48 8b 70 18          	mov    0x18(%rax),%rsi
  67da87:	48 8b 04 24          	mov    (%rsp),%rax
  67da8b:	48 8b 90 f8 09 00 00 	mov    0x9f8(%rax),%rdx
  67da92:	48 39 fe             	cmp    %rdi,%rsi
  67da95:	0f 82 89 22 00 00    	jb     67fd24 <<gpui_canvas::text::planner::Planner>::shape+0x3184>
  67da9b:	48 39 d6             	cmp    %rdx,%rsi
  67da9e:	0f 87 80 22 00 00    	ja     67fd24 <<gpui_canvas::text::planner::Planner>::shape+0x3184>
  67daa4:	48 8b 04 24          	mov    (%rsp),%rax
  67daa8:	48 8b 80 f0 09 00 00 	mov    0x9f0(%rax),%rax
  67daaf:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  67dab3:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  67dab7:	48 8d 14 b6          	lea    (%rsi,%rsi,4),%rdx
  67dabb:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  67dabf:	48 89 8c 24 90 04 00 	mov    %rcx,0x490(%rsp)
  67dac6:	00 
  67dac7:	48 89 84 24 98 04 00 	mov    %rax,0x498(%rsp)
  67dace:	00 
  67dacf:	48 c7 84 24 a0 04 00 	movq   $0x0,0x4a0(%rsp)
  67dad6:	00 00 00 00 00 
  67dadb:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  67dae0:	48 89 84 24 a8 04 00 	mov    %rax,0x4a8(%rsp)
  67dae7:	00 
  67dae8:	8b 44 24 6c          	mov    0x6c(%rsp),%eax
  67daec:	89 84 24 b0 04 00 00 	mov    %eax,0x4b0(%rsp)
  67daf3:	c6 84 24 d0 06 00 00 	movb   $0x2,0x6d0(%rsp)
  67dafa:	02 
  67dafb:	48 8d 84 24 d8 06 00 	lea    0x6d8(%rsp),%rax
  67db02:	00 
  67db03:	48 89 84 24 e0 02 00 	mov    %rax,0x2e0(%rsp)
  67db0a:	00 
  67db0b:	c6 84 24 c0 05 00 00 	movb   $0x2,0x5c0(%rsp)
  67db12:	02 
  67db13:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67db1a:	00 
  67db1b:	48 8d b4 24 90 04 00 	lea    0x490(%rsp),%rsi
  67db22:	00 
  67db23:	48 8d 94 24 e0 02 00 	lea    0x2e0(%rsp),%rdx
  67db2a:	00 
  67db2b:	48 8d 8c 24 b8 04 00 	lea    0x4b8(%rsp),%rcx
  67db32:	00 
  67db33:	e8 48 b2 fe ff       	call   668d80 <<core::iter::adapters::map::Map<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, gpui_canvas::text::planner::freeze_line::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::flatten::FlattenCompat<_, _>>::iter_try_fold::flatten<parley::layout::run::Clusters<()>, (), core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>, <core::iter::adapters::flatten::FlattenCompat<_, _> as core::iter::traits::iterator::Iterator>::try_fold::flatten<parley::layout::run::Clusters<()>, (), core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>, core::iter::traits::iterator::Iterator::find::check<parley::layout::cluster::Cluster<()>, &mut gpui_canvas::text::planner::freeze_line::{closure#1}>::{closure#0}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>>>
  67db38:	48 8b 8c 24 e0 06 00 	mov    0x6e0(%rsp),%rcx
  67db3f:	00 
  67db40:	48 85 c9             	test   %rcx,%rcx
  67db43:	0f 84 b5 00 00 00    	je     67dbfe <<gpui_canvas::text::planner::Planner>::shape+0x105e>
  67db49:	8b bc 24 08 07 00 00 	mov    0x708(%rsp),%edi
  67db50:	8b b4 24 60 07 00 00 	mov    0x760(%rsp),%esi
  67db57:	8b 94 24 64 07 00 00 	mov    0x764(%rsp),%edx
  67db5e:	48 8b 41 58          	mov    0x58(%rcx),%rax
  67db62:	48 39 f8             	cmp    %rdi,%rax
  67db65:	0f 86 e8 25 00 00    	jbe    680153 <<gpui_canvas::text::planner::Planner>::shape+0x35b3>
  67db6b:	48 8b 41 50          	mov    0x50(%rcx),%rax
  67db6f:	48 8d 3c ff          	lea    (%rdi,%rdi,8),%rdi
  67db73:	48 c1 e7 04          	shl    $0x4,%rdi
  67db77:	0f 10 41 68          	movups 0x68(%rcx),%xmm0
  67db7b:	0f 10 89 80 00 00 00 	movups 0x80(%rcx),%xmm1
  67db82:	0f 10 91 98 00 00 00 	movups 0x98(%rcx),%xmm2
  67db89:	0f 11 84 24 e0 06 00 	movups %xmm0,0x6e0(%rsp)
  67db90:	00 
  67db91:	0f 11 8c 24 f0 06 00 	movups %xmm1,0x6f0(%rsp)
  67db98:	00 
  67db99:	0f 11 94 24 00 07 00 	movups %xmm2,0x700(%rsp)
  67dba0:	00 
  67dba1:	48 8b 44 38 50       	mov    0x50(%rax,%rdi,1),%rax
  67dba6:	48 89 84 24 10 07 00 	mov    %rax,0x710(%rsp)
  67dbad:	00 
  67dbae:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67dbb5:	00 
  67dbb6:	ff 15 c4 b7 10 00    	call   *0x10b7c4(%rip)        # 789380 <_DYNAMIC+0x568>
  67dbbc:	49 89 c5             	mov    %rax,%r13
  67dbbf:	ba 48 02 00 00       	mov    $0x248,%edx
  67dbc4:	4c 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%r15
  67dbcb:	00 
  67dbcc:	4c 89 ff             	mov    %r15,%rdi
  67dbcf:	48 8d b4 24 90 04 00 	lea    0x490(%rsp),%rsi
  67dbd6:	00 
  67dbd7:	ff 15 0b b5 10 00    	call   *0x10b50b(%rip)        # 7890e8 <memcpy@GLIBC_2.14>
  67dbdd:	4c 89 ff             	mov    %r15,%rdi
  67dbe0:	4c 89 ee             	mov    %r13,%rsi
  67dbe3:	e8 78 b4 fe ff       	call   669060 <<core::iter::adapters::map::Map<core::iter::adapters::filter::Filter<core::iter::adapters::flatten::FlatMap<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, parley::layout::run::Clusters<()>, gpui_canvas::text::planner::freeze_line::{closure#0}>, gpui_canvas::text::planner::freeze_line::{closure#1}>, gpui_canvas::text::planner::freeze_line::{closure#2}> as core::iter::traits::iterator::Iterator>::fold::<usize, core::iter::traits::iterator::Iterator::min_by::fold<usize, <usize as core::cmp::Ord>::cmp>::{closure#0}>>
  67dbe8:	48 39 d8             	cmp    %rbx,%rax
  67dbeb:	48 0f 42 d8          	cmovb  %rax,%rbx
  67dbef:	4c 8b bc 24 28 01 00 	mov    0x128(%rsp),%r15
  67dbf6:	00 
  67dbf7:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  67dbfc:	eb 1f                	jmp    67dc1d <<gpui_canvas::text::planner::Planner>::shape+0x107d>
  67dbfe:	80 bc 24 d0 06 00 00 	cmpb   $0x2,0x6d0(%rsp)
  67dc05:	02 
  67dc06:	c6 84 24 c0 05 00 00 	movb   $0x2,0x5c0(%rsp)
  67dc0d:	02 
  67dc0e:	4c 8b bc 24 28 01 00 	mov    0x128(%rsp),%r15
  67dc15:	00 
  67dc16:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  67dc1b:	75 32                	jne    67dc4f <<gpui_canvas::text::planner::Planner>::shape+0x10af>
  67dc1d:	49 39 dd             	cmp    %rbx,%r13
  67dc20:	0f 87 70 1b 00 00    	ja     67f796 <<gpui_canvas::text::planner::Planner>::shape+0x2bf6>
  67dc26:	4d 85 ed             	test   %r13,%r13
  67dc29:	0f 84 b9 00 00 00    	je     67dce8 <<gpui_canvas::text::planner::Planner>::shape+0x1148>
  67dc2f:	4c 3b 6c 24 20       	cmp    0x20(%rsp),%r13
  67dc34:	0f 83 a8 00 00 00    	jae    67dce2 <<gpui_canvas::text::planner::Planner>::shape+0x1142>
  67dc3a:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67dc3f:	42 80 3c 28 bf       	cmpb   $0xbf,(%rax,%r13,1)
  67dc44:	0f 8f 9e 00 00 00    	jg     67dce8 <<gpui_canvas::text::planner::Planner>::shape+0x1148>
  67dc4a:	e9 47 1b 00 00       	jmp    67f796 <<gpui_canvas::text::planner::Planner>::shape+0x2bf6>
  67dc4f:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67dc56:	00 
  67dc57:	48 8d b4 24 c8 05 00 	lea    0x5c8(%rsp),%rsi
  67dc5e:	00 
  67dc5f:	e8 9c 59 00 00       	call   683600 <<parley::layout::run::Clusters<()>>::advance_cursor>
  67dc64:	83 bc 24 e0 06 00 00 	cmpl   $0x1,0x6e0(%rsp)
  67dc6b:	01 
  67dc6c:	75 af                	jne    67dc1d <<gpui_canvas::text::planner::Planner>::shape+0x107d>
  67dc6e:	48 83 bc 24 80 06 00 	cmpq   $0x0,0x680(%rsp)
  67dc75:	00 00 
  67dc77:	0f 84 b9 20 00 00    	je     67fd36 <<gpui_canvas::text::planner::Planner>::shape+0x3196>
  67dc7d:	48 8b 8c 24 c8 05 00 	mov    0x5c8(%rsp),%rcx
  67dc84:	00 
  67dc85:	48 85 c9             	test   %rcx,%rcx
  67dc88:	74 93                	je     67dc1d <<gpui_canvas::text::planner::Planner>::shape+0x107d>
  67dc8a:	8b bc 24 f0 05 00 00 	mov    0x5f0(%rsp),%edi
  67dc91:	48 8b 41 58          	mov    0x58(%rcx),%rax
  67dc95:	48 39 f8             	cmp    %rdi,%rax
  67dc98:	0f 86 42 24 00 00    	jbe    6800e0 <<gpui_canvas::text::planner::Planner>::shape+0x3540>
  67dc9e:	8b b4 24 e4 06 00 00 	mov    0x6e4(%rsp),%esi
  67dca5:	8b 94 24 e8 06 00 00 	mov    0x6e8(%rsp),%edx
  67dcac:	4c 8b 41 70          	mov    0x70(%rcx),%r8
  67dcb0:	39 f2                	cmp    %esi,%edx
  67dcb2:	0f 82 3f 20 00 00    	jb     67fcf7 <<gpui_canvas::text::planner::Planner>::shape+0x3157>
  67dcb8:	49 39 d0             	cmp    %rdx,%r8
  67dcbb:	0f 82 36 20 00 00    	jb     67fcf7 <<gpui_canvas::text::planner::Planner>::shape+0x3157>
  67dcc1:	39 f2                	cmp    %esi,%edx
  67dcc3:	0f 84 28 24 00 00    	je     6800f1 <<gpui_canvas::text::planner::Planner>::shape+0x3551>
  67dcc9:	4c 8b 41 68          	mov    0x68(%rcx),%r8
  67dccd:	4c 8d 0c 76          	lea    (%rsi,%rsi,2),%r9
  67dcd1:	43 80 7c 88 07 06    	cmpb   $0x6,0x7(%r8,%r9,4)
  67dcd7:	0f 85 72 ff ff ff    	jne    67dc4f <<gpui_canvas::text::planner::Planner>::shape+0x10af>
  67dcdd:	e9 80 fe ff ff       	jmp    67db62 <<gpui_canvas::text::planner::Planner>::shape+0xfc2>
  67dce2:	0f 85 ae 1a 00 00    	jne    67f796 <<gpui_canvas::text::planner::Planner>::shape+0x2bf6>
  67dce8:	48 85 db             	test   %rbx,%rbx
  67dceb:	74 1d                	je     67dd0a <<gpui_canvas::text::planner::Planner>::shape+0x116a>
  67dced:	48 3b 5c 24 20       	cmp    0x20(%rsp),%rbx
  67dcf2:	73 10                	jae    67dd04 <<gpui_canvas::text::planner::Planner>::shape+0x1164>
  67dcf4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67dcf9:	80 3c 18 c0          	cmpb   $0xc0,(%rax,%rbx,1)
  67dcfd:	7d 0b                	jge    67dd0a <<gpui_canvas::text::planner::Planner>::shape+0x116a>
  67dcff:	e9 92 1a 00 00       	jmp    67f796 <<gpui_canvas::text::planner::Planner>::shape+0x2bf6>
  67dd04:	0f 85 8c 1a 00 00    	jne    67f796 <<gpui_canvas::text::planner::Planner>::shape+0x2bf6>
  67dd0a:	0f 57 c0             	xorps  %xmm0,%xmm0
  67dd0d:	49 39 ef             	cmp    %rbp,%r15
  67dd10:	74 0d                	je     67dd1f <<gpui_canvas::text::planner::Planner>::shape+0x117f>
  67dd12:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  67dd19:	00 
  67dd1a:	f3 0f 10 40 30       	movss  0x30(%rax),%xmm0
  67dd1f:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
  67dd25:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  67dd2c:	00 
  67dd2d:	f3 0f 10 48 40       	movss  0x40(%rax),%xmm1
  67dd32:	f3 0f 10 40 44       	movss  0x44(%rax),%xmm0
  67dd37:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  67dd3e:	00 
  67dd3f:	f3 0f 5d 48 48       	minss  0x48(%rax),%xmm1
  67dd44:	0f 29 8c 24 80 02 00 	movaps %xmm1,0x280(%rsp)
  67dd4b:	00 
  67dd4c:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  67dd53:	00 
  67dd54:	f3 0f 5f 40 4c       	maxss  0x4c(%rax),%xmm0
  67dd59:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  67dd60:	00 
  67dd61:	f3 0f 10 40 24       	movss  0x24(%rax),%xmm0
  67dd66:	f3 0f 58 44 24 50    	addss  0x50(%rsp),%xmm0
  67dd6c:	f3 0f 11 44 24 38    	movss  %xmm0,0x38(%rsp)
  67dd72:	4c 8b bc 24 70 01 00 	mov    0x170(%rsp),%r15
  67dd79:	00 
  67dd7a:	4c 3b bc 24 60 01 00 	cmp    0x160(%rsp),%r15
  67dd81:	00 
  67dd82:	75 0e                	jne    67dd92 <<gpui_canvas::text::planner::Planner>::shape+0x11f2>
  67dd84:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  67dd8b:	00 
  67dd8c:	ff 15 96 b5 10 00    	call   *0x10b596(%rip)        # 789328 <_DYNAMIC+0x510>
  67dd92:	41 01 ed             	add    %ebp,%r13d
  67dd95:	01 eb                	add    %ebp,%ebx
  67dd97:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  67dd9e:	00 
  67dd9f:	0f 28 c2             	movaps %xmm2,%xmm0
  67dda2:	f3 0f c2 c2 03       	cmpunordss %xmm2,%xmm0
  67dda7:	0f 28 c8             	movaps %xmm0,%xmm1
  67ddaa:	0f 55 ca             	andnps %xmm2,%xmm1
  67ddad:	0f 54 84 24 f0 00 00 	andps  0xf0(%rsp),%xmm0
  67ddb4:	00 
  67ddb5:	0f 56 c1             	orps   %xmm1,%xmm0
  67ddb8:	f3 0f 10 4c 24 50    	movss  0x50(%rsp),%xmm1
  67ddbe:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  67ddc2:	0f 28 a4 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm4
  67ddc9:	00 
  67ddca:	0f 28 d4             	movaps %xmm4,%xmm2
  67ddcd:	f3 0f c2 d4 03       	cmpunordss %xmm4,%xmm2
  67ddd2:	0f 28 da             	movaps %xmm2,%xmm3
  67ddd5:	0f 55 dc             	andnps %xmm4,%xmm3
  67ddd8:	0f 54 94 24 00 01 00 	andps  0x100(%rsp),%xmm2
  67dddf:	00 
  67dde0:	0f 56 d3             	orps   %xmm3,%xmm2
  67dde3:	f3 0f 5c d0          	subss  %xmm0,%xmm2
  67dde7:	48 8b 84 24 68 01 00 	mov    0x168(%rsp),%rax
  67ddee:	00 
  67ddef:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  67ddf3:	44 89 2c c8          	mov    %r13d,(%rax,%rcx,8)
  67ddf7:	89 5c c8 04          	mov    %ebx,0x4(%rax,%rcx,8)
  67ddfb:	f3 0f 11 4c c8 08    	movss  %xmm1,0x8(%rax,%rcx,8)
  67de01:	f3 0f 11 54 c8 0c    	movss  %xmm2,0xc(%rax,%rcx,8)
  67de07:	f3 0f 10 44 24 38    	movss  0x38(%rsp),%xmm0
  67de0d:	f3 0f 11 44 c8 10    	movss  %xmm0,0x10(%rax,%rcx,8)
  67de13:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  67de19:	f3 0f 11 44 c8 14    	movss  %xmm0,0x14(%rax,%rcx,8)
  67de1f:	49 ff c7             	inc    %r15
  67de22:	4c 89 bc 24 70 01 00 	mov    %r15,0x170(%rsp)
  67de29:	00 
  67de2a:	89 9c 24 04 02 00 00 	mov    %ebx,0x204(%rsp)
  67de31:	8b 4c 24 6c          	mov    0x6c(%rsp),%ecx
  67de35:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  67de3c:	00 00 00 00 00 
  67de41:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  67de46:	48 89 84 24 e8 06 00 	mov    %rax,0x6e8(%rsp)
  67de4d:	00 
  67de4e:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  67de55:	00 
  67de56:	48 89 84 24 f0 06 00 	mov    %rax,0x6f0(%rsp)
  67de5d:	00 
  67de5e:	48 83 c0 70          	add    $0x70,%rax
  67de62:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  67de69:	00 
  67de6a:	89 8c 24 f8 06 00 00 	mov    %ecx,0x6f8(%rsp)
  67de71:	ff c1                	inc    %ecx
  67de73:	89 4c 24 6c          	mov    %ecx,0x6c(%rsp)
  67de77:	c6 84 24 a0 07 00 00 	movb   $0x2,0x7a0(%rsp)
  67de7e:	02 
  67de7f:	c7 84 24 a8 07 00 00 	movl   $0x0,0x7a8(%rsp)
  67de86:	00 00 00 00 
  67de8a:	48 8d bc 24 e0 02 00 	lea    0x2e0(%rsp),%rdi
  67de91:	00 
  67de92:	48 8d b4 24 e0 06 00 	lea    0x6e0(%rsp),%rsi
  67de99:	00 
  67de9a:	e8 81 5d 00 00       	call   683c20 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  67de9f:	83 bc 24 e0 02 00 00 	cmpl   $0x1,0x2e0(%rsp)
  67dea6:	01 
  67dea7:	0f 85 34 0f 00 00    	jne    67ede1 <<gpui_canvas::text::planner::Planner>::shape+0x2241>
  67dead:	48 8b 84 24 e8 02 00 	mov    0x2e8(%rsp),%rax
  67deb4:	00 
  67deb5:	48 85 c0             	test   %rax,%rax
  67deb8:	0f 84 aa 18 00 00    	je     67f768 <<gpui_canvas::text::planner::Planner>::shape+0x2bc8>
  67debe:	48 89 84 24 20 04 00 	mov    %rax,0x420(%rsp)
  67dec5:	00 
  67dec6:	41 0f 10 06          	movups (%r14),%xmm0
  67deca:	41 0f 10 4e 10       	movups 0x10(%r14),%xmm1
  67decf:	41 0f 10 56 20       	movups 0x20(%r14),%xmm2
  67ded4:	41 0f 10 5e 30       	movups 0x30(%r14),%xmm3
  67ded9:	48 8d 8c 24 28 04 00 	lea    0x428(%rsp),%rcx
  67dee0:	00 
  67dee1:	0f 11 59 30          	movups %xmm3,0x30(%rcx)
  67dee5:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  67dee9:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  67deed:	0f 11 01             	movups %xmm0,(%rcx)
  67def0:	48 8b 8c 24 28 04 00 	mov    0x428(%rsp),%rcx
  67def7:	00 
  67def8:	48 8b 51 30          	mov    0x30(%rcx),%rdx
  67defc:	48 8b 79 38          	mov    0x38(%rcx),%rdi
  67df00:	48 89 fe             	mov    %rdi,%rsi
  67df03:	48 29 d6             	sub    %rdx,%rsi
  67df06:	41 0f 92 c0          	setb   %r8b
  67df0a:	48 3b b8 d0 00 00 00 	cmp    0xd0(%rax),%rdi
  67df11:	40 0f 97 c7          	seta   %dil
  67df15:	48 01 d2             	add    %rdx,%rdx
  67df18:	48 03 90 c8 00 00 00 	add    0xc8(%rax),%rdx
  67df1f:	44 08 c7             	or     %r8b,%dil
  67df22:	40 84 ff             	test   %dil,%dil
  67df25:	bf 00 00 00 00       	mov    $0x0,%edi
  67df2a:	48 0f 45 f7          	cmovne %rdi,%rsi
  67df2e:	bf 02 00 00 00       	mov    $0x2,%edi
  67df33:	48 0f 45 d7          	cmovne %rdi,%rdx
  67df37:	48 01 f6             	add    %rsi,%rsi
  67df3a:	31 ff                	xor    %edi,%edi
  67df3c:	0f 1f 40 00          	nopl   0x0(%rax)
  67df40:	48 39 fe             	cmp    %rdi,%rsi
  67df43:	74 10                	je     67df55 <<gpui_canvas::text::planner::Planner>::shape+0x13b5>
  67df45:	66 83 3c 3a 00       	cmpw   $0x0,(%rdx,%rdi,1)
  67df4a:	48 8d 7f 02          	lea    0x2(%rdi),%rdi
  67df4e:	74 f0                	je     67df40 <<gpui_canvas::text::planner::Planner>::shape+0x13a0>
  67df50:	e9 b2 16 00 00       	jmp    67f607 <<gpui_canvas::text::planner::Planner>::shape+0x2a67>
  67df55:	48 8b 51 40          	mov    0x40(%rcx),%rdx
  67df59:	48 3b 90 b8 00 00 00 	cmp    0xb8(%rax),%rdx
  67df60:	0f 83 ee 1d 00 00    	jae    67fd54 <<gpui_canvas::text::planner::Planner>::shape+0x31b4>
  67df66:	48 c1 e2 06          	shl    $0x6,%rdx
  67df6a:	48 03 90 b0 00 00 00 	add    0xb0(%rax),%rdx
  67df71:	48 8b 3c 24          	mov    (%rsp),%rdi
  67df75:	83 3f 01             	cmpl   $0x1,(%rdi)
  67df78:	75 0e                	jne    67df88 <<gpui_canvas::text::planner::Planner>::shape+0x13e8>
  67df7a:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  67df7e:	48 3b 72 10          	cmp    0x10(%rdx),%rsi
  67df82:	75 04                	jne    67df88 <<gpui_canvas::text::planner::Planner>::shape+0x13e8>
  67df84:	31 ed                	xor    %ebp,%ebp
  67df86:	eb 49                	jmp    67dfd1 <<gpui_canvas::text::planner::Planner>::shape+0x1431>
  67df88:	83 7f 10 01          	cmpl   $0x1,0x10(%rdi)
  67df8c:	75 0f                	jne    67df9d <<gpui_canvas::text::planner::Planner>::shape+0x13fd>
  67df8e:	48 8b 77 18          	mov    0x18(%rdi),%rsi
  67df92:	bd 01 00 00 00       	mov    $0x1,%ebp
  67df97:	48 3b 72 10          	cmp    0x10(%rdx),%rsi
  67df9b:	74 1d                	je     67dfba <<gpui_canvas::text::planner::Planner>::shape+0x141a>
  67df9d:	83 7f 20 01          	cmpl   $0x1,0x20(%rdi)
  67dfa1:	0f 85 2b 18 00 00    	jne    67f7d2 <<gpui_canvas::text::planner::Planner>::shape+0x2c32>
  67dfa7:	48 8b 77 28          	mov    0x28(%rdi),%rsi
  67dfab:	bd 02 00 00 00       	mov    $0x2,%ebp
  67dfb0:	48 3b 72 10          	cmp    0x10(%rdx),%rsi
  67dfb4:	0f 85 18 18 00 00    	jne    67f7d2 <<gpui_canvas::text::planner::Planner>::shape+0x2c32>
  67dfba:	8d 55 ff             	lea    -0x1(%rbp),%edx
  67dfbd:	48 8b b4 24 f0 01 00 	mov    0x1f0(%rsp),%rsi
  67dfc4:	00 
  67dfc5:	48 0f ab d6          	bts    %rdx,%rsi
  67dfc9:	48 89 b4 24 f0 01 00 	mov    %rsi,0x1f0(%rsp)
  67dfd0:	00 
  67dfd1:	8b bc 24 48 04 00 00 	mov    0x448(%rsp),%edi
  67dfd8:	48 8b 70 58          	mov    0x58(%rax),%rsi
  67dfdc:	48 39 fe             	cmp    %rdi,%rsi
  67dfdf:	0f 86 23 21 00 00    	jbe    680108 <<gpui_canvas::text::planner::Planner>::shape+0x3568>
  67dfe5:	48 8b 94 24 38 04 00 	mov    0x438(%rsp),%rdx
  67dfec:	00 
  67dfed:	48 85 d2             	test   %rdx,%rdx
  67dff0:	74 0a                	je     67dffc <<gpui_canvas::text::planner::Planner>::shape+0x145c>
  67dff2:	48 8d 72 18          	lea    0x18(%rdx),%rsi
  67dff6:	48 83 c2 1c          	add    $0x1c,%rdx
  67dffa:	eb 1b                	jmp    67e017 <<gpui_canvas::text::planner::Planner>::shape+0x1477>
  67dffc:	48 8b 70 50          	mov    0x50(%rax),%rsi
  67e000:	48 8d 3c ff          	lea    (%rdi,%rdi,8),%rdi
  67e004:	48 c1 e7 04          	shl    $0x4,%rdi
  67e008:	48 8d 14 3e          	lea    (%rsi,%rdi,1),%rdx
  67e00c:	48 83 c2 54          	add    $0x54,%rdx
  67e010:	48 01 fe             	add    %rdi,%rsi
  67e013:	48 83 c6 50          	add    $0x50,%rsi
  67e017:	48 8b bc 24 e8 00 00 	mov    0xe8(%rsp),%rdi
  67e01e:	00 
  67e01f:	48 89 bc 24 38 03 00 	mov    %rdi,0x338(%rsp)
  67e026:	00 
  67e027:	48 8b 78 68          	mov    0x68(%rax),%rdi
  67e02b:	4c 8b 40 70          	mov    0x70(%rax),%r8
  67e02f:	4c 8b 88 80 00 00 00 	mov    0x80(%rax),%r9
  67e036:	4c 8b 90 88 00 00 00 	mov    0x88(%rax),%r10
  67e03d:	4c 8b 98 98 00 00 00 	mov    0x98(%rax),%r11
  67e044:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
  67e04b:	8b 12                	mov    (%rdx),%edx
  67e04d:	8b 36                	mov    (%rsi),%esi
  67e04f:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
  67e056:	80 e1 01             	and    $0x1,%cl
  67e059:	89 d3                	mov    %edx,%ebx
  67e05b:	29 f3                	sub    %esi,%ebx
  67e05d:	48 c7 84 24 90 04 00 	movq   $0x0,0x490(%rsp)
  67e064:	00 00 00 00 00 
  67e069:	48 c7 84 24 b0 04 00 	movq   $0x0,0x4b0(%rsp)
  67e070:	00 00 00 00 00 
  67e075:	c7 84 24 d0 04 00 00 	movl   $0x0,0x4d0(%rsp)
  67e07c:	00 00 00 00 
  67e080:	89 9c 24 d4 04 00 00 	mov    %ebx,0x4d4(%rsp)
  67e087:	48 89 bc 24 d8 04 00 	mov    %rdi,0x4d8(%rsp)
  67e08e:	00 
  67e08f:	4c 89 84 24 e0 04 00 	mov    %r8,0x4e0(%rsp)
  67e096:	00 
  67e097:	4c 89 8c 24 e8 04 00 	mov    %r9,0x4e8(%rsp)
  67e09e:	00 
  67e09f:	4c 89 94 24 f0 04 00 	mov    %r10,0x4f0(%rsp)
  67e0a6:	00 
  67e0a7:	4c 89 9c 24 f8 04 00 	mov    %r11,0x4f8(%rsp)
  67e0ae:	00 
  67e0af:	48 89 84 24 00 05 00 	mov    %rax,0x500(%rsp)
  67e0b6:	00 
  67e0b7:	89 b4 24 08 05 00 00 	mov    %esi,0x508(%rsp)
  67e0be:	89 94 24 0c 05 00 00 	mov    %edx,0x50c(%rsp)
  67e0c5:	89 b4 24 10 05 00 00 	mov    %esi,0x510(%rsp)
  67e0cc:	89 94 24 14 05 00 00 	mov    %edx,0x514(%rsp)
  67e0d3:	88 8c 24 18 05 00 00 	mov    %cl,0x518(%rsp)
  67e0da:	48 8d bc 24 80 03 00 	lea    0x380(%rsp),%rdi
  67e0e1:	00 
  67e0e2:	48 8d b4 24 20 04 00 	lea    0x420(%rsp),%rsi
  67e0e9:	00 
  67e0ea:	e8 51 4f 00 00       	call   683040 <<parley::layout::line::GlyphRun<()>>::positioned_glyphs>
  67e0ef:	4c 8b ac 24 80 03 00 	mov    0x380(%rsp),%r13
  67e0f6:	00 
  67e0f7:	48 8b 84 24 88 03 00 	mov    0x388(%rsp),%rax
  67e0fe:	00 
  67e0ff:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  67e106:	00 
  67e107:	0f b6 84 24 90 03 00 	movzbl 0x390(%rsp),%eax
  67e10e:	00 
  67e10f:	8b 8c 24 94 03 00 00 	mov    0x394(%rsp),%ecx
  67e116:	89 8c 24 9c 01 00 00 	mov    %ecx,0x19c(%rsp)
  67e11d:	f2 0f 10 84 24 98 03 	movsd  0x398(%rsp),%xmm0
  67e124:	00 00 
  67e126:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  67e12d:	00 
  67e12e:	f3 0f 10 84 24 a0 03 	movss  0x3a0(%rsp),%xmm0
  67e135:	00 00 
  67e137:	f3 0f 11 84 24 98 01 	movss  %xmm0,0x198(%rsp)
  67e13e:	00 00 
  67e140:	48 8b 8c 24 a8 03 00 	mov    0x3a8(%rsp),%rcx
  67e147:	00 
  67e148:	48 89 8c 24 58 02 00 	mov    %rcx,0x258(%rsp)
  67e14f:	00 
  67e150:	48 8b 8c 24 b0 03 00 	mov    0x3b0(%rsp),%rcx
  67e157:	00 
  67e158:	48 89 8c 24 e8 01 00 	mov    %rcx,0x1e8(%rsp)
  67e15f:	00 
  67e160:	48 8b 94 24 b8 03 00 	mov    0x3b8(%rsp),%rdx
  67e167:	00 
  67e168:	48 8b 9c 24 c0 03 00 	mov    0x3c0(%rsp),%rbx
  67e16f:	00 
  67e170:	48 8b 8c 24 c8 03 00 	mov    0x3c8(%rsp),%rcx
  67e177:	00 
  67e178:	48 89 8c 24 68 02 00 	mov    %rcx,0x268(%rsp)
  67e17f:	00 
  67e180:	48 8b 8c 24 d0 03 00 	mov    0x3d0(%rsp),%rcx
  67e187:	00 
  67e188:	48 89 8c 24 20 01 00 	mov    %rcx,0x120(%rsp)
  67e18f:	00 
  67e190:	8b 8c 24 d8 03 00 00 	mov    0x3d8(%rsp),%ecx
  67e197:	48 89 8c 24 e0 01 00 	mov    %rcx,0x1e0(%rsp)
  67e19e:	00 
  67e19f:	8b 8c 24 dc 03 00 00 	mov    0x3dc(%rsp),%ecx
  67e1a6:	48 89 8c 24 d8 01 00 	mov    %rcx,0x1d8(%rsp)
  67e1ad:	00 
  67e1ae:	8b 8c 24 e0 03 00 00 	mov    0x3e0(%rsp),%ecx
  67e1b5:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  67e1bc:	00 
  67e1bd:	8b 8c 24 e4 03 00 00 	mov    0x3e4(%rsp),%ecx
  67e1c4:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  67e1c9:	f3 0f 10 84 24 e8 03 	movss  0x3e8(%rsp),%xmm0
  67e1d0:	00 00 
  67e1d2:	f3 0f 11 84 24 a0 01 	movss  %xmm0,0x1a0(%rsp)
  67e1d9:	00 00 
  67e1db:	f3 0f 10 84 24 ec 03 	movss  0x3ec(%rsp),%xmm0
  67e1e2:	00 00 
  67e1e4:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  67e1ea:	48 8b 8c 24 f0 03 00 	mov    0x3f0(%rsp),%rcx
  67e1f1:	00 
  67e1f2:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  67e1f7:	f3 0f 10 84 24 08 04 	movss  0x408(%rsp),%xmm0
  67e1fe:	00 00 
  67e200:	f3 0f 10 94 24 18 04 	movss  0x418(%rsp),%xmm2
  67e207:	00 00 
  67e209:	f3 0f 10 8c 24 1c 04 	movss  0x41c(%rsp),%xmm1
  67e210:	00 00 
  67e212:	f3 0f 11 8c 24 18 02 	movss  %xmm1,0x218(%rsp)
  67e219:	00 00 
  67e21b:	f3 0f 10 8c 24 04 04 	movss  0x404(%rsp),%xmm1
  67e222:	00 00 
  67e224:	f3 0f 11 84 24 14 02 	movss  %xmm0,0x214(%rsp)
  67e22b:	00 00 
  67e22d:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  67e231:	f3 0f 10 84 24 0c 04 	movss  0x40c(%rsp),%xmm0
  67e238:	00 00 
  67e23a:	f3 0f 11 8c 24 10 02 	movss  %xmm1,0x210(%rsp)
  67e241:	00 00 
  67e243:	f3 0f 58 c1          	addss  %xmm1,%xmm0
  67e247:	f3 0f 11 84 24 08 02 	movss  %xmm0,0x208(%rsp)
  67e24e:	00 00 
  67e250:	0f b6 8c 24 14 04 00 	movzbl 0x414(%rsp),%ecx
  67e257:	00 
  67e258:	88 8c 24 80 02 00 00 	mov    %cl,0x280(%rsp)
  67e25f:	48 8b 8c 24 f8 03 00 	mov    0x3f8(%rsp),%rcx
  67e266:	00 
  67e267:	48 89 8c 24 18 01 00 	mov    %rcx,0x118(%rsp)
  67e26e:	00 
  67e26f:	8b 8c 24 00 04 00 00 	mov    0x400(%rsp),%ecx
  67e276:	89 8c 24 d0 00 00 00 	mov    %ecx,0xd0(%rsp)
  67e27d:	8b 8c 24 10 04 00 00 	mov    0x410(%rsp),%ecx
  67e284:	89 8c 24 0c 02 00 00 	mov    %ecx,0x20c(%rsp)
  67e28b:	48 8d 4a 16          	lea    0x16(%rdx),%rcx
  67e28f:	48 89 8c 24 40 02 00 	mov    %rcx,0x240(%rsp)
  67e296:	00 
  67e297:	48 89 94 24 c0 01 00 	mov    %rdx,0x1c0(%rsp)
  67e29e:	00 
  67e29f:	48 8d 4a 2e          	lea    0x2e(%rdx),%rcx
  67e2a3:	48 89 8c 24 40 03 00 	mov    %rcx,0x340(%rsp)
  67e2aa:	00 
  67e2ab:	48 89 ac 24 50 02 00 	mov    %rbp,0x250(%rsp)
  67e2b2:	00 
  67e2b3:	48 89 9c 24 d0 01 00 	mov    %rbx,0x1d0(%rsp)
  67e2ba:	00 
  67e2bb:	eb 6e                	jmp    67e32b <<gpui_canvas::text::planner::Planner>::shape+0x178b>
  67e2bd:	03 ac 24 30 01 00 00 	add    0x130(%rsp),%ebp
  67e2c4:	0f 28 8c 24 b0 01 00 	movaps 0x1b0(%rsp),%xmm1
  67e2cb:	00 
  67e2cc:	f3 0f 58 4c 24 50    	addss  0x50(%rsp),%xmm1
  67e2d2:	48 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%rax
  67e2d9:	00 
  67e2da:	48 89 d9             	mov    %rbx,%rcx
  67e2dd:	48 c1 e1 04          	shl    $0x4,%rcx
  67e2e1:	89 2c 08             	mov    %ebp,(%rax,%rcx,1)
  67e2e4:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  67e2ea:	f3 0f 11 44 08 04    	movss  %xmm0,0x4(%rax,%rcx,1)
  67e2f0:	f3 0f 11 4c 08 08    	movss  %xmm1,0x8(%rax,%rcx,1)
  67e2f6:	66 44 89 7c 08 0c    	mov    %r15w,0xc(%rax,%rcx,1)
  67e2fc:	48 8b 94 24 50 02 00 	mov    0x250(%rsp),%rdx
  67e303:	00 
  67e304:	88 54 08 0e          	mov    %dl,0xe(%rax,%rcx,1)
  67e308:	c6 44 08 0f 00       	movb   $0x0,0xf(%rax,%rcx,1)
  67e30d:	48 ff c3             	inc    %rbx
  67e310:	48 89 9c 24 e8 00 00 	mov    %rbx,0xe8(%rsp)
  67e317:	00 
  67e318:	31 c0                	xor    %eax,%eax
  67e31a:	48 8b 9c 24 d0 01 00 	mov    0x1d0(%rsp),%rbx
  67e321:	00 
  67e322:	f3 0f 10 94 24 a4 01 	movss  0x1a4(%rsp),%xmm2
  67e329:	00 00 
  67e32b:	f3 0f 11 54 24 78    	movss  %xmm2,0x78(%rsp)
  67e331:	a8 01                	test   $0x1,%al
  67e333:	74 5b                	je     67e390 <<gpui_canvas::text::planner::Planner>::shape+0x17f0>
  67e335:	f3 0f 10 84 24 98 01 	movss  0x198(%rsp),%xmm0
  67e33c:	00 00 
  67e33e:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  67e345:	00 00 
  67e347:	8b ac 24 9c 01 00 00 	mov    0x19c(%rsp),%ebp
  67e34e:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  67e355:	00 
  67e356:	0f 29 84 24 b0 01 00 	movaps %xmm0,0x1b0(%rsp)
  67e35d:	00 
  67e35e:	83 bc 24 d0 00 00 00 	cmpl   $0x0,0xd0(%rsp)
  67e365:	00 
  67e366:	74 6f                	je     67e3d7 <<gpui_canvas::text::planner::Planner>::shape+0x1837>
  67e368:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  67e36e:	74 7a                	je     67e3ea <<gpui_canvas::text::planner::Planner>::shape+0x184a>
  67e370:	0f 28 84 24 b0 01 00 	movaps 0x1b0(%rsp),%xmm0
  67e377:	00 
  67e378:	f3 0f 11 84 24 cc 00 	movss  %xmm0,0xcc(%rsp)
  67e37f:	00 00 
  67e381:	e9 98 00 00 00       	jmp    67e41e <<gpui_canvas::text::planner::Planner>::shape+0x187e>
  67e386:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  67e38d:	00 00 00 
  67e390:	4c 3b ac 24 80 00 00 	cmp    0x80(%rsp),%r13
  67e397:	00 
  67e398:	0f 84 4c 01 00 00    	je     67e4ea <<gpui_canvas::text::planner::Planner>::shape+0x194a>
  67e39e:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  67e3a3:	41 8b 6d 00          	mov    0x0(%r13),%ebp
  67e3a7:	f2 41 0f 10 45 04    	movsd  0x4(%r13),%xmm0
  67e3ad:	0f 29 84 24 b0 01 00 	movaps %xmm0,0x1b0(%rsp)
  67e3b4:	00 
  67e3b5:	f3 41 0f 10 45 0c    	movss  0xc(%r13),%xmm0
  67e3bb:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  67e3c2:	00 00 
  67e3c4:	49 83 c5 10          	add    $0x10,%r13
  67e3c8:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
  67e3cd:	83 bc 24 d0 00 00 00 	cmpl   $0x0,0xd0(%rsp)
  67e3d4:	00 
  67e3d5:	75 91                	jne    67e368 <<gpui_canvas::text::planner::Planner>::shape+0x17c8>
  67e3d7:	0f 28 84 24 b0 01 00 	movaps 0x1b0(%rsp),%xmm0
  67e3de:	00 
  67e3df:	f3 0f 11 84 24 cc 00 	movss  %xmm0,0xcc(%rsp)
  67e3e6:	00 00 
  67e3e8:	eb 6b                	jmp    67e455 <<gpui_canvas::text::planner::Planner>::shape+0x18b5>
  67e3ea:	f3 0f 10 84 24 a0 01 	movss  0x1a0(%rsp),%xmm0
  67e3f1:	00 00 
  67e3f3:	0f 28 c8             	movaps %xmm0,%xmm1
  67e3f6:	f3 0f 58 8c 24 b0 01 	addss  0x1b0(%rsp),%xmm1
  67e3fd:	00 00 
  67e3ff:	f3 0f 11 8c 24 cc 00 	movss  %xmm1,0xcc(%rsp)
  67e406:	00 00 
  67e408:	f3 0f 10 8c 24 00 01 	movss  0x100(%rsp),%xmm1
  67e40f:	00 00 
  67e411:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  67e415:	f3 0f 11 8c 24 00 01 	movss  %xmm1,0x100(%rsp)
  67e41c:	00 00 
  67e41e:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  67e423:	48 ff c2             	inc    %rdx
  67e426:	48 8b 84 24 18 01 00 	mov    0x118(%rsp),%rax
  67e42d:	00 
  67e42e:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
  67e433:	48 39 c2             	cmp    %rax,%rdx
  67e436:	75 1d                	jne    67e455 <<gpui_canvas::text::planner::Planner>::shape+0x18b5>
  67e438:	f3 0f 10 84 24 00 01 	movss  0x100(%rsp),%xmm0
  67e43f:	00 00 
  67e441:	f3 0f 58 44 24 5c    	addss  0x5c(%rsp),%xmm0
  67e447:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  67e44e:	00 00 
  67e450:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  67e455:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  67e45c:	00 
  67e45d:	48 8d b4 24 90 04 00 	lea    0x490(%rsp),%rsi
  67e464:	00 
  67e465:	e8 56 2a 00 00       	call   680ec0 <<core::iter::adapters::flatten::FlattenCompat<core::iter::adapters::map::Map<core::ops::range::Range<u32>, <parley::layout::run::Run<()>>::glyph_source_ranges::{closure#0}>, core::iter::sources::repeat_n::RepeatN<core::ops::range::Range<usize>>> as core::iter::traits::iterator::Iterator>::next>
  67e46a:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  67e471:	01 
  67e472:	0f 85 c1 12 00 00    	jne    67f739 <<gpui_canvas::text::planner::Planner>::shape+0x2b99>
  67e478:	f3 0f 10 54 24 78    	movss  0x78(%rsp),%xmm2
  67e47e:	f3 0f 58 94 24 00 01 	addss  0x100(%rsp),%xmm2
  67e485:	00 00 
  67e487:	31 c0                	xor    %eax,%eax
  67e489:	48 8b 8c 24 30 01 00 	mov    0x130(%rsp),%rcx
  67e490:	00 
  67e491:	48 39 8c 24 28 01 00 	cmp    %rcx,0x128(%rsp)
  67e498:	00 
  67e499:	0f 84 8c fe ff ff    	je     67e32b <<gpui_canvas::text::planner::Planner>::shape+0x178b>
  67e49f:	f3 0f 11 94 24 a4 01 	movss  %xmm2,0x1a4(%rsp)
  67e4a6:	00 00 
  67e4a8:	4c 8b 8c 24 98 00 00 	mov    0x98(%rsp),%r9
  67e4af:	00 
  67e4b0:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  67e4b7:	00 
  67e4b8:	49 39 c9             	cmp    %rcx,%r9
  67e4bb:	0f 87 4a 12 00 00    	ja     67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67e4c1:	4d 85 c9             	test   %r9,%r9
  67e4c4:	0f 84 fa 04 00 00    	je     67e9c4 <<gpui_canvas::text::planner::Planner>::shape+0x1e24>
  67e4ca:	4c 3b 4c 24 20       	cmp    0x20(%rsp),%r9
  67e4cf:	0f 83 e9 04 00 00    	jae    67e9be <<gpui_canvas::text::planner::Planner>::shape+0x1e1e>
  67e4d5:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67e4da:	42 80 3c 08 bf       	cmpb   $0xbf,(%rax,%r9,1)
  67e4df:	0f 8f df 04 00 00    	jg     67e9c4 <<gpui_canvas::text::planner::Planner>::shape+0x1e24>
  67e4e5:	e9 21 12 00 00       	jmp    67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67e4ea:	4c 89 ac 24 80 00 00 	mov    %r13,0x80(%rsp)
  67e4f1:	00 
  67e4f2:	f6 84 24 80 02 00 00 	testb  $0x1,0x280(%rsp)
  67e4f9:	01 
  67e4fa:	74 1e                	je     67e51a <<gpui_canvas::text::planner::Planner>::shape+0x197a>
  67e4fc:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  67e501:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  67e508:	00 
  67e509:	39 c1                	cmp    %eax,%ecx
  67e50b:	0f 83 4f 01 00 00    	jae    67e660 <<gpui_canvas::text::planner::Planner>::shape+0x1ac0>
  67e511:	ff c8                	dec    %eax
  67e513:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  67e518:	eb 18                	jmp    67e532 <<gpui_canvas::text::planner::Planner>::shape+0x1992>
  67e51a:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  67e51f:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  67e526:	00 
  67e527:	39 d0                	cmp    %edx,%eax
  67e529:	0f 83 4c 01 00 00    	jae    67e67b <<gpui_canvas::text::planner::Planner>::shape+0x1adb>
  67e52f:	8d 48 01             	lea    0x1(%rax),%ecx
  67e532:	89 c7                	mov    %eax,%edi
  67e534:	48 39 fb             	cmp    %rdi,%rbx
  67e537:	48 8b 94 24 c0 01 00 	mov    0x1c0(%rsp),%rdx
  67e53e:	00 
  67e53f:	0f 86 46 1b 00 00    	jbe    68008b <<gpui_canvas::text::planner::Planner>::shape+0x34eb>
  67e545:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  67e549:	44 8b 6c c2 08       	mov    0x8(%rdx,%rax,8),%r13d
  67e54e:	f6 44 c2 17 01       	testb  $0x1,0x17(%rdx,%rax,8)
  67e553:	0f 85 66 05 00 00    	jne    67eabf <<gpui_canvas::text::planner::Planner>::shape+0x1f1f>
  67e559:	48 8d 04 c2          	lea    (%rdx,%rax,8),%rax
  67e55d:	8b 50 0c             	mov    0xc(%rax),%edx
  67e560:	4a 8d 34 2a          	lea    (%rdx,%r13,1),%rsi
  67e564:	48 3b b4 24 20 01 00 	cmp    0x120(%rsp),%rsi
  67e56b:	00 
  67e56c:	0f 87 40 14 00 00    	ja     67f9b2 <<gpui_canvas::text::planner::Planner>::shape+0x2e12>
  67e572:	49 c1 e5 04          	shl    $0x4,%r13
  67e576:	4c 03 ac 24 68 02 00 	add    0x268(%rsp),%r13
  67e57d:	00 
  67e57e:	48 89 d0             	mov    %rdx,%rax
  67e581:	48 c1 e0 04          	shl    $0x4,%rax
  67e585:	4c 01 e8             	add    %r13,%rax
  67e588:	0f 57 c0             	xorps  %xmm0,%xmm0
  67e58b:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  67e592:	00 
  67e593:	48 85 d2             	test   %rdx,%rdx
  67e596:	0f 85 c1 06 00 00    	jne    67ec5d <<gpui_canvas::text::planner::Planner>::shape+0x20bd>
  67e59c:	89 ca                	mov    %ecx,%edx
  67e59e:	48 89 94 24 f0 00 00 	mov    %rdx,0xf0(%rsp)
  67e5a5:	00 
  67e5a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  67e5ad:	00 00 00 
  67e5b0:	f6 84 24 80 02 00 00 	testb  $0x1,0x280(%rsp)
  67e5b7:	01 
  67e5b8:	74 26                	je     67e5e0 <<gpui_canvas::text::planner::Planner>::shape+0x1a40>
  67e5ba:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
  67e5bf:	44 39 f9             	cmp    %r15d,%ecx
  67e5c2:	0f 83 d2 00 00 00    	jae    67e69a <<gpui_canvas::text::planner::Planner>::shape+0x1afa>
  67e5c8:	41 ff cf             	dec    %r15d
  67e5cb:	4c 89 f8             	mov    %r15,%rax
  67e5ce:	89 ca                	mov    %ecx,%edx
  67e5d0:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
  67e5d5:	89 c1                	mov    %eax,%ecx
  67e5d7:	eb 21                	jmp    67e5fa <<gpui_canvas::text::planner::Planner>::shape+0x1a5a>
  67e5d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  67e5e0:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  67e5e5:	39 d1                	cmp    %edx,%ecx
  67e5e7:	0f 83 55 01 00 00    	jae    67e742 <<gpui_canvas::text::planner::Planner>::shape+0x1ba2>
  67e5ed:	8d 41 01             	lea    0x1(%rcx),%eax
  67e5f0:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
  67e5f7:	00 
  67e5f8:	89 c2                	mov    %eax,%edx
  67e5fa:	89 cf                	mov    %ecx,%edi
  67e5fc:	48 39 fb             	cmp    %rdi,%rbx
  67e5ff:	48 8b 8c 24 c0 01 00 	mov    0x1c0(%rsp),%rcx
  67e606:	00 
  67e607:	0f 86 7e 1a 00 00    	jbe    68008b <<gpui_canvas::text::planner::Planner>::shape+0x34eb>
  67e60d:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  67e611:	44 8b 6c c1 08       	mov    0x8(%rcx,%rax,8),%r13d
  67e616:	f6 44 c1 17 01       	testb  $0x1,0x17(%rcx,%rax,8)
  67e61b:	0f 85 96 04 00 00    	jne    67eab7 <<gpui_canvas::text::planner::Planner>::shape+0x1f17>
  67e621:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
  67e625:	8b 78 0c             	mov    0xc(%rax),%edi
  67e628:	4a 8d 34 2f          	lea    (%rdi,%r13,1),%rsi
  67e62c:	48 3b b4 24 20 01 00 	cmp    0x120(%rsp),%rsi
  67e633:	00 
  67e634:	0f 87 78 13 00 00    	ja     67f9b2 <<gpui_canvas::text::planner::Planner>::shape+0x2e12>
  67e63a:	49 c1 e5 04          	shl    $0x4,%r13
  67e63e:	4c 03 ac 24 68 02 00 	add    0x268(%rsp),%r13
  67e645:	00 
  67e646:	48 89 f8             	mov    %rdi,%rax
  67e649:	48 c1 e0 04          	shl    $0x4,%rax
  67e64d:	4c 01 e8             	add    %r13,%rax
  67e650:	89 d1                	mov    %edx,%ecx
  67e652:	48 85 ff             	test   %rdi,%rdi
  67e655:	0f 84 55 ff ff ff    	je     67e5b0 <<gpui_canvas::text::planner::Planner>::shape+0x1a10>
  67e65b:	e9 d3 04 00 00       	jmp    67eb33 <<gpui_canvas::text::planner::Planner>::shape+0x1f93>
  67e660:	4c 89 e8             	mov    %r13,%rax
  67e663:	3b 8c 24 e0 01 00 00 	cmp    0x1e0(%rsp),%ecx
  67e66a:	0f 95 c2             	setne  %dl
  67e66d:	84 94 24 d0 00 00 00 	test   %dl,0xd0(%rsp)
  67e674:	75 4e                	jne    67e6c4 <<gpui_canvas::text::planner::Planner>::shape+0x1b24>
  67e676:	e9 fc 05 00 00       	jmp    67ec77 <<gpui_canvas::text::planner::Planner>::shape+0x20d7>
  67e67b:	4c 89 e8             	mov    %r13,%rax
  67e67e:	3b 94 24 d8 01 00 00 	cmp    0x1d8(%rsp),%edx
  67e685:	0f 95 c1             	setne  %cl
  67e688:	84 8c 24 d0 00 00 00 	test   %cl,0xd0(%rsp)
  67e68f:	0f 85 d7 00 00 00    	jne    67e76c <<gpui_canvas::text::planner::Planner>::shape+0x1bcc>
  67e695:	e9 dd 05 00 00       	jmp    67ec77 <<gpui_canvas::text::planner::Planner>::shape+0x20d7>
  67e69a:	0f 57 c0             	xorps  %xmm0,%xmm0
  67e69d:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  67e6a4:	00 
  67e6a5:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  67e6ac:	00 
  67e6ad:	3b 8c 24 e0 01 00 00 	cmp    0x1e0(%rsp),%ecx
  67e6b4:	0f 95 c2             	setne  %dl
  67e6b7:	84 94 24 d0 00 00 00 	test   %dl,0xd0(%rsp)
  67e6be:	0f 84 b3 05 00 00    	je     67ec77 <<gpui_canvas::text::planner::Planner>::shape+0x20d7>
  67e6c4:	8d 79 ff             	lea    -0x1(%rcx),%edi
  67e6c7:	48 39 fb             	cmp    %rdi,%rbx
  67e6ca:	0f 86 5c 1a 00 00    	jbe    68012c <<gpui_canvas::text::planner::Planner>::shape+0x358c>
  67e6d0:	3b bc 24 e0 01 00 00 	cmp    0x1e0(%rsp),%edi
  67e6d7:	76 43                	jbe    67e71c <<gpui_canvas::text::planner::Planner>::shape+0x1b7c>
  67e6d9:	48 8d 14 7f          	lea    (%rdi,%rdi,2),%rdx
  67e6dd:	48 8b b4 24 40 02 00 	mov    0x240(%rsp),%rsi
  67e6e4:	00 
  67e6e5:	48 8d 14 d6          	lea    (%rsi,%rdx,8),%rdx
  67e6e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  67e6f0:	48 39 fb             	cmp    %rdi,%rbx
  67e6f3:	0f 86 b3 19 00 00    	jbe    6800ac <<gpui_canvas::text::planner::Planner>::shape+0x350c>
  67e6f9:	f6 42 01 02          	testb  $0x2,0x1(%rdx)
  67e6fd:	75 1d                	jne    67e71c <<gpui_canvas::text::planner::Planner>::shape+0x1b7c>
  67e6ff:	48 ff cf             	dec    %rdi
  67e702:	48 83 c2 e8          	add    $0xffffffffffffffe8,%rdx
  67e706:	39 bc 24 e0 01 00 00 	cmp    %edi,0x1e0(%rsp)
  67e70d:	72 e1                	jb     67e6f0 <<gpui_canvas::text::planner::Planner>::shape+0x1b50>
  67e70f:	48 8b 94 24 e0 01 00 	mov    0x1e0(%rsp),%rdx
  67e716:	00 
  67e717:	48 89 d7             	mov    %rdx,%rdi
  67e71a:	eb 02                	jmp    67e71e <<gpui_canvas::text::planner::Planner>::shape+0x1b7e>
  67e71c:	89 fa                	mov    %edi,%edx
  67e71e:	48 39 fb             	cmp    %rdi,%rbx
  67e721:	0f 86 11 1a 00 00    	jbe    680138 <<gpui_canvas::text::planner::Planner>::shape+0x3598>
  67e727:	48 89 94 24 f0 00 00 	mov    %rdx,0xf0(%rsp)
  67e72e:	00 
  67e72f:	89 ca                	mov    %ecx,%edx
  67e731:	48 ff ca             	dec    %rdx
  67e734:	48 39 da             	cmp    %rbx,%rdx
  67e737:	0f 82 a1 00 00 00    	jb     67e7de <<gpui_canvas::text::planner::Planner>::shape+0x1c3e>
  67e73d:	e9 02 1a 00 00       	jmp    680144 <<gpui_canvas::text::planner::Planner>::shape+0x35a4>
  67e742:	0f 57 c0             	xorps  %xmm0,%xmm0
  67e745:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  67e74c:	00 
  67e74d:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  67e754:	00 
  67e755:	3b 94 24 d8 01 00 00 	cmp    0x1d8(%rsp),%edx
  67e75c:	0f 95 c1             	setne  %cl
  67e75f:	84 8c 24 d0 00 00 00 	test   %cl,0xd0(%rsp)
  67e766:	0f 84 0b 05 00 00    	je     67ec77 <<gpui_canvas::text::planner::Planner>::shape+0x20d7>
  67e76c:	49 89 d0             	mov    %rdx,%r8
  67e76f:	48 89 d1             	mov    %rdx,%rcx
  67e772:	89 cf                	mov    %ecx,%edi
  67e774:	48 39 fb             	cmp    %rdi,%rbx
  67e777:	0f 86 9a 19 00 00    	jbe    680117 <<gpui_canvas::text::planner::Planner>::shape+0x3577>
  67e77d:	ff c1                	inc    %ecx
  67e77f:	3b 8c 24 d8 01 00 00 	cmp    0x1d8(%rsp),%ecx
  67e786:	73 40                	jae    67e7c8 <<gpui_canvas::text::planner::Planner>::shape+0x1c28>
  67e788:	89 ca                	mov    %ecx,%edx
  67e78a:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  67e78e:	48 8b b4 24 40 02 00 	mov    0x240(%rsp),%rsi
  67e795:	00 
  67e796:	48 8d 34 ce          	lea    (%rsi,%rcx,8),%rsi
  67e79a:	48 89 d1             	mov    %rdx,%rcx
  67e79d:	0f 1f 00             	nopl   (%rax)
  67e7a0:	48 39 cb             	cmp    %rcx,%rbx
  67e7a3:	0f 86 eb 18 00 00    	jbe    680094 <<gpui_canvas::text::planner::Planner>::shape+0x34f4>
  67e7a9:	f6 46 01 02          	testb  $0x2,0x1(%rsi)
  67e7ad:	75 19                	jne    67e7c8 <<gpui_canvas::text::planner::Planner>::shape+0x1c28>
  67e7af:	48 ff c1             	inc    %rcx
  67e7b2:	48 83 c6 18          	add    $0x18,%rsi
  67e7b6:	48 39 8c 24 d8 01 00 	cmp    %rcx,0x1d8(%rsp)
  67e7bd:	00 
  67e7be:	75 e0                	jne    67e7a0 <<gpui_canvas::text::planner::Planner>::shape+0x1c00>
  67e7c0:	48 8b 8c 24 d8 01 00 	mov    0x1d8(%rsp),%rcx
  67e7c7:	00 
  67e7c8:	89 ca                	mov    %ecx,%edx
  67e7ca:	48 ff ca             	dec    %rdx
  67e7cd:	48 39 da             	cmp    %rbx,%rdx
  67e7d0:	0f 83 4a 19 00 00    	jae    680120 <<gpui_canvas::text::planner::Planner>::shape+0x3580>
  67e7d6:	4c 89 84 24 f0 00 00 	mov    %r8,0xf0(%rsp)
  67e7dd:	00 
  67e7de:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  67e7e3:	48 83 bc 24 58 02 00 	cmpq   $0x0,0x258(%rsp)
  67e7ea:	00 00 
  67e7ec:	0f 84 85 04 00 00    	je     67ec77 <<gpui_canvas::text::planner::Planner>::shape+0x20d7>
  67e7f2:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  67e7f6:	48 8b b4 24 c0 01 00 	mov    0x1c0(%rsp),%rsi
  67e7fd:	00 
  67e7fe:	8b 0c ce             	mov    (%rsi,%rcx,8),%ecx
  67e801:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  67e805:	8b 74 d6 04          	mov    0x4(%rsi,%rdx,8),%esi
  67e809:	39 ce                	cmp    %ecx,%esi
  67e80b:	0f 82 b0 14 00 00    	jb     67fcc1 <<gpui_canvas::text::planner::Planner>::shape+0x3121>
  67e811:	48 39 b4 24 e8 01 00 	cmp    %rsi,0x1e8(%rsp)
  67e818:	00 
  67e819:	0f 82 a2 14 00 00    	jb     67fcc1 <<gpui_canvas::text::planner::Planner>::shape+0x3121>
  67e81f:	39 ce                	cmp    %ecx,%esi
  67e821:	0f 84 a9 18 00 00    	je     6800d0 <<gpui_canvas::text::planner::Planner>::shape+0x3530>
  67e827:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  67e82b:	48 8b 94 24 58 02 00 	mov    0x258(%rsp),%rdx
  67e832:	00 
  67e833:	0f b6 4c 8a 07       	movzbl 0x7(%rdx,%rcx,4),%ecx
  67e838:	8d 51 ff             	lea    -0x1(%rcx),%edx
  67e83b:	83 fa 02             	cmp    $0x2,%edx
  67e83e:	73 28                	jae    67e868 <<gpui_canvas::text::planner::Planner>::shape+0x1cc8>
  67e840:	f3 0f 10 84 24 10 02 	movss  0x210(%rsp),%xmm0
  67e847:	00 00 
  67e849:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  67e84f:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  67e854:	3b 94 24 0c 02 00 00 	cmp    0x20c(%rsp),%edx
  67e85b:	77 2d                	ja     67e88a <<gpui_canvas::text::planner::Planner>::shape+0x1cea>
  67e85d:	f3 0f 10 84 24 08 02 	movss  0x208(%rsp),%xmm0
  67e864:	00 00 
  67e866:	eb 1c                	jmp    67e884 <<gpui_canvas::text::planner::Planner>::shape+0x1ce4>
  67e868:	f3 0f 10 84 24 14 02 	movss  0x214(%rsp),%xmm0
  67e86f:	00 00 
  67e871:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  67e877:	83 f9 06             	cmp    $0x6,%ecx
  67e87a:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  67e87f:	75 09                	jne    67e88a <<gpui_canvas::text::planner::Planner>::shape+0x1cea>
  67e881:	0f 57 c0             	xorps  %xmm0,%xmm0
  67e884:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  67e88a:	89 d6                	mov    %edx,%esi
  67e88c:	48 39 f3             	cmp    %rsi,%rbx
  67e88f:	0f 92 c1             	setb   %cl
  67e892:	3b 94 24 f0 00 00 00 	cmp    0xf0(%rsp),%edx
  67e899:	0f 82 06 01 00 00    	jb     67e9a5 <<gpui_canvas::text::planner::Planner>::shape+0x1e05>
  67e89f:	48 8b bc 24 f0 00 00 	mov    0xf0(%rsp),%rdi
  67e8a6:	00 
  67e8a7:	89 fa                	mov    %edi,%edx
  67e8a9:	84 c9                	test   %cl,%cl
  67e8ab:	0f 85 2f 14 00 00    	jne    67fce0 <<gpui_canvas::text::planner::Planner>::shape+0x3140>
  67e8b1:	3b 7c 24 18          	cmp    0x18(%rsp),%edi
  67e8b5:	75 11                	jne    67e8c8 <<gpui_canvas::text::planner::Planner>::shape+0x1d28>
  67e8b7:	48 c7 84 24 18 01 00 	movq   $0x0,0x118(%rsp)
  67e8be:	00 00 00 00 00 
  67e8c3:	e9 b4 00 00 00       	jmp    67e97c <<gpui_canvas::text::planner::Planner>::shape+0x1ddc>
  67e8c8:	48 8d 0c d5 00 00 00 	lea    0x0(,%rdx,8),%rcx
  67e8cf:	00 
  67e8d0:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  67e8d4:	48 8d 7e ff          	lea    -0x1(%rsi),%rdi
  67e8d8:	48 39 d7             	cmp    %rdx,%rdi
  67e8db:	75 10                	jne    67e8ed <<gpui_canvas::text::planner::Planner>::shape+0x1d4d>
  67e8dd:	31 d2                	xor    %edx,%edx
  67e8df:	48 c7 84 24 18 01 00 	movq   $0x0,0x118(%rsp)
  67e8e6:	00 00 00 00 00 
  67e8eb:	eb 5e                	jmp    67e94b <<gpui_canvas::text::planner::Planner>::shape+0x1dab>
  67e8ed:	48 29 d6             	sub    %rdx,%rsi
  67e8f0:	48 89 f7             	mov    %rsi,%rdi
  67e8f3:	48 83 e7 fe          	and    $0xfffffffffffffffe,%rdi
  67e8f7:	48 8b 94 24 40 03 00 	mov    0x340(%rsp),%rdx
  67e8fe:	00 
  67e8ff:	4c 8d 04 0a          	lea    (%rdx,%rcx,1),%r8
  67e903:	31 d2                	xor    %edx,%edx
  67e905:	45 31 d2             	xor    %r10d,%r10d
  67e908:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  67e90e:	66 90                	xchg   %ax,%ax
  67e910:	45 8b 48 de          	mov    -0x22(%r8),%r9d
  67e914:	41 f6 40 e9 01       	testb  $0x1,-0x17(%r8)
  67e919:	4d 0f 45 cb          	cmovne %r11,%r9
  67e91d:	4d 01 d1             	add    %r10,%r9
  67e920:	41 f6 40 01 01       	testb  $0x1,0x1(%r8)
  67e925:	45 8b 50 f6          	mov    -0xa(%r8),%r10d
  67e929:	4d 0f 45 d3          	cmovne %r11,%r10
  67e92d:	4d 01 ca             	add    %r9,%r10
  67e930:	48 83 c2 02          	add    $0x2,%rdx
  67e934:	49 83 c0 30          	add    $0x30,%r8
  67e938:	48 39 d7             	cmp    %rdx,%rdi
  67e93b:	75 d3                	jne    67e910 <<gpui_canvas::text::planner::Planner>::shape+0x1d70>
  67e93d:	4c 89 94 24 18 01 00 	mov    %r10,0x118(%rsp)
  67e944:	00 
  67e945:	40 f6 c6 01          	test   $0x1,%sil
  67e949:	74 31                	je     67e97c <<gpui_canvas::text::planner::Planner>::shape+0x1ddc>
  67e94b:	48 8b b4 24 18 01 00 	mov    0x118(%rsp),%rsi
  67e952:	00 
  67e953:	48 03 8c 24 c0 01 00 	add    0x1c0(%rsp),%rcx
  67e95a:	00 
  67e95b:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  67e95f:	f6 44 d1 17 01       	testb  $0x1,0x17(%rcx,%rdx,8)
  67e964:	8b 54 d1 0c          	mov    0xc(%rcx,%rdx,8),%edx
  67e968:	b9 01 00 00 00       	mov    $0x1,%ecx
  67e96d:	48 0f 45 d1          	cmovne %rcx,%rdx
  67e971:	48 01 f2             	add    %rsi,%rdx
  67e974:	48 89 94 24 18 01 00 	mov    %rdx,0x118(%rsp)
  67e97b:	00 
  67e97c:	0f 57 c0             	xorps  %xmm0,%xmm0
  67e97f:	f3 0f 11 84 24 a0 01 	movss  %xmm0,0x1a0(%rsp)
  67e986:	00 00 
  67e988:	b9 00 00 00 00       	mov    $0x0,%ecx
  67e98d:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  67e992:	ba 00 00 00 00       	mov    $0x0,%edx
  67e997:	49 39 c5             	cmp    %rax,%r13
  67e99a:	0f 84 52 fb ff ff    	je     67e4f2 <<gpui_canvas::text::planner::Planner>::shape+0x1952>
  67e9a0:	e9 fe f9 ff ff       	jmp    67e3a3 <<gpui_canvas::text::planner::Planner>::shape+0x1803>
  67e9a5:	b1 01                	mov    $0x1,%cl
  67e9a7:	48 8b bc 24 f0 00 00 	mov    0xf0(%rsp),%rdi
  67e9ae:	00 
  67e9af:	89 fa                	mov    %edi,%edx
  67e9b1:	84 c9                	test   %cl,%cl
  67e9b3:	0f 84 f8 fe ff ff    	je     67e8b1 <<gpui_canvas::text::planner::Planner>::shape+0x1d11>
  67e9b9:	e9 22 13 00 00       	jmp    67fce0 <<gpui_canvas::text::planner::Planner>::shape+0x3140>
  67e9be:	0f 85 47 0d 00 00    	jne    67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67e9c4:	48 85 c9             	test   %rcx,%rcx
  67e9c7:	41 0f 94 c7          	sete   %r15b
  67e9cb:	74 1d                	je     67e9ea <<gpui_canvas::text::planner::Planner>::shape+0x1e4a>
  67e9cd:	48 3b 4c 24 20       	cmp    0x20(%rsp),%rcx
  67e9d2:	73 10                	jae    67e9e4 <<gpui_canvas::text::planner::Planner>::shape+0x1e44>
  67e9d4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67e9d9:	80 3c 08 c0          	cmpb   $0xc0,(%rax,%rcx,1)
  67e9dd:	7d 0b                	jge    67e9ea <<gpui_canvas::text::planner::Planner>::shape+0x1e4a>
  67e9df:	e9 27 0d 00 00       	jmp    67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67e9e4:	0f 85 21 0d 00 00    	jne    67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67e9ea:	85 ed                	test   %ebp,%ebp
  67e9ec:	0f 84 9c 00 00 00    	je     67ea8e <<gpui_canvas::text::planner::Planner>::shape+0x1eee>
  67e9f2:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  67e9f8:	f3 0f 58 84 24 cc 00 	addss  0xcc(%rsp),%xmm0
  67e9ff:	00 00 
  67ea01:	f3 0f 11 44 24 78    	movss  %xmm0,0x78(%rsp)
  67ea07:	66 0f 7e c1          	movd   %xmm0,%ecx
  67ea0b:	0f 28 84 24 b0 01 00 	movaps 0x1b0(%rsp),%xmm0
  67ea12:	00 
  67ea13:	0f c6 c0 55          	shufps $0x55,%xmm0,%xmm0
  67ea17:	f3 0f 58 84 24 18 02 	addss  0x218(%rsp),%xmm0
  67ea1e:	00 00 
  67ea20:	0f 29 84 24 b0 01 00 	movaps %xmm0,0x1b0(%rsp)
  67ea27:	00 
  67ea28:	66 0f 7e c0          	movd   %xmm0,%eax
  67ea2c:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  67ea32:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  67ea37:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  67ea3c:	0f 9d c0             	setge  %al
  67ea3f:	81 f9 ff ff 7f 7f    	cmp    $0x7f7fffff,%ecx
  67ea45:	0f 8f 1d 0d 00 00    	jg     67f768 <<gpui_canvas::text::planner::Planner>::shape+0x2bc8>
  67ea4b:	84 c0                	test   %al,%al
  67ea4d:	0f 85 15 0d 00 00    	jne    67f768 <<gpui_canvas::text::planner::Planner>::shape+0x2bc8>
  67ea53:	81 fd ff ff 00 00    	cmp    $0xffff,%ebp
  67ea59:	0f 87 ac 0c 00 00    	ja     67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67ea5f:	41 89 ef             	mov    %ebp,%r15d
  67ea62:	4c 89 cd             	mov    %r9,%rbp
  67ea65:	48 8b 9c 24 e8 00 00 	mov    0xe8(%rsp),%rbx
  67ea6c:	00 
  67ea6d:	48 3b 9c 24 d8 00 00 	cmp    0xd8(%rsp),%rbx
  67ea74:	00 
  67ea75:	0f 85 42 f8 ff ff    	jne    67e2bd <<gpui_canvas::text::planner::Planner>::shape+0x171d>
  67ea7b:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  67ea82:	00 
  67ea83:	ff 15 27 a8 10 00    	call   *0x10a827(%rip)        # 7892b0 <_DYNAMIC+0x498>
  67ea89:	e9 2f f8 ff ff       	jmp    67e2bd <<gpui_canvas::text::planner::Planner>::shape+0x171d>
  67ea8e:	4d 85 c9             	test   %r9,%r9
  67ea91:	0f 84 b4 00 00 00    	je     67eb4b <<gpui_canvas::text::planner::Planner>::shape+0x1fab>
  67ea97:	4c 3b 4c 24 20       	cmp    0x20(%rsp),%r9
  67ea9c:	0f 83 a3 00 00 00    	jae    67eb45 <<gpui_canvas::text::planner::Planner>::shape+0x1fa5>
  67eaa2:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67eaa7:	42 80 3c 08 bf       	cmpb   $0xbf,(%rax,%r9,1)
  67eaac:	0f 8f 99 00 00 00    	jg     67eb4b <<gpui_canvas::text::planner::Planner>::shape+0x1fab>
  67eab2:	e9 a4 0d 00 00       	jmp    67f85b <<gpui_canvas::text::planner::Planner>::shape+0x2cbb>
  67eab7:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  67eabe:	00 
  67eabf:	44 89 ee             	mov    %r13d,%esi
  67eac2:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  67eac6:	48 8b 94 24 c0 01 00 	mov    0x1c0(%rsp),%rdx
  67eacd:	00 
  67eace:	f3 0f 10 44 c2 10    	movss  0x10(%rdx,%rax,8),%xmm0
  67ead4:	0f 57 c9             	xorps  %xmm1,%xmm1
  67ead7:	0f 29 8c 24 b0 01 00 	movaps %xmm1,0x1b0(%rsp)
  67eade:	00 
  67eadf:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  67eae5:	b8 04 00 00 00       	mov    $0x4,%eax
  67eaea:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  67eaf1:	00 
  67eaf2:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  67eaf9:	00 
  67eafa:	f3 0f 11 84 24 98 01 	movss  %xmm0,0x198(%rsp)
  67eb01:	00 00 
  67eb03:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  67eb0a:	00 00 
  67eb0c:	89 b4 24 9c 01 00 00 	mov    %esi,0x19c(%rsp)
  67eb13:	89 f5                	mov    %esi,%ebp
  67eb15:	0f 57 c0             	xorps  %xmm0,%xmm0
  67eb18:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  67eb1f:	00 
  67eb20:	83 bc 24 d0 00 00 00 	cmpl   $0x0,0xd0(%rsp)
  67eb27:	00 
  67eb28:	0f 85 3a f8 ff ff    	jne    67e368 <<gpui_canvas::text::planner::Planner>::shape+0x17c8>
  67eb2e:	e9 a4 f8 ff ff       	jmp    67e3d7 <<gpui_canvas::text::planner::Planner>::shape+0x1837>
  67eb33:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  67eb38:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  67eb3f:	00 
  67eb40:	e9 5e f8 ff ff       	jmp    67e3a3 <<gpui_canvas::text::planner::Planner>::shape+0x1803>
  67eb45:	0f 85 10 0d 00 00    	jne    67f85b <<gpui_canvas::text::planner::Planner>::shape+0x2cbb>
  67eb4b:	48 85 c9             	test   %rcx,%rcx
  67eb4e:	48 89 8c 24 38 02 00 	mov    %rcx,0x238(%rsp)
  67eb55:	00 
  67eb56:	74 1d                	je     67eb75 <<gpui_canvas::text::planner::Planner>::shape+0x1fd5>
  67eb58:	48 3b 4c 24 20       	cmp    0x20(%rsp),%rcx
  67eb5d:	73 10                	jae    67eb6f <<gpui_canvas::text::planner::Planner>::shape+0x1fcf>
  67eb5f:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67eb64:	80 3c 08 c0          	cmpb   $0xc0,(%rax,%rcx,1)
  67eb68:	7d 0b                	jge    67eb75 <<gpui_canvas::text::planner::Planner>::shape+0x1fd5>
  67eb6a:	e9 f8 0c 00 00       	jmp    67f867 <<gpui_canvas::text::planner::Planner>::shape+0x2cc7>
  67eb6f:	0f 85 f2 0c 00 00    	jne    67f867 <<gpui_canvas::text::planner::Planner>::shape+0x2cc7>
  67eb75:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67eb7a:	4c 89 cd             	mov    %r9,%rbp
  67eb7d:	4a 8d 1c 08          	lea    (%rax,%r9,1),%rbx
  67eb81:	48 01 c8             	add    %rcx,%rax
  67eb84:	48 89 84 24 b0 01 00 	mov    %rax,0x1b0(%rsp)
  67eb8b:	00 
  67eb8c:	0f 1f 40 00          	nopl   0x0(%rax)
  67eb90:	48 3b 9c 24 b0 01 00 	cmp    0x1b0(%rsp),%rbx
  67eb97:	00 
  67eb98:	0f 84 8c 00 00 00    	je     67ec2a <<gpui_canvas::text::planner::Planner>::shape+0x208a>
  67eb9e:	0f b6 33             	movzbl (%rbx),%esi
  67eba1:	40 84 f6             	test   %sil,%sil
  67eba4:	78 0a                	js     67ebb0 <<gpui_canvas::text::planner::Planner>::shape+0x2010>
  67eba6:	48 ff c3             	inc    %rbx
  67eba9:	eb 65                	jmp    67ec10 <<gpui_canvas::text::planner::Planner>::shape+0x2070>
  67ebab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  67ebb0:	89 f0                	mov    %esi,%eax
  67ebb2:	83 e0 1f             	and    $0x1f,%eax
  67ebb5:	0f b6 53 01          	movzbl 0x1(%rbx),%edx
  67ebb9:	83 e2 3f             	and    $0x3f,%edx
  67ebbc:	40 80 fe df          	cmp    $0xdf,%sil
  67ebc0:	76 2c                	jbe    67ebee <<gpui_canvas::text::planner::Planner>::shape+0x204e>
  67ebc2:	0f b6 4b 02          	movzbl 0x2(%rbx),%ecx
  67ebc6:	c1 e2 06             	shl    $0x6,%edx
  67ebc9:	83 e1 3f             	and    $0x3f,%ecx
  67ebcc:	09 d1                	or     %edx,%ecx
  67ebce:	40 80 fe f0          	cmp    $0xf0,%sil
  67ebd2:	72 27                	jb     67ebfb <<gpui_canvas::text::planner::Planner>::shape+0x205b>
  67ebd4:	0f b6 73 03          	movzbl 0x3(%rbx),%esi
  67ebd8:	48 83 c3 04          	add    $0x4,%rbx
  67ebdc:	83 e0 07             	and    $0x7,%eax
  67ebdf:	c1 e0 12             	shl    $0x12,%eax
  67ebe2:	c1 e1 06             	shl    $0x6,%ecx
  67ebe5:	83 e6 3f             	and    $0x3f,%esi
  67ebe8:	09 ce                	or     %ecx,%esi
  67ebea:	09 c6                	or     %eax,%esi
  67ebec:	eb 22                	jmp    67ec10 <<gpui_canvas::text::planner::Planner>::shape+0x2070>
  67ebee:	48 83 c3 02          	add    $0x2,%rbx
  67ebf2:	c1 e0 06             	shl    $0x6,%eax
  67ebf5:	09 d0                	or     %edx,%eax
  67ebf7:	89 c6                	mov    %eax,%esi
  67ebf9:	eb 15                	jmp    67ec10 <<gpui_canvas::text::planner::Planner>::shape+0x2070>
  67ebfb:	48 83 c3 03          	add    $0x3,%rbx
  67ebff:	c1 e0 0c             	shl    $0xc,%eax
  67ec02:	09 c1                	or     %eax,%ecx
  67ec04:	89 ce                	mov    %ecx,%esi
  67ec06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  67ec0d:	00 00 00 
  67ec10:	48 8d 3d 59 04 10 00 	lea    0x100459(%rip),%rdi        # 77f070 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x480>
  67ec17:	ff 15 ab aa 10 00    	call   *0x10aaab(%rip)        # 7896c8 <_DYNAMIC+0x8b0>
  67ec1d:	84 c0                	test   %al,%al
  67ec1f:	0f 85 6b ff ff ff    	jne    67eb90 <<gpui_canvas::text::planner::Planner>::shape+0x1ff0>
  67ec25:	e9 43 0c 00 00       	jmp    67f86d <<gpui_canvas::text::planner::Planner>::shape+0x2ccd>
  67ec2a:	31 c0                	xor    %eax,%eax
  67ec2c:	0f 57 c0             	xorps  %xmm0,%xmm0
  67ec2f:	f3 0f 10 8c 24 00 01 	movss  0x100(%rsp),%xmm1
  67ec36:	00 00 
  67ec38:	0f 2e c8             	ucomiss %xmm0,%xmm1
  67ec3b:	48 8b 9c 24 d0 01 00 	mov    0x1d0(%rsp),%rbx
  67ec42:	00 
  67ec43:	f3 0f 10 94 24 a4 01 	movss  0x1a4(%rsp),%xmm2
  67ec4a:	00 00 
  67ec4c:	0f 85 1b 0c 00 00    	jne    67f86d <<gpui_canvas::text::planner::Planner>::shape+0x2ccd>
  67ec52:	0f 8b d3 f6 ff ff    	jnp    67e32b <<gpui_canvas::text::planner::Planner>::shape+0x178b>
  67ec58:	e9 10 0c 00 00       	jmp    67f86d <<gpui_canvas::text::planner::Planner>::shape+0x2ccd>
  67ec5d:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  67ec62:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  67ec69:	00 
  67ec6a:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  67ec71:	00 
  67ec72:	e9 2c f7 ff ff       	jmp    67e3a3 <<gpui_canvas::text::planner::Planner>::shape+0x1803>
  67ec77:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  67ec7e:	00 
  67ec7f:	48 8d b4 24 90 04 00 	lea    0x490(%rsp),%rsi
  67ec86:	00 
  67ec87:	e8 34 22 00 00       	call   680ec0 <<core::iter::adapters::flatten::FlattenCompat<core::iter::adapters::map::Map<core::ops::range::Range<u32>, <parley::layout::run::Run<()>>::glyph_source_ranges::{closure#0}>, core::iter::sources::repeat_n::RepeatN<core::ops::range::Range<usize>>> as core::iter::traits::iterator::Iterator>::next>
  67ec8c:	48 83 bc 24 90 00 00 	cmpq   $0x0,0x90(%rsp)
  67ec93:	00 00 
  67ec95:	0f 85 70 0a 00 00    	jne    67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67ec9b:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67eca2:	00 
  67eca3:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67eca7:	0f 84 dd f1 ff ff    	je     67de8a <<gpui_canvas::text::planner::Planner>::shape+0x12ea>
  67ecad:	48 8b 8c 24 28 04 00 	mov    0x428(%rsp),%rcx
  67ecb4:	00 
  67ecb5:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  67ecbc:	00 
  67ecbd:	48 3b 94 24 30 01 00 	cmp    0x130(%rsp),%rdx
  67ecc4:	00 
  67ecc5:	75 07                	jne    67ecce <<gpui_canvas::text::planner::Planner>::shape+0x212e>
  67ecc7:	31 db                	xor    %ebx,%ebx
  67ecc9:	45 31 ff             	xor    %r15d,%r15d
  67eccc:	eb 79                	jmp    67ed47 <<gpui_canvas::text::planner::Planner>::shape+0x21a7>
  67ecce:	48 8b 94 24 38 04 00 	mov    0x438(%rsp),%rdx
  67ecd5:	00 
  67ecd6:	48 85 d2             	test   %rdx,%rdx
  67ecd9:	48 0f 44 d1          	cmove  %rcx,%rdx
  67ecdd:	48 8b 1a             	mov    (%rdx),%rbx
  67ece0:	4c 8b 7a 08          	mov    0x8(%rdx),%r15
  67ece4:	4c 39 fb             	cmp    %r15,%rbx
  67ece7:	0f 87 1e 0a 00 00    	ja     67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67eced:	48 85 db             	test   %rbx,%rbx
  67ecf0:	74 1a                	je     67ed0c <<gpui_canvas::text::planner::Planner>::shape+0x216c>
  67ecf2:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  67ecf7:	48 39 d3             	cmp    %rdx,%rbx
  67ecfa:	73 14                	jae    67ed10 <<gpui_canvas::text::planner::Planner>::shape+0x2170>
  67ecfc:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  67ed01:	80 3c 1a bf          	cmpb   $0xbf,(%rdx,%rbx,1)
  67ed05:	7f 12                	jg     67ed19 <<gpui_canvas::text::planner::Planner>::shape+0x2179>
  67ed07:	e9 ff 09 00 00       	jmp    67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67ed0c:	31 db                	xor    %ebx,%ebx
  67ed0e:	eb 09                	jmp    67ed19 <<gpui_canvas::text::planner::Planner>::shape+0x2179>
  67ed10:	48 89 d3             	mov    %rdx,%rbx
  67ed13:	0f 85 f2 09 00 00    	jne    67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67ed19:	4d 85 ff             	test   %r15,%r15
  67ed1c:	74 1b                	je     67ed39 <<gpui_canvas::text::planner::Planner>::shape+0x2199>
  67ed1e:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  67ed23:	49 39 d7             	cmp    %rdx,%r15
  67ed26:	73 16                	jae    67ed3e <<gpui_canvas::text::planner::Planner>::shape+0x219e>
  67ed28:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  67ed2d:	42 80 3c 3a c0       	cmpb   $0xc0,(%rdx,%r15,1)
  67ed32:	7d 13                	jge    67ed47 <<gpui_canvas::text::planner::Planner>::shape+0x21a7>
  67ed34:	e9 d2 09 00 00       	jmp    67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67ed39:	45 31 ff             	xor    %r15d,%r15d
  67ed3c:	eb 09                	jmp    67ed47 <<gpui_canvas::text::planner::Planner>::shape+0x21a7>
  67ed3e:	49 89 d7             	mov    %rdx,%r15
  67ed41:	0f 85 c4 09 00 00    	jne    67f70b <<gpui_canvas::text::planner::Planner>::shape+0x2b6b>
  67ed47:	8b 94 24 e8 00 00 00 	mov    0xe8(%rsp),%edx
  67ed4e:	89 54 24 18          	mov    %edx,0x18(%rsp)
  67ed52:	0f b6 a9 8c 00 00 00 	movzbl 0x8c(%rcx),%ebp
  67ed59:	4c 8b ac 24 58 01 00 	mov    0x158(%rsp),%r13
  67ed60:	00 
  67ed61:	49 39 c5             	cmp    %rax,%r13
  67ed64:	75 0e                	jne    67ed74 <<gpui_canvas::text::planner::Planner>::shape+0x21d4>
  67ed66:	48 8d bc 24 48 01 00 	lea    0x148(%rsp),%rdi
  67ed6d:	00 
  67ed6e:	ff 15 4c a5 10 00    	call   *0x10a54c(%rip)        # 7892c0 <_DYNAMIC+0x4a8>
  67ed74:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
  67ed7b:	00 
  67ed7c:	01 c3                	add    %eax,%ebx
  67ed7e:	41 01 c7             	add    %eax,%r15d
  67ed81:	40 80 e5 01          	and    $0x1,%bpl
  67ed85:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  67ed8c:	00 
  67ed8d:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  67ed94:	00 
  67ed95:	4c 01 e9             	add    %r13,%rcx
  67ed98:	89 1c c8             	mov    %ebx,(%rax,%rcx,8)
  67ed9b:	44 89 7c c8 04       	mov    %r15d,0x4(%rax,%rcx,8)
  67eda0:	48 8b 94 24 38 03 00 	mov    0x338(%rsp),%rdx
  67eda7:	00 
  67eda8:	89 54 c8 08          	mov    %edx,0x8(%rax,%rcx,8)
  67edac:	8b 54 24 18          	mov    0x18(%rsp),%edx
  67edb0:	89 54 c8 0c          	mov    %edx,0xc(%rax,%rcx,8)
  67edb4:	48 8b 94 24 48 02 00 	mov    0x248(%rsp),%rdx
  67edbb:	00 
  67edbc:	89 54 c8 10          	mov    %edx,0x10(%rax,%rcx,8)
  67edc0:	48 8b 94 24 50 02 00 	mov    0x250(%rsp),%rdx
  67edc7:	00 
  67edc8:	88 54 c8 14          	mov    %dl,0x14(%rax,%rcx,8)
  67edcc:	40 88 6c c8 15       	mov    %bpl,0x15(%rax,%rcx,8)
  67edd1:	49 ff c5             	inc    %r13
  67edd4:	4c 89 ac 24 58 01 00 	mov    %r13,0x158(%rsp)
  67eddb:	00 
  67eddc:	e9 a9 f0 ff ff       	jmp    67de8a <<gpui_canvas::text::planner::Planner>::shape+0x12ea>
  67ede1:	48 8b 84 24 48 03 00 	mov    0x348(%rsp),%rax
  67ede8:	00 
  67ede9:	48 39 84 24 88 00 00 	cmp    %rax,0x88(%rsp)
  67edf0:	00 
  67edf1:	48 8b ac 24 30 01 00 	mov    0x130(%rsp),%rbp
  67edf8:	00 
  67edf9:	4c 8b bc 24 28 01 00 	mov    0x128(%rsp),%r15
  67ee00:	00 
  67ee01:	0f 85 ff eb ff ff    	jne    67da06 <<gpui_canvas::text::planner::Planner>::shape+0xe66>
  67ee07:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  67ee0e:	00 ff 
  67ee10:	0f 84 b9 05 00 00    	je     67f3cf <<gpui_canvas::text::planner::Planner>::shape+0x282f>
  67ee16:	48 83 bc 24 78 01 00 	cmpq   $0xffffffffffffffff,0x178(%rsp)
  67ee1d:	00 ff 
  67ee1f:	0f 84 aa 05 00 00    	je     67f3cf <<gpui_canvas::text::planner::Planner>::shape+0x282f>
  67ee25:	48 89 ac 24 20 04 00 	mov    %rbp,0x420(%rsp)
  67ee2c:	00 
  67ee2d:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
  67ee33:	f3 0f 11 84 24 90 00 	movss  %xmm0,0x90(%rsp)
  67ee3a:	00 00 
  67ee3c:	4c 03 bc 24 38 01 00 	add    0x138(%rsp),%r15
  67ee43:	00 
  67ee44:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  67ee4b:	00 00 00 00 00 
  67ee50:	48 c7 84 24 e8 06 00 	movq   $0x8,0x6e8(%rsp)
  67ee57:	00 08 00 00 00 
  67ee5c:	48 c7 84 24 f0 06 00 	movq   $0x0,0x6f0(%rsp)
  67ee63:	00 00 00 00 00 
  67ee68:	c7 84 24 00 07 00 00 	movl   $0xffffffff,0x700(%rsp)
  67ee6f:	ff ff ff ff 
  67ee73:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67ee78:	48 89 84 24 08 07 00 	mov    %rax,0x708(%rsp)
  67ee7f:	00 
  67ee80:	4c 89 bc 24 10 07 00 	mov    %r15,0x710(%rsp)
  67ee87:	00 
  67ee88:	48 c7 84 24 18 07 00 	movq   $0x0,0x718(%rsp)
  67ee8f:	00 00 00 00 00 
  67ee94:	48 8d 05 45 03 10 00 	lea    0x100345(%rip),%rax        # 77f1e0 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x5f0>
  67ee9b:	48 89 84 24 20 07 00 	mov    %rax,0x720(%rsp)
  67eea2:	00 
  67eea3:	48 8d 05 b6 b8 ff ff 	lea    -0x474a(%rip),%rax        # 67a760 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  67eeaa:	48 89 84 24 28 07 00 	mov    %rax,0x728(%rsp)
  67eeb1:	00 
  67eeb2:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  67eeb7:	48 89 84 24 30 07 00 	mov    %rax,0x730(%rsp)
  67eebe:	00 
  67eebf:	48 c7 84 24 38 07 00 	movq   $0x0,0x738(%rsp)
  67eec6:	00 00 00 00 00 
  67eecb:	48 c7 84 24 68 07 00 	movq   $0x0,0x768(%rsp)
  67eed2:	00 00 00 00 00 
  67eed7:	c6 84 24 70 07 00 00 	movb   $0x0,0x770(%rsp)
  67eede:	00 
  67eedf:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67eee6:	00 
  67eee7:	e8 a4 56 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67eeec:	48 83 f8 01          	cmp    $0x1,%rax
  67eef0:	0f 85 73 03 00 00    	jne    67f269 <<gpui_canvas::text::planner::Planner>::shape+0x26c9>
  67eef6:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67eefd:	00 
  67eefe:	e8 8d 56 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67ef03:	48 83 f8 01          	cmp    $0x1,%rax
  67ef07:	0f 85 5c 03 00 00    	jne    67f269 <<gpui_canvas::text::planner::Planner>::shape+0x26c9>
  67ef0d:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67ef14:	00 
  67ef15:	e8 76 56 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67ef1a:	48 83 f8 01          	cmp    $0x1,%rax
  67ef1e:	0f 85 45 03 00 00    	jne    67f269 <<gpui_canvas::text::planner::Planner>::shape+0x26c9>
  67ef24:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67ef2b:	00 
  67ef2c:	e8 5f 56 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67ef31:	48 83 f8 01          	cmp    $0x1,%rax
  67ef35:	0f 85 2e 03 00 00    	jne    67f269 <<gpui_canvas::text::planner::Planner>::shape+0x26c9>
  67ef3b:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67ef42:	00 
  67ef43:	e8 48 56 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67ef48:	48 83 f8 01          	cmp    $0x1,%rax
  67ef4c:	0f 85 17 03 00 00    	jne    67f269 <<gpui_canvas::text::planner::Planner>::shape+0x26c9>
  67ef52:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67ef59:	00 
  67ef5a:	e8 31 56 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67ef5f:	48 83 f8 01          	cmp    $0x1,%rax
  67ef63:	0f 85 00 03 00 00    	jne    67f269 <<gpui_canvas::text::planner::Planner>::shape+0x26c9>
  67ef69:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67ef70:	00 
  67ef71:	e8 1a 56 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67ef76:	48 83 f8 01          	cmp    $0x1,%rax
  67ef7a:	0f 85 e9 02 00 00    	jne    67f269 <<gpui_canvas::text::planner::Planner>::shape+0x26c9>
  67ef80:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67ef87:	00 
  67ef88:	e8 03 56 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67ef8d:	a8 01                	test   $0x1,%al
  67ef8f:	0f 84 d4 02 00 00    	je     67f269 <<gpui_canvas::text::planner::Planner>::shape+0x26c9>
  67ef95:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67ef9c:	00 
  67ef9d:	e8 ee 55 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67efa2:	48 83 f8 01          	cmp    $0x1,%rax
  67efa6:	0f 85 bd 02 00 00    	jne    67f269 <<gpui_canvas::text::planner::Planner>::shape+0x26c9>
  67efac:	48 8b b4 24 e0 06 00 	mov    0x6e0(%rsp),%rsi
  67efb3:	00 
  67efb4:	48 85 f6             	test   %rsi,%rsi
  67efb7:	74 17                	je     67efd0 <<gpui_canvas::text::planner::Planner>::shape+0x2430>
  67efb9:	48 8b bc 24 e8 06 00 	mov    0x6e8(%rsp),%rdi
  67efc0:	00 
  67efc1:	48 c1 e6 03          	shl    $0x3,%rsi
  67efc5:	ba 08 00 00 00       	mov    $0x8,%edx
  67efca:	ff 15 80 a0 10 00    	call   *0x10a080(%rip)        # 789050 <_DYNAMIC+0x238>
  67efd0:	48 8b 9c 24 88 01 00 	mov    0x188(%rsp),%rbx
  67efd7:	00 
  67efd8:	c6 44 24 0f 00       	movb   $0x0,0xf(%rsp)
  67efdd:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  67efe4:	00 00 00 00 00 
  67efe9:	48 c7 84 24 e8 06 00 	movq   $0x8,0x6e8(%rsp)
  67eff0:	00 08 00 00 00 
  67eff5:	48 c7 84 24 f0 06 00 	movq   $0x0,0x6f0(%rsp)
  67effc:	00 00 00 00 00 
  67f001:	c7 84 24 00 07 00 00 	movl   $0xffffffff,0x700(%rsp)
  67f008:	ff ff ff ff 
  67f00c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67f011:	48 89 84 24 08 07 00 	mov    %rax,0x708(%rsp)
  67f018:	00 
  67f019:	4c 89 bc 24 10 07 00 	mov    %r15,0x710(%rsp)
  67f020:	00 
  67f021:	48 c7 84 24 18 07 00 	movq   $0x0,0x718(%rsp)
  67f028:	00 00 00 00 00 
  67f02d:	48 8d 05 ac 01 10 00 	lea    0x1001ac(%rip),%rax        # 77f1e0 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x5f0>
  67f034:	48 89 84 24 20 07 00 	mov    %rax,0x720(%rsp)
  67f03b:	00 
  67f03c:	48 8d 05 1d b7 ff ff 	lea    -0x48e3(%rip),%rax        # 67a760 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  67f043:	48 89 84 24 28 07 00 	mov    %rax,0x728(%rsp)
  67f04a:	00 
  67f04b:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  67f050:	48 89 84 24 30 07 00 	mov    %rax,0x730(%rsp)
  67f057:	00 
  67f058:	48 c7 84 24 38 07 00 	movq   $0x0,0x738(%rsp)
  67f05f:	00 00 00 00 00 
  67f064:	48 c7 84 24 68 07 00 	movq   $0x0,0x768(%rsp)
  67f06b:	00 00 00 00 00 
  67f070:	c6 84 24 70 07 00 00 	movb   $0x0,0x770(%rsp)
  67f077:	00 
  67f078:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
  67f07d:	48 89 84 24 90 04 00 	mov    %rax,0x490(%rsp)
  67f084:	00 
  67f085:	48 8d 84 24 78 01 00 	lea    0x178(%rsp),%rax
  67f08c:	00 
  67f08d:	48 89 84 24 98 04 00 	mov    %rax,0x498(%rsp)
  67f094:	00 
  67f095:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  67f09a:	48 89 bc 24 a0 04 00 	mov    %rdi,0x4a0(%rsp)
  67f0a1:	00 
  67f0a2:	48 8d 84 24 20 04 00 	lea    0x420(%rsp),%rax
  67f0a9:	00 
  67f0aa:	48 89 84 24 a8 04 00 	mov    %rax,0x4a8(%rsp)
  67f0b1:	00 
  67f0b2:	48 8d 84 24 90 00 00 	lea    0x90(%rsp),%rax
  67f0b9:	00 
  67f0ba:	48 89 84 24 b0 04 00 	mov    %rax,0x4b0(%rsp)
  67f0c1:	00 
  67f0c2:	48 8d b4 24 e0 06 00 	lea    0x6e0(%rsp),%rsi
  67f0c9:	00 
  67f0ca:	f3 0f 10 05 9a e6 99 	movss  -0x661966(%rip),%xmm0        # 1d76c <GCC_except_table0+0x28>
  67f0d1:	ff 
  67f0d2:	48 8d 94 24 90 04 00 	lea    0x490(%rsp),%rdx
  67f0d9:	00 
  67f0da:	e8 d1 61 00 00       	call   6852b0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>>
  67f0df:	84 c0                	test   %al,%al
  67f0e1:	0f 84 ac 04 00 00    	je     67f593 <<gpui_canvas::text::planner::Planner>::shape+0x29f3>
  67f0e7:	48 3b 9c 24 88 01 00 	cmp    0x188(%rsp),%rbx
  67f0ee:	00 
  67f0ef:	77 08                	ja     67f0f9 <<gpui_canvas::text::planner::Planner>::shape+0x2559>
  67f0f1:	48 89 9c 24 88 01 00 	mov    %rbx,0x188(%rsp)
  67f0f8:	00 
  67f0f9:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67f100:	00 
  67f101:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  67f106:	e8 b5 75 00 00       	call   6866c0 <<parley::editing::geometry::CursorGeometry<()>>::new>
  67f10b:	48 8b 84 24 e0 06 00 	mov    0x6e0(%rsp),%rax
  67f112:	00 
  67f113:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f117:	0f 84 88 0c 00 00    	je     67fda5 <<gpui_canvas::text::planner::Planner>::shape+0x3205>
  67f11d:	48 8d 94 24 00 07 00 	lea    0x700(%rsp),%rdx
  67f124:	00 
  67f125:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  67f129:	49 89 4e 20          	mov    %rcx,0x20(%r14)
  67f12d:	0f 10 42 f0          	movups -0x10(%rdx),%xmm0
  67f131:	0f 10 0a             	movups (%rdx),%xmm1
  67f134:	41 0f 11 4e 10       	movups %xmm1,0x10(%r14)
  67f139:	41 0f 11 06          	movups %xmm0,(%r14)
  67f13d:	48 8b 8c 24 e8 06 00 	mov    0x6e8(%rsp),%rcx
  67f144:	00 
  67f145:	48 89 84 24 e0 02 00 	mov    %rax,0x2e0(%rsp)
  67f14c:	00 
  67f14d:	48 89 8c 24 e8 02 00 	mov    %rcx,0x2e8(%rsp)
  67f154:	00 
  67f155:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  67f15c:	00 00 00 00 00 
  67f161:	48 c7 84 24 e8 06 00 	movq   $0x8,0x6e8(%rsp)
  67f168:	00 08 00 00 00 
  67f16d:	48 c7 84 24 f0 06 00 	movq   $0x0,0x6f0(%rsp)
  67f174:	00 00 00 00 00 
  67f179:	c7 84 24 00 07 00 00 	movl   $0xffffffff,0x700(%rsp)
  67f180:	ff ff ff ff 
  67f184:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67f189:	48 89 84 24 08 07 00 	mov    %rax,0x708(%rsp)
  67f190:	00 
  67f191:	4c 89 bc 24 10 07 00 	mov    %r15,0x710(%rsp)
  67f198:	00 
  67f199:	48 c7 84 24 18 07 00 	movq   $0x0,0x718(%rsp)
  67f1a0:	00 00 00 00 00 
  67f1a5:	48 8d 05 34 00 10 00 	lea    0x100034(%rip),%rax        # 77f1e0 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x5f0>
  67f1ac:	48 89 84 24 20 07 00 	mov    %rax,0x720(%rsp)
  67f1b3:	00 
  67f1b4:	48 8d 05 a5 b5 ff ff 	lea    -0x4a5b(%rip),%rax        # 67a760 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  67f1bb:	48 89 84 24 28 07 00 	mov    %rax,0x728(%rsp)
  67f1c2:	00 
  67f1c3:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  67f1c8:	48 89 84 24 30 07 00 	mov    %rax,0x730(%rsp)
  67f1cf:	00 
  67f1d0:	48 c7 84 24 38 07 00 	movq   $0x0,0x738(%rsp)
  67f1d7:	00 00 00 00 00 
  67f1dc:	48 c7 84 24 68 07 00 	movq   $0x0,0x768(%rsp)
  67f1e3:	00 00 00 00 00 
  67f1e8:	c6 84 24 70 07 00 00 	movb   $0x0,0x770(%rsp)
  67f1ef:	00 
  67f1f0:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67f1f7:	00 
  67f1f8:	e8 93 53 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67f1fd:	48 83 f8 01          	cmp    $0x1,%rax
  67f201:	0f 85 9c 03 00 00    	jne    67f5a3 <<gpui_canvas::text::planner::Planner>::shape+0x2a03>
  67f207:	49 89 d5             	mov    %rdx,%r13
  67f20a:	48 8d bc 24 90 04 00 	lea    0x490(%rsp),%rdi
  67f211:	00 
  67f212:	48 8d b4 24 e0 02 00 	lea    0x2e0(%rsp),%rsi
  67f219:	00 
  67f21a:	f3 0f 10 05 4a e5 99 	movss  -0x661ab6(%rip),%xmm0        # 1d76c <GCC_except_table0+0x28>
  67f221:	ff 
  67f222:	e8 29 72 00 00       	call   686450 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at>
  67f227:	83 bc 24 90 04 00 00 	cmpl   $0x1,0x490(%rsp)
  67f22e:	01 
  67f22f:	75 bf                	jne    67f1f0 <<gpui_canvas::text::planner::Planner>::shape+0x2650>
  67f231:	48 8b 94 24 20 04 00 	mov    0x420(%rsp),%rdx
  67f238:	00 
  67f239:	f3 0f 10 84 24 90 00 	movss  0x90(%rsp),%xmm0
  67f240:	00 00 
  67f242:	48 8d bc 24 78 01 00 	lea    0x178(%rsp),%rdi
  67f249:	00 
  67f24a:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  67f24f:	4c 89 e9             	mov    %r13,%rcx
  67f252:	4c 8d 84 24 90 04 00 	lea    0x490(%rsp),%r8
  67f259:	00 
  67f25a:	e8 a1 18 00 00       	call   680b00 <gpui_canvas::text::planner::append_caret>
  67f25f:	83 f8 ff             	cmp    $0xffffffff,%eax
  67f262:	74 8c                	je     67f1f0 <<gpui_canvas::text::planner::Planner>::shape+0x2650>
  67f264:	e9 fd 0a 00 00       	jmp    67fd66 <<gpui_canvas::text::planner::Planner>::shape+0x31c6>
  67f269:	48 8b b4 24 e0 06 00 	mov    0x6e0(%rsp),%rsi
  67f270:	00 
  67f271:	48 85 f6             	test   %rsi,%rsi
  67f274:	74 17                	je     67f28d <<gpui_canvas::text::planner::Planner>::shape+0x26ed>
  67f276:	48 8b bc 24 e8 06 00 	mov    0x6e8(%rsp),%rdi
  67f27d:	00 
  67f27e:	48 c1 e6 03          	shl    $0x3,%rsi
  67f282:	ba 08 00 00 00       	mov    $0x8,%edx
  67f287:	ff 15 c3 9d 10 00    	call   *0x109dc3(%rip)        # 789050 <_DYNAMIC+0x238>
  67f28d:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  67f294:	00 00 00 00 00 
  67f299:	48 c7 84 24 e8 06 00 	movq   $0x8,0x6e8(%rsp)
  67f2a0:	00 08 00 00 00 
  67f2a5:	48 c7 84 24 f0 06 00 	movq   $0x0,0x6f0(%rsp)
  67f2ac:	00 00 00 00 00 
  67f2b1:	c7 84 24 00 07 00 00 	movl   $0xffffffff,0x700(%rsp)
  67f2b8:	ff ff ff ff 
  67f2bc:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67f2c1:	48 89 84 24 08 07 00 	mov    %rax,0x708(%rsp)
  67f2c8:	00 
  67f2c9:	4c 89 bc 24 10 07 00 	mov    %r15,0x710(%rsp)
  67f2d0:	00 
  67f2d1:	48 c7 84 24 18 07 00 	movq   $0x0,0x718(%rsp)
  67f2d8:	00 00 00 00 00 
  67f2dd:	48 8d 05 fc fe 0f 00 	lea    0xffefc(%rip),%rax        # 77f1e0 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x5f0>
  67f2e4:	48 89 84 24 20 07 00 	mov    %rax,0x720(%rsp)
  67f2eb:	00 
  67f2ec:	48 8d 05 6d b4 ff ff 	lea    -0x4b93(%rip),%rax        # 67a760 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  67f2f3:	48 89 84 24 28 07 00 	mov    %rax,0x728(%rsp)
  67f2fa:	00 
  67f2fb:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  67f300:	48 89 84 24 30 07 00 	mov    %rax,0x730(%rsp)
  67f307:	00 
  67f308:	48 c7 84 24 38 07 00 	movq   $0x0,0x738(%rsp)
  67f30f:	00 00 00 00 00 
  67f314:	48 c7 84 24 68 07 00 	movq   $0x0,0x768(%rsp)
  67f31b:	00 00 00 00 00 
  67f320:	c6 84 24 70 07 00 00 	movb   $0x0,0x770(%rsp)
  67f327:	00 
  67f328:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  67f32f:	00 
  67f330:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67f337:	00 
  67f338:	e8 53 52 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  67f33d:	48 83 f8 01          	cmp    $0x1,%rax
  67f341:	75 68                	jne    67f3ab <<gpui_canvas::text::planner::Planner>::shape+0x280b>
  67f343:	48 89 d1             	mov    %rdx,%rcx
  67f346:	48 c7 84 24 90 04 00 	movq   $0x0,0x490(%rsp)
  67f34d:	00 00 00 00 00 
  67f352:	48 8d bc 24 78 01 00 	lea    0x178(%rsp),%rdi
  67f359:	00 
  67f35a:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  67f35f:	48 89 ea             	mov    %rbp,%rdx
  67f362:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
  67f368:	4c 8d 84 24 90 04 00 	lea    0x490(%rsp),%r8
  67f36f:	00 
  67f370:	e8 8b 17 00 00       	call   680b00 <gpui_canvas::text::planner::append_caret>
  67f375:	83 f8 ff             	cmp    $0xffffffff,%eax
  67f378:	74 b6                	je     67f330 <<gpui_canvas::text::planner::Planner>::shape+0x2790>
  67f37a:	e9 38 03 00 00       	jmp    67f6b7 <<gpui_canvas::text::planner::Planner>::shape+0x2b17>
  67f37f:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
  67f384:	4c 3b 8c 24 40 01 00 	cmp    0x140(%rsp),%r9
  67f38b:	00 
  67f38c:	0f 84 24 01 00 00    	je     67f4b6 <<gpui_canvas::text::planner::Planner>::shape+0x2916>
  67f392:	45 0f b6 11          	movzbl (%r9),%r10d
  67f396:	49 89 f3             	mov    %rsi,%r11
  67f399:	45 84 d2             	test   %r10b,%r10b
  67f39c:	0f 88 2c 01 00 00    	js     67f4ce <<gpui_canvas::text::planner::Planner>::shape+0x292e>
  67f3a2:	49 8d 49 01          	lea    0x1(%r9),%rcx
  67f3a6:	e9 82 01 00 00       	jmp    67f52d <<gpui_canvas::text::planner::Planner>::shape+0x298d>
  67f3ab:	48 8b b4 24 e0 06 00 	mov    0x6e0(%rsp),%rsi
  67f3b2:	00 
  67f3b3:	48 85 f6             	test   %rsi,%rsi
  67f3b6:	74 17                	je     67f3cf <<gpui_canvas::text::planner::Planner>::shape+0x282f>
  67f3b8:	48 8b bc 24 e8 06 00 	mov    0x6e8(%rsp),%rdi
  67f3bf:	00 
  67f3c0:	48 c1 e6 03          	shl    $0x3,%rsi
  67f3c4:	ba 08 00 00 00       	mov    $0x8,%edx
  67f3c9:	ff 15 81 9c 10 00    	call   *0x109c81(%rip)        # 789050 <_DYNAMIC+0x238>
  67f3cf:	0f 28 9c 24 70 02 00 	movaps 0x270(%rsp),%xmm3
  67f3d6:	00 
  67f3d7:	0f 28 c3             	movaps %xmm3,%xmm0
  67f3da:	f3 0f 5f 84 24 c8 00 	maxss  0xc8(%rsp),%xmm0
  67f3e1:	00 00 
  67f3e3:	0f 28 c8             	movaps %xmm0,%xmm1
  67f3e6:	f3 0f c2 c8 03       	cmpunordss %xmm0,%xmm1
  67f3eb:	0f 28 d1             	movaps %xmm1,%xmm2
  67f3ee:	0f 55 d0             	andnps %xmm0,%xmm2
  67f3f1:	0f 54 cb             	andps  %xmm3,%xmm1
  67f3f4:	0f 56 ca             	orps   %xmm2,%xmm1
  67f3f7:	0f 29 8c 24 70 02 00 	movaps %xmm1,0x270(%rsp)
  67f3fe:	00 
  67f3ff:	48 8b 04 24          	mov    (%rsp),%rax
  67f403:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
  67f409:	f3 0f 58 80 30 0a 00 	addss  0xa30(%rax),%xmm0
  67f410:	00 
  67f411:	f3 0f 11 44 24 50    	movss  %xmm0,0x50(%rsp)
  67f417:	80 7c 24 44 00       	cmpb   $0x0,0x44(%rsp)
  67f41c:	48 8b 84 24 60 03 00 	mov    0x360(%rsp),%rax
  67f423:	00 
  67f424:	8b 74 24 74          	mov    0x74(%rsp),%esi
  67f428:	48 8b 9c 24 58 03 00 	mov    0x358(%rsp),%rbx
  67f42f:	00 
  67f430:	0f 84 c5 dd ff ff    	je     67d1fb <<gpui_canvas::text::planner::Planner>::shape+0x65b>
  67f436:	e9 c6 03 00 00       	jmp    67f801 <<gpui_canvas::text::planner::Planner>::shape+0x2c61>
  67f43b:	48 8b 0c 24          	mov    (%rsp),%rcx
  67f43f:	48 8b 81 d8 09 00 00 	mov    0x9d8(%rcx),%rax
  67f446:	48 6b 89 e0 09 00 00 	imul   $0x70,0x9e0(%rcx),%rcx
  67f44d:	70 
  67f44e:	48 01 c1             	add    %rax,%rcx
  67f451:	48 89 84 24 e0 06 00 	mov    %rax,0x6e0(%rsp)
  67f458:	00 
  67f459:	48 89 8c 24 e8 06 00 	mov    %rcx,0x6e8(%rsp)
  67f460:	00 
  67f461:	48 c7 84 24 f0 06 00 	movq   $0x0,0x6f0(%rsp)
  67f468:	00 00 00 00 00 
  67f46d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  67f472:	48 89 84 24 f8 06 00 	mov    %rax,0x6f8(%rsp)
  67f479:	00 
  67f47a:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67f481:	00 
  67f482:	31 f6                	xor    %esi,%esi
  67f484:	48 8d 94 24 d7 00 00 	lea    0xd7(%rsp),%rdx
  67f48b:	00 
  67f48c:	e8 8f 97 fe ff       	call   668c20 <<core::iter::adapters::map::Map<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#3}> as core::iter::traits::iterator::Iterator>::fold::<usize, <core::iter::adapters::flatten::FlattenCompat<_, _>>::iter_fold::flatten<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, usize, <core::iter::adapters::flatten::FlattenCompat<_, _> as core::iter::traits::iterator::Iterator>::count::count<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>>>::{closure#0}>>
  67f491:	48 83 f8 02          	cmp    $0x2,%rax
  67f495:	0f 82 25 e3 ff ff    	jb     67d7c0 <<gpui_canvas::text::planner::Planner>::shape+0xc20>
  67f49b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  67f4a2:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  67f4a9:	00 ff 
  67f4ab:	0f 84 95 e2 ff ff    	je     67d746 <<gpui_canvas::text::planner::Planner>::shape+0xba6>
  67f4b1:	e9 0a e3 ff ff       	jmp    67d7c0 <<gpui_canvas::text::planner::Planner>::shape+0xc20>
  67f4b6:	c7 44 24 74 ff ff ff 	movl   $0xffffffff,0x74(%rsp)
  67f4bd:	ff 
  67f4be:	c7 44 24 44 00 00 00 	movl   $0x0,0x44(%rsp)
  67f4c5:	00 
  67f4c6:	4d 89 c7             	mov    %r8,%r15
  67f4c9:	e9 6b df ff ff       	jmp    67d439 <<gpui_canvas::text::planner::Planner>::shape+0x899>
  67f4ce:	44 89 d2             	mov    %r10d,%edx
  67f4d1:	83 e2 1f             	and    $0x1f,%edx
  67f4d4:	41 0f b6 79 01       	movzbl 0x1(%r9),%edi
  67f4d9:	83 e7 3f             	and    $0x3f,%edi
  67f4dc:	41 80 fa df          	cmp    $0xdf,%r10b
  67f4e0:	76 31                	jbe    67f513 <<gpui_canvas::text::planner::Planner>::shape+0x2973>
  67f4e2:	41 0f b6 71 02       	movzbl 0x2(%r9),%esi
  67f4e7:	c1 e7 06             	shl    $0x6,%edi
  67f4ea:	83 e6 3f             	and    $0x3f,%esi
  67f4ed:	09 fe                	or     %edi,%esi
  67f4ef:	41 80 fa f0          	cmp    $0xf0,%r10b
  67f4f3:	72 2c                	jb     67f521 <<gpui_canvas::text::planner::Planner>::shape+0x2981>
  67f4f5:	49 8d 49 04          	lea    0x4(%r9),%rcx
  67f4f9:	45 0f b6 51 03       	movzbl 0x3(%r9),%r10d
  67f4fe:	83 e2 07             	and    $0x7,%edx
  67f501:	c1 e2 12             	shl    $0x12,%edx
  67f504:	c1 e6 06             	shl    $0x6,%esi
  67f507:	41 83 e2 3f          	and    $0x3f,%r10d
  67f50b:	41 09 f2             	or     %esi,%r10d
  67f50e:	41 09 d2             	or     %edx,%r10d
  67f511:	eb 1a                	jmp    67f52d <<gpui_canvas::text::planner::Planner>::shape+0x298d>
  67f513:	49 8d 49 02          	lea    0x2(%r9),%rcx
  67f517:	c1 e2 06             	shl    $0x6,%edx
  67f51a:	09 fa                	or     %edi,%edx
  67f51c:	41 89 d2             	mov    %edx,%r10d
  67f51f:	eb 0c                	jmp    67f52d <<gpui_canvas::text::planner::Planner>::shape+0x298d>
  67f521:	49 8d 49 03          	lea    0x3(%r9),%rcx
  67f525:	c1 e2 0c             	shl    $0xc,%edx
  67f528:	09 d6                	or     %edx,%esi
  67f52a:	41 89 f2             	mov    %esi,%r10d
  67f52d:	4d 89 c7             	mov    %r8,%r15
  67f530:	49 8d 50 02          	lea    0x2(%r8),%rdx
  67f534:	48 89 c6             	mov    %rax,%rsi
  67f537:	4c 29 ce             	sub    %r9,%rsi
  67f53a:	48 01 ce             	add    %rcx,%rsi
  67f53d:	41 83 fa 0a          	cmp    $0xa,%r10d
  67f541:	bf fe ff ff ff       	mov    $0xfffffffe,%edi
  67f546:	44 0f 44 d7          	cmove  %edi,%r10d
  67f54a:	44 89 54 24 74       	mov    %r10d,0x74(%rsp)
  67f54f:	4c 0f 44 da          	cmove  %rdx,%r11
  67f553:	c7 44 24 44 00 00 00 	movl   $0x0,0x44(%rsp)
  67f55a:	00 
  67f55b:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  67f562:	00 
  67f563:	48 89 f0             	mov    %rsi,%rax
  67f566:	4c 89 de             	mov    %r11,%rsi
  67f569:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  67f56e:	e9 c6 de ff ff       	jmp    67d439 <<gpui_canvas::text::planner::Planner>::shape+0x899>
  67f573:	b9 04 00 00 00       	mov    $0x4,%ecx
  67f578:	41 b8 10 00 00 00    	mov    $0x10,%r8d
  67f57e:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  67f585:	00 
  67f586:	4c 89 ea             	mov    %r13,%rdx
  67f589:	e8 a2 46 fe ff       	call   663c30 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  67f58e:	e9 ab e3 ff ff       	jmp    67d93e <<gpui_canvas::text::planner::Planner>::shape+0xd9e>
  67f593:	80 7c 24 0f 00       	cmpb   $0x0,0xf(%rsp)
  67f598:	0f 84 31 fe ff ff    	je     67f3cf <<gpui_canvas::text::planner::Planner>::shape+0x282f>
  67f59e:	e9 fb 07 00 00       	jmp    67fd9e <<gpui_canvas::text::planner::Planner>::shape+0x31fe>
  67f5a3:	48 8b b4 24 e0 06 00 	mov    0x6e0(%rsp),%rsi
  67f5aa:	00 
  67f5ab:	48 85 f6             	test   %rsi,%rsi
  67f5ae:	74 17                	je     67f5c7 <<gpui_canvas::text::planner::Planner>::shape+0x2a27>
  67f5b0:	48 8b bc 24 e8 06 00 	mov    0x6e8(%rsp),%rdi
  67f5b7:	00 
  67f5b8:	48 c1 e6 03          	shl    $0x3,%rsi
  67f5bc:	ba 08 00 00 00       	mov    $0x8,%edx
  67f5c1:	ff 15 89 9a 10 00    	call   *0x109a89(%rip)        # 789050 <_DYNAMIC+0x238>
  67f5c7:	48 8d bc 24 e0 02 00 	lea    0x2e0(%rsp),%rdi
  67f5ce:	00 
  67f5cf:	e8 fc bd ff ff       	call   67b3d0 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
  67f5d4:	e9 f6 fd ff ff       	jmp    67f3cf <<gpui_canvas::text::planner::Planner>::shape+0x282f>
  67f5d9:	c7 84 24 98 00 00 00 	movl   $0x7,0x98(%rsp)
  67f5e0:	07 00 00 00 
  67f5e4:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67f5eb:	00 ff ff ff ff 
  67f5f0:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67f5f7:	00 
  67f5f8:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f5fc:	0f 85 c9 07 00 00    	jne    67fdcb <<gpui_canvas::text::planner::Planner>::shape+0x322b>
  67f602:	e9 3a 08 00 00       	jmp    67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67f607:	c7 84 24 98 00 00 00 	movl   $0x4,0x98(%rsp)
  67f60e:	04 00 00 00 
  67f612:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67f619:	00 ff ff ff ff 
  67f61e:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67f625:	00 
  67f626:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f62a:	0f 85 9b 07 00 00    	jne    67fdcb <<gpui_canvas::text::planner::Planner>::shape+0x322b>
  67f630:	e9 0c 08 00 00       	jmp    67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67f635:	48 8d 35 6c ca 10 00 	lea    0x10ca6c(%rip),%rsi        # 78c0a8 <gpui_canvas::text::HEBREW_FONT>
  67f63c:	48 8d 15 a1 0f 9e ff 	lea    -0x61f05f(%rip),%rdx        # 605e4 <gpui_canvas::text::HEBREW_BYTES>
  67f643:	48 8d bc 24 e0 06 00 	lea    0x6e0(%rsp),%rdi
  67f64a:	00 
  67f64b:	b9 14 69 00 00       	mov    $0x6914,%ecx
  67f650:	45 31 c0             	xor    %r8d,%r8d
  67f653:	e8 68 46 fe ff       	call   663cc0 <<gpui_canvas::text::FontFace>::shared_static>
  67f658:	80 bc 24 e0 06 00 00 	cmpb   $0x0,0x6e0(%rsp)
  67f65f:	00 
  67f660:	0f 85 2d d9 ff ff    	jne    67cf93 <<gpui_canvas::text::planner::Planner>::shape+0x3f3>
  67f666:	48 8b 04 24          	mov    (%rsp),%rax
  67f66a:	4c 8d b8 50 0a 00 00 	lea    0xa50(%rax),%r15
  67f671:	4c 8b a4 24 e8 06 00 	mov    0x6e8(%rsp),%r12
  67f678:	00 
  67f679:	49 8b 07             	mov    (%r15),%rax
  67f67c:	48 85 c0             	test   %rax,%rax
  67f67f:	74 0f                	je     67f690 <<gpui_canvas::text::planner::Planner>::shape+0x2af0>
  67f681:	f0 48 ff 08          	lock decq (%rax)
  67f685:	75 09                	jne    67f690 <<gpui_canvas::text::planner::Planner>::shape+0x2af0>
  67f687:	4c 89 ff             	mov    %r15,%rdi
  67f68a:	ff 15 e8 99 10 00    	call   *0x1099e8(%rip)        # 789078 <_DYNAMIC+0x260>
  67f690:	48 8b 3c 24          	mov    (%rsp),%rdi
  67f694:	4c 89 a7 50 0a 00 00 	mov    %r12,0xa50(%rdi)
  67f69b:	be 02 00 00 00       	mov    $0x2,%esi
  67f6a0:	e8 fb 0e 00 00       	call   6805a0 <<gpui_canvas::text::planner::Planner>::register>
  67f6a5:	83 f8 ff             	cmp    $0xffffffff,%eax
  67f6a8:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  67f6ac:	0f 85 42 d9 ff ff    	jne    67cff4 <<gpui_canvas::text::planner::Planner>::shape+0x454>
  67f6b2:	e9 7b d9 ff ff       	jmp    67d032 <<gpui_canvas::text::planner::Planner>::shape+0x492>
  67f6b7:	48 8b b4 24 e0 06 00 	mov    0x6e0(%rsp),%rsi
  67f6be:	00 
  67f6bf:	48 85 f6             	test   %rsi,%rsi
  67f6c2:	0f 84 e2 06 00 00    	je     67fdaa <<gpui_canvas::text::planner::Planner>::shape+0x320a>
  67f6c8:	48 8b bc 24 e8 06 00 	mov    0x6e8(%rsp),%rdi
  67f6cf:	00 
  67f6d0:	48 c1 e6 03          	shl    $0x3,%rsi
  67f6d4:	ba 08 00 00 00       	mov    $0x8,%edx
  67f6d9:	89 c3                	mov    %eax,%ebx
  67f6db:	ff 15 6f 99 10 00    	call   *0x10996f(%rip)        # 789050 <_DYNAMIC+0x238>
  67f6e1:	89 9c 24 98 00 00 00 	mov    %ebx,0x98(%rsp)
  67f6e8:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67f6ef:	00 ff ff ff ff 
  67f6f4:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67f6fb:	00 
  67f6fc:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f700:	0f 85 c5 06 00 00    	jne    67fdcb <<gpui_canvas::text::planner::Planner>::shape+0x322b>
  67f706:	e9 36 07 00 00       	jmp    67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67f70b:	c7 84 24 98 00 00 00 	movl   $0x3,0x98(%rsp)
  67f712:	03 00 00 00 
  67f716:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67f71d:	00 ff ff ff ff 
  67f722:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67f729:	00 
  67f72a:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f72e:	0f 85 97 06 00 00    	jne    67fdcb <<gpui_canvas::text::planner::Planner>::shape+0x322b>
  67f734:	e9 08 07 00 00       	jmp    67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67f739:	48 c7 84 24 98 00 00 	movq   $0x3,0x98(%rsp)
  67f740:	00 03 00 00 00 
  67f745:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67f74c:	00 ff ff ff ff 
  67f751:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67f758:	00 
  67f759:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f75d:	0f 85 68 06 00 00    	jne    67fdcb <<gpui_canvas::text::planner::Planner>::shape+0x322b>
  67f763:	e9 d9 06 00 00       	jmp    67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67f768:	c7 84 24 98 00 00 00 	movl   $0x1,0x98(%rsp)
  67f76f:	01 00 00 00 
  67f773:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67f77a:	00 ff ff ff ff 
  67f77f:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67f786:	00 
  67f787:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f78b:	0f 85 3a 06 00 00    	jne    67fdcb <<gpui_canvas::text::planner::Planner>::shape+0x322b>
  67f791:	e9 ab 06 00 00       	jmp    67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67f796:	c7 84 24 98 00 00 00 	movl   $0x3,0x98(%rsp)
  67f79d:	03 00 00 00 
  67f7a1:	8b 84 24 04 02 00 00 	mov    0x204(%rsp),%eax
  67f7a8:	89 84 24 9c 00 00 00 	mov    %eax,0x9c(%rsp)
  67f7af:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67f7b6:	00 ff ff ff ff 
  67f7bb:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67f7c2:	00 
  67f7c3:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f7c7:	0f 85 fe 05 00 00    	jne    67fdcb <<gpui_canvas::text::planner::Planner>::shape+0x322b>
  67f7cd:	e9 6f 06 00 00       	jmp    67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67f7d2:	48 c7 84 24 98 00 00 	movq   $0xc,0x98(%rsp)
  67f7d9:	00 0c 00 00 00 
  67f7de:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67f7e5:	00 ff ff ff ff 
  67f7ea:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67f7f1:	00 
  67f7f2:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f7f6:	0f 85 cf 05 00 00    	jne    67fdcb <<gpui_canvas::text::planner::Planner>::shape+0x322b>
  67f7fc:	e9 40 06 00 00       	jmp    67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67f801:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  67f808:	00 ff 
  67f80a:	0f 84 52 01 00 00    	je     67f962 <<gpui_canvas::text::planner::Planner>::shape+0x2dc2>
  67f810:	48 8b 84 24 78 01 00 	mov    0x178(%rsp),%rax
  67f817:	00 
  67f818:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f81c:	0f 84 f8 02 00 00    	je     67fb1a <<gpui_canvas::text::planner::Planner>::shape+0x2f7a>
  67f822:	48 8b b4 24 88 01 00 	mov    0x188(%rsp),%rsi
  67f829:	00 
  67f82a:	48 39 f0             	cmp    %rsi,%rax
  67f82d:	0f 86 e7 02 00 00    	jbe    67fb1a <<gpui_canvas::text::planner::Planner>::shape+0x2f7a>
  67f833:	48 8d bc 24 78 01 00 	lea    0x178(%rsp),%rdi
  67f83a:	00 
  67f83b:	e8 b0 0f 00 00       	call   6807f0 <<alloc::raw_vec::RawVecInner>::shrink>
  67f840:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f844:	0f 84 d0 02 00 00    	je     67fb1a <<gpui_canvas::text::planner::Planner>::shape+0x2f7a>
  67f84a:	48 89 c7             	mov    %rax,%rdi
  67f84d:	48 89 d6             	mov    %rdx,%rsi
  67f850:	ff 15 12 99 10 00    	call   *0x109912(%rip)        # 789168 <_DYNAMIC+0x350>
  67f856:	e9 08 09 00 00       	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  67f85b:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  67f860:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  67f865:	eb 20                	jmp    67f887 <<gpui_canvas::text::planner::Planner>::shape+0x2ce7>
  67f867:	4c 89 cd             	mov    %r9,%rbp
  67f86a:	45 31 ff             	xor    %r15d,%r15d
  67f86d:	48 85 ed             	test   %rbp,%rbp
  67f870:	74 23                	je     67f895 <<gpui_canvas::text::planner::Planner>::shape+0x2cf5>
  67f872:	49 89 e9             	mov    %rbp,%r9
  67f875:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  67f87a:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  67f87f:	48 8b 8c 24 38 02 00 	mov    0x238(%rsp),%rcx
  67f886:	00 
  67f887:	49 39 c1             	cmp    %rax,%r9
  67f88a:	73 20                	jae    67f8ac <<gpui_canvas::text::planner::Planner>::shape+0x2d0c>
  67f88c:	43 80 3c 08 bf       	cmpb   $0xbf,(%r8,%r9,1)
  67f891:	7f 1e                	jg     67f8b1 <<gpui_canvas::text::planner::Planner>::shape+0x2d11>
  67f893:	eb 46                	jmp    67f8db <<gpui_canvas::text::planner::Planner>::shape+0x2d3b>
  67f895:	45 31 c9             	xor    %r9d,%r9d
  67f898:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  67f89d:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  67f8a2:	48 8b 8c 24 38 02 00 	mov    0x238(%rsp),%rcx
  67f8a9:	00 
  67f8aa:	eb 05                	jmp    67f8b1 <<gpui_canvas::text::planner::Planner>::shape+0x2d11>
  67f8ac:	49 89 c1             	mov    %rax,%r9
  67f8af:	75 2a                	jne    67f8db <<gpui_canvas::text::planner::Planner>::shape+0x2d3b>
  67f8b1:	45 84 ff             	test   %r15b,%r15b
  67f8b4:	74 15                	je     67f8cb <<gpui_canvas::text::planner::Planner>::shape+0x2d2b>
  67f8b6:	4c 39 c9             	cmp    %r9,%rcx
  67f8b9:	74 20                	je     67f8db <<gpui_canvas::text::planner::Planner>::shape+0x2d3b>
  67f8bb:	43 0f b6 0c 08       	movzbl (%r8,%r9,1),%ecx
  67f8c0:	84 c9                	test   %cl,%cl
  67f8c2:	78 52                	js     67f916 <<gpui_canvas::text::planner::Planner>::shape+0x2d76>
  67f8c4:	b8 0b 00 00 00       	mov    $0xb,%eax
  67f8c9:	eb 1a                	jmp    67f8e5 <<gpui_canvas::text::planner::Planner>::shape+0x2d45>
  67f8cb:	48 39 c1             	cmp    %rax,%rcx
  67f8ce:	73 09                	jae    67f8d9 <<gpui_canvas::text::planner::Planner>::shape+0x2d39>
  67f8d0:	41 80 3c 08 bf       	cmpb   $0xbf,(%r8,%rcx,1)
  67f8d5:	7f df                	jg     67f8b6 <<gpui_canvas::text::planner::Planner>::shape+0x2d16>
  67f8d7:	eb 02                	jmp    67f8db <<gpui_canvas::text::planner::Planner>::shape+0x2d3b>
  67f8d9:	74 db                	je     67f8b6 <<gpui_canvas::text::planner::Planner>::shape+0x2d16>
  67f8db:	b8 03 00 00 00       	mov    $0x3,%eax
  67f8e0:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  67f8e5:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
  67f8ec:	89 8c 24 9c 00 00 00 	mov    %ecx,0x9c(%rsp)
  67f8f3:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67f8fa:	00 ff ff ff ff 
  67f8ff:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67f906:	00 
  67f907:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67f90b:	0f 85 ba 04 00 00    	jne    67fdcb <<gpui_canvas::text::planner::Planner>::shape+0x322b>
  67f911:	e9 2b 05 00 00       	jmp    67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67f916:	89 ca                	mov    %ecx,%edx
  67f918:	83 e2 1f             	and    $0x1f,%edx
  67f91b:	43 0f b6 7c 08 01    	movzbl 0x1(%r8,%r9,1),%edi
  67f921:	83 e7 3f             	and    $0x3f,%edi
  67f924:	b8 0b 00 00 00       	mov    $0xb,%eax
  67f929:	80 f9 df             	cmp    $0xdf,%cl
  67f92c:	76 2b                	jbe    67f959 <<gpui_canvas::text::planner::Planner>::shape+0x2db9>
  67f92e:	43 0f b6 74 08 02    	movzbl 0x2(%r8,%r9,1),%esi
  67f934:	c1 e7 06             	shl    $0x6,%edi
  67f937:	83 e6 3f             	and    $0x3f,%esi
  67f93a:	09 fe                	or     %edi,%esi
  67f93c:	80 f9 f0             	cmp    $0xf0,%cl
  67f93f:	72 65                	jb     67f9a6 <<gpui_canvas::text::planner::Planner>::shape+0x2e06>
  67f941:	43 0f b6 4c 08 03    	movzbl 0x3(%r8,%r9,1),%ecx
  67f947:	83 e2 07             	and    $0x7,%edx
  67f94a:	c1 e2 12             	shl    $0x12,%edx
  67f94d:	c1 e6 06             	shl    $0x6,%esi
  67f950:	83 e1 3f             	and    $0x3f,%ecx
  67f953:	09 f1                	or     %esi,%ecx
  67f955:	09 d1                	or     %edx,%ecx
  67f957:	eb 8c                	jmp    67f8e5 <<gpui_canvas::text::planner::Planner>::shape+0x2d45>
  67f959:	c1 e2 06             	shl    $0x6,%edx
  67f95c:	09 fa                	or     %edi,%edx
  67f95e:	89 d1                	mov    %edx,%ecx
  67f960:	eb 83                	jmp    67f8e5 <<gpui_canvas::text::planner::Planner>::shape+0x2d45>
  67f962:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  67f969:	00 
  67f96a:	48 85 c0             	test   %rax,%rax
  67f96d:	0f 84 86 00 00 00    	je     67f9f9 <<gpui_canvas::text::planner::Planner>::shape+0x2e59>
  67f973:	48 8b 8c 24 e0 00 00 	mov    0xe0(%rsp),%rcx
  67f97a:	00 
  67f97b:	48 c1 e0 04          	shl    $0x4,%rax
  67f97f:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  67f984:	2b 54 01 f0          	sub    -0x10(%rcx,%rax,1),%edx
  67f988:	73 7c                	jae    67fa06 <<gpui_canvas::text::planner::Planner>::shape+0x2e66>
  67f98a:	c7 84 24 98 00 00 00 	movl   $0x3,0x98(%rsp)
  67f991:	03 00 00 00 
  67f995:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67f99c:	00 ff ff ff ff 
  67f9a1:	e9 9b 04 00 00       	jmp    67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67f9a6:	c1 e2 0c             	shl    $0xc,%edx
  67f9a9:	09 d6                	or     %edx,%esi
  67f9ab:	89 f1                	mov    %esi,%ecx
  67f9ad:	e9 33 ff ff ff       	jmp    67f8e5 <<gpui_canvas::text::planner::Planner>::shape+0x2d45>
  67f9b2:	48 8d 0d 07 f7 0f 00 	lea    0xff707(%rip),%rcx        # 77f0c0 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x4d0>
  67f9b9:	4c 89 ef             	mov    %r13,%rdi
  67f9bc:	48 8b 94 24 20 01 00 	mov    0x120(%rsp),%rdx
  67f9c3:	00 
  67f9c4:	ff 15 a6 99 10 00    	call   *0x1099a6(%rip)        # 789370 <_DYNAMIC+0x558>
  67f9ca:	e9 94 07 00 00       	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  67f9cf:	41 bc 03 00 00 00    	mov    $0x3,%r12d
  67f9d5:	8b 84 24 00 01 00 00 	mov    0x100(%rsp),%eax
  67f9dc:	41 89 c7             	mov    %eax,%r15d
  67f9df:	e9 16 d6 ff ff       	jmp    67cffa <<gpui_canvas::text::planner::Planner>::shape+0x45a>
  67f9e4:	41 bc 03 00 00 00    	mov    $0x3,%r12d
  67f9ea:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  67f9f1:	41 89 c7             	mov    %eax,%r15d
  67f9f4:	e9 01 d6 ff ff       	jmp    67cffa <<gpui_canvas::text::planner::Planner>::shape+0x45a>
  67f9f9:	48 83 7c 24 48 00    	cmpq   $0x0,0x48(%rsp)
  67f9ff:	75 11                	jne    67fa12 <<gpui_canvas::text::planner::Planner>::shape+0x2e72>
  67fa01:	e9 14 01 00 00       	jmp    67fb1a <<gpui_canvas::text::planner::Planner>::shape+0x2f7a>
  67fa06:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  67fa0c:	0f 86 95 02 00 00    	jbe    67fca7 <<gpui_canvas::text::planner::Planner>::shape+0x3107>
  67fa12:	bf 04 00 00 00       	mov    $0x4,%edi
  67fa17:	be 18 00 00 00       	mov    $0x18,%esi
  67fa1c:	e8 9f 10 00 00       	call   680ac0 <alloc::boxed::box_new_uninit>
  67fa21:	49 89 c7             	mov    %rax,%r15
  67fa24:	8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%eax
  67fa2b:	41 c7 07 00 00 00 00 	movl   $0x0,(%r15)
  67fa32:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
  67fa37:	41 89 5f 04          	mov    %ebx,0x4(%r15)
  67fa3b:	41 c7 47 08 00 00 00 	movl   $0x0,0x8(%r15)
  67fa42:	00 
  67fa43:	41 89 47 0c          	mov    %eax,0xc(%r15)
  67fa47:	41 c7 47 10 00 00 00 	movl   $0x0,0x10(%r15)
  67fa4e:	00 
  67fa4f:	66 41 c7 47 14 00 00 	movw   $0x0,0x14(%r15)
  67fa56:	bf 04 00 00 00       	mov    $0x4,%edi
  67fa5b:	be 18 00 00 00       	mov    $0x18,%esi
  67fa60:	e8 5b 10 00 00       	call   680ac0 <alloc::boxed::box_new_uninit>
  67fa65:	49 89 c6             	mov    %rax,%r14
  67fa68:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  67fa6e:	89 58 04             	mov    %ebx,0x4(%rax)
  67fa71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  67fa78:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
  67fa7e:	f3 0f 11 40 0c       	movss  %xmm0,0xc(%rax)
  67fa83:	f3 0f 10 44 24 70    	movss  0x70(%rsp),%xmm0
  67fa89:	f3 0f 11 40 10       	movss  %xmm0,0x10(%rax)
  67fa8e:	0f 28 84 24 70 02 00 	movaps 0x270(%rsp),%xmm0
  67fa95:	00 
  67fa96:	f3 0f 11 40 14       	movss  %xmm0,0x14(%rax)
  67fa9b:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  67faa2:	00 ff 
  67faa4:	74 0d                	je     67fab3 <<gpui_canvas::text::planner::Planner>::shape+0x2f13>
  67faa6:	48 8d bc 24 48 01 00 	lea    0x148(%rsp),%rdi
  67faad:	00 
  67faae:	e8 7d c6 ff ff       	call   67c130 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  67fab3:	48 c7 84 24 48 01 00 	movq   $0x1,0x148(%rsp)
  67faba:	00 01 00 00 00 
  67fabf:	4c 89 bc 24 50 01 00 	mov    %r15,0x150(%rsp)
  67fac6:	00 
  67fac7:	48 c7 84 24 58 01 00 	movq   $0x1,0x158(%rsp)
  67face:	00 01 00 00 00 
  67fad3:	48 c7 84 24 60 01 00 	movq   $0x1,0x160(%rsp)
  67fada:	00 01 00 00 00 
  67fadf:	4c 89 b4 24 68 01 00 	mov    %r14,0x168(%rsp)
  67fae6:	00 
  67fae7:	48 c7 84 24 70 01 00 	movq   $0x1,0x170(%rsp)
  67faee:	00 01 00 00 00 
  67faf3:	48 c7 84 24 78 01 00 	movq   $0xffffffffffffffff,0x178(%rsp)
  67fafa:	00 ff ff ff ff 
  67faff:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  67fb04:	89 84 24 90 01 00 00 	mov    %eax,0x190(%rsp)
  67fb0b:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  67fb11:	f3 0f 11 84 24 94 01 	movss  %xmm0,0x194(%rsp)
  67fb18:	00 00 
  67fb1a:	4c 8b bc 24 d8 00 00 	mov    0xd8(%rsp),%r15
  67fb21:	00 
  67fb22:	4c 8b a4 24 e0 00 00 	mov    0xe0(%rsp),%r12
  67fb29:	00 
  67fb2a:	48 8b 9c 24 e8 00 00 	mov    0xe8(%rsp),%rbx
  67fb31:	00 
  67fb32:	48 8b 3c 24          	mov    (%rsp),%rdi
  67fb36:	48 8b b4 24 f0 01 00 	mov    0x1f0(%rsp),%rsi
  67fb3d:	00 
  67fb3e:	e8 1d 09 00 00       	call   680460 <<gpui_canvas::text::planner::Planner>::font_set>
  67fb43:	49 89 c5             	mov    %rax,%r13
  67fb46:	48 89 84 24 90 04 00 	mov    %rax,0x490(%rsp)
  67fb4d:	00 
  67fb4e:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67fb55:	00 
  67fb56:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67fb5a:	0f 84 c3 00 00 00    	je     67fc23 <<gpui_canvas::text::planner::Planner>::shape+0x3083>
  67fb60:	48 8d 94 24 50 01 00 	lea    0x150(%rsp),%rdx
  67fb67:	00 
  67fb68:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  67fb6c:	48 89 8c 24 38 07 00 	mov    %rcx,0x738(%rsp)
  67fb73:	00 
  67fb74:	0f 10 02             	movups (%rdx),%xmm0
  67fb77:	0f 10 4a 10          	movups 0x10(%rdx),%xmm1
  67fb7b:	0f 10 52 20          	movups 0x20(%rdx),%xmm2
  67fb7f:	0f 10 5a 30          	movups 0x30(%rdx),%xmm3
  67fb83:	0f 11 9c 24 28 07 00 	movups %xmm3,0x728(%rsp)
  67fb8a:	00 
  67fb8b:	0f 11 94 24 18 07 00 	movups %xmm2,0x718(%rsp)
  67fb92:	00 
  67fb93:	0f 11 8c 24 08 07 00 	movups %xmm1,0x708(%rsp)
  67fb9a:	00 
  67fb9b:	0f 11 84 24 f8 06 00 	movups %xmm0,0x6f8(%rsp)
  67fba2:	00 
  67fba3:	48 c7 84 24 e0 06 00 	movq   $0x1,0x6e0(%rsp)
  67fbaa:	00 01 00 00 00 
  67fbaf:	48 c7 84 24 e8 06 00 	movq   $0x1,0x6e8(%rsp)
  67fbb6:	00 01 00 00 00 
  67fbbb:	48 8d ac 24 f0 06 00 	lea    0x6f0(%rsp),%rbp
  67fbc2:	00 
  67fbc3:	48 89 84 24 f0 06 00 	mov    %rax,0x6f0(%rsp)
  67fbca:	00 
  67fbcb:	bf 08 00 00 00       	mov    $0x8,%edi
  67fbd0:	be 60 00 00 00       	mov    $0x60,%esi
  67fbd5:	e8 e6 0e 00 00       	call   680ac0 <alloc::boxed::box_new_uninit>
  67fbda:	0f 10 84 24 30 07 00 	movups 0x730(%rsp),%xmm0
  67fbe1:	00 
  67fbe2:	0f 11 40 50          	movups %xmm0,0x50(%rax)
  67fbe6:	0f 10 84 24 20 07 00 	movups 0x720(%rsp),%xmm0
  67fbed:	00 
  67fbee:	0f 11 40 40          	movups %xmm0,0x40(%rax)
  67fbf2:	0f 10 84 24 e0 06 00 	movups 0x6e0(%rsp),%xmm0
  67fbf9:	00 
  67fbfa:	0f 10 8c 24 f0 06 00 	movups 0x6f0(%rsp),%xmm1
  67fc01:	00 
  67fc02:	0f 10 94 24 00 07 00 	movups 0x700(%rsp),%xmm2
  67fc09:	00 
  67fc0a:	0f 10 9c 24 10 07 00 	movups 0x710(%rsp),%xmm3
  67fc11:	00 
  67fc12:	0f 11 58 30          	movups %xmm3,0x30(%rax)
  67fc16:	0f 11 50 20          	movups %xmm2,0x20(%rax)
  67fc1a:	0f 11 48 10          	movups %xmm1,0x10(%rax)
  67fc1e:	0f 11 00             	movups %xmm0,(%rax)
  67fc21:	eb 02                	jmp    67fc25 <<gpui_canvas::text::planner::Planner>::shape+0x3085>
  67fc23:	31 c0                	xor    %eax,%eax
  67fc25:	4c 89 bc 24 90 00 00 	mov    %r15,0x90(%rsp)
  67fc2c:	00 
  67fc2d:	4c 89 a4 24 98 00 00 	mov    %r12,0x98(%rsp)
  67fc34:	00 
  67fc35:	48 89 9c 24 a0 00 00 	mov    %rbx,0xa0(%rsp)
  67fc3c:	00 
  67fc3d:	4c 89 ac 24 a8 00 00 	mov    %r13,0xa8(%rsp)
  67fc44:	00 
  67fc45:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  67fc4c:	00 
  67fc4d:	0f 28 84 24 70 02 00 	movaps 0x270(%rsp),%xmm0
  67fc54:	00 
  67fc55:	f3 0f 11 84 24 b8 00 	movss  %xmm0,0xb8(%rsp)
  67fc5c:	00 00 
  67fc5e:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
  67fc64:	f3 0f 11 84 24 bc 00 	movss  %xmm0,0xbc(%rsp)
  67fc6b:	00 00 
  67fc6d:	f3 0f 10 44 24 70    	movss  0x70(%rsp),%xmm0
  67fc73:	f3 0f 11 84 24 c0 00 	movss  %xmm0,0xc0(%rsp)
  67fc7a:	00 00 
  67fc7c:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  67fc82:	f3 0f 11 84 24 c4 00 	movss  %xmm0,0xc4(%rsp)
  67fc89:	00 00 
  67fc8b:	48 8d bc 24 98 02 00 	lea    0x298(%rsp),%rdi
  67fc92:	00 
  67fc93:	e8 38 ac ff ff       	call   67a8d0 <core::ptr::drop_glue::<[parlance::font_family::FontFamilyName; 3]>>
  67fc98:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  67fc9c:	0f 85 7b 03 00 00    	jne    68001d <<gpui_canvas::text::planner::Planner>::shape+0x347d>
  67fca2:	e9 30 02 00 00       	jmp    67fed7 <<gpui_canvas::text::planner::Planner>::shape+0x3337>
  67fca7:	48 01 c1             	add    %rax,%rcx
  67fcaa:	88 51 ff             	mov    %dl,-0x1(%rcx)
  67fcad:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  67fcb4:	00 ff 
  67fcb6:	0f 85 54 fb ff ff    	jne    67f810 <<gpui_canvas::text::planner::Planner>::shape+0x2c70>
  67fcbc:	e9 59 fe ff ff       	jmp    67fb1a <<gpui_canvas::text::planner::Planner>::shape+0x2f7a>
  67fcc1:	49 89 cd             	mov    %rcx,%r13
  67fcc4:	48 8b 84 24 e8 01 00 	mov    0x1e8(%rsp),%rax
  67fccb:	00 
  67fccc:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  67fcd3:	00 
  67fcd4:	48 8d 0d ed f4 0f 00 	lea    0xff4ed(%rip),%rcx        # 77f1c8 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x5d8>
  67fcdb:	e9 d9 fc ff ff       	jmp    67f9b9 <<gpui_canvas::text::planner::Planner>::shape+0x2e19>
  67fce0:	49 89 d5             	mov    %rdx,%r13
  67fce3:	48 89 9c 24 20 01 00 	mov    %rbx,0x120(%rsp)
  67fcea:	00 
  67fceb:	48 8d 0d 9e f3 0f 00 	lea    0xff39e(%rip),%rcx        # 77f090 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x4a0>
  67fcf2:	e9 c2 fc ff ff       	jmp    67f9b9 <<gpui_canvas::text::planner::Planner>::shape+0x2e19>
  67fcf7:	48 8d 0d c2 f7 0f 00 	lea    0xff7c2(%rip),%rcx        # 77f4c0 <anon.d4a86088305c8823b863e6abd2e38045.36.llvm.4134324091787671213>
  67fcfe:	48 89 f7             	mov    %rsi,%rdi
  67fd01:	48 89 d6             	mov    %rdx,%rsi
  67fd04:	4c 89 c2             	mov    %r8,%rdx
  67fd07:	ff 15 63 96 10 00    	call   *0x109663(%rip)        # 789370 <_DYNAMIC+0x558>
  67fd0d:	e9 51 04 00 00       	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  67fd12:	48 8d 0d 5f f7 0f 00 	lea    0xff75f(%rip),%rcx        # 77f478 <anon.d4a86088305c8823b863e6abd2e38045.32.llvm.4134324091787671213>
  67fd19:	ff 15 51 96 10 00    	call   *0x109651(%rip)        # 789370 <_DYNAMIC+0x558>
  67fd1f:	e9 3f 04 00 00       	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  67fd24:	48 8d 0d 4d f7 0f 00 	lea    0xff74d(%rip),%rcx        # 77f478 <anon.d4a86088305c8823b863e6abd2e38045.32.llvm.4134324091787671213>
  67fd2b:	ff 15 3f 96 10 00    	call   *0x10963f(%rip)        # 789370 <_DYNAMIC+0x558>
  67fd31:	e9 2d 04 00 00       	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  67fd36:	48 8d 3d 23 e6 bd ff 	lea    -0x4219dd(%rip),%rdi        # 25e360 <anon.d4a86088305c8823b863e6abd2e38045.0.llvm.4134324091787671213>
  67fd3d:	48 8d 15 74 f9 0f 00 	lea    0xff974(%rip),%rdx        # 77f6b8 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.4134324091787671213>
  67fd44:	be 63 00 00 00       	mov    $0x63,%esi
  67fd49:	ff 15 a9 95 10 00    	call   *0x1095a9(%rip)        # 7892f8 <_DYNAMIC+0x4e0>
  67fd4f:	e9 0f 04 00 00       	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  67fd54:	48 8d 3d 35 f7 0f 00 	lea    0xff735(%rip),%rdi        # 77f490 <anon.d4a86088305c8823b863e6abd2e38045.33.llvm.4134324091787671213>
  67fd5b:	ff 15 ef 93 10 00    	call   *0x1093ef(%rip)        # 789150 <_DYNAMIC+0x338>
  67fd61:	e9 fd 03 00 00       	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  67fd66:	89 c3                	mov    %eax,%ebx
  67fd68:	48 8b b4 24 e0 06 00 	mov    0x6e0(%rsp),%rsi
  67fd6f:	00 
  67fd70:	48 85 f6             	test   %rsi,%rsi
  67fd73:	74 17                	je     67fd8c <<gpui_canvas::text::planner::Planner>::shape+0x31ec>
  67fd75:	48 8b bc 24 e8 06 00 	mov    0x6e8(%rsp),%rdi
  67fd7c:	00 
  67fd7d:	48 c1 e6 03          	shl    $0x3,%rsi
  67fd81:	ba 08 00 00 00       	mov    $0x8,%edx
  67fd86:	ff 15 c4 92 10 00    	call   *0x1092c4(%rip)        # 789050 <_DYNAMIC+0x238>
  67fd8c:	48 8d bc 24 e0 02 00 	lea    0x2e0(%rsp),%rdi
  67fd93:	00 
  67fd94:	e8 37 b6 ff ff       	call   67b3d0 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
  67fd99:	e9 43 f9 ff ff       	jmp    67f6e1 <<gpui_canvas::text::planner::Planner>::shape+0x2b41>
  67fd9e:	b8 01 00 00 00       	mov    $0x1,%eax
  67fda3:	eb 05                	jmp    67fdaa <<gpui_canvas::text::planner::Planner>::shape+0x320a>
  67fda5:	b8 03 00 00 00       	mov    $0x3,%eax
  67fdaa:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
  67fdb1:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67fdb8:	00 ff ff ff ff 
  67fdbd:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  67fdc4:	00 
  67fdc5:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67fdc9:	74 76                	je     67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67fdcb:	48 85 c0             	test   %rax,%rax
  67fdce:	74 1b                	je     67fdeb <<gpui_canvas::text::planner::Planner>::shape+0x324b>
  67fdd0:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  67fdd7:	00 
  67fdd8:	48 c1 e0 03          	shl    $0x3,%rax
  67fddc:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  67fde0:	ba 04 00 00 00       	mov    $0x4,%edx
  67fde5:	ff 15 65 92 10 00    	call   *0x109265(%rip)        # 789050 <_DYNAMIC+0x238>
  67fdeb:	48 8b 84 24 60 01 00 	mov    0x160(%rsp),%rax
  67fdf2:	00 
  67fdf3:	48 85 c0             	test   %rax,%rax
  67fdf6:	74 1b                	je     67fe13 <<gpui_canvas::text::planner::Planner>::shape+0x3273>
  67fdf8:	48 8b bc 24 68 01 00 	mov    0x168(%rsp),%rdi
  67fdff:	00 
  67fe00:	48 c1 e0 03          	shl    $0x3,%rax
  67fe04:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  67fe08:	ba 04 00 00 00       	mov    $0x4,%edx
  67fe0d:	ff 15 3d 92 10 00    	call   *0x10923d(%rip)        # 789050 <_DYNAMIC+0x238>
  67fe13:	48 8b 84 24 78 01 00 	mov    0x178(%rsp),%rax
  67fe1a:	00 
  67fe1b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  67fe1f:	74 20                	je     67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67fe21:	48 85 c0             	test   %rax,%rax
  67fe24:	74 1b                	je     67fe41 <<gpui_canvas::text::planner::Planner>::shape+0x32a1>
  67fe26:	48 8b bc 24 80 01 00 	mov    0x180(%rsp),%rdi
  67fe2d:	00 
  67fe2e:	48 c1 e0 02          	shl    $0x2,%rax
  67fe32:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  67fe36:	ba 04 00 00 00       	mov    $0x4,%edx
  67fe3b:	ff 15 0f 92 10 00    	call   *0x10920f(%rip)        # 789050 <_DYNAMIC+0x238>
  67fe41:	48 8b b4 24 d8 00 00 	mov    0xd8(%rsp),%rsi
  67fe48:	00 
  67fe49:	48 85 f6             	test   %rsi,%rsi
  67fe4c:	74 17                	je     67fe65 <<gpui_canvas::text::planner::Planner>::shape+0x32c5>
  67fe4e:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  67fe55:	00 
  67fe56:	48 c1 e6 04          	shl    $0x4,%rsi
  67fe5a:	ba 04 00 00 00       	mov    $0x4,%edx
  67fe5f:	ff 15 eb 91 10 00    	call   *0x1091eb(%rip)        # 789050 <_DYNAMIC+0x238>
  67fe65:	48 8b b4 24 98 02 00 	mov    0x298(%rsp),%rsi
  67fe6c:	00 
  67fe6d:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  67fe71:	77 18                	ja     67fe8b <<gpui_canvas::text::planner::Planner>::shape+0x32eb>
  67fe73:	48 85 f6             	test   %rsi,%rsi
  67fe76:	74 13                	je     67fe8b <<gpui_canvas::text::planner::Planner>::shape+0x32eb>
  67fe78:	48 8b bc 24 a0 02 00 	mov    0x2a0(%rsp),%rdi
  67fe7f:	00 
  67fe80:	ba 01 00 00 00       	mov    $0x1,%edx
  67fe85:	ff 15 c5 91 10 00    	call   *0x1091c5(%rip)        # 789050 <_DYNAMIC+0x238>
  67fe8b:	48 8b b4 24 b0 02 00 	mov    0x2b0(%rsp),%rsi
  67fe92:	00 
  67fe93:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  67fe97:	77 18                	ja     67feb1 <<gpui_canvas::text::planner::Planner>::shape+0x3311>
  67fe99:	48 85 f6             	test   %rsi,%rsi
  67fe9c:	74 13                	je     67feb1 <<gpui_canvas::text::planner::Planner>::shape+0x3311>
  67fe9e:	48 8b bc 24 b8 02 00 	mov    0x2b8(%rsp),%rdi
  67fea5:	00 
  67fea6:	ba 01 00 00 00       	mov    $0x1,%edx
  67feab:	ff 15 9f 91 10 00    	call   *0x10919f(%rip)        # 789050 <_DYNAMIC+0x238>
  67feb1:	48 8b b4 24 c8 02 00 	mov    0x2c8(%rsp),%rsi
  67feb8:	00 
  67feb9:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  67febd:	77 18                	ja     67fed7 <<gpui_canvas::text::planner::Planner>::shape+0x3337>
  67febf:	48 85 f6             	test   %rsi,%rsi
  67fec2:	74 13                	je     67fed7 <<gpui_canvas::text::planner::Planner>::shape+0x3337>
  67fec4:	48 8b bc 24 d0 02 00 	mov    0x2d0(%rsp),%rdi
  67fecb:	00 
  67fecc:	ba 01 00 00 00       	mov    $0x1,%edx
  67fed1:	ff 15 79 91 10 00    	call   *0x109179(%rip)        # 789050 <_DYNAMIC+0x238>
  67fed7:	48 8b 1c 24          	mov    (%rsp),%rbx
  67fedb:	48 8d bb c8 08 00 00 	lea    0x8c8(%rbx),%rdi
  67fee2:	e8 d9 b0 ff ff       	call   67afc0 <core::ptr::drop_glue::<parley::layout::layout::Layout<()>>>
  67fee7:	48 c7 83 c8 08 00 00 	movq   $0x0,0x8c8(%rbx)
  67feee:	00 00 00 00 
  67fef2:	48 c7 83 d0 08 00 00 	movq   $0x4,0x8d0(%rbx)
  67fef9:	04 00 00 00 
  67fefd:	0f 57 c0             	xorps  %xmm0,%xmm0
  67ff00:	0f 11 83 d8 08 00 00 	movups %xmm0,0x8d8(%rbx)
  67ff07:	48 c7 83 e8 08 00 00 	movq   $0x4,0x8e8(%rbx)
  67ff0e:	04 00 00 00 
  67ff12:	0f 11 83 f0 08 00 00 	movups %xmm0,0x8f0(%rbx)
  67ff19:	48 c7 83 00 09 00 00 	movq   $0x8,0x900(%rbx)
  67ff20:	08 00 00 00 
  67ff24:	0f 11 83 08 09 00 00 	movups %xmm0,0x908(%rbx)
  67ff2b:	48 c7 83 18 09 00 00 	movq   $0x8,0x918(%rbx)
  67ff32:	08 00 00 00 
  67ff36:	0f 11 83 20 09 00 00 	movups %xmm0,0x920(%rbx)
  67ff3d:	48 c7 83 30 09 00 00 	movq   $0x4,0x930(%rbx)
  67ff44:	04 00 00 00 
  67ff48:	0f 11 83 38 09 00 00 	movups %xmm0,0x938(%rbx)
  67ff4f:	48 c7 83 48 09 00 00 	movq   $0x4,0x948(%rbx)
  67ff56:	04 00 00 00 
  67ff5a:	0f 11 83 50 09 00 00 	movups %xmm0,0x950(%rbx)
  67ff61:	48 c7 83 60 09 00 00 	movq   $0x4,0x960(%rbx)
  67ff68:	04 00 00 00 
  67ff6c:	0f 11 83 68 09 00 00 	movups %xmm0,0x968(%rbx)
  67ff73:	48 c7 83 78 09 00 00 	movq   $0x8,0x978(%rbx)
  67ff7a:	08 00 00 00 
  67ff7e:	0f 11 83 80 09 00 00 	movups %xmm0,0x980(%rbx)
  67ff85:	48 c7 83 90 09 00 00 	movq   $0x2,0x990(%rbx)
  67ff8c:	02 00 00 00 
  67ff90:	0f 11 83 98 09 00 00 	movups %xmm0,0x998(%rbx)
  67ff97:	48 c7 83 a8 09 00 00 	movq   $0x4,0x9a8(%rbx)
  67ff9e:	04 00 00 00 
  67ffa2:	0f 11 83 b0 09 00 00 	movups %xmm0,0x9b0(%rbx)
  67ffa9:	48 c7 83 c0 09 00 00 	movq   $0x8,0x9c0(%rbx)
  67ffb0:	08 00 00 00 
  67ffb4:	0f 11 83 c8 09 00 00 	movups %xmm0,0x9c8(%rbx)
  67ffbb:	48 c7 83 d8 09 00 00 	movq   $0x8,0x9d8(%rbx)
  67ffc2:	08 00 00 00 
  67ffc6:	0f 11 83 e0 09 00 00 	movups %xmm0,0x9e0(%rbx)
  67ffcd:	48 c7 83 f0 09 00 00 	movq   $0x8,0x9f0(%rbx)
  67ffd4:	08 00 00 00 
  67ffd8:	0f 11 83 f8 09 00 00 	movups %xmm0,0x9f8(%rbx)
  67ffdf:	48 c7 83 08 0a 00 00 	movq   $0x4,0xa08(%rbx)
  67ffe6:	04 00 00 00 
  67ffea:	0f 11 83 10 0a 00 00 	movups %xmm0,0xa10(%rbx)
  67fff1:	c7 83 20 0a 00 00 00 	movl   $0x3f800000,0xa20(%rbx)
  67fff8:	00 80 3f 
  67fffb:	0f 11 83 24 0a 00 00 	movups %xmm0,0xa24(%rbx)
  680002:	48 c7 83 32 0a 00 00 	movq   $0x0,0xa32(%rbx)
  680009:	00 00 00 00 
  68000d:	66 c7 83 3a 0a 00 00 	movw   $0xff01,0xa3a(%rbx)
  680014:	01 ff 
  680016:	c6 83 3c 0a 00 00 00 	movb   $0x0,0xa3c(%rbx)
  68001d:	48 8b 8c 24 c0 00 00 	mov    0xc0(%rsp),%rcx
  680024:	00 
  680025:	48 8b 84 24 78 03 00 	mov    0x378(%rsp),%rax
  68002c:	00 
  68002d:	48 89 48 30          	mov    %rcx,0x30(%rax)
  680031:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  680038:	00 
  680039:	0f 10 8c 24 a0 00 00 	movups 0xa0(%rsp),%xmm1
  680040:	00 
  680041:	0f 10 94 24 b0 00 00 	movups 0xb0(%rsp),%xmm2
  680048:	00 
  680049:	0f 11 50 20          	movups %xmm2,0x20(%rax)
  68004d:	0f 11 48 10          	movups %xmm1,0x10(%rax)
  680051:	0f 11 00             	movups %xmm0,(%rax)
  680054:	48 81 c4 b8 11 00 00 	add    $0x11b8,%rsp
  68005b:	5b                   	pop    %rbx
  68005c:	41 5c                	pop    %r12
  68005e:	41 5d                	pop    %r13
  680060:	41 5e                	pop    %r14
  680062:	41 5f                	pop    %r15
  680064:	5d                   	pop    %rbp
  680065:	c3                   	ret
  680066:	4c 8d 05 9b f0 0f 00 	lea    0xff09b(%rip),%r8        # 77f108 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x518>
  68006d:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  680074:	00 
  680075:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  68007a:	48 89 da             	mov    %rbx,%rdx
  68007d:	4c 89 f9             	mov    %r15,%rcx
  680080:	ff 15 f2 94 10 00    	call   *0x1094f2(%rip)        # 789578 <_DYNAMIC+0x760>
  680086:	e9 d8 00 00 00       	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  68008b:	48 8d 05 16 f0 0f 00 	lea    0xff016(%rip),%rax        # 77f0a8 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x4b8>
  680092:	eb 1f                	jmp    6800b3 <<gpui_canvas::text::planner::Planner>::shape+0x3513>
  680094:	48 39 d3             	cmp    %rdx,%rbx
  680097:	48 0f 47 d3          	cmova  %rbx,%rdx
  68009b:	48 8d 05 f6 f1 0f 00 	lea    0xff1f6(%rip),%rax        # 77f298 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x6a8>
  6800a2:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6800a7:	48 89 d7             	mov    %rdx,%rdi
  6800aa:	eb 0c                	jmp    6800b8 <<gpui_canvas::text::planner::Planner>::shape+0x3518>
  6800ac:	48 8d 05 b5 f0 0f 00 	lea    0xff0b5(%rip),%rax        # 77f168 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x578>
  6800b3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6800b8:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  6800bf:	00 
  6800c0:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  6800c5:	ff 15 ad 90 10 00    	call   *0x1090ad(%rip)        # 789178 <_DYNAMIC+0x360>
  6800cb:	e9 93 00 00 00       	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  6800d0:	31 ff                	xor    %edi,%edi
  6800d2:	48 c7 84 24 d0 01 00 	movq   $0x0,0x1d0(%rsp)
  6800d9:	00 00 00 00 00 
  6800de:	eb d8                	jmp    6800b8 <<gpui_canvas::text::planner::Planner>::shape+0x3518>
  6800e0:	48 8d 0d 29 f5 0f 00 	lea    0xff529(%rip),%rcx        # 77f610 <anon.d4a86088305c8823b863e6abd2e38045.52.llvm.4134324091787671213>
  6800e7:	48 89 8c 24 60 02 00 	mov    %rcx,0x260(%rsp)
  6800ee:	00 
  6800ef:	eb 04                	jmp    6800f5 <<gpui_canvas::text::planner::Planner>::shape+0x3555>
  6800f1:	31 ff                	xor    %edi,%edi
  6800f3:	31 c0                	xor    %eax,%eax
  6800f5:	48 89 c6             	mov    %rax,%rsi
  6800f8:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
  6800ff:	00 
  680100:	ff 15 72 90 10 00    	call   *0x109072(%rip)        # 789178 <_DYNAMIC+0x360>
  680106:	eb 5b                	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  680108:	48 8d 15 01 f5 0f 00 	lea    0xff501(%rip),%rdx        # 77f610 <anon.d4a86088305c8823b863e6abd2e38045.52.llvm.4134324091787671213>
  68010f:	ff 15 63 90 10 00    	call   *0x109063(%rip)        # 789178 <_DYNAMIC+0x360>
  680115:	eb 4c                	jmp    680163 <<gpui_canvas::text::planner::Planner>::shape+0x35c3>
  680117:	48 8d 05 62 f1 0f 00 	lea    0xff162(%rip),%rax        # 77f280 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x690>
  68011e:	eb 93                	jmp    6800b3 <<gpui_canvas::text::planner::Planner>::shape+0x3513>
  680120:	48 89 d7             	mov    %rdx,%rdi
  680123:	48 8d 05 86 f1 0f 00 	lea    0xff186(%rip),%rax        # 77f2b0 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x6c0>
  68012a:	eb 87                	jmp    6800b3 <<gpui_canvas::text::planner::Planner>::shape+0x3513>
  68012c:	48 8d 05 1d f0 0f 00 	lea    0xff01d(%rip),%rax        # 77f150 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x560>
  680133:	e9 7b ff ff ff       	jmp    6800b3 <<gpui_canvas::text::planner::Planner>::shape+0x3513>
  680138:	48 8d 05 41 f0 0f 00 	lea    0xff041(%rip),%rax        # 77f180 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x590>
  68013f:	e9 6f ff ff ff       	jmp    6800b3 <<gpui_canvas::text::planner::Planner>::shape+0x3513>
  680144:	48 89 d7             	mov    %rdx,%rdi
  680147:	48 8d 05 4a f0 0f 00 	lea    0xff04a(%rip),%rax        # 77f198 <anon.3ebc8aef2a3d7706b3d65334ef36f60a.3.llvm.9487204053687045712+0x5a8>
  68014e:	e9 60 ff ff ff       	jmp    6800b3 <<gpui_canvas::text::planner::Planner>::shape+0x3513>
  680153:	48 8d 15 b6 f4 0f 00 	lea    0xff4b6(%rip),%rdx        # 77f610 <anon.d4a86088305c8823b863e6abd2e38045.52.llvm.4134324091787671213>
  68015a:	48 89 c6             	mov    %rax,%rsi
  68015d:	ff 15 15 90 10 00    	call   *0x109015(%rip)        # 789178 <_DYNAMIC+0x360>
  680163:	0f 0b                	ud2
  680165:	49 89 c6             	mov    %rax,%r14
  680168:	be 18 00 00 00       	mov    $0x18,%esi
  68016d:	ba 04 00 00 00       	mov    $0x4,%edx
  680172:	4c 89 ff             	mov    %r15,%rdi
  680175:	ff 15 d5 8e 10 00    	call   *0x108ed5(%rip)        # 789050 <_DYNAMIC+0x238>
  68017b:	e9 84 02 00 00       	jmp    680404 <<gpui_canvas::text::planner::Planner>::shape+0x3864>
  680180:	49 89 c6             	mov    %rax,%r14
  680183:	48 89 ef             	mov    %rbp,%rdi
  680186:	e8 a5 bf ff ff       	call   67c130 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  68018b:	f0 49 ff 4d 00       	lock decq 0x0(%r13)
  680190:	75 0e                	jne    6801a0 <<gpui_canvas::text::planner::Planner>::shape+0x3600>
  680192:	48 8d bc 24 90 04 00 	lea    0x490(%rsp),%rdi
  680199:	00 
  68019a:	ff 15 c8 8e 10 00    	call   *0x108ec8(%rip)        # 789068 <_DYNAMIC+0x250>
  6801a0:	31 db                	xor    %ebx,%ebx
  6801a2:	eb 0b                	jmp    6801af <<gpui_canvas::text::planner::Planner>::shape+0x360f>
  6801a4:	ff 15 c6 8e 10 00    	call   *0x108ec6(%rip)        # 789070 <_DYNAMIC+0x258>
  6801aa:	49 89 c6             	mov    %rax,%r14
  6801ad:	b3 01                	mov    $0x1,%bl
  6801af:	4d 85 ff             	test   %r15,%r15
  6801b2:	74 15                	je     6801c9 <<gpui_canvas::text::planner::Planner>::shape+0x3629>
  6801b4:	49 c1 e7 04          	shl    $0x4,%r15
  6801b8:	ba 04 00 00 00       	mov    $0x4,%edx
  6801bd:	4c 89 e7             	mov    %r12,%rdi
  6801c0:	4c 89 fe             	mov    %r15,%rsi
  6801c3:	ff 15 87 8e 10 00    	call   *0x108e87(%rip)        # 789050 <_DYNAMIC+0x238>
  6801c9:	84 db                	test   %bl,%bl
  6801cb:	0f 84 75 02 00 00    	je     680446 <<gpui_canvas::text::planner::Planner>::shape+0x38a6>
  6801d1:	31 db                	xor    %ebx,%ebx
  6801d3:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  6801da:	00 ff 
  6801dc:	0f 84 e7 01 00 00    	je     6803c9 <<gpui_canvas::text::planner::Planner>::shape+0x3829>
  6801e2:	e9 2a 02 00 00       	jmp    680411 <<gpui_canvas::text::planner::Planner>::shape+0x3871>
  6801e7:	49 89 c6             	mov    %rax,%r14
  6801ea:	48 8b b4 24 e0 06 00 	mov    0x6e0(%rsp),%rsi
  6801f1:	00 
  6801f2:	48 85 f6             	test   %rsi,%rsi
  6801f5:	74 17                	je     68020e <<gpui_canvas::text::planner::Planner>::shape+0x366e>
  6801f7:	48 8b bc 24 e8 06 00 	mov    0x6e8(%rsp),%rdi
  6801fe:	00 
  6801ff:	48 c1 e6 03          	shl    $0x3,%rsi
  680203:	ba 08 00 00 00       	mov    $0x8,%edx
  680208:	ff 15 42 8e 10 00    	call   *0x108e42(%rip)        # 789050 <_DYNAMIC+0x238>
  68020e:	48 8d bc 24 e0 02 00 	lea    0x2e0(%rsp),%rdi
  680215:	00 
  680216:	e8 b5 b1 ff ff       	call   67b3d0 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
  68021b:	e9 e4 01 00 00       	jmp    680404 <<gpui_canvas::text::planner::Planner>::shape+0x3864>
  680220:	49 89 c6             	mov    %rax,%r14
  680223:	4d 89 27             	mov    %r12,(%r15)
  680226:	4c 89 f7             	mov    %r14,%rdi
  680229:	e8 42 cd 0f 00       	call   77cf70 <_Unwind_Resume@plt>
  68022e:	e9 ce 01 00 00       	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  680233:	e9 c9 01 00 00       	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  680238:	e9 c4 01 00 00       	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  68023d:	e9 6a 01 00 00       	jmp    6803ac <<gpui_canvas::text::planner::Planner>::shape+0x380c>
  680242:	e9 ba 01 00 00       	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  680247:	e9 b5 01 00 00       	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  68024c:	e9 b0 01 00 00       	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  680251:	e9 ab 01 00 00       	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  680256:	49 89 c6             	mov    %rax,%r14
  680259:	48 c7 83 c8 08 00 00 	movq   $0x0,0x8c8(%rbx)
  680260:	00 00 00 00 
  680264:	48 c7 83 d0 08 00 00 	movq   $0x4,0x8d0(%rbx)
  68026b:	04 00 00 00 
  68026f:	0f 57 c0             	xorps  %xmm0,%xmm0
  680272:	0f 11 83 d8 08 00 00 	movups %xmm0,0x8d8(%rbx)
  680279:	48 c7 83 e8 08 00 00 	movq   $0x4,0x8e8(%rbx)
  680280:	04 00 00 00 
  680284:	0f 11 83 f0 08 00 00 	movups %xmm0,0x8f0(%rbx)
  68028b:	48 c7 83 00 09 00 00 	movq   $0x8,0x900(%rbx)
  680292:	08 00 00 00 
  680296:	0f 11 83 08 09 00 00 	movups %xmm0,0x908(%rbx)
  68029d:	48 c7 83 18 09 00 00 	movq   $0x8,0x918(%rbx)
  6802a4:	08 00 00 00 
  6802a8:	0f 11 83 20 09 00 00 	movups %xmm0,0x920(%rbx)
  6802af:	48 c7 83 30 09 00 00 	movq   $0x4,0x930(%rbx)
  6802b6:	04 00 00 00 
  6802ba:	0f 11 83 38 09 00 00 	movups %xmm0,0x938(%rbx)
  6802c1:	48 c7 83 48 09 00 00 	movq   $0x4,0x948(%rbx)
  6802c8:	04 00 00 00 
  6802cc:	0f 11 83 50 09 00 00 	movups %xmm0,0x950(%rbx)
  6802d3:	48 c7 83 60 09 00 00 	movq   $0x4,0x960(%rbx)
  6802da:	04 00 00 00 
  6802de:	0f 11 83 68 09 00 00 	movups %xmm0,0x968(%rbx)
  6802e5:	48 c7 83 78 09 00 00 	movq   $0x8,0x978(%rbx)
  6802ec:	08 00 00 00 
  6802f0:	0f 11 83 80 09 00 00 	movups %xmm0,0x980(%rbx)
  6802f7:	48 c7 83 90 09 00 00 	movq   $0x2,0x990(%rbx)
  6802fe:	02 00 00 00 
  680302:	0f 11 83 98 09 00 00 	movups %xmm0,0x998(%rbx)
  680309:	48 c7 83 a8 09 00 00 	movq   $0x4,0x9a8(%rbx)
  680310:	04 00 00 00 
  680314:	0f 11 83 b0 09 00 00 	movups %xmm0,0x9b0(%rbx)
  68031b:	48 c7 83 c0 09 00 00 	movq   $0x8,0x9c0(%rbx)
  680322:	08 00 00 00 
  680326:	0f 11 83 c8 09 00 00 	movups %xmm0,0x9c8(%rbx)
  68032d:	48 c7 83 d8 09 00 00 	movq   $0x8,0x9d8(%rbx)
  680334:	08 00 00 00 
  680338:	0f 11 83 e0 09 00 00 	movups %xmm0,0x9e0(%rbx)
  68033f:	48 c7 83 f0 09 00 00 	movq   $0x8,0x9f0(%rbx)
  680346:	08 00 00 00 
  68034a:	0f 11 83 f8 09 00 00 	movups %xmm0,0x9f8(%rbx)
  680351:	48 c7 83 08 0a 00 00 	movq   $0x4,0xa08(%rbx)
  680358:	04 00 00 00 
  68035c:	0f 11 83 10 0a 00 00 	movups %xmm0,0xa10(%rbx)
  680363:	c7 83 20 0a 00 00 00 	movl   $0x3f800000,0xa20(%rbx)
  68036a:	00 80 3f 
  68036d:	0f 11 83 24 0a 00 00 	movups %xmm0,0xa24(%rbx)
  680374:	48 c7 83 32 0a 00 00 	movq   $0x0,0xa32(%rbx)
  68037b:	00 00 00 00 
  68037f:	66 c7 83 3a 0a 00 00 	movw   $0xff01,0xa3a(%rbx)
  680386:	01 ff 
  680388:	c6 83 3c 0a 00 00 00 	movb   $0x0,0xa3c(%rbx)
  68038f:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  680396:	00 
  680397:	e8 44 a6 ff ff       	call   67a9e0 <core::ptr::drop_glue::<core::result::Result<gpui_canvas::text::TextLayout, gpui_canvas::Error>>>
  68039c:	4c 89 f7             	mov    %r14,%rdi
  68039f:	e8 cc cb 0f 00       	call   77cf70 <_Unwind_Resume@plt>
  6803a4:	ff 15 c6 8c 10 00    	call   *0x108cc6(%rip)        # 789070 <_DYNAMIC+0x258>
  6803aa:	eb 55                	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  6803ac:	49 89 c6             	mov    %rax,%r14
  6803af:	48 8b b4 24 e0 06 00 	mov    0x6e0(%rsp),%rsi
  6803b6:	00 
  6803b7:	b3 01                	mov    $0x1,%bl
  6803b9:	48 85 f6             	test   %rsi,%rsi
  6803bc:	75 11                	jne    6803cf <<gpui_canvas::text::planner::Planner>::shape+0x382f>
  6803be:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  6803c5:	00 ff 
  6803c7:	75 48                	jne    680411 <<gpui_canvas::text::planner::Planner>::shape+0x3871>
  6803c9:	84 db                	test   %bl,%bl
  6803cb:	75 55                	jne    680422 <<gpui_canvas::text::planner::Planner>::shape+0x3882>
  6803cd:	eb 77                	jmp    680446 <<gpui_canvas::text::planner::Planner>::shape+0x38a6>
  6803cf:	48 8b bc 24 e8 06 00 	mov    0x6e8(%rsp),%rdi
  6803d6:	00 
  6803d7:	48 c1 e6 03          	shl    $0x3,%rsi
  6803db:	ba 08 00 00 00       	mov    $0x8,%edx
  6803e0:	ff 15 6a 8c 10 00    	call   *0x108c6a(%rip)        # 789050 <_DYNAMIC+0x238>
  6803e6:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  6803ed:	00 ff 
  6803ef:	74 d8                	je     6803c9 <<gpui_canvas::text::planner::Planner>::shape+0x3829>
  6803f1:	eb 1e                	jmp    680411 <<gpui_canvas::text::planner::Planner>::shape+0x3871>
  6803f3:	eb 0c                	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  6803f5:	eb 0a                	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  6803f7:	eb 08                	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  6803f9:	eb 06                	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  6803fb:	eb 04                	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  6803fd:	eb 02                	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  6803ff:	eb 00                	jmp    680401 <<gpui_canvas::text::planner::Planner>::shape+0x3861>
  680401:	49 89 c6             	mov    %rax,%r14
  680404:	b3 01                	mov    $0x1,%bl
  680406:	48 83 bc 24 48 01 00 	cmpq   $0xffffffffffffffff,0x148(%rsp)
  68040d:	00 ff 
  68040f:	74 b8                	je     6803c9 <<gpui_canvas::text::planner::Planner>::shape+0x3829>
  680411:	48 8d bc 24 48 01 00 	lea    0x148(%rsp),%rdi
  680418:	00 
  680419:	e8 12 bd ff ff       	call   67c130 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  68041e:	84 db                	test   %bl,%bl
  680420:	74 24                	je     680446 <<gpui_canvas::text::planner::Planner>::shape+0x38a6>
  680422:	48 8b b4 24 d8 00 00 	mov    0xd8(%rsp),%rsi
  680429:	00 
  68042a:	48 85 f6             	test   %rsi,%rsi
  68042d:	74 17                	je     680446 <<gpui_canvas::text::planner::Planner>::shape+0x38a6>
  68042f:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  680436:	00 
  680437:	48 c1 e6 04          	shl    $0x4,%rsi
  68043b:	ba 04 00 00 00       	mov    $0x4,%edx
  680440:	ff 15 0a 8c 10 00    	call   *0x108c0a(%rip)        # 789050 <_DYNAMIC+0x238>
  680446:	48 8d bc 24 98 02 00 	lea    0x298(%rsp),%rdi
  68044d:	00 
  68044e:	e8 7d a4 ff ff       	call   67a8d0 <core::ptr::drop_glue::<[parlance::font_family::FontFamilyName; 3]>>
  680453:	4c 89 f7             	mov    %r14,%rdi
  680456:	e8 15 cb 0f 00       	call   77cf70 <_Unwind_Resume@plt>

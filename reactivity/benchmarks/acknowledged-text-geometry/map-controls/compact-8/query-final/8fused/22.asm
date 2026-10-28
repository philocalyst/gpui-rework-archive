
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680100 <<gpui_canvas::text::layout::TextGeometry>::stops>:
  680100:	41 57                	push   %r15
  680102:	41 56                	push   %r14
  680104:	53                   	push   %rbx
  680105:	41 89 d0             	mov    %edx,%r8d
  680108:	4c 8b 1e             	mov    (%rsi),%r11
  68010b:	4c 8b 56 10          	mov    0x10(%rsi),%r10
  68010f:	31 c0                	xor    %eax,%eax
  680111:	49 83 fb 02          	cmp    $0x2,%r11
  680115:	4c 89 d2             	mov    %r10,%rdx
  680118:	48 0f 44 d0          	cmove  %rax,%rdx
  68011c:	41 b9 04 00 00 00    	mov    $0x4,%r9d
  680122:	4c 0f 45 4e 08       	cmovne 0x8(%rsi),%r9
  680127:	45 85 c0             	test   %r8d,%r8d
  68012a:	0f 84 8e 00 00 00    	je     6801be <<gpui_canvas::text::layout::TextGeometry>::stops+0xbe>
  680130:	41 f6 c3 01          	test   $0x1,%r11b
  680134:	75 3b                	jne    680171 <<gpui_canvas::text::layout::TextGeometry>::stops+0x71>
  680136:	48 85 d2             	test   %rdx,%rdx
  680139:	0f 84 50 01 00 00    	je     68028f <<gpui_canvas::text::layout::TextGeometry>::stops+0x18f>
  68013f:	31 c0                	xor    %eax,%eax
  680141:	48 83 fa 01          	cmp    $0x1,%rdx
  680145:	74 24                	je     68016b <<gpui_canvas::text::layout::TextGeometry>::stops+0x6b>
  680147:	4c 89 d6             	mov    %r10,%rsi
  68014a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  680150:	48 89 f3             	mov    %rsi,%rbx
  680153:	48 d1 eb             	shr    $1,%rbx
  680156:	4c 8d 34 03          	lea    (%rbx,%rax,1),%r14
  68015a:	47 39 04 f1          	cmp    %r8d,(%r9,%r14,8)
  68015e:	49 0f 42 c6          	cmovb  %r14,%rax
  680162:	48 29 de             	sub    %rbx,%rsi
  680165:	48 83 fe 01          	cmp    $0x1,%rsi
  680169:	77 e5                	ja     680150 <<gpui_canvas::text::layout::TextGeometry>::stops+0x50>
  68016b:	49 8d 34 c1          	lea    (%r9,%rax,8),%rsi
  68016f:	eb 46                	jmp    6801b7 <<gpui_canvas::text::layout::TextGeometry>::stops+0xb7>
  680171:	48 85 d2             	test   %rdx,%rdx
  680174:	0f 84 23 01 00 00    	je     68029d <<gpui_canvas::text::layout::TextGeometry>::stops+0x19d>
  68017a:	31 c0                	xor    %eax,%eax
  68017c:	48 83 fa 01          	cmp    $0x1,%rdx
  680180:	74 2d                	je     6801af <<gpui_canvas::text::layout::TextGeometry>::stops+0xaf>
  680182:	4c 89 d6             	mov    %r10,%rsi
  680185:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  68018c:	00 00 00 00 
  680190:	48 89 f3             	mov    %rsi,%rbx
  680193:	48 d1 eb             	shr    $1,%rbx
  680196:	4c 8d 34 03          	lea    (%rbx,%rax,1),%r14
  68019a:	4f 8d 3c 76          	lea    (%r14,%r14,2),%r15
  68019e:	47 39 04 b9          	cmp    %r8d,(%r9,%r15,4)
  6801a2:	49 0f 42 c6          	cmovb  %r14,%rax
  6801a6:	48 29 de             	sub    %rbx,%rsi
  6801a9:	48 83 fe 01          	cmp    $0x1,%rsi
  6801ad:	77 e1                	ja     680190 <<gpui_canvas::text::layout::TextGeometry>::stops+0x90>
  6801af:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  6801b3:	49 8d 34 b1          	lea    (%r9,%rsi,4),%rsi
  6801b7:	44 39 06             	cmp    %r8d,(%rsi)
  6801ba:	48 83 d0 00          	adc    $0x0,%rax
  6801be:	41 f6 c3 01          	test   $0x1,%r11b
  6801c2:	75 4e                	jne    680212 <<gpui_canvas::text::layout::TextGeometry>::stops+0x112>
  6801c4:	48 85 d2             	test   %rdx,%rdx
  6801c7:	0f 84 8a 00 00 00    	je     680257 <<gpui_canvas::text::layout::TextGeometry>::stops+0x157>
  6801cd:	31 f6                	xor    %esi,%esi
  6801cf:	48 83 fa 01          	cmp    $0x1,%rdx
  6801d3:	74 28                	je     6801fd <<gpui_canvas::text::layout::TextGeometry>::stops+0xfd>
  6801d5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6801dc:	00 00 00 00 
  6801e0:	49 89 f0             	mov    %rsi,%r8
  6801e3:	4d 89 d3             	mov    %r10,%r11
  6801e6:	49 d1 eb             	shr    $1,%r11
  6801e9:	4c 01 de             	add    %r11,%rsi
  6801ec:	41 39 0c f1          	cmp    %ecx,(%r9,%rsi,8)
  6801f0:	49 0f 47 f0          	cmova  %r8,%rsi
  6801f4:	4d 29 da             	sub    %r11,%r10
  6801f7:	49 83 fa 01          	cmp    $0x1,%r10
  6801fb:	77 e3                	ja     6801e0 <<gpui_canvas::text::layout::TextGeometry>::stops+0xe0>
  6801fd:	41 3b 0c f1          	cmp    (%r9,%rsi,8),%ecx
  680201:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  680205:	48 39 c6             	cmp    %rax,%rsi
  680208:	72 59                	jb     680263 <<gpui_canvas::text::layout::TextGeometry>::stops+0x163>
  68020a:	48 89 c1             	mov    %rax,%rcx
  68020d:	e9 83 00 00 00       	jmp    680295 <<gpui_canvas::text::layout::TextGeometry>::stops+0x195>
  680212:	48 85 d2             	test   %rdx,%rdx
  680215:	74 5c                	je     680273 <<gpui_canvas::text::layout::TextGeometry>::stops+0x173>
  680217:	31 f6                	xor    %esi,%esi
  680219:	48 83 fa 01          	cmp    $0x1,%rdx
  68021d:	74 22                	je     680241 <<gpui_canvas::text::layout::TextGeometry>::stops+0x141>
  68021f:	90                   	nop
  680220:	49 89 f0             	mov    %rsi,%r8
  680223:	4d 89 d3             	mov    %r10,%r11
  680226:	49 d1 eb             	shr    $1,%r11
  680229:	4c 01 de             	add    %r11,%rsi
  68022c:	48 8d 1c 76          	lea    (%rsi,%rsi,2),%rbx
  680230:	41 39 0c 99          	cmp    %ecx,(%r9,%rbx,4)
  680234:	49 0f 47 f0          	cmova  %r8,%rsi
  680238:	4d 29 da             	sub    %r11,%r10
  68023b:	49 83 fa 01          	cmp    $0x1,%r10
  68023f:	77 df                	ja     680220 <<gpui_canvas::text::layout::TextGeometry>::stops+0x120>
  680241:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  680245:	43 3b 0c 81          	cmp    (%r9,%r8,4),%ecx
  680249:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  68024d:	48 39 c6             	cmp    %rax,%rsi
  680250:	72 2d                	jb     68027f <<gpui_canvas::text::layout::TextGeometry>::stops+0x17f>
  680252:	48 89 c1             	mov    %rax,%rcx
  680255:	eb 4c                	jmp    6802a3 <<gpui_canvas::text::layout::TextGeometry>::stops+0x1a3>
  680257:	31 c9                	xor    %ecx,%ecx
  680259:	be 00 00 00 00       	mov    $0x0,%esi
  68025e:	48 85 c0             	test   %rax,%rax
  680261:	74 32                	je     680295 <<gpui_canvas::text::layout::TextGeometry>::stops+0x195>
  680263:	48 8d 0d ae f4 0f 00 	lea    0xff4ae(%rip),%rcx        # 77f718 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xc0>
  68026a:	48 89 c7             	mov    %rax,%rdi
  68026d:	ff 15 7d 96 10 00    	call   *0x10967d(%rip)        # 7898f0 <_DYNAMIC+0x3c8>
  680273:	31 c9                	xor    %ecx,%ecx
  680275:	be 00 00 00 00       	mov    $0x0,%esi
  68027a:	48 85 c0             	test   %rax,%rax
  68027d:	74 24                	je     6802a3 <<gpui_canvas::text::layout::TextGeometry>::stops+0x1a3>
  68027f:	48 8d 0d aa f4 0f 00 	lea    0xff4aa(%rip),%rcx        # 77f730 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xd8>
  680286:	48 89 c7             	mov    %rax,%rdi
  680289:	ff 15 61 96 10 00    	call   *0x109661(%rip)        # 7898f0 <_DYNAMIC+0x3c8>
  68028f:	48 89 d1             	mov    %rdx,%rcx
  680292:	48 89 d6             	mov    %rdx,%rsi
  680295:	49 8d 04 c9          	lea    (%r9,%rcx,8),%rax
  680299:	31 d2                	xor    %edx,%edx
  68029b:	eb 13                	jmp    6802b0 <<gpui_canvas::text::layout::TextGeometry>::stops+0x1b0>
  68029d:	48 89 d1             	mov    %rdx,%rcx
  6802a0:	48 89 d6             	mov    %rdx,%rsi
  6802a3:	48 8d 04 49          	lea    (%rcx,%rcx,2),%rax
  6802a7:	49 8d 04 81          	lea    (%r9,%rax,4),%rax
  6802ab:	ba 01 00 00 00       	mov    $0x1,%edx
  6802b0:	48 29 ce             	sub    %rcx,%rsi
  6802b3:	48 89 47 08          	mov    %rax,0x8(%rdi)
  6802b7:	48 89 77 10          	mov    %rsi,0x10(%rdi)
  6802bb:	48 89 17             	mov    %rdx,(%rdi)
  6802be:	48 89 f8             	mov    %rdi,%rax
  6802c1:	5b                   	pop    %rbx
  6802c2:	41 5e                	pop    %r14
  6802c4:	41 5f                	pop    %r15
  6802c6:	c3                   	ret


/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000067dad0 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds>:
  67dad0:	41 56                	push   %r14
  67dad2:	53                   	push   %rbx
  67dad3:	48 83 ec 18          	sub    $0x18,%rsp
  67dad7:	49 89 f6             	mov    %rsi,%r14
  67dada:	48 89 fb             	mov    %rdi,%rbx
  67dadd:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  67dae2:	e8 59 fe ff ff       	call   67d940 <<gpui_canvas::text::layout::TextGeometry>::caret_stop>
  67dae7:	31 c0                	xor    %eax,%eax
  67dae9:	83 7c 24 08 01       	cmpl   $0x1,0x8(%rsp)
  67daee:	0f 85 0a 01 00 00    	jne    67dbfe <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x12e>
  67daf4:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  67daf8:	49 8b 46 38          	mov    0x38(%r14),%rax
  67dafc:	49 8b 76 40          	mov    0x40(%r14),%rsi
  67db00:	85 c9                	test   %ecx,%ecx
  67db02:	74 65                	je     67db69 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x99>
  67db04:	0f b6 54 24 14       	movzbl 0x14(%rsp),%edx
  67db09:	80 e2 01             	and    $0x1,%dl
  67db0c:	74 5b                	je     67db69 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x99>
  67db0e:	48 89 f7             	mov    %rsi,%rdi
  67db11:	48 85 f6             	test   %rsi,%rsi
  67db14:	74 46                	je     67db5c <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x8c>
  67db16:	31 ff                	xor    %edi,%edi
  67db18:	48 83 fe 01          	cmp    $0x1,%rsi
  67db1c:	74 32                	je     67db50 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x80>
  67db1e:	48 89 f2             	mov    %rsi,%rdx
  67db21:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67db28:	0f 1f 84 00 00 00 00 
  67db2f:	00 
  67db30:	49 89 d0             	mov    %rdx,%r8
  67db33:	49 d1 e8             	shr    $1,%r8
  67db36:	4d 8d 0c 38          	lea    (%r8,%rdi,1),%r9
  67db3a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  67db3e:	42 39 4c d0 04       	cmp    %ecx,0x4(%rax,%r10,8)
  67db43:	49 0f 42 f9          	cmovb  %r9,%rdi
  67db47:	4c 29 c2             	sub    %r8,%rdx
  67db4a:	48 83 fa 01          	cmp    $0x1,%rdx
  67db4e:	77 e0                	ja     67db30 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x60>
  67db50:	48 8d 14 7f          	lea    (%rdi,%rdi,2),%rdx
  67db54:	39 4c d0 04          	cmp    %ecx,0x4(%rax,%rdx,8)
  67db58:	48 83 d7 00          	adc    $0x0,%rdi
  67db5c:	48 8d 4e ff          	lea    -0x1(%rsi),%rcx
  67db60:	48 39 f9             	cmp    %rdi,%rcx
  67db63:	48 0f 42 f9          	cmovb  %rcx,%rdi
  67db67:	eb 51                	jmp    67dbba <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xea>
  67db69:	48 89 f7             	mov    %rsi,%rdi
  67db6c:	48 85 f6             	test   %rsi,%rsi
  67db6f:	74 49                	je     67dbba <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xea>
  67db71:	31 d2                	xor    %edx,%edx
  67db73:	48 83 fe 01          	cmp    $0x1,%rsi
  67db77:	74 28                	je     67dba1 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xd1>
  67db79:	48 89 f7             	mov    %rsi,%rdi
  67db7c:	0f 1f 40 00          	nopl   0x0(%rax)
  67db80:	49 89 d0             	mov    %rdx,%r8
  67db83:	49 89 f9             	mov    %rdi,%r9
  67db86:	49 d1 e9             	shr    $1,%r9
  67db89:	4c 01 ca             	add    %r9,%rdx
  67db8c:	4c 8d 14 52          	lea    (%rdx,%rdx,2),%r10
  67db90:	42 39 0c d0          	cmp    %ecx,(%rax,%r10,8)
  67db94:	49 0f 47 d0          	cmova  %r8,%rdx
  67db98:	4c 29 cf             	sub    %r9,%rdi
  67db9b:	48 83 ff 01          	cmp    $0x1,%rdi
  67db9f:	77 df                	ja     67db80 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xb0>
  67dba1:	4c 8d 04 52          	lea    (%rdx,%rdx,2),%r8
  67dba5:	31 ff                	xor    %edi,%edi
  67dba7:	42 39 0c c0          	cmp    %ecx,(%rax,%r8,8)
  67dbab:	40 0f 96 c7          	setbe  %dil
  67dbaf:	48 01 d7             	add    %rdx,%rdi
  67dbb2:	48 83 ff 01          	cmp    $0x1,%rdi
  67dbb6:	48 83 d7 ff          	adc    $0xffffffffffffffff,%rdi
  67dbba:	48 39 f7             	cmp    %rsi,%rdi
  67dbbd:	73 4c                	jae    67dc0b <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x13b>
  67dbbf:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  67dbc5:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  67dbc9:	f3 0f 10 0d 7b fa 99 	movss  -0x660585(%rip),%xmm1        # 1d64c <GCC_except_table0+0x3c>
  67dbd0:	ff 
  67dbd1:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  67dbd5:	f3 0f 5c c8          	subss  %xmm0,%xmm1
  67dbd9:	f3 0f 10 54 c8 08    	movss  0x8(%rax,%rcx,8),%xmm2
  67dbdf:	f3 0f 10 5c c8 0c    	movss  0xc(%rax,%rcx,8),%xmm3
  67dbe5:	f3 0f 11 43 04       	movss  %xmm0,0x4(%rbx)
  67dbea:	f3 0f 11 53 08       	movss  %xmm2,0x8(%rbx)
  67dbef:	f3 0f 11 4b 0c       	movss  %xmm1,0xc(%rbx)
  67dbf4:	f3 0f 11 5b 10       	movss  %xmm3,0x10(%rbx)
  67dbf9:	b8 01 00 00 00       	mov    $0x1,%eax
  67dbfe:	89 03                	mov    %eax,(%rbx)
  67dc00:	48 89 d8             	mov    %rbx,%rax
  67dc03:	48 83 c4 18          	add    $0x18,%rsp
  67dc07:	5b                   	pop    %rbx
  67dc08:	41 5e                	pop    %r14
  67dc0a:	c3                   	ret
  67dc0b:	48 8d 15 36 1b 10 00 	lea    0x101b36(%rip),%rdx        # 77f748 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xf0>
  67dc12:	ff 15 78 bc 10 00    	call   *0x10bc78(%rip)        # 789890 <_DYNAMIC+0x368>

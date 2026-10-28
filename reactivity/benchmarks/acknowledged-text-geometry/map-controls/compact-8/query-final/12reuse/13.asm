
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680f80 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds>:
  680f80:	41 56                	push   %r14
  680f82:	53                   	push   %rbx
  680f83:	50                   	push   %rax
  680f84:	48 83 7e 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rsi)
  680f89:	0f 84 fb 00 00 00    	je     68108a <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x10a>
  680f8f:	4c 8b 46 38          	mov    0x38(%rsi),%r8
  680f93:	48 8b 46 40          	mov    0x40(%rsi),%rax
  680f97:	49 89 c1             	mov    %rax,%r9
  680f9a:	48 85 c0             	test   %rax,%rax
  680f9d:	74 3c                	je     680fdb <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x5b>
  680f9f:	45 31 c9             	xor    %r9d,%r9d
  680fa2:	48 83 f8 01          	cmp    $0x1,%rax
  680fa6:	74 27                	je     680fcf <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x4f>
  680fa8:	49 89 c2             	mov    %rax,%r10
  680fab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  680fb0:	4d 89 d3             	mov    %r10,%r11
  680fb3:	49 d1 eb             	shr    $1,%r11
  680fb6:	4b 8d 1c 0b          	lea    (%r11,%r9,1),%rbx
  680fba:	4c 8d 34 5b          	lea    (%rbx,%rbx,2),%r14
  680fbe:	43 39 14 b0          	cmp    %edx,(%r8,%r14,4)
  680fc2:	4c 0f 42 cb          	cmovb  %rbx,%r9
  680fc6:	4d 29 da             	sub    %r11,%r10
  680fc9:	49 83 fa 01          	cmp    $0x1,%r10
  680fcd:	77 e1                	ja     680fb0 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x30>
  680fcf:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  680fd3:	43 39 14 90          	cmp    %edx,(%r8,%r10,4)
  680fd7:	49 83 d1 00          	adc    $0x0,%r9
  680fdb:	fe c1                	inc    %cl
  680fdd:	49 c1 e1 02          	shl    $0x2,%r9
  680fe1:	4f 8d 0c 49          	lea    (%r9,%r9,2),%r9
  680fe5:	4f 8d 14 08          	lea    (%r8,%r9,1),%r10
  680fe9:	48 c1 e0 02          	shl    $0x2,%rax
  680fed:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  680ff1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  680ff8:	0f 1f 84 00 00 00 00 
  680fff:	00 
  681000:	45 31 db             	xor    %r11d,%r11d
  681003:	4c 39 c8             	cmp    %r9,%rax
  681006:	0f 84 23 01 00 00    	je     68112f <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x1af>
  68100c:	41 39 12             	cmp    %edx,(%r10)
  68100f:	0f 85 1a 01 00 00    	jne    68112f <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x1af>
  681015:	45 0f b6 5a 08       	movzbl 0x8(%r10),%r11d
  68101a:	49 83 c2 0c          	add    $0xc,%r10
  68101e:	49 83 c1 0c          	add    $0xc,%r9
  681022:	41 84 cb             	test   %cl,%r11b
  681025:	74 d9                	je     681000 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x80>
  681027:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  68102b:	48 8b 76 28          	mov    0x28(%rsi),%rsi
  68102f:	85 d2                	test   %edx,%edx
  681031:	74 5f                	je     681092 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x112>
  681033:	41 80 e3 01          	and    $0x1,%r11b
  681037:	74 59                	je     681092 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x112>
  681039:	48 89 f0             	mov    %rsi,%rax
  68103c:	48 85 f6             	test   %rsi,%rsi
  68103f:	74 3c                	je     68107d <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xfd>
  681041:	31 c0                	xor    %eax,%eax
  681043:	48 83 fe 01          	cmp    $0x1,%rsi
  681047:	74 27                	je     681070 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xf0>
  681049:	49 89 f2             	mov    %rsi,%r10
  68104c:	0f 1f 40 00          	nopl   0x0(%rax)
  681050:	4d 89 d3             	mov    %r10,%r11
  681053:	49 d1 eb             	shr    $1,%r11
  681056:	49 8d 1c 03          	lea    (%r11,%rax,1),%rbx
  68105a:	4c 8d 34 5b          	lea    (%rbx,%rbx,2),%r14
  68105e:	42 39 54 f1 04       	cmp    %edx,0x4(%rcx,%r14,8)
  681063:	48 0f 42 c3          	cmovb  %rbx,%rax
  681067:	4d 29 da             	sub    %r11,%r10
  68106a:	49 83 fa 01          	cmp    $0x1,%r10
  68106e:	77 e0                	ja     681050 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xd0>
  681070:	4c 8d 14 40          	lea    (%rax,%rax,2),%r10
  681074:	42 39 54 d1 04       	cmp    %edx,0x4(%rcx,%r10,8)
  681079:	48 83 d0 00          	adc    $0x0,%rax
  68107d:	48 8d 56 ff          	lea    -0x1(%rsi),%rdx
  681081:	48 39 c2             	cmp    %rax,%rdx
  681084:	48 0f 42 c2          	cmovb  %rdx,%rax
  681088:	eb 5f                	jmp    6810e9 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x169>
  68108a:	45 31 db             	xor    %r11d,%r11d
  68108d:	e9 9d 00 00 00       	jmp    68112f <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x1af>
  681092:	48 89 f0             	mov    %rsi,%rax
  681095:	48 85 f6             	test   %rsi,%rsi
  681098:	74 4f                	je     6810e9 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x169>
  68109a:	45 31 d2             	xor    %r10d,%r10d
  68109d:	48 83 fe 01          	cmp    $0x1,%rsi
  6810a1:	74 2e                	je     6810d1 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x151>
  6810a3:	48 89 f0             	mov    %rsi,%rax
  6810a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  6810ad:	00 00 00 
  6810b0:	4d 89 d3             	mov    %r10,%r11
  6810b3:	48 89 c3             	mov    %rax,%rbx
  6810b6:	48 d1 eb             	shr    $1,%rbx
  6810b9:	49 01 da             	add    %rbx,%r10
  6810bc:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  6810c0:	42 39 14 f1          	cmp    %edx,(%rcx,%r14,8)
  6810c4:	4d 0f 47 d3          	cmova  %r11,%r10
  6810c8:	48 29 d8             	sub    %rbx,%rax
  6810cb:	48 83 f8 01          	cmp    $0x1,%rax
  6810cf:	77 df                	ja     6810b0 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x130>
  6810d1:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  6810d5:	31 c0                	xor    %eax,%eax
  6810d7:	42 39 14 d9          	cmp    %edx,(%rcx,%r11,8)
  6810db:	0f 96 c0             	setbe  %al
  6810de:	4c 01 d0             	add    %r10,%rax
  6810e1:	48 83 f8 01          	cmp    $0x1,%rax
  6810e5:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  6810e9:	48 39 f0             	cmp    %rsi,%rax
  6810ec:	73 4f                	jae    68113d <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x1bd>
  6810ee:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6810f2:	f3 43 0f 10 44 08 f8 	movss  -0x8(%r8,%r9,1),%xmm0
  6810f9:	f3 0f 10 0d ab c3 99 	movss  -0x663c55(%rip),%xmm1        # 1d4ac <GCC_except_table0+0x3c>
  681100:	ff 
  681101:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  681105:	f3 0f 5c c8          	subss  %xmm0,%xmm1
  681109:	f3 0f 10 54 c1 08    	movss  0x8(%rcx,%rax,8),%xmm2
  68110f:	f3 0f 10 5c c1 0c    	movss  0xc(%rcx,%rax,8),%xmm3
  681115:	f3 0f 11 47 04       	movss  %xmm0,0x4(%rdi)
  68111a:	f3 0f 11 57 08       	movss  %xmm2,0x8(%rdi)
  68111f:	f3 0f 11 4f 0c       	movss  %xmm1,0xc(%rdi)
  681124:	f3 0f 11 5f 10       	movss  %xmm3,0x10(%rdi)
  681129:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  68112f:	44 89 1f             	mov    %r11d,(%rdi)
  681132:	48 89 f8             	mov    %rdi,%rax
  681135:	48 83 c4 08          	add    $0x8,%rsp
  681139:	5b                   	pop    %rbx
  68113a:	41 5e                	pop    %r14
  68113c:	c3                   	ret
  68113d:	48 8d 15 04 c8 0f 00 	lea    0xfc804(%rip),%rdx        # 77d948 <anon.11946e5055af849423ef6f6fa3ccb0e0.6.llvm.6812186184794855116+0x48>
  681144:	48 89 c7             	mov    %rax,%rdi
  681147:	ff 15 6b 65 10 00    	call   *0x10656b(%rip)        # 7876b8 <_DYNAMIC+0x398>

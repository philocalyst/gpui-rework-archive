
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000683e10 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds>:
  683e10:	53                   	push   %rbx
  683e11:	f6 42 08 01          	testb  $0x1,0x8(%rdx)
  683e15:	44 8b 02             	mov    (%rdx),%r8d
  683e18:	48 8b 4e 38          	mov    0x38(%rsi),%rcx
  683e1c:	48 8b 76 40          	mov    0x40(%rsi),%rsi
  683e20:	74 58                	je     683e7a <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x6a>
  683e22:	45 85 c0             	test   %r8d,%r8d
  683e25:	74 53                	je     683e7a <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x6a>
  683e27:	48 89 f0             	mov    %rsi,%rax
  683e2a:	48 85 f6             	test   %rsi,%rsi
  683e2d:	74 3e                	je     683e6d <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x5d>
  683e2f:	31 c0                	xor    %eax,%eax
  683e31:	48 83 fe 01          	cmp    $0x1,%rsi
  683e35:	74 29                	je     683e60 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x50>
  683e37:	49 89 f1             	mov    %rsi,%r9
  683e3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  683e40:	4d 89 ca             	mov    %r9,%r10
  683e43:	49 d1 ea             	shr    $1,%r10
  683e46:	4d 8d 1c 02          	lea    (%r10,%rax,1),%r11
  683e4a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  683e4e:	44 39 44 d9 04       	cmp    %r8d,0x4(%rcx,%rbx,8)
  683e53:	49 0f 42 c3          	cmovb  %r11,%rax
  683e57:	4d 29 d1             	sub    %r10,%r9
  683e5a:	49 83 f9 01          	cmp    $0x1,%r9
  683e5e:	77 e0                	ja     683e40 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x30>
  683e60:	4c 8d 0c 40          	lea    (%rax,%rax,2),%r9
  683e64:	46 39 44 c9 04       	cmp    %r8d,0x4(%rcx,%r9,8)
  683e69:	48 83 d0 00          	adc    $0x0,%rax
  683e6d:	4c 8d 46 ff          	lea    -0x1(%rsi),%r8
  683e71:	49 39 c0             	cmp    %rax,%r8
  683e74:	49 0f 42 c0          	cmovb  %r8,%rax
  683e78:	eb 4f                	jmp    683ec9 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xb9>
  683e7a:	48 89 f0             	mov    %rsi,%rax
  683e7d:	48 85 f6             	test   %rsi,%rsi
  683e80:	74 47                	je     683ec9 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xb9>
  683e82:	45 31 c9             	xor    %r9d,%r9d
  683e85:	48 83 fe 01          	cmp    $0x1,%rsi
  683e89:	74 26                	je     683eb1 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xa1>
  683e8b:	48 89 f0             	mov    %rsi,%rax
  683e8e:	66 90                	xchg   %ax,%ax
  683e90:	4d 89 ca             	mov    %r9,%r10
  683e93:	49 89 c3             	mov    %rax,%r11
  683e96:	49 d1 eb             	shr    $1,%r11
  683e99:	4d 01 d9             	add    %r11,%r9
  683e9c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  683ea0:	44 39 04 d9          	cmp    %r8d,(%rcx,%rbx,8)
  683ea4:	4d 0f 47 ca          	cmova  %r10,%r9
  683ea8:	4c 29 d8             	sub    %r11,%rax
  683eab:	48 83 f8 01          	cmp    $0x1,%rax
  683eaf:	77 df                	ja     683e90 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x80>
  683eb1:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  683eb5:	31 c0                	xor    %eax,%eax
  683eb7:	46 39 04 d1          	cmp    %r8d,(%rcx,%r10,8)
  683ebb:	0f 96 c0             	setbe  %al
  683ebe:	4c 01 c8             	add    %r9,%rax
  683ec1:	48 83 f8 01          	cmp    $0x1,%rax
  683ec5:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  683ec9:	48 39 f0             	cmp    %rsi,%rax
  683ecc:	73 3d                	jae    683f0b <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xfb>
  683ece:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  683ed2:	f3 0f 10 42 04       	movss  0x4(%rdx),%xmm0
  683ed7:	f3 0f 10 0d 4d 97 99 	movss  -0x6668b3(%rip),%xmm1        # 1d62c <GCC_except_table0+0x40>
  683ede:	ff 
  683edf:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  683ee3:	f3 0f 5c c8          	subss  %xmm0,%xmm1
  683ee7:	f3 0f 10 54 c1 08    	movss  0x8(%rcx,%rax,8),%xmm2
  683eed:	f3 0f 10 5c c1 0c    	movss  0xc(%rcx,%rax,8),%xmm3
  683ef3:	f3 0f 11 07          	movss  %xmm0,(%rdi)
  683ef7:	f3 0f 11 57 04       	movss  %xmm2,0x4(%rdi)
  683efc:	f3 0f 11 4f 08       	movss  %xmm1,0x8(%rdi)
  683f01:	f3 0f 11 5f 0c       	movss  %xmm3,0xc(%rdi)
  683f06:	48 89 f8             	mov    %rdi,%rax
  683f09:	5b                   	pop    %rbx
  683f0a:	c3                   	ret
  683f0b:	48 8d 15 ee be 0f 00 	lea    0xfbeee(%rip),%rdx        # 77fe00 <anon.3410b8a693437fb60a075b0edac1ad14.19.llvm.8008813205763886337>
  683f12:	48 89 c7             	mov    %rax,%rdi
  683f15:	ff 15 bd 58 10 00    	call   *0x1058bd(%rip)        # 7897d8 <_DYNAMIC+0x370>

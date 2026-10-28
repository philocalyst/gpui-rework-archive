
/tmp/gpui-text-map-query-refinements/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006858f0 <<gpui_canvas::text::layout::TextGeometry>::stops>:
  6858f0:	53                   	push   %rbx
  6858f1:	89 d0                	mov    %edx,%eax
  6858f3:	31 d2                	xor    %edx,%edx
  6858f5:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  6858fa:	4c 8b 47 40          	mov    0x40(%rdi),%r8
  6858fe:	49 0f 45 d0          	cmovne %r8,%rdx
  685902:	b9 04 00 00 00       	mov    $0x4,%ecx
  685907:	48 0f 45 4f 38       	cmovne 0x38(%rdi),%rcx
  68590c:	85 f6                	test   %esi,%esi
  68590e:	74 4e                	je     68595e <<gpui_canvas::text::layout::TextGeometry>::stops+0x6e>
  685910:	48 85 d2             	test   %rdx,%rdx
  685913:	0f 84 a8 00 00 00    	je     6859c1 <<gpui_canvas::text::layout::TextGeometry>::stops+0xd1>
  685919:	31 ff                	xor    %edi,%edi
  68591b:	48 83 fa 01          	cmp    $0x1,%rdx
  68591f:	74 2e                	je     68594f <<gpui_canvas::text::layout::TextGeometry>::stops+0x5f>
  685921:	4d 89 c1             	mov    %r8,%r9
  685924:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  68592b:	00 00 00 00 00 
  685930:	4d 89 ca             	mov    %r9,%r10
  685933:	49 d1 ea             	shr    $1,%r10
  685936:	4d 8d 1c 3a          	lea    (%r10,%rdi,1),%r11
  68593a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  68593e:	39 74 d9 10          	cmp    %esi,0x10(%rcx,%rbx,8)
  685942:	49 0f 42 fb          	cmovb  %r11,%rdi
  685946:	4d 29 d1             	sub    %r10,%r9
  685949:	49 83 f9 01          	cmp    $0x1,%r9
  68594d:	77 e1                	ja     685930 <<gpui_canvas::text::layout::TextGeometry>::stops+0x40>
  68594f:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  685953:	42 39 74 c9 10       	cmp    %esi,0x10(%rcx,%r9,8)
  685958:	48 83 d7 00          	adc    $0x0,%rdi
  68595c:	eb 0c                	jmp    68596a <<gpui_canvas::text::layout::TextGeometry>::stops+0x7a>
  68595e:	31 ff                	xor    %edi,%edi
  685960:	be 00 00 00 00       	mov    $0x0,%esi
  685965:	48 85 d2             	test   %rdx,%rdx
  685968:	74 5d                	je     6859c7 <<gpui_canvas::text::layout::TextGeometry>::stops+0xd7>
  68596a:	31 f6                	xor    %esi,%esi
  68596c:	48 83 fa 01          	cmp    $0x1,%rdx
  685970:	74 30                	je     6859a2 <<gpui_canvas::text::layout::TextGeometry>::stops+0xb2>
  685972:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  685979:	1f 84 00 00 00 00 00 
  685980:	49 89 f1             	mov    %rsi,%r9
  685983:	4d 89 c2             	mov    %r8,%r10
  685986:	49 d1 ea             	shr    $1,%r10
  685989:	4c 01 d6             	add    %r10,%rsi
  68598c:	4c 8d 1c 76          	lea    (%rsi,%rsi,2),%r11
  685990:	42 39 44 d9 10       	cmp    %eax,0x10(%rcx,%r11,8)
  685995:	49 0f 47 f1          	cmova  %r9,%rsi
  685999:	4d 29 d0             	sub    %r10,%r8
  68599c:	49 83 f8 01          	cmp    $0x1,%r8
  6859a0:	77 de                	ja     685980 <<gpui_canvas::text::layout::TextGeometry>::stops+0x90>
  6859a2:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  6859a6:	42 3b 44 c1 10       	cmp    0x10(%rcx,%r8,8),%eax
  6859ab:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  6859af:	48 39 fe             	cmp    %rdi,%rsi
  6859b2:	73 13                	jae    6859c7 <<gpui_canvas::text::layout::TextGeometry>::stops+0xd7>
  6859b4:	48 8d 0d 5d 81 0f 00 	lea    0xf815d(%rip),%rcx        # 77db18 <anon.54a4d576d54a94f5b464056acc886f06.3.llvm.4127220915301182839+0x30>
  6859bb:	ff 15 4f 1c 10 00    	call   *0x101c4f(%rip)        # 787610 <_DYNAMIC+0x588>
  6859c1:	48 89 d6             	mov    %rdx,%rsi
  6859c4:	48 89 d7             	mov    %rdx,%rdi
  6859c7:	48 29 fe             	sub    %rdi,%rsi
  6859ca:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  6859ce:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
  6859d2:	48 89 f2             	mov    %rsi,%rdx
  6859d5:	5b                   	pop    %rbx
  6859d6:	c3                   	ret

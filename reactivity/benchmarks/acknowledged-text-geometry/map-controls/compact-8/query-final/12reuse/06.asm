
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680880 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>:
  680880:	55                   	push   %rbp
  680881:	41 57                	push   %r15
  680883:	41 56                	push   %r14
  680885:	41 55                	push   %r13
  680887:	41 54                	push   %r12
  680889:	53                   	push   %rbx
  68088a:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  680891:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  680896:	74 75                	je     68090d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x8d>
  680898:	49 89 fc             	mov    %rdi,%r12
  68089b:	48 8b 5f 28          	mov    0x28(%rdi),%rbx
  68089f:	48 39 de             	cmp    %rbx,%rsi
  6808a2:	0f 83 bd 06 00 00    	jae    680f65 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6e5>
  6808a8:	49 8b 44 24 38       	mov    0x38(%r12),%rax
  6808ad:	4d 8b 6c 24 40       	mov    0x40(%r12),%r13
  6808b2:	4d 8b 74 24 20       	mov    0x20(%r12),%r14
  6808b7:	48 8d 0c 76          	lea    (%rsi,%rsi,2),%rcx
  6808bb:	45 8b 1c ce          	mov    (%r14,%rcx,8),%r11d
  6808bf:	45 85 db             	test   %r11d,%r11d
  6808c2:	74 50                	je     680914 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x94>
  6808c4:	4c 89 ea             	mov    %r13,%rdx
  6808c7:	4d 85 ed             	test   %r13,%r13
  6808ca:	74 4a                	je     680916 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x96>
  6808cc:	31 d2                	xor    %edx,%edx
  6808ce:	49 83 fd 01          	cmp    $0x1,%r13
  6808d2:	74 2b                	je     6808ff <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x7f>
  6808d4:	4c 89 ef             	mov    %r13,%rdi
  6808d7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  6808de:	00 00 
  6808e0:	49 89 f8             	mov    %rdi,%r8
  6808e3:	49 d1 e8             	shr    $1,%r8
  6808e6:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  6808ea:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  6808ee:	46 39 1c 90          	cmp    %r11d,(%rax,%r10,4)
  6808f2:	49 0f 42 d1          	cmovb  %r9,%rdx
  6808f6:	4c 29 c7             	sub    %r8,%rdi
  6808f9:	48 83 ff 01          	cmp    $0x1,%rdi
  6808fd:	77 e1                	ja     6808e0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x60>
  6808ff:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  680903:	44 39 1c b8          	cmp    %r11d,(%rax,%rdi,4)
  680907:	48 83 d2 00          	adc    $0x0,%rdx
  68090b:	eb 09                	jmp    680916 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x96>
  68090d:	b2 02                	mov    $0x2,%dl
  68090f:	e9 3c 06 00 00       	jmp    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680914:	31 d2                	xor    %edx,%edx
  680916:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
  68091c:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  680921:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  680926:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  68092b:	49 8d 0c ce          	lea    (%r14,%rcx,8),%rcx
  68092f:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  680934:	49 29 d5             	sub    %rdx,%r13
  680937:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  68093b:	48 8d 2c 88          	lea    (%rax,%rcx,4),%rbp
  68093f:	f3 41 0f 10 44 24 4c 	movss  0x4c(%r12),%xmm0
  680946:	f3 0f 59 05 aa cb 99 	mulss  -0x663456(%rip),%xmm0        # 1d4f8 <GCC_except_table0+0x88>
  68094d:	ff 
  68094e:	f3 0f 11 44 24 1c    	movss  %xmm0,0x1c(%rsp)
  680954:	c6 44 24 07 02       	movb   $0x2,0x7(%rsp)
  680959:	31 f6                	xor    %esi,%esi
  68095b:	b0 02                	mov    $0x2,%al
  68095d:	4d 89 ee             	mov    %r13,%r14
  680960:	48 89 eb             	mov    %rbp,%rbx
  680963:	4c 89 6c 24 48       	mov    %r13,0x48(%rsp)
  680968:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  68096d:	44 89 f9             	mov    %r15d,%ecx
  680970:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  680976:	41 89 cf             	mov    %ecx,%r15d
  680979:	89 44 24 08          	mov    %eax,0x8(%rsp)
  68097d:	eb 04                	jmp    680983 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x103>
  68097f:	90                   	nop
  680980:	40 b6 01             	mov    $0x1,%sil
  680983:	48 89 e8             	mov    %rbp,%rax
  680986:	48 89 da             	mov    %rbx,%rdx
  680989:	4c 89 e9             	mov    %r13,%rcx
  68098c:	49 83 fd 01          	cmp    $0x1,%r13
  680990:	74 33                	je     6809c5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x145>
  680992:	4d 85 ed             	test   %r13,%r13
  680995:	0f 84 a6 02 00 00    	je     680c41 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  68099b:	8b 38                	mov    (%rax),%edi
  68099d:	4c 8d 40 0c          	lea    0xc(%rax),%r8
  6809a1:	4d 8d 4d 01          	lea    0x1(%r13),%r9
  6809a5:	b9 01 00 00 00       	mov    $0x1,%ecx
  6809aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  6809b0:	41 3b 38             	cmp    (%r8),%edi
  6809b3:	75 10                	jne    6809c5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x145>
  6809b5:	48 ff c1             	inc    %rcx
  6809b8:	49 83 c0 0c          	add    $0xc,%r8
  6809bc:	49 ff c9             	dec    %r9
  6809bf:	49 83 f9 02          	cmp    $0x2,%r9
  6809c3:	77 eb                	ja     6809b0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x130>
  6809c5:	49 29 cd             	sub    %rcx,%r13
  6809c8:	0f 82 26 05 00 00    	jb     680ef4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  6809ce:	40 f6 c6 01          	test   $0x1,%sil
  6809d2:	0f 84 ac 01 00 00    	je     680b84 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x304>
  6809d8:	4c 89 f6             	mov    %r14,%rsi
  6809db:	49 83 fe 01          	cmp    $0x1,%r14
  6809df:	74 34                	je     680a15 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x195>
  6809e1:	4d 85 f6             	test   %r14,%r14
  6809e4:	0f 84 57 02 00 00    	je     680c41 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  6809ea:	8b 3a                	mov    (%rdx),%edi
  6809ec:	4c 8d 42 0c          	lea    0xc(%rdx),%r8
  6809f0:	4d 8d 4e 01          	lea    0x1(%r14),%r9
  6809f4:	be 01 00 00 00       	mov    $0x1,%esi
  6809f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  680a00:	41 3b 38             	cmp    (%r8),%edi
  680a03:	75 10                	jne    680a15 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x195>
  680a05:	48 ff c6             	inc    %rsi
  680a08:	49 83 c0 0c          	add    $0xc,%r8
  680a0c:	49 ff c9             	dec    %r9
  680a0f:	49 83 f9 02          	cmp    $0x2,%r9
  680a13:	77 eb                	ja     680a00 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x180>
  680a15:	49 29 f6             	sub    %rsi,%r14
  680a18:	0f 82 d6 04 00 00    	jb     680ef4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  680a1e:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  680a22:	48 8d 1c ba          	lea    (%rdx,%rdi,4),%rbx
  680a26:	48 8d 3c 49          	lea    (%rcx,%rcx,2),%rdi
  680a2a:	48 8d 2c b8          	lea    (%rax,%rdi,4),%rbp
  680a2e:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  680a35:	00 
  680a36:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
  680a3d:	00 
  680a3e:	48 89 94 24 98 00 00 	mov    %rdx,0x98(%rsp)
  680a45:	00 
  680a46:	48 89 b4 24 a0 00 00 	mov    %rsi,0xa0(%rsp)
  680a4d:	00 
  680a4e:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  680a53:	4c 89 e6             	mov    %r12,%rsi
  680a56:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  680a5c:	48 8d 94 24 88 00 00 	lea    0x88(%rsp),%rdx
  680a63:	00 
  680a64:	e8 f7 f5 ff ff       	call   680060 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}>
  680a69:	0f b6 44 24 54       	movzbl 0x54(%rsp),%eax
  680a6e:	3c 02                	cmp    $0x2,%al
  680a70:	0f 84 0a ff ff ff    	je     680980 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x100>
  680a76:	8b 4c 24 50          	mov    0x50(%rsp),%ecx
  680a7a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  680a7f:	3b 4a 04             	cmp    0x4(%rdx),%ecx
  680a82:	0f 87 b9 01 00 00    	ja     680c41 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  680a88:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  680a8d:	48 39 54 24 70       	cmp    %rdx,0x70(%rsp)
  680a92:	0f 85 e8 fe ff ff    	jne    680980 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x100>
  680a98:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  680a9e:	f6 84 24 80 00 00 00 	testb  $0x1,0x80(%rsp)
  680aa5:	01 
  680aa6:	74 3d                	je     680ae5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x265>
  680aa8:	89 ca                	mov    %ecx,%edx
  680aaa:	89 c7                	mov    %eax,%edi
  680aac:	0f 28 c8             	movaps %xmm0,%xmm1
  680aaf:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
  680ab5:	0f 2e c2             	ucomiss %xmm2,%xmm0
  680ab8:	0f 87 a4 00 00 00    	ja     680b62 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2e2>
  680abe:	0f 2e d1             	ucomiss %xmm1,%xmm2
  680ac1:	0f 86 55 04 00 00    	jbe    680f1c <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x69c>
  680ac7:	40 b6 01             	mov    $0x1,%sil
  680aca:	80 7c 24 07 02       	cmpb   $0x2,0x7(%rsp)
  680acf:	0f 84 4e 01 00 00    	je     680c23 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3a3>
  680ad5:	0f 2e 4c 24 10       	ucomiss 0x10(%rsp),%xmm1
  680ada:	0f 86 a3 fe ff ff    	jbe    680983 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x103>
  680ae0:	e9 3e 01 00 00       	jmp    680c23 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3a3>
  680ae5:	8b 54 24 58          	mov    0x58(%rsp),%edx
  680ae9:	0f b6 74 24 5c       	movzbl 0x5c(%rsp),%esi
  680aee:	f3 0f 10 4c 24 7c    	movss  0x7c(%rsp),%xmm1
  680af4:	40 80 e6 01          	and    $0x1,%sil
  680af8:	0f 28 d8             	movaps %xmm0,%xmm3
  680afb:	f3 0f 5d d9          	minss  %xmm1,%xmm3
  680aff:	0f 28 d3             	movaps %xmm3,%xmm2
  680b02:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  680b07:	0f 28 e2             	movaps %xmm2,%xmm4
  680b0a:	0f 55 e3             	andnps %xmm3,%xmm4
  680b0d:	0f 54 d0             	andps  %xmm0,%xmm2
  680b10:	0f 56 d4             	orps   %xmm4,%xmm2
  680b13:	0f 28 d8             	movaps %xmm0,%xmm3
  680b16:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  680b1a:	0f 2e c8             	ucomiss %xmm0,%xmm1
  680b1d:	41 89 c8             	mov    %ecx,%r8d
  680b20:	44 0f 46 c2          	cmovbe %edx,%r8d
  680b24:	0f 28 cb             	movaps %xmm3,%xmm1
  680b27:	f3 0f c2 cb 03       	cmpunordss %xmm3,%xmm1
  680b2c:	44 0f b6 c8          	movzbl %al,%r9d
  680b30:	40 0f b6 fe          	movzbl %sil,%edi
  680b34:	44 89 c8             	mov    %r9d,%eax
  680b37:	0f 46 c7             	cmovbe %edi,%eax
  680b3a:	0f 28 e1             	movaps %xmm1,%xmm4
  680b3d:	0f 46 d1             	cmovbe %ecx,%edx
  680b40:	0f 55 e3             	andnps %xmm3,%xmm4
  680b43:	41 0f 46 f9          	cmovbe %r9d,%edi
  680b47:	0f 54 c8             	andps  %xmm0,%xmm1
  680b4a:	0f 56 cc             	orps   %xmm4,%xmm1
  680b4d:	0f 28 c2             	movaps %xmm2,%xmm0
  680b50:	44 89 c1             	mov    %r8d,%ecx
  680b53:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
  680b59:	0f 2e c2             	ucomiss %xmm2,%xmm0
  680b5c:	0f 86 5c ff ff ff    	jbe    680abe <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x23e>
  680b62:	40 b6 01             	mov    $0x1,%sil
  680b65:	80 7c 24 08 02       	cmpb   $0x2,0x8(%rsp)
  680b6a:	0f 84 00 fe ff ff    	je     680970 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xf0>
  680b70:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  680b76:	0f 2e c8             	ucomiss %xmm0,%xmm1
  680b79:	0f 86 04 fe ff ff    	jbe    680983 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x103>
  680b7f:	e9 ec fd ff ff       	jmp    680970 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xf0>
  680b84:	4d 89 f1             	mov    %r14,%r9
  680b87:	49 83 fe 01          	cmp    $0x1,%r14
  680b8b:	74 2d                	je     680bba <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x33a>
  680b8d:	4d 85 f6             	test   %r14,%r14
  680b90:	0f 84 ab 00 00 00    	je     680c41 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  680b96:	8b 32                	mov    (%rdx),%esi
  680b98:	48 8d 7a 0c          	lea    0xc(%rdx),%rdi
  680b9c:	4d 8d 46 01          	lea    0x1(%r14),%r8
  680ba0:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  680ba6:	3b 37                	cmp    (%rdi),%esi
  680ba8:	75 10                	jne    680bba <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x33a>
  680baa:	49 ff c1             	inc    %r9
  680bad:	48 83 c7 0c          	add    $0xc,%rdi
  680bb1:	49 ff c8             	dec    %r8
  680bb4:	49 83 f8 02          	cmp    $0x2,%r8
  680bb8:	77 ec                	ja     680ba6 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x326>
  680bba:	4c 89 f7             	mov    %r14,%rdi
  680bbd:	4c 29 cf             	sub    %r9,%rdi
  680bc0:	0f 82 2e 03 00 00    	jb     680ef4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  680bc6:	4f 8d 1c 49          	lea    (%r9,%r9,2),%r11
  680bca:	4e 8d 04 9a          	lea    (%rdx,%r11,4),%r8
  680bce:	48 89 fe             	mov    %rdi,%rsi
  680bd1:	48 83 ff 01          	cmp    $0x1,%rdi
  680bd5:	74 30                	je     680c07 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x387>
  680bd7:	48 85 ff             	test   %rdi,%rdi
  680bda:	74 65                	je     680c41 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  680bdc:	45 8b 10             	mov    (%r8),%r10d
  680bdf:	4a 8d 14 9a          	lea    (%rdx,%r11,4),%rdx
  680be3:	48 83 c2 0c          	add    $0xc,%rdx
  680be7:	4d 29 ce             	sub    %r9,%r14
  680bea:	49 ff c6             	inc    %r14
  680bed:	be 01 00 00 00       	mov    $0x1,%esi
  680bf2:	44 3b 12             	cmp    (%rdx),%r10d
  680bf5:	75 10                	jne    680c07 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x387>
  680bf7:	48 ff c6             	inc    %rsi
  680bfa:	48 83 c2 0c          	add    $0xc,%rdx
  680bfe:	49 ff ce             	dec    %r14
  680c01:	49 83 fe 02          	cmp    $0x2,%r14
  680c05:	77 eb                	ja     680bf2 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x372>
  680c07:	48 29 f7             	sub    %rsi,%rdi
  680c0a:	0f 82 e4 02 00 00    	jb     680ef4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  680c10:	48 8d 14 76          	lea    (%rsi,%rsi,2),%rdx
  680c14:	49 8d 1c 90          	lea    (%r8,%rdx,4),%rbx
  680c18:	49 89 fe             	mov    %rdi,%r14
  680c1b:	4c 89 c2             	mov    %r8,%rdx
  680c1e:	e9 03 fe ff ff       	jmp    680a26 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1a6>
  680c23:	40 88 7c 24 07       	mov    %dil,0x7(%rsp)
  680c28:	89 54 24 14          	mov    %edx,0x14(%rsp)
  680c2c:	f3 0f 11 4c 24 10    	movss  %xmm1,0x10(%rsp)
  680c32:	8b 44 24 08          	mov    0x8(%rsp),%eax
  680c36:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  680c3c:	e9 2c fd ff ff       	jmp    68096d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xed>
  680c41:	0f b6 4c 24 07       	movzbl 0x7(%rsp),%ecx
  680c46:	80 f9 02             	cmp    $0x2,%cl
  680c49:	75 51                	jne    680c9c <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x41c>
  680c4b:	8b 54 24 08          	mov    0x8(%rsp),%edx
  680c4f:	80 fa 02             	cmp    $0x2,%dl
  680c52:	0f 85 f8 02 00 00    	jne    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680c58:	b2 02                	mov    $0x2,%dl
  680c5a:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  680c5f:	48 85 c0             	test   %rax,%rax
  680c62:	0f 84 82 02 00 00    	je     680eea <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x66a>
  680c68:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  680c6c:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
  680c71:	48 8d 04 85 00 00 00 	lea    0x0(,%rax,4),%rax
  680c78:	00 
  680c79:	4c 01 e8             	add    %r13,%rax
  680c7c:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  680c81:	8b 49 04             	mov    0x4(%rcx),%ecx
  680c84:	4c 8b 74 24 40       	mov    0x40(%rsp),%r14
  680c89:	49 8d 56 ff          	lea    -0x1(%r14),%rdx
  680c8d:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  680c92:	4c 8b 64 24 38       	mov    0x38(%rsp),%r12
  680c97:	e9 82 00 00 00       	jmp    680d1e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x49e>
  680c9c:	8b 44 24 08          	mov    0x8(%rsp),%eax
  680ca0:	3c 02                	cmp    $0x2,%al
  680ca2:	75 0c                	jne    680cb0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x430>
  680ca4:	89 ca                	mov    %ecx,%edx
  680ca6:	44 8b 7c 24 14       	mov    0x14(%rsp),%r15d
  680cab:	e9 a0 02 00 00       	jmp    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680cb0:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  680cb6:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  680cba:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  680cc0:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  680cc4:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
  680cc8:	f2 0f 59 0d f0 39 9a 	mulsd  -0x65c610(%rip),%xmm1        # 246c0 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x110>
  680ccf:	ff 
  680cd0:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  680cd6:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  680cda:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  680cde:	44 0f 46 7c 24 14    	cmovbe 0x14(%rsp),%r15d
  680ce4:	0f b6 c0             	movzbl %al,%eax
  680ce7:	0f b6 d1             	movzbl %cl,%edx
  680cea:	0f 47 d0             	cmova  %eax,%edx
  680ced:	e9 5e 02 00 00       	jmp    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680cf2:	31 f6                	xor    %esi,%esi
  680cf4:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  680cf8:	45 39 7c fc 04       	cmp    %r15d,0x4(%r12,%rdi,8)
  680cfd:	48 83 d6 00          	adc    $0x0,%rsi
  680d01:	48 39 f2             	cmp    %rsi,%rdx
  680d04:	48 0f 42 f2          	cmovb  %rdx,%rsi
  680d08:	48 39 de             	cmp    %rbx,%rsi
  680d0b:	0f 84 00 02 00 00    	je     680f11 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x691>
  680d11:	49 83 c5 0c          	add    $0xc,%r13
  680d15:	49 39 c5             	cmp    %rax,%r13
  680d18:	0f 84 d2 01 00 00    	je     680ef0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x670>
  680d1e:	45 8b 7d 00          	mov    0x0(%r13),%r15d
  680d22:	41 39 cf             	cmp    %ecx,%r15d
  680d25:	0f 87 c1 01 00 00    	ja     680eec <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x66c>
  680d2b:	41 0f b6 75 08       	movzbl 0x8(%r13),%esi
  680d30:	45 85 ff             	test   %r15d,%r15d
  680d33:	74 2b                	je     680d60 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x4e0>
  680d35:	40 f6 c6 02          	test   $0x2,%sil
  680d39:	0f 84 95 00 00 00    	je     680dd4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x554>
  680d3f:	4d 89 f0             	mov    %r14,%r8
  680d42:	4d 85 f6             	test   %r14,%r14
  680d45:	0f 84 80 00 00 00    	je     680dcb <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x54b>
  680d4b:	49 83 fe 01          	cmp    $0x1,%r14
  680d4f:	75 36                	jne    680d87 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x507>
  680d51:	31 ff                	xor    %edi,%edi
  680d53:	eb 5c                	jmp    680db1 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x531>
  680d55:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  680d5c:	00 00 00 00 
  680d60:	40 f6 c6 02          	test   $0x2,%sil
  680d64:	0f 84 0a 01 00 00    	je     680e74 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5f4>
  680d6a:	4d 89 f0             	mov    %r14,%r8
  680d6d:	4d 85 f6             	test   %r14,%r14
  680d70:	0f 84 f5 00 00 00    	je     680e6b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5eb>
  680d76:	49 83 fe 01          	cmp    $0x1,%r14
  680d7a:	0f 85 a5 00 00 00    	jne    680e25 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5a5>
  680d80:	31 ff                	xor    %edi,%edi
  680d82:	e9 c9 00 00 00       	jmp    680e50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5d0>
  680d87:	4d 89 f0             	mov    %r14,%r8
  680d8a:	31 ff                	xor    %edi,%edi
  680d8c:	0f 1f 40 00          	nopl   0x0(%rax)
  680d90:	49 89 f9             	mov    %rdi,%r9
  680d93:	4d 89 c2             	mov    %r8,%r10
  680d96:	49 d1 ea             	shr    $1,%r10
  680d99:	4c 01 d7             	add    %r10,%rdi
  680d9c:	4c 8d 1c 7f          	lea    (%rdi,%rdi,2),%r11
  680da0:	47 39 3c dc          	cmp    %r15d,(%r12,%r11,8)
  680da4:	49 0f 47 f9          	cmova  %r9,%rdi
  680da8:	4d 29 d0             	sub    %r10,%r8
  680dab:	49 83 f8 01          	cmp    $0x1,%r8
  680daf:	77 df                	ja     680d90 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x510>
  680db1:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  680db5:	45 31 c0             	xor    %r8d,%r8d
  680db8:	47 39 3c cc          	cmp    %r15d,(%r12,%r9,8)
  680dbc:	41 0f 96 c0          	setbe  %r8b
  680dc0:	49 01 f8             	add    %rdi,%r8
  680dc3:	49 83 f8 01          	cmp    $0x1,%r8
  680dc7:	49 83 d0 ff          	adc    $0xffffffffffffffff,%r8
  680dcb:	49 39 d8             	cmp    %rbx,%r8
  680dce:	0f 84 39 01 00 00    	je     680f0d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x68d>
  680dd4:	40 f6 c6 01          	test   $0x1,%sil
  680dd8:	0f 84 33 ff ff ff    	je     680d11 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x491>
  680dde:	4c 89 f6             	mov    %r14,%rsi
  680de1:	4d 85 f6             	test   %r14,%r14
  680de4:	0f 84 1e ff ff ff    	je     680d08 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x488>
  680dea:	49 83 fe 01          	cmp    $0x1,%r14
  680dee:	0f 84 fe fe ff ff    	je     680cf2 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x472>
  680df4:	4c 89 f7             	mov    %r14,%rdi
  680df7:	31 f6                	xor    %esi,%esi
  680df9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  680e00:	49 89 f8             	mov    %rdi,%r8
  680e03:	49 d1 e8             	shr    $1,%r8
  680e06:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  680e0a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  680e0e:	47 39 7c d4 04       	cmp    %r15d,0x4(%r12,%r10,8)
  680e13:	49 0f 42 f1          	cmovb  %r9,%rsi
  680e17:	4c 29 c7             	sub    %r8,%rdi
  680e1a:	48 83 ff 01          	cmp    $0x1,%rdi
  680e1e:	77 e0                	ja     680e00 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x580>
  680e20:	e9 cf fe ff ff       	jmp    680cf4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x474>
  680e25:	4d 89 f0             	mov    %r14,%r8
  680e28:	31 ff                	xor    %edi,%edi
  680e2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  680e30:	4d 89 c1             	mov    %r8,%r9
  680e33:	49 d1 e9             	shr    $1,%r9
  680e36:	4d 8d 14 39          	lea    (%r9,%rdi,1),%r10
  680e3a:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  680e3e:	43 83 3c dc 00       	cmpl   $0x0,(%r12,%r11,8)
  680e43:	49 0f 44 fa          	cmove  %r10,%rdi
  680e47:	4d 29 c8             	sub    %r9,%r8
  680e4a:	49 83 f8 01          	cmp    $0x1,%r8
  680e4e:	77 e0                	ja     680e30 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5b0>
  680e50:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  680e54:	45 31 c0             	xor    %r8d,%r8d
  680e57:	43 83 3c cc 00       	cmpl   $0x0,(%r12,%r9,8)
  680e5c:	41 0f 94 c0          	sete   %r8b
  680e60:	49 01 f8             	add    %rdi,%r8
  680e63:	49 83 f8 01          	cmp    $0x1,%r8
  680e67:	49 83 d0 ff          	adc    $0xffffffffffffffff,%r8
  680e6b:	49 39 d8             	cmp    %rbx,%r8
  680e6e:	0f 84 a1 00 00 00    	je     680f15 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x695>
  680e74:	40 f6 c6 01          	test   $0x1,%sil
  680e78:	0f 84 93 fe ff ff    	je     680d11 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x491>
  680e7e:	4c 89 f7             	mov    %r14,%rdi
  680e81:	4d 85 f6             	test   %r14,%r14
  680e84:	74 54                	je     680eda <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x65a>
  680e86:	49 83 fe 01          	cmp    $0x1,%r14
  680e8a:	75 04                	jne    680e90 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x610>
  680e8c:	31 f6                	xor    %esi,%esi
  680e8e:	eb 30                	jmp    680ec0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x640>
  680e90:	4c 89 f7             	mov    %r14,%rdi
  680e93:	31 f6                	xor    %esi,%esi
  680e95:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  680e9c:	00 00 00 00 
  680ea0:	49 89 f8             	mov    %rdi,%r8
  680ea3:	49 d1 e8             	shr    $1,%r8
  680ea6:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  680eaa:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  680eae:	43 83 3c d4 00       	cmpl   $0x0,(%r12,%r10,8)
  680eb3:	49 0f 44 f1          	cmove  %r9,%rsi
  680eb7:	4c 29 c7             	sub    %r8,%rdi
  680eba:	48 83 ff 01          	cmp    $0x1,%rdi
  680ebe:	77 e0                	ja     680ea0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x620>
  680ec0:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  680ec4:	31 ff                	xor    %edi,%edi
  680ec6:	43 83 3c c4 00       	cmpl   $0x0,(%r12,%r8,8)
  680ecb:	40 0f 94 c7          	sete   %dil
  680ecf:	48 01 f7             	add    %rsi,%rdi
  680ed2:	48 83 ff 01          	cmp    $0x1,%rdi
  680ed6:	48 83 d7 ff          	adc    $0xffffffffffffffff,%rdi
  680eda:	48 39 df             	cmp    %rbx,%rdi
  680edd:	0f 85 2e fe ff ff    	jne    680d11 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x491>
  680ee3:	31 d2                	xor    %edx,%edx
  680ee5:	45 31 ff             	xor    %r15d,%r15d
  680ee8:	eb 66                	jmp    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680eea:	eb 64                	jmp    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680eec:	b2 02                	mov    $0x2,%dl
  680eee:	eb 60                	jmp    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680ef0:	b2 02                	mov    $0x2,%dl
  680ef2:	eb 5c                	jmp    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680ef4:	48 8d 3d 46 d1 bd ff 	lea    -0x422eba(%rip),%rdi        # 25e041 <anon.329e3194b7ea4d30c6973e63ae7c35c7.13.llvm.3101811785982658095+0x2d1>
  680efb:	48 8d 15 8e ca 0f 00 	lea    0xfca8e(%rip),%rdx        # 77d990 <anon.11946e5055af849423ef6f6fa3ccb0e0.6.llvm.6812186184794855116+0x90>
  680f02:	be 13 00 00 00       	mov    $0x13,%esi
  680f07:	ff 15 63 66 10 00    	call   *0x106663(%rip)        # 787570 <_DYNAMIC+0x250>
  680f0d:	b2 01                	mov    $0x1,%dl
  680f0f:	eb 3f                	jmp    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680f11:	31 d2                	xor    %edx,%edx
  680f13:	eb 3b                	jmp    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680f15:	45 31 ff             	xor    %r15d,%r15d
  680f18:	b2 01                	mov    $0x1,%dl
  680f1a:	eb 34                	jmp    680f50 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  680f1c:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  680f20:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  680f24:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
  680f28:	f2 0f 59 0d 90 37 9a 	mulsd  -0x65c870(%rip),%xmm1        # 246c0 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x110>
  680f2f:	ff 
  680f30:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  680f36:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  680f3a:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  680f3e:	0f 47 ca             	cmova  %edx,%ecx
  680f41:	40 0f b6 d7          	movzbl %dil,%edx
  680f45:	0f b6 c0             	movzbl %al,%eax
  680f48:	0f 47 c2             	cmova  %edx,%eax
  680f4b:	89 c2                	mov    %eax,%edx
  680f4d:	41 89 cf             	mov    %ecx,%r15d
  680f50:	44 89 f8             	mov    %r15d,%eax
  680f53:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  680f5a:	5b                   	pop    %rbx
  680f5b:	41 5c                	pop    %r12
  680f5d:	41 5d                	pop    %r13
  680f5f:	41 5e                	pop    %r14
  680f61:	41 5f                	pop    %r15
  680f63:	5d                   	pop    %rbp
  680f64:	c3                   	ret
  680f65:	48 8d 15 0c ca 0f 00 	lea    0xfca0c(%rip),%rdx        # 77d978 <anon.11946e5055af849423ef6f6fa3ccb0e0.6.llvm.6812186184794855116+0x78>
  680f6c:	48 89 f7             	mov    %rsi,%rdi
  680f6f:	48 89 de             	mov    %rbx,%rsi
  680f72:	ff 15 40 67 10 00    	call   *0x106740(%rip)        # 7876b8 <_DYNAMIC+0x398>


/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000661c40 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>:
  661c40:	55                   	push   %rbp
  661c41:	41 57                	push   %r15
  661c43:	41 56                	push   %r14
  661c45:	41 55                	push   %r13
  661c47:	41 54                	push   %r12
  661c49:	53                   	push   %rbx
  661c4a:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  661c51:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  661c56:	74 75                	je     661ccd <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x8d>
  661c58:	49 89 fc             	mov    %rdi,%r12
  661c5b:	48 8b 5f 28          	mov    0x28(%rdi),%rbx
  661c5f:	48 39 de             	cmp    %rbx,%rsi
  661c62:	0f 83 bd 06 00 00    	jae    662325 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6e5>
  661c68:	49 8b 44 24 38       	mov    0x38(%r12),%rax
  661c6d:	4d 8b 6c 24 40       	mov    0x40(%r12),%r13
  661c72:	4d 8b 74 24 20       	mov    0x20(%r12),%r14
  661c77:	48 8d 0c 76          	lea    (%rsi,%rsi,2),%rcx
  661c7b:	45 8b 1c ce          	mov    (%r14,%rcx,8),%r11d
  661c7f:	45 85 db             	test   %r11d,%r11d
  661c82:	74 50                	je     661cd4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x94>
  661c84:	4c 89 ea             	mov    %r13,%rdx
  661c87:	4d 85 ed             	test   %r13,%r13
  661c8a:	74 4a                	je     661cd6 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x96>
  661c8c:	31 d2                	xor    %edx,%edx
  661c8e:	49 83 fd 01          	cmp    $0x1,%r13
  661c92:	74 2b                	je     661cbf <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x7f>
  661c94:	4c 89 ef             	mov    %r13,%rdi
  661c97:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  661c9e:	00 00 
  661ca0:	49 89 f8             	mov    %rdi,%r8
  661ca3:	49 d1 e8             	shr    $1,%r8
  661ca6:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  661caa:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  661cae:	46 39 1c 90          	cmp    %r11d,(%rax,%r10,4)
  661cb2:	49 0f 42 d1          	cmovb  %r9,%rdx
  661cb6:	4c 29 c7             	sub    %r8,%rdi
  661cb9:	48 83 ff 01          	cmp    $0x1,%rdi
  661cbd:	77 e1                	ja     661ca0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x60>
  661cbf:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  661cc3:	44 39 1c b8          	cmp    %r11d,(%rax,%rdi,4)
  661cc7:	48 83 d2 00          	adc    $0x0,%rdx
  661ccb:	eb 09                	jmp    661cd6 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x96>
  661ccd:	b2 02                	mov    $0x2,%dl
  661ccf:	e9 3c 06 00 00       	jmp    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  661cd4:	31 d2                	xor    %edx,%edx
  661cd6:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
  661cdc:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  661ce1:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  661ce6:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  661ceb:	49 8d 0c ce          	lea    (%r14,%rcx,8),%rcx
  661cef:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  661cf4:	49 29 d5             	sub    %rdx,%r13
  661cf7:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  661cfb:	48 8d 2c 88          	lea    (%rax,%rcx,4),%rbp
  661cff:	f3 41 0f 10 44 24 4c 	movss  0x4c(%r12),%xmm0
  661d06:	f3 0f 59 05 ba b7 9b 	mulss  -0x644846(%rip),%xmm0        # 1d4c8 <GCC_except_table0+0x94>
  661d0d:	ff 
  661d0e:	f3 0f 11 44 24 1c    	movss  %xmm0,0x1c(%rsp)
  661d14:	c6 44 24 07 02       	movb   $0x2,0x7(%rsp)
  661d19:	31 f6                	xor    %esi,%esi
  661d1b:	b0 02                	mov    $0x2,%al
  661d1d:	4d 89 ee             	mov    %r13,%r14
  661d20:	48 89 eb             	mov    %rbp,%rbx
  661d23:	4c 89 6c 24 48       	mov    %r13,0x48(%rsp)
  661d28:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  661d2d:	44 89 f9             	mov    %r15d,%ecx
  661d30:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  661d36:	41 89 cf             	mov    %ecx,%r15d
  661d39:	89 44 24 08          	mov    %eax,0x8(%rsp)
  661d3d:	eb 04                	jmp    661d43 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x103>
  661d3f:	90                   	nop
  661d40:	40 b6 01             	mov    $0x1,%sil
  661d43:	48 89 e8             	mov    %rbp,%rax
  661d46:	48 89 da             	mov    %rbx,%rdx
  661d49:	4c 89 e9             	mov    %r13,%rcx
  661d4c:	49 83 fd 01          	cmp    $0x1,%r13
  661d50:	74 33                	je     661d85 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x145>
  661d52:	4d 85 ed             	test   %r13,%r13
  661d55:	0f 84 a6 02 00 00    	je     662001 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  661d5b:	8b 38                	mov    (%rax),%edi
  661d5d:	4c 8d 40 0c          	lea    0xc(%rax),%r8
  661d61:	4d 8d 4d 01          	lea    0x1(%r13),%r9
  661d65:	b9 01 00 00 00       	mov    $0x1,%ecx
  661d6a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  661d70:	41 3b 38             	cmp    (%r8),%edi
  661d73:	75 10                	jne    661d85 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x145>
  661d75:	48 ff c1             	inc    %rcx
  661d78:	49 83 c0 0c          	add    $0xc,%r8
  661d7c:	49 ff c9             	dec    %r9
  661d7f:	49 83 f9 02          	cmp    $0x2,%r9
  661d83:	77 eb                	ja     661d70 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x130>
  661d85:	49 29 cd             	sub    %rcx,%r13
  661d88:	0f 82 26 05 00 00    	jb     6622b4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  661d8e:	40 f6 c6 01          	test   $0x1,%sil
  661d92:	0f 84 ac 01 00 00    	je     661f44 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x304>
  661d98:	4c 89 f6             	mov    %r14,%rsi
  661d9b:	49 83 fe 01          	cmp    $0x1,%r14
  661d9f:	74 34                	je     661dd5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x195>
  661da1:	4d 85 f6             	test   %r14,%r14
  661da4:	0f 84 57 02 00 00    	je     662001 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  661daa:	8b 3a                	mov    (%rdx),%edi
  661dac:	4c 8d 42 0c          	lea    0xc(%rdx),%r8
  661db0:	4d 8d 4e 01          	lea    0x1(%r14),%r9
  661db4:	be 01 00 00 00       	mov    $0x1,%esi
  661db9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  661dc0:	41 3b 38             	cmp    (%r8),%edi
  661dc3:	75 10                	jne    661dd5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x195>
  661dc5:	48 ff c6             	inc    %rsi
  661dc8:	49 83 c0 0c          	add    $0xc,%r8
  661dcc:	49 ff c9             	dec    %r9
  661dcf:	49 83 f9 02          	cmp    $0x2,%r9
  661dd3:	77 eb                	ja     661dc0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x180>
  661dd5:	49 29 f6             	sub    %rsi,%r14
  661dd8:	0f 82 d6 04 00 00    	jb     6622b4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  661dde:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  661de2:	48 8d 1c ba          	lea    (%rdx,%rdi,4),%rbx
  661de6:	48 8d 3c 49          	lea    (%rcx,%rcx,2),%rdi
  661dea:	48 8d 2c b8          	lea    (%rax,%rdi,4),%rbp
  661dee:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  661df5:	00 
  661df6:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
  661dfd:	00 
  661dfe:	48 89 94 24 98 00 00 	mov    %rdx,0x98(%rsp)
  661e05:	00 
  661e06:	48 89 b4 24 a0 00 00 	mov    %rsi,0xa0(%rsp)
  661e0d:	00 
  661e0e:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  661e13:	4c 89 e6             	mov    %r12,%rsi
  661e16:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  661e1c:	48 8d 94 24 88 00 00 	lea    0x88(%rsp),%rdx
  661e23:	00 
  661e24:	e8 87 f6 ff ff       	call   6614b0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}>
  661e29:	0f b6 44 24 54       	movzbl 0x54(%rsp),%eax
  661e2e:	3c 02                	cmp    $0x2,%al
  661e30:	0f 84 0a ff ff ff    	je     661d40 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x100>
  661e36:	8b 4c 24 50          	mov    0x50(%rsp),%ecx
  661e3a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  661e3f:	3b 4a 04             	cmp    0x4(%rdx),%ecx
  661e42:	0f 87 b9 01 00 00    	ja     662001 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  661e48:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  661e4d:	48 39 54 24 70       	cmp    %rdx,0x70(%rsp)
  661e52:	0f 85 e8 fe ff ff    	jne    661d40 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x100>
  661e58:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  661e5e:	f6 84 24 80 00 00 00 	testb  $0x1,0x80(%rsp)
  661e65:	01 
  661e66:	74 3d                	je     661ea5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x265>
  661e68:	89 ca                	mov    %ecx,%edx
  661e6a:	89 c7                	mov    %eax,%edi
  661e6c:	0f 28 c8             	movaps %xmm0,%xmm1
  661e6f:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
  661e75:	0f 2e c2             	ucomiss %xmm2,%xmm0
  661e78:	0f 87 a4 00 00 00    	ja     661f22 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2e2>
  661e7e:	0f 2e d1             	ucomiss %xmm1,%xmm2
  661e81:	0f 86 55 04 00 00    	jbe    6622dc <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x69c>
  661e87:	40 b6 01             	mov    $0x1,%sil
  661e8a:	80 7c 24 07 02       	cmpb   $0x2,0x7(%rsp)
  661e8f:	0f 84 4e 01 00 00    	je     661fe3 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3a3>
  661e95:	0f 2e 4c 24 10       	ucomiss 0x10(%rsp),%xmm1
  661e9a:	0f 86 a3 fe ff ff    	jbe    661d43 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x103>
  661ea0:	e9 3e 01 00 00       	jmp    661fe3 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3a3>
  661ea5:	8b 54 24 58          	mov    0x58(%rsp),%edx
  661ea9:	0f b6 74 24 5c       	movzbl 0x5c(%rsp),%esi
  661eae:	f3 0f 10 4c 24 7c    	movss  0x7c(%rsp),%xmm1
  661eb4:	40 80 e6 01          	and    $0x1,%sil
  661eb8:	0f 28 d8             	movaps %xmm0,%xmm3
  661ebb:	f3 0f 5d d9          	minss  %xmm1,%xmm3
  661ebf:	0f 28 d3             	movaps %xmm3,%xmm2
  661ec2:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  661ec7:	0f 28 e2             	movaps %xmm2,%xmm4
  661eca:	0f 55 e3             	andnps %xmm3,%xmm4
  661ecd:	0f 54 d0             	andps  %xmm0,%xmm2
  661ed0:	0f 56 d4             	orps   %xmm4,%xmm2
  661ed3:	0f 28 d8             	movaps %xmm0,%xmm3
  661ed6:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  661eda:	0f 2e c8             	ucomiss %xmm0,%xmm1
  661edd:	41 89 c8             	mov    %ecx,%r8d
  661ee0:	44 0f 46 c2          	cmovbe %edx,%r8d
  661ee4:	0f 28 cb             	movaps %xmm3,%xmm1
  661ee7:	f3 0f c2 cb 03       	cmpunordss %xmm3,%xmm1
  661eec:	44 0f b6 c8          	movzbl %al,%r9d
  661ef0:	40 0f b6 fe          	movzbl %sil,%edi
  661ef4:	44 89 c8             	mov    %r9d,%eax
  661ef7:	0f 46 c7             	cmovbe %edi,%eax
  661efa:	0f 28 e1             	movaps %xmm1,%xmm4
  661efd:	0f 46 d1             	cmovbe %ecx,%edx
  661f00:	0f 55 e3             	andnps %xmm3,%xmm4
  661f03:	41 0f 46 f9          	cmovbe %r9d,%edi
  661f07:	0f 54 c8             	andps  %xmm0,%xmm1
  661f0a:	0f 56 cc             	orps   %xmm4,%xmm1
  661f0d:	0f 28 c2             	movaps %xmm2,%xmm0
  661f10:	44 89 c1             	mov    %r8d,%ecx
  661f13:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
  661f19:	0f 2e c2             	ucomiss %xmm2,%xmm0
  661f1c:	0f 86 5c ff ff ff    	jbe    661e7e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x23e>
  661f22:	40 b6 01             	mov    $0x1,%sil
  661f25:	80 7c 24 08 02       	cmpb   $0x2,0x8(%rsp)
  661f2a:	0f 84 00 fe ff ff    	je     661d30 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xf0>
  661f30:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  661f36:	0f 2e c8             	ucomiss %xmm0,%xmm1
  661f39:	0f 86 04 fe ff ff    	jbe    661d43 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x103>
  661f3f:	e9 ec fd ff ff       	jmp    661d30 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xf0>
  661f44:	4d 89 f1             	mov    %r14,%r9
  661f47:	49 83 fe 01          	cmp    $0x1,%r14
  661f4b:	74 2d                	je     661f7a <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x33a>
  661f4d:	4d 85 f6             	test   %r14,%r14
  661f50:	0f 84 ab 00 00 00    	je     662001 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  661f56:	8b 32                	mov    (%rdx),%esi
  661f58:	48 8d 7a 0c          	lea    0xc(%rdx),%rdi
  661f5c:	4d 8d 46 01          	lea    0x1(%r14),%r8
  661f60:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  661f66:	3b 37                	cmp    (%rdi),%esi
  661f68:	75 10                	jne    661f7a <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x33a>
  661f6a:	49 ff c1             	inc    %r9
  661f6d:	48 83 c7 0c          	add    $0xc,%rdi
  661f71:	49 ff c8             	dec    %r8
  661f74:	49 83 f8 02          	cmp    $0x2,%r8
  661f78:	77 ec                	ja     661f66 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x326>
  661f7a:	4c 89 f7             	mov    %r14,%rdi
  661f7d:	4c 29 cf             	sub    %r9,%rdi
  661f80:	0f 82 2e 03 00 00    	jb     6622b4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  661f86:	4f 8d 1c 49          	lea    (%r9,%r9,2),%r11
  661f8a:	4e 8d 04 9a          	lea    (%rdx,%r11,4),%r8
  661f8e:	48 89 fe             	mov    %rdi,%rsi
  661f91:	48 83 ff 01          	cmp    $0x1,%rdi
  661f95:	74 30                	je     661fc7 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x387>
  661f97:	48 85 ff             	test   %rdi,%rdi
  661f9a:	74 65                	je     662001 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  661f9c:	45 8b 10             	mov    (%r8),%r10d
  661f9f:	4a 8d 14 9a          	lea    (%rdx,%r11,4),%rdx
  661fa3:	48 83 c2 0c          	add    $0xc,%rdx
  661fa7:	4d 29 ce             	sub    %r9,%r14
  661faa:	49 ff c6             	inc    %r14
  661fad:	be 01 00 00 00       	mov    $0x1,%esi
  661fb2:	44 3b 12             	cmp    (%rdx),%r10d
  661fb5:	75 10                	jne    661fc7 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x387>
  661fb7:	48 ff c6             	inc    %rsi
  661fba:	48 83 c2 0c          	add    $0xc,%rdx
  661fbe:	49 ff ce             	dec    %r14
  661fc1:	49 83 fe 02          	cmp    $0x2,%r14
  661fc5:	77 eb                	ja     661fb2 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x372>
  661fc7:	48 29 f7             	sub    %rsi,%rdi
  661fca:	0f 82 e4 02 00 00    	jb     6622b4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  661fd0:	48 8d 14 76          	lea    (%rsi,%rsi,2),%rdx
  661fd4:	49 8d 1c 90          	lea    (%r8,%rdx,4),%rbx
  661fd8:	49 89 fe             	mov    %rdi,%r14
  661fdb:	4c 89 c2             	mov    %r8,%rdx
  661fde:	e9 03 fe ff ff       	jmp    661de6 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1a6>
  661fe3:	40 88 7c 24 07       	mov    %dil,0x7(%rsp)
  661fe8:	89 54 24 14          	mov    %edx,0x14(%rsp)
  661fec:	f3 0f 11 4c 24 10    	movss  %xmm1,0x10(%rsp)
  661ff2:	8b 44 24 08          	mov    0x8(%rsp),%eax
  661ff6:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  661ffc:	e9 2c fd ff ff       	jmp    661d2d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xed>
  662001:	0f b6 4c 24 07       	movzbl 0x7(%rsp),%ecx
  662006:	80 f9 02             	cmp    $0x2,%cl
  662009:	75 51                	jne    66205c <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x41c>
  66200b:	8b 54 24 08          	mov    0x8(%rsp),%edx
  66200f:	80 fa 02             	cmp    $0x2,%dl
  662012:	0f 85 f8 02 00 00    	jne    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  662018:	b2 02                	mov    $0x2,%dl
  66201a:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  66201f:	48 85 c0             	test   %rax,%rax
  662022:	0f 84 82 02 00 00    	je     6622aa <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x66a>
  662028:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  66202c:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
  662031:	48 8d 04 85 00 00 00 	lea    0x0(,%rax,4),%rax
  662038:	00 
  662039:	4c 01 e8             	add    %r13,%rax
  66203c:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  662041:	8b 49 04             	mov    0x4(%rcx),%ecx
  662044:	4c 8b 74 24 40       	mov    0x40(%rsp),%r14
  662049:	49 8d 56 ff          	lea    -0x1(%r14),%rdx
  66204d:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  662052:	4c 8b 64 24 38       	mov    0x38(%rsp),%r12
  662057:	e9 82 00 00 00       	jmp    6620de <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x49e>
  66205c:	8b 44 24 08          	mov    0x8(%rsp),%eax
  662060:	3c 02                	cmp    $0x2,%al
  662062:	75 0c                	jne    662070 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x430>
  662064:	89 ca                	mov    %ecx,%edx
  662066:	44 8b 7c 24 14       	mov    0x14(%rsp),%r15d
  66206b:	e9 a0 02 00 00       	jmp    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  662070:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  662076:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  66207a:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  662080:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  662084:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
  662088:	f2 0f 59 0d 00 26 9c 	mulsd  -0x63da00(%rip),%xmm1        # 24690 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x110>
  66208f:	ff 
  662090:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  662096:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  66209a:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  66209e:	44 0f 46 7c 24 14    	cmovbe 0x14(%rsp),%r15d
  6620a4:	0f b6 c0             	movzbl %al,%eax
  6620a7:	0f b6 d1             	movzbl %cl,%edx
  6620aa:	0f 47 d0             	cmova  %eax,%edx
  6620ad:	e9 5e 02 00 00       	jmp    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6620b2:	31 f6                	xor    %esi,%esi
  6620b4:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  6620b8:	45 39 7c fc 04       	cmp    %r15d,0x4(%r12,%rdi,8)
  6620bd:	48 83 d6 00          	adc    $0x0,%rsi
  6620c1:	48 39 f2             	cmp    %rsi,%rdx
  6620c4:	48 0f 42 f2          	cmovb  %rdx,%rsi
  6620c8:	48 39 de             	cmp    %rbx,%rsi
  6620cb:	0f 84 00 02 00 00    	je     6622d1 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x691>
  6620d1:	49 83 c5 0c          	add    $0xc,%r13
  6620d5:	49 39 c5             	cmp    %rax,%r13
  6620d8:	0f 84 d2 01 00 00    	je     6622b0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x670>
  6620de:	45 8b 7d 00          	mov    0x0(%r13),%r15d
  6620e2:	41 39 cf             	cmp    %ecx,%r15d
  6620e5:	0f 87 c1 01 00 00    	ja     6622ac <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x66c>
  6620eb:	41 0f b6 75 08       	movzbl 0x8(%r13),%esi
  6620f0:	45 85 ff             	test   %r15d,%r15d
  6620f3:	74 2b                	je     662120 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x4e0>
  6620f5:	40 f6 c6 02          	test   $0x2,%sil
  6620f9:	0f 84 95 00 00 00    	je     662194 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x554>
  6620ff:	4d 89 f0             	mov    %r14,%r8
  662102:	4d 85 f6             	test   %r14,%r14
  662105:	0f 84 80 00 00 00    	je     66218b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x54b>
  66210b:	49 83 fe 01          	cmp    $0x1,%r14
  66210f:	75 36                	jne    662147 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x507>
  662111:	31 ff                	xor    %edi,%edi
  662113:	eb 5c                	jmp    662171 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x531>
  662115:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  66211c:	00 00 00 00 
  662120:	40 f6 c6 02          	test   $0x2,%sil
  662124:	0f 84 0a 01 00 00    	je     662234 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5f4>
  66212a:	4d 89 f0             	mov    %r14,%r8
  66212d:	4d 85 f6             	test   %r14,%r14
  662130:	0f 84 f5 00 00 00    	je     66222b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5eb>
  662136:	49 83 fe 01          	cmp    $0x1,%r14
  66213a:	0f 85 a5 00 00 00    	jne    6621e5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5a5>
  662140:	31 ff                	xor    %edi,%edi
  662142:	e9 c9 00 00 00       	jmp    662210 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5d0>
  662147:	4d 89 f0             	mov    %r14,%r8
  66214a:	31 ff                	xor    %edi,%edi
  66214c:	0f 1f 40 00          	nopl   0x0(%rax)
  662150:	49 89 f9             	mov    %rdi,%r9
  662153:	4d 89 c2             	mov    %r8,%r10
  662156:	49 d1 ea             	shr    $1,%r10
  662159:	4c 01 d7             	add    %r10,%rdi
  66215c:	4c 8d 1c 7f          	lea    (%rdi,%rdi,2),%r11
  662160:	47 39 3c dc          	cmp    %r15d,(%r12,%r11,8)
  662164:	49 0f 47 f9          	cmova  %r9,%rdi
  662168:	4d 29 d0             	sub    %r10,%r8
  66216b:	49 83 f8 01          	cmp    $0x1,%r8
  66216f:	77 df                	ja     662150 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x510>
  662171:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  662175:	45 31 c0             	xor    %r8d,%r8d
  662178:	47 39 3c cc          	cmp    %r15d,(%r12,%r9,8)
  66217c:	41 0f 96 c0          	setbe  %r8b
  662180:	49 01 f8             	add    %rdi,%r8
  662183:	49 83 f8 01          	cmp    $0x1,%r8
  662187:	49 83 d0 ff          	adc    $0xffffffffffffffff,%r8
  66218b:	49 39 d8             	cmp    %rbx,%r8
  66218e:	0f 84 39 01 00 00    	je     6622cd <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x68d>
  662194:	40 f6 c6 01          	test   $0x1,%sil
  662198:	0f 84 33 ff ff ff    	je     6620d1 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x491>
  66219e:	4c 89 f6             	mov    %r14,%rsi
  6621a1:	4d 85 f6             	test   %r14,%r14
  6621a4:	0f 84 1e ff ff ff    	je     6620c8 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x488>
  6621aa:	49 83 fe 01          	cmp    $0x1,%r14
  6621ae:	0f 84 fe fe ff ff    	je     6620b2 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x472>
  6621b4:	4c 89 f7             	mov    %r14,%rdi
  6621b7:	31 f6                	xor    %esi,%esi
  6621b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6621c0:	49 89 f8             	mov    %rdi,%r8
  6621c3:	49 d1 e8             	shr    $1,%r8
  6621c6:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  6621ca:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  6621ce:	47 39 7c d4 04       	cmp    %r15d,0x4(%r12,%r10,8)
  6621d3:	49 0f 42 f1          	cmovb  %r9,%rsi
  6621d7:	4c 29 c7             	sub    %r8,%rdi
  6621da:	48 83 ff 01          	cmp    $0x1,%rdi
  6621de:	77 e0                	ja     6621c0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x580>
  6621e0:	e9 cf fe ff ff       	jmp    6620b4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x474>
  6621e5:	4d 89 f0             	mov    %r14,%r8
  6621e8:	31 ff                	xor    %edi,%edi
  6621ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  6621f0:	4d 89 c1             	mov    %r8,%r9
  6621f3:	49 d1 e9             	shr    $1,%r9
  6621f6:	4d 8d 14 39          	lea    (%r9,%rdi,1),%r10
  6621fa:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  6621fe:	43 83 3c dc 00       	cmpl   $0x0,(%r12,%r11,8)
  662203:	49 0f 44 fa          	cmove  %r10,%rdi
  662207:	4d 29 c8             	sub    %r9,%r8
  66220a:	49 83 f8 01          	cmp    $0x1,%r8
  66220e:	77 e0                	ja     6621f0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5b0>
  662210:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  662214:	45 31 c0             	xor    %r8d,%r8d
  662217:	43 83 3c cc 00       	cmpl   $0x0,(%r12,%r9,8)
  66221c:	41 0f 94 c0          	sete   %r8b
  662220:	49 01 f8             	add    %rdi,%r8
  662223:	49 83 f8 01          	cmp    $0x1,%r8
  662227:	49 83 d0 ff          	adc    $0xffffffffffffffff,%r8
  66222b:	49 39 d8             	cmp    %rbx,%r8
  66222e:	0f 84 a1 00 00 00    	je     6622d5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x695>
  662234:	40 f6 c6 01          	test   $0x1,%sil
  662238:	0f 84 93 fe ff ff    	je     6620d1 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x491>
  66223e:	4c 89 f7             	mov    %r14,%rdi
  662241:	4d 85 f6             	test   %r14,%r14
  662244:	74 54                	je     66229a <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x65a>
  662246:	49 83 fe 01          	cmp    $0x1,%r14
  66224a:	75 04                	jne    662250 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x610>
  66224c:	31 f6                	xor    %esi,%esi
  66224e:	eb 30                	jmp    662280 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x640>
  662250:	4c 89 f7             	mov    %r14,%rdi
  662253:	31 f6                	xor    %esi,%esi
  662255:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  66225c:	00 00 00 00 
  662260:	49 89 f8             	mov    %rdi,%r8
  662263:	49 d1 e8             	shr    $1,%r8
  662266:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  66226a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  66226e:	43 83 3c d4 00       	cmpl   $0x0,(%r12,%r10,8)
  662273:	49 0f 44 f1          	cmove  %r9,%rsi
  662277:	4c 29 c7             	sub    %r8,%rdi
  66227a:	48 83 ff 01          	cmp    $0x1,%rdi
  66227e:	77 e0                	ja     662260 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x620>
  662280:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  662284:	31 ff                	xor    %edi,%edi
  662286:	43 83 3c c4 00       	cmpl   $0x0,(%r12,%r8,8)
  66228b:	40 0f 94 c7          	sete   %dil
  66228f:	48 01 f7             	add    %rsi,%rdi
  662292:	48 83 ff 01          	cmp    $0x1,%rdi
  662296:	48 83 d7 ff          	adc    $0xffffffffffffffff,%rdi
  66229a:	48 39 df             	cmp    %rbx,%rdi
  66229d:	0f 85 2e fe ff ff    	jne    6620d1 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x491>
  6622a3:	31 d2                	xor    %edx,%edx
  6622a5:	45 31 ff             	xor    %r15d,%r15d
  6622a8:	eb 66                	jmp    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6622aa:	eb 64                	jmp    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6622ac:	b2 02                	mov    $0x2,%dl
  6622ae:	eb 60                	jmp    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6622b0:	b2 02                	mov    $0x2,%dl
  6622b2:	eb 5c                	jmp    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6622b4:	48 8d 3d a6 34 9c ff 	lea    -0x63cb5a(%rip),%rdi        # 25761 <anon.510ecd5b06a31c5d706a3e62c051feab.3.llvm.15957366779061141188+0x9>
  6622bb:	48 8d 15 26 a6 11 00 	lea    0x11a626(%rip),%rdx        # 77c8e8 <anon.b75840af67eff6c7867889150027a6c7.3.llvm.2112026857664668335+0x78>
  6622c2:	be 13 00 00 00       	mov    $0x13,%esi
  6622c7:	ff 15 33 52 12 00    	call   *0x125233(%rip)        # 787500 <_DYNAMIC+0x250>
  6622cd:	b2 01                	mov    $0x1,%dl
  6622cf:	eb 3f                	jmp    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6622d1:	31 d2                	xor    %edx,%edx
  6622d3:	eb 3b                	jmp    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6622d5:	45 31 ff             	xor    %r15d,%r15d
  6622d8:	b2 01                	mov    $0x1,%dl
  6622da:	eb 34                	jmp    662310 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6622dc:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  6622e0:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  6622e4:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
  6622e8:	f2 0f 59 0d a0 23 9c 	mulsd  -0x63dc60(%rip),%xmm1        # 24690 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x110>
  6622ef:	ff 
  6622f0:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  6622f6:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  6622fa:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  6622fe:	0f 47 ca             	cmova  %edx,%ecx
  662301:	40 0f b6 d7          	movzbl %dil,%edx
  662305:	0f b6 c0             	movzbl %al,%eax
  662308:	0f 47 c2             	cmova  %edx,%eax
  66230b:	89 c2                	mov    %eax,%edx
  66230d:	41 89 cf             	mov    %ecx,%r15d
  662310:	44 89 f8             	mov    %r15d,%eax
  662313:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  66231a:	5b                   	pop    %rbx
  66231b:	41 5c                	pop    %r12
  66231d:	41 5d                	pop    %r13
  66231f:	41 5e                	pop    %r14
  662321:	41 5f                	pop    %r15
  662323:	5d                   	pop    %rbp
  662324:	c3                   	ret
  662325:	48 8d 15 a4 a5 11 00 	lea    0x11a5a4(%rip),%rdx        # 77c8d0 <anon.b75840af67eff6c7867889150027a6c7.3.llvm.2112026857664668335+0x60>
  66232c:	48 89 f7             	mov    %rsi,%rdi
  66232f:	48 89 de             	mov    %rbx,%rsi
  662332:	ff 15 18 53 12 00    	call   *0x125318(%rip)        # 787650 <_DYNAMIC+0x3a0>

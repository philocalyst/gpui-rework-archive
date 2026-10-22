
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000661c90 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>:
  661c90:	55                   	push   %rbp
  661c91:	41 57                	push   %r15
  661c93:	41 56                	push   %r14
  661c95:	41 55                	push   %r13
  661c97:	41 54                	push   %r12
  661c99:	53                   	push   %rbx
  661c9a:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  661ca1:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  661ca6:	74 75                	je     661d1d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x8d>
  661ca8:	49 89 fc             	mov    %rdi,%r12
  661cab:	48 8b 5f 28          	mov    0x28(%rdi),%rbx
  661caf:	48 39 de             	cmp    %rbx,%rsi
  661cb2:	0f 83 bd 06 00 00    	jae    662375 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6e5>
  661cb8:	49 8b 44 24 38       	mov    0x38(%r12),%rax
  661cbd:	4d 8b 6c 24 40       	mov    0x40(%r12),%r13
  661cc2:	4d 8b 74 24 20       	mov    0x20(%r12),%r14
  661cc7:	48 8d 0c 76          	lea    (%rsi,%rsi,2),%rcx
  661ccb:	45 8b 1c ce          	mov    (%r14,%rcx,8),%r11d
  661ccf:	45 85 db             	test   %r11d,%r11d
  661cd2:	74 50                	je     661d24 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x94>
  661cd4:	4c 89 ea             	mov    %r13,%rdx
  661cd7:	4d 85 ed             	test   %r13,%r13
  661cda:	74 4a                	je     661d26 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x96>
  661cdc:	31 d2                	xor    %edx,%edx
  661cde:	49 83 fd 01          	cmp    $0x1,%r13
  661ce2:	74 2b                	je     661d0f <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x7f>
  661ce4:	4c 89 ef             	mov    %r13,%rdi
  661ce7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  661cee:	00 00 
  661cf0:	49 89 f8             	mov    %rdi,%r8
  661cf3:	49 d1 e8             	shr    $1,%r8
  661cf6:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  661cfa:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  661cfe:	46 39 1c 90          	cmp    %r11d,(%rax,%r10,4)
  661d02:	49 0f 42 d1          	cmovb  %r9,%rdx
  661d06:	4c 29 c7             	sub    %r8,%rdi
  661d09:	48 83 ff 01          	cmp    $0x1,%rdi
  661d0d:	77 e1                	ja     661cf0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x60>
  661d0f:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  661d13:	44 39 1c b8          	cmp    %r11d,(%rax,%rdi,4)
  661d17:	48 83 d2 00          	adc    $0x0,%rdx
  661d1b:	eb 09                	jmp    661d26 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x96>
  661d1d:	b2 02                	mov    $0x2,%dl
  661d1f:	e9 3c 06 00 00       	jmp    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  661d24:	31 d2                	xor    %edx,%edx
  661d26:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
  661d2c:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  661d31:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  661d36:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  661d3b:	49 8d 0c ce          	lea    (%r14,%rcx,8),%rcx
  661d3f:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  661d44:	49 29 d5             	sub    %rdx,%r13
  661d47:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  661d4b:	48 8d 2c 88          	lea    (%rax,%rcx,4),%rbp
  661d4f:	f3 41 0f 10 44 24 4c 	movss  0x4c(%r12),%xmm0
  661d56:	f3 0f 59 05 6a b7 9b 	mulss  -0x644896(%rip),%xmm0        # 1d4c8 <GCC_except_table0+0x88>
  661d5d:	ff 
  661d5e:	f3 0f 11 44 24 1c    	movss  %xmm0,0x1c(%rsp)
  661d64:	c6 44 24 07 02       	movb   $0x2,0x7(%rsp)
  661d69:	31 f6                	xor    %esi,%esi
  661d6b:	b0 02                	mov    $0x2,%al
  661d6d:	4d 89 ee             	mov    %r13,%r14
  661d70:	48 89 eb             	mov    %rbp,%rbx
  661d73:	4c 89 6c 24 48       	mov    %r13,0x48(%rsp)
  661d78:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  661d7d:	44 89 f9             	mov    %r15d,%ecx
  661d80:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  661d86:	41 89 cf             	mov    %ecx,%r15d
  661d89:	89 44 24 08          	mov    %eax,0x8(%rsp)
  661d8d:	eb 04                	jmp    661d93 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x103>
  661d8f:	90                   	nop
  661d90:	40 b6 01             	mov    $0x1,%sil
  661d93:	48 89 e8             	mov    %rbp,%rax
  661d96:	48 89 da             	mov    %rbx,%rdx
  661d99:	4c 89 e9             	mov    %r13,%rcx
  661d9c:	49 83 fd 01          	cmp    $0x1,%r13
  661da0:	74 33                	je     661dd5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x145>
  661da2:	4d 85 ed             	test   %r13,%r13
  661da5:	0f 84 a6 02 00 00    	je     662051 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  661dab:	8b 38                	mov    (%rax),%edi
  661dad:	4c 8d 40 0c          	lea    0xc(%rax),%r8
  661db1:	4d 8d 4d 01          	lea    0x1(%r13),%r9
  661db5:	b9 01 00 00 00       	mov    $0x1,%ecx
  661dba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  661dc0:	41 3b 38             	cmp    (%r8),%edi
  661dc3:	75 10                	jne    661dd5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x145>
  661dc5:	48 ff c1             	inc    %rcx
  661dc8:	49 83 c0 0c          	add    $0xc,%r8
  661dcc:	49 ff c9             	dec    %r9
  661dcf:	49 83 f9 02          	cmp    $0x2,%r9
  661dd3:	77 eb                	ja     661dc0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x130>
  661dd5:	49 29 cd             	sub    %rcx,%r13
  661dd8:	0f 82 26 05 00 00    	jb     662304 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  661dde:	40 f6 c6 01          	test   $0x1,%sil
  661de2:	0f 84 ac 01 00 00    	je     661f94 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x304>
  661de8:	4c 89 f6             	mov    %r14,%rsi
  661deb:	49 83 fe 01          	cmp    $0x1,%r14
  661def:	74 34                	je     661e25 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x195>
  661df1:	4d 85 f6             	test   %r14,%r14
  661df4:	0f 84 57 02 00 00    	je     662051 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  661dfa:	8b 3a                	mov    (%rdx),%edi
  661dfc:	4c 8d 42 0c          	lea    0xc(%rdx),%r8
  661e00:	4d 8d 4e 01          	lea    0x1(%r14),%r9
  661e04:	be 01 00 00 00       	mov    $0x1,%esi
  661e09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  661e10:	41 3b 38             	cmp    (%r8),%edi
  661e13:	75 10                	jne    661e25 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x195>
  661e15:	48 ff c6             	inc    %rsi
  661e18:	49 83 c0 0c          	add    $0xc,%r8
  661e1c:	49 ff c9             	dec    %r9
  661e1f:	49 83 f9 02          	cmp    $0x2,%r9
  661e23:	77 eb                	ja     661e10 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x180>
  661e25:	49 29 f6             	sub    %rsi,%r14
  661e28:	0f 82 d6 04 00 00    	jb     662304 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  661e2e:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  661e32:	48 8d 1c ba          	lea    (%rdx,%rdi,4),%rbx
  661e36:	48 8d 3c 49          	lea    (%rcx,%rcx,2),%rdi
  661e3a:	48 8d 2c b8          	lea    (%rax,%rdi,4),%rbp
  661e3e:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  661e45:	00 
  661e46:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
  661e4d:	00 
  661e4e:	48 89 94 24 98 00 00 	mov    %rdx,0x98(%rsp)
  661e55:	00 
  661e56:	48 89 b4 24 a0 00 00 	mov    %rsi,0xa0(%rsp)
  661e5d:	00 
  661e5e:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  661e63:	4c 89 e6             	mov    %r12,%rsi
  661e66:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  661e6c:	48 8d 94 24 88 00 00 	lea    0x88(%rsp),%rdx
  661e73:	00 
  661e74:	e8 e7 f5 ff ff       	call   661460 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}>
  661e79:	0f b6 44 24 54       	movzbl 0x54(%rsp),%eax
  661e7e:	3c 02                	cmp    $0x2,%al
  661e80:	0f 84 0a ff ff ff    	je     661d90 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x100>
  661e86:	8b 4c 24 50          	mov    0x50(%rsp),%ecx
  661e8a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  661e8f:	3b 4a 04             	cmp    0x4(%rdx),%ecx
  661e92:	0f 87 b9 01 00 00    	ja     662051 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  661e98:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  661e9d:	48 39 54 24 70       	cmp    %rdx,0x70(%rsp)
  661ea2:	0f 85 e8 fe ff ff    	jne    661d90 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x100>
  661ea8:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  661eae:	f6 84 24 80 00 00 00 	testb  $0x1,0x80(%rsp)
  661eb5:	01 
  661eb6:	74 3d                	je     661ef5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x265>
  661eb8:	89 ca                	mov    %ecx,%edx
  661eba:	89 c7                	mov    %eax,%edi
  661ebc:	0f 28 c8             	movaps %xmm0,%xmm1
  661ebf:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
  661ec5:	0f 2e c2             	ucomiss %xmm2,%xmm0
  661ec8:	0f 87 a4 00 00 00    	ja     661f72 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2e2>
  661ece:	0f 2e d1             	ucomiss %xmm1,%xmm2
  661ed1:	0f 86 55 04 00 00    	jbe    66232c <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x69c>
  661ed7:	40 b6 01             	mov    $0x1,%sil
  661eda:	80 7c 24 07 02       	cmpb   $0x2,0x7(%rsp)
  661edf:	0f 84 4e 01 00 00    	je     662033 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3a3>
  661ee5:	0f 2e 4c 24 10       	ucomiss 0x10(%rsp),%xmm1
  661eea:	0f 86 a3 fe ff ff    	jbe    661d93 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x103>
  661ef0:	e9 3e 01 00 00       	jmp    662033 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3a3>
  661ef5:	8b 54 24 58          	mov    0x58(%rsp),%edx
  661ef9:	0f b6 74 24 5c       	movzbl 0x5c(%rsp),%esi
  661efe:	f3 0f 10 4c 24 7c    	movss  0x7c(%rsp),%xmm1
  661f04:	40 80 e6 01          	and    $0x1,%sil
  661f08:	0f 28 d8             	movaps %xmm0,%xmm3
  661f0b:	f3 0f 5d d9          	minss  %xmm1,%xmm3
  661f0f:	0f 28 d3             	movaps %xmm3,%xmm2
  661f12:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  661f17:	0f 28 e2             	movaps %xmm2,%xmm4
  661f1a:	0f 55 e3             	andnps %xmm3,%xmm4
  661f1d:	0f 54 d0             	andps  %xmm0,%xmm2
  661f20:	0f 56 d4             	orps   %xmm4,%xmm2
  661f23:	0f 28 d8             	movaps %xmm0,%xmm3
  661f26:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  661f2a:	0f 2e c8             	ucomiss %xmm0,%xmm1
  661f2d:	41 89 c8             	mov    %ecx,%r8d
  661f30:	44 0f 46 c2          	cmovbe %edx,%r8d
  661f34:	0f 28 cb             	movaps %xmm3,%xmm1
  661f37:	f3 0f c2 cb 03       	cmpunordss %xmm3,%xmm1
  661f3c:	44 0f b6 c8          	movzbl %al,%r9d
  661f40:	40 0f b6 fe          	movzbl %sil,%edi
  661f44:	44 89 c8             	mov    %r9d,%eax
  661f47:	0f 46 c7             	cmovbe %edi,%eax
  661f4a:	0f 28 e1             	movaps %xmm1,%xmm4
  661f4d:	0f 46 d1             	cmovbe %ecx,%edx
  661f50:	0f 55 e3             	andnps %xmm3,%xmm4
  661f53:	41 0f 46 f9          	cmovbe %r9d,%edi
  661f57:	0f 54 c8             	andps  %xmm0,%xmm1
  661f5a:	0f 56 cc             	orps   %xmm4,%xmm1
  661f5d:	0f 28 c2             	movaps %xmm2,%xmm0
  661f60:	44 89 c1             	mov    %r8d,%ecx
  661f63:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
  661f69:	0f 2e c2             	ucomiss %xmm2,%xmm0
  661f6c:	0f 86 5c ff ff ff    	jbe    661ece <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x23e>
  661f72:	40 b6 01             	mov    $0x1,%sil
  661f75:	80 7c 24 08 02       	cmpb   $0x2,0x8(%rsp)
  661f7a:	0f 84 00 fe ff ff    	je     661d80 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xf0>
  661f80:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  661f86:	0f 2e c8             	ucomiss %xmm0,%xmm1
  661f89:	0f 86 04 fe ff ff    	jbe    661d93 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x103>
  661f8f:	e9 ec fd ff ff       	jmp    661d80 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xf0>
  661f94:	4d 89 f1             	mov    %r14,%r9
  661f97:	49 83 fe 01          	cmp    $0x1,%r14
  661f9b:	74 2d                	je     661fca <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x33a>
  661f9d:	4d 85 f6             	test   %r14,%r14
  661fa0:	0f 84 ab 00 00 00    	je     662051 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  661fa6:	8b 32                	mov    (%rdx),%esi
  661fa8:	48 8d 7a 0c          	lea    0xc(%rdx),%rdi
  661fac:	4d 8d 46 01          	lea    0x1(%r14),%r8
  661fb0:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  661fb6:	3b 37                	cmp    (%rdi),%esi
  661fb8:	75 10                	jne    661fca <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x33a>
  661fba:	49 ff c1             	inc    %r9
  661fbd:	48 83 c7 0c          	add    $0xc,%rdi
  661fc1:	49 ff c8             	dec    %r8
  661fc4:	49 83 f8 02          	cmp    $0x2,%r8
  661fc8:	77 ec                	ja     661fb6 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x326>
  661fca:	4c 89 f7             	mov    %r14,%rdi
  661fcd:	4c 29 cf             	sub    %r9,%rdi
  661fd0:	0f 82 2e 03 00 00    	jb     662304 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  661fd6:	4f 8d 1c 49          	lea    (%r9,%r9,2),%r11
  661fda:	4e 8d 04 9a          	lea    (%rdx,%r11,4),%r8
  661fde:	48 89 fe             	mov    %rdi,%rsi
  661fe1:	48 83 ff 01          	cmp    $0x1,%rdi
  661fe5:	74 30                	je     662017 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x387>
  661fe7:	48 85 ff             	test   %rdi,%rdi
  661fea:	74 65                	je     662051 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3c1>
  661fec:	45 8b 10             	mov    (%r8),%r10d
  661fef:	4a 8d 14 9a          	lea    (%rdx,%r11,4),%rdx
  661ff3:	48 83 c2 0c          	add    $0xc,%rdx
  661ff7:	4d 29 ce             	sub    %r9,%r14
  661ffa:	49 ff c6             	inc    %r14
  661ffd:	be 01 00 00 00       	mov    $0x1,%esi
  662002:	44 3b 12             	cmp    (%rdx),%r10d
  662005:	75 10                	jne    662017 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x387>
  662007:	48 ff c6             	inc    %rsi
  66200a:	48 83 c2 0c          	add    $0xc,%rdx
  66200e:	49 ff ce             	dec    %r14
  662011:	49 83 fe 02          	cmp    $0x2,%r14
  662015:	77 eb                	ja     662002 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x372>
  662017:	48 29 f7             	sub    %rsi,%rdi
  66201a:	0f 82 e4 02 00 00    	jb     662304 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x674>
  662020:	48 8d 14 76          	lea    (%rsi,%rsi,2),%rdx
  662024:	49 8d 1c 90          	lea    (%r8,%rdx,4),%rbx
  662028:	49 89 fe             	mov    %rdi,%r14
  66202b:	4c 89 c2             	mov    %r8,%rdx
  66202e:	e9 03 fe ff ff       	jmp    661e36 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1a6>
  662033:	40 88 7c 24 07       	mov    %dil,0x7(%rsp)
  662038:	89 54 24 14          	mov    %edx,0x14(%rsp)
  66203c:	f3 0f 11 4c 24 10    	movss  %xmm1,0x10(%rsp)
  662042:	8b 44 24 08          	mov    0x8(%rsp),%eax
  662046:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  66204c:	e9 2c fd ff ff       	jmp    661d7d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xed>
  662051:	0f b6 4c 24 07       	movzbl 0x7(%rsp),%ecx
  662056:	80 f9 02             	cmp    $0x2,%cl
  662059:	75 51                	jne    6620ac <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x41c>
  66205b:	8b 54 24 08          	mov    0x8(%rsp),%edx
  66205f:	80 fa 02             	cmp    $0x2,%dl
  662062:	0f 85 f8 02 00 00    	jne    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  662068:	b2 02                	mov    $0x2,%dl
  66206a:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  66206f:	48 85 c0             	test   %rax,%rax
  662072:	0f 84 82 02 00 00    	je     6622fa <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x66a>
  662078:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  66207c:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
  662081:	48 8d 04 85 00 00 00 	lea    0x0(,%rax,4),%rax
  662088:	00 
  662089:	4c 01 e8             	add    %r13,%rax
  66208c:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  662091:	8b 49 04             	mov    0x4(%rcx),%ecx
  662094:	4c 8b 74 24 40       	mov    0x40(%rsp),%r14
  662099:	49 8d 56 ff          	lea    -0x1(%r14),%rdx
  66209d:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  6620a2:	4c 8b 64 24 38       	mov    0x38(%rsp),%r12
  6620a7:	e9 82 00 00 00       	jmp    66212e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x49e>
  6620ac:	8b 44 24 08          	mov    0x8(%rsp),%eax
  6620b0:	3c 02                	cmp    $0x2,%al
  6620b2:	75 0c                	jne    6620c0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x430>
  6620b4:	89 ca                	mov    %ecx,%edx
  6620b6:	44 8b 7c 24 14       	mov    0x14(%rsp),%r15d
  6620bb:	e9 a0 02 00 00       	jmp    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6620c0:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  6620c6:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  6620ca:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  6620d0:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  6620d4:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
  6620d8:	f2 0f 59 0d b0 25 9c 	mulsd  -0x63da50(%rip),%xmm1        # 24690 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x110>
  6620df:	ff 
  6620e0:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  6620e6:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  6620ea:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  6620ee:	44 0f 46 7c 24 14    	cmovbe 0x14(%rsp),%r15d
  6620f4:	0f b6 c0             	movzbl %al,%eax
  6620f7:	0f b6 d1             	movzbl %cl,%edx
  6620fa:	0f 47 d0             	cmova  %eax,%edx
  6620fd:	e9 5e 02 00 00       	jmp    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  662102:	31 f6                	xor    %esi,%esi
  662104:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  662108:	45 39 7c fc 04       	cmp    %r15d,0x4(%r12,%rdi,8)
  66210d:	48 83 d6 00          	adc    $0x0,%rsi
  662111:	48 39 f2             	cmp    %rsi,%rdx
  662114:	48 0f 42 f2          	cmovb  %rdx,%rsi
  662118:	48 39 de             	cmp    %rbx,%rsi
  66211b:	0f 84 00 02 00 00    	je     662321 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x691>
  662121:	49 83 c5 0c          	add    $0xc,%r13
  662125:	49 39 c5             	cmp    %rax,%r13
  662128:	0f 84 d2 01 00 00    	je     662300 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x670>
  66212e:	45 8b 7d 00          	mov    0x0(%r13),%r15d
  662132:	41 39 cf             	cmp    %ecx,%r15d
  662135:	0f 87 c1 01 00 00    	ja     6622fc <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x66c>
  66213b:	41 0f b6 75 08       	movzbl 0x8(%r13),%esi
  662140:	45 85 ff             	test   %r15d,%r15d
  662143:	74 2b                	je     662170 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x4e0>
  662145:	40 f6 c6 02          	test   $0x2,%sil
  662149:	0f 84 95 00 00 00    	je     6621e4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x554>
  66214f:	4d 89 f0             	mov    %r14,%r8
  662152:	4d 85 f6             	test   %r14,%r14
  662155:	0f 84 80 00 00 00    	je     6621db <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x54b>
  66215b:	49 83 fe 01          	cmp    $0x1,%r14
  66215f:	75 36                	jne    662197 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x507>
  662161:	31 ff                	xor    %edi,%edi
  662163:	eb 5c                	jmp    6621c1 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x531>
  662165:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  66216c:	00 00 00 00 
  662170:	40 f6 c6 02          	test   $0x2,%sil
  662174:	0f 84 0a 01 00 00    	je     662284 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5f4>
  66217a:	4d 89 f0             	mov    %r14,%r8
  66217d:	4d 85 f6             	test   %r14,%r14
  662180:	0f 84 f5 00 00 00    	je     66227b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5eb>
  662186:	49 83 fe 01          	cmp    $0x1,%r14
  66218a:	0f 85 a5 00 00 00    	jne    662235 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5a5>
  662190:	31 ff                	xor    %edi,%edi
  662192:	e9 c9 00 00 00       	jmp    662260 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5d0>
  662197:	4d 89 f0             	mov    %r14,%r8
  66219a:	31 ff                	xor    %edi,%edi
  66219c:	0f 1f 40 00          	nopl   0x0(%rax)
  6621a0:	49 89 f9             	mov    %rdi,%r9
  6621a3:	4d 89 c2             	mov    %r8,%r10
  6621a6:	49 d1 ea             	shr    $1,%r10
  6621a9:	4c 01 d7             	add    %r10,%rdi
  6621ac:	4c 8d 1c 7f          	lea    (%rdi,%rdi,2),%r11
  6621b0:	47 39 3c dc          	cmp    %r15d,(%r12,%r11,8)
  6621b4:	49 0f 47 f9          	cmova  %r9,%rdi
  6621b8:	4d 29 d0             	sub    %r10,%r8
  6621bb:	49 83 f8 01          	cmp    $0x1,%r8
  6621bf:	77 df                	ja     6621a0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x510>
  6621c1:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  6621c5:	45 31 c0             	xor    %r8d,%r8d
  6621c8:	47 39 3c cc          	cmp    %r15d,(%r12,%r9,8)
  6621cc:	41 0f 96 c0          	setbe  %r8b
  6621d0:	49 01 f8             	add    %rdi,%r8
  6621d3:	49 83 f8 01          	cmp    $0x1,%r8
  6621d7:	49 83 d0 ff          	adc    $0xffffffffffffffff,%r8
  6621db:	49 39 d8             	cmp    %rbx,%r8
  6621de:	0f 84 39 01 00 00    	je     66231d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x68d>
  6621e4:	40 f6 c6 01          	test   $0x1,%sil
  6621e8:	0f 84 33 ff ff ff    	je     662121 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x491>
  6621ee:	4c 89 f6             	mov    %r14,%rsi
  6621f1:	4d 85 f6             	test   %r14,%r14
  6621f4:	0f 84 1e ff ff ff    	je     662118 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x488>
  6621fa:	49 83 fe 01          	cmp    $0x1,%r14
  6621fe:	0f 84 fe fe ff ff    	je     662102 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x472>
  662204:	4c 89 f7             	mov    %r14,%rdi
  662207:	31 f6                	xor    %esi,%esi
  662209:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  662210:	49 89 f8             	mov    %rdi,%r8
  662213:	49 d1 e8             	shr    $1,%r8
  662216:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  66221a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  66221e:	47 39 7c d4 04       	cmp    %r15d,0x4(%r12,%r10,8)
  662223:	49 0f 42 f1          	cmovb  %r9,%rsi
  662227:	4c 29 c7             	sub    %r8,%rdi
  66222a:	48 83 ff 01          	cmp    $0x1,%rdi
  66222e:	77 e0                	ja     662210 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x580>
  662230:	e9 cf fe ff ff       	jmp    662104 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x474>
  662235:	4d 89 f0             	mov    %r14,%r8
  662238:	31 ff                	xor    %edi,%edi
  66223a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  662240:	4d 89 c1             	mov    %r8,%r9
  662243:	49 d1 e9             	shr    $1,%r9
  662246:	4d 8d 14 39          	lea    (%r9,%rdi,1),%r10
  66224a:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  66224e:	43 83 3c dc 00       	cmpl   $0x0,(%r12,%r11,8)
  662253:	49 0f 44 fa          	cmove  %r10,%rdi
  662257:	4d 29 c8             	sub    %r9,%r8
  66225a:	49 83 f8 01          	cmp    $0x1,%r8
  66225e:	77 e0                	ja     662240 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5b0>
  662260:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  662264:	45 31 c0             	xor    %r8d,%r8d
  662267:	43 83 3c cc 00       	cmpl   $0x0,(%r12,%r9,8)
  66226c:	41 0f 94 c0          	sete   %r8b
  662270:	49 01 f8             	add    %rdi,%r8
  662273:	49 83 f8 01          	cmp    $0x1,%r8
  662277:	49 83 d0 ff          	adc    $0xffffffffffffffff,%r8
  66227b:	49 39 d8             	cmp    %rbx,%r8
  66227e:	0f 84 a1 00 00 00    	je     662325 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x695>
  662284:	40 f6 c6 01          	test   $0x1,%sil
  662288:	0f 84 93 fe ff ff    	je     662121 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x491>
  66228e:	4c 89 f7             	mov    %r14,%rdi
  662291:	4d 85 f6             	test   %r14,%r14
  662294:	74 54                	je     6622ea <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x65a>
  662296:	49 83 fe 01          	cmp    $0x1,%r14
  66229a:	75 04                	jne    6622a0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x610>
  66229c:	31 f6                	xor    %esi,%esi
  66229e:	eb 30                	jmp    6622d0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x640>
  6622a0:	4c 89 f7             	mov    %r14,%rdi
  6622a3:	31 f6                	xor    %esi,%esi
  6622a5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6622ac:	00 00 00 00 
  6622b0:	49 89 f8             	mov    %rdi,%r8
  6622b3:	49 d1 e8             	shr    $1,%r8
  6622b6:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  6622ba:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  6622be:	43 83 3c d4 00       	cmpl   $0x0,(%r12,%r10,8)
  6622c3:	49 0f 44 f1          	cmove  %r9,%rsi
  6622c7:	4c 29 c7             	sub    %r8,%rdi
  6622ca:	48 83 ff 01          	cmp    $0x1,%rdi
  6622ce:	77 e0                	ja     6622b0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x620>
  6622d0:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  6622d4:	31 ff                	xor    %edi,%edi
  6622d6:	43 83 3c c4 00       	cmpl   $0x0,(%r12,%r8,8)
  6622db:	40 0f 94 c7          	sete   %dil
  6622df:	48 01 f7             	add    %rsi,%rdi
  6622e2:	48 83 ff 01          	cmp    $0x1,%rdi
  6622e6:	48 83 d7 ff          	adc    $0xffffffffffffffff,%rdi
  6622ea:	48 39 df             	cmp    %rbx,%rdi
  6622ed:	0f 85 2e fe ff ff    	jne    662121 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x491>
  6622f3:	31 d2                	xor    %edx,%edx
  6622f5:	45 31 ff             	xor    %r15d,%r15d
  6622f8:	eb 66                	jmp    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6622fa:	eb 64                	jmp    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  6622fc:	b2 02                	mov    $0x2,%dl
  6622fe:	eb 60                	jmp    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  662300:	b2 02                	mov    $0x2,%dl
  662302:	eb 5c                	jmp    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  662304:	48 8d 3d 56 34 9c ff 	lea    -0x63cbaa(%rip),%rdi        # 25761 <anon.510ecd5b06a31c5d706a3e62c051feab.3.llvm.15957366779061141188+0x9>
  66230b:	48 8d 15 46 a4 11 00 	lea    0x11a446(%rip),%rdx        # 77c758 <anon.0ce93d74e9d39703631c89632b12715b.3.llvm.7854699070981760621+0x78>
  662312:	be 13 00 00 00       	mov    $0x13,%esi
  662317:	ff 15 53 50 12 00    	call   *0x125053(%rip)        # 787370 <_DYNAMIC+0x250>
  66231d:	b2 01                	mov    $0x1,%dl
  66231f:	eb 3f                	jmp    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  662321:	31 d2                	xor    %edx,%edx
  662323:	eb 3b                	jmp    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  662325:	45 31 ff             	xor    %r15d,%r15d
  662328:	b2 01                	mov    $0x1,%dl
  66232a:	eb 34                	jmp    662360 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6d0>
  66232c:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  662330:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  662334:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
  662338:	f2 0f 59 0d 50 23 9c 	mulsd  -0x63dcb0(%rip),%xmm1        # 24690 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x110>
  66233f:	ff 
  662340:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  662346:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  66234a:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  66234e:	0f 47 ca             	cmova  %edx,%ecx
  662351:	40 0f b6 d7          	movzbl %dil,%edx
  662355:	0f b6 c0             	movzbl %al,%eax
  662358:	0f 47 c2             	cmova  %edx,%eax
  66235b:	89 c2                	mov    %eax,%edx
  66235d:	41 89 cf             	mov    %ecx,%r15d
  662360:	44 89 f8             	mov    %r15d,%eax
  662363:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  66236a:	5b                   	pop    %rbx
  66236b:	41 5c                	pop    %r12
  66236d:	41 5d                	pop    %r13
  66236f:	41 5e                	pop    %r14
  662371:	41 5f                	pop    %r15
  662373:	5d                   	pop    %rbp
  662374:	c3                   	ret
  662375:	48 8d 15 c4 a3 11 00 	lea    0x11a3c4(%rip),%rdx        # 77c740 <anon.0ce93d74e9d39703631c89632b12715b.3.llvm.7854699070981760621+0x60>
  66237c:	48 89 f7             	mov    %rsi,%rdi
  66237f:	48 89 de             	mov    %rbx,%rsi
  662382:	ff 15 38 51 12 00    	call   *0x125138(%rip)        # 7874c0 <_DYNAMIC+0x3a0>

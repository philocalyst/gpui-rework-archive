
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660c30 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>:
  660c30:	55                   	push   %rbp
  660c31:	41 57                	push   %r15
  660c33:	41 56                	push   %r14
  660c35:	41 55                	push   %r13
  660c37:	41 54                	push   %r12
  660c39:	53                   	push   %rbx
  660c3a:	48 83 ec 38          	sub    $0x38,%rsp
  660c3e:	48 8b 0a             	mov    (%rdx),%rcx
  660c41:	4c 8b 42 08          	mov    0x8(%rdx),%r8
  660c45:	48 8b 6a 10          	mov    0x10(%rdx),%rbp
  660c49:	48 8b 42 18          	mov    0x18(%rdx),%rax
  660c4d:	48 8b 16             	mov    (%rsi),%rdx
  660c50:	4c 8b 3a             	mov    (%rdx),%r15
  660c53:	f3 0f 10 42 08       	movss  0x8(%rdx),%xmm0
  660c58:	48 83 c1 f4          	add    $0xfffffffffffffff4,%rcx
  660c5c:	49 c1 e0 02          	shl    $0x2,%r8
  660c60:	4b 8d 14 40          	lea    (%r8,%r8,2),%rdx
  660c64:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  660c6b:	00 00 00 00 00 
  660c70:	48 85 d2             	test   %rdx,%rdx
  660c73:	0f 84 be 00 00 00    	je     660d37 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x107>
  660c79:	4c 8d 71 0c          	lea    0xc(%rcx),%r14
  660c7d:	48 83 c2 f4          	add    $0xfffffffffffffff4,%rdx
  660c81:	f6 41 14 02          	testb  $0x2,0x14(%rcx)
  660c85:	4c 89 f1             	mov    %r14,%rcx
  660c88:	74 e6                	je     660c70 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x40>
  660c8a:	48 c1 e0 02          	shl    $0x2,%rax
  660c8e:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  660c92:	31 c9                	xor    %ecx,%ecx
  660c94:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  660c9b:	00 00 00 00 00 
  660ca0:	48 39 c8             	cmp    %rcx,%rax
  660ca3:	0f 84 8e 00 00 00    	je     660d37 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x107>
  660ca9:	4c 8d 61 0c          	lea    0xc(%rcx),%r12
  660cad:	f6 44 0d 08 01       	testb  $0x1,0x8(%rbp,%rcx,1)
  660cb2:	4c 89 e1             	mov    %r12,%rcx
  660cb5:	74 e9                	je     660ca0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x70>
  660cb7:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  660cbc:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  660cc1:	41 8b 36             	mov    (%r14),%esi
  660cc4:	4c 89 ff             	mov    %r15,%rdi
  660cc7:	89 74 24 04          	mov    %esi,0x4(%rsp)
  660ccb:	ba 01 00 00 00       	mov    $0x1,%edx
  660cd0:	ff 15 da 67 12 00    	call   *0x1267da(%rip)        # 7874b0 <_DYNAMIC+0x390>
  660cd6:	48 89 c3             	mov    %rax,%rbx
  660cd9:	49 8b 77 28          	mov    0x28(%r15),%rsi
  660cdd:	48 39 f0             	cmp    %rsi,%rax
  660ce0:	0f 83 a7 01 00 00    	jae    660e8d <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x25d>
  660ce6:	46 8b 6c 25 f4       	mov    -0xc(%rbp,%r12,1),%r13d
  660ceb:	49 8b 47 20          	mov    0x20(%r15),%rax
  660cef:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
  660cf3:	8b 44 c8 04          	mov    0x4(%rax,%rcx,8),%eax
  660cf7:	89 04 24             	mov    %eax,(%rsp)
  660cfa:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  660cff:	4c 89 fe             	mov    %r15,%rsi
  660d02:	4c 89 f2             	mov    %r14,%rdx
  660d05:	ff 15 ad 67 12 00    	call   *0x1267ad(%rip)        # 7874b8 <_DYNAMIC+0x398>
  660d0b:	f3 41 0f 10 46 04    	movss  0x4(%r14),%xmm0
  660d11:	f3 42 0f 10 4c 25 f8 	movss  -0x8(%rbp,%r12,1),%xmm1
  660d18:	8b 2c 24             	mov    (%rsp),%ebp
  660d1b:	41 39 ed             	cmp    %ebp,%r13d
  660d1e:	77 20                	ja     660d40 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x110>
  660d20:	0f 2e c1             	ucomiss %xmm1,%xmm0
  660d23:	75 02                	jne    660d27 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0xf7>
  660d25:	7b 19                	jnp    660d40 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x110>
  660d27:	0f 2e c8             	ucomiss %xmm0,%xmm1
  660d2a:	0f 96 c0             	setbe  %al
  660d2d:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  660d32:	e9 b7 00 00 00       	jmp    660dee <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1be>
  660d37:	c6 47 04 02          	movb   $0x2,0x4(%rdi)
  660d3b:	e9 3b 01 00 00       	jmp    660e7b <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x24b>
  660d40:	49 8b 47 08          	mov    0x8(%r15),%rax
  660d44:	49 8b 4f 10          	mov    0x10(%r15),%rcx
  660d48:	48 89 ca             	mov    %rcx,%rdx
  660d4b:	48 85 c9             	test   %rcx,%rcx
  660d4e:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  660d53:	0f 28 6c 24 20       	movaps 0x20(%rsp),%xmm5
  660d58:	74 48                	je     660da2 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x172>
  660d5a:	31 d2                	xor    %edx,%edx
  660d5c:	48 83 f9 01          	cmp    $0x1,%rcx
  660d60:	74 31                	je     660d93 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x163>
  660d62:	48 89 ce             	mov    %rcx,%rsi
  660d65:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  660d6c:	00 00 00 00 
  660d70:	49 89 f0             	mov    %rsi,%r8
  660d73:	49 d1 e8             	shr    $1,%r8
  660d76:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  660d7a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  660d7e:	46 8b 54 d0 10       	mov    0x10(%rax,%r10,8),%r10d
  660d83:	4c 39 d3             	cmp    %r10,%rbx
  660d86:	49 0f 47 d1          	cmova  %r9,%rdx
  660d8a:	4c 29 c6             	sub    %r8,%rsi
  660d8d:	48 83 fe 01          	cmp    $0x1,%rsi
  660d91:	77 dd                	ja     660d70 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x140>
  660d93:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
  660d97:	8b 74 f0 10          	mov    0x10(%rax,%rsi,8),%esi
  660d9b:	48 39 de             	cmp    %rbx,%rsi
  660d9e:	48 83 d2 00          	adc    $0x0,%rdx
  660da2:	48 c1 e2 03          	shl    $0x3,%rdx
  660da6:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  660daa:	4c 8d 04 10          	lea    (%rax,%rdx,1),%r8
  660dae:	41 8b 36             	mov    (%r14),%esi
  660db1:	48 c1 e1 03          	shl    $0x3,%rcx
  660db5:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  660db9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  660dc0:	48 39 d1             	cmp    %rdx,%rcx
  660dc3:	74 5a                	je     660e1f <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1ef>
  660dc5:	4d 89 c1             	mov    %r8,%r9
  660dc8:	45 8b 40 10          	mov    0x10(%r8),%r8d
  660dcc:	4c 39 c3             	cmp    %r8,%rbx
  660dcf:	75 4e                	jne    660e1f <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1ef>
  660dd1:	4d 8d 41 18          	lea    0x18(%r9),%r8
  660dd5:	48 83 c2 18          	add    $0x18,%rdx
  660dd9:	41 39 31             	cmp    %esi,(%r9)
  660ddc:	77 e2                	ja     660dc0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x190>
  660dde:	41 3b 71 04          	cmp    0x4(%r9),%esi
  660de2:	77 dc                	ja     660dc0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x190>
  660de4:	0f b6 44 10 fd       	movzbl -0x3(%rax,%rdx,1),%eax
  660de9:	41 39 ed             	cmp    %ebp,%r13d
  660dec:	77 38                	ja     660e26 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1f6>
  660dee:	0f 28 d8             	movaps %xmm0,%xmm3
  660df1:	f3 0f 5d d9          	minss  %xmm1,%xmm3
  660df5:	0f 28 d3             	movaps %xmm3,%xmm2
  660df8:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  660dfd:	0f 28 e2             	movaps %xmm2,%xmm4
  660e00:	0f 55 e3             	andnps %xmm3,%xmm4
  660e03:	0f 54 d0             	andps  %xmm0,%xmm2
  660e06:	0f 56 d4             	orps   %xmm4,%xmm2
  660e09:	f3 0f 10 5c 24 14    	movss  0x14(%rsp),%xmm3
  660e0f:	0f 28 e9             	movaps %xmm1,%xmm5
  660e12:	f3 0f 5c e8          	subss  %xmm0,%xmm5
  660e16:	0f 54 2d 73 43 9c ff 	andps  -0x63bc8d(%rip),%xmm5        # 25190 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  660e1d:	eb 18                	jmp    660e37 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x207>
  660e1f:	31 c0                	xor    %eax,%eax
  660e21:	41 39 ed             	cmp    %ebp,%r13d
  660e24:	76 c8                	jbe    660dee <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1be>
  660e26:	0f 28 d0             	movaps %xmm0,%xmm2
  660e29:	84 c0                	test   %al,%al
  660e2b:	74 04                	je     660e31 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x201>
  660e2d:	f3 0f 5c d5          	subss  %xmm5,%xmm2
  660e31:	f3 0f 10 5c 24 14    	movss  0x14(%rsp),%xmm3
  660e37:	41 39 ed             	cmp    %ebp,%r13d
  660e3a:	f3 0f 10 64 24 1c    	movss  0x1c(%rsp),%xmm4
  660e40:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
  660e44:	89 0f                	mov    %ecx,(%rdi)
  660e46:	c6 47 04 01          	movb   $0x1,0x4(%rdi)
  660e4a:	44 89 6f 08          	mov    %r13d,0x8(%rdi)
  660e4e:	c6 47 0c 00          	movb   $0x0,0xc(%rdi)
  660e52:	f3 0f 11 57 10       	movss  %xmm2,0x10(%rdi)
  660e57:	f3 0f 11 5f 14       	movss  %xmm3,0x14(%rdi)
  660e5c:	f3 0f 11 6f 18       	movss  %xmm5,0x18(%rdi)
  660e61:	f3 0f 11 67 1c       	movss  %xmm4,0x1c(%rdi)
  660e66:	48 89 5f 20          	mov    %rbx,0x20(%rdi)
  660e6a:	f3 0f 11 47 28       	movss  %xmm0,0x28(%rdi)
  660e6f:	f3 0f 11 4f 2c       	movss  %xmm1,0x2c(%rdi)
  660e74:	0f 97 47 30          	seta   0x30(%rdi)
  660e78:	88 47 31             	mov    %al,0x31(%rdi)
  660e7b:	48 89 f8             	mov    %rdi,%rax
  660e7e:	48 83 c4 38          	add    $0x38,%rsp
  660e82:	5b                   	pop    %rbx
  660e83:	41 5c                	pop    %r12
  660e85:	41 5d                	pop    %r13
  660e87:	41 5e                	pop    %r14
  660e89:	41 5f                	pop    %r15
  660e8b:	5d                   	pop    %rbp
  660e8c:	c3                   	ret
  660e8d:	48 8d 15 1c b8 11 00 	lea    0x11b81c(%rip),%rdx        # 77c6b0 <anon.131d754ff6fdc2dfddc852c3e2010d7b.4.llvm.17478163706573382256+0x30>
  660e94:	48 89 df             	mov    %rbx,%rdi
  660e97:	ff 15 23 66 12 00    	call   *0x126623(%rip)        # 7874c0 <_DYNAMIC+0x3a0>

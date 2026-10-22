
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660c60 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>:
  660c60:	55                   	push   %rbp
  660c61:	41 57                	push   %r15
  660c63:	41 56                	push   %r14
  660c65:	41 55                	push   %r13
  660c67:	41 54                	push   %r12
  660c69:	53                   	push   %rbx
  660c6a:	48 83 ec 38          	sub    $0x38,%rsp
  660c6e:	4c 8b 22             	mov    (%rdx),%r12
  660c71:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  660c75:	4c 8b 7a 10          	mov    0x10(%rdx),%r15
  660c79:	48 8b 42 18          	mov    0x18(%rdx),%rax
  660c7d:	48 8b 16             	mov    (%rsi),%rdx
  660c80:	4c 8b 32             	mov    (%rdx),%r14
  660c83:	f3 0f 10 42 08       	movss  0x8(%rdx),%xmm0
  660c88:	48 c1 e1 02          	shl    $0x2,%rcx
  660c8c:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  660c90:	31 d2                	xor    %edx,%edx
  660c92:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660c99:	1f 84 00 00 00 00 00 
  660ca0:	48 39 d1             	cmp    %rdx,%rcx
  660ca3:	0f 84 ed 00 00 00    	je     660d96 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x136>
  660ca9:	4c 8d 6a 0c          	lea    0xc(%rdx),%r13
  660cad:	41 f6 44 14 08 02    	testb  $0x2,0x8(%r12,%rdx,1)
  660cb3:	4c 89 ea             	mov    %r13,%rdx
  660cb6:	74 e8                	je     660ca0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x40>
  660cb8:	48 c1 e0 02          	shl    $0x2,%rax
  660cbc:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  660cc0:	31 c9                	xor    %ecx,%ecx
  660cc2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660cc9:	1f 84 00 00 00 00 00 
  660cd0:	48 39 c8             	cmp    %rcx,%rax
  660cd3:	0f 84 bd 00 00 00    	je     660d96 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x136>
  660cd9:	48 8d 59 0c          	lea    0xc(%rcx),%rbx
  660cdd:	41 f6 44 0f 08 01    	testb  $0x1,0x8(%r15,%rcx,1)
  660ce3:	48 89 d9             	mov    %rbx,%rcx
  660ce6:	74 e8                	je     660cd0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x70>
  660ce8:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  660ced:	48 89 fd             	mov    %rdi,%rbp
  660cf0:	43 8b 74 2c f4       	mov    -0xc(%r12,%r13,1),%esi
  660cf5:	4c 89 f7             	mov    %r14,%rdi
  660cf8:	89 74 24 0c          	mov    %esi,0xc(%rsp)
  660cfc:	ba 01 00 00 00       	mov    $0x1,%edx
  660d01:	ff 15 a9 69 12 00    	call   *0x1269a9(%rip)        # 7876b0 <_DYNAMIC+0x390>
  660d07:	49 8b 76 28          	mov    0x28(%r14),%rsi
  660d0b:	48 39 f0             	cmp    %rsi,%rax
  660d0e:	0f 83 1e 02 00 00    	jae    660f32 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x2d2>
  660d14:	45 8b 4c 1f f4       	mov    -0xc(%r15,%rbx,1),%r9d
  660d19:	49 8b 4e 20          	mov    0x20(%r14),%rcx
  660d1d:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  660d21:	44 8b 54 d1 04       	mov    0x4(%rcx,%rdx,8),%r10d
  660d26:	48 85 c0             	test   %rax,%rax
  660d29:	48 89 ef             	mov    %rbp,%rdi
  660d2c:	0f 28 6c 24 20       	movaps 0x20(%rsp),%xmm5
  660d31:	74 6c                	je     660d9f <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x13f>
  660d33:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%rsp)
  660d38:	74 65                	je     660d9f <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x13f>
  660d3a:	47 0f b6 44 2c fc    	movzbl -0x4(%r12,%r13,1),%r8d
  660d40:	41 80 e0 01          	and    $0x1,%r8b
  660d44:	74 59                	je     660d9f <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x13f>
  660d46:	48 8d 14 d1          	lea    (%rcx,%rdx,8),%rdx
  660d4a:	48 89 c1             	mov    %rax,%rcx
  660d4d:	44 8b 44 24 0c       	mov    0xc(%rsp),%r8d
  660d52:	44 39 42 ec          	cmp    %r8d,-0x14(%rdx)
  660d56:	75 4a                	jne    660da2 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x142>
  660d58:	4c 89 f7             	mov    %r14,%rdi
  660d5b:	8b 74 24 0c          	mov    0xc(%rsp),%esi
  660d5f:	31 d2                	xor    %edx,%edx
  660d61:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  660d66:	44 89 4c 24 14       	mov    %r9d,0x14(%rsp)
  660d6b:	44 89 54 24 10       	mov    %r10d,0x10(%rsp)
  660d70:	ff 15 3a 69 12 00    	call   *0x12693a(%rip)        # 7876b0 <_DYNAMIC+0x390>
  660d76:	44 8b 54 24 10       	mov    0x10(%rsp),%r10d
  660d7b:	44 8b 4c 24 14       	mov    0x14(%rsp),%r9d
  660d80:	0f 28 6c 24 20       	movaps 0x20(%rsp),%xmm5
  660d85:	48 89 ef             	mov    %rbp,%rdi
  660d88:	48 89 c1             	mov    %rax,%rcx
  660d8b:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  660d90:	49 8b 76 28          	mov    0x28(%r14),%rsi
  660d94:	eb 0c                	jmp    660da2 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x142>
  660d96:	c6 47 04 02          	movb   $0x2,0x4(%rdi)
  660d9a:	e9 63 01 00 00       	jmp    660f02 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x2a2>
  660d9f:	48 89 c1             	mov    %rax,%rcx
  660da2:	48 39 f1             	cmp    %rsi,%rcx
  660da5:	0f 83 97 01 00 00    	jae    660f42 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x2e2>
  660dab:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  660daf:	48 c1 e1 03          	shl    $0x3,%rcx
  660db3:	49 03 4e 20          	add    0x20(%r14),%rcx
  660db7:	f3 43 0f 10 44 2c f8 	movss  -0x8(%r12,%r13,1),%xmm0
  660dbe:	f3 41 0f 10 4c 1f f8 	movss  -0x8(%r15,%rbx,1),%xmm1
  660dc5:	45 39 d1             	cmp    %r10d,%r9d
  660dc8:	77 12                	ja     660ddc <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x17c>
  660dca:	0f 2e c1             	ucomiss %xmm1,%xmm0
  660dcd:	75 02                	jne    660dd1 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x171>
  660dcf:	7b 0b                	jnp    660ddc <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x17c>
  660dd1:	0f 2e c8             	ucomiss %xmm0,%xmm1
  660dd4:	0f 96 c2             	setbe  %dl
  660dd7:	e9 b5 00 00 00       	jmp    660e91 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x231>
  660ddc:	45 89 d7             	mov    %r10d,%r15d
  660ddf:	44 89 cd             	mov    %r9d,%ebp
  660de2:	49 8b 56 08          	mov    0x8(%r14),%rdx
  660de6:	49 8b 76 10          	mov    0x10(%r14),%rsi
  660dea:	49 89 f0             	mov    %rsi,%r8
  660ded:	48 85 f6             	test   %rsi,%rsi
  660df0:	74 40                	je     660e32 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1d2>
  660df2:	45 31 c0             	xor    %r8d,%r8d
  660df5:	48 83 fe 01          	cmp    $0x1,%rsi
  660df9:	74 27                	je     660e22 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1c2>
  660dfb:	49 89 f1             	mov    %rsi,%r9
  660dfe:	66 90                	xchg   %ax,%ax
  660e00:	4d 89 ca             	mov    %r9,%r10
  660e03:	49 d1 ea             	shr    $1,%r10
  660e06:	4f 8d 1c 02          	lea    (%r10,%r8,1),%r11
  660e0a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  660e0e:	8b 5c da 10          	mov    0x10(%rdx,%rbx,8),%ebx
  660e12:	48 39 d8             	cmp    %rbx,%rax
  660e15:	4d 0f 47 c3          	cmova  %r11,%r8
  660e19:	4d 29 d1             	sub    %r10,%r9
  660e1c:	49 83 f9 01          	cmp    $0x1,%r9
  660e20:	77 de                	ja     660e00 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1a0>
  660e22:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
  660e26:	46 8b 4c ca 10       	mov    0x10(%rdx,%r9,8),%r9d
  660e2b:	49 39 c1             	cmp    %rax,%r9
  660e2e:	49 83 d0 00          	adc    $0x0,%r8
  660e32:	49 c1 e0 03          	shl    $0x3,%r8
  660e36:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
  660e3a:	4e 8d 14 02          	lea    (%rdx,%r8,1),%r10
  660e3e:	47 8b 4c 2c f4       	mov    -0xc(%r12,%r13,1),%r9d
  660e43:	48 c1 e6 03          	shl    $0x3,%rsi
  660e47:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  660e4b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  660e50:	4c 39 c6             	cmp    %r8,%rsi
  660e53:	0f 84 bb 00 00 00    	je     660f14 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x2b4>
  660e59:	4d 89 d3             	mov    %r10,%r11
  660e5c:	45 8b 52 10          	mov    0x10(%r10),%r10d
  660e60:	4c 39 d0             	cmp    %r10,%rax
  660e63:	0f 85 ab 00 00 00    	jne    660f14 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x2b4>
  660e69:	4d 8d 53 18          	lea    0x18(%r11),%r10
  660e6d:	49 83 c0 18          	add    $0x18,%r8
  660e71:	45 39 0b             	cmp    %r9d,(%r11)
  660e74:	77 da                	ja     660e50 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1f0>
  660e76:	45 3b 4b 04          	cmp    0x4(%r11),%r9d
  660e7a:	77 d4                	ja     660e50 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1f0>
  660e7c:	42 0f b6 54 02 fd    	movzbl -0x3(%rdx,%r8,1),%edx
  660e82:	41 89 e9             	mov    %ebp,%r9d
  660e85:	45 89 fa             	mov    %r15d,%r10d
  660e88:	44 39 fd             	cmp    %r15d,%ebp
  660e8b:	0f 87 94 00 00 00    	ja     660f25 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x2c5>
  660e91:	0f 28 d8             	movaps %xmm0,%xmm3
  660e94:	f3 0f 5d d9          	minss  %xmm1,%xmm3
  660e98:	0f 28 d3             	movaps %xmm3,%xmm2
  660e9b:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  660ea0:	0f 28 e2             	movaps %xmm2,%xmm4
  660ea3:	0f 55 e3             	andnps %xmm3,%xmm4
  660ea6:	0f 54 d0             	andps  %xmm0,%xmm2
  660ea9:	0f 56 d4             	orps   %xmm4,%xmm2
  660eac:	0f 28 e9             	movaps %xmm1,%xmm5
  660eaf:	f3 0f 5c e8          	subss  %xmm0,%xmm5
  660eb3:	0f 54 2d 06 43 9c ff 	andps  -0x63bcfa(%rip),%xmm5        # 251c0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  660eba:	45 39 d1             	cmp    %r10d,%r9d
  660ebd:	f3 0f 10 59 08       	movss  0x8(%rcx),%xmm3
  660ec2:	f3 0f 10 61 0c       	movss  0xc(%rcx),%xmm4
  660ec7:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  660ecb:	89 0f                	mov    %ecx,(%rdi)
  660ecd:	c6 47 04 01          	movb   $0x1,0x4(%rdi)
  660ed1:	44 89 4f 08          	mov    %r9d,0x8(%rdi)
  660ed5:	c6 47 0c 00          	movb   $0x0,0xc(%rdi)
  660ed9:	f3 0f 11 57 10       	movss  %xmm2,0x10(%rdi)
  660ede:	f3 0f 11 5f 14       	movss  %xmm3,0x14(%rdi)
  660ee3:	f3 0f 11 6f 18       	movss  %xmm5,0x18(%rdi)
  660ee8:	f3 0f 11 67 1c       	movss  %xmm4,0x1c(%rdi)
  660eed:	48 89 47 20          	mov    %rax,0x20(%rdi)
  660ef1:	f3 0f 11 47 28       	movss  %xmm0,0x28(%rdi)
  660ef6:	f3 0f 11 4f 2c       	movss  %xmm1,0x2c(%rdi)
  660efb:	0f 97 47 30          	seta   0x30(%rdi)
  660eff:	88 57 31             	mov    %dl,0x31(%rdi)
  660f02:	48 89 f8             	mov    %rdi,%rax
  660f05:	48 83 c4 38          	add    $0x38,%rsp
  660f09:	5b                   	pop    %rbx
  660f0a:	41 5c                	pop    %r12
  660f0c:	41 5d                	pop    %r13
  660f0e:	41 5e                	pop    %r14
  660f10:	41 5f                	pop    %r15
  660f12:	5d                   	pop    %rbp
  660f13:	c3                   	ret
  660f14:	31 d2                	xor    %edx,%edx
  660f16:	41 89 e9             	mov    %ebp,%r9d
  660f19:	45 89 fa             	mov    %r15d,%r10d
  660f1c:	44 39 fd             	cmp    %r15d,%ebp
  660f1f:	0f 86 6c ff ff ff    	jbe    660e91 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x231>
  660f25:	0f 28 d0             	movaps %xmm0,%xmm2
  660f28:	84 d2                	test   %dl,%dl
  660f2a:	74 8e                	je     660eba <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x25a>
  660f2c:	f3 0f 5c d5          	subss  %xmm5,%xmm2
  660f30:	eb 88                	jmp    660eba <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x25a>
  660f32:	48 8d 15 47 b9 11 00 	lea    0x11b947(%rip),%rdx        # 77c880 <anon.131d754ff6fdc2dfddc852c3e2010d7b.4.llvm.17478163706573382256+0x30>
  660f39:	48 89 c7             	mov    %rax,%rdi
  660f3c:	ff 15 76 67 12 00    	call   *0x126776(%rip)        # 7876b8 <_DYNAMIC+0x398>
  660f42:	48 8d 15 4f b9 11 00 	lea    0x11b94f(%rip),%rdx        # 77c898 <anon.131d754ff6fdc2dfddc852c3e2010d7b.4.llvm.17478163706573382256+0x48>
  660f49:	48 89 cf             	mov    %rcx,%rdi
  660f4c:	ff 15 66 67 12 00    	call   *0x126766(%rip)        # 7876b8 <_DYNAMIC+0x398>

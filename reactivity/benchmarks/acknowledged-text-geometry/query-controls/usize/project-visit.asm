
/tmp/gpui-ack-query-comparison/usize/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a60ca0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>>:
  a60ca0:	55                   	push   %rbp
  a60ca1:	41 57                	push   %r15
  a60ca3:	41 56                	push   %r14
  a60ca5:	41 55                	push   %r13
  a60ca7:	41 54                	push   %r12
  a60ca9:	53                   	push   %rbx
  a60caa:	48 81 ec 58 01 00 00 	sub    $0x158,%rsp
  a60cb1:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  a60cb6:	48 8b 5f 38          	mov    0x38(%rdi),%rbx
  a60cba:	48 85 db             	test   %rbx,%rbx
  a60cbd:	0f 84 6f 03 00 00    	je     a61032 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x392>
  a60cc3:	4c 8b 3e             	mov    (%rsi),%r15
  a60cc6:	48 8b 46 08          	mov    0x8(%rsi),%rax
  a60cca:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  a60ccf:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  a60cd4:	48 8b 68 28          	mov    0x28(%rax),%rbp
  a60cd8:	4c 8b 68 30          	mov    0x30(%rax),%r13
  a60cdc:	4c 8b 66 10          	mov    0x10(%rsi),%r12
  a60ce0:	48 8b 48 50          	mov    0x50(%rax),%rcx
  a60ce4:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  a60ce9:	48 8b 40 58          	mov    0x58(%rax),%rax
  a60ced:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  a60cf2:	48 8b 46 18          	mov    0x18(%rsi),%rax
  a60cf6:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  a60cfb:	45 31 c0             	xor    %r8d,%r8d
  a60cfe:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
  a60d03:	4c 89 24 24          	mov    %r12,(%rsp)
  a60d07:	eb 48                	jmp    a60d51 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xb1>
  a60d09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  a60d10:	4c 89 f0             	mov    %r14,%rax
  a60d13:	48 c1 e0 07          	shl    $0x7,%rax
  a60d17:	4a 8d 3c f0          	lea    (%rax,%r14,8),%rdi
  a60d1b:	49 03 7c 24 08       	add    0x8(%r12),%rdi
  a60d20:	ba 88 00 00 00       	mov    $0x88,%edx
  a60d25:	48 8d b4 24 d0 00 00 	lea    0xd0(%rsp),%rsi
  a60d2c:	00 
  a60d2d:	ff 15 4d ec ac 00    	call   *0xacec4d(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a60d33:	49 ff c6             	inc    %r14
  a60d36:	4d 89 74 24 10       	mov    %r14,0x10(%r12)
  a60d3b:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
  a60d40:	49 ff c0             	inc    %r8
  a60d43:	49 39 d8             	cmp    %rbx,%r8
  a60d46:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
  a60d4b:	0f 84 e1 02 00 00    	je     a61032 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x392>
  a60d51:	49 8b 47 10          	mov    0x10(%r15),%rax
  a60d55:	4f 8d 24 80          	lea    (%r8,%r8,4),%r12
  a60d59:	49 c1 e4 04          	shl    $0x4,%r12
  a60d5d:	4d 01 ec             	add    %r13,%r12
  a60d60:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
  a60d65:	eb 10                	jmp    a60d77 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xd7>
  a60d67:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  a60d6e:	00 00 
  a60d70:	48 ff c8             	dec    %rax
  a60d73:	49 89 47 10          	mov    %rax,0x10(%r15)
  a60d77:	48 85 c0             	test   %rax,%rax
  a60d7a:	74 54                	je     a60dd0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x130>
  a60d7c:	41 8b 7c 24 48       	mov    0x48(%r12),%edi
  a60d81:	81 e7 ff ff 01 00    	and    $0x1ffff,%edi
  a60d87:	48 81 ff ff ff 01 00 	cmp    $0x1ffff,%rdi
  a60d8e:	74 e0                	je     a60d70 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xd0>
  a60d90:	48 39 fb             	cmp    %rdi,%rbx
  a60d93:	0f 86 df 02 00 00    	jbe    a61078 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3d8>
  a60d99:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  a60d9d:	c1 e1 04             	shl    $0x4,%ecx
  a60da0:	49 8b 74 0d 20       	mov    0x20(%r13,%rcx,1),%rsi
  a60da5:	48 85 f6             	test   %rsi,%rsi
  a60da8:	0f 84 96 02 00 00    	je     a61044 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3a4>
  a60dae:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  a60db2:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  a60db6:	48 39 74 d1 f0       	cmp    %rsi,-0x10(%rcx,%rdx,8)
  a60dbb:	75 b3                	jne    a60d70 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xd0>
  a60dbd:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  a60dc1:	48 39 74 d1 e8       	cmp    %rsi,-0x18(%rcx,%rdx,8)
  a60dc6:	75 a8                	jne    a60d70 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xd0>
  a60dc8:	eb 56                	jmp    a60e20 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x180>
  a60dca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  a60dd0:	41 8b 7c 24 48       	mov    0x48(%r12),%edi
  a60dd5:	81 e7 ff ff 01 00    	and    $0x1ffff,%edi
  a60ddb:	48 81 ff ff ff 01 00 	cmp    $0x1ffff,%rdi
  a60de2:	74 2c                	je     a60e10 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x170>
  a60de4:	48 39 fb             	cmp    %rdi,%rbx
  a60de7:	0f 86 8b 02 00 00    	jbe    a61078 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3d8>
  a60ded:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  a60df1:	c1 e0 04             	shl    $0x4,%eax
  a60df4:	49 83 7c 05 20 00    	cmpq   $0x0,0x20(%r13,%rax,1)
  a60dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  a60dff:	0f 85 72 ff ff ff    	jne    a60d77 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xd7>
  a60e05:	e9 3a 02 00 00       	jmp    a61044 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3a4>
  a60e0a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  a60e10:	31 ff                	xor    %edi,%edi
  a60e12:	eb 14                	jmp    a60e28 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x188>
  a60e14:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a60e1b:	00 00 00 00 00 
  a60e20:	48 8d 04 d1          	lea    (%rcx,%rdx,8),%rax
  a60e24:	48 8b 78 f8          	mov    -0x8(%rax),%rdi
  a60e28:	4d 8b 74 24 20       	mov    0x20(%r12),%r14
  a60e2d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  a60e32:	48 8b 48 10          	mov    0x10(%rax),%rcx
  a60e36:	48 85 c9             	test   %rcx,%rcx
  a60e39:	74 75                	je     a60eb0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x210>
  a60e3b:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  a60e40:	48 8b 40 08          	mov    0x8(%rax),%rax
  a60e44:	48 83 f9 01          	cmp    $0x1,%rcx
  a60e48:	75 16                	jne    a60e60 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x1c0>
  a60e4a:	4c 39 70 08          	cmp    %r14,0x8(%rax)
  a60e4e:	74 50                	je     a60ea0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x200>
  a60e50:	eb 5e                	jmp    a60eb0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x210>
  a60e52:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a60e59:	1f 84 00 00 00 00 00 
  a60e60:	31 d2                	xor    %edx,%edx
  a60e62:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a60e69:	1f 84 00 00 00 00 00 
  a60e70:	48 89 d6             	mov    %rdx,%rsi
  a60e73:	49 89 c8             	mov    %rcx,%r8
  a60e76:	49 d1 e8             	shr    $1,%r8
  a60e79:	4c 01 c2             	add    %r8,%rdx
  a60e7c:	4c 6b ca 38          	imul   $0x38,%rdx,%r9
  a60e80:	4e 39 74 08 08       	cmp    %r14,0x8(%rax,%r9,1)
  a60e85:	48 0f 47 d6          	cmova  %rsi,%rdx
  a60e89:	4c 29 c1             	sub    %r8,%rcx
  a60e8c:	48 83 f9 01          	cmp    $0x1,%rcx
  a60e90:	77 de                	ja     a60e70 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x1d0>
  a60e92:	48 6b ca 38          	imul   $0x38,%rdx,%rcx
  a60e96:	4c 39 74 08 08       	cmp    %r14,0x8(%rax,%rcx,1)
  a60e9b:	75 13                	jne    a60eb0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x210>
  a60e9d:	48 01 c8             	add    %rcx,%rax
  a60ea0:	48 8b 40 20          	mov    0x20(%rax),%rax
  a60ea4:	4d 01 f6             	add    %r14,%r14
  a60ea7:	48 85 c0             	test   %rax,%rax
  a60eaa:	4c 0f 45 f0          	cmovne %rax,%r14
  a60eae:	eb 03                	jmp    a60eb3 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x213>
  a60eb0:	4d 01 f6             	add    %r14,%r14
  a60eb3:	48 8b 04 24          	mov    (%rsp),%rax
  a60eb7:	48 8b 70 10          	mov    0x10(%rax),%rsi
  a60ebb:	48 39 f7             	cmp    %rsi,%rdi
  a60ebe:	0f 83 c4 01 00 00    	jae    a61088 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3e8>
  a60ec4:	48 8b 40 08          	mov    0x8(%rax),%rax
  a60ec8:	48 89 f9             	mov    %rdi,%rcx
  a60ecb:	48 c1 e1 07          	shl    $0x7,%rcx
  a60ecf:	48 8d 0c f9          	lea    (%rcx,%rdi,8),%rcx
  a60ed3:	48 8d 3c 08          	lea    (%rax,%rcx,1),%rdi
  a60ed7:	48 83 c7 08          	add    $0x8,%rdi
  a60edb:	31 f6                	xor    %esi,%esi
  a60edd:	4c 89 f2             	mov    %r14,%rdx
  a60ee0:	ff 15 ba fe ac 00    	call   *0xacfeba(%rip)        # 1530da0 <_DYNAMIC+0x1680>
  a60ee6:	49 8b 44 24 20       	mov    0x20(%r12),%rax
  a60eeb:	48 85 c0             	test   %rax,%rax
  a60eee:	0f 84 50 01 00 00    	je     a61044 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3a4>
  a60ef4:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  a60ef9:	48 3b 4d 00          	cmp    0x0(%rbp),%rcx
  a60efd:	75 0f                	jne    a60f0e <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x26e>
  a60eff:	48 39 44 24 30       	cmp    %rax,0x30(%rsp)
  a60f04:	75 08                	jne    a60f0e <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x26e>
  a60f06:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a60f0b:	4c 89 30             	mov    %r14,(%rax)
  a60f0e:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  a60f13:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  a60f18:	48 8b 6c 24 20       	mov    0x20(%rsp),%rbp
  a60f1d:	48 89 ea             	mov    %rbp,%rdx
  a60f20:	e8 6b 7b 00 00       	call   a68a90 <gpui::native::accessibility::projected_node>
  a60f25:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  a60f2a:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  a60f2f:	48 89 ea             	mov    %rbp,%rdx
  a60f32:	48 8d 4c 24 50       	lea    0x50(%rsp),%rcx
  a60f37:	4c 8b 04 24          	mov    (%rsp),%r8
  a60f3b:	45 31 c9             	xor    %r9d,%r9d
  a60f3e:	e8 3d c7 ff ff       	call   a5d680 <<gpui::native::accessibility::text::Cohort>::append>
  a60f43:	4d 8b 64 24 20       	mov    0x20(%r12),%r12
  a60f48:	4d 85 e4             	test   %r12,%r12
  a60f4b:	0f 84 0c 01 00 00    	je     a6105d <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3bd>
  a60f51:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  a60f56:	48 8b 00             	mov    (%rax),%rax
  a60f59:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  a60f5e:	48 8b 04 24          	mov    (%rsp),%rax
  a60f62:	48 8b 40 10          	mov    0x10(%rax),%rax
  a60f66:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  a60f6b:	49 8b 6f 10          	mov    0x10(%r15),%rbp
  a60f6f:	49 3b 2f             	cmp    (%r15),%rbp
  a60f72:	75 09                	jne    a60f7d <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x2dd>
  a60f74:	4c 89 ff             	mov    %r15,%rdi
  a60f77:	ff 15 6b fe ac 00    	call   *0xacfe6b(%rip)        # 1530de8 <_DYNAMIC+0x16c8>
  a60f7d:	49 8b 47 08          	mov    0x8(%r15),%rax
  a60f81:	48 8d 0c 6d 00 00 00 	lea    0x0(,%rbp,2),%rcx
  a60f88:	00 
  a60f89:	48 01 e9             	add    %rbp,%rcx
  a60f8c:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  a60f91:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
  a60f95:	4c 89 64 c8 08       	mov    %r12,0x8(%rax,%rcx,8)
  a60f9a:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a60f9f:	48 89 54 c8 10       	mov    %rdx,0x10(%rax,%rcx,8)
  a60fa4:	48 ff c5             	inc    %rbp
  a60fa7:	49 89 6f 10          	mov    %rbp,0x10(%r15)
  a60fab:	0f 10 84 24 c0 00 00 	movups 0xc0(%rsp),%xmm0
  a60fb2:	00 
  a60fb3:	48 8d 84 24 d8 00 00 	lea    0xd8(%rsp),%rax
  a60fba:	00 
  a60fbb:	0f 11 40 70          	movups %xmm0,0x70(%rax)
  a60fbf:	0f 10 84 24 b0 00 00 	movups 0xb0(%rsp),%xmm0
  a60fc6:	00 
  a60fc7:	0f 11 40 60          	movups %xmm0,0x60(%rax)
  a60fcb:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  a60fd2:	00 
  a60fd3:	0f 11 40 50          	movups %xmm0,0x50(%rax)
  a60fd7:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  a60fde:	00 
  a60fdf:	0f 11 40 40          	movups %xmm0,0x40(%rax)
  a60fe3:	0f 10 44 24 50       	movups 0x50(%rsp),%xmm0
  a60fe8:	0f 10 4c 24 60       	movups 0x60(%rsp),%xmm1
  a60fed:	0f 10 54 24 70       	movups 0x70(%rsp),%xmm2
  a60ff2:	0f 10 9c 24 80 00 00 	movups 0x80(%rsp),%xmm3
  a60ff9:	00 
  a60ffa:	0f 11 58 30          	movups %xmm3,0x30(%rax)
  a60ffe:	0f 11 50 20          	movups %xmm2,0x20(%rax)
  a61002:	0f 11 48 10          	movups %xmm1,0x10(%rax)
  a61006:	0f 11 00             	movups %xmm0,(%rax)
  a61009:	4c 89 b4 24 d0 00 00 	mov    %r14,0xd0(%rsp)
  a61010:	00 
  a61011:	4c 8b 24 24          	mov    (%rsp),%r12
  a61015:	4d 8b 74 24 10       	mov    0x10(%r12),%r14
  a6101a:	4d 3b 34 24          	cmp    (%r12),%r14
  a6101e:	0f 85 ec fc ff ff    	jne    a60d10 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x70>
  a61024:	4c 89 e7             	mov    %r12,%rdi
  a61027:	ff 15 93 fd ac 00    	call   *0xacfd93(%rip)        # 1530dc0 <_DYNAMIC+0x16a0>
  a6102d:	e9 de fc ff ff       	jmp    a60d10 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x70>
  a61032:	48 81 c4 58 01 00 00 	add    $0x158,%rsp
  a61039:	5b                   	pop    %rbx
  a6103a:	41 5c                	pop    %r12
  a6103c:	41 5d                	pop    %r13
  a6103e:	41 5e                	pop    %r14
  a61040:	41 5f                	pop    %r15
  a61042:	5d                   	pop    %rbp
  a61043:	c3                   	ret
  a61044:	48 8d 3d 95 94 72 ff 	lea    -0x8d6b6b(%rip),%rdi        # 18a4e0 <anon.3619ef3883629585de0d6acaf5c725d7.55.llvm.10332671355869831320>
  a6104b:	48 8d 15 f6 06 a6 00 	lea    0xa606f6(%rip),%rdx        # 14c1748 <anon.3619ef3883629585de0d6acaf5c725d7.56.llvm.10332671355869831320>
  a61052:	be 20 00 00 00       	mov    $0x20,%esi
  a61057:	ff 15 3b ea ac 00    	call   *0xacea3b(%rip)        # 152fa98 <_DYNAMIC+0x378>
  a6105d:	48 8d 3d 7c 94 72 ff 	lea    -0x8d6b84(%rip),%rdi        # 18a4e0 <anon.3619ef3883629585de0d6acaf5c725d7.55.llvm.10332671355869831320>
  a61064:	48 8d 15 dd 06 a6 00 	lea    0xa606dd(%rip),%rdx        # 14c1748 <anon.3619ef3883629585de0d6acaf5c725d7.56.llvm.10332671355869831320>
  a6106b:	be 20 00 00 00       	mov    $0x20,%esi
  a61070:	ff 15 22 ea ac 00    	call   *0xacea22(%rip)        # 152fa98 <_DYNAMIC+0x378>
  a61076:	0f 0b                	ud2
  a61078:	48 8d 15 01 07 a6 00 	lea    0xa60701(%rip),%rdx        # 14c1780 <anon.3619ef3883629585de0d6acaf5c725d7.56.llvm.10332671355869831320+0x38>
  a6107f:	48 89 de             	mov    %rbx,%rsi
  a61082:	ff 15 c8 e9 ac 00    	call   *0xace9c8(%rip)        # 152fa50 <_DYNAMIC+0x330>
  a61088:	48 8d 15 71 06 a6 00 	lea    0xa60671(%rip),%rdx        # 14c1700 <anon.3619ef3883629585de0d6acaf5c725d7.22.llvm.10332671355869831320+0x18>
  a6108f:	ff 15 bb e9 ac 00    	call   *0xace9bb(%rip)        # 152fa50 <_DYNAMIC+0x330>
  a61095:	48 89 c3             	mov    %rax,%rbx
  a61098:	48 8d bc 24 d0 00 00 	lea    0xd0(%rsp),%rdi
  a6109f:	00 
  a610a0:	e8 3b 04 00 00       	call   a614e0 <core::ptr::drop_glue::<(accesskit::NodeId, accesskit::Node)>>
  a610a5:	eb 15                	jmp    a610bc <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x41c>
  a610a7:	ff 15 fb e8 ac 00    	call   *0xace8fb(%rip)        # 152f9a8 <_DYNAMIC+0x288>
  a610ad:	eb 00                	jmp    a610af <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x40f>
  a610af:	48 89 c3             	mov    %rax,%rbx
  a610b2:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  a610b7:	e8 a4 02 00 00       	call   a61360 <core::ptr::drop_glue::<accesskit::Node>>
  a610bc:	48 89 df             	mov    %rbx,%rdi
  a610bf:	e8 ac 91 a5 00       	call   14ba270 <_Unwind_Resume@plt>
  a610c4:	ff 15 de e8 ac 00    	call   *0xace8de(%rip)        # 152f9a8 <_DYNAMIC+0x288>

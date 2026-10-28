
/tmp/gpui-caret-transaction-bin/matched-indexed-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007e9d10 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at>:
  7e9d10:	55                   	push   %rbp
  7e9d11:	41 57                	push   %r15
  7e9d13:	41 56                	push   %r14
  7e9d15:	41 55                	push   %r13
  7e9d17:	41 54                	push   %r12
  7e9d19:	53                   	push   %rbx
  7e9d1a:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  7e9d21:	48 89 fb             	mov    %rdi,%rbx
  7e9d24:	f3 0f 11 44 24 14    	movss  %xmm0,0x14(%rsp)
  7e9d2a:	48 85 d2             	test   %rdx,%rdx
  7e9d2d:	0f 84 97 01 00 00    	je     7e9eca <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  7e9d33:	48 8b 46 28          	mov    0x28(%rsi),%rax
  7e9d37:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  7e9d3b:	48 39 c1             	cmp    %rax,%rcx
  7e9d3e:	0f 83 86 01 00 00    	jae    7e9eca <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  7e9d44:	48 39 c2             	cmp    %rax,%rdx
  7e9d47:	0f 83 7d 01 00 00    	jae    7e9eca <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  7e9d4d:	48 8b 46 20          	mov    0x20(%rsi),%rax
  7e9d51:	44 8b 6c 90 fc       	mov    -0x4(%rax,%rdx,4),%r13d
  7e9d56:	48 8b 4e 10          	mov    0x10(%rsi),%rcx
  7e9d5a:	4c 39 e9             	cmp    %r13,%rcx
  7e9d5d:	0f 86 67 01 00 00    	jbe    7e9eca <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  7e9d63:	8b 2c 90             	mov    (%rax,%rdx,4),%ebp
  7e9d66:	48 39 e9             	cmp    %rbp,%rcx
  7e9d69:	0f 86 5b 01 00 00    	jbe    7e9eca <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  7e9d6f:	4c 8b 7e 08          	mov    0x8(%rsi),%r15
  7e9d73:	4d 89 ec             	mov    %r13,%r12
  7e9d76:	49 c1 e4 04          	shl    $0x4,%r12
  7e9d7a:	4d 01 fc             	add    %r15,%r12
  7e9d7d:	48 89 e8             	mov    %rbp,%rax
  7e9d80:	48 c1 e0 04          	shl    $0x4,%rax
  7e9d84:	41 8b 0c 24          	mov    (%r12),%ecx
  7e9d88:	41 3b 0c 07          	cmp    (%r15,%rax,1),%ecx
  7e9d8c:	0f 85 38 01 00 00    	jne    7e9eca <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  7e9d92:	49 01 c7             	add    %rax,%r15
  7e9d95:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  7e9d9a:	41 3b 47 04          	cmp    0x4(%r15),%eax
  7e9d9e:	0f 85 26 01 00 00    	jne    7e9eca <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  7e9da4:	48 8b 7e 30          	mov    0x30(%rsi),%rdi
  7e9da8:	48 39 8f 18 01 00 00 	cmp    %rcx,0x118(%rdi)
  7e9daf:	0f 86 15 01 00 00    	jbe    7e9eca <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  7e9db5:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  7e9dbb:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  7e9dc0:	49 89 d6             	mov    %rdx,%r14
  7e9dc3:	48 6b d1 70          	imul   $0x70,%rcx,%rdx
  7e9dc7:	48 03 97 10 01 00 00 	add    0x110(%rdi),%rdx
  7e9dce:	48 89 7c 24 68       	mov    %rdi,0x68(%rsp)
  7e9dd3:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  7e9dd8:	89 4c 24 78          	mov    %ecx,0x78(%rsp)
  7e9ddc:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  7e9de1:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
  7e9de6:	48 89 c2             	mov    %rax,%rdx
  7e9de9:	e8 72 fe ff ff       	call   7e9c60 <<parley::layout::line::Line<()>>::item>
  7e9dee:	83 7c 24 20 01       	cmpl   $0x1,0x20(%rsp)
  7e9df3:	0f 85 c3 00 00 00    	jne    7e9ebc <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ac>
  7e9df9:	48 83 7c 24 28 00    	cmpq   $0x0,0x28(%rsp)
  7e9dff:	4c 89 f2             	mov    %r14,%rdx
  7e9e02:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7e9e07:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  7e9e0d:	0f 84 b7 00 00 00    	je     7e9eca <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  7e9e13:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7e9e18:	0f b6 80 8c 00 00 00 	movzbl 0x8c(%rax),%eax
  7e9e1f:	48 8d 4d 01          	lea    0x1(%rbp),%rcx
  7e9e23:	31 ff                	xor    %edi,%edi
  7e9e25:	4c 39 e9             	cmp    %r13,%rcx
  7e9e28:	40 0f 94 c7          	sete   %dil
  7e9e2c:	49 ff c5             	inc    %r13
  7e9e2f:	31 c9                	xor    %ecx,%ecx
  7e9e31:	49 39 ed             	cmp    %rbp,%r13
  7e9e34:	0f 94 c1             	sete   %cl
  7e9e37:	24 01                	and    $0x1,%al
  7e9e39:	88 44 24 0f          	mov    %al,0xf(%rsp)
  7e9e3d:	0f 44 f9             	cmove  %ecx,%edi
  7e9e40:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  7e9e45:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  7e9e4a:	48 8d 44 24 14       	lea    0x14(%rsp),%rax
  7e9e4f:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7e9e54:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
  7e9e59:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  7e9e5e:	4c 89 64 24 38       	mov    %r12,0x38(%rsp)
  7e9e63:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  7e9e68:	40 84 ff             	test   %dil,%dil
  7e9e6b:	74 5d                	je     7e9eca <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  7e9e6d:	48 8d bc 24 88 00 00 	lea    0x88(%rsp),%rdi
  7e9e74:	00 
  7e9e75:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  7e9e7a:	e8 61 fd ff ff       	call   7e9be0 <<parley::editing::geometry::CursorGeometry<()>>::shared_edge::{closure#0}>
  7e9e7f:	0f 10 84 24 88 00 00 	movups 0x88(%rsp),%xmm0
  7e9e86:	00 
  7e9e87:	0f 10 8c 24 98 00 00 	movups 0x98(%rsp),%xmm1
  7e9e8e:	00 
  7e9e8f:	0f 29 4c 24 50       	movaps %xmm1,0x50(%rsp)
  7e9e94:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  7e9e99:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  7e9e9e:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  7e9ea3:	0f 11 4b 38          	movups %xmm1,0x38(%rbx)
  7e9ea7:	0f 11 4b 18          	movups %xmm1,0x18(%rbx)
  7e9eab:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  7e9eaf:	0f 11 43 28          	movups %xmm0,0x28(%rbx)
  7e9eb3:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  7e9eba:	eb 17                	jmp    7e9ed3 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1c3>
  7e9ebc:	4c 89 f2             	mov    %r14,%rdx
  7e9ebf:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7e9ec4:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  7e9eca:	48 89 df             	mov    %rbx,%rdi
  7e9ecd:	ff 15 d5 1b 34 00    	call   *0x341bd5(%rip)        # b2baa8 <_DYNAMIC+0xdd8>
  7e9ed3:	48 89 d8             	mov    %rbx,%rax
  7e9ed6:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  7e9edd:	5b                   	pop    %rbx
  7e9ede:	41 5c                	pop    %r12
  7e9ee0:	41 5d                	pop    %r13
  7e9ee2:	41 5e                	pop    %r14
  7e9ee4:	41 5f                	pop    %r15
  7e9ee6:	5d                   	pop    %rbp
  7e9ee7:	c3                   	ret

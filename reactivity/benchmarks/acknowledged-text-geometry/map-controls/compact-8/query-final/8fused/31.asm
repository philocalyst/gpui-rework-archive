
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680dc0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>:
  680dc0:	41 56                	push   %r14
  680dc2:	53                   	push   %rbx
  680dc3:	50                   	push   %rax
  680dc4:	48 89 d1             	mov    %rdx,%rcx
  680dc7:	48 89 f0             	mov    %rsi,%rax
  680dca:	4c 8b 16             	mov    (%rsi),%r10
  680dcd:	4c 8b 4e 08          	mov    0x8(%rsi),%r9
  680dd1:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  680dd5:	4c 8b 46 18          	mov    0x18(%rsi),%r8
  680dd9:	49 83 fa 01          	cmp    $0x1,%r10
  680ddd:	75 26                	jne    680e05 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x45>
  680ddf:	4d 8d 59 0c          	lea    0xc(%r9),%r11
  680de3:	eb 7c                	jmp    680e61 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xa1>
  680de5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  680dec:	00 00 00 00 
  680df0:	48 89 70 18          	mov    %rsi,0x18(%rax)
  680df4:	4c 39 c6             	cmp    %r8,%rsi
  680df7:	72 46                	jb     680e3f <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x7f>
  680df9:	49 89 f0             	mov    %rsi,%r8
  680dfc:	48 ff c9             	dec    %rcx
  680dff:	0f 84 ad 00 00 00    	je     680eb2 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xf2>
  680e05:	49 39 d0             	cmp    %rdx,%r8
  680e08:	0f 83 45 01 00 00    	jae    680f53 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x193>
  680e0e:	49 8d 70 01          	lea    0x1(%r8),%rsi
  680e12:	48 39 d6             	cmp    %rdx,%rsi
  680e15:	73 1a                	jae    680e31 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x71>
  680e17:	47 8b 1c c1          	mov    (%r9,%r8,8),%r11d
  680e1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  680e20:	45 39 1c f1          	cmp    %r11d,(%r9,%rsi,8)
  680e24:	75 ca                	jne    680df0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x30>
  680e26:	48 ff c6             	inc    %rsi
  680e29:	48 39 f2             	cmp    %rsi,%rdx
  680e2c:	75 f2                	jne    680e20 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x60>
  680e2e:	48 89 d6             	mov    %rdx,%rsi
  680e31:	48 89 70 18          	mov    %rsi,0x18(%rax)
  680e35:	4c 39 c6             	cmp    %r8,%rsi
  680e38:	72 05                	jb     680e3f <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x7f>
  680e3a:	48 39 d6             	cmp    %rdx,%rsi
  680e3d:	76 ba                	jbe    680df9 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x39>
  680e3f:	48 8d 0d d2 e8 0f 00 	lea    0xfe8d2(%rip),%rcx        # 77f718 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xc0>
  680e46:	4c 89 c7             	mov    %r8,%rdi
  680e49:	ff 15 a1 8a 10 00    	call   *0x108aa1(%rip)        # 7898f0 <_DYNAMIC+0x3c8>
  680e4f:	90                   	nop
  680e50:	48 89 70 18          	mov    %rsi,0x18(%rax)
  680e54:	4c 39 c6             	cmp    %r8,%rsi
  680e57:	72 49                	jb     680ea2 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xe2>
  680e59:	49 89 f0             	mov    %rsi,%r8
  680e5c:	48 ff c9             	dec    %rcx
  680e5f:	74 51                	je     680eb2 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xf2>
  680e61:	49 39 d0             	cmp    %rdx,%r8
  680e64:	0f 83 e9 00 00 00    	jae    680f53 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x193>
  680e6a:	49 8d 70 01          	lea    0x1(%r8),%rsi
  680e6e:	48 39 d6             	cmp    %rdx,%rsi
  680e71:	73 21                	jae    680e94 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xd4>
  680e73:	4f 8d 34 40          	lea    (%r8,%r8,2),%r14
  680e77:	43 8b 1c b1          	mov    (%r9,%r14,4),%ebx
  680e7b:	4f 8d 34 b3          	lea    (%r11,%r14,4),%r14
  680e7f:	90                   	nop
  680e80:	41 39 1e             	cmp    %ebx,(%r14)
  680e83:	75 cb                	jne    680e50 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x90>
  680e85:	48 ff c6             	inc    %rsi
  680e88:	49 83 c6 0c          	add    $0xc,%r14
  680e8c:	48 39 f2             	cmp    %rsi,%rdx
  680e8f:	75 ef                	jne    680e80 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xc0>
  680e91:	48 89 d6             	mov    %rdx,%rsi
  680e94:	48 89 70 18          	mov    %rsi,0x18(%rax)
  680e98:	4c 39 c6             	cmp    %r8,%rsi
  680e9b:	72 05                	jb     680ea2 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xe2>
  680e9d:	48 39 d6             	cmp    %rdx,%rsi
  680ea0:	76 b7                	jbe    680e59 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x99>
  680ea2:	48 8d 0d 87 e8 0f 00 	lea    0xfe887(%rip),%rcx        # 77f730 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xd8>
  680ea9:	4c 89 c7             	mov    %r8,%rdi
  680eac:	ff 15 3e 8a 10 00    	call   *0x108a3e(%rip)        # 7898f0 <_DYNAMIC+0x3c8>
  680eb2:	41 f6 c2 01          	test   $0x1,%r10b
  680eb6:	74 58                	je     680f10 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x150>
  680eb8:	48 39 d6             	cmp    %rdx,%rsi
  680ebb:	0f 83 92 00 00 00    	jae    680f53 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x193>
  680ec1:	4c 8d 1c 76          	lea    (%rsi,%rsi,2),%r11
  680ec5:	4b 8d 0c 99          	lea    (%r9,%r11,4),%rcx
  680ec9:	4c 8d 46 01          	lea    0x1(%rsi),%r8
  680ecd:	49 39 d0             	cmp    %rdx,%r8
  680ed0:	73 22                	jae    680ef4 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x134>
  680ed2:	47 8b 14 99          	mov    (%r9,%r11,4),%r10d
  680ed6:	4f 8d 0c 99          	lea    (%r9,%r11,4),%r9
  680eda:	49 83 c1 0c          	add    $0xc,%r9
  680ede:	66 90                	xchg   %ax,%ax
  680ee0:	45 39 11             	cmp    %r10d,(%r9)
  680ee3:	75 7d                	jne    680f62 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1a2>
  680ee5:	49 ff c0             	inc    %r8
  680ee8:	49 83 c1 0c          	add    $0xc,%r9
  680eec:	4c 39 c2             	cmp    %r8,%rdx
  680eef:	75 ef                	jne    680ee0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x120>
  680ef1:	49 89 d0             	mov    %rdx,%r8
  680ef4:	4c 89 40 18          	mov    %r8,0x18(%rax)
  680ef8:	49 39 f0             	cmp    %rsi,%r8
  680efb:	0f 82 a1 00 00 00    	jb     680fa2 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1e2>
  680f01:	b8 01 00 00 00       	mov    $0x1,%eax
  680f06:	49 39 d0             	cmp    %rdx,%r8
  680f09:	76 65                	jbe    680f70 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1b0>
  680f0b:	e9 92 00 00 00       	jmp    680fa2 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1e2>
  680f10:	48 39 d6             	cmp    %rdx,%rsi
  680f13:	73 3e                	jae    680f53 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x193>
  680f15:	49 8d 0c f1          	lea    (%r9,%rsi,8),%rcx
  680f19:	4c 8d 46 01          	lea    0x1(%rsi),%r8
  680f1d:	49 39 d0             	cmp    %rdx,%r8
  680f20:	73 1f                	jae    680f41 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x181>
  680f22:	45 8b 14 f1          	mov    (%r9,%rsi,8),%r10d
  680f26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  680f2d:	00 00 00 
  680f30:	47 39 14 c1          	cmp    %r10d,(%r9,%r8,8)
  680f34:	75 50                	jne    680f86 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1c6>
  680f36:	49 ff c0             	inc    %r8
  680f39:	4c 39 c2             	cmp    %r8,%rdx
  680f3c:	75 f2                	jne    680f30 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x170>
  680f3e:	49 89 d0             	mov    %rdx,%r8
  680f41:	4c 89 40 18          	mov    %r8,0x18(%rax)
  680f45:	49 39 f0             	cmp    %rsi,%r8
  680f48:	72 45                	jb     680f8f <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1cf>
  680f4a:	49 39 d0             	cmp    %rdx,%r8
  680f4d:	77 40                	ja     680f8f <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1cf>
  680f4f:	31 c0                	xor    %eax,%eax
  680f51:	eb 1d                	jmp    680f70 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1b0>
  680f53:	48 c7 07 02 00 00 00 	movq   $0x2,(%rdi)
  680f5a:	48 83 c4 08          	add    $0x8,%rsp
  680f5e:	5b                   	pop    %rbx
  680f5f:	41 5e                	pop    %r14
  680f61:	c3                   	ret
  680f62:	4c 89 40 18          	mov    %r8,0x18(%rax)
  680f66:	b8 01 00 00 00       	mov    $0x1,%eax
  680f6b:	49 39 f0             	cmp    %rsi,%r8
  680f6e:	72 32                	jb     680fa2 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1e2>
  680f70:	49 29 f0             	sub    %rsi,%r8
  680f73:	48 89 07             	mov    %rax,(%rdi)
  680f76:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  680f7a:	4c 89 47 10          	mov    %r8,0x10(%rdi)
  680f7e:	48 83 c4 08          	add    $0x8,%rsp
  680f82:	5b                   	pop    %rbx
  680f83:	41 5e                	pop    %r14
  680f85:	c3                   	ret
  680f86:	4c 89 40 18          	mov    %r8,0x18(%rax)
  680f8a:	49 39 f0             	cmp    %rsi,%r8
  680f8d:	73 c0                	jae    680f4f <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x18f>
  680f8f:	48 8d 0d 82 e7 0f 00 	lea    0xfe782(%rip),%rcx        # 77f718 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xc0>
  680f96:	48 89 f7             	mov    %rsi,%rdi
  680f99:	4c 89 c6             	mov    %r8,%rsi
  680f9c:	ff 15 4e 89 10 00    	call   *0x10894e(%rip)        # 7898f0 <_DYNAMIC+0x3c8>
  680fa2:	48 8d 0d 87 e7 0f 00 	lea    0xfe787(%rip),%rcx        # 77f730 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xd8>
  680fa9:	48 89 f7             	mov    %rsi,%rdi
  680fac:	4c 89 c6             	mov    %r8,%rsi
  680faf:	ff 15 3b 89 10 00    	call   *0x10893b(%rip)        # 7898f0 <_DYNAMIC+0x3c8>

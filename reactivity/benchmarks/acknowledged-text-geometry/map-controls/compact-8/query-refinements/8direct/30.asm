
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000686d20 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next>:
  686d20:	41 57                	push   %r15
  686d22:	41 56                	push   %r14
  686d24:	41 55                	push   %r13
  686d26:	41 54                	push   %r12
  686d28:	53                   	push   %rbx
  686d29:	48 83 ec 20          	sub    $0x20,%rsp
  686d2d:	48 8b 5e 18          	mov    0x18(%rsi),%rbx
  686d31:	48 8b 46 08          	mov    0x8(%rsi),%rax
  686d35:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  686d39:	48 83 3e 01          	cmpq   $0x1,(%rsi)
  686d3d:	75 61                	jne    686da0 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x80>
  686d3f:	48 39 d3             	cmp    %rdx,%rbx
  686d42:	0f 83 4c 02 00 00    	jae    686f94 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x274>
  686d48:	4c 8d 04 5b          	lea    (%rbx,%rbx,2),%r8
  686d4c:	4e 8d 3c 80          	lea    (%rax,%r8,4),%r15
  686d50:	4c 8d 73 01          	lea    0x1(%rbx),%r14
  686d54:	49 39 d6             	cmp    %rdx,%r14
  686d57:	73 2a                	jae    686d83 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x63>
  686d59:	42 8b 0c 80          	mov    (%rax,%r8,4),%ecx
  686d5d:	4a 8d 04 80          	lea    (%rax,%r8,4),%rax
  686d61:	48 83 c0 0c          	add    $0xc,%rax
  686d65:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  686d6c:	00 00 00 00 
  686d70:	39 08                	cmp    %ecx,(%rax)
  686d72:	75 7c                	jne    686df0 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xd0>
  686d74:	49 ff c6             	inc    %r14
  686d77:	48 83 c0 0c          	add    $0xc,%rax
  686d7b:	4c 39 f2             	cmp    %r14,%rdx
  686d7e:	75 f0                	jne    686d70 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x50>
  686d80:	49 89 d6             	mov    %rdx,%r14
  686d83:	4c 89 76 18          	mov    %r14,0x18(%rsi)
  686d87:	49 39 de             	cmp    %rbx,%r14
  686d8a:	0f 82 c6 01 00 00    	jb     686f56 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x236>
  686d90:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  686d96:	49 39 d6             	cmp    %rdx,%r14
  686d99:	76 68                	jbe    686e03 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xe3>
  686d9b:	e9 b6 01 00 00       	jmp    686f56 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x236>
  686da0:	48 39 d3             	cmp    %rdx,%rbx
  686da3:	0f 83 eb 01 00 00    	jae    686f94 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x274>
  686da9:	4c 8d 3c d8          	lea    (%rax,%rbx,8),%r15
  686dad:	4c 8d 73 01          	lea    0x1(%rbx),%r14
  686db1:	49 39 d6             	cmp    %rdx,%r14
  686db4:	73 1f                	jae    686dd5 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xb5>
  686db6:	8b 0c d8             	mov    (%rax,%rbx,8),%ecx
  686db9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  686dc0:	42 39 0c f0          	cmp    %ecx,(%rax,%r14,8)
  686dc4:	0f 85 01 01 00 00    	jne    686ecb <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1ab>
  686dca:	49 ff c6             	inc    %r14
  686dcd:	4c 39 f2             	cmp    %r14,%rdx
  686dd0:	75 ee                	jne    686dc0 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xa0>
  686dd2:	49 89 d6             	mov    %rdx,%r14
  686dd5:	4c 89 76 18          	mov    %r14,0x18(%rsi)
  686dd9:	49 39 de             	cmp    %rbx,%r14
  686ddc:	0f 82 f6 00 00 00    	jb     686ed8 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1b8>
  686de2:	49 39 d6             	cmp    %rdx,%r14
  686de5:	0f 87 ed 00 00 00    	ja     686ed8 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1b8>
  686deb:	45 31 e4             	xor    %r12d,%r12d
  686dee:	eb 13                	jmp    686e03 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xe3>
  686df0:	4c 89 76 18          	mov    %r14,0x18(%rsi)
  686df4:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  686dfa:	49 39 de             	cmp    %rbx,%r14
  686dfd:	0f 82 53 01 00 00    	jb     686f56 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x236>
  686e03:	48 8b 56 40          	mov    0x40(%rsi),%rdx
  686e07:	48 85 d2             	test   %rdx,%rdx
  686e0a:	0f 85 59 01 00 00    	jne    686f69 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x249>
  686e10:	48 8b 46 38          	mov    0x38(%rsi),%rax
  686e14:	4c 8b 4e 28          	mov    0x28(%rsi),%r9
  686e18:	48 8b 56 30          	mov    0x30(%rsi),%rdx
  686e1c:	48 83 7e 20 01       	cmpq   $0x1,0x20(%rsi)
  686e21:	75 61                	jne    686e84 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x164>
  686e23:	48 39 d0             	cmp    %rdx,%rax
  686e26:	0f 83 68 01 00 00    	jae    686f94 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x274>
  686e2c:	4c 8d 1c 40          	lea    (%rax,%rax,2),%r11
  686e30:	4b 8d 0c 99          	lea    (%r9,%r11,4),%rcx
  686e34:	4c 8d 40 01          	lea    0x1(%rax),%r8
  686e38:	49 39 d0             	cmp    %rdx,%r8
  686e3b:	73 2b                	jae    686e68 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x148>
  686e3d:	47 8b 14 99          	mov    (%r9,%r11,4),%r10d
  686e41:	4f 8d 0c 99          	lea    (%r9,%r11,4),%r9
  686e45:	49 83 c1 0c          	add    $0xc,%r9
  686e49:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  686e50:	45 39 11             	cmp    %r10d,(%r9)
  686e53:	0f 85 92 00 00 00    	jne    686eeb <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1cb>
  686e59:	49 ff c0             	inc    %r8
  686e5c:	49 83 c1 0c          	add    $0xc,%r9
  686e60:	4c 39 c2             	cmp    %r8,%rdx
  686e63:	75 eb                	jne    686e50 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x130>
  686e65:	49 89 d0             	mov    %rdx,%r8
  686e68:	4c 89 46 38          	mov    %r8,0x38(%rsi)
  686e6c:	49 39 c0             	cmp    %rax,%r8
  686e6f:	0f 82 34 01 00 00    	jb     686fa9 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x289>
  686e75:	be 01 00 00 00       	mov    $0x1,%esi
  686e7a:	49 39 d0             	cmp    %rdx,%r8
  686e7d:	76 7e                	jbe    686efd <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1dd>
  686e7f:	e9 25 01 00 00       	jmp    686fa9 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x289>
  686e84:	48 39 d0             	cmp    %rdx,%rax
  686e87:	0f 83 07 01 00 00    	jae    686f94 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x274>
  686e8d:	49 8d 0c c1          	lea    (%r9,%rax,8),%rcx
  686e91:	4c 8d 40 01          	lea    0x1(%rax),%r8
  686e95:	49 39 d0             	cmp    %rdx,%r8
  686e98:	73 1b                	jae    686eb5 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x195>
  686e9a:	45 8b 14 c1          	mov    (%r9,%rax,8),%r10d
  686e9e:	66 90                	xchg   %ax,%ax
  686ea0:	47 39 14 c1          	cmp    %r10d,(%r9,%r8,8)
  686ea4:	0f 85 90 00 00 00    	jne    686f3a <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x21a>
  686eaa:	49 ff c0             	inc    %r8
  686ead:	4c 39 c2             	cmp    %r8,%rdx
  686eb0:	75 ee                	jne    686ea0 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x180>
  686eb2:	49 89 d0             	mov    %rdx,%r8
  686eb5:	4c 89 46 38          	mov    %r8,0x38(%rsi)
  686eb9:	49 39 c0             	cmp    %rax,%r8
  686ebc:	0f 82 81 00 00 00    	jb     686f43 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x223>
  686ec2:	49 39 d0             	cmp    %rdx,%r8
  686ec5:	77 7c                	ja     686f43 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x223>
  686ec7:	31 f6                	xor    %esi,%esi
  686ec9:	eb 32                	jmp    686efd <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1dd>
  686ecb:	4c 89 76 18          	mov    %r14,0x18(%rsi)
  686ecf:	49 39 de             	cmp    %rbx,%r14
  686ed2:	0f 83 13 ff ff ff    	jae    686deb <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xcb>
  686ed8:	48 8d 0d f1 8e 0f 00 	lea    0xf8ef1(%rip),%rcx        # 77fdd0 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1c8>
  686edf:	48 89 df             	mov    %rbx,%rdi
  686ee2:	4c 89 f6             	mov    %r14,%rsi
  686ee5:	ff 15 4d 2a 10 00    	call   *0x102a4d(%rip)        # 789938 <_DYNAMIC+0x4d0>
  686eeb:	4c 89 46 38          	mov    %r8,0x38(%rsi)
  686eef:	be 01 00 00 00       	mov    $0x1,%esi
  686ef4:	49 39 c0             	cmp    %rax,%r8
  686ef7:	0f 82 ac 00 00 00    	jb     686fa9 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x289>
  686efd:	49 29 c0             	sub    %rax,%r8
  686f00:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  686f05:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  686f0a:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  686f0f:	49 29 de             	sub    %rbx,%r14
  686f12:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  686f17:	48 89 47 28          	mov    %rax,0x28(%rdi)
  686f1b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  686f20:	48 89 47 18          	mov    %rax,0x18(%rdi)
  686f24:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  686f29:	48 89 47 20          	mov    %rax,0x20(%rdi)
  686f2d:	4c 89 27             	mov    %r12,(%rdi)
  686f30:	4c 89 7f 08          	mov    %r15,0x8(%rdi)
  686f34:	4c 89 77 10          	mov    %r14,0x10(%rdi)
  686f38:	eb 61                	jmp    686f9b <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x27b>
  686f3a:	4c 89 46 38          	mov    %r8,0x38(%rsi)
  686f3e:	49 39 c0             	cmp    %rax,%r8
  686f41:	73 84                	jae    686ec7 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1a7>
  686f43:	48 8d 0d 86 8e 0f 00 	lea    0xf8e86(%rip),%rcx        # 77fdd0 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1c8>
  686f4a:	48 89 c7             	mov    %rax,%rdi
  686f4d:	4c 89 c6             	mov    %r8,%rsi
  686f50:	ff 15 e2 29 10 00    	call   *0x1029e2(%rip)        # 789938 <_DYNAMIC+0x4d0>
  686f56:	48 8d 0d 8b 8e 0f 00 	lea    0xf8e8b(%rip),%rcx        # 77fde8 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1e0>
  686f5d:	48 89 df             	mov    %rbx,%rdi
  686f60:	4c 89 f6             	mov    %r14,%rsi
  686f63:	ff 15 cf 29 10 00    	call   *0x1029cf(%rip)        # 789938 <_DYNAMIC+0x4d0>
  686f69:	48 c7 46 40 00 00 00 	movq   $0x0,0x40(%rsi)
  686f70:	00 
  686f71:	48 83 c6 20          	add    $0x20,%rsi
  686f75:	48 8d 44 24 08       	lea    0x8(%rsp),%rax
  686f7a:	49 89 fd             	mov    %rdi,%r13
  686f7d:	48 89 c7             	mov    %rax,%rdi
  686f80:	e8 db 02 00 00       	call   687260 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>
  686f85:	4c 89 ef             	mov    %r13,%rdi
  686f88:	48 83 7c 24 08 02    	cmpq   $0x2,0x8(%rsp)
  686f8e:	0f 85 7b ff ff ff    	jne    686f0f <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1ef>
  686f94:	48 c7 07 02 00 00 00 	movq   $0x2,(%rdi)
  686f9b:	48 83 c4 20          	add    $0x20,%rsp
  686f9f:	5b                   	pop    %rbx
  686fa0:	41 5c                	pop    %r12
  686fa2:	41 5d                	pop    %r13
  686fa4:	41 5e                	pop    %r14
  686fa6:	41 5f                	pop    %r15
  686fa8:	c3                   	ret
  686fa9:	48 8d 0d 38 8e 0f 00 	lea    0xf8e38(%rip),%rcx        # 77fde8 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1e0>
  686fb0:	48 89 c7             	mov    %rax,%rdi
  686fb3:	4c 89 c6             	mov    %r8,%rsi
  686fb6:	ff 15 7c 29 10 00    	call   *0x10297c(%rip)        # 789938 <_DYNAMIC+0x4d0>

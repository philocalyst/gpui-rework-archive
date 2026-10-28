
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680880 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next>:
  680880:	41 57                	push   %r15
  680882:	41 56                	push   %r14
  680884:	41 55                	push   %r13
  680886:	41 54                	push   %r12
  680888:	53                   	push   %rbx
  680889:	48 83 ec 20          	sub    $0x20,%rsp
  68088d:	48 8b 5e 18          	mov    0x18(%rsi),%rbx
  680891:	48 8b 46 08          	mov    0x8(%rsi),%rax
  680895:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  680899:	48 83 3e 01          	cmpq   $0x1,(%rsi)
  68089d:	75 61                	jne    680900 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x80>
  68089f:	48 39 d3             	cmp    %rdx,%rbx
  6808a2:	0f 83 4c 02 00 00    	jae    680af4 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x274>
  6808a8:	4c 8d 04 5b          	lea    (%rbx,%rbx,2),%r8
  6808ac:	4e 8d 3c 80          	lea    (%rax,%r8,4),%r15
  6808b0:	4c 8d 73 01          	lea    0x1(%rbx),%r14
  6808b4:	49 39 d6             	cmp    %rdx,%r14
  6808b7:	73 2a                	jae    6808e3 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x63>
  6808b9:	42 8b 0c 80          	mov    (%rax,%r8,4),%ecx
  6808bd:	4a 8d 04 80          	lea    (%rax,%r8,4),%rax
  6808c1:	48 83 c0 0c          	add    $0xc,%rax
  6808c5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6808cc:	00 00 00 00 
  6808d0:	39 08                	cmp    %ecx,(%rax)
  6808d2:	75 7c                	jne    680950 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xd0>
  6808d4:	49 ff c6             	inc    %r14
  6808d7:	48 83 c0 0c          	add    $0xc,%rax
  6808db:	4c 39 f2             	cmp    %r14,%rdx
  6808de:	75 f0                	jne    6808d0 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x50>
  6808e0:	49 89 d6             	mov    %rdx,%r14
  6808e3:	4c 89 76 18          	mov    %r14,0x18(%rsi)
  6808e7:	49 39 de             	cmp    %rbx,%r14
  6808ea:	0f 82 c6 01 00 00    	jb     680ab6 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x236>
  6808f0:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  6808f6:	49 39 d6             	cmp    %rdx,%r14
  6808f9:	76 68                	jbe    680963 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xe3>
  6808fb:	e9 b6 01 00 00       	jmp    680ab6 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x236>
  680900:	48 39 d3             	cmp    %rdx,%rbx
  680903:	0f 83 eb 01 00 00    	jae    680af4 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x274>
  680909:	4c 8d 3c d8          	lea    (%rax,%rbx,8),%r15
  68090d:	4c 8d 73 01          	lea    0x1(%rbx),%r14
  680911:	49 39 d6             	cmp    %rdx,%r14
  680914:	73 1f                	jae    680935 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xb5>
  680916:	8b 0c d8             	mov    (%rax,%rbx,8),%ecx
  680919:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  680920:	42 39 0c f0          	cmp    %ecx,(%rax,%r14,8)
  680924:	0f 85 01 01 00 00    	jne    680a2b <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1ab>
  68092a:	49 ff c6             	inc    %r14
  68092d:	4c 39 f2             	cmp    %r14,%rdx
  680930:	75 ee                	jne    680920 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xa0>
  680932:	49 89 d6             	mov    %rdx,%r14
  680935:	4c 89 76 18          	mov    %r14,0x18(%rsi)
  680939:	49 39 de             	cmp    %rbx,%r14
  68093c:	0f 82 f6 00 00 00    	jb     680a38 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1b8>
  680942:	49 39 d6             	cmp    %rdx,%r14
  680945:	0f 87 ed 00 00 00    	ja     680a38 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1b8>
  68094b:	45 31 e4             	xor    %r12d,%r12d
  68094e:	eb 13                	jmp    680963 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xe3>
  680950:	4c 89 76 18          	mov    %r14,0x18(%rsi)
  680954:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  68095a:	49 39 de             	cmp    %rbx,%r14
  68095d:	0f 82 53 01 00 00    	jb     680ab6 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x236>
  680963:	48 8b 56 40          	mov    0x40(%rsi),%rdx
  680967:	48 85 d2             	test   %rdx,%rdx
  68096a:	0f 85 59 01 00 00    	jne    680ac9 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x249>
  680970:	48 8b 46 38          	mov    0x38(%rsi),%rax
  680974:	4c 8b 4e 28          	mov    0x28(%rsi),%r9
  680978:	48 8b 56 30          	mov    0x30(%rsi),%rdx
  68097c:	48 83 7e 20 01       	cmpq   $0x1,0x20(%rsi)
  680981:	75 61                	jne    6809e4 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x164>
  680983:	48 39 d0             	cmp    %rdx,%rax
  680986:	0f 83 68 01 00 00    	jae    680af4 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x274>
  68098c:	4c 8d 1c 40          	lea    (%rax,%rax,2),%r11
  680990:	4b 8d 0c 99          	lea    (%r9,%r11,4),%rcx
  680994:	4c 8d 40 01          	lea    0x1(%rax),%r8
  680998:	49 39 d0             	cmp    %rdx,%r8
  68099b:	73 2b                	jae    6809c8 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x148>
  68099d:	47 8b 14 99          	mov    (%r9,%r11,4),%r10d
  6809a1:	4f 8d 0c 99          	lea    (%r9,%r11,4),%r9
  6809a5:	49 83 c1 0c          	add    $0xc,%r9
  6809a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6809b0:	45 39 11             	cmp    %r10d,(%r9)
  6809b3:	0f 85 92 00 00 00    	jne    680a4b <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1cb>
  6809b9:	49 ff c0             	inc    %r8
  6809bc:	49 83 c1 0c          	add    $0xc,%r9
  6809c0:	4c 39 c2             	cmp    %r8,%rdx
  6809c3:	75 eb                	jne    6809b0 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x130>
  6809c5:	49 89 d0             	mov    %rdx,%r8
  6809c8:	4c 89 46 38          	mov    %r8,0x38(%rsi)
  6809cc:	49 39 c0             	cmp    %rax,%r8
  6809cf:	0f 82 34 01 00 00    	jb     680b09 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x289>
  6809d5:	be 01 00 00 00       	mov    $0x1,%esi
  6809da:	49 39 d0             	cmp    %rdx,%r8
  6809dd:	76 7e                	jbe    680a5d <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1dd>
  6809df:	e9 25 01 00 00       	jmp    680b09 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x289>
  6809e4:	48 39 d0             	cmp    %rdx,%rax
  6809e7:	0f 83 07 01 00 00    	jae    680af4 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x274>
  6809ed:	49 8d 0c c1          	lea    (%r9,%rax,8),%rcx
  6809f1:	4c 8d 40 01          	lea    0x1(%rax),%r8
  6809f5:	49 39 d0             	cmp    %rdx,%r8
  6809f8:	73 1b                	jae    680a15 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x195>
  6809fa:	45 8b 14 c1          	mov    (%r9,%rax,8),%r10d
  6809fe:	66 90                	xchg   %ax,%ax
  680a00:	47 39 14 c1          	cmp    %r10d,(%r9,%r8,8)
  680a04:	0f 85 90 00 00 00    	jne    680a9a <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x21a>
  680a0a:	49 ff c0             	inc    %r8
  680a0d:	4c 39 c2             	cmp    %r8,%rdx
  680a10:	75 ee                	jne    680a00 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x180>
  680a12:	49 89 d0             	mov    %rdx,%r8
  680a15:	4c 89 46 38          	mov    %r8,0x38(%rsi)
  680a19:	49 39 c0             	cmp    %rax,%r8
  680a1c:	0f 82 81 00 00 00    	jb     680aa3 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x223>
  680a22:	49 39 d0             	cmp    %rdx,%r8
  680a25:	77 7c                	ja     680aa3 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x223>
  680a27:	31 f6                	xor    %esi,%esi
  680a29:	eb 32                	jmp    680a5d <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1dd>
  680a2b:	4c 89 76 18          	mov    %r14,0x18(%rsi)
  680a2f:	49 39 de             	cmp    %rbx,%r14
  680a32:	0f 83 13 ff ff ff    	jae    68094b <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0xcb>
  680a38:	48 8d 0d d9 ec 0f 00 	lea    0xfecd9(%rip),%rcx        # 77f718 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xc0>
  680a3f:	48 89 df             	mov    %rbx,%rdi
  680a42:	4c 89 f6             	mov    %r14,%rsi
  680a45:	ff 15 a5 8e 10 00    	call   *0x108ea5(%rip)        # 7898f0 <_DYNAMIC+0x3c8>
  680a4b:	4c 89 46 38          	mov    %r8,0x38(%rsi)
  680a4f:	be 01 00 00 00       	mov    $0x1,%esi
  680a54:	49 39 c0             	cmp    %rax,%r8
  680a57:	0f 82 ac 00 00 00    	jb     680b09 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x289>
  680a5d:	49 29 c0             	sub    %rax,%r8
  680a60:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  680a65:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  680a6a:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  680a6f:	49 29 de             	sub    %rbx,%r14
  680a72:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  680a77:	48 89 47 28          	mov    %rax,0x28(%rdi)
  680a7b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  680a80:	48 89 47 18          	mov    %rax,0x18(%rdi)
  680a84:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  680a89:	48 89 47 20          	mov    %rax,0x20(%rdi)
  680a8d:	4c 89 27             	mov    %r12,(%rdi)
  680a90:	4c 89 7f 08          	mov    %r15,0x8(%rdi)
  680a94:	4c 89 77 10          	mov    %r14,0x10(%rdi)
  680a98:	eb 61                	jmp    680afb <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x27b>
  680a9a:	4c 89 46 38          	mov    %r8,0x38(%rsi)
  680a9e:	49 39 c0             	cmp    %rax,%r8
  680aa1:	73 84                	jae    680a27 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1a7>
  680aa3:	48 8d 0d 6e ec 0f 00 	lea    0xfec6e(%rip),%rcx        # 77f718 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xc0>
  680aaa:	48 89 c7             	mov    %rax,%rdi
  680aad:	4c 89 c6             	mov    %r8,%rsi
  680ab0:	ff 15 3a 8e 10 00    	call   *0x108e3a(%rip)        # 7898f0 <_DYNAMIC+0x3c8>
  680ab6:	48 8d 0d 73 ec 0f 00 	lea    0xfec73(%rip),%rcx        # 77f730 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xd8>
  680abd:	48 89 df             	mov    %rbx,%rdi
  680ac0:	4c 89 f6             	mov    %r14,%rsi
  680ac3:	ff 15 27 8e 10 00    	call   *0x108e27(%rip)        # 7898f0 <_DYNAMIC+0x3c8>
  680ac9:	48 c7 46 40 00 00 00 	movq   $0x0,0x40(%rsi)
  680ad0:	00 
  680ad1:	48 83 c6 20          	add    $0x20,%rsi
  680ad5:	48 8d 44 24 08       	lea    0x8(%rsp),%rax
  680ada:	49 89 fd             	mov    %rdi,%r13
  680add:	48 89 c7             	mov    %rax,%rdi
  680ae0:	e8 db 02 00 00       	call   680dc0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>
  680ae5:	4c 89 ef             	mov    %r13,%rdi
  680ae8:	48 83 7c 24 08 02    	cmpq   $0x2,0x8(%rsp)
  680aee:	0f 85 7b ff ff ff    	jne    680a6f <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next+0x1ef>
  680af4:	48 c7 07 02 00 00 00 	movq   $0x2,(%rdi)
  680afb:	48 83 c4 20          	add    $0x20,%rsp
  680aff:	5b                   	pop    %rbx
  680b00:	41 5c                	pop    %r12
  680b02:	41 5d                	pop    %r13
  680b04:	41 5e                	pop    %r14
  680b06:	41 5f                	pop    %r15
  680b08:	c3                   	ret
  680b09:	48 8d 0d 20 ec 0f 00 	lea    0xfec20(%rip),%rcx        # 77f730 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xd8>
  680b10:	48 89 c7             	mov    %rax,%rdi
  680b13:	4c 89 c6             	mov    %r8,%rsi
  680b16:	ff 15 d4 8d 10 00    	call   *0x108dd4(%rip)        # 7898f0 <_DYNAMIC+0x3c8>

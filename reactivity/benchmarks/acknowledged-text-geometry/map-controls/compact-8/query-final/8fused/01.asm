
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000066bff0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>>:
  66bff0:	41 56                	push   %r14
  66bff2:	53                   	push   %rbx
  66bff3:	50                   	push   %rax
  66bff4:	48 8b 4f 18          	mov    0x18(%rdi),%rcx
  66bff8:	48 8b 47 20          	mov    0x20(%rdi),%rax
  66bffc:	48 8b 1e             	mov    (%rsi),%rbx
  66bfff:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  66c003:	48 39 c1             	cmp    %rax,%rcx
  66c006:	0f 83 9b 00 00 00    	jae    66c0a7 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xb7>
  66c00c:	4c 8b 46 10          	mov    0x10(%rsi),%r8
  66c010:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  66c014:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  66c018:	48 83 3f 01          	cmpq   $0x1,(%rdi)
  66c01c:	0f 85 90 00 00 00    	jne    66c0b2 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xc2>
  66c022:	4b 8d 3c 76          	lea    (%r14,%r14,2),%rdi
  66c026:	49 8d 3c b8          	lea    (%r8,%rdi,4),%rdi
  66c02a:	4c 8d 04 49          	lea    (%rcx,%rcx,2),%r8
  66c02e:	4a 8d 34 86          	lea    (%rsi,%r8,4),%rsi
  66c032:	41 b8 09 00 00 00    	mov    $0x9,%r8d
  66c038:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  66c03f:	00 
  66c040:	48 39 d1             	cmp    %rdx,%rcx
  66c043:	0f 83 cc 00 00 00    	jae    66c115 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0x125>
  66c049:	48 ff c1             	inc    %rcx
  66c04c:	46 8b 4c 06 f7       	mov    -0x9(%rsi,%r8,1),%r9d
  66c051:	f3 42 0f 10 44 06 fb 	movss  -0x5(%rsi,%r8,1),%xmm0
  66c058:	46 0f b6 54 06 ff    	movzbl -0x1(%rsi,%r8,1),%r10d
  66c05e:	46 0f b6 5c 06 02    	movzbl 0x2(%rsi,%r8,1),%r11d
  66c064:	44 88 5c 24 06       	mov    %r11b,0x6(%rsp)
  66c069:	46 0f b7 1c 06       	movzwl (%rsi,%r8,1),%r11d
  66c06e:	66 44 89 5c 24 04    	mov    %r11w,0x4(%rsp)
  66c074:	46 89 4c 07 f7       	mov    %r9d,-0x9(%rdi,%r8,1)
  66c079:	f3 42 0f 11 44 07 fb 	movss  %xmm0,-0x5(%rdi,%r8,1)
  66c080:	46 88 54 07 ff       	mov    %r10b,-0x1(%rdi,%r8,1)
  66c085:	44 0f b7 4c 24 04    	movzwl 0x4(%rsp),%r9d
  66c08b:	66 46 89 0c 07       	mov    %r9w,(%rdi,%r8,1)
  66c090:	44 0f b6 4c 24 06    	movzbl 0x6(%rsp),%r9d
  66c096:	46 88 4c 07 02       	mov    %r9b,0x2(%rdi,%r8,1)
  66c09b:	49 ff c6             	inc    %r14
  66c09e:	49 83 c0 0c          	add    $0xc,%r8
  66c0a2:	48 39 c8             	cmp    %rcx,%rax
  66c0a5:	75 99                	jne    66c040 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0x50>
  66c0a7:	4c 89 33             	mov    %r14,(%rbx)
  66c0aa:	48 83 c4 08          	add    $0x8,%rsp
  66c0ae:	5b                   	pop    %rbx
  66c0af:	41 5e                	pop    %r14
  66c0b1:	c3                   	ret
  66c0b2:	4b 8d 3c 76          	lea    (%r14,%r14,2),%rdi
  66c0b6:	49 8d 3c b8          	lea    (%r8,%rdi,4),%rdi
  66c0ba:	48 83 c7 08          	add    $0x8,%rdi
  66c0be:	eb 30                	jmp    66c0f0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0x100>
  66c0c0:	4d 85 c9             	test   %r9,%r9
  66c0c3:	74 4b                	je     66c110 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0x120>
  66c0c5:	44 39 44 ce f0       	cmp    %r8d,-0x10(%rsi,%rcx,8)
  66c0ca:	41 0f 94 c2          	sete   %r10b
  66c0ce:	41 80 f2 03          	xor    $0x3,%r10b
  66c0d2:	f3 0f 10 44 ce fc    	movss  -0x4(%rsi,%rcx,8),%xmm0
  66c0d8:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
  66c0dc:	f3 0f 11 47 fc       	movss  %xmm0,-0x4(%rdi)
  66c0e1:	44 88 17             	mov    %r10b,(%rdi)
  66c0e4:	49 ff c6             	inc    %r14
  66c0e7:	48 83 c7 0c          	add    $0xc,%rdi
  66c0eb:	48 39 c8             	cmp    %rcx,%rax
  66c0ee:	74 b7                	je     66c0a7 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xb7>
  66c0f0:	48 39 d1             	cmp    %rdx,%rcx
  66c0f3:	73 20                	jae    66c115 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0x125>
  66c0f5:	49 89 c9             	mov    %rcx,%r9
  66c0f8:	48 ff c1             	inc    %rcx
  66c0fb:	46 8b 04 ce          	mov    (%rsi,%r9,8),%r8d
  66c0ff:	48 39 d1             	cmp    %rdx,%rcx
  66c102:	73 bc                	jae    66c0c0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xd0>
  66c104:	41 b2 01             	mov    $0x1,%r10b
  66c107:	44 39 04 ce          	cmp    %r8d,(%rsi,%rcx,8)
  66c10b:	75 b3                	jne    66c0c0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xd0>
  66c10d:	eb c3                	jmp    66c0d2 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xe2>
  66c10f:	90                   	nop
  66c110:	41 b2 03             	mov    $0x3,%r10b
  66c113:	eb bd                	jmp    66c0d2 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xe2>
  66c115:	48 8d 3d 7c 2d 11 00 	lea    0x112d7c(%rip),%rdi        # 77ee98 <anon.17cc0cddeb7f52c0d510aaf5d8af24ac.11.llvm.10253562051569396321>
  66c11c:	ff 15 ae d6 11 00    	call   *0x11d6ae(%rip)        # 7897d0 <_DYNAMIC+0x2a8>
  66c122:	0f 0b                	ud2
  66c124:	4c 89 33             	mov    %r14,(%rbx)
  66c127:	48 89 c7             	mov    %rax,%rdi
  66c12a:	e8 e1 16 11 00       	call   77d810 <_Unwind_Resume@plt>

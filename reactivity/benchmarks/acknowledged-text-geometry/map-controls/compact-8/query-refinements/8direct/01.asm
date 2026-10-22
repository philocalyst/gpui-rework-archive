
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006817a0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>>:
  6817a0:	41 56                	push   %r14
  6817a2:	53                   	push   %rbx
  6817a3:	50                   	push   %rax
  6817a4:	48 8b 4f 18          	mov    0x18(%rdi),%rcx
  6817a8:	48 8b 47 20          	mov    0x20(%rdi),%rax
  6817ac:	48 8b 1e             	mov    (%rsi),%rbx
  6817af:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  6817b3:	48 39 c1             	cmp    %rax,%rcx
  6817b6:	0f 83 9b 00 00 00    	jae    681857 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xb7>
  6817bc:	4c 8b 46 10          	mov    0x10(%rsi),%r8
  6817c0:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  6817c4:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  6817c8:	48 83 3f 01          	cmpq   $0x1,(%rdi)
  6817cc:	0f 85 90 00 00 00    	jne    681862 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xc2>
  6817d2:	4b 8d 3c 76          	lea    (%r14,%r14,2),%rdi
  6817d6:	49 8d 3c b8          	lea    (%r8,%rdi,4),%rdi
  6817da:	4c 8d 04 49          	lea    (%rcx,%rcx,2),%r8
  6817de:	4a 8d 34 86          	lea    (%rsi,%r8,4),%rsi
  6817e2:	41 b8 09 00 00 00    	mov    $0x9,%r8d
  6817e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  6817ef:	00 
  6817f0:	48 39 d1             	cmp    %rdx,%rcx
  6817f3:	0f 83 cc 00 00 00    	jae    6818c5 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0x125>
  6817f9:	48 ff c1             	inc    %rcx
  6817fc:	46 8b 4c 06 f7       	mov    -0x9(%rsi,%r8,1),%r9d
  681801:	f3 42 0f 10 44 06 fb 	movss  -0x5(%rsi,%r8,1),%xmm0
  681808:	46 0f b6 54 06 ff    	movzbl -0x1(%rsi,%r8,1),%r10d
  68180e:	46 0f b6 5c 06 02    	movzbl 0x2(%rsi,%r8,1),%r11d
  681814:	44 88 5c 24 06       	mov    %r11b,0x6(%rsp)
  681819:	46 0f b7 1c 06       	movzwl (%rsi,%r8,1),%r11d
  68181e:	66 44 89 5c 24 04    	mov    %r11w,0x4(%rsp)
  681824:	46 89 4c 07 f7       	mov    %r9d,-0x9(%rdi,%r8,1)
  681829:	f3 42 0f 11 44 07 fb 	movss  %xmm0,-0x5(%rdi,%r8,1)
  681830:	46 88 54 07 ff       	mov    %r10b,-0x1(%rdi,%r8,1)
  681835:	44 0f b7 4c 24 04    	movzwl 0x4(%rsp),%r9d
  68183b:	66 46 89 0c 07       	mov    %r9w,(%rdi,%r8,1)
  681840:	44 0f b6 4c 24 06    	movzbl 0x6(%rsp),%r9d
  681846:	46 88 4c 07 02       	mov    %r9b,0x2(%rdi,%r8,1)
  68184b:	49 ff c6             	inc    %r14
  68184e:	49 83 c0 0c          	add    $0xc,%r8
  681852:	48 39 c8             	cmp    %rcx,%rax
  681855:	75 99                	jne    6817f0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0x50>
  681857:	4c 89 33             	mov    %r14,(%rbx)
  68185a:	48 83 c4 08          	add    $0x8,%rsp
  68185e:	5b                   	pop    %rbx
  68185f:	41 5e                	pop    %r14
  681861:	c3                   	ret
  681862:	4b 8d 3c 76          	lea    (%r14,%r14,2),%rdi
  681866:	49 8d 3c b8          	lea    (%r8,%rdi,4),%rdi
  68186a:	48 83 c7 08          	add    $0x8,%rdi
  68186e:	eb 30                	jmp    6818a0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0x100>
  681870:	4d 85 c9             	test   %r9,%r9
  681873:	74 4b                	je     6818c0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0x120>
  681875:	44 39 44 ce f0       	cmp    %r8d,-0x10(%rsi,%rcx,8)
  68187a:	41 0f 94 c2          	sete   %r10b
  68187e:	41 80 f2 03          	xor    $0x3,%r10b
  681882:	f3 0f 10 44 ce fc    	movss  -0x4(%rsi,%rcx,8),%xmm0
  681888:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
  68188c:	f3 0f 11 47 fc       	movss  %xmm0,-0x4(%rdi)
  681891:	44 88 17             	mov    %r10b,(%rdi)
  681894:	49 ff c6             	inc    %r14
  681897:	48 83 c7 0c          	add    $0xc,%rdi
  68189b:	48 39 c8             	cmp    %rcx,%rax
  68189e:	74 b7                	je     681857 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xb7>
  6818a0:	48 39 d1             	cmp    %rdx,%rcx
  6818a3:	73 20                	jae    6818c5 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0x125>
  6818a5:	49 89 c9             	mov    %rcx,%r9
  6818a8:	48 ff c1             	inc    %rcx
  6818ab:	46 8b 04 ce          	mov    (%rsi,%r9,8),%r8d
  6818af:	48 39 d1             	cmp    %rdx,%rcx
  6818b2:	73 bc                	jae    681870 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xd0>
  6818b4:	41 b2 01             	mov    $0x1,%r10b
  6818b7:	44 39 04 ce          	cmp    %r8d,(%rsi,%rcx,8)
  6818bb:	75 b3                	jne    681870 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xd0>
  6818bd:	eb c3                	jmp    681882 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xe2>
  6818bf:	90                   	nop
  6818c0:	41 b2 03             	mov    $0x3,%r10b
  6818c3:	eb bd                	jmp    681882 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>+0xe2>
  6818c5:	48 8d 3d 3c e3 0f 00 	lea    0xfe33c(%rip),%rdi        # 77fc08 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468>
  6818cc:	ff 15 3e 7e 10 00    	call   *0x107e3e(%rip)        # 789710 <_DYNAMIC+0x2a8>
  6818d2:	0f 0b                	ud2
  6818d4:	4c 89 33             	mov    %r14,(%rbx)
  6818d7:	48 89 c7             	mov    %rax,%rdi
  6818da:	e8 a1 be 0f 00       	call   77d780 <_Unwind_Resume@plt>

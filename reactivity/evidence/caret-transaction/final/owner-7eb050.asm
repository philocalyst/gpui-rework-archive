
/tmp/gpui-caret-transaction-bin/62e-native-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007eb050 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>>:
  7eb050:	55                   	push   %rbp
  7eb051:	41 57                	push   %r15
  7eb053:	41 56                	push   %r14
  7eb055:	41 55                	push   %r13
  7eb057:	41 54                	push   %r12
  7eb059:	53                   	push   %rbx
  7eb05a:	48 81 ec d8 02 00 00 	sub    $0x2d8,%rsp
  7eb061:	83 bf 54 01 00 00 00 	cmpl   $0x0,0x154(%rdi)
  7eb068:	75 1d                	jne    7eb087 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x37>
  7eb06a:	48 89 fd             	mov    %rdi,%rbp
  7eb06d:	48 8b 47 70          	mov    0x70(%rdi),%rax
  7eb071:	48 c1 e8 20          	shr    $0x20,%rax
  7eb075:	75 10                	jne    7eb087 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x37>
  7eb077:	48 8b 9d 18 01 00 00 	mov    0x118(%rbp),%rbx
  7eb07e:	48 89 d8             	mov    %rbx,%rax
  7eb081:	48 c1 e8 20          	shr    $0x20,%rax
  7eb085:	74 24                	je     7eb0ab <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x5b>
  7eb087:	48 8b 06             	mov    (%rsi),%rax
  7eb08a:	41 b6 01             	mov    $0x1,%r14b
  7eb08d:	48 85 c0             	test   %rax,%rax
  7eb090:	0f 84 cc 0a 00 00    	je     7ebb62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb12>
  7eb096:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  7eb09a:	48 c1 e0 03          	shl    $0x3,%rax
  7eb09e:	ba 08 00 00 00       	mov    $0x8,%edx
  7eb0a3:	48 89 c6             	mov    %rax,%rsi
  7eb0a6:	e9 b1 0a 00 00       	jmp    7ebb5c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb0c>
  7eb0ab:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  7eb0b1:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
  7eb0b6:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  7eb0bd:	00 00 
  7eb0bf:	48 c7 44 24 40 04 00 	movq   $0x4,0x40(%rsp)
  7eb0c6:	00 00 
  7eb0c8:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
  7eb0cf:	00 00 
  7eb0d1:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  7eb0d8:	00 00 
  7eb0da:	48 c7 44 24 58 04 00 	movq   $0x4,0x58(%rsp)
  7eb0e1:	00 00 
  7eb0e3:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  7eb0ea:	00 00 
  7eb0ec:	48 8d bc 24 40 02 00 	lea    0x240(%rsp),%rdi
  7eb0f3:	00 
  7eb0f4:	49 89 d6             	mov    %rdx,%r14
  7eb0f7:	ba 98 00 00 00       	mov    $0x98,%edx
  7eb0fc:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
  7eb102:	ff 15 68 26 34 00    	call   *0x342668(%rip)        # b2d770 <memcpy@GLIBC_2.14>
  7eb108:	4c 89 b4 24 b0 00 00 	mov    %r14,0xb0(%rsp)
  7eb10f:	00 
  7eb110:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  7eb116:	f3 0f 11 44 24 20    	movss  %xmm0,0x20(%rsp)
  7eb11c:	48 c7 84 24 30 02 00 	movq   $0x2,0x230(%rsp)
  7eb123:	00 02 00 00 00 
  7eb128:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  7eb12f:	00 00 00 00 00 
  7eb134:	c7 84 24 a4 01 00 00 	movl   $0x0,0x1a4(%rsp)
  7eb13b:	00 00 00 00 
  7eb13f:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  7eb146:	00 00 00 00 00 
  7eb14b:	48 c7 84 24 f8 00 00 	movq   $0x0,0xf8(%rsp)
  7eb152:	00 00 00 00 00 
  7eb157:	48 c7 84 24 00 01 00 	movq   $0x0,0x100(%rsp)
  7eb15e:	00 00 00 00 00 
  7eb163:	48 85 db             	test   %rbx,%rbx
  7eb166:	48 89 6c 24 78       	mov    %rbp,0x78(%rsp)
  7eb16b:	0f 84 2b 08 00 00    	je     7eb99c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x94c>
  7eb171:	48 8b 8d 10 01 00 00 	mov    0x110(%rbp),%rcx
  7eb178:	48 6b c3 70          	imul   $0x70,%rbx,%rax
  7eb17c:	48 01 c8             	add    %rcx,%rax
  7eb17f:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  7eb186:	00 
  7eb187:	4c 8b 85 28 01 00 00 	mov    0x128(%rbp),%r8
  7eb18e:	48 8b 95 30 01 00 00 	mov    0x130(%rbp),%rdx
  7eb195:	48 8b 45 58          	mov    0x58(%rbp),%rax
  7eb199:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  7eb1a0:	00 
  7eb1a1:	48 8b 85 e8 00 00 00 	mov    0xe8(%rbp),%rax
  7eb1a8:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  7eb1af:	00 
  7eb1b0:	45 31 c9             	xor    %r9d,%r9d
  7eb1b3:	48 8d 05 ae c4 31 00 	lea    0x31c4ae(%rip),%rax        # b07668 <anon.ee2cf06d9598ac3323a1e4b3d9cbfdc3.3.llvm.17696767679096401280+0x78>
  7eb1ba:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  7eb1c1:	00 
  7eb1c2:	48 8d 05 6f c4 31 00 	lea    0x31c46f(%rip),%rax        # b07638 <anon.ee2cf06d9598ac3323a1e4b3d9cbfdc3.3.llvm.17696767679096401280+0x48>
  7eb1c9:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7eb1ce:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  7eb1d5:	00 
  7eb1d6:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  7eb1db:	48 89 ac 24 90 00 00 	mov    %rbp,0x90(%rsp)
  7eb1e2:	00 
  7eb1e3:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  7eb1ea:	00 
  7eb1eb:	44 89 8c 24 a0 00 00 	mov    %r9d,0xa0(%rsp)
  7eb1f2:	00 
  7eb1f3:	48 8b 79 10          	mov    0x10(%rcx),%rdi
  7eb1f7:	48 8b 71 18          	mov    0x18(%rcx),%rsi
  7eb1fb:	48 89 f0             	mov    %rsi,%rax
  7eb1fe:	48 29 f8             	sub    %rdi,%rax
  7eb201:	0f 82 74 09 00 00    	jb     7ebb7b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb2b>
  7eb207:	48 39 d6             	cmp    %rdx,%rsi
  7eb20a:	0f 87 6b 09 00 00    	ja     7ebb7b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb2b>
  7eb210:	48 c1 e8 20          	shr    $0x20,%rax
  7eb214:	41 b6 01             	mov    $0x1,%r14b
  7eb217:	0f 85 e5 08 00 00    	jne    7ebb02 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  7eb21d:	4c 89 4c 24 70       	mov    %r9,0x70(%rsp)
  7eb222:	48 39 fe             	cmp    %rdi,%rsi
  7eb225:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  7eb22a:	0f 85 96 03 00 00    	jne    7eb5c6 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x576>
  7eb230:	48 89 fe             	mov    %rdi,%rsi
  7eb233:	48 89 eb             	mov    %rbp,%rbx
  7eb236:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  7eb23b:	45 31 ff             	xor    %r15d,%r15d
  7eb23e:	4c 8d 6c 24 30       	lea    0x30(%rsp),%r13
  7eb243:	45 31 c9             	xor    %r9d,%r9d
  7eb246:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
  7eb24d:	48 39 fe             	cmp    %rdi,%rsi
  7eb250:	0f 82 37 09 00 00    	jb     7ebb8d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb3d>
  7eb256:	48 39 d6             	cmp    %rdx,%rsi
  7eb259:	0f 87 2e 09 00 00    	ja     7ebb8d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb3d>
  7eb25f:	4c 89 8c 24 f0 00 00 	mov    %r9,0xf0(%rsp)
  7eb266:	00 
  7eb267:	48 39 f7             	cmp    %rsi,%rdi
  7eb26a:	0f 85 f8 03 00 00    	jne    7eb668 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x618>
  7eb270:	48 83 44 24 68 70    	addq   $0x70,0x68(%rsp)
  7eb276:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  7eb27b:	ff c0                	inc    %eax
  7eb27d:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  7eb282:	49 c1 e7 03          	shl    $0x3,%r15
  7eb286:	31 db                	xor    %ebx,%ebx
  7eb288:	48 8b 6c 24 78       	mov    0x78(%rsp),%rbp
  7eb28d:	eb 05                	jmp    7eb294 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x244>
  7eb28f:	90                   	nop
  7eb290:	48 83 c3 08          	add    $0x8,%rbx
  7eb294:	49 39 df             	cmp    %rbx,%r15
  7eb297:	0f 84 a0 03 00 00    	je     7eb63d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x5ed>
  7eb29d:	41 8b 44 1d 00       	mov    0x0(%r13,%rbx,1),%eax
  7eb2a2:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  7eb2a7:	48 39 c8             	cmp    %rcx,%rax
  7eb2aa:	74 e4                	je     7eb290 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x240>
  7eb2ac:	48 8b 94 24 98 00 00 	mov    0x98(%rsp),%rdx
  7eb2b3:	00 
  7eb2b4:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  7eb2b8:	48 01 c1             	add    %rax,%rcx
  7eb2bb:	48 3b 4a 18          	cmp    0x18(%rdx),%rcx
  7eb2bf:	0f 83 f9 08 00 00    	jae    7ebbbe <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb6e>
  7eb2c5:	4c 8b b4 24 90 00 00 	mov    0x90(%rsp),%r14
  7eb2cc:	00 
  7eb2cd:	49 3b 8e 30 01 00 00 	cmp    0x130(%r14),%rcx
  7eb2d4:	0f 83 e4 08 00 00    	jae    7ebbbe <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb6e>
  7eb2da:	49 8b 96 28 01 00 00 	mov    0x128(%r14),%rdx
  7eb2e1:	48 8d 34 89          	lea    (%rcx,%rcx,4),%rsi
  7eb2e5:	48 8d 0c f2          	lea    (%rdx,%rsi,8),%rcx
  7eb2e9:	80 7c f2 21 01       	cmpb   $0x1,0x21(%rdx,%rsi,8)
  7eb2ee:	0f 84 a8 08 00 00    	je     7ebb9c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb4c>
  7eb2f4:	4c 8b 61 10          	mov    0x10(%rcx),%r12
  7eb2f8:	49 8b 76 58          	mov    0x58(%r14),%rsi
  7eb2fc:	49 39 f4             	cmp    %rsi,%r12
  7eb2ff:	0f 83 b9 08 00 00    	jae    7ebbbe <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb6e>
  7eb305:	4d 3b a6 e8 00 00 00 	cmp    0xe8(%r14),%r12
  7eb30c:	0f 83 ac 08 00 00    	jae    7ebbbe <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb6e>
  7eb312:	f3 41 0f 10 44 1d 04 	movss  0x4(%r13,%rbx,1),%xmm0
  7eb319:	8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%edx
  7eb320:	49 8b 7e 50          	mov    0x50(%r14),%rdi
  7eb324:	4f 8d 04 e4          	lea    (%r12,%r12,8),%r8
  7eb328:	49 c1 e0 04          	shl    $0x4,%r8
  7eb32c:	4f 8d 0c a4          	lea    (%r12,%r12,4),%r9
  7eb330:	49 c1 e1 04          	shl    $0x4,%r9
  7eb334:	4d 03 8e e0 00 00 00 	add    0xe0(%r14),%r9
  7eb33b:	4e 8d 14 07          	lea    (%rdi,%r8,1),%r10
  7eb33f:	4c 89 b4 24 b8 01 00 	mov    %r14,0x1b8(%rsp)
  7eb346:	00 
  7eb347:	4c 89 94 24 c0 01 00 	mov    %r10,0x1c0(%rsp)
  7eb34e:	00 
  7eb34f:	4c 89 8c 24 c8 01 00 	mov    %r9,0x1c8(%rsp)
  7eb356:	00 
  7eb357:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  7eb35e:	00 
  7eb35f:	89 94 24 d8 01 00 00 	mov    %edx,0x1d8(%rsp)
  7eb366:	89 84 24 dc 01 00 00 	mov    %eax,0x1dc(%rsp)
  7eb36d:	44 89 a4 24 e0 01 00 	mov    %r12d,0x1e0(%rsp)
  7eb374:	00 
  7eb375:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  7eb37b:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  7eb382:	00 00 
  7eb384:	42 f6 84 07 8c 00 00 	testb  $0x1,0x8c(%rdi,%r8,1)
  7eb38b:	00 01 
  7eb38d:	74 7d                	je     7eb40c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x3bc>
  7eb38f:	41 0f 10 46 68       	movups 0x68(%r14),%xmm0
  7eb394:	41 0f 10 8e 80 00 00 	movups 0x80(%r14),%xmm1
  7eb39b:	00 
  7eb39c:	41 0f 10 96 98 00 00 	movups 0x98(%r14),%xmm2
  7eb3a3:	00 
  7eb3a4:	0f 11 84 24 18 01 00 	movups %xmm0,0x118(%rsp)
  7eb3ab:	00 
  7eb3ac:	0f 11 8c 24 28 01 00 	movups %xmm1,0x128(%rsp)
  7eb3b3:	00 
  7eb3b4:	0f 11 94 24 38 01 00 	movups %xmm2,0x138(%rsp)
  7eb3bb:	00 
  7eb3bc:	48 8b 41 18          	mov    0x18(%rcx),%rax
  7eb3c0:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  7eb3c7:	00 
  7eb3c8:	48 8d bc 24 18 01 00 	lea    0x118(%rsp),%rdi
  7eb3cf:	00 
  7eb3d0:	ff 15 92 2f 34 00    	call   *0x342f92(%rip)        # b2e368 <_DYNAMIC+0xe68>
  7eb3d6:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  7eb3db:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7eb3e0:	48 29 f1             	sub    %rsi,%rcx
  7eb3e3:	48 39 c8             	cmp    %rcx,%rax
  7eb3e6:	0f 87 bd 01 00 00    	ja     7eb5a9 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x559>
  7eb3ec:	48 8d bc 24 b8 01 00 	lea    0x1b8(%rsp),%rdi
  7eb3f3:	00 
  7eb3f4:	be 01 00 00 00       	mov    $0x1,%esi
  7eb3f9:	48 8d 54 24 50       	lea    0x50(%rsp),%rdx
  7eb3fe:	48 8d 4c 24 24       	lea    0x24(%rsp),%rcx
  7eb403:	e8 a8 de 00 00       	call   7f92b0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>>
  7eb408:	49 8b 76 58          	mov    0x58(%r14),%rsi
  7eb40c:	44 89 e7             	mov    %r12d,%edi
  7eb40f:	48 c7 84 24 08 01 00 	movq   $0x0,0x108(%rsp)
  7eb416:	00 00 00 00 00 
  7eb41b:	c7 84 24 8c 00 00 00 	movl   $0x0,0x8c(%rsp)
  7eb422:	00 00 00 00 
  7eb426:	c6 44 24 0f 00       	movb   $0x0,0xf(%rsp)
  7eb42b:	48 39 fe             	cmp    %rdi,%rsi
  7eb42e:	0f 86 9a 07 00 00    	jbe    7ebbce <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb7e>
  7eb434:	41 0f 10 46 68       	movups 0x68(%r14),%xmm0
  7eb439:	41 0f 10 8e 80 00 00 	movups 0x80(%r14),%xmm1
  7eb440:	00 
  7eb441:	41 0f 10 96 98 00 00 	movups 0x98(%r14),%xmm2
  7eb448:	00 
  7eb449:	49 8b 46 50          	mov    0x50(%r14),%rax
  7eb44d:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
  7eb451:	48 c1 e1 04          	shl    $0x4,%rcx
  7eb455:	0f 11 84 24 e8 01 00 	movups %xmm0,0x1e8(%rsp)
  7eb45c:	00 
  7eb45d:	0f 11 8c 24 f8 01 00 	movups %xmm1,0x1f8(%rsp)
  7eb464:	00 
  7eb465:	0f 11 94 24 08 02 00 	movups %xmm2,0x208(%rsp)
  7eb46c:	00 
  7eb46d:	48 8b 44 08 50       	mov    0x50(%rax,%rcx,1),%rax
  7eb472:	48 89 84 24 18 02 00 	mov    %rax,0x218(%rsp)
  7eb479:	00 
  7eb47a:	48 c7 84 24 10 01 00 	movq   $0x0,0x110(%rsp)
  7eb481:	00 00 00 00 00 
  7eb486:	48 8d 84 24 e8 01 00 	lea    0x1e8(%rsp),%rax
  7eb48d:	00 
  7eb48e:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
  7eb495:	00 
  7eb496:	48 89 ac 24 20 01 00 	mov    %rbp,0x120(%rsp)
  7eb49d:	00 
  7eb49e:	48 8d 84 24 00 01 00 	lea    0x100(%rsp),%rax
  7eb4a5:	00 
  7eb4a6:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  7eb4ad:	00 
  7eb4ae:	48 8d 84 24 f8 00 00 	lea    0xf8(%rsp),%rax
  7eb4b5:	00 
  7eb4b6:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  7eb4bd:	00 
  7eb4be:	48 8d 44 24 50       	lea    0x50(%rsp),%rax
  7eb4c3:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  7eb4ca:	00 
  7eb4cb:	48 8d 84 24 10 01 00 	lea    0x110(%rsp),%rax
  7eb4d2:	00 
  7eb4d3:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  7eb4da:	00 
  7eb4db:	48 8d 44 24 24       	lea    0x24(%rsp),%rax
  7eb4e0:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  7eb4e7:	00 
  7eb4e8:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
  7eb4ed:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  7eb4f4:	00 
  7eb4f5:	48 8d 84 24 30 02 00 	lea    0x230(%rsp),%rax
  7eb4fc:	00 
  7eb4fd:	48 89 84 24 58 01 00 	mov    %rax,0x158(%rsp)
  7eb504:	00 
  7eb505:	48 8d 84 24 b8 00 00 	lea    0xb8(%rsp),%rax
  7eb50c:	00 
  7eb50d:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
  7eb514:	00 
  7eb515:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  7eb51a:	48 89 84 24 68 01 00 	mov    %rax,0x168(%rsp)
  7eb521:	00 
  7eb522:	48 8d 84 24 b0 00 00 	lea    0xb0(%rsp),%rax
  7eb529:	00 
  7eb52a:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
  7eb531:	00 
  7eb532:	48 8d 84 24 08 01 00 	lea    0x108(%rsp),%rax
  7eb539:	00 
  7eb53a:	48 89 84 24 78 01 00 	mov    %rax,0x178(%rsp)
  7eb541:	00 
  7eb542:	48 8d 84 24 90 00 00 	lea    0x90(%rsp),%rax
  7eb549:	00 
  7eb54a:	48 89 84 24 80 01 00 	mov    %rax,0x180(%rsp)
  7eb551:	00 
  7eb552:	48 8d 84 24 8c 00 00 	lea    0x8c(%rsp),%rax
  7eb559:	00 
  7eb55a:	48 89 84 24 88 01 00 	mov    %rax,0x188(%rsp)
  7eb561:	00 
  7eb562:	48 8d 84 24 a4 01 00 	lea    0x1a4(%rsp),%rax
  7eb569:	00 
  7eb56a:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  7eb571:	00 
  7eb572:	48 8d 84 24 c8 00 00 	lea    0xc8(%rsp),%rax
  7eb579:	00 
  7eb57a:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  7eb581:	00 
  7eb582:	48 8d bc 24 b8 01 00 	lea    0x1b8(%rsp),%rdi
  7eb589:	00 
  7eb58a:	31 f6                	xor    %esi,%esi
  7eb58c:	48 8d 94 24 18 01 00 	lea    0x118(%rsp),%rdx
  7eb593:	00 
  7eb594:	e8 37 d6 00 00       	call   7f8bd0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>>
  7eb599:	41 89 c6             	mov    %eax,%r14d
  7eb59c:	3c 02                	cmp    $0x2,%al
  7eb59e:	0f 84 ec fc ff ff    	je     7eb290 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x240>
  7eb5a4:	e9 59 05 00 00       	jmp    7ebb02 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  7eb5a9:	b9 04 00 00 00       	mov    $0x4,%ecx
  7eb5ae:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  7eb5b4:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  7eb5b9:	48 89 c2             	mov    %rax,%rdx
  7eb5bc:	e8 ff 64 01 00       	call   801ac0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  7eb5c1:	e9 26 fe ff ff       	jmp    7eb3ec <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x39c>
  7eb5c6:	48 8d 04 fd 00 00 00 	lea    0x0(,%rdi,8),%rax
  7eb5cd:	00 
  7eb5ce:	48 8d 2c 80          	lea    (%rax,%rax,4),%rbp
  7eb5d2:	48 8d 04 f5 00 00 00 	lea    0x0(,%rsi,8),%rax
  7eb5d9:	00 
  7eb5da:	48 8d 1c 80          	lea    (%rax,%rax,4),%rbx
  7eb5de:	49 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%r9
  7eb5e5:	48 89 e9             	mov    %rbp,%rcx
  7eb5e8:	31 c0                	xor    %eax,%eax
  7eb5ea:	45 31 ed             	xor    %r13d,%r13d
  7eb5ed:	eb 0e                	jmp    7eb5fd <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x5ad>
  7eb5ef:	90                   	nop
  7eb5f0:	48 83 c1 28          	add    $0x28,%rcx
  7eb5f4:	48 39 cb             	cmp    %rcx,%rbx
  7eb5f7:	0f 84 df 01 00 00    	je     7eb7dc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x78c>
  7eb5fd:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  7eb602:	80 7c 0a 21 00       	cmpb   $0x0,0x21(%rdx,%rcx,1)
  7eb607:	75 e7                	jne    7eb5f0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x5a0>
  7eb609:	48 8b 54 0a 10       	mov    0x10(%rdx,%rcx,1),%rdx
  7eb60e:	48 3b 94 24 e8 00 00 	cmp    0xe8(%rsp),%rdx
  7eb615:	00 
  7eb616:	0f 83 e6 04 00 00    	jae    7ebb02 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  7eb61c:	48 3b 94 24 e0 00 00 	cmp    0xe0(%rsp),%rdx
  7eb623:	00 
  7eb624:	0f 83 d8 04 00 00    	jae    7ebb02 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  7eb62a:	4c 39 ca             	cmp    %r9,%rdx
  7eb62d:	4c 0f 42 ca          	cmovb  %rdx,%r9
  7eb631:	48 39 c2             	cmp    %rax,%rdx
  7eb634:	48 0f 47 c2          	cmova  %rdx,%rax
  7eb638:	49 ff c5             	inc    %r13
  7eb63b:	eb b3                	jmp    7eb5f0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x5a0>
  7eb63d:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  7eb642:	48 3b 8c 24 d0 00 00 	cmp    0xd0(%rsp),%rcx
  7eb649:	00 
  7eb64a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  7eb650:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  7eb657:	00 
  7eb658:	4c 8b 4c 24 70       	mov    0x70(%rsp),%r9
  7eb65d:	0f 85 78 fb ff ff    	jne    7eb1db <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x18b>
  7eb663:	e9 34 03 00 00       	jmp    7eb99c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x94c>
  7eb668:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  7eb66d:	f3 0f 10 48 28       	movss  0x28(%rax),%xmm1
  7eb672:	8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%eax
  7eb679:	89 84 24 84 00 00 00 	mov    %eax,0x84(%rsp)
  7eb680:	48 c1 e7 03          	shl    $0x3,%rdi
  7eb684:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  7eb688:	4c 8b b3 28 01 00 00 	mov    0x128(%rbx),%r14
  7eb68f:	49 01 c6             	add    %rax,%r14
  7eb692:	48 c1 e6 03          	shl    $0x3,%rsi
  7eb696:	48 8d 2c b6          	lea    (%rsi,%rsi,4),%rbp
  7eb69a:	48 29 c5             	sub    %rax,%rbp
  7eb69d:	45 31 e4             	xor    %r12d,%r12d
  7eb6a0:	eb 2c                	jmp    7eb6ce <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x67e>
  7eb6a2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7eb6a9:	1f 84 00 00 00 00 00 
  7eb6b0:	f3 0f 10 8c 24 88 00 	movss  0x88(%rsp),%xmm1
  7eb6b7:	00 00 
  7eb6b9:	49 83 c6 28          	add    $0x28,%r14
  7eb6bd:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  7eb6c1:	49 ff c4             	inc    %r12
  7eb6c4:	48 83 c5 d8          	add    $0xffffffffffffffd8,%rbp
  7eb6c8:	0f 84 a2 fb ff ff    	je     7eb270 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x220>
  7eb6ce:	49 8b 7e 10          	mov    0x10(%r14),%rdi
  7eb6d2:	41 80 7e 21 01       	cmpb   $0x1,0x21(%r14)
  7eb6d7:	75 27                	jne    7eb700 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x6b0>
  7eb6d9:	48 8b 73 40          	mov    0x40(%rbx),%rsi
  7eb6dd:	48 39 f7             	cmp    %rsi,%rdi
  7eb6e0:	0f 83 f1 04 00 00    	jae    7ebbd7 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb87>
  7eb6e6:	48 8b 43 38          	mov    0x38(%rbx),%rax
  7eb6ea:	48 6b cf 38          	imul   $0x38,%rdi,%rcx
  7eb6ee:	f3 0f 10 44 08 24    	movss  0x24(%rax,%rcx,1),%xmm0
  7eb6f4:	eb c3                	jmp    7eb6b9 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x669>
  7eb6f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  7eb6fd:	00 00 00 
  7eb700:	48 8b 73 58          	mov    0x58(%rbx),%rsi
  7eb704:	48 39 f7             	cmp    %rsi,%rdi
  7eb707:	0f 83 d3 04 00 00    	jae    7ebbe0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb90>
  7eb70d:	48 8b b3 e8 00 00 00 	mov    0xe8(%rbx),%rsi
  7eb714:	48 39 f7             	cmp    %rsi,%rdi
  7eb717:	0f 83 cc 04 00 00    	jae    7ebbe9 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb99>
  7eb71d:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
  7eb721:	48 c1 e0 04          	shl    $0x4,%rax
  7eb725:	48 03 43 50          	add    0x50(%rbx),%rax
  7eb729:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  7eb72d:	48 c1 e1 04          	shl    $0x4,%rcx
  7eb731:	48 03 8b e0 00 00 00 	add    0xe0(%rbx),%rcx
  7eb738:	48 89 9c 24 18 01 00 	mov    %rbx,0x118(%rsp)
  7eb73f:	00 
  7eb740:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  7eb747:	00 
  7eb748:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  7eb74f:	00 
  7eb750:	4c 89 b4 24 30 01 00 	mov    %r14,0x130(%rsp)
  7eb757:	00 
  7eb758:	8b 84 24 84 00 00 00 	mov    0x84(%rsp),%eax
  7eb75f:	89 84 24 38 01 00 00 	mov    %eax,0x138(%rsp)
  7eb766:	44 89 a4 24 3c 01 00 	mov    %r12d,0x13c(%rsp)
  7eb76d:	00 
  7eb76e:	89 bc 24 40 01 00 00 	mov    %edi,0x140(%rsp)
  7eb775:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  7eb77c:	00 
  7eb77d:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  7eb782:	48 8b 79 10          	mov    0x10(%rcx),%rdi
  7eb786:	4c 01 e7             	add    %r12,%rdi
  7eb789:	48 8b b0 30 01 00 00 	mov    0x130(%rax),%rsi
  7eb790:	48 39 f7             	cmp    %rsi,%rdi
  7eb793:	0f 83 59 04 00 00    	jae    7ebbf2 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xba2>
  7eb799:	48 8b 80 28 01 00 00 	mov    0x128(%rax),%rax
  7eb7a0:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  7eb7a4:	48 8b 7c c8 10       	mov    0x10(%rax,%rcx,8),%rdi
  7eb7a9:	48 2b bc 24 f0 00 00 	sub    0xf0(%rsp),%rdi
  7eb7b0:	00 
  7eb7b1:	4c 39 ff             	cmp    %r15,%rdi
  7eb7b4:	0f 83 41 04 00 00    	jae    7ebbfb <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbab>
  7eb7ba:	f3 0f 11 8c 24 88 00 	movss  %xmm1,0x88(%rsp)
  7eb7c1:	00 00 
  7eb7c3:	f3 41 0f 11 4c fd 04 	movss  %xmm1,0x4(%r13,%rdi,8)
  7eb7ca:	48 8d bc 24 18 01 00 	lea    0x118(%rsp),%rdi
  7eb7d1:	00 
  7eb7d2:	e8 79 eb 00 00       	call   7fa350 <<parley::layout::run::Run<()>>::advance>
  7eb7d7:	e9 d4 fe ff ff       	jmp    7eb6b0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x660>
  7eb7dc:	49 83 f9 ff          	cmp    $0xffffffffffffffff,%r9
  7eb7e0:	74 32                	je     7eb814 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x7c4>
  7eb7e2:	48 89 c1             	mov    %rax,%rcx
  7eb7e5:	4c 29 c9             	sub    %r9,%rcx
  7eb7e8:	0f 82 14 03 00 00    	jb     7ebb02 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  7eb7ee:	48 ff c1             	inc    %rcx
  7eb7f1:	4c 39 e9             	cmp    %r13,%rcx
  7eb7f4:	0f 85 08 03 00 00    	jne    7ebb02 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  7eb7fa:	4c 39 c8             	cmp    %r9,%rax
  7eb7fd:	75 29                	jne    7eb828 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x7d8>
  7eb7ff:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
  7eb804:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  7eb80a:	4c 8d 6c 24 30       	lea    0x30(%rsp),%r13
  7eb80f:	e9 c6 00 00 00       	jmp    7eb8da <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x88a>
  7eb814:	48 8b 5c 24 78       	mov    0x78(%rsp),%rbx
  7eb819:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  7eb81e:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7eb823:	e9 13 fa ff ff       	jmp    7eb23b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x1eb>
  7eb828:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
  7eb82f:	00 00 
  7eb831:	4d 85 ed             	test   %r13,%r13
  7eb834:	74 2f                	je     7eb865 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x815>
  7eb836:	4c 3b 6c 24 38       	cmp    0x38(%rsp),%r13
  7eb83b:	0f 87 1e 01 00 00    	ja     7eb95f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x90f>
  7eb841:	45 31 ff             	xor    %r15d,%r15d
  7eb844:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  7eb849:	4a 8d 04 ff          	lea    (%rdi,%r15,8),%rax
  7eb84d:	49 83 fd 01          	cmp    $0x1,%r13
  7eb851:	74 72                	je     7eb8c5 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x875>
  7eb853:	b9 01 00 00 00       	mov    $0x1,%ecx
  7eb858:	49 83 fd 05          	cmp    $0x5,%r13
  7eb85c:	73 0c                	jae    7eb86a <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x81a>
  7eb85e:	be ff ff ff ff       	mov    $0xffffffff,%esi
  7eb863:	eb 48                	jmp    7eb8ad <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x85d>
  7eb865:	45 31 ff             	xor    %r15d,%r15d
  7eb868:	eb 66                	jmp    7eb8d0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x880>
  7eb86a:	49 8d 55 ff          	lea    -0x1(%r13),%rdx
  7eb86e:	48 89 d6             	mov    %rdx,%rsi
  7eb871:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
  7eb875:	48 8d 04 f0          	lea    (%rax,%rsi,8),%rax
  7eb879:	48 8d 4e 01          	lea    0x1(%rsi),%rcx
  7eb87d:	4a 8d 3c ff          	lea    (%rdi,%r15,8),%rdi
  7eb881:	48 83 c7 10          	add    $0x10,%rdi
  7eb885:	45 31 c0             	xor    %r8d,%r8d
  7eb888:	0f 28 05 41 55 91 ff 	movaps -0x6eaabf(%rip),%xmm0        # 100dd0 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0x1180>
  7eb88f:	42 0f 11 44 c7 f0    	movups %xmm0,-0x10(%rdi,%r8,8)
  7eb895:	42 0f 11 04 c7       	movups %xmm0,(%rdi,%r8,8)
  7eb89a:	49 83 c0 04          	add    $0x4,%r8
  7eb89e:	4c 39 c6             	cmp    %r8,%rsi
  7eb8a1:	75 ec                	jne    7eb88f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x83f>
  7eb8a3:	48 39 f2             	cmp    %rsi,%rdx
  7eb8a6:	be ff ff ff ff       	mov    $0xffffffff,%esi
  7eb8ab:	74 12                	je     7eb8bf <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x86f>
  7eb8ad:	4c 89 ea             	mov    %r13,%rdx
  7eb8b0:	48 29 ca             	sub    %rcx,%rdx
  7eb8b3:	48 89 30             	mov    %rsi,(%rax)
  7eb8b6:	48 83 c0 08          	add    $0x8,%rax
  7eb8ba:	48 ff ca             	dec    %rdx
  7eb8bd:	75 f4                	jne    7eb8b3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x863>
  7eb8bf:	4d 01 ef             	add    %r13,%r15
  7eb8c2:	49 ff cf             	dec    %r15
  7eb8c5:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  7eb8ca:	48 89 08             	mov    %rcx,(%rax)
  7eb8cd:	49 ff c7             	inc    %r15
  7eb8d0:	4c 89 7c 24 48       	mov    %r15,0x48(%rsp)
  7eb8d5:	4c 8b 6c 24 40       	mov    0x40(%rsp),%r13
  7eb8da:	31 c0                	xor    %eax,%eax
  7eb8dc:	eb 13                	jmp    7eb8f1 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x8a1>
  7eb8de:	66 90                	xchg   %ax,%ax
  7eb8e0:	41 89 44 fd 00       	mov    %eax,0x0(%r13,%rdi,8)
  7eb8e5:	48 83 c5 28          	add    $0x28,%rbp
  7eb8e9:	48 ff c0             	inc    %rax
  7eb8ec:	48 39 eb             	cmp    %rbp,%rbx
  7eb8ef:	74 3c                	je     7eb92d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x8dd>
  7eb8f1:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  7eb8f6:	80 7c 29 21 00       	cmpb   $0x0,0x21(%rcx,%rbp,1)
  7eb8fb:	75 e8                	jne    7eb8e5 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x895>
  7eb8fd:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  7eb902:	48 8b 7c 29 10       	mov    0x10(%rcx,%rbp,1),%rdi
  7eb907:	4c 29 cf             	sub    %r9,%rdi
  7eb90a:	4c 39 ff             	cmp    %r15,%rdi
  7eb90d:	0f 83 04 03 00 00    	jae    7ebc17 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbc7>
  7eb913:	41 83 7c fd 00 ff    	cmpl   $0xffffffff,0x0(%r13,%rdi,8)
  7eb919:	0f 85 e3 01 00 00    	jne    7ebb02 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  7eb91f:	48 89 c1             	mov    %rax,%rcx
  7eb922:	48 c1 e9 20          	shr    $0x20,%rcx
  7eb926:	74 b8                	je     7eb8e0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x890>
  7eb928:	e9 d5 01 00 00       	jmp    7ebb02 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  7eb92d:	48 8b 9c 24 90 00 00 	mov    0x90(%rsp),%rbx
  7eb934:	00 
  7eb935:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  7eb93c:	00 
  7eb93d:	48 8b 78 10          	mov    0x10(%rax),%rdi
  7eb941:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7eb946:	48 8b 70 18          	mov    0x18(%rax),%rsi
  7eb94a:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
  7eb951:	48 39 fe             	cmp    %rdi,%rsi
  7eb954:	0f 83 fc f8 ff ff    	jae    7eb256 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x206>
  7eb95a:	e9 2e 02 00 00       	jmp    7ebb8d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb3d>
  7eb95f:	4d 89 cc             	mov    %r9,%r12
  7eb962:	b9 04 00 00 00       	mov    $0x4,%ecx
  7eb967:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  7eb96d:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  7eb972:	31 f6                	xor    %esi,%esi
  7eb974:	4c 89 ea             	mov    %r13,%rdx
  7eb977:	e8 44 61 01 00       	call   801ac0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  7eb97c:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  7eb981:	4d 89 e1             	mov    %r12,%r9
  7eb984:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  7eb989:	4a 8d 04 ff          	lea    (%rdi,%r15,8),%rax
  7eb98d:	49 83 fd 01          	cmp    $0x1,%r13
  7eb991:	0f 85 bc fe ff ff    	jne    7eb853 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x803>
  7eb997:	e9 29 ff ff ff       	jmp    7eb8c5 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x875>
  7eb99c:	4c 8d bc 24 20 01 00 	lea    0x120(%rsp),%r15
  7eb9a3:	00 
  7eb9a4:	31 ed                	xor    %ebp,%ebp
  7eb9a6:	4c 8d a4 24 e8 01 00 	lea    0x1e8(%rsp),%r12
  7eb9ad:	00 
  7eb9ae:	48 8b 1d 5b 29 34 00 	mov    0x34295b(%rip),%rbx        # b2e310 <_DYNAMIC+0xe10>
  7eb9b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  7eb9bc:	00 00 00 00 
  7eb9c0:	4c 8b b4 24 30 02 00 	mov    0x230(%rsp),%r14
  7eb9c7:	00 
  7eb9c8:	49 83 fe 02          	cmp    $0x2,%r14
  7eb9cc:	75 20                	jne    7eb9ee <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x99e>
  7eb9ce:	48 8d bc 24 40 02 00 	lea    0x240(%rsp),%rdi
  7eb9d5:	00 
  7eb9d6:	e8 c5 23 02 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7eb9db:	49 89 c6             	mov    %rax,%r14
  7eb9de:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  7eb9e5:	00 
  7eb9e6:	48 89 94 24 38 02 00 	mov    %rdx,0x238(%rsp)
  7eb9ed:	00 
  7eb9ee:	49 83 fe 01          	cmp    $0x1,%r14
  7eb9f2:	0f 85 0a 01 00 00    	jne    7ebb02 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  7eb9f8:	4c 8b ac 24 38 02 00 	mov    0x238(%rsp),%r13
  7eb9ff:	00 
  7eba00:	83 bc 24 b8 00 00 00 	cmpl   $0x1,0xb8(%rsp)
  7eba07:	01 
  7eba08:	75 0e                	jne    7eba18 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x9c8>
  7eba0a:	4c 3b ac 24 c0 00 00 	cmp    0xc0(%rsp),%r13
  7eba11:	00 
  7eba12:	0f 82 ea 00 00 00    	jb     7ebb02 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  7eba18:	48 c7 84 24 30 02 00 	movq   $0x2,0x230(%rsp)
  7eba1f:	00 02 00 00 00 
  7eba24:	48 c7 84 24 b8 00 00 	movq   $0x1,0xb8(%rsp)
  7eba2b:	00 01 00 00 00 
  7eba30:	4c 39 ac 24 c8 00 00 	cmp    %r13,0xc8(%rsp)
  7eba37:	00 
  7eba38:	b9 00 00 00 00       	mov    $0x0,%ecx
  7eba3d:	48 8d 84 24 a8 01 00 	lea    0x1a8(%rsp),%rax
  7eba44:	00 
  7eba45:	48 0f 44 c8          	cmove  %rax,%rcx
  7eba49:	80 bc 24 a4 01 00 00 	cmpb   $0x0,0x1a4(%rsp)
  7eba50:	00 
  7eba51:	4c 89 ac 24 c0 00 00 	mov    %r13,0xc0(%rsp)
  7eba58:	00 
  7eba59:	48 0f 44 cd          	cmove  %rbp,%rcx
  7eba5d:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  7eba63:	4c 89 e7             	mov    %r12,%rdi
  7eba66:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  7eba6b:	4c 89 ea             	mov    %r13,%rdx
  7eba6e:	45 31 c0             	xor    %r8d,%r8d
  7eba71:	ff d3                	call   *%rbx
  7eba73:	48 8b 84 24 28 02 00 	mov    0x228(%rsp),%rax
  7eba7a:	00 
  7eba7b:	49 89 47 40          	mov    %rax,0x40(%r15)
  7eba7f:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  7eba86:	00 
  7eba87:	0f 10 8c 24 f8 01 00 	movups 0x1f8(%rsp),%xmm1
  7eba8e:	00 
  7eba8f:	0f 10 94 24 08 02 00 	movups 0x208(%rsp),%xmm2
  7eba96:	00 
  7eba97:	0f 10 9c 24 18 02 00 	movups 0x218(%rsp),%xmm3
  7eba9e:	00 
  7eba9f:	41 0f 11 5f 30       	movups %xmm3,0x30(%r15)
  7ebaa4:	41 0f 11 57 20       	movups %xmm2,0x20(%r15)
  7ebaa9:	41 0f 11 4f 10       	movups %xmm1,0x10(%r15)
  7ebaae:	41 0f 11 07          	movups %xmm0,(%r15)
  7ebab2:	4c 8b b4 24 b0 00 00 	mov    0xb0(%rsp),%r14
  7ebab9:	00 
  7ebaba:	4c 89 ac 24 18 01 00 	mov    %r13,0x118(%rsp)
  7ebac1:	00 
  7ebac2:	83 bc 24 20 01 00 00 	cmpl   $0x1,0x120(%rsp)
  7ebac9:	01 
  7ebaca:	0f 85 f0 fe ff ff    	jne    7eb9c0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x970>
  7ebad0:	49 8b 7e 08          	mov    0x8(%r14),%rdi
  7ebad4:	49 8b 76 10          	mov    0x10(%r14),%rsi
  7ebad8:	49 8b 46 18          	mov    0x18(%r14),%rax
  7ebadc:	48 8b 10             	mov    (%rax),%rdx
  7ebadf:	49 8b 46 20          	mov    0x20(%r14),%rax
  7ebae3:	f3 0f 10 00          	movss  (%rax),%xmm0
  7ebae7:	4c 89 e9             	mov    %r13,%rcx
  7ebaea:	4d 89 f8             	mov    %r15,%r8
  7ebaed:	e8 de 77 00 00       	call   7f32d0 <gpui_canvas::text::planner::append_caret>
  7ebaf2:	83 f8 ff             	cmp    $0xffffffff,%eax
  7ebaf5:	0f 95 c0             	setne  %al
  7ebaf8:	49 8b 0e             	mov    (%r14),%rcx
  7ebafb:	08 01                	or     %al,(%rcx)
  7ebafd:	e9 be fe ff ff       	jmp    7eb9c0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x970>
  7ebb02:	48 8b b4 24 40 02 00 	mov    0x240(%rsp),%rsi
  7ebb09:	00 
  7ebb0a:	48 85 f6             	test   %rsi,%rsi
  7ebb0d:	74 17                	je     7ebb26 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xad6>
  7ebb0f:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  7ebb16:	00 
  7ebb17:	48 c1 e6 03          	shl    $0x3,%rsi
  7ebb1b:	ba 08 00 00 00       	mov    $0x8,%edx
  7ebb20:	ff 15 22 1c 34 00    	call   *0x341c22(%rip)        # b2d748 <_DYNAMIC+0x248>
  7ebb26:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  7ebb2b:	48 85 f6             	test   %rsi,%rsi
  7ebb2e:	74 14                	je     7ebb44 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xaf4>
  7ebb30:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  7ebb35:	48 c1 e6 02          	shl    $0x2,%rsi
  7ebb39:	ba 04 00 00 00       	mov    $0x4,%edx
  7ebb3e:	ff 15 04 1c 34 00    	call   *0x341c04(%rip)        # b2d748 <_DYNAMIC+0x248>
  7ebb44:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  7ebb49:	48 85 f6             	test   %rsi,%rsi
  7ebb4c:	74 14                	je     7ebb62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb12>
  7ebb4e:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  7ebb53:	48 c1 e6 03          	shl    $0x3,%rsi
  7ebb57:	ba 04 00 00 00       	mov    $0x4,%edx
  7ebb5c:	ff 15 e6 1b 34 00    	call   *0x341be6(%rip)        # b2d748 <_DYNAMIC+0x248>
  7ebb62:	41 80 e6 01          	and    $0x1,%r14b
  7ebb66:	44 89 f0             	mov    %r14d,%eax
  7ebb69:	48 81 c4 d8 02 00 00 	add    $0x2d8,%rsp
  7ebb70:	5b                   	pop    %rbx
  7ebb71:	41 5c                	pop    %r12
  7ebb73:	41 5d                	pop    %r13
  7ebb75:	41 5e                	pop    %r14
  7ebb77:	41 5f                	pop    %r15
  7ebb79:	5d                   	pop    %rbp
  7ebb7a:	c3                   	ret
  7ebb7b:	48 8d 0d ce ba 31 00 	lea    0x31bace(%rip),%rcx        # b07650 <anon.ee2cf06d9598ac3323a1e4b3d9cbfdc3.3.llvm.17696767679096401280+0x60>
  7ebb82:	ff 15 08 1c 34 00    	call   *0x341c08(%rip)        # b2d790 <_DYNAMIC+0x290>
  7ebb88:	e9 88 00 00 00       	jmp    7ebc15 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbc5>
  7ebb8d:	48 8d 0d a4 c3 31 00 	lea    0x31c3a4(%rip),%rcx        # b07f38 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.37.llvm.14379316919819170204>
  7ebb94:	ff 15 f6 1b 34 00    	call   *0x341bf6(%rip)        # b2d790 <_DYNAMIC+0x290>
  7ebb9a:	eb 79                	jmp    7ebc15 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbc5>
  7ebb9c:	48 8b 41 10          	mov    0x10(%rcx),%rax
  7ebba0:	49 3b 46 40          	cmp    0x40(%r14),%rax
  7ebba4:	48 8d 05 d5 ba 31 00 	lea    0x31bad5(%rip),%rax        # b07680 <anon.ee2cf06d9598ac3323a1e4b3d9cbfdc3.3.llvm.17696767679096401280+0x90>
  7ebbab:	48 8d 0d b6 ba 31 00 	lea    0x31bab6(%rip),%rcx        # b07668 <anon.ee2cf06d9598ac3323a1e4b3d9cbfdc3.3.llvm.17696767679096401280+0x78>
  7ebbb2:	48 0f 42 c8          	cmovb  %rax,%rcx
  7ebbb6:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
  7ebbbd:	00 
  7ebbbe:	48 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%rdi
  7ebbc5:	00 
  7ebbc6:	ff 15 bc 1b 34 00    	call   *0x341bbc(%rip)        # b2d788 <_DYNAMIC+0x288>
  7ebbcc:	eb 47                	jmp    7ebc15 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbc5>
  7ebbce:	48 8d 05 73 bb 31 00 	lea    0x31bb73(%rip),%rax        # b07748 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x20>
  7ebbd5:	eb 2e                	jmp    7ebc05 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbb5>
  7ebbd7:	48 8d 05 32 bb 31 00 	lea    0x31bb32(%rip),%rax        # b07710 <anon.8b5fc042aaf44ecdb8851cb64b83294a.9.llvm.11756661080873179907+0x48>
  7ebbde:	eb 25                	jmp    7ebc05 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbb5>
  7ebbe0:	48 8d 05 f9 ba 31 00 	lea    0x31baf9(%rip),%rax        # b076e0 <anon.8b5fc042aaf44ecdb8851cb64b83294a.9.llvm.11756661080873179907+0x18>
  7ebbe7:	eb 1c                	jmp    7ebc05 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbb5>
  7ebbe9:	48 8d 05 08 bb 31 00 	lea    0x31bb08(%rip),%rax        # b076f8 <anon.8b5fc042aaf44ecdb8851cb64b83294a.9.llvm.11756661080873179907+0x30>
  7ebbf0:	eb 13                	jmp    7ebc05 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbb5>
  7ebbf2:	48 8d 05 9f ba 31 00 	lea    0x31ba9f(%rip),%rax        # b07698 <anon.ee2cf06d9598ac3323a1e4b3d9cbfdc3.3.llvm.17696767679096401280+0xa8>
  7ebbf9:	eb 0a                	jmp    7ebc05 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbb5>
  7ebbfb:	4c 89 fe             	mov    %r15,%rsi
  7ebbfe:	48 8d 05 ab ba 31 00 	lea    0x31baab(%rip),%rax        # b076b0 <anon.ee2cf06d9598ac3323a1e4b3d9cbfdc3.3.llvm.17696767679096401280+0xc0>
  7ebc05:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7ebc0a:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  7ebc0f:	ff 15 bb 1b 34 00    	call   *0x341bbb(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ebc15:	0f 0b                	ud2
  7ebc17:	4c 89 fe             	mov    %r15,%rsi
  7ebc1a:	eb ee                	jmp    7ebc0a <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbba>
  7ebc1c:	eb 08                	jmp    7ebc26 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbd6>
  7ebc1e:	eb 06                	jmp    7ebc26 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbd6>
  7ebc20:	eb 04                	jmp    7ebc26 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbd6>
  7ebc22:	eb 02                	jmp    7ebc26 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbd6>
  7ebc24:	eb 00                	jmp    7ebc26 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbd6>
  7ebc26:	48 89 c3             	mov    %rax,%rbx
  7ebc29:	48 8b b4 24 40 02 00 	mov    0x240(%rsp),%rsi
  7ebc30:	00 
  7ebc31:	48 85 f6             	test   %rsi,%rsi
  7ebc34:	75 1c                	jne    7ebc52 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xc02>
  7ebc36:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  7ebc3b:	48 85 f6             	test   %rsi,%rsi
  7ebc3e:	75 33                	jne    7ebc73 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xc23>
  7ebc40:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  7ebc45:	48 85 f6             	test   %rsi,%rsi
  7ebc48:	75 47                	jne    7ebc91 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xc41>
  7ebc4a:	48 89 df             	mov    %rbx,%rdi
  7ebc4d:	e8 de 78 31 00       	call   b03530 <_Unwind_Resume@plt>
  7ebc52:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  7ebc59:	00 
  7ebc5a:	48 c1 e6 03          	shl    $0x3,%rsi
  7ebc5e:	ba 08 00 00 00       	mov    $0x8,%edx
  7ebc63:	ff 15 df 1a 34 00    	call   *0x341adf(%rip)        # b2d748 <_DYNAMIC+0x248>
  7ebc69:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  7ebc6e:	48 85 f6             	test   %rsi,%rsi
  7ebc71:	74 cd                	je     7ebc40 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbf0>
  7ebc73:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  7ebc78:	48 c1 e6 02          	shl    $0x2,%rsi
  7ebc7c:	ba 04 00 00 00       	mov    $0x4,%edx
  7ebc81:	ff 15 c1 1a 34 00    	call   *0x341ac1(%rip)        # b2d748 <_DYNAMIC+0x248>
  7ebc87:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  7ebc8c:	48 85 f6             	test   %rsi,%rsi
  7ebc8f:	74 b9                	je     7ebc4a <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbfa>
  7ebc91:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  7ebc96:	48 c1 e6 03          	shl    $0x3,%rsi
  7ebc9a:	ba 04 00 00 00       	mov    $0x4,%edx
  7ebc9f:	ff 15 a3 1a 34 00    	call   *0x341aa3(%rip)        # b2d748 <_DYNAMIC+0x248>
  7ebca5:	48 89 df             	mov    %rbx,%rdi
  7ebca8:	e8 83 78 31 00       	call   b03530 <_Unwind_Resume@plt>

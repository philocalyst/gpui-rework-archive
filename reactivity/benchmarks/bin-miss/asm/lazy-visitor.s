
/tmp/gpui-lazy-bins-target/release/deps/bin_phase-d773cf8873bbe22b:     file format elf64-x86-64


Disassembly of section .text:

0000000000086900 <gpui_canvas::canvas::visit_tiles::<<gpui_canvas::canvas::bins::RasterScratch>::prepare::{closure#2}>>:
   86900:	41 57                	push   %r15
   86902:	41 56                	push   %r14
   86904:	41 54                	push   %r12
   86906:	53                   	push   %rbx
   86907:	50                   	push   %rax
   86908:	48 8b 4f 78          	mov    0x78(%rdi),%rcx
   8690c:	48 8b 46 08          	mov    0x8(%rsi),%rax
   86910:	48 c1 e9 04          	shr    $0x4,%rcx
   86914:	48 39 c8             	cmp    %rcx,%rax
   86917:	48 0f 47 c8          	cmova  %rax,%rcx
   8691b:	4c 8b 8f 88 00 00 00 	mov    0x88(%rdi),%r9
   86922:	4d 89 c8             	mov    %r9,%r8
   86925:	49 c1 e8 04          	shr    $0x4,%r8
   86929:	41 83 e1 0f          	and    $0xf,%r9d
   8692d:	49 83 f9 01          	cmp    $0x1,%r9
   86931:	49 83 d8 ff          	sbb    $0xffffffffffffffff,%r8
   86935:	4c 8b 4e 18          	mov    0x18(%rsi),%r9
   86939:	4d 39 c1             	cmp    %r8,%r9
   8693c:	4d 0f 42 c1          	cmovb  %r9,%r8
   86940:	4c 39 c1             	cmp    %r8,%rcx
   86943:	0f 83 bd 00 00 00    	jae    86a06 <gpui_canvas::canvas::visit_tiles::<<gpui_canvas::canvas::bins::RasterScratch>::prepare::{closure#2}>+0x106>
   86949:	4c 8b 3e             	mov    (%rsi),%r15
   8694c:	4c 8b 4f 70          	mov    0x70(%rdi),%r9
   86950:	49 c1 e9 04          	shr    $0x4,%r9
   86954:	4d 39 cf             	cmp    %r9,%r15
   86957:	4d 0f 47 cf          	cmova  %r15,%r9
   8695b:	4c 8b 56 10          	mov    0x10(%rsi),%r10
   8695f:	48 8b b7 80 00 00 00 	mov    0x80(%rdi),%rsi
   86966:	49 89 f3             	mov    %rsi,%r11
   86969:	49 c1 eb 04          	shr    $0x4,%r11
   8696d:	83 e6 0f             	and    $0xf,%esi
   86970:	48 83 fe 01          	cmp    $0x1,%rsi
   86974:	49 83 db ff          	sbb    $0xffffffffffffffff,%r11
   86978:	4d 39 da             	cmp    %r11,%r10
   8697b:	4d 0f 42 da          	cmovb  %r10,%r11
   8697f:	4d 29 cb             	sub    %r9,%r11
   86982:	0f 86 7e 00 00 00    	jbe    86a06 <gpui_canvas::canvas::visit_tiles::<<gpui_canvas::canvas::bins::RasterScratch>::prepare::{closure#2}>+0x106>
   86988:	4d 29 fa             	sub    %r15,%r10
   8698b:	48 8b 5a 10          	mov    0x10(%rdx),%rbx
   8698f:	4c 8b 32             	mov    (%rdx),%r14
   86992:	48 8b 52 08          	mov    0x8(%rdx),%rdx
   86996:	48 89 ce             	mov    %rcx,%rsi
   86999:	48 29 c6             	sub    %rax,%rsi
   8699c:	49 0f af f2          	imul   %r10,%rsi
   869a0:	49 01 f1             	add    %rsi,%r9
   869a3:	4d 29 f9             	sub    %r15,%r9
   869a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   869ad:	00 00 00 
   869b0:	48 ff c1             	inc    %rcx
   869b3:	4c 89 cf             	mov    %r9,%rdi
   869b6:	4d 89 df             	mov    %r11,%r15
   869b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   869c0:	48 8b 72 10          	mov    0x10(%rdx),%rsi
   869c4:	48 39 f7             	cmp    %rsi,%rdi
   869c7:	73 49                	jae    86a12 <gpui_canvas::canvas::visit_tiles::<<gpui_canvas::canvas::bins::RasterScratch>::prepare::{closure#2}>+0x112>
   869c9:	48 8b 42 08          	mov    0x8(%rdx),%rax
   869cd:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
   869d1:	49 8b 76 10          	mov    0x10(%r14),%rsi
   869d5:	48 39 f0             	cmp    %rsi,%rax
   869d8:	73 45                	jae    86a1f <gpui_canvas::canvas::visit_tiles::<<gpui_canvas::canvas::bins::RasterScratch>::prepare::{closure#2}>+0x11f>
   869da:	48 8b 33             	mov    (%rbx),%rsi
   869dd:	4d 8b 66 08          	mov    0x8(%r14),%r12
   869e1:	41 89 34 84          	mov    %esi,(%r12,%rax,4)
   869e5:	48 8b 72 10          	mov    0x10(%rdx),%rsi
   869e9:	48 39 f7             	cmp    %rsi,%rdi
   869ec:	73 41                	jae    86a2f <gpui_canvas::canvas::visit_tiles::<<gpui_canvas::canvas::bins::RasterScratch>::prepare::{closure#2}>+0x12f>
   869ee:	48 8b 42 08          	mov    0x8(%rdx),%rax
   869f2:	48 ff 04 f8          	incq   (%rax,%rdi,8)
   869f6:	48 ff c7             	inc    %rdi
   869f9:	49 ff cf             	dec    %r15
   869fc:	75 c2                	jne    869c0 <gpui_canvas::canvas::visit_tiles::<<gpui_canvas::canvas::bins::RasterScratch>::prepare::{closure#2}>+0xc0>
   869fe:	4d 01 d1             	add    %r10,%r9
   86a01:	4c 39 c1             	cmp    %r8,%rcx
   86a04:	75 aa                	jne    869b0 <gpui_canvas::canvas::visit_tiles::<<gpui_canvas::canvas::bins::RasterScratch>::prepare::{closure#2}>+0xb0>
   86a06:	48 83 c4 08          	add    $0x8,%rsp
   86a0a:	5b                   	pop    %rbx
   86a0b:	41 5c                	pop    %r12
   86a0d:	41 5e                	pop    %r14
   86a0f:	41 5f                	pop    %r15
   86a11:	c3                   	ret
   86a12:	48 8d 15 0f 8a 06 00 	lea    0x68a0f(%rip),%rdx        # ef428 <anon.3c511bf1c207598aac5aaa2c17116cb5.18.llvm.16457729305247153211>
   86a19:	ff 15 f9 ba 06 00    	call   *0x6baf9(%rip)        # f2518 <_DYNAMIC+0x278>
   86a1f:	48 8d 15 1a 8a 06 00 	lea    0x68a1a(%rip),%rdx        # ef440 <anon.3c511bf1c207598aac5aaa2c17116cb5.19.llvm.16457729305247153211>
   86a26:	48 89 c7             	mov    %rax,%rdi
   86a29:	ff 15 e9 ba 06 00    	call   *0x6bae9(%rip)        # f2518 <_DYNAMIC+0x278>
   86a2f:	48 8d 15 22 8a 06 00 	lea    0x68a22(%rip),%rdx        # ef458 <anon.3c511bf1c207598aac5aaa2c17116cb5.20.llvm.16457729305247153211>
   86a36:	ff 15 dc ba 06 00    	call   *0x6badc(%rip)        # f2518 <_DYNAMIC+0x278>

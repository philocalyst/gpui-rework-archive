
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006867c0 <<gpui_canvas::text::layout::TextGeometry>::line_tail>:
  6867c0:	53                   	push   %rbx
  6867c1:	4c 8b 0e             	mov    (%rsi),%r9
  6867c4:	4c 8b 56 10          	mov    0x10(%rsi),%r10
  6867c8:	31 c9                	xor    %ecx,%ecx
  6867ca:	49 83 f9 02          	cmp    $0x2,%r9
  6867ce:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  6867d4:	4c 0f 45 46 08       	cmovne 0x8(%rsi),%r8
  6867d9:	49 0f 45 ca          	cmovne %r10,%rcx
  6867dd:	48 8b 46 40          	mov    0x40(%rsi),%rax
  6867e1:	48 39 c2             	cmp    %rax,%rdx
  6867e4:	0f 83 ce 00 00 00    	jae    6868b8 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xf8>
  6867ea:	48 8b 46 38          	mov    0x38(%rsi),%rax
  6867ee:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  6867f2:	8b 14 d0             	mov    (%rax,%rdx,8),%edx
  6867f5:	85 d2                	test   %edx,%edx
  6867f7:	74 48                	je     686841 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0x81>
  6867f9:	48 89 c8             	mov    %rcx,%rax
  6867fc:	41 f6 c1 01          	test   $0x1,%r9b
  686800:	75 49                	jne    68684b <<gpui_canvas::text::layout::TextGeometry>::line_tail+0x8b>
  686802:	48 85 c9             	test   %rcx,%rcx
  686805:	0f 84 88 00 00 00    	je     686893 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xd3>
  68680b:	31 c0                	xor    %eax,%eax
  68680d:	48 83 f9 01          	cmp    $0x1,%rcx
  686811:	74 28                	je     68683b <<gpui_canvas::text::layout::TextGeometry>::line_tail+0x7b>
  686813:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  68681a:	84 00 00 00 00 00 
  686820:	4c 89 d6             	mov    %r10,%rsi
  686823:	48 d1 ee             	shr    $1,%rsi
  686826:	4c 8d 1c 06          	lea    (%rsi,%rax,1),%r11
  68682a:	43 39 14 d8          	cmp    %edx,(%r8,%r11,8)
  68682e:	49 0f 42 c3          	cmovb  %r11,%rax
  686832:	49 29 f2             	sub    %rsi,%r10
  686835:	49 83 fa 01          	cmp    $0x1,%r10
  686839:	77 e5                	ja     686820 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0x60>
  68683b:	49 8d 34 c0          	lea    (%r8,%rax,8),%rsi
  68683f:	eb 46                	jmp    686887 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xc7>
  686841:	31 c0                	xor    %eax,%eax
  686843:	41 f6 c1 01          	test   $0x1,%r9b
  686847:	74 4a                	je     686893 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xd3>
  686849:	eb 50                	jmp    68689b <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xdb>
  68684b:	48 85 c9             	test   %rcx,%rcx
  68684e:	74 4b                	je     68689b <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xdb>
  686850:	31 c0                	xor    %eax,%eax
  686852:	48 83 f9 01          	cmp    $0x1,%rcx
  686856:	74 27                	je     68687f <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xbf>
  686858:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  68685f:	00 
  686860:	4c 89 d6             	mov    %r10,%rsi
  686863:	48 d1 ee             	shr    $1,%rsi
  686866:	4c 8d 1c 06          	lea    (%rsi,%rax,1),%r11
  68686a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  68686e:	41 39 14 98          	cmp    %edx,(%r8,%rbx,4)
  686872:	49 0f 42 c3          	cmovb  %r11,%rax
  686876:	49 29 f2             	sub    %rsi,%r10
  686879:	49 83 fa 01          	cmp    $0x1,%r10
  68687d:	77 e1                	ja     686860 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xa0>
  68687f:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  686883:	49 8d 34 b0          	lea    (%r8,%rsi,4),%rsi
  686887:	39 16                	cmp    %edx,(%rsi)
  686889:	48 83 d0 00          	adc    $0x0,%rax
  68688d:	41 f6 c1 01          	test   $0x1,%r9b
  686891:	75 08                	jne    68689b <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xdb>
  686893:	49 8d 14 c0          	lea    (%r8,%rax,8),%rdx
  686897:	31 f6                	xor    %esi,%esi
  686899:	eb 0d                	jmp    6868a8 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xe8>
  68689b:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  68689f:	49 8d 14 90          	lea    (%r8,%rdx,4),%rdx
  6868a3:	be 01 00 00 00       	mov    $0x1,%esi
  6868a8:	48 29 c1             	sub    %rax,%rcx
  6868ab:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  6868af:	48 89 4f 10          	mov    %rcx,0x10(%rdi)
  6868b3:	48 89 37             	mov    %rsi,(%rdi)
  6868b6:	5b                   	pop    %rbx
  6868b7:	c3                   	ret
  6868b8:	48 8d 0d 49 96 0f 00 	lea    0xf9649(%rip),%rcx        # 77ff08 <anon.3410b8a693437fb60a075b0edac1ad14.21.llvm.8008813205763886337+0xf0>
  6868bf:	48 89 d7             	mov    %rdx,%rdi
  6868c2:	48 89 c6             	mov    %rax,%rsi
  6868c5:	48 89 ca             	mov    %rcx,%rdx
  6868c8:	ff 15 0a 2f 10 00    	call   *0x102f0a(%rip)        # 7897d8 <_DYNAMIC+0x370>

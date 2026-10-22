
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000662820 <<gpui_canvas::text::layout::TextGeometry>::stops>:
  662820:	53                   	push   %rbx
  662821:	89 d0                	mov    %edx,%eax
  662823:	31 d2                	xor    %edx,%edx
  662825:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  66282a:	4c 8b 47 40          	mov    0x40(%rdi),%r8
  66282e:	49 0f 45 d0          	cmovne %r8,%rdx
  662832:	b9 04 00 00 00       	mov    $0x4,%ecx
  662837:	48 0f 45 4f 38       	cmovne 0x38(%rdi),%rcx
  66283c:	85 f6                	test   %esi,%esi
  66283e:	74 4c                	je     66288c <<gpui_canvas::text::layout::TextGeometry>::stops+0x6c>
  662840:	48 85 d2             	test   %rdx,%rdx
  662843:	0f 84 96 00 00 00    	je     6628df <<gpui_canvas::text::layout::TextGeometry>::stops+0xbf>
  662849:	31 ff                	xor    %edi,%edi
  66284b:	48 83 fa 01          	cmp    $0x1,%rdx
  66284f:	74 2d                	je     66287e <<gpui_canvas::text::layout::TextGeometry>::stops+0x5e>
  662851:	4d 89 c1             	mov    %r8,%r9
  662854:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  66285b:	00 00 00 00 00 
  662860:	4d 89 ca             	mov    %r9,%r10
  662863:	49 d1 ea             	shr    $1,%r10
  662866:	4d 8d 1c 3a          	lea    (%r10,%rdi,1),%r11
  66286a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  66286e:	39 34 99             	cmp    %esi,(%rcx,%rbx,4)
  662871:	49 0f 42 fb          	cmovb  %r11,%rdi
  662875:	4d 29 d1             	sub    %r10,%r9
  662878:	49 83 f9 01          	cmp    $0x1,%r9
  66287c:	77 e2                	ja     662860 <<gpui_canvas::text::layout::TextGeometry>::stops+0x40>
  66287e:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  662882:	42 39 34 89          	cmp    %esi,(%rcx,%r9,4)
  662886:	48 83 d7 00          	adc    $0x0,%rdi
  66288a:	eb 0c                	jmp    662898 <<gpui_canvas::text::layout::TextGeometry>::stops+0x78>
  66288c:	31 ff                	xor    %edi,%edi
  66288e:	be 00 00 00 00       	mov    $0x0,%esi
  662893:	48 85 d2             	test   %rdx,%rdx
  662896:	74 4d                	je     6628e5 <<gpui_canvas::text::layout::TextGeometry>::stops+0xc5>
  662898:	31 f6                	xor    %esi,%esi
  66289a:	48 83 fa 01          	cmp    $0x1,%rdx
  66289e:	74 21                	je     6628c1 <<gpui_canvas::text::layout::TextGeometry>::stops+0xa1>
  6628a0:	49 89 f1             	mov    %rsi,%r9
  6628a3:	4d 89 c2             	mov    %r8,%r10
  6628a6:	49 d1 ea             	shr    $1,%r10
  6628a9:	4c 01 d6             	add    %r10,%rsi
  6628ac:	4c 8d 1c 76          	lea    (%rsi,%rsi,2),%r11
  6628b0:	42 39 04 99          	cmp    %eax,(%rcx,%r11,4)
  6628b4:	49 0f 47 f1          	cmova  %r9,%rsi
  6628b8:	4d 29 d0             	sub    %r10,%r8
  6628bb:	49 83 f8 01          	cmp    $0x1,%r8
  6628bf:	77 df                	ja     6628a0 <<gpui_canvas::text::layout::TextGeometry>::stops+0x80>
  6628c1:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  6628c5:	42 3b 04 81          	cmp    (%rcx,%r8,4),%eax
  6628c9:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  6628cd:	48 39 fe             	cmp    %rdi,%rsi
  6628d0:	73 13                	jae    6628e5 <<gpui_canvas::text::layout::TextGeometry>::stops+0xc5>
  6628d2:	48 8d 0d df 9f 11 00 	lea    0x119fdf(%rip),%rcx        # 77c8b8 <anon.b75840af67eff6c7867889150027a6c7.3.llvm.2112026857664668335+0x48>
  6628d9:	ff 15 b1 4d 12 00    	call   *0x124db1(%rip)        # 787690 <_DYNAMIC+0x3e0>
  6628df:	48 89 d6             	mov    %rdx,%rsi
  6628e2:	48 89 d7             	mov    %rdx,%rdi
  6628e5:	48 29 fe             	sub    %rdi,%rsi
  6628e8:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  6628ec:	48 8d 04 81          	lea    (%rcx,%rax,4),%rax
  6628f0:	48 89 f2             	mov    %rsi,%rdx
  6628f3:	5b                   	pop    %rbx
  6628f4:	c3                   	ret

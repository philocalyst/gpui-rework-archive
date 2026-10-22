
/tmp/gpui-text-map-query-controls/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000684780 <<gpui_canvas::text::layout::TextGeometry>::move_visual>:
  684780:	55                   	push   %rbp
  684781:	41 57                	push   %r15
  684783:	41 56                	push   %r14
  684785:	41 55                	push   %r13
  684787:	41 54                	push   %r12
  684789:	53                   	push   %rbx
  68478a:	48 83 ec 68          	sub    $0x68,%rsp
  68478e:	40 b5 02             	mov    $0x2,%bpl
  684791:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  684796:	0f 84 43 01 00 00    	je     6848df <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15f>
  68479c:	4c 8b 7f 38          	mov    0x38(%rdi),%r15
  6847a0:	4c 8b 77 40          	mov    0x40(%rdi),%r14
  6847a4:	4c 89 f0             	mov    %r14,%rax
  6847a7:	4d 85 f6             	test   %r14,%r14
  6847aa:	74 41                	je     6847ed <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x6d>
  6847ac:	31 c0                	xor    %eax,%eax
  6847ae:	49 83 fe 01          	cmp    $0x1,%r14
  6847b2:	74 2c                	je     6847e0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x60>
  6847b4:	4d 89 f0             	mov    %r14,%r8
  6847b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  6847be:	00 00 
  6847c0:	4d 89 c1             	mov    %r8,%r9
  6847c3:	49 d1 e9             	shr    $1,%r9
  6847c6:	4d 8d 14 01          	lea    (%r9,%rax,1),%r10
  6847ca:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  6847ce:	43 39 74 df 10       	cmp    %esi,0x10(%r15,%r11,8)
  6847d3:	49 0f 42 c2          	cmovb  %r10,%rax
  6847d7:	4d 29 c8             	sub    %r9,%r8
  6847da:	49 83 f8 01          	cmp    $0x1,%r8
  6847de:	77 e0                	ja     6847c0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x40>
  6847e0:	4c 8d 04 40          	lea    (%rax,%rax,2),%r8
  6847e4:	43 39 74 c7 10       	cmp    %esi,0x10(%r15,%r8,8)
  6847e9:	48 83 d0 00          	adc    $0x0,%rax
  6847ed:	44 8d 42 01          	lea    0x1(%rdx),%r8d
  6847f1:	48 c1 e0 03          	shl    $0x3,%rax
  6847f5:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6847f9:	4e 8d 0c f5 00 00 00 	lea    0x0(,%r14,8),%r9
  684800:	00 
  684801:	4f 8d 0c 49          	lea    (%r9,%r9,2),%r9
  684805:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  68480c:	00 00 00 00 
  684810:	49 39 c1             	cmp    %rax,%r9
  684813:	0f 84 c6 00 00 00    	je     6848df <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15f>
  684819:	41 39 74 07 10       	cmp    %esi,0x10(%r15,%rax,1)
  68481e:	0f 85 bb 00 00 00    	jne    6848df <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15f>
  684824:	4c 8d 50 18          	lea    0x18(%rax),%r10
  684828:	45 84 44 07 14       	test   %r8b,0x14(%r15,%rax,1)
  68482d:	4c 89 d0             	mov    %r10,%rax
  684830:	74 de                	je     684810 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x90>
  684832:	f3 43 0f 10 44 17 e8 	movss  -0x18(%r15,%r10,1),%xmm0
  684839:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
  68483f:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
  684844:	0f b6 d2             	movzbl %dl,%edx
  684847:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  68484c:	89 74 24 1c          	mov    %esi,0x1c(%rsp)
  684850:	89 cb                	mov    %ecx,%ebx
  684852:	ff 15 b8 31 10 00    	call   *0x1031b8(%rip)        # 787a10 <_DYNAMIC+0x988>
  684858:	48 89 c1             	mov    %rax,%rcx
  68485b:	48 83 f9 01          	cmp    $0x1,%rcx
  68485f:	75 7e                	jne    6848df <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15f>
  684861:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  684866:	48 8b 71 28          	mov    0x28(%rcx),%rsi
  68486a:	48 39 f2             	cmp    %rsi,%rdx
  68486d:	0f 83 25 05 00 00    	jae    684d98 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x618>
  684873:	89 5c 24 14          	mov    %ebx,0x14(%rsp)
  684877:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  68487c:	48 8b 59 20          	mov    0x20(%rcx),%rbx
  684880:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
  684884:	8b 3c c3             	mov    (%rbx,%rax,8),%edi
  684887:	85 ff                	test   %edi,%edi
  684889:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  68488e:	74 60                	je     6848f0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x170>
  684890:	4c 89 f6             	mov    %r14,%rsi
  684893:	4d 85 f6             	test   %r14,%r14
  684896:	74 5a                	je     6848f2 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x172>
  684898:	31 f6                	xor    %esi,%esi
  68489a:	49 83 fe 01          	cmp    $0x1,%r14
  68489e:	74 30                	je     6848d0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x150>
  6848a0:	4d 89 f0             	mov    %r14,%r8
  6848a3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6848aa:	84 00 00 00 00 00 
  6848b0:	4d 89 c1             	mov    %r8,%r9
  6848b3:	49 d1 e9             	shr    $1,%r9
  6848b6:	4d 8d 14 31          	lea    (%r9,%rsi,1),%r10
  6848ba:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  6848be:	43 39 7c df 10       	cmp    %edi,0x10(%r15,%r11,8)
  6848c3:	49 0f 42 f2          	cmovb  %r10,%rsi
  6848c7:	4d 29 c8             	sub    %r9,%r8
  6848ca:	49 83 f8 01          	cmp    $0x1,%r8
  6848ce:	77 e0                	ja     6848b0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x130>
  6848d0:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  6848d4:	43 39 7c c7 10       	cmp    %edi,0x10(%r15,%r8,8)
  6848d9:	48 83 d6 00          	adc    $0x0,%rsi
  6848dd:	eb 13                	jmp    6848f2 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x172>
  6848df:	89 ea                	mov    %ebp,%edx
  6848e1:	48 83 c4 68          	add    $0x68,%rsp
  6848e5:	5b                   	pop    %rbx
  6848e6:	41 5c                	pop    %r12
  6848e8:	41 5d                	pop    %r13
  6848ea:	41 5e                	pop    %r14
  6848ec:	41 5f                	pop    %r15
  6848ee:	5d                   	pop    %rbp
  6848ef:	c3                   	ret
  6848f0:	31 f6                	xor    %esi,%esi
  6848f2:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
  6848f7:	48 8d 04 c3          	lea    (%rbx,%rax,8),%rax
  6848fb:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  684900:	49 29 f6             	sub    %rsi,%r14
  684903:	48 8d 04 76          	lea    (%rsi,%rsi,2),%rax
  684907:	4d 8d 04 c7          	lea    (%r15,%rax,8),%r8
  68490b:	4c 8b 61 08          	mov    0x8(%rcx),%r12
  68490f:	48 8b 41 10          	mov    0x10(%rcx),%rax
  684913:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  684918:	f3 0f 10 05 c8 8b 99 	movss  -0x667438(%rip),%xmm0        # 1d4e8 <GCC_except_table0+0xc0>
  68491f:	ff 
  684920:	b0 02                	mov    $0x2,%al
  684922:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  684926:	45 31 db             	xor    %r11d,%r11d
  684929:	4d 89 c7             	mov    %r8,%r15
  68492c:	4d 89 f5             	mov    %r14,%r13
  68492f:	4c 89 64 24 58       	mov    %r12,0x58(%rsp)
  684934:	eb 0d                	jmp    684943 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c3>
  684936:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  68493d:	00 00 00 
  684940:	49 89 c7             	mov    %rax,%r15
  684943:	4c 89 c5             	mov    %r8,%rbp
  684946:	4c 89 f7             	mov    %r14,%rdi
  684949:	49 83 fe 01          	cmp    $0x1,%r14
  68494d:	74 3a                	je     684989 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x209>
  68494f:	4d 85 f6             	test   %r14,%r14
  684952:	0f 84 80 03 00 00    	je     684cd8 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x558>
  684958:	48 8d 55 28          	lea    0x28(%rbp),%rdx
  68495c:	49 8d 76 01          	lea    0x1(%r14),%rsi
  684960:	bf 01 00 00 00       	mov    $0x1,%edi
  684965:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  68496c:	00 00 00 00 
  684970:	44 8b 42 e8          	mov    -0x18(%rdx),%r8d
  684974:	44 3b 02             	cmp    (%rdx),%r8d
  684977:	75 10                	jne    684989 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x209>
  684979:	48 ff c7             	inc    %rdi
  68497c:	48 83 c2 18          	add    $0x18,%rdx
  684980:	48 ff ce             	dec    %rsi
  684983:	48 83 fe 02          	cmp    $0x2,%rsi
  684987:	77 e7                	ja     684970 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f0>
  684989:	49 29 fe             	sub    %rdi,%r14
  68498c:	0f 82 cd 03 00 00    	jb     684d5f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5df>
  684992:	41 f6 c3 01          	test   $0x1,%r11b
  684996:	0f 84 ec 01 00 00    	je     684b88 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x408>
  68499c:	4d 89 e9             	mov    %r13,%r9
  68499f:	49 83 fd 01          	cmp    $0x1,%r13
  6849a3:	74 34                	je     6849d9 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x259>
  6849a5:	4d 85 ed             	test   %r13,%r13
  6849a8:	0f 84 2a 03 00 00    	je     684cd8 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x558>
  6849ae:	49 8d 57 28          	lea    0x28(%r15),%rdx
  6849b2:	49 8d 75 01          	lea    0x1(%r13),%rsi
  6849b6:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  6849bc:	0f 1f 40 00          	nopl   0x0(%rax)
  6849c0:	44 8b 42 e8          	mov    -0x18(%rdx),%r8d
  6849c4:	44 3b 02             	cmp    (%rdx),%r8d
  6849c7:	75 10                	jne    6849d9 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x259>
  6849c9:	49 ff c1             	inc    %r9
  6849cc:	48 83 c2 18          	add    $0x18,%rdx
  6849d0:	48 ff ce             	dec    %rsi
  6849d3:	48 83 fe 02          	cmp    $0x2,%rsi
  6849d7:	77 e7                	ja     6849c0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x240>
  6849d9:	4d 29 cd             	sub    %r9,%r13
  6849dc:	0f 82 7d 03 00 00    	jb     684d5f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5df>
  6849e2:	4b 8d 14 49          	lea    (%r9,%r9,2),%rdx
  6849e6:	49 8d 04 d7          	lea    (%r15,%rdx,8),%rax
  6849ea:	48 8d 14 7f          	lea    (%rdi,%rdi,2),%rdx
  6849ee:	4c 8d 04 d5 00 00 00 	lea    0x0(,%rdx,8),%r8
  6849f5:	00 
  6849f6:	49 01 e8             	add    %rbp,%r8
  6849f9:	48 c1 e7 03          	shl    $0x3,%rdi
  6849fd:	48 8d 14 7f          	lea    (%rdi,%rdi,2),%rdx
  684a01:	31 f6                	xor    %esi,%esi
  684a03:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  684a0a:	84 00 00 00 00 00 
  684a10:	41 b3 01             	mov    $0x1,%r11b
  684a13:	48 39 f2             	cmp    %rsi,%rdx
  684a16:	0f 84 24 ff ff ff    	je     684940 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c0>
  684a1c:	4c 8d 56 18          	lea    0x18(%rsi),%r10
  684a20:	f6 44 35 14 02       	testb  $0x2,0x14(%rbp,%rsi,1)
  684a25:	4c 89 d6             	mov    %r10,%rsi
  684a28:	74 e6                	je     684a10 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x290>
  684a2a:	49 c1 e1 03          	shl    $0x3,%r9
  684a2e:	4b 8d 34 49          	lea    (%r9,%r9,2),%rsi
  684a32:	31 ff                	xor    %edi,%edi
  684a34:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  684a3b:	00 00 00 00 00 
  684a40:	48 39 fe             	cmp    %rdi,%rsi
  684a43:	0f 84 f7 fe ff ff    	je     684940 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c0>
  684a49:	48 8d 57 18          	lea    0x18(%rdi),%rdx
  684a4d:	41 f6 44 3f 14 01    	testb  $0x1,0x14(%r15,%rdi,1)
  684a53:	48 89 d7             	mov    %rdx,%rdi
  684a56:	74 e8                	je     684a40 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2c0>
  684a58:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  684a5d:	46 8b 4c 15 f8       	mov    -0x8(%rbp,%r10,1),%r9d
  684a62:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  684a67:	48 89 c7             	mov    %rax,%rdi
  684a6a:	48 85 c0             	test   %rax,%rax
  684a6d:	74 65                	je     684ad4 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x354>
  684a6f:	48 83 f8 01          	cmp    $0x1,%rax
  684a73:	75 09                	jne    684a7e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2fe>
  684a75:	31 f6                	xor    %esi,%esi
  684a77:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
  684a7c:	eb 33                	jmp    684ab1 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x331>
  684a7e:	48 89 c7             	mov    %rax,%rdi
  684a81:	31 f6                	xor    %esi,%esi
  684a83:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
  684a88:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  684a8f:	00 
  684a90:	48 89 f3             	mov    %rsi,%rbx
  684a93:	48 89 f8             	mov    %rdi,%rax
  684a96:	48 d1 e8             	shr    $1,%rax
  684a99:	48 01 c6             	add    %rax,%rsi
  684a9c:	48 8d 0c 76          	lea    (%rsi,%rsi,2),%rcx
  684aa0:	45 39 0c cc          	cmp    %r9d,(%r12,%rcx,8)
  684aa4:	48 0f 47 f3          	cmova  %rbx,%rsi
  684aa8:	48 29 c7             	sub    %rax,%rdi
  684aab:	48 83 ff 01          	cmp    $0x1,%rdi
  684aaf:	77 df                	ja     684a90 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x310>
  684ab1:	48 8d 04 76          	lea    (%rsi,%rsi,2),%rax
  684ab5:	31 ff                	xor    %edi,%edi
  684ab7:	45 39 0c c4          	cmp    %r9d,(%r12,%rax,8)
  684abb:	40 0f 96 c7          	setbe  %dil
  684abf:	48 01 f7             	add    %rsi,%rdi
  684ac2:	48 83 ff 01          	cmp    $0x1,%rdi
  684ac6:	48 83 d7 ff          	adc    $0xffffffffffffffff,%rdi
  684aca:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  684acf:	4c 8b 64 24 58       	mov    0x58(%rsp),%r12
  684ad4:	48 39 c7             	cmp    %rax,%rdi
  684ad7:	0f 83 a9 02 00 00    	jae    684d86 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x606>
  684add:	41 8b 5c 17 f8       	mov    -0x8(%r15,%rdx,1),%ebx
  684ae2:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  684ae6:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  684aeb:	8b 74 c1 04          	mov    0x4(%rcx,%rax,8),%esi
  684aef:	f3 42 0f 10 4c 15 e8 	movss  -0x18(%rbp,%r10,1),%xmm1
  684af6:	f3 41 0f 10 54 17 e8 	movss  -0x18(%r15,%rdx,1),%xmm2
  684afd:	39 f3                	cmp    %esi,%ebx
  684aff:	77 07                	ja     684b08 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x388>
  684b01:	0f 2e ca             	ucomiss %xmm2,%xmm1
  684b04:	75 4a                	jne    684b50 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3d0>
  684b06:	7a 48                	jp     684b50 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3d0>
  684b08:	48 83 7c 24 40 02    	cmpq   $0x2,0x40(%rsp)
  684b0e:	72 40                	jb     684b50 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3d0>
  684b10:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  684b15:	45 31 d2             	xor    %r10d,%r10d
  684b18:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  684b1f:	00 
  684b20:	48 89 d0             	mov    %rdx,%rax
  684b23:	48 d1 e8             	shr    $1,%rax
  684b26:	4a 8d 0c 10          	lea    (%rax,%r10,1),%rcx
  684b2a:	4c 8d 3c 49          	lea    (%rcx,%rcx,2),%r15
  684b2e:	47 8b 7c fc 10       	mov    0x10(%r12,%r15,8),%r15d
  684b33:	4c 39 ff             	cmp    %r15,%rdi
  684b36:	4c 0f 47 d1          	cmova  %rcx,%r10
  684b3a:	48 29 c2             	sub    %rax,%rdx
  684b3d:	48 83 fa 01          	cmp    $0x1,%rdx
  684b41:	77 dd                	ja     684b20 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3a0>
  684b43:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  684b4a:	84 00 00 00 00 00 
  684b50:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  684b55:	44 3b 48 04          	cmp    0x4(%rax),%r9d
  684b59:	0f 87 79 01 00 00    	ja     684cd8 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x558>
  684b5f:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  684b64:	49 89 c7             	mov    %rax,%r15
  684b67:	4c 89 c5             	mov    %r8,%rbp
  684b6a:	48 3b 7c 24 48       	cmp    0x48(%rsp),%rdi
  684b6f:	0f 85 d1 fd ff ff    	jne    684946 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c6>
  684b75:	49 89 c7             	mov    %rax,%r15
  684b78:	4c 89 c5             	mov    %r8,%rbp
  684b7b:	39 f3                	cmp    %esi,%ebx
  684b7d:	0f 87 c3 fd ff ff    	ja     684946 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c6>
  684b83:	e9 a4 00 00 00       	jmp    684c2c <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4ac>
  684b88:	4c 89 ee             	mov    %r13,%rsi
  684b8b:	49 83 fd 01          	cmp    $0x1,%r13
  684b8f:	74 2f                	je     684bc0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x440>
  684b91:	4d 85 ed             	test   %r13,%r13
  684b94:	0f 84 3e 01 00 00    	je     684cd8 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x558>
  684b9a:	49 8d 57 28          	lea    0x28(%r15),%rdx
  684b9e:	4d 8d 45 01          	lea    0x1(%r13),%r8
  684ba2:	be 01 00 00 00       	mov    $0x1,%esi
  684ba7:	44 8b 4a e8          	mov    -0x18(%rdx),%r9d
  684bab:	44 3b 0a             	cmp    (%rdx),%r9d
  684bae:	75 10                	jne    684bc0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x440>
  684bb0:	48 ff c6             	inc    %rsi
  684bb3:	48 83 c2 18          	add    $0x18,%rdx
  684bb7:	49 ff c8             	dec    %r8
  684bba:	49 83 f8 02          	cmp    $0x2,%r8
  684bbe:	77 e7                	ja     684ba7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x427>
  684bc0:	4c 89 ea             	mov    %r13,%rdx
  684bc3:	48 29 f2             	sub    %rsi,%rdx
  684bc6:	0f 82 93 01 00 00    	jb     684d5f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5df>
  684bcc:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  684bd0:	49 89 d1             	mov    %rdx,%r9
  684bd3:	48 83 fa 01          	cmp    $0x1,%rdx
  684bd7:	74 36                	je     684c0f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x48f>
  684bd9:	48 85 d2             	test   %rdx,%rdx
  684bdc:	0f 84 f6 00 00 00    	je     684cd8 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x558>
  684be2:	4f 8d 14 c7          	lea    (%r15,%r8,8),%r10
  684be6:	49 83 c2 28          	add    $0x28,%r10
  684bea:	49 29 f5             	sub    %rsi,%r13
  684bed:	49 ff c5             	inc    %r13
  684bf0:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  684bf6:	41 8b 72 e8          	mov    -0x18(%r10),%esi
  684bfa:	41 3b 32             	cmp    (%r10),%esi
  684bfd:	75 10                	jne    684c0f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x48f>
  684bff:	49 ff c1             	inc    %r9
  684c02:	49 83 c2 18          	add    $0x18,%r10
  684c06:	49 ff cd             	dec    %r13
  684c09:	49 83 fd 02          	cmp    $0x2,%r13
  684c0d:	77 e7                	ja     684bf6 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x476>
  684c0f:	4c 29 ca             	sub    %r9,%rdx
  684c12:	0f 82 47 01 00 00    	jb     684d5f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5df>
  684c18:	4f 8d 3c c7          	lea    (%r15,%r8,8),%r15
  684c1c:	4b 8d 34 49          	lea    (%r9,%r9,2),%rsi
  684c20:	49 8d 04 f7          	lea    (%r15,%rsi,8),%rax
  684c24:	49 89 d5             	mov    %rdx,%r13
  684c27:	e9 be fd ff ff       	jmp    6849ea <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x26a>
  684c2c:	8b 74 24 14          	mov    0x14(%rsp),%esi
  684c30:	40 84 f6             	test   %sil,%sil
  684c33:	74 23                	je     684c58 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4d8>
  684c35:	0f 28 e1             	movaps %xmm1,%xmm4
  684c38:	f3 0f 5f e2          	maxss  %xmm2,%xmm4
  684c3c:	0f 28 dc             	movaps %xmm4,%xmm3
  684c3f:	f3 0f c2 dc 03       	cmpunordss %xmm4,%xmm3
  684c44:	0f 28 eb             	movaps %xmm3,%xmm5
  684c47:	0f 55 ec             	andnps %xmm4,%xmm5
  684c4a:	0f 54 d9             	andps  %xmm1,%xmm3
  684c4d:	0f 56 dd             	orps   %xmm5,%xmm3
  684c50:	f3 0f 5c 5c 24 18    	subss  0x18(%rsp),%xmm3
  684c56:	eb 25                	jmp    684c7d <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4fd>
  684c58:	0f 28 d9             	movaps %xmm1,%xmm3
  684c5b:	f3 0f 5d da          	minss  %xmm2,%xmm3
  684c5f:	0f 28 e3             	movaps %xmm3,%xmm4
  684c62:	f3 0f c2 e3 03       	cmpunordss %xmm3,%xmm4
  684c67:	0f 28 ec             	movaps %xmm4,%xmm5
  684c6a:	0f 55 eb             	andnps %xmm3,%xmm5
  684c6d:	0f 54 e1             	andps  %xmm1,%xmm4
  684c70:	0f 56 e5             	orps   %xmm5,%xmm4
  684c73:	f3 0f 10 5c 24 18    	movss  0x18(%rsp),%xmm3
  684c79:	f3 0f 5c dc          	subss  %xmm4,%xmm3
  684c7d:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  684c81:	8b 7c 24 10          	mov    0x10(%rsp),%edi
  684c85:	0f 28 e3             	movaps %xmm3,%xmm4
  684c88:	f3 0f c2 e0 01       	cmpltss %xmm0,%xmm4
  684c8d:	0f 57 ed             	xorps  %xmm5,%xmm5
  684c90:	f3 0f c2 eb 01       	cmpltss %xmm3,%xmm5
  684c95:	0f 54 ec             	andps  %xmm4,%xmm5
  684c98:	0f 2e d1             	ucomiss %xmm1,%xmm2
  684c9b:	66 0f 7e e8          	movd   %xmm5,%eax
  684c9f:	0f 96 c2             	setbe  %dl
  684ca2:	40 30 f2             	xor    %sil,%dl
  684ca5:	44 0f 45 cb          	cmovne %ebx,%r9d
  684ca9:	80 f2 01             	xor    $0x1,%dl
  684cac:	a8 01                	test   $0x1,%al
  684cae:	75 03                	jne    684cb3 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x533>
  684cb0:	0f 28 d8             	movaps %xmm0,%xmm3
  684cb3:	0f b6 c2             	movzbl %dl,%eax
  684cb6:	0f b6 c9             	movzbl %cl,%ecx
  684cb9:	0f 45 c8             	cmovne %eax,%ecx
  684cbc:	89 4c 24 0c          	mov    %ecx,0xc(%rsp)
  684cc0:	41 0f 45 f9          	cmovne %r9d,%edi
  684cc4:	89 7c 24 10          	mov    %edi,0x10(%rsp)
  684cc8:	41 b3 01             	mov    $0x1,%r11b
  684ccb:	0f 28 c3             	movaps %xmm3,%xmm0
  684cce:	4c 8b 7c 24 50       	mov    0x50(%rsp),%r15
  684cd3:	e9 6b fc ff ff       	jmp    684943 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c3>
  684cd8:	8b 6c 24 0c          	mov    0xc(%rsp),%ebp
  684cdc:	40 80 fd 02          	cmp    $0x2,%bpl
  684ce0:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  684ce5:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  684ce9:	8b 44 24 10          	mov    0x10(%rsp),%eax
  684ced:	0f 85 ec fb ff ff    	jne    6848df <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15f>
  684cf3:	84 c9                	test   %cl,%cl
  684cf5:	74 30                	je     684d27 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5a7>
  684cf7:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  684cfb:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  684d00:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  684d04:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  684d09:	74 6d                	je     684d78 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5f8>
  684d0b:	48 ff c6             	inc    %rsi
  684d0e:	31 d2                	xor    %edx,%edx
  684d10:	48 3b 74 24 20       	cmp    0x20(%rsp),%rsi
  684d15:	0f 92 c2             	setb   %dl
  684d18:	f6 c2 01             	test   $0x1,%dl
  684d1b:	74 62                	je     684d7f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5ff>
  684d1d:	f3 0f 10 05 cf 87 99 	movss  -0x667831(%rip),%xmm0        # 1d4f4 <GCC_except_table0+0xcc>
  684d24:	ff 
  684d25:	eb 2c                	jmp    684d53 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5d3>
  684d27:	48 85 f6             	test   %rsi,%rsi
  684d2a:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  684d2f:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  684d33:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  684d38:	74 0a                	je     684d44 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5c4>
  684d3a:	48 ff ce             	dec    %rsi
  684d3d:	ba 01 00 00 00       	mov    $0x1,%edx
  684d42:	eb 02                	jmp    684d46 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5c6>
  684d44:	31 d2                	xor    %edx,%edx
  684d46:	f6 c2 01             	test   $0x1,%dl
  684d49:	74 34                	je     684d7f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5ff>
  684d4b:	f3 0f 10 05 8d 87 99 	movss  -0x667873(%rip),%xmm0        # 1d4e0 <GCC_except_table0+0xb8>
  684d52:	ff 
  684d53:	e8 58 00 00 00       	call   684db0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  684d58:	89 d5                	mov    %edx,%ebp
  684d5a:	e9 80 fb ff ff       	jmp    6848df <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15f>
  684d5f:	48 8d 3d 54 93 bd ff 	lea    -0x426cac(%rip),%rdi        # 25e0ba <anon.694f5c156bcaaad1bfdfb170c855f1e5.14.llvm.4793427009722363920+0x3e2>
  684d66:	48 8d 15 db 8d 0f 00 	lea    0xf8ddb(%rip),%rdx        # 77db48 <anon.54a4d576d54a94f5b464056acc886f06.3.llvm.4127220915301182839+0x60>
  684d6d:	be 13 00 00 00       	mov    $0x13,%esi
  684d72:	ff 15 60 25 10 00    	call   *0x102560(%rip)        # 7872d8 <_DYNAMIC+0x250>
  684d78:	31 d2                	xor    %edx,%edx
  684d7a:	f6 c2 01             	test   $0x1,%dl
  684d7d:	75 9e                	jne    684d1d <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x59d>
  684d7f:	89 cd                	mov    %ecx,%ebp
  684d81:	e9 59 fb ff ff       	jmp    6848df <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15f>
  684d86:	48 8d 15 73 8d 0f 00 	lea    0xf8d73(%rip),%rdx        # 77db00 <anon.54a4d576d54a94f5b464056acc886f06.3.llvm.4127220915301182839+0x18>
  684d8d:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  684d92:	ff 15 88 26 10 00    	call   *0x102688(%rip)        # 787420 <_DYNAMIC+0x398>
  684d98:	48 8d 05 91 8d 0f 00 	lea    0xf8d91(%rip),%rax        # 77db30 <anon.54a4d576d54a94f5b464056acc886f06.3.llvm.4127220915301182839+0x48>
  684d9f:	48 89 d7             	mov    %rdx,%rdi
  684da2:	48 89 c2             	mov    %rax,%rdx
  684da5:	ff 15 75 26 10 00    	call   *0x102675(%rip)        # 787420 <_DYNAMIC+0x398>

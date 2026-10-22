
/tmp/gpui-acknowledged-text-evidence/query-release-candidate/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a4f6f0 <gpui::native::accessibility::projected_node>:
  a4f6f0:	55                   	push   %rbp
  a4f6f1:	41 57                	push   %r15
  a4f6f3:	41 56                	push   %r14
  a4f6f5:	41 55                	push   %r13
  a4f6f7:	41 54                	push   %r12
  a4f6f9:	53                   	push   %rbx
  a4f6fa:	48 81 ec 58 01 00 00 	sub    $0x158,%rsp
  a4f701:	49 89 f4             	mov    %rsi,%r12
  a4f704:	49 89 ff             	mov    %rdi,%r15
  a4f707:	89 d7                	mov    %edx,%edi
  a4f709:	48 8b 76 38          	mov    0x38(%rsi),%rsi
  a4f70d:	48 39 fe             	cmp    %rdi,%rsi
  a4f710:	0f 86 1d 0a 00 00    	jbe    a50133 <gpui::native::accessibility::projected_node+0xa43>
  a4f716:	41 89 d5             	mov    %edx,%r13d
  a4f719:	48 89 b4 24 00 01 00 	mov    %rsi,0x100(%rsp)
  a4f720:	00 
  a4f721:	49 8b 4c 24 30       	mov    0x30(%r12),%rcx
  a4f726:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  a4f72a:	48 c1 e0 04          	shl    $0x4,%rax
  a4f72e:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
  a4f732:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  a4f737:	0f b6 4c 01 4d       	movzbl 0x4d(%rcx,%rax,1),%ecx
  a4f73c:	48 8d 05 0d cd 74 ff 	lea    -0x8b32f3(%rip),%rax        # 19c450 <anon.68a54e84e457eea401d24dc6a9d93b0a.6.llvm.2319709713416821753+0x6de>
  a4f743:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  a4f748:	48 63 0c 88          	movslq (%rax,%rcx,4),%rcx
  a4f74c:	48 01 c1             	add    %rax,%rcx
  a4f74f:	49 be 57 57 57 57 57 	movabs $0x5757575757575757,%r14
  a4f756:	57 57 57 
  a4f759:	89 94 24 10 01 00 00 	mov    %edx,0x110(%rsp)
  a4f760:	ff e1                	jmp    *%rcx
  a4f762:	40 b5 12             	mov    $0x12,%bpl
  a4f765:	f6 43 4c 01          	testb  $0x1,0x4c(%rbx)
  a4f769:	0f 85 ac 00 00 00    	jne    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f76f:	4c 89 e7             	mov    %r12,%rdi
  a4f772:	44 89 ee             	mov    %r13d,%esi
  a4f775:	ff 15 ed 0f ae 00    	call   *0xae0fed(%rip)        # 1530768 <_DYNAMIC+0x15f0>
  a4f77b:	40 b5 4e             	mov    $0x4e,%bpl
  a4f77e:	48 85 c0             	test   %rax,%rax
  a4f781:	0f 85 94 00 00 00    	jne    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f787:	49 8b 44 24 60       	mov    0x60(%r12),%rax
  a4f78c:	40 b5 0e             	mov    $0xe,%bpl
  a4f78f:	48 85 c0             	test   %rax,%rax
  a4f792:	0f 84 83 00 00 00    	je     a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f798:	48 8b 50 40          	mov    0x40(%rax),%rdx
  a4f79c:	48 85 d2             	test   %rdx,%rdx
  a4f79f:	74 7a                	je     a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f7a1:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  a4f7a5:	48 8b 40 38          	mov    0x38(%rax),%rax
  a4f7a9:	48 83 fa 01          	cmp    $0x1,%rdx
  a4f7ad:	0f 85 33 09 00 00    	jne    a500e6 <gpui::native::accessibility::projected_node+0x9f6>
  a4f7b3:	48 39 08             	cmp    %rcx,(%rax)
  a4f7b6:	75 63                	jne    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f7b8:	e9 60 09 00 00       	jmp    a5011d <gpui::native::accessibility::projected_node+0xa2d>
  a4f7bd:	40 b5 18             	mov    $0x18,%bpl
  a4f7c0:	eb 59                	jmp    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f7c2:	40 b5 11             	mov    $0x11,%bpl
  a4f7c5:	eb 54                	jmp    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f7c7:	40 b5 12             	mov    $0x12,%bpl
  a4f7ca:	eb 4f                	jmp    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f7cc:	40 b5 6c             	mov    $0x6c,%bpl
  a4f7cf:	eb 4a                	jmp    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f7d1:	4c 89 e7             	mov    %r12,%rdi
  a4f7d4:	44 89 ee             	mov    %r13d,%esi
  a4f7d7:	ff 15 8b 0f ae 00    	call   *0xae0f8b(%rip)        # 1530768 <_DYNAMIC+0x15f0>
  a4f7dd:	48 8b 73 28          	mov    0x28(%rbx),%rsi
  a4f7e1:	40 b5 4e             	mov    $0x4e,%bpl
  a4f7e4:	48 85 f6             	test   %rsi,%rsi
  a4f7e7:	0f 84 bb 02 00 00    	je     a4faa8 <gpui::native::accessibility::projected_node+0x3b8>
  a4f7ed:	48 85 c0             	test   %rax,%rax
  a4f7f0:	74 29                	je     a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f7f2:	48 8b 0e             	mov    (%rsi),%rcx
  a4f7f5:	48 d1 e9             	shr    $1,%rcx
  a4f7f8:	48 39 ca             	cmp    %rcx,%rdx
  a4f7fb:	75 1e                	jne    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f7fd:	48 83 c6 10          	add    $0x10,%rsi
  a4f801:	48 89 c7             	mov    %rax,%rdi
  a4f804:	ff 15 96 fd ad 00    	call   *0xadfd96(%rip)        # 152f5a0 <bcmp@GLIBC_2.2.5>
  a4f80a:	85 c0                	test   %eax,%eax
  a4f80c:	75 0d                	jne    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f80e:	e9 9e 02 00 00       	jmp    a4fab1 <gpui::native::accessibility::projected_node+0x3c1>
  a4f813:	40 b5 07             	mov    $0x7,%bpl
  a4f816:	eb 03                	jmp    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4f818:	40 b5 04             	mov    $0x4,%bpl
  a4f81b:	40 88 ac 24 fc 00 00 	mov    %bpl,0xfc(%rsp)
  a4f822:	00 
  a4f823:	48 c7 84 24 f0 00 00 	movq   $0x0,0xf0(%rsp)
  a4f82a:	00 00 00 00 00 
  a4f82f:	c7 84 24 f8 00 00 00 	movl   $0x0,0xf8(%rsp)
  a4f836:	00 00 00 00 
  a4f83a:	48 c7 84 24 80 00 00 	movq   $0x0,0x80(%rsp)
  a4f841:	00 00 00 00 00 
  a4f846:	48 c7 84 24 88 00 00 	movq   $0x8,0x88(%rsp)
  a4f84d:	00 08 00 00 00 
  a4f852:	48 c7 84 24 90 00 00 	movq   $0x0,0x90(%rsp)
  a4f859:	00 00 00 00 00 
  a4f85e:	66 0f 28 05 9a d3 73 	movapd -0x8c2c66(%rip),%xmm0        # 18cc00 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a4f865:	ff 
  a4f866:	66 0f 11 84 24 98 00 	movupd %xmm0,0x98(%rsp)
  a4f86d:	00 00 
  a4f86f:	66 0f 11 84 24 a8 00 	movupd %xmm0,0xa8(%rsp)
  a4f876:	00 00 
  a4f878:	66 0f 11 84 24 b8 00 	movupd %xmm0,0xb8(%rsp)
  a4f87f:	00 00 
  a4f881:	66 0f 11 84 24 c8 00 	movupd %xmm0,0xc8(%rsp)
  a4f888:	00 00 
  a4f88a:	66 0f 11 84 24 d8 00 	movupd %xmm0,0xd8(%rsp)
  a4f891:	00 00 
  a4f893:	4c 89 b4 24 e7 00 00 	mov    %r14,0xe7(%rsp)
  a4f89a:	00 
  a4f89b:	4c 89 e7             	mov    %r12,%rdi
  a4f89e:	44 89 ee             	mov    %r13d,%esi
  a4f8a1:	ff 15 c1 0e ae 00    	call   *0xae0ec1(%rip)        # 1530768 <_DYNAMIC+0x15f0>
  a4f8a7:	48 85 c0             	test   %rax,%rax
  a4f8aa:	0f 84 8b 00 00 00    	je     a4f93b <gpui::native::accessibility::projected_node+0x24b>
  a4f8b0:	49 89 d6             	mov    %rdx,%r14
  a4f8b3:	48 85 d2             	test   %rdx,%rdx
  a4f8b6:	79 11                	jns    a4f8c9 <gpui::native::accessibility::projected_node+0x1d9>
  a4f8b8:	45 31 ff             	xor    %r15d,%r15d
  a4f8bb:	4c 89 ff             	mov    %r15,%rdi
  a4f8be:	4c 89 f6             	mov    %r14,%rsi
  a4f8c1:	ff 15 e9 fb ad 00    	call   *0xadfbe9(%rip)        # 152f4b0 <_DYNAMIC+0x338>
  a4f8c7:	0f 0b                	ud2
  a4f8c9:	74 3e                	je     a4f909 <gpui::native::accessibility::projected_node+0x219>
  a4f8cb:	4c 89 3c 24          	mov    %r15,(%rsp)
  a4f8cf:	48 89 c5             	mov    %rax,%rbp
  a4f8d2:	ff 15 e0 fa ad 00    	call   *0xadfae0(%rip)        # 152f3b8 <_DYNAMIC+0x240>
  a4f8d8:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a4f8de:	be 01 00 00 00       	mov    $0x1,%esi
  a4f8e3:	4c 89 f7             	mov    %r14,%rdi
  a4f8e6:	ff 15 d4 fa ad 00    	call   *0xadfad4(%rip)        # 152f3c0 <_DYNAMIC+0x248>
  a4f8ec:	48 85 c0             	test   %rax,%rax
  a4f8ef:	74 ca                	je     a4f8bb <gpui::native::accessibility::projected_node+0x1cb>
  a4f8f1:	49 89 c5             	mov    %rax,%r13
  a4f8f4:	48 89 c7             	mov    %rax,%rdi
  a4f8f7:	48 89 ee             	mov    %rbp,%rsi
  a4f8fa:	4c 89 f2             	mov    %r14,%rdx
  a4f8fd:	ff 15 d5 fa ad 00    	call   *0xadfad5(%rip)        # 152f3d8 <memcpy@GLIBC_2.14>
  a4f903:	4c 8b 3c 24          	mov    (%rsp),%r15
  a4f907:	eb 06                	jmp    a4f90f <gpui::native::accessibility::projected_node+0x21f>
  a4f909:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  a4f90f:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a4f914:	4c 89 6c 24 30       	mov    %r13,0x30(%rsp)
  a4f919:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a4f91e:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a4f923:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4f92a:	00 
  a4f92b:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a4f930:	be 0f 00 00 00       	mov    $0xf,%esi
  a4f935:	ff 15 45 0e ae 00    	call   *0xae0e45(%rip)        # 1530780 <_DYNAMIC+0x1608>
  a4f93b:	80 7b 4d 02          	cmpb   $0x2,0x4d(%rbx)
  a4f93f:	0f 85 86 00 00 00    	jne    a4f9cb <gpui::native::accessibility::projected_node+0x2db>
  a4f945:	4c 8b 6b 28          	mov    0x28(%rbx),%r13
  a4f949:	4d 85 ed             	test   %r13,%r13
  a4f94c:	74 7d                	je     a4f9cb <gpui::native::accessibility::projected_node+0x2db>
  a4f94e:	4d 8b 75 00          	mov    0x0(%r13),%r14
  a4f952:	49 d1 ee             	shr    $1,%r14
  a4f955:	74 43                	je     a4f99a <gpui::native::accessibility::projected_node+0x2aa>
  a4f957:	4c 89 3c 24          	mov    %r15,(%rsp)
  a4f95b:	ff 15 57 fa ad 00    	call   *0xadfa57(%rip)        # 152f3b8 <_DYNAMIC+0x240>
  a4f961:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a4f967:	be 01 00 00 00       	mov    $0x1,%esi
  a4f96c:	4c 89 f7             	mov    %r14,%rdi
  a4f96f:	ff 15 4b fa ad 00    	call   *0xadfa4b(%rip)        # 152f3c0 <_DYNAMIC+0x248>
  a4f975:	48 85 c0             	test   %rax,%rax
  a4f978:	0f 84 3d ff ff ff    	je     a4f8bb <gpui::native::accessibility::projected_node+0x1cb>
  a4f97e:	48 89 c5             	mov    %rax,%rbp
  a4f981:	49 83 c5 10          	add    $0x10,%r13
  a4f985:	48 89 c7             	mov    %rax,%rdi
  a4f988:	4c 89 ee             	mov    %r13,%rsi
  a4f98b:	4c 89 f2             	mov    %r14,%rdx
  a4f98e:	ff 15 44 fa ad 00    	call   *0xadfa44(%rip)        # 152f3d8 <memcpy@GLIBC_2.14>
  a4f994:	4c 8b 3c 24          	mov    (%rsp),%r15
  a4f998:	eb 05                	jmp    a4f99f <gpui::native::accessibility::projected_node+0x2af>
  a4f99a:	bd 01 00 00 00       	mov    $0x1,%ebp
  a4f99f:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a4f9a4:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  a4f9a9:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a4f9ae:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a4f9b3:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4f9ba:	00 
  a4f9bb:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a4f9c0:	be 11 00 00 00       	mov    $0x11,%esi
  a4f9c5:	ff 15 b5 0d ae 00    	call   *0xae0db5(%rip)        # 1530780 <_DYNAMIC+0x1608>
  a4f9cb:	4d 8b 6c 24 60       	mov    0x60(%r12),%r13
  a4f9d0:	4d 85 ed             	test   %r13,%r13
  a4f9d3:	0f 84 18 02 00 00    	je     a4fbf1 <gpui::native::accessibility::projected_node+0x501>
  a4f9d9:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  a4f9dd:	49 8b 4d 40          	mov    0x40(%r13),%rcx
  a4f9e1:	48 85 c9             	test   %rcx,%rcx
  a4f9e4:	0f 84 dc 01 00 00    	je     a4fbc6 <gpui::native::accessibility::projected_node+0x4d6>
  a4f9ea:	49 8b 45 38          	mov    0x38(%r13),%rax
  a4f9ee:	48 83 f9 01          	cmp    $0x1,%rcx
  a4f9f2:	75 17                	jne    a4fa0b <gpui::native::accessibility::projected_node+0x31b>
  a4f9f4:	48 39 10             	cmp    %rdx,(%rax)
  a4f9f7:	0f 85 c9 01 00 00    	jne    a4fbc6 <gpui::native::accessibility::projected_node+0x4d6>
  a4f9fd:	48 8b 68 08          	mov    0x8(%rax),%rbp
  a4fa01:	48 85 ed             	test   %rbp,%rbp
  a4fa04:	75 4c                	jne    a4fa52 <gpui::native::accessibility::projected_node+0x362>
  a4fa06:	e9 bb 01 00 00       	jmp    a4fbc6 <gpui::native::accessibility::projected_node+0x4d6>
  a4fa0b:	31 f6                	xor    %esi,%esi
  a4fa0d:	0f 1f 00             	nopl   (%rax)
  a4fa10:	48 89 f7             	mov    %rsi,%rdi
  a4fa13:	49 89 c8             	mov    %rcx,%r8
  a4fa16:	49 d1 e8             	shr    $1,%r8
  a4fa19:	4c 01 c6             	add    %r8,%rsi
  a4fa1c:	49 89 f1             	mov    %rsi,%r9
  a4fa1f:	49 c1 e1 04          	shl    $0x4,%r9
  a4fa23:	4a 39 14 08          	cmp    %rdx,(%rax,%r9,1)
  a4fa27:	48 0f 47 f7          	cmova  %rdi,%rsi
  a4fa2b:	4c 29 c1             	sub    %r8,%rcx
  a4fa2e:	48 83 f9 01          	cmp    $0x1,%rcx
  a4fa32:	77 dc                	ja     a4fa10 <gpui::native::accessibility::projected_node+0x320>
  a4fa34:	48 c1 e6 04          	shl    $0x4,%rsi
  a4fa38:	48 39 14 30          	cmp    %rdx,(%rax,%rsi,1)
  a4fa3c:	0f 85 84 01 00 00    	jne    a4fbc6 <gpui::native::accessibility::projected_node+0x4d6>
  a4fa42:	48 01 f0             	add    %rsi,%rax
  a4fa45:	48 8b 68 08          	mov    0x8(%rax),%rbp
  a4fa49:	48 85 ed             	test   %rbp,%rbp
  a4fa4c:	0f 84 74 01 00 00    	je     a4fbc6 <gpui::native::accessibility::projected_node+0x4d6>
  a4fa52:	4c 8b 75 00          	mov    0x0(%rbp),%r14
  a4fa56:	49 d1 ee             	shr    $1,%r14
  a4fa59:	0f 84 32 01 00 00    	je     a4fb91 <gpui::native::accessibility::projected_node+0x4a1>
  a4fa5f:	4c 89 3c 24          	mov    %r15,(%rsp)
  a4fa63:	ff 15 4f f9 ad 00    	call   *0xadf94f(%rip)        # 152f3b8 <_DYNAMIC+0x240>
  a4fa69:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a4fa6f:	be 01 00 00 00       	mov    $0x1,%esi
  a4fa74:	4c 89 f7             	mov    %r14,%rdi
  a4fa77:	ff 15 43 f9 ad 00    	call   *0xadf943(%rip)        # 152f3c0 <_DYNAMIC+0x248>
  a4fa7d:	48 85 c0             	test   %rax,%rax
  a4fa80:	0f 84 35 fe ff ff    	je     a4f8bb <gpui::native::accessibility::projected_node+0x1cb>
  a4fa86:	48 83 c5 10          	add    $0x10,%rbp
  a4fa8a:	48 89 c7             	mov    %rax,%rdi
  a4fa8d:	48 89 ee             	mov    %rbp,%rsi
  a4fa90:	4c 89 f2             	mov    %r14,%rdx
  a4fa93:	49 89 c7             	mov    %rax,%r15
  a4fa96:	ff 15 3c f9 ad 00    	call   *0xadf93c(%rip)        # 152f3d8 <memcpy@GLIBC_2.14>
  a4fa9c:	4c 89 f8             	mov    %r15,%rax
  a4fa9f:	4c 8b 3c 24          	mov    (%rsp),%r15
  a4faa3:	e9 ee 00 00 00       	jmp    a4fb96 <gpui::native::accessibility::projected_node+0x4a6>
  a4faa8:	48 85 c0             	test   %rax,%rax
  a4faab:	0f 85 6a fd ff ff    	jne    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a4fab1:	c6 84 24 fc 00 00 00 	movb   $0x3,0xfc(%rsp)
  a4fab8:	03 
  a4fab9:	48 c7 84 24 f0 00 00 	movq   $0x0,0xf0(%rsp)
  a4fac0:	00 00 00 00 00 
  a4fac5:	c7 84 24 f8 00 00 00 	movl   $0x0,0xf8(%rsp)
  a4facc:	00 00 00 00 
  a4fad0:	48 c7 84 24 80 00 00 	movq   $0x0,0x80(%rsp)
  a4fad7:	00 00 00 00 00 
  a4fadc:	48 c7 84 24 88 00 00 	movq   $0x8,0x88(%rsp)
  a4fae3:	00 08 00 00 00 
  a4fae8:	48 c7 84 24 90 00 00 	movq   $0x0,0x90(%rsp)
  a4faef:	00 00 00 00 00 
  a4faf4:	66 0f 28 05 04 d1 73 	movapd -0x8c2efc(%rip),%xmm0        # 18cc00 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a4fafb:	ff 
  a4fafc:	66 0f 11 84 24 98 00 	movupd %xmm0,0x98(%rsp)
  a4fb03:	00 00 
  a4fb05:	66 0f 11 84 24 a8 00 	movupd %xmm0,0xa8(%rsp)
  a4fb0c:	00 00 
  a4fb0e:	66 0f 11 84 24 b8 00 	movupd %xmm0,0xb8(%rsp)
  a4fb15:	00 00 
  a4fb17:	66 0f 11 84 24 c8 00 	movupd %xmm0,0xc8(%rsp)
  a4fb1e:	00 00 
  a4fb20:	66 0f 11 84 24 d8 00 	movupd %xmm0,0xd8(%rsp)
  a4fb27:	00 00 
  a4fb29:	4c 89 b4 24 e7 00 00 	mov    %r14,0xe7(%rsp)
  a4fb30:	00 
  a4fb31:	4c 8b 6b 28          	mov    0x28(%rbx),%r13
  a4fb35:	4d 85 ed             	test   %r13,%r13
  a4fb38:	0f 84 fd fd ff ff    	je     a4f93b <gpui::native::accessibility::projected_node+0x24b>
  a4fb3e:	4d 8b 75 00          	mov    0x0(%r13),%r14
  a4fb42:	49 d1 ee             	shr    $1,%r14
  a4fb45:	0f 84 65 05 00 00    	je     a500b0 <gpui::native::accessibility::projected_node+0x9c0>
  a4fb4b:	4c 89 3c 24          	mov    %r15,(%rsp)
  a4fb4f:	ff 15 63 f8 ad 00    	call   *0xadf863(%rip)        # 152f3b8 <_DYNAMIC+0x240>
  a4fb55:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a4fb5b:	be 01 00 00 00       	mov    $0x1,%esi
  a4fb60:	4c 89 f7             	mov    %r14,%rdi
  a4fb63:	ff 15 57 f8 ad 00    	call   *0xadf857(%rip)        # 152f3c0 <_DYNAMIC+0x248>
  a4fb69:	48 85 c0             	test   %rax,%rax
  a4fb6c:	0f 84 49 fd ff ff    	je     a4f8bb <gpui::native::accessibility::projected_node+0x1cb>
  a4fb72:	48 89 c5             	mov    %rax,%rbp
  a4fb75:	49 83 c5 10          	add    $0x10,%r13
  a4fb79:	48 89 c7             	mov    %rax,%rdi
  a4fb7c:	4c 89 ee             	mov    %r13,%rsi
  a4fb7f:	4c 89 f2             	mov    %r14,%rdx
  a4fb82:	ff 15 50 f8 ad 00    	call   *0xadf850(%rip)        # 152f3d8 <memcpy@GLIBC_2.14>
  a4fb88:	4c 8b 3c 24          	mov    (%rsp),%r15
  a4fb8c:	e9 24 05 00 00       	jmp    a500b5 <gpui::native::accessibility::projected_node+0x9c5>
  a4fb91:	b8 01 00 00 00       	mov    $0x1,%eax
  a4fb96:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a4fb9b:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  a4fba0:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a4fba5:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a4fbaa:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4fbb1:	00 
  a4fbb2:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a4fbb7:	be 10 00 00 00       	mov    $0x10,%esi
  a4fbbc:	ff 15 be 0b ae 00    	call   *0xae0bbe(%rip)        # 1530780 <_DYNAMIC+0x1608>
  a4fbc2:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  a4fbc6:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  a4fbcb:	4c 89 ee             	mov    %r13,%rsi
  a4fbce:	e8 ad 92 00 00       	call   a58e80 <<gpui::runtime::scroll::ViewportColumn>::list>
  a4fbd3:	83 7c 24 20 01       	cmpl   $0x1,0x20(%rsp)
  a4fbd8:	75 17                	jne    a4fbf1 <gpui::native::accessibility::projected_node+0x501>
  a4fbda:	8b 54 24 30          	mov    0x30(%rsp),%edx
  a4fbde:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4fbe5:	00 
  a4fbe6:	be 38 00 00 00       	mov    $0x38,%esi
  a4fbeb:	ff 15 97 0b ae 00    	call   *0xae0b97(%rip)        # 1530788 <_DYNAMIC+0x1610>
  a4fbf1:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  a4fbf6:	4c 89 e6             	mov    %r12,%rsi
  a4fbf9:	8b 94 24 10 01 00 00 	mov    0x110(%rsp),%edx
  a4fc00:	ff 15 8a 0b ae 00    	call   *0xae0b8a(%rip)        # 1530790 <_DYNAMIC+0x1618>
  a4fc06:	48 83 7c 24 20 00    	cmpq   $0x0,0x20(%rsp)
  a4fc0c:	74 17                	je     a4fc25 <gpui::native::accessibility::projected_node+0x535>
  a4fc0e:	8b 54 24 38          	mov    0x38(%rsp),%edx
  a4fc12:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4fc19:	00 
  a4fc1a:	be 39 00 00 00       	mov    $0x39,%esi
  a4fc1f:	ff 15 63 0b ae 00    	call   *0xae0b63(%rip)        # 1530788 <_DYNAMIC+0x1610>
  a4fc25:	f3 0f 10 43 30       	movss  0x30(%rbx),%xmm0
  a4fc2a:	0f 2e c0             	ucomiss %xmm0,%xmm0
  a4fc2d:	0f 8a 91 00 00 00    	jp     a4fcc4 <gpui::native::accessibility::projected_node+0x5d4>
  a4fc33:	f3 0f 10 4b 34       	movss  0x34(%rbx),%xmm1
  a4fc38:	0f 14 c1             	unpcklps %xmm1,%xmm0
  a4fc3b:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  a4fc3e:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  a4fc43:	0f 5a 43 38          	cvtps2pd 0x38(%rbx),%xmm0
  a4fc47:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  a4fc4c:	0f 5a 43 40          	cvtps2pd 0x40(%rbx),%xmm0
  a4fc50:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a4fc55:	c6 44 24 50 00       	movb   $0x0,0x50(%rsp)
  a4fc5a:	66 0f 10 03          	movupd (%rbx),%xmm0
  a4fc5e:	66 0f 29 84 24 40 01 	movapd %xmm0,0x140(%rsp)
  a4fc65:	00 00 
  a4fc67:	48 8d bc 24 2c 01 00 	lea    0x12c(%rsp),%rdi
  a4fc6e:	00 
  a4fc6f:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  a4fc74:	48 8d 94 24 40 01 00 	lea    0x140(%rsp),%rdx
  a4fc7b:	00 
  a4fc7c:	ff 15 7e f8 ad 00    	call   *0xadf87e(%rip)        # 152f500 <_DYNAMIC+0x388>
  a4fc82:	83 bc 24 2c 01 00 00 	cmpl   $0x1,0x12c(%rsp)
  a4fc89:	01 
  a4fc8a:	75 38                	jne    a4fcc4 <gpui::native::accessibility::projected_node+0x5d4>
  a4fc8c:	0f 5a 84 24 30 01 00 	cvtps2pd 0x130(%rsp),%xmm0
  a4fc93:	00 
  a4fc94:	0f 5a 8c 24 38 01 00 	cvtps2pd 0x138(%rsp),%xmm1
  a4fc9b:	00 
  a4fc9c:	66 0f 58 c8          	addpd  %xmm0,%xmm1
  a4fca0:	66 0f 29 44 24 20    	movapd %xmm0,0x20(%rsp)
  a4fca6:	66 0f 29 4c 24 30    	movapd %xmm1,0x30(%rsp)
  a4fcac:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4fcb3:	00 
  a4fcb4:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a4fcb9:	be 53 00 00 00       	mov    $0x53,%esi
  a4fcbe:	ff 15 d4 0a ae 00    	call   *0xae0ad4(%rip)        # 1530798 <_DYNAMIC+0x1620>
  a4fcc4:	b8 4f 00 00 00       	mov    $0x4f,%eax
  a4fcc9:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  a4fcce:	0f a3 c8             	bt     %ecx,%eax
  a4fcd1:	73 67                	jae    a4fd3a <gpui::native::accessibility::projected_node+0x64a>
  a4fcd3:	4d 85 ed             	test   %r13,%r13
  a4fcd6:	74 6f                	je     a4fd47 <gpui::native::accessibility::projected_node+0x657>
  a4fcd8:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  a4fcdc:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  a4fce1:	4c 89 ee             	mov    %r13,%rsi
  a4fce4:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  a4fce9:	4c 8b 84 24 00 01 00 	mov    0x100(%rsp),%r8
  a4fcf0:	00 
  a4fcf1:	e8 5a 8f 00 00       	call   a58c50 <<gpui::runtime::scroll::ViewportColumn>::info>
  a4fcf6:	48 83 7c 24 20 02    	cmpq   $0x2,0x20(%rsp)
  a4fcfc:	0f 95 c0             	setne  %al
  a4fcff:	74 48                	je     a4fd49 <gpui::native::accessibility::projected_node+0x659>
  a4fd01:	f2 0f 10 44 24 28    	movsd  0x28(%rsp),%xmm0
  a4fd07:	f2 44 0f 10 44 24 30 	movsd  0x30(%rsp),%xmm8
  a4fd0e:	f2 0f 10 74 24 38    	movsd  0x38(%rsp),%xmm6
  a4fd14:	f2 0f 10 64 24 40    	movsd  0x40(%rsp),%xmm4
  a4fd1a:	f2 0f 10 7c 24 48    	movsd  0x48(%rsp),%xmm7
  a4fd20:	f2 0f 10 6c 24 50    	movsd  0x50(%rsp),%xmm5
  a4fd26:	0f b6 6c 24 68       	movzbl 0x68(%rsp),%ebp
  a4fd2b:	f3 0f 10 4b 30       	movss  0x30(%rbx),%xmm1
  a4fd30:	0f 2e c9             	ucomiss %xmm1,%xmm1
  a4fd33:	7b 22                	jnp    a4fd57 <gpui::native::accessibility::projected_node+0x667>
  a4fd35:	e9 58 02 00 00       	jmp    a4ff92 <gpui::native::accessibility::projected_node+0x8a2>
  a4fd3a:	80 8c 24 f9 00 00 00 	orb    $0x8,0xf9(%rsp)
  a4fd41:	08 
  a4fd42:	4d 85 ed             	test   %r13,%r13
  a4fd45:	75 91                	jne    a4fcd8 <gpui::native::accessibility::projected_node+0x5e8>
  a4fd47:	31 c0                	xor    %eax,%eax
  a4fd49:	f3 0f 10 4b 30       	movss  0x30(%rbx),%xmm1
  a4fd4e:	0f 2e c9             	ucomiss %xmm1,%xmm1
  a4fd51:	0f 8a 3b 02 00 00    	jp     a4ff92 <gpui::native::accessibility::projected_node+0x8a2>
  a4fd57:	0f 57 d2             	xorps  %xmm2,%xmm2
  a4fd5a:	0f 2e ca             	ucomiss %xmm2,%xmm1
  a4fd5d:	75 06                	jne    a4fd65 <gpui::native::accessibility::projected_node+0x675>
  a4fd5f:	0f 8b 2d 02 00 00    	jnp    a4ff92 <gpui::native::accessibility::projected_node+0x8a2>
  a4fd65:	f3 0f 10 5b 38       	movss  0x38(%rbx),%xmm3
  a4fd6a:	0f 2e da             	ucomiss %xmm2,%xmm3
  a4fd6d:	0f 85 1f 02 00 00    	jne    a4ff92 <gpui::native::accessibility::projected_node+0x8a2>
  a4fd73:	0f 8a 19 02 00 00    	jp     a4ff92 <gpui::native::accessibility::projected_node+0x8a2>
  a4fd79:	f3 0f 10 5b 34       	movss  0x34(%rbx),%xmm3
  a4fd7e:	0f 2e da             	ucomiss %xmm2,%xmm3
  a4fd81:	0f 85 0b 02 00 00    	jne    a4ff92 <gpui::native::accessibility::projected_node+0x8a2>
  a4fd87:	0f 8a 05 02 00 00    	jp     a4ff92 <gpui::native::accessibility::projected_node+0x8a2>
  a4fd8d:	f3 0f 10 5b 3c       	movss  0x3c(%rbx),%xmm3
  a4fd92:	0f 2e da             	ucomiss %xmm2,%xmm3
  a4fd95:	75 06                	jne    a4fd9d <gpui::native::accessibility::projected_node+0x6ad>
  a4fd97:	0f 8b f5 01 00 00    	jnp    a4ff92 <gpui::native::accessibility::projected_node+0x8a2>
  a4fd9d:	84 c0                	test   %al,%al
  a4fd9f:	0f 84 ed 01 00 00    	je     a4ff92 <gpui::native::accessibility::projected_node+0x8a2>
  a4fda5:	f3 0f 11 5c 24 18    	movss  %xmm3,0x18(%rsp)
  a4fdab:	f2 44 0f 11 04 24    	movsd  %xmm8,(%rsp)
  a4fdb1:	f2 0f 11 7c 24 10    	movsd  %xmm7,0x10(%rsp)
  a4fdb7:	0f 29 b4 24 10 01 00 	movaps %xmm6,0x110(%rsp)
  a4fdbe:	00 
  a4fdbf:	f2 0f 11 6c 24 08    	movsd  %xmm5,0x8(%rsp)
  a4fdc5:	0f 29 a4 24 00 01 00 	movaps %xmm4,0x100(%rsp)
  a4fdcc:	00 
  a4fdcd:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  a4fdd1:	f2 0f 11 8c 24 20 01 	movsd  %xmm1,0x120(%rsp)
  a4fdd8:	00 00 
  a4fdda:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a4fdde:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4fde5:	00 
  a4fde6:	be 24 00 00 00       	mov    $0x24,%esi
  a4fdeb:	ff 15 af 09 ae 00    	call   *0xae09af(%rip)        # 15307a0 <_DYNAMIC+0x1628>
  a4fdf1:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  a4fdf7:	0f 57 c9             	xorps  %xmm1,%xmm1
  a4fdfa:	f3 0f 5a c8          	cvtss2sd %xmm0,%xmm1
  a4fdfe:	f2 0f 10 04 24       	movsd  (%rsp),%xmm0
  a4fe03:	f2 0f 11 4c 24 18    	movsd  %xmm1,0x18(%rsp)
  a4fe09:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a4fe0d:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4fe14:	00 
  a4fe15:	be 27 00 00 00       	mov    $0x27,%esi
  a4fe1a:	ff 15 80 09 ae 00    	call   *0xae0980(%rip)        # 15307a0 <_DYNAMIC+0x1628>
  a4fe20:	66 0f 28 9c 24 10 01 	movapd 0x110(%rsp),%xmm3
  a4fe27:	00 00 
  a4fe29:	f2 0f 10 8c 24 20 01 	movsd  0x120(%rsp),%xmm1
  a4fe30:	00 00 
  a4fe32:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
  a4fe36:	f2 0f 10 44 24 10    	movsd  0x10(%rsp),%xmm0
  a4fe3c:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a4fe40:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a4fe44:	f2 0f 11 44 24 10    	movsd  %xmm0,0x10(%rsp)
  a4fe4a:	f2 0f 5d c8          	minsd  %xmm0,%xmm1
  a4fe4e:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a4fe52:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a4fe57:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a4fe5b:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a4fe5f:	66 0f 29 9c 24 10 01 	movapd %xmm3,0x110(%rsp)
  a4fe66:	00 00 
  a4fe68:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a4fe6c:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a4fe70:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4fe77:	00 
  a4fe78:	be 25 00 00 00       	mov    $0x25,%esi
  a4fe7d:	ff 15 1d 09 ae 00    	call   *0xae091d(%rip)        # 15307a0 <_DYNAMIC+0x1628>
  a4fe83:	66 0f 28 9c 24 10 01 	movapd 0x110(%rsp),%xmm3
  a4fe8a:	00 00 
  a4fe8c:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a4fe90:	f2 0f 5f 4c 24 10    	maxsd  0x10(%rsp),%xmm1
  a4fe96:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a4fe9a:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a4fe9f:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a4fea3:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a4fea7:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a4feab:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a4feaf:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4feb6:	00 
  a4feb7:	be 26 00 00 00       	mov    $0x26,%esi
  a4febc:	ff 15 de 08 ae 00    	call   *0xae08de(%rip)        # 15307a0 <_DYNAMIC+0x1628>
  a4fec2:	66 0f 28 9c 24 00 01 	movapd 0x100(%rsp),%xmm3
  a4fec9:	00 00 
  a4fecb:	f2 0f 10 4c 24 18    	movsd  0x18(%rsp),%xmm1
  a4fed1:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
  a4fed5:	f2 0f 10 44 24 08    	movsd  0x8(%rsp),%xmm0
  a4fedb:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a4fedf:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a4fee3:	f2 0f 11 44 24 08    	movsd  %xmm0,0x8(%rsp)
  a4fee9:	f2 0f 5d c8          	minsd  %xmm0,%xmm1
  a4feed:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a4fef1:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a4fef6:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a4fefa:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a4fefe:	66 0f 29 9c 24 00 01 	movapd %xmm3,0x100(%rsp)
  a4ff05:	00 00 
  a4ff07:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a4ff0b:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a4ff0f:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4ff16:	00 
  a4ff17:	be 28 00 00 00       	mov    $0x28,%esi
  a4ff1c:	ff 15 7e 08 ae 00    	call   *0xae087e(%rip)        # 15307a0 <_DYNAMIC+0x1628>
  a4ff22:	66 0f 28 9c 24 00 01 	movapd 0x100(%rsp),%xmm3
  a4ff29:	00 00 
  a4ff2b:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a4ff2f:	f2 0f 5f 4c 24 08    	maxsd  0x8(%rsp),%xmm1
  a4ff35:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a4ff39:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a4ff3e:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a4ff42:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a4ff46:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a4ff4a:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a4ff4e:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a4ff55:	00 
  a4ff56:	be 29 00 00 00       	mov    $0x29,%esi
  a4ff5b:	ff 15 3f 08 ae 00    	call   *0xae083f(%rip)        # 15307a0 <_DYNAMIC+0x1628>
  a4ff61:	40 f6 c5 01          	test   $0x1,%bpl
  a4ff65:	b9 00 00 02 00       	mov    $0x20000,%ecx
  a4ff6a:	b8 00 30 02 00       	mov    $0x23000,%eax
  a4ff6f:	0f 44 c1             	cmove  %ecx,%eax
  a4ff72:	0b 84 24 f0 00 00 00 	or     0xf0(%rsp),%eax
  a4ff79:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  a4ff80:	40 f6 c5 02          	test   $0x2,%bpl
  a4ff84:	74 0c                	je     a4ff92 <gpui::native::accessibility::projected_node+0x8a2>
  a4ff86:	0d 00 48 00 00       	or     $0x4800,%eax
  a4ff8b:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  a4ff92:	0f b6 43 4c          	movzbl 0x4c(%rbx),%eax
  a4ff96:	48 b9 01 02 04 08 10 	movabs $0x8040201008040201,%rcx
  a4ff9d:	20 40 80 
  a4ffa0:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  a4ffa5:	8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%ecx
  a4ffac:	31 ff                	xor    %edi,%edi
  a4ffae:	48 8d 15 bb c4 74 ff 	lea    -0x8b3b45(%rip),%rdx        # 19c470 <anon.68a54e84e457eea401d24dc6a9d93b0a.6.llvm.2319709713416821753+0x6fe>
  a4ffb5:	48 89 fe             	mov    %rdi,%rsi
  a4ffb8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a4ffbf:	00 
  a4ffc0:	0f b6 7c 34 30       	movzbl 0x30(%rsp,%rsi,1),%edi
  a4ffc5:	40 84 c7             	test   %al,%dil
  a4ffc8:	75 16                	jne    a4ffe0 <gpui::native::accessibility::projected_node+0x8f0>
  a4ffca:	48 ff c6             	inc    %rsi
  a4ffcd:	48 83 fe 08          	cmp    $0x8,%rsi
  a4ffd1:	75 ed                	jne    a4ffc0 <gpui::native::accessibility::projected_node+0x8d0>
  a4ffd3:	eb 5f                	jmp    a50034 <gpui::native::accessibility::projected_node+0x944>
  a4ffd5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  a4ffdc:	00 00 00 00 
  a4ffe0:	40 0f b6 ff          	movzbl %dil,%edi
  a4ffe4:	f3 0f bc ff          	tzcnt  %edi,%edi
  a4ffe8:	4c 63 04 ba          	movslq (%rdx,%rdi,4),%r8
  a4ffec:	49 01 d0             	add    %rdx,%r8
  a4ffef:	41 ff e0             	jmp    *%r8
  a4fff2:	48 8d 7e 01          	lea    0x1(%rsi),%rdi
  a4fff6:	48 83 fe 07          	cmp    $0x7,%rsi
  a4fffa:	75 b9                	jne    a4ffb5 <gpui::native::accessibility::projected_node+0x8c5>
  a4fffc:	eb 36                	jmp    a50034 <gpui::native::accessibility::projected_node+0x944>
  a4fffe:	bf 01 00 00 00       	mov    $0x1,%edi
  a50003:	eb 1b                	jmp    a50020 <gpui::native::accessibility::projected_node+0x930>
  a50005:	bf 0f 00 00 00       	mov    $0xf,%edi
  a5000a:	eb 14                	jmp    a50020 <gpui::native::accessibility::projected_node+0x930>
  a5000c:	bf 02 00 00 00       	mov    $0x2,%edi
  a50011:	eb 0d                	jmp    a50020 <gpui::native::accessibility::projected_node+0x930>
  a50013:	bf 14 00 00 00       	mov    $0x14,%edi
  a50018:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a5001f:	00 
  a50020:	0f ab f9             	bts    %edi,%ecx
  a50023:	89 8c 24 f0 00 00 00 	mov    %ecx,0xf0(%rsp)
  a5002a:	48 8d 7e 01          	lea    0x1(%rsi),%rdi
  a5002e:	48 83 fe 07          	cmp    $0x7,%rsi
  a50032:	75 81                	jne    a4ffb5 <gpui::native::accessibility::projected_node+0x8c5>
  a50034:	0f 10 84 24 f0 00 00 	movups 0xf0(%rsp),%xmm0
  a5003b:	00 
  a5003c:	41 0f 11 47 70       	movups %xmm0,0x70(%r15)
  a50041:	0f 10 84 24 e0 00 00 	movups 0xe0(%rsp),%xmm0
  a50048:	00 
  a50049:	41 0f 11 47 60       	movups %xmm0,0x60(%r15)
  a5004e:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  a50055:	00 
  a50056:	41 0f 11 47 50       	movups %xmm0,0x50(%r15)
  a5005b:	0f 10 84 24 c0 00 00 	movups 0xc0(%rsp),%xmm0
  a50062:	00 
  a50063:	41 0f 11 47 40       	movups %xmm0,0x40(%r15)
  a50068:	0f 10 84 24 80 00 00 	movups 0x80(%rsp),%xmm0
  a5006f:	00 
  a50070:	0f 10 8c 24 90 00 00 	movups 0x90(%rsp),%xmm1
  a50077:	00 
  a50078:	0f 10 94 24 a0 00 00 	movups 0xa0(%rsp),%xmm2
  a5007f:	00 
  a50080:	0f 10 9c 24 b0 00 00 	movups 0xb0(%rsp),%xmm3
  a50087:	00 
  a50088:	41 0f 11 5f 30       	movups %xmm3,0x30(%r15)
  a5008d:	41 0f 11 57 20       	movups %xmm2,0x20(%r15)
  a50092:	41 0f 11 4f 10       	movups %xmm1,0x10(%r15)
  a50097:	41 0f 11 07          	movups %xmm0,(%r15)
  a5009b:	4c 89 f8             	mov    %r15,%rax
  a5009e:	48 81 c4 58 01 00 00 	add    $0x158,%rsp
  a500a5:	5b                   	pop    %rbx
  a500a6:	41 5c                	pop    %r12
  a500a8:	41 5d                	pop    %r13
  a500aa:	41 5e                	pop    %r14
  a500ac:	41 5f                	pop    %r15
  a500ae:	5d                   	pop    %rbp
  a500af:	c3                   	ret
  a500b0:	bd 01 00 00 00       	mov    $0x1,%ebp
  a500b5:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a500ba:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  a500bf:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a500c4:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a500c9:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a500d0:	00 
  a500d1:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a500d6:	be 11 00 00 00       	mov    $0x11,%esi
  a500db:	ff 15 9f 06 ae 00    	call   *0xae069f(%rip)        # 1530780 <_DYNAMIC+0x1608>
  a500e1:	e9 55 f8 ff ff       	jmp    a4f93b <gpui::native::accessibility::projected_node+0x24b>
  a500e6:	31 f6                	xor    %esi,%esi
  a500e8:	48 89 f7             	mov    %rsi,%rdi
  a500eb:	49 89 d0             	mov    %rdx,%r8
  a500ee:	49 d1 e8             	shr    $1,%r8
  a500f1:	4c 01 c6             	add    %r8,%rsi
  a500f4:	49 89 f1             	mov    %rsi,%r9
  a500f7:	49 c1 e1 04          	shl    $0x4,%r9
  a500fb:	4a 39 0c 08          	cmp    %rcx,(%rax,%r9,1)
  a500ff:	48 0f 47 f7          	cmova  %rdi,%rsi
  a50103:	4c 29 c2             	sub    %r8,%rdx
  a50106:	48 83 fa 01          	cmp    $0x1,%rdx
  a5010a:	77 dc                	ja     a500e8 <gpui::native::accessibility::projected_node+0x9f8>
  a5010c:	48 c1 e6 04          	shl    $0x4,%rsi
  a50110:	48 39 0c 30          	cmp    %rcx,(%rax,%rsi,1)
  a50114:	0f 85 01 f7 ff ff    	jne    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a5011a:	48 01 f0             	add    %rsi,%rax
  a5011d:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
  a50122:	40 0f 95 c5          	setne  %bpl
  a50126:	40 c0 e5 06          	shl    $0x6,%bpl
  a5012a:	40 80 cd 0e          	or     $0xe,%bpl
  a5012e:	e9 e8 f6 ff ff       	jmp    a4f81b <gpui::native::accessibility::projected_node+0x12b>
  a50133:	48 8d 15 1e 07 a7 00 	lea    0xa7071e(%rip),%rdx        # 14c0858 <anon.a825392c48d1f25659fd13eba8732c03.6.llvm.7382778784098134658>
  a5013a:	ff 15 e8 f2 ad 00    	call   *0xadf2e8(%rip)        # 152f428 <_DYNAMIC+0x2b0>
  a50140:	48 89 c3             	mov    %rax,%rbx
  a50143:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a5014a:	00 
  a5014b:	e8 80 c2 ff ff       	call   a4c3d0 <core::ptr::drop_glue::<accesskit::Node>>
  a50150:	48 89 df             	mov    %rbx,%rdi
  a50153:	e8 98 9a a6 00       	call   14b9bf0 <_Unwind_Resume@plt>
  a50158:	ff 15 a2 f2 ad 00    	call   *0xadf2a2(%rip)        # 152f400 <_DYNAMIC+0x288>

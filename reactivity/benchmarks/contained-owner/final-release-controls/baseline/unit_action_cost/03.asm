
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070d7c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor>:
  70d7c0:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70d7c7:	48 85 c0             	test   %rax,%rax
  70d7ca:	0f 84 f4 00 00 00    	je     70d8c4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0x104>
  70d7d0:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70d7d7:	48 85 c0             	test   %rax,%rax
  70d7da:	0f 84 e4 00 00 00    	je     70d8c4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0x104>
  70d7e0:	89 d1                	mov    %edx,%ecx
  70d7e2:	c1 e9 08             	shr    $0x8,%ecx
  70d7e5:	44 0f b6 40 13       	movzbl 0x13(%rax),%r8d
  70d7ea:	41 80 f8 ff          	cmp    $0xff,%r8b
  70d7ee:	0f 84 8e 00 00 00    	je     70d882 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xc2>
  70d7f4:	45 31 c9             	xor    %r9d,%r9d
  70d7f7:	41 80 f8 06          	cmp    $0x6,%r8b
  70d7fb:	41 0f 92 c1          	setb   %r9b
  70d7ff:	41 0f 93 c2          	setae  %r10b
  70d803:	41 38 d0             	cmp    %dl,%r8b
  70d806:	41 0f 94 c3          	sete   %r11b
  70d80a:	45 20 d3             	and    %r10b,%r11b
  70d80d:	80 fa 06             	cmp    $0x6,%dl
  70d810:	45 0f b6 d3          	movzbl %r11b,%r10d
  70d814:	45 0f 43 ca          	cmovae %r10d,%r9d
  70d818:	45 84 c9             	test   %r9b,%r9b
  70d81b:	74 65                	je     70d882 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xc2>
  70d81d:	41 80 f8 05          	cmp    $0x5,%r8b
  70d821:	77 2b                	ja     70d84e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0x8e>
  70d823:	41 38 d0             	cmp    %dl,%r8b
  70d826:	75 5a                	jne    70d882 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xc2>
  70d828:	44 0f b7 c1          	movzwl %cx,%r8d
  70d82c:	80 fa 05             	cmp    $0x5,%dl
  70d82f:	74 0a                	je     70d83b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0x7b>
  70d831:	44 0f b6 ca          	movzbl %dl,%r9d
  70d835:	41 83 f9 04          	cmp    $0x4,%r9d
  70d839:	75 13                	jne    70d84e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0x8e>
  70d83b:	44 38 40 14          	cmp    %r8b,0x14(%rax)
  70d83f:	75 41                	jne    70d882 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xc2>
  70d841:	41 89 d0             	mov    %edx,%r8d
  70d844:	41 c1 e8 10          	shr    $0x10,%r8d
  70d848:	44 38 40 15          	cmp    %r8b,0x15(%rax)
  70d84c:	75 34                	jne    70d882 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xc2>
  70d84e:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  70d855:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  70d85c:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  70d863:	00 
  70d864:	74 3a                	je     70d8a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xe0>
  70d866:	84 c0                	test   %al,%al
  70d868:	74 0a                	je     70d874 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xb4>
  70d86a:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  70d871:	ff 
  70d872:	74 2c                	je     70d8a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xe0>
  70d874:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  70d87b:	b9 01 00 00 00       	mov    $0x1,%ecx
  70d880:	eb 20                	jmp    70d8a2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xe2>
  70d882:	88 50 13             	mov    %dl,0x13(%rax)
  70d885:	66 89 48 14          	mov    %cx,0x14(%rax)
  70d889:	48 c7 86 08 07 00 00 	movq   $0x0,0x708(%rsi)
  70d890:	00 00 00 00 
  70d894:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  70d89b:	e9 50 02 01 00       	jmp    71daf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70d8a0:	31 c9                	xor    %ecx,%ecx
  70d8a2:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  70d8a9:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70d8ad:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  70d8b1:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  70d8b5:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  70d8b9:	88 47 30             	mov    %al,0x30(%rdi)
  70d8bc:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70d8c3:	c3                   	ret
  70d8c4:	50                   	push   %rax
  70d8c5:	48 8d 3d f9 b9 95 ff 	lea    -0x6a4607(%rip),%rdi        # 692c5 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c35>
  70d8cc:	48 8d 15 cd 5b 3c 00 	lea    0x3c5bcd(%rip),%rdx        # ad34a0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x888>
  70d8d3:	be 11 00 00 00       	mov    $0x11,%esi
  70d8d8:	ff 15 7a 3b 3f 00    	call   *0x3f3b7a(%rip)        # b01458 <_DYNAMIC+0x368>


/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000007078f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>:
  7078f0:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  7078f7:	48 85 c0             	test   %rax,%rax
  7078fa:	0f 84 f4 00 00 00    	je     7079f4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x104>
  707900:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  707907:	48 85 c0             	test   %rax,%rax
  70790a:	0f 84 e4 00 00 00    	je     7079f4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x104>
  707910:	89 d1                	mov    %edx,%ecx
  707912:	c1 e9 08             	shr    $0x8,%ecx
  707915:	44 0f b6 40 13       	movzbl 0x13(%rax),%r8d
  70791a:	41 80 f8 ff          	cmp    $0xff,%r8b
  70791e:	0f 84 8e 00 00 00    	je     7079b2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  707924:	45 31 c9             	xor    %r9d,%r9d
  707927:	41 80 f8 06          	cmp    $0x6,%r8b
  70792b:	41 0f 92 c1          	setb   %r9b
  70792f:	41 0f 93 c2          	setae  %r10b
  707933:	41 38 d0             	cmp    %dl,%r8b
  707936:	41 0f 94 c3          	sete   %r11b
  70793a:	45 20 d3             	and    %r10b,%r11b
  70793d:	80 fa 06             	cmp    $0x6,%dl
  707940:	45 0f b6 d3          	movzbl %r11b,%r10d
  707944:	45 0f 43 ca          	cmovae %r10d,%r9d
  707948:	45 84 c9             	test   %r9b,%r9b
  70794b:	74 65                	je     7079b2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  70794d:	41 80 f8 05          	cmp    $0x5,%r8b
  707951:	77 2b                	ja     70797e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x8e>
  707953:	41 38 d0             	cmp    %dl,%r8b
  707956:	75 5a                	jne    7079b2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  707958:	44 0f b7 c1          	movzwl %cx,%r8d
  70795c:	80 fa 05             	cmp    $0x5,%dl
  70795f:	74 0a                	je     70796b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x7b>
  707961:	44 0f b6 ca          	movzbl %dl,%r9d
  707965:	41 83 f9 04          	cmp    $0x4,%r9d
  707969:	75 13                	jne    70797e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0x8e>
  70796b:	44 38 40 14          	cmp    %r8b,0x14(%rax)
  70796f:	75 41                	jne    7079b2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  707971:	41 89 d0             	mov    %edx,%r8d
  707974:	41 c1 e8 10          	shr    $0x10,%r8d
  707978:	44 38 40 15          	cmp    %r8b,0x15(%rax)
  70797c:	75 34                	jne    7079b2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xc2>
  70797e:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  707985:	0f b6 86 20 08 00 00 	movzbl 0x820(%rsi),%eax
  70798c:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  707993:	00 
  707994:	74 3a                	je     7079d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe0>
  707996:	84 c0                	test   %al,%al
  707998:	74 0a                	je     7079a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xb4>
  70799a:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  7079a1:	ff 
  7079a2:	74 2c                	je     7079d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe0>
  7079a4:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  7079ab:	b9 01 00 00 00       	mov    $0x1,%ecx
  7079b0:	eb 20                	jmp    7079d2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor+0xe2>
  7079b2:	88 50 13             	mov    %dl,0x13(%rax)
  7079b5:	66 89 48 14          	mov    %cx,0x14(%rax)
  7079b9:	48 c7 86 08 07 00 00 	movq   $0x0,0x708(%rsi)
  7079c0:	00 00 00 00 
  7079c4:	c6 86 1f 08 00 00 01 	movb   $0x1,0x81f(%rsi)
  7079cb:	e9 50 1f 01 00       	jmp    719920 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  7079d0:	31 c9                	xor    %ecx,%ecx
  7079d2:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  7079d9:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  7079dd:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  7079e1:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  7079e5:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  7079e9:	88 47 30             	mov    %al,0x30(%rdi)
  7079ec:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  7079f3:	c3                   	ret
  7079f4:	50                   	push   %rax
  7079f5:	48 8d 3d c9 29 96 ff 	lea    -0x69d637(%rip),%rdi        # 6a3c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32d8>
  7079fc:	48 8d 15 8d 22 3f 00 	lea    0x3f228d(%rip),%rdx        # af9c90 <__frame_dummy_init_array_entry+0x768>
  707a03:	be 11 00 00 00       	mov    $0x11,%esi
  707a08:	ff 15 f2 05 42 00    	call   *0x4205f2(%rip)        # b28000 <_DYNAMIC+0x348>

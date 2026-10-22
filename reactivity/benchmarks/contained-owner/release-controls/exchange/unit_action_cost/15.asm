
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

00000000007075b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property>:
  7075b0:	55                   	push   %rbp
  7075b1:	41 57                	push   %r15
  7075b3:	41 56                	push   %r14
  7075b5:	41 55                	push   %r13
  7075b7:	41 54                	push   %r12
  7075b9:	53                   	push   %rbx
  7075ba:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
  7075c1:	49 89 cc             	mov    %rcx,%r12
  7075c4:	49 89 f6             	mov    %rsi,%r14
  7075c7:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  7075cc:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  7075d3:	48 39 f1             	cmp    %rsi,%rcx
  7075d6:	0f 83 97 05 00 00    	jae    707b73 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5c3>
  7075dc:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  7075e3:	4b 8d 1c a4          	lea    (%r12,%r12,4),%rbx
  7075e7:	48 8b 74 d8 08       	mov    0x8(%rax,%rbx,8),%rsi
  7075ec:	48 8b 4c d8 10       	mov    0x10(%rax,%rbx,8),%rcx
  7075f1:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  7075f8:	00 00 
  7075fa:	48 85 f6             	test   %rsi,%rsi
  7075fd:	0f 84 49 05 00 00    	je     707b4c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x59c>
  707603:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  70760a:	00 
  70760b:	4c 89 84 24 e0 00 00 	mov    %r8,0xe0(%rsp)
  707612:	00 
  707613:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  707618:	48 89 b4 24 f0 00 00 	mov    %rsi,0xf0(%rsp)
  70761f:	00 
  707620:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  707625:	48 89 8c 24 f8 00 00 	mov    %rcx,0xf8(%rsp)
  70762c:	00 
  70762d:	49 8b 86 60 06 00 00 	mov    0x660(%r14),%rax
  707634:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  70763b:	00 
  70763c:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  707643:	48 8d 0d 6e c3 3c 00 	lea    0x3cc36e(%rip),%rcx        # ad39b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  70764a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70764f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  707656:	00 
  707657:	48 89 ea             	mov    %rbp,%rdx
  70765a:	ff 15 80 aa 3f 00    	call   *0x3faa80(%rip)        # b020e0 <_DYNAMIC+0x398>
  707660:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  707666:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  70766b:	0f 84 f6 00 00 00    	je     707767 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1b7>
  707671:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  707676:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  70767b:	8b 74 24 24          	mov    0x24(%rsp),%esi
  70767f:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  707684:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  70768a:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  707690:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  707694:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  707699:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  7076a0:	00 
  7076a1:	66 45 85 ff          	test   %r15w,%r15w
  7076a5:	0f 84 f8 00 00 00    	je     7077a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1f3>
  7076ab:	41 c1 e1 10          	shl    $0x10,%r9d
  7076af:	45 09 c8             	or     %r9d,%r8d
  7076b2:	49 c1 e0 20          	shl    $0x20,%r8
  7076b6:	4c 09 c1             	or     %r8,%rcx
  7076b9:	89 b4 24 04 01 00 00 	mov    %esi,0x104(%rsp)
  7076c0:	40 88 bc 24 08 01 00 	mov    %dil,0x108(%rsp)
  7076c7:	00 
  7076c8:	89 8c 24 09 01 00 00 	mov    %ecx,0x109(%rsp)
  7076cf:	48 89 ce             	mov    %rcx,%rsi
  7076d2:	48 c1 ee 30          	shr    $0x30,%rsi
  7076d6:	40 88 b4 24 0f 01 00 	mov    %sil,0x10f(%rsp)
  7076dd:	00 
  7076de:	48 c1 e9 20          	shr    $0x20,%rcx
  7076e2:	66 89 8c 24 0d 01 00 	mov    %cx,0x10d(%rsp)
  7076e9:	00 
  7076ea:	0f 28 84 24 20 01 00 	movaps 0x120(%rsp),%xmm0
  7076f1:	00 
  7076f2:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  7076f9:	00 
  7076fa:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  707701:	49 ff c5             	inc    %r13
  707704:	0f 84 5b 04 00 00    	je     707b65 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5b5>
  70770a:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  707711:	0f 85 93 00 00 00    	jne    7077aa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1fa>
  707717:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70771c:	4c 89 f6             	mov    %r14,%rsi
  70771f:	e8 ec 65 01 00       	call   71dd10 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  707724:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  70772a:	0f 85 83 00 00 00    	jne    7077b3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x203>
  707730:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  707735:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  70773a:	4c 8d 84 24 04 01 00 	lea    0x104(%rsp),%r8
  707741:	00 
  707742:	4c 89 f6             	mov    %r14,%rsi
  707745:	44 89 f9             	mov    %r15d,%ecx
  707748:	e8 23 76 01 00       	call   71ed70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at>
  70774d:	4d 89 e7             	mov    %r12,%r15
  707750:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  707755:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707759:	0f 85 9e 00 00 00    	jne    7077fd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x24d>
  70775f:	45 31 c0             	xor    %r8d,%r8d
  707762:	e9 bb 00 00 00       	jmp    707822 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x272>
  707767:	0f b6 74 24 28       	movzbl 0x28(%rsp),%esi
  70776c:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  707771:	c1 e0 10             	shl    $0x10,%eax
  707774:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  707779:	09 c1                	or     %eax,%ecx
  70777b:	48 c1 e1 20          	shl    $0x20,%rcx
  70777f:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  707783:	48 09 cd             	or     %rcx,%rbp
  707786:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70778b:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  707792:	00 
  707793:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  707798:	41 bd 20 00 00 00    	mov    $0x20,%r13d
  70779e:	e9 bf 01 00 00       	jmp    707962 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3b2>
  7077a3:	31 f6                	xor    %esi,%esi
  7077a5:	e9 66 01 00 00       	jmp    707910 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x360>
  7077aa:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  7077b1:	00 00 
  7077b3:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7077b8:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  7077bf:	00 
  7077c0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7077c5:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  7077ca:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  7077cf:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  7077d4:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  7077db:	00 
  7077dc:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  7077e1:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  7077e6:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  7077eb:	4d 89 e7             	mov    %r12,%r15
  7077ee:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  7077f3:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  7077f7:	0f 84 62 ff ff ff    	je     70775f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1af>
  7077fd:	4c 89 e1             	mov    %r12,%rcx
  707800:	48 83 e9 0d          	sub    $0xd,%rcx
  707804:	b8 14 00 00 00       	mov    $0x14,%eax
  707809:	48 0f 4d c1          	cmovge %rcx,%rax
  70780d:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  707812:	48 83 f8 17          	cmp    $0x17,%rax
  707816:	74 0a                	je     707822 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x272>
  707818:	48 83 f8 04          	cmp    $0x4,%rax
  70781c:	0f 85 f7 00 00 00    	jne    707919 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x369>
  707822:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  707829:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  707830:	48 8d 0d 81 c1 3c 00 	lea    0x3cc181(%rip),%rcx        # ad39b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  707837:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  70783e:	00 
  70783f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  707846:	00 
  707847:	48 89 ea             	mov    %rbp,%rdx
  70784a:	ff 15 98 a8 3f 00    	call   *0x3fa898(%rip)        # b020e8 <_DYNAMIC+0x3a0>
  707850:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  707855:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  70785a:	48 8b b4 24 30 01 00 	mov    0x130(%rsp),%rsi
  707861:	00 
  707862:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  707866:	74 69                	je     7078d1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x321>
  707868:	48 89 f5             	mov    %rsi,%rbp
  70786b:	48 c1 ed 08          	shr    $0x8,%rbp
  70786f:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  707876:	00 
  707877:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  70787c:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707880:	74 44                	je     7078c6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x316>
  707882:	49 83 ec 0d          	sub    $0xd,%r12
  707886:	ba 14 00 00 00       	mov    $0x14,%edx
  70788b:	49 0f 4d d4          	cmovge %r12,%rdx
  70788f:	48 83 fa 19          	cmp    $0x19,%rdx
  707893:	74 09                	je     70789e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x2ee>
  707895:	48 89 c8             	mov    %rcx,%rax
  707898:	48 83 fa 14          	cmp    $0x14,%rdx
  70789c:	75 28                	jne    7078c6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x316>
  70789e:	49 89 f5             	mov    %rsi,%r13
  7078a1:	48 8b 30             	mov    (%rax),%rsi
  7078a4:	48 85 f6             	test   %rsi,%rsi
  7078a7:	74 0f                	je     7078b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x308>
  7078a9:	48 8b 78 08          	mov    0x8(%rax),%rdi
  7078ad:	ba 01 00 00 00       	mov    $0x1,%edx
  7078b2:	ff 15 d8 a6 3f 00    	call   *0x3fa6d8(%rip)        # b01f90 <_DYNAMIC+0x248>
  7078b8:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  7078be:	4c 89 ee             	mov    %r13,%rsi
  7078c1:	e9 96 00 00 00       	jmp    70795c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3ac>
  7078c6:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  7078cc:	e9 8b 00 00 00       	jmp    70795c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3ac>
  7078d1:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  7078d5:	74 33                	je     70790a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x35a>
  7078d7:	49 83 ec 0d          	sub    $0xd,%r12
  7078db:	ba 14 00 00 00       	mov    $0x14,%edx
  7078e0:	49 0f 4d d4          	cmovge %r12,%rdx
  7078e4:	48 83 fa 19          	cmp    $0x19,%rdx
  7078e8:	74 09                	je     7078f3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x343>
  7078ea:	48 89 c8             	mov    %rcx,%rax
  7078ed:	48 83 fa 14          	cmp    $0x14,%rdx
  7078f1:	75 17                	jne    70790a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x35a>
  7078f3:	48 8b 30             	mov    (%rax),%rsi
  7078f6:	48 85 f6             	test   %rsi,%rsi
  7078f9:	74 0f                	je     70790a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x35a>
  7078fb:	48 8b 78 08          	mov    0x8(%rax),%rdi
  7078ff:	ba 01 00 00 00       	mov    $0x1,%edx
  707904:	ff 15 86 a6 3f 00    	call   *0x3fa686(%rip)        # b01f90 <_DYNAMIC+0x248>
  70790a:	40 b6 01             	mov    $0x1,%sil
  70790d:	4d 89 fc             	mov    %r15,%r12
  707910:	49 c7 c5 fe ff ff ff 	mov    $0xfffffffffffffffe,%r13
  707917:	eb 49                	jmp    707962 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3b2>
  707919:	0f b6 74 24 68       	movzbl 0x68(%rsp),%esi
  70791e:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  707923:	c1 e0 10             	shl    $0x10,%eax
  707926:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  70792b:	09 c1                	or     %eax,%ecx
  70792d:	48 c1 e1 20          	shl    $0x20,%rcx
  707931:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  707935:	48 09 cd             	or     %rcx,%rbp
  707938:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70793d:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  707942:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  707949:	00 
  70794a:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  70794f:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  707956:	00 
  707957:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  70795c:	4d 89 e5             	mov    %r12,%r13
  70795f:	4d 89 fc             	mov    %r15,%r12
  707962:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  707967:	40 0f b6 c6          	movzbl %sil,%eax
  70796b:	48 c1 e5 08          	shl    $0x8,%rbp
  70796f:	48 09 c5             	or     %rax,%rbp
  707972:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  707977:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  70797c:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  707983:	00 
  707984:	0f 11 8c 24 c0 00 00 	movups %xmm1,0xc0(%rsp)
  70798b:	00 
  70798c:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707991:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  707998:	00 
  707999:	4c 89 ac 24 a0 00 00 	mov    %r13,0xa0(%rsp)
  7079a0:	00 
  7079a1:	48 89 ac 24 a8 00 00 	mov    %rbp,0xa8(%rsp)
  7079a8:	00 
  7079a9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7079b0:	49 39 f4             	cmp    %rsi,%r12
  7079b3:	0f 83 8d 02 00 00    	jae    707c46 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x696>
  7079b9:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  7079c0:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  7079c4:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  7079c9:	4d 85 ff             	test   %r15,%r15
  7079cc:	74 28                	je     7079f6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x446>
  7079ce:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  7079d3:	48 8b 03             	mov    (%rbx),%rax
  7079d6:	48 85 c0             	test   %rax,%rax
  7079d9:	74 05                	je     7079e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x430>
  7079db:	4c 89 ff             	mov    %r15,%rdi
  7079de:	ff d0                	call   *%rax
  7079e0:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  7079e4:	48 85 f6             	test   %rsi,%rsi
  7079e7:	74 0d                	je     7079f6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x446>
  7079e9:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  7079ed:	4c 89 ff             	mov    %r15,%rdi
  7079f0:	ff 15 9a a5 3f 00    	call   *0x3fa59a(%rip)        # b01f90 <_DYNAMIC+0x248>
  7079f6:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  7079fb:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  707a00:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  707a05:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  707a0a:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  707a0e:	74 35                	je     707a45 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x495>
  707a10:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  707a14:	75 77                	jne    707a8d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4dd>
  707a16:	80 7c 24 58 01       	cmpb   $0x1,0x58(%rsp)
  707a1b:	0f 85 bb 00 00 00    	jne    707adc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x52c>
  707a21:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  707a26:	4c 89 f6             	mov    %r14,%rsi
  707a29:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  707a30:	00 
  707a31:	31 c9                	xor    %ecx,%ecx
  707a33:	4c 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%r8
  707a3a:	00 
  707a3b:	e8 70 06 00 00       	call   7080b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>
  707a40:	e9 f5 00 00 00       	jmp    707b3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x58a>
  707a45:	4c 89 f7             	mov    %r14,%rdi
  707a48:	e8 53 69 01 00       	call   71e3a0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  707a4d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707a52:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  707a59:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  707a60:	00 
  707a61:	48 8b 03             	mov    (%rbx),%rax
  707a64:	48 85 c0             	test   %rax,%rax
  707a67:	74 05                	je     707a6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4be>
  707a69:	48 89 ef             	mov    %rbp,%rdi
  707a6c:	ff d0                	call   *%rax
  707a6e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707a72:	48 85 f6             	test   %rsi,%rsi
  707a75:	0f 84 bf 00 00 00    	je     707b3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x58a>
  707a7b:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707a7f:	48 89 ef             	mov    %rbp,%rdi
  707a82:	ff 15 08 a5 3f 00    	call   *0x3fa508(%rip)        # b01f90 <_DYNAMIC+0x248>
  707a88:	e9 ad 00 00 00       	jmp    707b3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x58a>
  707a8d:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  707a94:	00 
  707a95:	49 39 86 60 06 00 00 	cmp    %rax,0x660(%r14)
  707a9c:	74 08                	je     707aa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4f6>
  707a9e:	4c 89 f7             	mov    %r14,%rdi
  707aa1:	e8 fa 68 01 00       	call   71e3a0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  707aa6:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  707aad:	00 
  707aae:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  707ab3:	48 89 41 30          	mov    %rax,0x30(%rcx)
  707ab7:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  707abe:	00 
  707abf:	0f 10 8c 24 b0 00 00 	movups 0xb0(%rsp),%xmm1
  707ac6:	00 
  707ac7:	0f 10 94 24 c0 00 00 	movups 0xc0(%rsp),%xmm2
  707ace:	00 
  707acf:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  707ad3:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  707ad7:	0f 11 01             	movups %xmm0,(%rcx)
  707ada:	eb 5e                	jmp    707b3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x58a>
  707adc:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  707ae3:	00 
  707ae4:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  707aeb:	00 
  707aec:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  707af3:	00 
  707af4:	74 0e                	je     707b04 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x554>
  707af6:	84 c0                	test   %al,%al
  707af8:	74 0e                	je     707b08 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x558>
  707afa:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  707b01:	ff 
  707b02:	75 04                	jne    707b08 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x558>
  707b04:	31 c9                	xor    %ecx,%ecx
  707b06:	eb 0c                	jmp    707b14 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x564>
  707b08:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  707b0f:	b9 01 00 00 00       	mov    $0x1,%ecx
  707b14:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  707b1b:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  707b20:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  707b24:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  707b28:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  707b2c:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  707b30:	88 47 30             	mov    %al,0x30(%rdi)
  707b33:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  707b3a:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  707b41:	5b                   	pop    %rbx
  707b42:	41 5c                	pop    %r12
  707b44:	41 5d                	pop    %r13
  707b46:	41 5e                	pop    %r14
  707b48:	41 5f                	pop    %r15
  707b4a:	5d                   	pop    %rbp
  707b4b:	c3                   	ret
  707b4c:	48 8d 3d 50 ef 95 ff 	lea    -0x6a10b0(%rip),%rdi        # 66aa3 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e3>
  707b53:	48 8d 15 26 c2 3c 00 	lea    0x3cc226(%rip),%rdx        # ad3d80 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x598>
  707b5a:	be 0e 00 00 00       	mov    $0xe,%esi
  707b5f:	ff 15 4b a5 3f 00    	call   *0x3fa54b(%rip)        # b020b0 <_DYNAMIC+0x368>
  707b65:	4d 89 e7             	mov    %r12,%r15
  707b68:	41 bc 1f 00 00 00    	mov    $0x1f,%r12d
  707b6e:	e9 e9 fd ff ff       	jmp    70795c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3ac>
  707b73:	48 8d 15 ee c1 3c 00 	lea    0x3cc1ee(%rip),%rdx        # ad3d68 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x580>
  707b7a:	4c 89 e7             	mov    %r12,%rdi
  707b7d:	ff 15 3d a5 3f 00    	call   *0x3fa53d(%rip)        # b020c0 <_DYNAMIC+0x378>
  707b83:	49 89 c6             	mov    %rax,%r14
  707b86:	e9 f1 00 00 00       	jmp    707c7c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6cc>
  707b8b:	49 89 c6             	mov    %rax,%r14
  707b8e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707b92:	48 85 f6             	test   %rsi,%rsi
  707b95:	0f 84 ee 00 00 00    	je     707c89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6d9>
  707b9b:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707b9f:	48 89 ef             	mov    %rbp,%rdi
  707ba2:	ff 15 e8 a3 3f 00    	call   *0x3fa3e8(%rip)        # b01f90 <_DYNAMIC+0x248>
  707ba8:	4c 89 f7             	mov    %r14,%rdi
  707bab:	e8 00 a8 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  707bb0:	49 89 c5             	mov    %rax,%r13
  707bb3:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707bb7:	74 46                	je     707bff <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x64f>
  707bb9:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  707bbe:	e8 0d cb ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707bc3:	eb 3a                	jmp    707bff <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x64f>
  707bc5:	49 89 c6             	mov    %rax,%r14
  707bc8:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707bcc:	48 85 f6             	test   %rsi,%rsi
  707bcf:	74 0d                	je     707bde <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x62e>
  707bd1:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707bd5:	4c 89 ff             	mov    %r15,%rdi
  707bd8:	ff 15 b2 a3 3f 00    	call   *0x3fa3b2(%rip)        # b01f90 <_DYNAMIC+0x248>
  707bde:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  707be3:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  707be8:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  707bed:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  707bf2:	eb 7c                	jmp    707c70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6c0>
  707bf4:	49 89 c6             	mov    %rax,%r14
  707bf7:	eb 77                	jmp    707c70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6c0>
  707bf9:	4d 89 e7             	mov    %r12,%r15
  707bfc:	49 89 c5             	mov    %rax,%r13
  707bff:	4c 89 ef             	mov    %r13,%rdi
  707c02:	ff 15 c8 a4 3f 00    	call   *0x3fa4c8(%rip)        # b020d0 <_DYNAMIC+0x388>
  707c08:	48 89 c5             	mov    %rax,%rbp
  707c0b:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  707c12:	00 
  707c13:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  707c1a:	00 
  707c1b:	48 c7 84 24 a0 00 00 	movq   $0xfffffffffffffffd,0xa0(%rsp)
  707c22:	00 fd ff ff ff 
  707c27:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  707c2c:	4d 89 fc             	mov    %r15,%r12
  707c2f:	49 c7 c5 fd ff ff ff 	mov    $0xfffffffffffffffd,%r13
  707c36:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707c3d:	49 39 f4             	cmp    %rsi,%r12
  707c40:	0f 82 73 fd ff ff    	jb     7079b9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x409>
  707c46:	48 8d 15 4b c1 3c 00 	lea    0x3cc14b(%rip),%rdx        # ad3d98 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x5b0>
  707c4d:	4c 89 e7             	mov    %r12,%rdi
  707c50:	ff 15 6a a4 3f 00    	call   *0x3fa46a(%rip)        # b020c0 <_DYNAMIC+0x378>
  707c56:	0f 0b                	ud2
  707c58:	ff 15 7a a4 3f 00    	call   *0x3fa47a(%rip)        # b020d8 <_DYNAMIC+0x390>
  707c5e:	49 89 c6             	mov    %rax,%r14
  707c61:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  707c66:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  707c6b:	e8 20 9b ff ff       	call   701790 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  707c70:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  707c74:	74 1b                	je     707c91 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6e1>
  707c76:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  707c7a:	74 0d                	je     707c89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6d9>
  707c7c:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  707c83:	00 
  707c84:	e8 47 ca ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707c89:	4c 89 f7             	mov    %r14,%rdi
  707c8c:	e8 1f a7 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  707c91:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  707c98:	00 
  707c99:	e8 92 9f ff ff       	call   701c30 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707c9e:	eb e9                	jmp    707c89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6d9>
  707ca0:	ff 15 3a a3 3f 00    	call   *0x3fa33a(%rip)        # b01fe0 <_DYNAMIC+0x298>

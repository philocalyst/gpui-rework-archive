
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
  7075c1:	49 89 f6             	mov    %rsi,%r14
  7075c4:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  7075c9:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  7075d0:	48 39 f1             	cmp    %rsi,%rcx
  7075d3:	0f 83 a7 05 00 00    	jae    707b80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5d0>
  7075d9:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  7075e0:	48 89 0c 24          	mov    %rcx,(%rsp)
  7075e4:	48 8d 1c 89          	lea    (%rcx,%rcx,4),%rbx
  7075e8:	48 8b 4c d8 08       	mov    0x8(%rax,%rbx,8),%rcx
  7075ed:	4c 8b 64 d8 10       	mov    0x10(%rax,%rbx,8),%r12
  7075f2:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  7075f9:	00 00 
  7075fb:	48 85 c9             	test   %rcx,%rcx
  7075fe:	0f 84 59 05 00 00    	je     707b5d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5ad>
  707604:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  70760b:	00 
  70760c:	4c 89 84 24 e0 00 00 	mov    %r8,0xe0(%rsp)
  707613:	00 
  707614:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  707619:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  707620:	00 
  707621:	4c 89 a4 24 f8 00 00 	mov    %r12,0xf8(%rsp)
  707628:	00 
  707629:	49 8b 86 60 06 00 00 	mov    0x660(%r14),%rax
  707630:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  707637:	00 
  707638:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  70763f:	48 8d 0d 72 c3 3c 00 	lea    0x3cc372(%rip),%rcx        # ad39b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  707646:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70764b:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  707652:	00 
  707653:	48 89 ea             	mov    %rbp,%rdx
  707656:	4c 89 64 24 58       	mov    %r12,0x58(%rsp)
  70765b:	ff 15 7f aa 3f 00    	call   *0x3faa7f(%rip)        # b020e0 <_DYNAMIC+0x398>
  707661:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  707667:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  70766c:	0f 84 f6 00 00 00    	je     707768 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1b8>
  707672:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  707677:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  70767c:	8b 74 24 24          	mov    0x24(%rsp),%esi
  707680:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  707685:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  70768b:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  707691:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  707695:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70769a:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  7076a1:	00 
  7076a2:	66 45 85 ff          	test   %r15w,%r15w
  7076a6:	0f 84 f3 00 00 00    	je     70779f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1ef>
  7076ac:	41 c1 e1 10          	shl    $0x10,%r9d
  7076b0:	45 09 c8             	or     %r9d,%r8d
  7076b3:	49 c1 e0 20          	shl    $0x20,%r8
  7076b7:	4c 09 c1             	or     %r8,%rcx
  7076ba:	89 b4 24 04 01 00 00 	mov    %esi,0x104(%rsp)
  7076c1:	40 88 bc 24 08 01 00 	mov    %dil,0x108(%rsp)
  7076c8:	00 
  7076c9:	89 8c 24 09 01 00 00 	mov    %ecx,0x109(%rsp)
  7076d0:	48 89 ce             	mov    %rcx,%rsi
  7076d3:	48 c1 ee 30          	shr    $0x30,%rsi
  7076d7:	40 88 b4 24 0f 01 00 	mov    %sil,0x10f(%rsp)
  7076de:	00 
  7076df:	48 c1 e9 20          	shr    $0x20,%rcx
  7076e3:	66 89 8c 24 0d 01 00 	mov    %cx,0x10d(%rsp)
  7076ea:	00 
  7076eb:	0f 28 84 24 20 01 00 	movaps 0x120(%rsp),%xmm0
  7076f2:	00 
  7076f3:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  7076fa:	00 
  7076fb:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  707702:	49 ff c5             	inc    %r13
  707705:	0f 84 6b 04 00 00    	je     707b76 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5c6>
  70770b:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  707712:	0f 85 a1 00 00 00    	jne    7077b9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x209>
  707718:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70771d:	4c 89 f6             	mov    %r14,%rsi
  707720:	e8 eb 65 01 00       	call   71dd10 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  707725:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  70772b:	0f 85 91 00 00 00    	jne    7077c2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x212>
  707731:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  707736:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  70773b:	4c 8d 84 24 04 01 00 	lea    0x104(%rsp),%r8
  707742:	00 
  707743:	4c 89 f6             	mov    %r14,%rsi
  707746:	44 89 f9             	mov    %r15d,%ecx
  707749:	e8 22 76 01 00       	call   71ed70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at>
  70774e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  707753:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  707757:	0f 85 ac 00 00 00    	jne    707809 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x259>
  70775d:	49 89 cc             	mov    %rcx,%r12
  707760:	45 31 c0             	xor    %r8d,%r8d
  707763:	e9 c6 00 00 00       	jmp    70782e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x27e>
  707768:	44 0f b6 7c 24 28    	movzbl 0x28(%rsp),%r15d
  70776e:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  707773:	c1 e0 10             	shl    $0x10,%eax
  707776:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  70777b:	09 c1                	or     %eax,%ecx
  70777d:	48 c1 e1 20          	shl    $0x20,%rcx
  707781:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  707785:	48 09 cd             	or     %rcx,%rbp
  707788:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70778d:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  707794:	00 
  707795:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  70779a:	e9 26 01 00 00       	jmp    7078c5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x315>
  70779f:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  7077a6:	00 00 00 00 
  7077aa:	48 c7 c1 fe ff ff ff 	mov    $0xfffffffffffffffe,%rcx
  7077b1:	45 31 ff             	xor    %r15d,%r15d
  7077b4:	e9 11 01 00 00       	jmp    7078ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x31a>
  7077b9:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  7077c0:	00 00 
  7077c2:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7077c7:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  7077ce:	00 
  7077cf:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7077d4:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  7077d9:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  7077de:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  7077e3:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  7077ea:	00 
  7077eb:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  7077f0:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  7077f5:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  7077fa:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  7077ff:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  707803:	0f 84 54 ff ff ff    	je     70775d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1ad>
  707809:	49 89 cc             	mov    %rcx,%r12
  70780c:	48 83 e9 0d          	sub    $0xd,%rcx
  707810:	b8 14 00 00 00       	mov    $0x14,%eax
  707815:	48 0f 4d c1          	cmovge %rcx,%rax
  707819:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  70781e:	48 83 f8 17          	cmp    $0x17,%rax
  707822:	74 0a                	je     70782e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x27e>
  707824:	48 83 f8 04          	cmp    $0x4,%rax
  707828:	0f 85 9f 02 00 00    	jne    707acd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x51d>
  70782e:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  707835:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70783c:	48 8d 0d 75 c1 3c 00 	lea    0x3cc175(%rip),%rcx        # ad39b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  707843:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  70784a:	00 
  70784b:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  707852:	00 
  707853:	48 89 ea             	mov    %rbp,%rdx
  707856:	ff 15 8c a8 3f 00    	call   *0x3fa88c(%rip)        # b020e8 <_DYNAMIC+0x3a0>
  70785c:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  707861:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  707866:	4c 8b bc 24 30 01 00 	mov    0x130(%rsp),%r15
  70786d:	00 
  70786e:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  707872:	0f 84 0d 02 00 00    	je     707a85 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4d5>
  707878:	4c 89 fd             	mov    %r15,%rbp
  70787b:	48 c1 ed 08          	shr    $0x8,%rbp
  70787f:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  707886:	00 
  707887:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  70788c:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707890:	74 33                	je     7078c5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x315>
  707892:	49 83 ec 0d          	sub    $0xd,%r12
  707896:	ba 14 00 00 00       	mov    $0x14,%edx
  70789b:	49 0f 4d d4          	cmovge %r12,%rdx
  70789f:	48 83 fa 19          	cmp    $0x19,%rdx
  7078a3:	74 09                	je     7078ae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x2fe>
  7078a5:	48 89 c8             	mov    %rcx,%rax
  7078a8:	48 83 fa 14          	cmp    $0x14,%rdx
  7078ac:	75 17                	jne    7078c5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x315>
  7078ae:	48 8b 30             	mov    (%rax),%rsi
  7078b1:	48 85 f6             	test   %rsi,%rsi
  7078b4:	74 0f                	je     7078c5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x315>
  7078b6:	48 8b 78 08          	mov    0x8(%rax),%rdi
  7078ba:	ba 01 00 00 00       	mov    $0x1,%edx
  7078bf:	ff 15 cb a6 3f 00    	call   *0x3fa6cb(%rip)        # b01f90 <_DYNAMIC+0x248>
  7078c5:	b9 20 00 00 00       	mov    $0x20,%ecx
  7078ca:	48 8b 3c 24          	mov    (%rsp),%rdi
  7078ce:	41 0f b6 c7          	movzbl %r15b,%eax
  7078d2:	48 c1 e5 08          	shl    $0x8,%rbp
  7078d6:	48 09 c5             	or     %rax,%rbp
  7078d9:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  7078de:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  7078e3:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  7078ea:	00 
  7078eb:	0f 11 8c 24 c0 00 00 	movups %xmm1,0xc0(%rsp)
  7078f2:	00 
  7078f3:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7078f8:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  7078ff:	00 
  707900:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  707907:	00 
  707908:	48 89 ac 24 a8 00 00 	mov    %rbp,0xa8(%rsp)
  70790f:	00 
  707910:	48 89 0c 24          	mov    %rcx,(%rsp)
  707914:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70791b:	48 39 f7             	cmp    %rsi,%rdi
  70791e:	0f 83 2d 03 00 00    	jae    707c51 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6a1>
  707924:	4d 89 fc             	mov    %r15,%r12
  707927:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70792e:	4c 8d 2c d8          	lea    (%rax,%rbx,8),%r13
  707932:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  707937:	4d 85 ff             	test   %r15,%r15
  70793a:	74 28                	je     707964 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3b4>
  70793c:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  707941:	48 8b 03             	mov    (%rbx),%rax
  707944:	48 85 c0             	test   %rax,%rax
  707947:	74 05                	je     70794e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x39e>
  707949:	4c 89 ff             	mov    %r15,%rdi
  70794c:	ff d0                	call   *%rax
  70794e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707952:	48 85 f6             	test   %rsi,%rsi
  707955:	74 0d                	je     707964 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3b4>
  707957:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  70795b:	4c 89 ff             	mov    %r15,%rdi
  70795e:	ff 15 2c a6 3f 00    	call   *0x3fa62c(%rip)        # b01f90 <_DYNAMIC+0x248>
  707964:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  707969:	49 89 45 08          	mov    %rax,0x8(%r13)
  70796d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  707972:	49 89 45 10          	mov    %rax,0x10(%r13)
  707976:	48 8b 04 24          	mov    (%rsp),%rax
  70797a:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  70797e:	74 34                	je     7079b4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x404>
  707980:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707984:	75 76                	jne    7079fc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x44c>
  707986:	41 80 fc 01          	cmp    $0x1,%r12b
  70798a:	0f 85 be 00 00 00    	jne    707a4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x49e>
  707990:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  707995:	4c 89 f6             	mov    %r14,%rsi
  707998:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  70799f:	00 
  7079a0:	31 c9                	xor    %ecx,%ecx
  7079a2:	4c 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%r8
  7079a9:	00 
  7079aa:	e8 01 07 00 00       	call   7080b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>
  7079af:	e9 97 01 00 00       	jmp    707b4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x59b>
  7079b4:	4c 89 f7             	mov    %r14,%rdi
  7079b7:	e8 e4 69 01 00       	call   71e3a0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  7079bc:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7079c1:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  7079c8:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  7079cf:	00 
  7079d0:	48 8b 03             	mov    (%rbx),%rax
  7079d3:	48 85 c0             	test   %rax,%rax
  7079d6:	74 05                	je     7079dd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x42d>
  7079d8:	48 89 ef             	mov    %rbp,%rdi
  7079db:	ff d0                	call   *%rax
  7079dd:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  7079e1:	48 85 f6             	test   %rsi,%rsi
  7079e4:	0f 84 61 01 00 00    	je     707b4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x59b>
  7079ea:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  7079ee:	48 89 ef             	mov    %rbp,%rdi
  7079f1:	ff 15 99 a5 3f 00    	call   *0x3fa599(%rip)        # b01f90 <_DYNAMIC+0x248>
  7079f7:	e9 4f 01 00 00       	jmp    707b4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x59b>
  7079fc:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  707a03:	00 
  707a04:	49 39 86 60 06 00 00 	cmp    %rax,0x660(%r14)
  707a0b:	74 08                	je     707a15 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x465>
  707a0d:	4c 89 f7             	mov    %r14,%rdi
  707a10:	e8 8b 69 01 00       	call   71e3a0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  707a15:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  707a1c:	00 
  707a1d:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  707a22:	48 89 41 30          	mov    %rax,0x30(%rcx)
  707a26:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  707a2d:	00 
  707a2e:	0f 10 8c 24 b0 00 00 	movups 0xb0(%rsp),%xmm1
  707a35:	00 
  707a36:	0f 10 94 24 c0 00 00 	movups 0xc0(%rsp),%xmm2
  707a3d:	00 
  707a3e:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  707a42:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  707a46:	0f 11 01             	movups %xmm0,(%rcx)
  707a49:	e9 fd 00 00 00       	jmp    707b4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x59b>
  707a4e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  707a55:	00 
  707a56:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  707a5d:	00 
  707a5e:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  707a65:	00 
  707a66:	74 16                	je     707a7e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4ce>
  707a68:	84 c0                	test   %al,%al
  707a6a:	0f 84 a9 00 00 00    	je     707b19 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x569>
  707a70:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  707a77:	ff 
  707a78:	0f 85 9b 00 00 00    	jne    707b19 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x569>
  707a7e:	31 c9                	xor    %ecx,%ecx
  707a80:	e9 a0 00 00 00       	jmp    707b25 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x575>
  707a85:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707a89:	74 33                	je     707abe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x50e>
  707a8b:	49 83 ec 0d          	sub    $0xd,%r12
  707a8f:	ba 14 00 00 00       	mov    $0x14,%edx
  707a94:	49 0f 4d d4          	cmovge %r12,%rdx
  707a98:	48 83 fa 19          	cmp    $0x19,%rdx
  707a9c:	74 09                	je     707aa7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4f7>
  707a9e:	48 89 c8             	mov    %rcx,%rax
  707aa1:	48 83 fa 14          	cmp    $0x14,%rdx
  707aa5:	75 17                	jne    707abe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x50e>
  707aa7:	48 8b 30             	mov    (%rax),%rsi
  707aaa:	48 85 f6             	test   %rsi,%rsi
  707aad:	74 0f                	je     707abe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x50e>
  707aaf:	48 8b 78 08          	mov    0x8(%rax),%rdi
  707ab3:	ba 01 00 00 00       	mov    $0x1,%edx
  707ab8:	ff 15 d2 a4 3f 00    	call   *0x3fa4d2(%rip)        # b01f90 <_DYNAMIC+0x248>
  707abe:	48 c7 c1 fe ff ff ff 	mov    $0xfffffffffffffffe,%rcx
  707ac5:	41 b7 01             	mov    $0x1,%r15b
  707ac8:	e9 fd fd ff ff       	jmp    7078ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x31a>
  707acd:	44 0f b6 7c 24 68    	movzbl 0x68(%rsp),%r15d
  707ad3:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  707ad8:	c1 e0 10             	shl    $0x10,%eax
  707adb:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  707ae0:	09 c1                	or     %eax,%ecx
  707ae2:	48 c1 e1 20          	shl    $0x20,%rcx
  707ae6:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  707aea:	48 09 cd             	or     %rcx,%rbp
  707aed:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  707af2:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  707af7:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  707afe:	00 
  707aff:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  707b04:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  707b0b:	00 
  707b0c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  707b11:	4c 89 e1             	mov    %r12,%rcx
  707b14:	e9 b1 fd ff ff       	jmp    7078ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x31a>
  707b19:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  707b20:	b9 01 00 00 00       	mov    $0x1,%ecx
  707b25:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  707b2c:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  707b31:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  707b35:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  707b39:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  707b3d:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  707b41:	88 47 30             	mov    %al,0x30(%rdi)
  707b44:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  707b4b:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  707b52:	5b                   	pop    %rbx
  707b53:	41 5c                	pop    %r12
  707b55:	41 5d                	pop    %r13
  707b57:	41 5e                	pop    %r14
  707b59:	41 5f                	pop    %r15
  707b5b:	5d                   	pop    %rbp
  707b5c:	c3                   	ret
  707b5d:	48 8d 3d 3f ef 95 ff 	lea    -0x6a10c1(%rip),%rdi        # 66aa3 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e3>
  707b64:	48 8d 15 15 c2 3c 00 	lea    0x3cc215(%rip),%rdx        # ad3d80 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x598>
  707b6b:	be 0e 00 00 00       	mov    $0xe,%esi
  707b70:	ff 15 3a a5 3f 00    	call   *0x3fa53a(%rip)        # b020b0 <_DYNAMIC+0x368>
  707b76:	b9 1f 00 00 00       	mov    $0x1f,%ecx
  707b7b:	e9 4a fd ff ff       	jmp    7078ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x31a>
  707b80:	48 8d 15 e1 c1 3c 00 	lea    0x3cc1e1(%rip),%rdx        # ad3d68 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x580>
  707b87:	48 89 cf             	mov    %rcx,%rdi
  707b8a:	ff 15 30 a5 3f 00    	call   *0x3fa530(%rip)        # b020c0 <_DYNAMIC+0x378>
  707b90:	49 89 c6             	mov    %rax,%r14
  707b93:	e9 ee 00 00 00       	jmp    707c86 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6d6>
  707b98:	49 89 c6             	mov    %rax,%r14
  707b9b:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707b9f:	48 85 f6             	test   %rsi,%rsi
  707ba2:	0f 84 eb 00 00 00    	je     707c93 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6e3>
  707ba8:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707bac:	48 89 ef             	mov    %rbp,%rdi
  707baf:	ff 15 db a3 3f 00    	call   *0x3fa3db(%rip)        # b01f90 <_DYNAMIC+0x248>
  707bb5:	4c 89 f7             	mov    %r14,%rdi
  707bb8:	e8 f3 a7 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  707bbd:	49 89 c7             	mov    %rax,%r15
  707bc0:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707bc4:	74 41                	je     707c07 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x657>
  707bc6:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  707bcb:	e8 00 cb ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707bd0:	eb 35                	jmp    707c07 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x657>
  707bd2:	49 89 c6             	mov    %rax,%r14
  707bd5:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707bd9:	48 85 f6             	test   %rsi,%rsi
  707bdc:	74 0d                	je     707beb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x63b>
  707bde:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707be2:	4c 89 ff             	mov    %r15,%rdi
  707be5:	ff 15 a5 a3 3f 00    	call   *0x3fa3a5(%rip)        # b01f90 <_DYNAMIC+0x248>
  707beb:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  707bf0:	49 89 45 08          	mov    %rax,0x8(%r13)
  707bf4:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  707bf9:	49 89 45 10          	mov    %rax,0x10(%r13)
  707bfd:	eb 79                	jmp    707c78 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6c8>
  707bff:	49 89 c6             	mov    %rax,%r14
  707c02:	eb 74                	jmp    707c78 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6c8>
  707c04:	49 89 c7             	mov    %rax,%r15
  707c07:	4c 89 ff             	mov    %r15,%rdi
  707c0a:	ff 15 c0 a4 3f 00    	call   *0x3fa4c0(%rip)        # b020d0 <_DYNAMIC+0x388>
  707c10:	48 89 c5             	mov    %rax,%rbp
  707c13:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  707c1a:	00 
  707c1b:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  707c22:	00 
  707c23:	48 c7 84 24 a0 00 00 	movq   $0xfffffffffffffffd,0xa0(%rsp)
  707c2a:	00 fd ff ff ff 
  707c2f:	48 c7 c1 fd ff ff ff 	mov    $0xfffffffffffffffd,%rcx
  707c36:	41 89 ef             	mov    %ebp,%r15d
  707c39:	48 8b 3c 24          	mov    (%rsp),%rdi
  707c3d:	48 89 0c 24          	mov    %rcx,(%rsp)
  707c41:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707c48:	48 39 f7             	cmp    %rsi,%rdi
  707c4b:	0f 82 d3 fc ff ff    	jb     707924 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x374>
  707c51:	48 8d 15 40 c1 3c 00 	lea    0x3cc140(%rip),%rdx        # ad3d98 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x5b0>
  707c58:	ff 15 62 a4 3f 00    	call   *0x3fa462(%rip)        # b020c0 <_DYNAMIC+0x378>
  707c5e:	0f 0b                	ud2
  707c60:	ff 15 72 a4 3f 00    	call   *0x3fa472(%rip)        # b020d8 <_DYNAMIC+0x390>
  707c66:	49 89 c6             	mov    %rax,%r14
  707c69:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  707c6e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  707c73:	e8 18 9b ff ff       	call   701790 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  707c78:	48 83 3c 24 fd       	cmpq   $0xfffffffffffffffd,(%rsp)
  707c7d:	74 1c                	je     707c9b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6eb>
  707c7f:	48 83 3c 24 fe       	cmpq   $0xfffffffffffffffe,(%rsp)
  707c84:	74 0d                	je     707c93 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6e3>
  707c86:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  707c8d:	00 
  707c8e:	e8 3d ca ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707c93:	4c 89 f7             	mov    %r14,%rdi
  707c96:	e8 15 a7 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  707c9b:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  707ca2:	00 
  707ca3:	e8 88 9f ff ff       	call   701c30 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707ca8:	eb e9                	jmp    707c93 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6e3>
  707caa:	ff 15 30 a3 3f 00    	call   *0x3fa330(%rip)        # b01fe0 <_DYNAMIC+0x298>

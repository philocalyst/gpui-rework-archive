
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

00000000007076c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property>:
  7076c0:	55                   	push   %rbp
  7076c1:	41 57                	push   %r15
  7076c3:	41 56                	push   %r14
  7076c5:	41 55                	push   %r13
  7076c7:	41 54                	push   %r12
  7076c9:	53                   	push   %rbx
  7076ca:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
  7076d1:	49 89 cc             	mov    %rcx,%r12
  7076d4:	49 89 f6             	mov    %rsi,%r14
  7076d7:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  7076dc:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  7076e3:	48 39 f1             	cmp    %rsi,%rcx
  7076e6:	0f 83 97 05 00 00    	jae    707c83 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5c3>
  7076ec:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  7076f3:	4b 8d 1c a4          	lea    (%r12,%r12,4),%rbx
  7076f7:	48 8b 74 d8 08       	mov    0x8(%rax,%rbx,8),%rsi
  7076fc:	48 8b 4c d8 10       	mov    0x10(%rax,%rbx,8),%rcx
  707701:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  707708:	00 00 
  70770a:	48 85 f6             	test   %rsi,%rsi
  70770d:	0f 84 49 05 00 00    	je     707c5c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x59c>
  707713:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  70771a:	00 
  70771b:	4c 89 84 24 e0 00 00 	mov    %r8,0xe0(%rsp)
  707722:	00 
  707723:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  707728:	48 89 b4 24 f0 00 00 	mov    %rsi,0xf0(%rsp)
  70772f:	00 
  707730:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  707735:	48 89 8c 24 f8 00 00 	mov    %rcx,0xf8(%rsp)
  70773c:	00 
  70773d:	49 8b 86 60 06 00 00 	mov    0x660(%r14),%rax
  707744:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  70774b:	00 
  70774c:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  707753:	48 8d 0d 1e c3 3c 00 	lea    0x3cc31e(%rip),%rcx        # ad3a78 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  70775a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70775f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  707766:	00 
  707767:	48 89 ea             	mov    %rbp,%rdx
  70776a:	ff 15 70 aa 3f 00    	call   *0x3faa70(%rip)        # b021e0 <_DYNAMIC+0x398>
  707770:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  707776:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  70777b:	0f 84 f6 00 00 00    	je     707877 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1b7>
  707781:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  707786:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  70778b:	8b 74 24 24          	mov    0x24(%rsp),%esi
  70778f:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  707794:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  70779a:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  7077a0:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  7077a4:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  7077a9:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  7077b0:	00 
  7077b1:	66 45 85 ff          	test   %r15w,%r15w
  7077b5:	0f 84 f8 00 00 00    	je     7078b3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1f3>
  7077bb:	41 c1 e1 10          	shl    $0x10,%r9d
  7077bf:	45 09 c8             	or     %r9d,%r8d
  7077c2:	49 c1 e0 20          	shl    $0x20,%r8
  7077c6:	4c 09 c1             	or     %r8,%rcx
  7077c9:	89 b4 24 04 01 00 00 	mov    %esi,0x104(%rsp)
  7077d0:	40 88 bc 24 08 01 00 	mov    %dil,0x108(%rsp)
  7077d7:	00 
  7077d8:	89 8c 24 09 01 00 00 	mov    %ecx,0x109(%rsp)
  7077df:	48 89 ce             	mov    %rcx,%rsi
  7077e2:	48 c1 ee 30          	shr    $0x30,%rsi
  7077e6:	40 88 b4 24 0f 01 00 	mov    %sil,0x10f(%rsp)
  7077ed:	00 
  7077ee:	48 c1 e9 20          	shr    $0x20,%rcx
  7077f2:	66 89 8c 24 0d 01 00 	mov    %cx,0x10d(%rsp)
  7077f9:	00 
  7077fa:	0f 28 84 24 20 01 00 	movaps 0x120(%rsp),%xmm0
  707801:	00 
  707802:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  707809:	00 
  70780a:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  707811:	49 ff c5             	inc    %r13
  707814:	0f 84 5b 04 00 00    	je     707c75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5b5>
  70781a:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  707821:	0f 85 93 00 00 00    	jne    7078ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1fa>
  707827:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70782c:	4c 89 f6             	mov    %r14,%rsi
  70782f:	e8 ec 65 01 00       	call   71de20 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  707834:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  70783a:	0f 85 83 00 00 00    	jne    7078c3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x203>
  707840:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  707845:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  70784a:	4c 8d 84 24 04 01 00 	lea    0x104(%rsp),%r8
  707851:	00 
  707852:	4c 89 f6             	mov    %r14,%rsi
  707855:	44 89 f9             	mov    %r15d,%ecx
  707858:	e8 23 76 01 00       	call   71ee80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at>
  70785d:	4d 89 e7             	mov    %r12,%r15
  707860:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  707865:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707869:	0f 85 9e 00 00 00    	jne    70790d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x24d>
  70786f:	45 31 c0             	xor    %r8d,%r8d
  707872:	e9 bb 00 00 00       	jmp    707932 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x272>
  707877:	0f b6 74 24 28       	movzbl 0x28(%rsp),%esi
  70787c:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  707881:	c1 e0 10             	shl    $0x10,%eax
  707884:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  707889:	09 c1                	or     %eax,%ecx
  70788b:	48 c1 e1 20          	shl    $0x20,%rcx
  70788f:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  707893:	48 09 cd             	or     %rcx,%rbp
  707896:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70789b:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  7078a2:	00 
  7078a3:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  7078a8:	41 bd 20 00 00 00    	mov    $0x20,%r13d
  7078ae:	e9 bf 01 00 00       	jmp    707a72 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3b2>
  7078b3:	31 f6                	xor    %esi,%esi
  7078b5:	e9 66 01 00 00       	jmp    707a20 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x360>
  7078ba:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  7078c1:	00 00 
  7078c3:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7078c8:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  7078cf:	00 
  7078d0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7078d5:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  7078da:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  7078df:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  7078e4:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  7078eb:	00 
  7078ec:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  7078f1:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  7078f6:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  7078fb:	4d 89 e7             	mov    %r12,%r15
  7078fe:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  707903:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707907:	0f 84 62 ff ff ff    	je     70786f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1af>
  70790d:	4c 89 e1             	mov    %r12,%rcx
  707910:	48 83 e9 0d          	sub    $0xd,%rcx
  707914:	b8 14 00 00 00       	mov    $0x14,%eax
  707919:	48 0f 4d c1          	cmovge %rcx,%rax
  70791d:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  707922:	48 83 f8 17          	cmp    $0x17,%rax
  707926:	74 0a                	je     707932 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x272>
  707928:	48 83 f8 04          	cmp    $0x4,%rax
  70792c:	0f 85 f7 00 00 00    	jne    707a29 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x369>
  707932:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  707939:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  707940:	48 8d 0d 31 c1 3c 00 	lea    0x3cc131(%rip),%rcx        # ad3a78 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  707947:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  70794e:	00 
  70794f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  707956:	00 
  707957:	48 89 ea             	mov    %rbp,%rdx
  70795a:	ff 15 88 a8 3f 00    	call   *0x3fa888(%rip)        # b021e8 <_DYNAMIC+0x3a0>
  707960:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  707965:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  70796a:	48 8b b4 24 30 01 00 	mov    0x130(%rsp),%rsi
  707971:	00 
  707972:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  707976:	74 69                	je     7079e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x321>
  707978:	48 89 f5             	mov    %rsi,%rbp
  70797b:	48 c1 ed 08          	shr    $0x8,%rbp
  70797f:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  707986:	00 
  707987:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  70798c:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707990:	74 44                	je     7079d6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x316>
  707992:	49 83 ec 0d          	sub    $0xd,%r12
  707996:	ba 14 00 00 00       	mov    $0x14,%edx
  70799b:	49 0f 4d d4          	cmovge %r12,%rdx
  70799f:	48 83 fa 19          	cmp    $0x19,%rdx
  7079a3:	74 09                	je     7079ae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x2ee>
  7079a5:	48 89 c8             	mov    %rcx,%rax
  7079a8:	48 83 fa 14          	cmp    $0x14,%rdx
  7079ac:	75 28                	jne    7079d6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x316>
  7079ae:	49 89 f5             	mov    %rsi,%r13
  7079b1:	48 8b 30             	mov    (%rax),%rsi
  7079b4:	48 85 f6             	test   %rsi,%rsi
  7079b7:	74 0f                	je     7079c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x308>
  7079b9:	48 8b 78 08          	mov    0x8(%rax),%rdi
  7079bd:	ba 01 00 00 00       	mov    $0x1,%edx
  7079c2:	ff 15 c8 a6 3f 00    	call   *0x3fa6c8(%rip)        # b02090 <_DYNAMIC+0x248>
  7079c8:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  7079ce:	4c 89 ee             	mov    %r13,%rsi
  7079d1:	e9 96 00 00 00       	jmp    707a6c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3ac>
  7079d6:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  7079dc:	e9 8b 00 00 00       	jmp    707a6c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3ac>
  7079e1:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  7079e5:	74 33                	je     707a1a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x35a>
  7079e7:	49 83 ec 0d          	sub    $0xd,%r12
  7079eb:	ba 14 00 00 00       	mov    $0x14,%edx
  7079f0:	49 0f 4d d4          	cmovge %r12,%rdx
  7079f4:	48 83 fa 19          	cmp    $0x19,%rdx
  7079f8:	74 09                	je     707a03 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x343>
  7079fa:	48 89 c8             	mov    %rcx,%rax
  7079fd:	48 83 fa 14          	cmp    $0x14,%rdx
  707a01:	75 17                	jne    707a1a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x35a>
  707a03:	48 8b 30             	mov    (%rax),%rsi
  707a06:	48 85 f6             	test   %rsi,%rsi
  707a09:	74 0f                	je     707a1a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x35a>
  707a0b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  707a0f:	ba 01 00 00 00       	mov    $0x1,%edx
  707a14:	ff 15 76 a6 3f 00    	call   *0x3fa676(%rip)        # b02090 <_DYNAMIC+0x248>
  707a1a:	40 b6 01             	mov    $0x1,%sil
  707a1d:	4d 89 fc             	mov    %r15,%r12
  707a20:	49 c7 c5 fe ff ff ff 	mov    $0xfffffffffffffffe,%r13
  707a27:	eb 49                	jmp    707a72 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3b2>
  707a29:	0f b6 74 24 68       	movzbl 0x68(%rsp),%esi
  707a2e:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  707a33:	c1 e0 10             	shl    $0x10,%eax
  707a36:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  707a3b:	09 c1                	or     %eax,%ecx
  707a3d:	48 c1 e1 20          	shl    $0x20,%rcx
  707a41:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  707a45:	48 09 cd             	or     %rcx,%rbp
  707a48:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  707a4d:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  707a52:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  707a59:	00 
  707a5a:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  707a5f:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  707a66:	00 
  707a67:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  707a6c:	4d 89 e5             	mov    %r12,%r13
  707a6f:	4d 89 fc             	mov    %r15,%r12
  707a72:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  707a77:	40 0f b6 c6          	movzbl %sil,%eax
  707a7b:	48 c1 e5 08          	shl    $0x8,%rbp
  707a7f:	48 09 c5             	or     %rax,%rbp
  707a82:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  707a87:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  707a8c:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  707a93:	00 
  707a94:	0f 11 8c 24 c0 00 00 	movups %xmm1,0xc0(%rsp)
  707a9b:	00 
  707a9c:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707aa1:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  707aa8:	00 
  707aa9:	4c 89 ac 24 a0 00 00 	mov    %r13,0xa0(%rsp)
  707ab0:	00 
  707ab1:	48 89 ac 24 a8 00 00 	mov    %rbp,0xa8(%rsp)
  707ab8:	00 
  707ab9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707ac0:	49 39 f4             	cmp    %rsi,%r12
  707ac3:	0f 83 8d 02 00 00    	jae    707d56 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x696>
  707ac9:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  707ad0:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  707ad4:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  707ad9:	4d 85 ff             	test   %r15,%r15
  707adc:	74 28                	je     707b06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x446>
  707ade:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  707ae3:	48 8b 03             	mov    (%rbx),%rax
  707ae6:	48 85 c0             	test   %rax,%rax
  707ae9:	74 05                	je     707af0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x430>
  707aeb:	4c 89 ff             	mov    %r15,%rdi
  707aee:	ff d0                	call   *%rax
  707af0:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707af4:	48 85 f6             	test   %rsi,%rsi
  707af7:	74 0d                	je     707b06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x446>
  707af9:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707afd:	4c 89 ff             	mov    %r15,%rdi
  707b00:	ff 15 8a a5 3f 00    	call   *0x3fa58a(%rip)        # b02090 <_DYNAMIC+0x248>
  707b06:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  707b0b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  707b10:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  707b15:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  707b1a:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  707b1e:	74 35                	je     707b55 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x495>
  707b20:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  707b24:	75 77                	jne    707b9d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4dd>
  707b26:	80 7c 24 58 01       	cmpb   $0x1,0x58(%rsp)
  707b2b:	0f 85 bb 00 00 00    	jne    707bec <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x52c>
  707b31:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  707b36:	4c 89 f6             	mov    %r14,%rsi
  707b39:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  707b40:	00 
  707b41:	31 c9                	xor    %ecx,%ecx
  707b43:	4c 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%r8
  707b4a:	00 
  707b4b:	e8 70 06 00 00       	call   7081c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>
  707b50:	e9 f5 00 00 00       	jmp    707c4a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x58a>
  707b55:	4c 89 f7             	mov    %r14,%rdi
  707b58:	e8 53 69 01 00       	call   71e4b0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  707b5d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707b62:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  707b69:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  707b70:	00 
  707b71:	48 8b 03             	mov    (%rbx),%rax
  707b74:	48 85 c0             	test   %rax,%rax
  707b77:	74 05                	je     707b7e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4be>
  707b79:	48 89 ef             	mov    %rbp,%rdi
  707b7c:	ff d0                	call   *%rax
  707b7e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707b82:	48 85 f6             	test   %rsi,%rsi
  707b85:	0f 84 bf 00 00 00    	je     707c4a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x58a>
  707b8b:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707b8f:	48 89 ef             	mov    %rbp,%rdi
  707b92:	ff 15 f8 a4 3f 00    	call   *0x3fa4f8(%rip)        # b02090 <_DYNAMIC+0x248>
  707b98:	e9 ad 00 00 00       	jmp    707c4a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x58a>
  707b9d:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  707ba4:	00 
  707ba5:	49 39 86 60 06 00 00 	cmp    %rax,0x660(%r14)
  707bac:	74 08                	je     707bb6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4f6>
  707bae:	4c 89 f7             	mov    %r14,%rdi
  707bb1:	e8 fa 68 01 00       	call   71e4b0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  707bb6:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  707bbd:	00 
  707bbe:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  707bc3:	48 89 41 30          	mov    %rax,0x30(%rcx)
  707bc7:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  707bce:	00 
  707bcf:	0f 10 8c 24 b0 00 00 	movups 0xb0(%rsp),%xmm1
  707bd6:	00 
  707bd7:	0f 10 94 24 c0 00 00 	movups 0xc0(%rsp),%xmm2
  707bde:	00 
  707bdf:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  707be3:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  707be7:	0f 11 01             	movups %xmm0,(%rcx)
  707bea:	eb 5e                	jmp    707c4a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x58a>
  707bec:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  707bf3:	00 
  707bf4:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  707bfb:	00 
  707bfc:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  707c03:	00 
  707c04:	74 0e                	je     707c14 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x554>
  707c06:	84 c0                	test   %al,%al
  707c08:	74 0e                	je     707c18 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x558>
  707c0a:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  707c11:	ff 
  707c12:	75 04                	jne    707c18 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x558>
  707c14:	31 c9                	xor    %ecx,%ecx
  707c16:	eb 0c                	jmp    707c24 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x564>
  707c18:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  707c1f:	b9 01 00 00 00       	mov    $0x1,%ecx
  707c24:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  707c2b:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  707c30:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  707c34:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  707c38:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  707c3c:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  707c40:	88 47 30             	mov    %al,0x30(%rdi)
  707c43:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  707c4a:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  707c51:	5b                   	pop    %rbx
  707c52:	41 5c                	pop    %r12
  707c54:	41 5d                	pop    %r13
  707c56:	41 5e                	pop    %r14
  707c58:	41 5f                	pop    %r15
  707c5a:	5d                   	pop    %rbp
  707c5b:	c3                   	ret
  707c5c:	48 8d 3d a0 ee 95 ff 	lea    -0x6a1160(%rip),%rdi        # 66b03 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e3>
  707c63:	48 8d 15 d6 c1 3c 00 	lea    0x3cc1d6(%rip),%rdx        # ad3e40 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x598>
  707c6a:	be 0e 00 00 00       	mov    $0xe,%esi
  707c6f:	ff 15 3b a5 3f 00    	call   *0x3fa53b(%rip)        # b021b0 <_DYNAMIC+0x368>
  707c75:	4d 89 e7             	mov    %r12,%r15
  707c78:	41 bc 1f 00 00 00    	mov    $0x1f,%r12d
  707c7e:	e9 e9 fd ff ff       	jmp    707a6c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3ac>
  707c83:	48 8d 15 9e c1 3c 00 	lea    0x3cc19e(%rip),%rdx        # ad3e28 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x580>
  707c8a:	4c 89 e7             	mov    %r12,%rdi
  707c8d:	ff 15 2d a5 3f 00    	call   *0x3fa52d(%rip)        # b021c0 <_DYNAMIC+0x378>
  707c93:	49 89 c6             	mov    %rax,%r14
  707c96:	e9 f1 00 00 00       	jmp    707d8c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6cc>
  707c9b:	49 89 c6             	mov    %rax,%r14
  707c9e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707ca2:	48 85 f6             	test   %rsi,%rsi
  707ca5:	0f 84 ee 00 00 00    	je     707d99 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6d9>
  707cab:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707caf:	48 89 ef             	mov    %rbp,%rdi
  707cb2:	ff 15 d8 a3 3f 00    	call   *0x3fa3d8(%rip)        # b02090 <_DYNAMIC+0x248>
  707cb8:	4c 89 f7             	mov    %r14,%rdi
  707cbb:	e8 b0 a7 3c 00       	call   ad2470 <_Unwind_Resume@plt>
  707cc0:	49 89 c5             	mov    %rax,%r13
  707cc3:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707cc7:	74 46                	je     707d0f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x64f>
  707cc9:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  707cce:	e8 0d cb ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707cd3:	eb 3a                	jmp    707d0f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x64f>
  707cd5:	49 89 c6             	mov    %rax,%r14
  707cd8:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707cdc:	48 85 f6             	test   %rsi,%rsi
  707cdf:	74 0d                	je     707cee <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x62e>
  707ce1:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707ce5:	4c 89 ff             	mov    %r15,%rdi
  707ce8:	ff 15 a2 a3 3f 00    	call   *0x3fa3a2(%rip)        # b02090 <_DYNAMIC+0x248>
  707cee:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  707cf3:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  707cf8:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  707cfd:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  707d02:	eb 7c                	jmp    707d80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6c0>
  707d04:	49 89 c6             	mov    %rax,%r14
  707d07:	eb 77                	jmp    707d80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6c0>
  707d09:	4d 89 e7             	mov    %r12,%r15
  707d0c:	49 89 c5             	mov    %rax,%r13
  707d0f:	4c 89 ef             	mov    %r13,%rdi
  707d12:	ff 15 b8 a4 3f 00    	call   *0x3fa4b8(%rip)        # b021d0 <_DYNAMIC+0x388>
  707d18:	48 89 c5             	mov    %rax,%rbp
  707d1b:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  707d22:	00 
  707d23:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  707d2a:	00 
  707d2b:	48 c7 84 24 a0 00 00 	movq   $0xfffffffffffffffd,0xa0(%rsp)
  707d32:	00 fd ff ff ff 
  707d37:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  707d3c:	4d 89 fc             	mov    %r15,%r12
  707d3f:	49 c7 c5 fd ff ff ff 	mov    $0xfffffffffffffffd,%r13
  707d46:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707d4d:	49 39 f4             	cmp    %rsi,%r12
  707d50:	0f 82 73 fd ff ff    	jb     707ac9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x409>
  707d56:	48 8d 15 fb c0 3c 00 	lea    0x3cc0fb(%rip),%rdx        # ad3e58 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x5b0>
  707d5d:	4c 89 e7             	mov    %r12,%rdi
  707d60:	ff 15 5a a4 3f 00    	call   *0x3fa45a(%rip)        # b021c0 <_DYNAMIC+0x378>
  707d66:	0f 0b                	ud2
  707d68:	ff 15 6a a4 3f 00    	call   *0x3fa46a(%rip)        # b021d8 <_DYNAMIC+0x390>
  707d6e:	49 89 c6             	mov    %rax,%r14
  707d71:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  707d76:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  707d7b:	e8 20 9b ff ff       	call   7018a0 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  707d80:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  707d84:	74 1b                	je     707da1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6e1>
  707d86:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  707d8a:	74 0d                	je     707d99 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6d9>
  707d8c:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  707d93:	00 
  707d94:	e8 47 ca ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707d99:	4c 89 f7             	mov    %r14,%rdi
  707d9c:	e8 cf a6 3c 00       	call   ad2470 <_Unwind_Resume@plt>
  707da1:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  707da8:	00 
  707da9:	e8 92 9f ff ff       	call   701d40 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707dae:	eb e9                	jmp    707d99 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6d9>
  707db0:	ff 15 2a a3 3f 00    	call   *0x3fa32a(%rip)        # b020e0 <_DYNAMIC+0x298>

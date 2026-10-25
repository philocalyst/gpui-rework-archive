
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

00000000007076c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property>:
  7076c0:	55                   	push   %rbp
  7076c1:	41 57                	push   %r15
  7076c3:	41 56                	push   %r14
  7076c5:	41 55                	push   %r13
  7076c7:	41 54                	push   %r12
  7076c9:	53                   	push   %rbx
  7076ca:	48 81 ec 38 01 00 00 	sub    $0x138,%rsp
  7076d1:	49 89 cc             	mov    %rcx,%r12
  7076d4:	49 89 f6             	mov    %rsi,%r14
  7076d7:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  7076dc:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  7076e3:	48 39 f1             	cmp    %rsi,%rcx
  7076e6:	0f 83 6f 05 00 00    	jae    707c5b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x59b>
  7076ec:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  7076f3:	4b 8d 1c a4          	lea    (%r12,%r12,4),%rbx
  7076f7:	48 8b 74 d8 08       	mov    0x8(%rax,%rbx,8),%rsi
  7076fc:	48 8b 4c d8 10       	mov    0x10(%rax,%rbx,8),%rcx
  707701:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  707708:	00 00 
  70770a:	48 85 f6             	test   %rsi,%rsi
  70770d:	0f 84 21 05 00 00    	je     707c34 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x574>
  707713:	48 89 94 24 d0 00 00 	mov    %rdx,0xd0(%rsp)
  70771a:	00 
  70771b:	4c 89 84 24 d8 00 00 	mov    %r8,0xd8(%rsp)
  707722:	00 
  707723:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  707728:	48 89 b4 24 e0 00 00 	mov    %rsi,0xe0(%rsp)
  70772f:	00 
  707730:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  707735:	48 89 8c 24 e8 00 00 	mov    %rcx,0xe8(%rsp)
  70773c:	00 
  70773d:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  707744:	48 8d 0d fd c2 3c 00 	lea    0x3cc2fd(%rip),%rcx        # ad3a48 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  70774b:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  707750:	48 8d b4 24 e0 00 00 	lea    0xe0(%rsp),%rsi
  707757:	00 
  707758:	48 89 ea             	mov    %rbp,%rdx
  70775b:	ff 15 4f aa 3f 00    	call   *0x3faa4f(%rip)        # b021b0 <_DYNAMIC+0x398>
  707761:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  707767:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  70776c:	0f 84 f6 00 00 00    	je     707868 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1a8>
  707772:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  707777:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  70777c:	8b 74 24 24          	mov    0x24(%rsp),%esi
  707780:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  707785:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  70778b:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  707791:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  707795:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70779a:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  7077a1:	00 
  7077a2:	66 45 85 ff          	test   %r15w,%r15w
  7077a6:	0f 84 f8 00 00 00    	je     7078a4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1e4>
  7077ac:	41 c1 e1 10          	shl    $0x10,%r9d
  7077b0:	45 09 c8             	or     %r9d,%r8d
  7077b3:	49 c1 e0 20          	shl    $0x20,%r8
  7077b7:	4c 09 c1             	or     %r8,%rcx
  7077ba:	89 b4 24 f4 00 00 00 	mov    %esi,0xf4(%rsp)
  7077c1:	40 88 bc 24 f8 00 00 	mov    %dil,0xf8(%rsp)
  7077c8:	00 
  7077c9:	89 8c 24 f9 00 00 00 	mov    %ecx,0xf9(%rsp)
  7077d0:	48 89 ce             	mov    %rcx,%rsi
  7077d3:	48 c1 ee 30          	shr    $0x30,%rsi
  7077d7:	40 88 b4 24 ff 00 00 	mov    %sil,0xff(%rsp)
  7077de:	00 
  7077df:	48 c1 e9 20          	shr    $0x20,%rcx
  7077e3:	66 89 8c 24 fd 00 00 	mov    %cx,0xfd(%rsp)
  7077ea:	00 
  7077eb:	0f 28 84 24 10 01 00 	movaps 0x110(%rsp),%xmm0
  7077f2:	00 
  7077f3:	0f 11 84 24 00 01 00 	movups %xmm0,0x100(%rsp)
  7077fa:	00 
  7077fb:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  707802:	49 ff c5             	inc    %r13
  707805:	0f 84 42 04 00 00    	je     707c4d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x58d>
  70780b:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  707812:	0f 85 93 00 00 00    	jne    7078ab <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1eb>
  707818:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70781d:	4c 89 f6             	mov    %r14,%rsi
  707820:	e8 cb 65 01 00       	call   71ddf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  707825:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  70782b:	0f 85 83 00 00 00    	jne    7078b4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1f4>
  707831:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  707836:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  70783b:	4c 8d 84 24 f4 00 00 	lea    0xf4(%rsp),%r8
  707842:	00 
  707843:	4c 89 f6             	mov    %r14,%rsi
  707846:	44 89 f9             	mov    %r15d,%ecx
  707849:	e8 02 76 01 00       	call   71ee50 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at>
  70784e:	4d 89 e7             	mov    %r12,%r15
  707851:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  707856:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  70785a:	0f 85 9e 00 00 00    	jne    7078fe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x23e>
  707860:	45 31 c0             	xor    %r8d,%r8d
  707863:	e9 bb 00 00 00       	jmp    707923 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x263>
  707868:	0f b6 74 24 28       	movzbl 0x28(%rsp),%esi
  70786d:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  707872:	c1 e0 10             	shl    $0x10,%eax
  707875:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  70787a:	09 c1                	or     %eax,%ecx
  70787c:	48 c1 e1 20          	shl    $0x20,%rcx
  707880:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  707884:	48 09 cd             	or     %rcx,%rbp
  707887:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70788c:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  707893:	00 
  707894:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  707899:	41 bd 20 00 00 00    	mov    $0x20,%r13d
  70789f:	e9 bf 01 00 00       	jmp    707a63 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3a3>
  7078a4:	31 f6                	xor    %esi,%esi
  7078a6:	e9 66 01 00 00       	jmp    707a11 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x351>
  7078ab:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  7078b2:	00 00 
  7078b4:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7078b9:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  7078c0:	00 
  7078c1:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7078c6:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  7078cb:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  7078d0:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  7078d5:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  7078dc:	00 
  7078dd:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  7078e2:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  7078e7:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  7078ec:	4d 89 e7             	mov    %r12,%r15
  7078ef:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  7078f4:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  7078f8:	0f 84 62 ff ff ff    	je     707860 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x1a0>
  7078fe:	4c 89 e1             	mov    %r12,%rcx
  707901:	48 83 e9 0d          	sub    $0xd,%rcx
  707905:	b8 14 00 00 00       	mov    $0x14,%eax
  70790a:	48 0f 4d c1          	cmovge %rcx,%rax
  70790e:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  707913:	48 83 f8 17          	cmp    $0x17,%rax
  707917:	74 0a                	je     707923 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x263>
  707919:	48 83 f8 04          	cmp    $0x4,%rax
  70791d:	0f 85 f7 00 00 00    	jne    707a1a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x35a>
  707923:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  70792a:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  707931:	48 8d 0d 10 c1 3c 00 	lea    0x3cc110(%rip),%rcx        # ad3a48 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  707938:	48 8d bc 24 20 01 00 	lea    0x120(%rsp),%rdi
  70793f:	00 
  707940:	48 8d b4 24 e0 00 00 	lea    0xe0(%rsp),%rsi
  707947:	00 
  707948:	48 89 ea             	mov    %rbp,%rdx
  70794b:	ff 15 67 a8 3f 00    	call   *0x3fa867(%rip)        # b021b8 <_DYNAMIC+0x3a0>
  707951:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  707956:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  70795b:	48 8b b4 24 20 01 00 	mov    0x120(%rsp),%rsi
  707962:	00 
  707963:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  707967:	74 69                	je     7079d2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x312>
  707969:	48 89 f5             	mov    %rsi,%rbp
  70796c:	48 c1 ed 08          	shr    $0x8,%rbp
  707970:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  707977:	00 
  707978:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  70797d:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707981:	74 44                	je     7079c7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x307>
  707983:	49 83 ec 0d          	sub    $0xd,%r12
  707987:	ba 14 00 00 00       	mov    $0x14,%edx
  70798c:	49 0f 4d d4          	cmovge %r12,%rdx
  707990:	48 83 fa 19          	cmp    $0x19,%rdx
  707994:	74 09                	je     70799f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x2df>
  707996:	48 89 c8             	mov    %rcx,%rax
  707999:	48 83 fa 14          	cmp    $0x14,%rdx
  70799d:	75 28                	jne    7079c7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x307>
  70799f:	49 89 f5             	mov    %rsi,%r13
  7079a2:	48 8b 30             	mov    (%rax),%rsi
  7079a5:	48 85 f6             	test   %rsi,%rsi
  7079a8:	74 0f                	je     7079b9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x2f9>
  7079aa:	48 8b 78 08          	mov    0x8(%rax),%rdi
  7079ae:	ba 01 00 00 00       	mov    $0x1,%edx
  7079b3:	ff 15 a7 a6 3f 00    	call   *0x3fa6a7(%rip)        # b02060 <_DYNAMIC+0x248>
  7079b9:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  7079bf:	4c 89 ee             	mov    %r13,%rsi
  7079c2:	e9 96 00 00 00       	jmp    707a5d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x39d>
  7079c7:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  7079cd:	e9 8b 00 00 00       	jmp    707a5d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x39d>
  7079d2:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  7079d6:	74 33                	je     707a0b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x34b>
  7079d8:	49 83 ec 0d          	sub    $0xd,%r12
  7079dc:	ba 14 00 00 00       	mov    $0x14,%edx
  7079e1:	49 0f 4d d4          	cmovge %r12,%rdx
  7079e5:	48 83 fa 19          	cmp    $0x19,%rdx
  7079e9:	74 09                	je     7079f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x334>
  7079eb:	48 89 c8             	mov    %rcx,%rax
  7079ee:	48 83 fa 14          	cmp    $0x14,%rdx
  7079f2:	75 17                	jne    707a0b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x34b>
  7079f4:	48 8b 30             	mov    (%rax),%rsi
  7079f7:	48 85 f6             	test   %rsi,%rsi
  7079fa:	74 0f                	je     707a0b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x34b>
  7079fc:	48 8b 78 08          	mov    0x8(%rax),%rdi
  707a00:	ba 01 00 00 00       	mov    $0x1,%edx
  707a05:	ff 15 55 a6 3f 00    	call   *0x3fa655(%rip)        # b02060 <_DYNAMIC+0x248>
  707a0b:	40 b6 01             	mov    $0x1,%sil
  707a0e:	4d 89 fc             	mov    %r15,%r12
  707a11:	49 c7 c5 fe ff ff ff 	mov    $0xfffffffffffffffe,%r13
  707a18:	eb 49                	jmp    707a63 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3a3>
  707a1a:	0f b6 74 24 68       	movzbl 0x68(%rsp),%esi
  707a1f:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  707a24:	c1 e0 10             	shl    $0x10,%eax
  707a27:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  707a2c:	09 c1                	or     %eax,%ecx
  707a2e:	48 c1 e1 20          	shl    $0x20,%rcx
  707a32:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  707a36:	48 09 cd             	or     %rcx,%rbp
  707a39:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  707a3e:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  707a43:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  707a4a:	00 
  707a4b:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  707a50:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  707a57:	00 
  707a58:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  707a5d:	4d 89 e5             	mov    %r12,%r13
  707a60:	4d 89 fc             	mov    %r15,%r12
  707a63:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  707a68:	40 0f b6 c6          	movzbl %sil,%eax
  707a6c:	48 c1 e5 08          	shl    $0x8,%rbp
  707a70:	48 09 c5             	or     %rax,%rbp
  707a73:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  707a78:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  707a7d:	0f 11 84 24 a8 00 00 	movups %xmm0,0xa8(%rsp)
  707a84:	00 
  707a85:	0f 11 8c 24 b8 00 00 	movups %xmm1,0xb8(%rsp)
  707a8c:	00 
  707a8d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707a92:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  707a99:	00 
  707a9a:	4c 89 ac 24 98 00 00 	mov    %r13,0x98(%rsp)
  707aa1:	00 
  707aa2:	48 89 ac 24 a0 00 00 	mov    %rbp,0xa0(%rsp)
  707aa9:	00 
  707aaa:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707ab1:	49 39 f4             	cmp    %rsi,%r12
  707ab4:	0f 83 68 02 00 00    	jae    707d22 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x662>
  707aba:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  707ac1:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  707ac5:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  707aca:	4d 85 ff             	test   %r15,%r15
  707acd:	74 28                	je     707af7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x437>
  707acf:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  707ad4:	48 8b 03             	mov    (%rbx),%rax
  707ad7:	48 85 c0             	test   %rax,%rax
  707ada:	74 05                	je     707ae1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x421>
  707adc:	4c 89 ff             	mov    %r15,%rdi
  707adf:	ff d0                	call   *%rax
  707ae1:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707ae5:	48 85 f6             	test   %rsi,%rsi
  707ae8:	74 0d                	je     707af7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x437>
  707aea:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707aee:	4c 89 ff             	mov    %r15,%rdi
  707af1:	ff 15 69 a5 3f 00    	call   *0x3fa569(%rip)        # b02060 <_DYNAMIC+0x248>
  707af7:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  707afc:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  707b01:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  707b06:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  707b0b:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  707b0f:	74 35                	je     707b46 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x486>
  707b11:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  707b15:	75 77                	jne    707b8e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4ce>
  707b17:	80 7c 24 58 01       	cmpb   $0x1,0x58(%rsp)
  707b1c:	0f 85 a2 00 00 00    	jne    707bc4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x504>
  707b22:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  707b27:	4c 89 f6             	mov    %r14,%rsi
  707b2a:	48 8b 94 24 d0 00 00 	mov    0xd0(%rsp),%rdx
  707b31:	00 
  707b32:	31 c9                	xor    %ecx,%ecx
  707b34:	4c 8b 84 24 d8 00 00 	mov    0xd8(%rsp),%r8
  707b3b:	00 
  707b3c:	e8 4f 06 00 00       	call   708190 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>
  707b41:	e9 dc 00 00 00       	jmp    707c22 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x562>
  707b46:	4c 89 f7             	mov    %r14,%rdi
  707b49:	e8 32 69 01 00       	call   71e480 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  707b4e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707b53:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  707b5a:	48 8b 9c 24 a8 00 00 	mov    0xa8(%rsp),%rbx
  707b61:	00 
  707b62:	48 8b 03             	mov    (%rbx),%rax
  707b65:	48 85 c0             	test   %rax,%rax
  707b68:	74 05                	je     707b6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x4af>
  707b6a:	48 89 ef             	mov    %rbp,%rdi
  707b6d:	ff d0                	call   *%rax
  707b6f:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707b73:	48 85 f6             	test   %rsi,%rsi
  707b76:	0f 84 a6 00 00 00    	je     707c22 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x562>
  707b7c:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707b80:	48 89 ef             	mov    %rbp,%rdi
  707b83:	ff 15 d7 a4 3f 00    	call   *0x3fa4d7(%rip)        # b02060 <_DYNAMIC+0x248>
  707b89:	e9 94 00 00 00       	jmp    707c22 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x562>
  707b8e:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  707b95:	00 
  707b96:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  707b9b:	48 89 41 30          	mov    %rax,0x30(%rcx)
  707b9f:	0f 10 84 24 98 00 00 	movups 0x98(%rsp),%xmm0
  707ba6:	00 
  707ba7:	0f 10 8c 24 a8 00 00 	movups 0xa8(%rsp),%xmm1
  707bae:	00 
  707baf:	0f 10 94 24 b8 00 00 	movups 0xb8(%rsp),%xmm2
  707bb6:	00 
  707bb7:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  707bbb:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  707bbf:	0f 11 01             	movups %xmm0,(%rcx)
  707bc2:	eb 5e                	jmp    707c22 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x562>
  707bc4:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  707bcb:	00 
  707bcc:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  707bd3:	00 
  707bd4:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  707bdb:	00 
  707bdc:	74 0e                	je     707bec <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x52c>
  707bde:	84 c0                	test   %al,%al
  707be0:	74 0e                	je     707bf0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x530>
  707be2:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  707be9:	ff 
  707bea:	75 04                	jne    707bf0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x530>
  707bec:	31 c9                	xor    %ecx,%ecx
  707bee:	eb 0c                	jmp    707bfc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x53c>
  707bf0:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  707bf7:	b9 01 00 00 00       	mov    $0x1,%ecx
  707bfc:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  707c03:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  707c08:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  707c0c:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  707c10:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  707c14:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  707c18:	88 47 30             	mov    %al,0x30(%rdi)
  707c1b:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  707c22:	48 81 c4 38 01 00 00 	add    $0x138,%rsp
  707c29:	5b                   	pop    %rbx
  707c2a:	41 5c                	pop    %r12
  707c2c:	41 5d                	pop    %r13
  707c2e:	41 5e                	pop    %r14
  707c30:	41 5f                	pop    %r15
  707c32:	5d                   	pop    %rbp
  707c33:	c3                   	ret
  707c34:	48 8d 3d c8 ee 95 ff 	lea    -0x6a1138(%rip),%rdi        # 66b03 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e3>
  707c3b:	48 8d 15 ce c1 3c 00 	lea    0x3cc1ce(%rip),%rdx        # ad3e10 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x598>
  707c42:	be 0e 00 00 00       	mov    $0xe,%esi
  707c47:	ff 15 33 a5 3f 00    	call   *0x3fa533(%rip)        # b02180 <_DYNAMIC+0x368>
  707c4d:	4d 89 e7             	mov    %r12,%r15
  707c50:	41 bc 1f 00 00 00    	mov    $0x1f,%r12d
  707c56:	e9 02 fe ff ff       	jmp    707a5d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x39d>
  707c5b:	48 8d 15 96 c1 3c 00 	lea    0x3cc196(%rip),%rdx        # ad3df8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x580>
  707c62:	4c 89 e7             	mov    %r12,%rdi
  707c65:	ff 15 25 a5 3f 00    	call   *0x3fa525(%rip)        # b02190 <_DYNAMIC+0x378>
  707c6b:	49 89 c6             	mov    %rax,%r14
  707c6e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707c72:	48 85 f6             	test   %rsi,%rsi
  707c75:	74 0d                	je     707c84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5c4>
  707c77:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707c7b:	48 89 ef             	mov    %rbp,%rdi
  707c7e:	ff 15 dc a3 3f 00    	call   *0x3fa3dc(%rip)        # b02060 <_DYNAMIC+0x248>
  707c84:	4c 89 f7             	mov    %r14,%rdi
  707c87:	e8 b4 a7 3c 00       	call   ad2440 <_Unwind_Resume@plt>
  707c8c:	49 89 c5             	mov    %rax,%r13
  707c8f:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  707c93:	74 46                	je     707cdb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x61b>
  707c95:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  707c9a:	e8 41 cb ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707c9f:	eb 3a                	jmp    707cdb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x61b>
  707ca1:	49 89 c6             	mov    %rax,%r14
  707ca4:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  707ca8:	48 85 f6             	test   %rsi,%rsi
  707cab:	74 0d                	je     707cba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5fa>
  707cad:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  707cb1:	4c 89 ff             	mov    %r15,%rdi
  707cb4:	ff 15 a6 a3 3f 00    	call   *0x3fa3a6(%rip)        # b02060 <_DYNAMIC+0x248>
  707cba:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  707cbf:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  707cc4:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  707cc9:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  707cce:	eb 7c                	jmp    707d4c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x68c>
  707cd0:	49 89 c6             	mov    %rax,%r14
  707cd3:	eb 77                	jmp    707d4c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x68c>
  707cd5:	4d 89 e7             	mov    %r12,%r15
  707cd8:	49 89 c5             	mov    %rax,%r13
  707cdb:	4c 89 ef             	mov    %r13,%rdi
  707cde:	ff 15 bc a4 3f 00    	call   *0x3fa4bc(%rip)        # b021a0 <_DYNAMIC+0x388>
  707ce4:	48 89 c5             	mov    %rax,%rbp
  707ce7:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  707cee:	00 
  707cef:	48 89 94 24 a8 00 00 	mov    %rdx,0xa8(%rsp)
  707cf6:	00 
  707cf7:	48 c7 84 24 98 00 00 	movq   $0xfffffffffffffffd,0x98(%rsp)
  707cfe:	00 fd ff ff ff 
  707d03:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  707d08:	4d 89 fc             	mov    %r15,%r12
  707d0b:	49 c7 c5 fd ff ff ff 	mov    $0xfffffffffffffffd,%r13
  707d12:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707d19:	49 39 f4             	cmp    %rsi,%r12
  707d1c:	0f 82 98 fd ff ff    	jb     707aba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x3fa>
  707d22:	48 8d 15 ff c0 3c 00 	lea    0x3cc0ff(%rip),%rdx        # ad3e28 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x5b0>
  707d29:	4c 89 e7             	mov    %r12,%rdi
  707d2c:	ff 15 5e a4 3f 00    	call   *0x3fa45e(%rip)        # b02190 <_DYNAMIC+0x378>
  707d32:	0f 0b                	ud2
  707d34:	ff 15 6e a4 3f 00    	call   *0x3fa46e(%rip)        # b021a8 <_DYNAMIC+0x390>
  707d3a:	49 89 c6             	mov    %rax,%r14
  707d3d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  707d42:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  707d47:	e8 54 9b ff ff       	call   7018a0 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  707d4c:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  707d50:	74 1f                	je     707d71 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x6b1>
  707d52:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  707d56:	0f 84 28 ff ff ff    	je     707c84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5c4>
  707d5c:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  707d63:	00 
  707d64:	e8 77 ca ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707d69:	4c 89 f7             	mov    %r14,%rdi
  707d6c:	e8 cf a6 3c 00       	call   ad2440 <_Unwind_Resume@plt>
  707d71:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  707d78:	00 
  707d79:	e8 c2 9f ff ff       	call   701d40 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707d7e:	e9 01 ff ff ff       	jmp    707c84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property+0x5c4>
  707d83:	ff 15 27 a3 3f 00    	call   *0x3fa327(%rip)        # b020b0 <_DYNAMIC+0x298>

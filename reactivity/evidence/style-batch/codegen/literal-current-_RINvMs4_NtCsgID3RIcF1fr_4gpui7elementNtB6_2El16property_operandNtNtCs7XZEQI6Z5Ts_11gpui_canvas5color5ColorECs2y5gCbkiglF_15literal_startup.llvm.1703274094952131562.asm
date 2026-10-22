
/tmp/gpui-style-startup-current-target/release/examples/literal_startup:     file format elf64-x86-64


Disassembly of section .text:

00000000004f9660 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>>:
  4f9660:	55                   	push   %rbp
  4f9661:	41 57                	push   %r15
  4f9663:	41 56                	push   %r14
  4f9665:	41 54                	push   %r12
  4f9667:	53                   	push   %rbx
  4f9668:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
  4f966f:	89 d5                	mov    %edx,%ebp
  4f9671:	48 89 f3             	mov    %rsi,%rbx
  4f9674:	49 89 fe             	mov    %rdi,%r14
  4f9677:	f6 01 01             	testb  $0x1,(%rcx)
  4f967a:	0f 84 ab 00 00 00    	je     4f972b <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0xcb>
  4f9680:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  4f9684:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  4f9688:	48 8b bb a0 00 00 00 	mov    0xa0(%rbx),%rdi
  4f968f:	48 85 ff             	test   %rdi,%rdi
  4f9692:	0f 85 86 00 00 00    	jne    4f971e <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0xbe>
  4f9698:	49 89 cf             	mov    %rcx,%r15
  4f969b:	49 89 d4             	mov    %rdx,%r12
  4f969e:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  4f96a5:	00 00 
  4f96a7:	48 c7 44 24 18 08 00 	movq   $0x8,0x18(%rsp)
  4f96ae:	00 00 
  4f96b0:	0f 57 c0             	xorps  %xmm0,%xmm0
  4f96b3:	0f 11 44 24 20       	movups %xmm0,0x20(%rsp)
  4f96b8:	0f 11 44 24 2d       	movups %xmm0,0x2d(%rsp)
  4f96bd:	48 b8 03 00 00 00 00 	movabs $0x8000000000000003,%rax
  4f96c4:	00 00 80 
  4f96c7:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4f96cc:	ff 15 9e 06 2d 00    	call   *0x2d069e(%rip)        # 7c9d70 <_DYNAMIC+0x260>
  4f96d2:	bf 38 00 00 00       	mov    $0x38,%edi
  4f96d7:	be 08 00 00 00       	mov    $0x8,%esi
  4f96dc:	ff 15 6e 06 2d 00    	call   *0x2d066e(%rip)        # 7c9d50 <_DYNAMIC+0x240>
  4f96e2:	48 85 c0             	test   %rax,%rax
  4f96e5:	0f 84 a6 02 00 00    	je     4f9991 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x331>
  4f96eb:	48 89 c7             	mov    %rax,%rdi
  4f96ee:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  4f96f3:	48 89 47 30          	mov    %rax,0x30(%rdi)
  4f96f7:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  4f96fc:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  4f9701:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  4f9706:	0f 11 57 20          	movups %xmm2,0x20(%rdi)
  4f970a:	0f 11 4f 10          	movups %xmm1,0x10(%rdi)
  4f970e:	0f 11 07             	movups %xmm0,(%rdi)
  4f9711:	48 89 bb a0 00 00 00 	mov    %rdi,0xa0(%rbx)
  4f9718:	4c 89 e2             	mov    %r12,%rdx
  4f971b:	4c 89 f9             	mov    %r15,%rcx
  4f971e:	89 ee                	mov    %ebp,%esi
  4f9720:	ff 15 62 0a 2d 00    	call   *0x2d0a62(%rip)        # 7ca188 <_DYNAMIC+0x678>
  4f9726:	e9 f4 01 00 00       	jmp    4f991f <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x2bf>
  4f972b:	0f 10 41 04          	movups 0x4(%rcx),%xmm0
  4f972f:	0f 11 44 24 47       	movups %xmm0,0x47(%rsp)
  4f9734:	c6 44 24 0c 02       	movb   $0x2,0xc(%rsp)
  4f9739:	0f 10 44 24 44       	movups 0x44(%rsp),%xmm0
  4f973e:	0f 11 44 24 0d       	movups %xmm0,0xd(%rsp)
  4f9743:	8b 44 24 53          	mov    0x53(%rsp),%eax
  4f9747:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  4f974b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%rsp)
  4f9752:	00 
  4f9753:	48 8d 7c 24 44       	lea    0x44(%rsp),%rdi
  4f9758:	4c 8d 7c 24 08       	lea    0x8(%rsp),%r15
  4f975d:	4c 89 fe             	mov    %r15,%rsi
  4f9760:	89 ea                	mov    %ebp,%edx
  4f9762:	ff 15 08 0a 2d 00    	call   *0x2d0a08(%rip)        # 7ca170 <_DYNAMIC+0x660>
  4f9768:	80 7c 24 44 ff       	cmpb   $0xff,0x44(%rsp)
  4f976d:	0f 84 cc 01 00 00    	je     4f993f <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x2df>
  4f9773:	0f 10 44 24 44       	movups 0x44(%rsp),%xmm0
  4f9778:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  4f977d:	0f 11 4c 24 6c       	movups %xmm1,0x6c(%rsp)
  4f9782:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  4f9787:	48 8b bb a0 00 00 00 	mov    0xa0(%rbx),%rdi
  4f978e:	48 85 ff             	test   %rdi,%rdi
  4f9791:	74 08                	je     4f979b <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x13b>
  4f9793:	89 ee                	mov    %ebp,%esi
  4f9795:	ff 15 f5 09 2d 00    	call   *0x2d09f5(%rip)        # 7ca190 <_DYNAMIC+0x680>
  4f979b:	66 83 fd 07          	cmp    $0x7,%bp
  4f979f:	75 60                	jne    4f9801 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x1a1>
  4f97a1:	48 8b 05 f0 09 2d 00 	mov    0x2d09f0(%rip),%rax        # 7ca198 <_DYNAMIC+0x688>
  4f97a8:	80 78 32 01          	cmpb   $0x1,0x32(%rax)
  4f97ac:	74 60                	je     4f980e <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x1ae>
  4f97ae:	48 8d 73 30          	lea    0x30(%rbx),%rsi
  4f97b2:	48 8d 54 24 60       	lea    0x60(%rsp),%rdx
  4f97b7:	89 ef                	mov    %ebp,%edi
  4f97b9:	ff 15 b9 09 2d 00    	call   *0x2d09b9(%rip)        # 7ca178 <_DYNAMIC+0x668>
  4f97bf:	66 85 c0             	test   %ax,%ax
  4f97c2:	0f 84 f3 00 00 00    	je     4f98bb <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x25b>
  4f97c8:	89 c1                	mov    %eax,%ecx
  4f97ca:	c1 e9 10             	shr    $0x10,%ecx
  4f97cd:	48 89 c2             	mov    %rax,%rdx
  4f97d0:	48 c1 ea 18          	shr    $0x18,%rdx
  4f97d4:	66 89 44 24 08       	mov    %ax,0x8(%rsp)
  4f97d9:	88 4c 24 0a          	mov    %cl,0xa(%rsp)
  4f97dd:	66 89 54 24 0b       	mov    %dx,0xb(%rsp)
  4f97e2:	c1 ea 10             	shr    $0x10,%edx
  4f97e5:	88 54 24 0d          	mov    %dl,0xd(%rsp)
  4f97e9:	4c 8d 05 88 f4 2a 00 	lea    0x2af488(%rip),%r8        # 7a8c78 <anon.6f305857a6e080d5018272bfc63fda68.0.llvm.2199850371625610380+0xe0>
  4f97f0:	be 1a 00 00 00       	mov    $0x1a,%esi
  4f97f5:	48 8d 3d 0a f1 b4 ff 	lea    -0x4b0ef6(%rip),%rdi        # 48906 <anon.8658b204e9eae4eaf9bcf27658b3ee09.5.llvm.3942281989498588229+0x27d>
  4f97fc:	e9 63 01 00 00       	jmp    4f9964 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x304>
  4f9801:	48 8b 05 98 09 2d 00 	mov    0x2d0998(%rip),%rax        # 7ca1a0 <_DYNAMIC+0x690>
  4f9808:	80 78 32 01          	cmpb   $0x1,0x32(%rax)
  4f980c:	75 a0                	jne    4f97ae <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x14e>
  4f980e:	80 7c 24 60 01       	cmpb   $0x1,0x60(%rsp)
  4f9813:	0f 85 5d 01 00 00    	jne    4f9976 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x316>
  4f9819:	f3 0f 10 44 24 64    	movss  0x64(%rsp),%xmm0
  4f981f:	48 8b bb a0 00 00 00 	mov    0xa0(%rbx),%rdi
  4f9826:	48 85 ff             	test   %rdi,%rdi
  4f9829:	0f 85 86 00 00 00    	jne    4f98b5 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x255>
  4f982f:	f3 0f 11 44 24 40    	movss  %xmm0,0x40(%rsp)
  4f9835:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  4f983c:	00 00 
  4f983e:	48 c7 44 24 18 08 00 	movq   $0x8,0x18(%rsp)
  4f9845:	00 00 
  4f9847:	0f 57 c0             	xorps  %xmm0,%xmm0
  4f984a:	0f 11 44 24 20       	movups %xmm0,0x20(%rsp)
  4f984f:	0f 11 44 24 2d       	movups %xmm0,0x2d(%rsp)
  4f9854:	48 b8 03 00 00 00 00 	movabs $0x8000000000000003,%rax
  4f985b:	00 00 80 
  4f985e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4f9863:	ff 15 07 05 2d 00    	call   *0x2d0507(%rip)        # 7c9d70 <_DYNAMIC+0x260>
  4f9869:	bf 38 00 00 00       	mov    $0x38,%edi
  4f986e:	be 08 00 00 00       	mov    $0x8,%esi
  4f9873:	ff 15 d7 04 2d 00    	call   *0x2d04d7(%rip)        # 7c9d50 <_DYNAMIC+0x240>
  4f9879:	48 85 c0             	test   %rax,%rax
  4f987c:	0f 84 21 01 00 00    	je     4f99a3 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x343>
  4f9882:	48 89 c7             	mov    %rax,%rdi
  4f9885:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  4f988a:	48 89 47 30          	mov    %rax,0x30(%rdi)
  4f988e:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  4f9893:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  4f9898:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  4f989d:	0f 11 57 20          	movups %xmm2,0x20(%rdi)
  4f98a1:	0f 11 4f 10          	movups %xmm1,0x10(%rdi)
  4f98a5:	0f 11 07             	movups %xmm0,(%rdi)
  4f98a8:	48 89 bb a0 00 00 00 	mov    %rdi,0xa0(%rbx)
  4f98af:	f3 0f 10 44 24 40    	movss  0x40(%rsp),%xmm0
  4f98b5:	ff 15 ed 08 2d 00    	call   *0x2d08ed(%rip)        # 7ca1a8 <_DYNAMIC+0x698>
  4f98bb:	4c 8b bb a0 00 00 00 	mov    0xa0(%rbx),%r15
  4f98c2:	4d 85 ff             	test   %r15,%r15
  4f98c5:	74 58                	je     4f991f <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x2bf>
  4f98c7:	48 b8 03 00 00 00 00 	movabs $0x8000000000000003,%rax
  4f98ce:	00 00 80 
  4f98d1:	49 39 07             	cmp    %rax,(%r15)
  4f98d4:	75 49                	jne    4f991f <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x2bf>
  4f98d6:	49 83 7f 20 00       	cmpq   $0x0,0x20(%r15)
  4f98db:	75 42                	jne    4f991f <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x2bf>
  4f98dd:	49 83 7f 18 00       	cmpq   $0x0,0x18(%r15)
  4f98e2:	75 3b                	jne    4f991f <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x2bf>
  4f98e4:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  4f98e9:	75 34                	jne    4f991f <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x2bf>
  4f98eb:	41 83 7f 30 00       	cmpl   $0x0,0x30(%r15)
  4f98f0:	75 2d                	jne    4f991f <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x2bf>
  4f98f2:	41 80 7f 34 00       	cmpb   $0x0,0x34(%r15)
  4f98f7:	75 26                	jne    4f991f <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x2bf>
  4f98f9:	4c 89 ff             	mov    %r15,%rdi
  4f98fc:	e8 ef 1d 00 00       	call   4fb6f0 <core::ptr::drop_glue::<gpui::semantic::ElementExtra>>
  4f9901:	be 38 00 00 00       	mov    $0x38,%esi
  4f9906:	ba 08 00 00 00       	mov    $0x8,%edx
  4f990b:	4c 89 ff             	mov    %r15,%rdi
  4f990e:	ff 15 44 04 2d 00    	call   *0x2d0444(%rip)        # 7c9d58 <_DYNAMIC+0x248>
  4f9914:	48 c7 83 a0 00 00 00 	movq   $0x0,0xa0(%rbx)
  4f991b:	00 00 00 00 
  4f991f:	ba b0 00 00 00       	mov    $0xb0,%edx
  4f9924:	4c 89 f7             	mov    %r14,%rdi
  4f9927:	48 89 de             	mov    %rbx,%rsi
  4f992a:	48 81 c4 80 00 00 00 	add    $0x80,%rsp
  4f9931:	5b                   	pop    %rbx
  4f9932:	41 5c                	pop    %r12
  4f9934:	41 5e                	pop    %r14
  4f9936:	41 5f                	pop    %r15
  4f9938:	5d                   	pop    %rbp
  4f9939:	ff 25 41 04 2d 00    	jmp    *0x2d0441(%rip)        # 7c9d80 <memcpy@GLIBC_2.14>
  4f993f:	0f b7 44 24 4a       	movzwl 0x4a(%rsp),%eax
  4f9944:	66 89 44 24 0c       	mov    %ax,0xc(%rsp)
  4f9949:	8b 44 24 46          	mov    0x46(%rsp),%eax
  4f994d:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4f9951:	4c 8d 05 08 f3 2a 00 	lea    0x2af308(%rip),%r8        # 7a8c60 <anon.6f305857a6e080d5018272bfc63fda68.0.llvm.2199850371625610380+0xc8>
  4f9958:	be 1e 00 00 00       	mov    $0x1e,%esi
  4f995d:	48 8d 3d 84 ef b4 ff 	lea    -0x4b107c(%rip),%rdi        # 488e8 <anon.8658b204e9eae4eaf9bcf27658b3ee09.5.llvm.3942281989498588229+0x25f>
  4f9964:	48 8d 0d 55 f3 2a 00 	lea    0x2af355(%rip),%rcx        # 7a8cc0 <anon.75158de5310fa4960df0d507925fcde0.13.llvm.1703274094952131562+0x18>
  4f996b:	4c 89 fa             	mov    %r15,%rdx
  4f996e:	ff 15 e4 04 2d 00    	call   *0x2d04e4(%rip)        # 7c9e58 <_DYNAMIC+0x348>
  4f9974:	eb 3d                	jmp    4f99b3 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x353>
  4f9976:	48 8d 3d 43 ef b4 ff 	lea    -0x4b10bd(%rip),%rdi        # 488c0 <anon.8658b204e9eae4eaf9bcf27658b3ee09.5.llvm.3942281989498588229+0x237>
  4f997d:	48 8d 15 0c f3 2a 00 	lea    0x2af30c(%rip),%rdx        # 7a8c90 <anon.6f305857a6e080d5018272bfc63fda68.0.llvm.2199850371625610380+0xf8>
  4f9984:	be 28 00 00 00       	mov    $0x28,%esi
  4f9989:	ff 15 01 04 2d 00    	call   *0x2d0401(%rip)        # 7c9d90 <_DYNAMIC+0x280>
  4f998f:	eb 22                	jmp    4f99b3 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x353>
  4f9991:	bf 08 00 00 00       	mov    $0x8,%edi
  4f9996:	be 38 00 00 00       	mov    $0x38,%esi
  4f999b:	ff 15 e7 03 2d 00    	call   *0x2d03e7(%rip)        # 7c9d88 <_DYNAMIC+0x278>
  4f99a1:	eb 10                	jmp    4f99b3 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x353>
  4f99a3:	bf 08 00 00 00       	mov    $0x8,%edi
  4f99a8:	be 38 00 00 00       	mov    $0x38,%esi
  4f99ad:	ff 15 d5 03 2d 00    	call   *0x2d03d5(%rip)        # 7c9d88 <_DYNAMIC+0x278>
  4f99b3:	0f 0b                	ud2
  4f99b5:	49 89 c6             	mov    %rax,%r14
  4f99b8:	be 38 00 00 00       	mov    $0x38,%esi
  4f99bd:	ba 08 00 00 00       	mov    $0x8,%edx
  4f99c2:	4c 89 ff             	mov    %r15,%rdi
  4f99c5:	ff 15 8d 03 2d 00    	call   *0x2d038d(%rip)        # 7c9d58 <_DYNAMIC+0x248>
  4f99cb:	48 c7 83 a0 00 00 00 	movq   $0x0,0xa0(%rbx)
  4f99d2:	00 00 00 00 
  4f99d6:	eb 2d                	jmp    4f9a05 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x3a5>
  4f99d8:	49 89 c6             	mov    %rax,%r14
  4f99db:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  4f99e0:	e8 0b 1d 00 00       	call   4fb6f0 <core::ptr::drop_glue::<gpui::semantic::ElementExtra>>
  4f99e5:	eb 1e                	jmp    4f9a05 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x3a5>
  4f99e7:	ff 15 bb 03 2d 00    	call   *0x2d03bb(%rip)        # 7c9da8 <_DYNAMIC+0x298>
  4f99ed:	49 89 c6             	mov    %rax,%r14
  4f99f0:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  4f99f5:	e8 f6 1c 00 00       	call   4fb6f0 <core::ptr::drop_glue::<gpui::semantic::ElementExtra>>
  4f99fa:	eb 09                	jmp    4f9a05 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>+0x3a5>
  4f99fc:	ff 15 a6 03 2d 00    	call   *0x2d03a6(%rip)        # 7c9da8 <_DYNAMIC+0x298>
  4f9a02:	49 89 c6             	mov    %rax,%r14
  4f9a05:	48 89 df             	mov    %rbx,%rdi
  4f9a08:	e8 e3 19 00 00       	call   4fb3f0 <core::ptr::drop_glue::<gpui::element::El>>
  4f9a0d:	4c 89 f7             	mov    %r14,%rdi
  4f9a10:	e8 8b d0 2a 00       	call   7a6aa0 <_Unwind_Resume@plt>
  4f9a15:	ff 15 8d 03 2d 00    	call   *0x2d038d(%rip)        # 7c9da8 <_DYNAMIC+0x298>

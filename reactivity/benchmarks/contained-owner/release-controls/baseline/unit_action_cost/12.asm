
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070b950 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer>:
  70b950:	55                   	push   %rbp
  70b951:	41 57                	push   %r15
  70b953:	41 56                	push   %r14
  70b955:	41 55                	push   %r13
  70b957:	41 54                	push   %r12
  70b959:	53                   	push   %rbx
  70b95a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  70b961:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  70b968:	75 0c                	jne    70b976 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x26>
  70b96a:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70b971:	e9 37 02 00 00       	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70b976:	80 be 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rsi)
  70b97d:	0f 85 23 02 00 00    	jne    70bba6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70b983:	80 be 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rsi)
  70b98a:	0f 85 16 02 00 00    	jne    70bba6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70b990:	80 be 20 07 00 00 00 	cmpb   $0x0,0x720(%rsi)
  70b997:	0f 84 09 02 00 00    	je     70bba6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70b99d:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  70b9a4:	ff 
  70b9a5:	0f 85 fb 01 00 00    	jne    70bba6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70b9ab:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  70b9b2:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  70b9b9:	0f 85 e7 01 00 00    	jne    70bba6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70b9bf:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  70b9c6:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  70b9cd:	0f 85 d3 01 00 00    	jne    70bba6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70b9d3:	f3 0f 10 96 14 07 00 	movss  0x714(%rsi),%xmm2
  70b9da:	00 
  70b9db:	0f 2e 96 18 07 00 00 	ucomiss 0x718(%rsi),%xmm2
  70b9e2:	0f 85 be 01 00 00    	jne    70bba6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70b9e8:	0f 8a b8 01 00 00    	jp     70bba6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70b9ee:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70b9f4:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  70b9f9:	48 89 fd             	mov    %rdi,%rbp
  70b9fc:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70ba01:	48 89 f3             	mov    %rsi,%rbx
  70ba04:	49 89 d7             	mov    %rdx,%r15
  70ba07:	49 89 ce             	mov    %rcx,%r14
  70ba0a:	e8 61 e2 ff ff       	call   709c70 <<gpui::runtime::Runtime<unit_action_cost::Model>>::input_index>
  70ba0f:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70ba14:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  70ba19:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70ba1d:	0f 85 9c 01 00 00    	jne    70bbbf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x26f>
  70ba23:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70ba2a:	49 39 f4             	cmp    %rsi,%r12
  70ba2d:	0f 83 8b 04 00 00    	jae    70bebe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x56e>
  70ba33:	48 89 e8             	mov    %rbp,%rax
  70ba36:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70ba3d:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  70ba41:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  70ba45:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  70ba4c:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  70ba53:	48 c1 e2 04          	shl    $0x4,%rdx
  70ba57:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  70ba5b:	31 d2                	xor    %edx,%edx
  70ba5d:	49 89 c8             	mov    %rcx,%r8
  70ba60:	48 39 d7             	cmp    %rdx,%rdi
  70ba63:	0f 84 7b 01 00 00    	je     70bbe4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x294>
  70ba69:	48 83 c2 50          	add    $0x50,%rdx
  70ba6d:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  70ba71:	4d 8d 40 50          	lea    0x50(%r8),%r8
  70ba75:	75 e9                	jne    70ba60 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x110>
  70ba77:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  70ba7d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70ba80:	0f 8a 5e 01 00 00    	jp     70bbe4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x294>
  70ba86:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  70ba8c:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70ba93:	00 00 
  70ba95:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70ba98:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  70ba9b:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70baa2:	00 
  70baa3:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  70baa8:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70baad:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  70bab2:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  70bab9:	00 
  70baba:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70babf:	e8 ac 88 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70bac4:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  70bacb:	00 
  70bacc:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  70bad1:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70bad6:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  70badb:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  70bae2:	00 
  70bae3:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  70bae8:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  70baed:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  70baf4:	00 
  70baf5:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  70bafa:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  70bb00:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  70bb05:	ff 15 95 5a 3f 00    	call   *0x3f5a95(%rip)        # b015a0 <_DYNAMIC+0x4b0>
  70bb0b:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70bb12:	00 00 
  70bb14:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  70bb1b:	01 
  70bb1c:	0f 85 34 01 00 00    	jne    70bc56 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x306>
  70bb22:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  70bb29:	00 00 
  70bb2b:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  70bb30:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  70bb37:	00 00 
  70bb39:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70bb3f:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70bb44:	e8 27 88 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70bb49:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  70bb50:	49 39 f4             	cmp    %rsi,%r12
  70bb53:	0f 83 75 03 00 00    	jae    70bece <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x57e>
  70bb59:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  70bb60:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  70bb67:	4c 89 e0             	mov    %r12,%rax
  70bb6a:	48 c1 e0 04          	shl    $0x4,%rax
  70bb6e:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  70bb72:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  70bb79:	00 
  70bb7a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70bb7f:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  70bb86:	00 
  70bb87:	ff 15 f3 59 3f 00    	call   *0x3f59f3(%rip)        # b01580 <_DYNAMIC+0x490>
  70bb8d:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  70bb92:	74 59                	je     70bbed <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x29d>
  70bb94:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  70bb99:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  70bba0:	00 
  70bba1:	88 45 08             	mov    %al,0x8(%rbp)
  70bba4:	eb 07                	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70bba6:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70bbad:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  70bbb4:	5b                   	pop    %rbx
  70bbb5:	41 5c                	pop    %r12
  70bbb7:	41 5d                	pop    %r13
  70bbb9:	41 5e                	pop    %r14
  70bbbb:	41 5f                	pop    %r15
  70bbbd:	5d                   	pop    %rbp
  70bbbe:	c3                   	ret
  70bbbf:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  70bbc4:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  70bbc8:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70bbcd:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  70bbd2:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70bbd6:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70bbda:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70bbde:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  70bbe2:	eb c9                	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70bbe4:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  70bbeb:	eb c0                	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70bbed:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  70bbf3:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  70bbfa:	00 00 
  70bbfc:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  70bc02:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  70bc08:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70bc0d:	48 89 de             	mov    %rbx,%rsi
  70bc10:	4c 89 e2             	mov    %r12,%rdx
  70bc13:	e8 c8 eb ff ff       	call   70a7e0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::interaction_layout>
  70bc18:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70bc1d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70bc21:	75 40                	jne    70bc63 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x313>
  70bc23:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  70bc29:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  70bc2f:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  70bc34:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  70bc3b:	00 00 
  70bc3d:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70bc42:	ff 15 60 59 3f 00    	call   *0x3f5960(%rip)        # b015a8 <_DYNAMIC+0x4b8>
  70bc48:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70bc4f:	00 00 
  70bc51:	80 fa 02             	cmp    $0x2,%dl
  70bc54:	75 3a                	jne    70bc90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x340>
  70bc56:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70bc5d:	00 
  70bc5e:	e9 4a ff ff ff       	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70bc63:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  70bc68:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  70bc6d:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70bc71:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70bc76:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  70bc7a:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70bc7f:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70bc83:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70bc87:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  70bc8b:	e9 1d ff ff ff       	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70bc90:	41 89 d5             	mov    %edx,%r13d
  70bc93:	41 89 c4             	mov    %eax,%r12d
  70bc96:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70bc9b:	e8 d0 86 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70bca0:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  70bca7:	ff 
  70bca8:	0f 84 03 02 00 00    	je     70beb1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x561>
  70bcae:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  70bcb5:	00 00 
  70bcb7:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70bcbc:	e8 af 86 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70bcc1:	48 89 de             	mov    %rbx,%rsi
  70bcc4:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  70bccb:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  70bcd0:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  70bcd7:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  70bcde:	00 
  70bcdf:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  70bce6:	48 89 04 24          	mov    %rax,(%rsp)
  70bcea:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  70bcf1:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  70bcf6:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70bcfb:	4c 89 fa             	mov    %r15,%rdx
  70bcfe:	4c 89 f1             	mov    %r14,%rcx
  70bd01:	e8 1a dd ff ff       	call   709a20 <<gpui::runtime::Runtime<unit_action_cost::Model>>::focus>
  70bd06:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70bd0b:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70bd0f:	0f 85 fa 00 00 00    	jne    70be0f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4bf>
  70bd15:	41 80 e5 01          	and    $0x1,%r13b
  70bd19:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  70bd20:	00 
  70bd21:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  70bd28:	00 
  70bd29:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  70bd30:	00 
  70bd31:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  70bd38:	00 
  70bd39:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70bd3e:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  70bd45:	00 
  70bd46:	48 89 de             	mov    %rbx,%rsi
  70bd49:	4c 89 fa             	mov    %r15,%rdx
  70bd4c:	4c 89 f1             	mov    %r14,%rcx
  70bd4f:	e8 fc f9 ff ff       	call   70b750 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input>
  70bd54:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70bd59:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70bd5e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  70bd65:	00 
  70bd66:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70bd6b:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  70bd72:	00 
  70bd73:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70bd78:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  70bd7f:	00 
  70bd80:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70bd84:	0f 85 bf 00 00 00    	jne    70be49 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4f9>
  70bd8a:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  70bd91:	00 
  70bd92:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70bd99:	00 
  70bd9a:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  70bda1:	00 
  70bda2:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  70bda9:	00 
  70bdaa:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  70bdb1:	00 
  70bdb2:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  70bdb9:	00 
  70bdba:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  70bdc1:	48 85 c0             	test   %rax,%rax
  70bdc4:	48 89 ef             	mov    %rbp,%rdi
  70bdc7:	0f 84 a9 00 00 00    	je     70be76 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x526>
  70bdcd:	48 8b 0c 24          	mov    (%rsp),%rcx
  70bdd1:	48 85 c9             	test   %rcx,%rcx
  70bdd4:	0f 84 a7 00 00 00    	je     70be81 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70bdda:	48 39 c8             	cmp    %rcx,%rax
  70bddd:	0f 85 9e 00 00 00    	jne    70be81 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70bde3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  70bde8:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  70bdef:	0f 85 8c 00 00 00    	jne    70be81 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70bdf5:	48 89 de             	mov    %rbx,%rsi
  70bdf8:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  70bdfd:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  70be04:	00 
  70be05:	e8 d6 00 00 00       	call   70bee0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change>
  70be0a:	e9 9e fd ff ff       	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70be0f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70be14:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  70be19:	8b 74 24 44          	mov    0x44(%rsp),%esi
  70be1d:	89 75 34             	mov    %esi,0x34(%rbp)
  70be20:	8b 74 24 41          	mov    0x41(%rsp),%esi
  70be24:	89 75 31             	mov    %esi,0x31(%rbp)
  70be27:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70be2c:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70be31:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70be35:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70be39:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70be3d:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70be41:	88 55 30             	mov    %dl,0x30(%rbp)
  70be44:	e9 64 fd ff ff       	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70be49:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  70be50:	00 
  70be51:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70be58:	00 
  70be59:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  70be60:	00 
  70be61:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  70be65:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70be69:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70be6d:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70be71:	e9 37 fd ff ff       	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70be76:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  70be7b:	0f 84 74 ff ff ff    	je     70bdf5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4a5>
  70be81:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  70be88:	00 
  70be89:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  70be90:	00 
  70be91:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  70be98:	00 
  70be99:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  70be9d:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  70bea1:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  70bea5:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70beac:	e9 fc fc ff ff       	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70beb1:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  70beb8:	00 
  70beb9:	e9 ef fc ff ff       	jmp    70bbad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70bebe:	48 8d 15 7b 75 3c 00 	lea    0x3c757b(%rip),%rdx        # ad3440 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x828>
  70bec5:	4c 89 e7             	mov    %r12,%rdi
  70bec8:	ff 15 9a 55 3f 00    	call   *0x3f559a(%rip)        # b01468 <_DYNAMIC+0x378>
  70bece:	48 8d 15 83 75 3c 00 	lea    0x3c7583(%rip),%rdx        # ad3458 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x840>
  70bed5:	4c 89 e7             	mov    %r12,%rdi
  70bed8:	ff 15 8a 55 3f 00    	call   *0x3f558a(%rip)        # b01468 <_DYNAMIC+0x378>

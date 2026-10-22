
/tmp/gpui-style-startup-current-target/release/examples/literal_startup:     file format elf64-x86-64


Disassembly of section .text:

00000000004f9a20 <<gpui::element::El>::property_operand::<f64>>:
  4f9a20:	55                   	push   %rbp
  4f9a21:	41 57                	push   %r15
  4f9a23:	41 56                	push   %r14
  4f9a25:	41 54                	push   %r12
  4f9a27:	53                   	push   %rbx
  4f9a28:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
  4f9a2f:	89 d5                	mov    %edx,%ebp
  4f9a31:	48 89 f3             	mov    %rsi,%rbx
  4f9a34:	49 89 fe             	mov    %rdi,%r14
  4f9a37:	48 8b 11             	mov    (%rcx),%rdx
  4f9a3a:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  4f9a3e:	48 85 d2             	test   %rdx,%rdx
  4f9a41:	0f 84 be 00 00 00    	je     4f9b05 <<gpui::element::El>::property_operand::<f64>+0xe5>
  4f9a47:	48 8b bb a0 00 00 00 	mov    0xa0(%rbx),%rdi
  4f9a4e:	48 85 ff             	test   %rdi,%rdi
  4f9a51:	0f 85 86 00 00 00    	jne    4f9add <<gpui::element::El>::property_operand::<f64>+0xbd>
  4f9a57:	49 89 d7             	mov    %rdx,%r15
  4f9a5a:	49 89 cc             	mov    %rcx,%r12
  4f9a5d:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  4f9a64:	00 00 
  4f9a66:	48 c7 44 24 18 08 00 	movq   $0x8,0x18(%rsp)
  4f9a6d:	00 00 
  4f9a6f:	0f 57 c0             	xorps  %xmm0,%xmm0
  4f9a72:	0f 11 44 24 20       	movups %xmm0,0x20(%rsp)
  4f9a77:	0f 11 44 24 2d       	movups %xmm0,0x2d(%rsp)
  4f9a7c:	48 b8 03 00 00 00 00 	movabs $0x8000000000000003,%rax
  4f9a83:	00 00 80 
  4f9a86:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4f9a8b:	ff 15 df 02 2d 00    	call   *0x2d02df(%rip)        # 7c9d70 <_DYNAMIC+0x260>
  4f9a91:	bf 38 00 00 00       	mov    $0x38,%edi
  4f9a96:	be 08 00 00 00       	mov    $0x8,%esi
  4f9a9b:	ff 15 af 02 2d 00    	call   *0x2d02af(%rip)        # 7c9d50 <_DYNAMIC+0x240>
  4f9aa1:	48 85 c0             	test   %rax,%rax
  4f9aa4:	0f 84 3e 02 00 00    	je     4f9ce8 <<gpui::element::El>::property_operand::<f64>+0x2c8>
  4f9aaa:	48 89 c7             	mov    %rax,%rdi
  4f9aad:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  4f9ab2:	48 89 47 30          	mov    %rax,0x30(%rdi)
  4f9ab6:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  4f9abb:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  4f9ac0:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  4f9ac5:	0f 11 57 20          	movups %xmm2,0x20(%rdi)
  4f9ac9:	0f 11 4f 10          	movups %xmm1,0x10(%rdi)
  4f9acd:	0f 11 07             	movups %xmm0,(%rdi)
  4f9ad0:	48 89 bb a0 00 00 00 	mov    %rdi,0xa0(%rbx)
  4f9ad7:	4c 89 e1             	mov    %r12,%rcx
  4f9ada:	4c 89 fa             	mov    %r15,%rdx
  4f9add:	89 ee                	mov    %ebp,%esi
  4f9adf:	ff 15 a3 06 2d 00    	call   *0x2d06a3(%rip)        # 7ca188 <_DYNAMIC+0x678>
  4f9ae5:	ba b0 00 00 00       	mov    $0xb0,%edx
  4f9aea:	4c 89 f7             	mov    %r14,%rdi
  4f9aed:	48 89 de             	mov    %rbx,%rsi
  4f9af0:	48 81 c4 80 00 00 00 	add    $0x80,%rsp
  4f9af7:	5b                   	pop    %rbx
  4f9af8:	41 5c                	pop    %r12
  4f9afa:	41 5e                	pop    %r14
  4f9afc:	41 5f                	pop    %r15
  4f9afe:	5d                   	pop    %rbp
  4f9aff:	ff 25 7b 02 2d 00    	jmp    *0x2d027b(%rip)        # 7c9d80 <memcpy@GLIBC_2.14>
  4f9b05:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  4f9b0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
  4f9b11:	00 
  4f9b12:	48 8d 7c 24 44       	lea    0x44(%rsp),%rdi
  4f9b17:	4c 8d 7c 24 08       	lea    0x8(%rsp),%r15
  4f9b1c:	4c 89 fe             	mov    %r15,%rsi
  4f9b1f:	89 ea                	mov    %ebp,%edx
  4f9b21:	ff 15 49 06 2d 00    	call   *0x2d0649(%rip)        # 7ca170 <_DYNAMIC+0x660>
  4f9b27:	80 7c 24 44 ff       	cmpb   $0xff,0x44(%rsp)
  4f9b2c:	0f 84 8f 01 00 00    	je     4f9cc1 <<gpui::element::El>::property_operand::<f64>+0x2a1>
  4f9b32:	0f 10 44 24 44       	movups 0x44(%rsp),%xmm0
  4f9b37:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  4f9b3c:	0f 11 4c 24 6c       	movups %xmm1,0x6c(%rsp)
  4f9b41:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  4f9b46:	48 8b bb a0 00 00 00 	mov    0xa0(%rbx),%rdi
  4f9b4d:	48 85 ff             	test   %rdi,%rdi
  4f9b50:	74 08                	je     4f9b5a <<gpui::element::El>::property_operand::<f64>+0x13a>
  4f9b52:	89 ee                	mov    %ebp,%esi
  4f9b54:	ff 15 36 06 2d 00    	call   *0x2d0636(%rip)        # 7ca190 <_DYNAMIC+0x680>
  4f9b5a:	0f b7 c5             	movzwl %bp,%eax
  4f9b5d:	48 8d 0d 84 f2 2a 00 	lea    0x2af284(%rip),%rcx        # 7a8de8 <anon.75158de5310fa4960df0d507925fcde0.13.llvm.1703274094952131562+0x140>
  4f9b64:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  4f9b69:	80 78 12 01          	cmpb   $0x1,0x12(%rax)
  4f9b6d:	0f 85 af 00 00 00    	jne    4f9c22 <<gpui::element::El>::property_operand::<f64>+0x202>
  4f9b73:	80 7c 24 60 01       	cmpb   $0x1,0x60(%rsp)
  4f9b78:	0f 85 7c 01 00 00    	jne    4f9cfa <<gpui::element::El>::property_operand::<f64>+0x2da>
  4f9b7e:	f3 0f 10 44 24 64    	movss  0x64(%rsp),%xmm0
  4f9b84:	48 8b bb a0 00 00 00 	mov    0xa0(%rbx),%rdi
  4f9b8b:	48 85 ff             	test   %rdi,%rdi
  4f9b8e:	0f 85 86 00 00 00    	jne    4f9c1a <<gpui::element::El>::property_operand::<f64>+0x1fa>
  4f9b94:	f3 0f 11 44 24 40    	movss  %xmm0,0x40(%rsp)
  4f9b9a:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  4f9ba1:	00 00 
  4f9ba3:	48 c7 44 24 18 08 00 	movq   $0x8,0x18(%rsp)
  4f9baa:	00 00 
  4f9bac:	0f 57 c0             	xorps  %xmm0,%xmm0
  4f9baf:	0f 11 44 24 20       	movups %xmm0,0x20(%rsp)
  4f9bb4:	0f 11 44 24 2d       	movups %xmm0,0x2d(%rsp)
  4f9bb9:	48 b8 03 00 00 00 00 	movabs $0x8000000000000003,%rax
  4f9bc0:	00 00 80 
  4f9bc3:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4f9bc8:	ff 15 a2 01 2d 00    	call   *0x2d01a2(%rip)        # 7c9d70 <_DYNAMIC+0x260>
  4f9bce:	bf 38 00 00 00       	mov    $0x38,%edi
  4f9bd3:	be 08 00 00 00       	mov    $0x8,%esi
  4f9bd8:	ff 15 72 01 2d 00    	call   *0x2d0172(%rip)        # 7c9d50 <_DYNAMIC+0x240>
  4f9bde:	48 85 c0             	test   %rax,%rax
  4f9be1:	0f 84 74 01 00 00    	je     4f9d5b <<gpui::element::El>::property_operand::<f64>+0x33b>
  4f9be7:	48 89 c7             	mov    %rax,%rdi
  4f9bea:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  4f9bef:	48 89 47 30          	mov    %rax,0x30(%rdi)
  4f9bf3:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  4f9bf8:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  4f9bfd:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  4f9c02:	0f 11 57 20          	movups %xmm2,0x20(%rdi)
  4f9c06:	0f 11 4f 10          	movups %xmm1,0x10(%rdi)
  4f9c0a:	0f 11 07             	movups %xmm0,(%rdi)
  4f9c0d:	48 89 bb a0 00 00 00 	mov    %rdi,0xa0(%rbx)
  4f9c14:	f3 0f 10 44 24 40    	movss  0x40(%rsp),%xmm0
  4f9c1a:	ff 15 88 05 2d 00    	call   *0x2d0588(%rip)        # 7ca1a8 <_DYNAMIC+0x698>
  4f9c20:	eb 1a                	jmp    4f9c3c <<gpui::element::El>::property_operand::<f64>+0x21c>
  4f9c22:	48 8d 73 30          	lea    0x30(%rbx),%rsi
  4f9c26:	48 8d 54 24 60       	lea    0x60(%rsp),%rdx
  4f9c2b:	89 ef                	mov    %ebp,%edi
  4f9c2d:	ff 15 45 05 2d 00    	call   *0x2d0545(%rip)        # 7ca178 <_DYNAMIC+0x668>
  4f9c33:	66 85 c0             	test   %ax,%ax
  4f9c36:	0f 85 d9 00 00 00    	jne    4f9d15 <<gpui::element::El>::property_operand::<f64>+0x2f5>
  4f9c3c:	4c 8b bb a0 00 00 00 	mov    0xa0(%rbx),%r15
  4f9c43:	4d 85 ff             	test   %r15,%r15
  4f9c46:	0f 84 99 fe ff ff    	je     4f9ae5 <<gpui::element::El>::property_operand::<f64>+0xc5>
  4f9c4c:	48 b8 03 00 00 00 00 	movabs $0x8000000000000003,%rax
  4f9c53:	00 00 80 
  4f9c56:	49 39 07             	cmp    %rax,(%r15)
  4f9c59:	0f 85 86 fe ff ff    	jne    4f9ae5 <<gpui::element::El>::property_operand::<f64>+0xc5>
  4f9c5f:	49 83 7f 20 00       	cmpq   $0x0,0x20(%r15)
  4f9c64:	0f 85 7b fe ff ff    	jne    4f9ae5 <<gpui::element::El>::property_operand::<f64>+0xc5>
  4f9c6a:	49 83 7f 18 00       	cmpq   $0x0,0x18(%r15)
  4f9c6f:	0f 85 70 fe ff ff    	jne    4f9ae5 <<gpui::element::El>::property_operand::<f64>+0xc5>
  4f9c75:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  4f9c7a:	0f 85 65 fe ff ff    	jne    4f9ae5 <<gpui::element::El>::property_operand::<f64>+0xc5>
  4f9c80:	41 83 7f 30 00       	cmpl   $0x0,0x30(%r15)
  4f9c85:	0f 85 5a fe ff ff    	jne    4f9ae5 <<gpui::element::El>::property_operand::<f64>+0xc5>
  4f9c8b:	41 80 7f 34 00       	cmpb   $0x0,0x34(%r15)
  4f9c90:	0f 85 4f fe ff ff    	jne    4f9ae5 <<gpui::element::El>::property_operand::<f64>+0xc5>
  4f9c96:	4c 89 ff             	mov    %r15,%rdi
  4f9c99:	e8 52 1a 00 00       	call   4fb6f0 <core::ptr::drop_glue::<gpui::semantic::ElementExtra>>
  4f9c9e:	be 38 00 00 00       	mov    $0x38,%esi
  4f9ca3:	ba 08 00 00 00       	mov    $0x8,%edx
  4f9ca8:	4c 89 ff             	mov    %r15,%rdi
  4f9cab:	ff 15 a7 00 2d 00    	call   *0x2d00a7(%rip)        # 7c9d58 <_DYNAMIC+0x248>
  4f9cb1:	48 c7 83 a0 00 00 00 	movq   $0x0,0xa0(%rbx)
  4f9cb8:	00 00 00 00 
  4f9cbc:	e9 24 fe ff ff       	jmp    4f9ae5 <<gpui::element::El>::property_operand::<f64>+0xc5>
  4f9cc1:	0f b7 44 24 4a       	movzwl 0x4a(%rsp),%eax
  4f9cc6:	66 89 44 24 0c       	mov    %ax,0xc(%rsp)
  4f9ccb:	8b 44 24 46          	mov    0x46(%rsp),%eax
  4f9ccf:	89 44 24 08          	mov    %eax,0x8(%rsp)
  4f9cd3:	4c 8d 05 86 ef 2a 00 	lea    0x2aef86(%rip),%r8        # 7a8c60 <anon.6f305857a6e080d5018272bfc63fda68.0.llvm.2199850371625610380+0xc8>
  4f9cda:	be 1e 00 00 00       	mov    $0x1e,%esi
  4f9cdf:	48 8d 3d 02 ec b4 ff 	lea    -0x4b13fe(%rip),%rdi        # 488e8 <anon.8658b204e9eae4eaf9bcf27658b3ee09.5.llvm.3942281989498588229+0x25f>
  4f9ce6:	eb 61                	jmp    4f9d49 <<gpui::element::El>::property_operand::<f64>+0x329>
  4f9ce8:	bf 08 00 00 00       	mov    $0x8,%edi
  4f9ced:	be 38 00 00 00       	mov    $0x38,%esi
  4f9cf2:	ff 15 90 00 2d 00    	call   *0x2d0090(%rip)        # 7c9d88 <_DYNAMIC+0x278>
  4f9cf8:	eb 71                	jmp    4f9d6b <<gpui::element::El>::property_operand::<f64>+0x34b>
  4f9cfa:	48 8d 3d bf eb b4 ff 	lea    -0x4b1441(%rip),%rdi        # 488c0 <anon.8658b204e9eae4eaf9bcf27658b3ee09.5.llvm.3942281989498588229+0x237>
  4f9d01:	48 8d 15 88 ef 2a 00 	lea    0x2aef88(%rip),%rdx        # 7a8c90 <anon.6f305857a6e080d5018272bfc63fda68.0.llvm.2199850371625610380+0xf8>
  4f9d08:	be 28 00 00 00       	mov    $0x28,%esi
  4f9d0d:	ff 15 7d 00 2d 00    	call   *0x2d007d(%rip)        # 7c9d90 <_DYNAMIC+0x280>
  4f9d13:	eb 56                	jmp    4f9d6b <<gpui::element::El>::property_operand::<f64>+0x34b>
  4f9d15:	89 c1                	mov    %eax,%ecx
  4f9d17:	c1 e9 10             	shr    $0x10,%ecx
  4f9d1a:	48 89 c2             	mov    %rax,%rdx
  4f9d1d:	48 c1 ea 18          	shr    $0x18,%rdx
  4f9d21:	66 89 44 24 08       	mov    %ax,0x8(%rsp)
  4f9d26:	88 4c 24 0a          	mov    %cl,0xa(%rsp)
  4f9d2a:	66 89 54 24 0b       	mov    %dx,0xb(%rsp)
  4f9d2f:	c1 ea 10             	shr    $0x10,%edx
  4f9d32:	88 54 24 0d          	mov    %dl,0xd(%rsp)
  4f9d36:	4c 8d 05 3b ef 2a 00 	lea    0x2aef3b(%rip),%r8        # 7a8c78 <anon.6f305857a6e080d5018272bfc63fda68.0.llvm.2199850371625610380+0xe0>
  4f9d3d:	be 1a 00 00 00       	mov    $0x1a,%esi
  4f9d42:	48 8d 3d bd eb b4 ff 	lea    -0x4b1443(%rip),%rdi        # 48906 <anon.8658b204e9eae4eaf9bcf27658b3ee09.5.llvm.3942281989498588229+0x27d>
  4f9d49:	48 8d 0d 70 ef 2a 00 	lea    0x2aef70(%rip),%rcx        # 7a8cc0 <anon.75158de5310fa4960df0d507925fcde0.13.llvm.1703274094952131562+0x18>
  4f9d50:	4c 89 fa             	mov    %r15,%rdx
  4f9d53:	ff 15 ff 00 2d 00    	call   *0x2d00ff(%rip)        # 7c9e58 <_DYNAMIC+0x348>
  4f9d59:	eb 10                	jmp    4f9d6b <<gpui::element::El>::property_operand::<f64>+0x34b>
  4f9d5b:	bf 08 00 00 00       	mov    $0x8,%edi
  4f9d60:	be 38 00 00 00       	mov    $0x38,%esi
  4f9d65:	ff 15 1d 00 2d 00    	call   *0x2d001d(%rip)        # 7c9d88 <_DYNAMIC+0x278>
  4f9d6b:	0f 0b                	ud2
  4f9d6d:	49 89 c6             	mov    %rax,%r14
  4f9d70:	be 38 00 00 00       	mov    $0x38,%esi
  4f9d75:	ba 08 00 00 00       	mov    $0x8,%edx
  4f9d7a:	4c 89 ff             	mov    %r15,%rdi
  4f9d7d:	ff 15 d5 ff 2c 00    	call   *0x2cffd5(%rip)        # 7c9d58 <_DYNAMIC+0x248>
  4f9d83:	48 c7 83 a0 00 00 00 	movq   $0x0,0xa0(%rbx)
  4f9d8a:	00 00 00 00 
  4f9d8e:	eb 2d                	jmp    4f9dbd <<gpui::element::El>::property_operand::<f64>+0x39d>
  4f9d90:	49 89 c6             	mov    %rax,%r14
  4f9d93:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  4f9d98:	e8 53 19 00 00       	call   4fb6f0 <core::ptr::drop_glue::<gpui::semantic::ElementExtra>>
  4f9d9d:	eb 1e                	jmp    4f9dbd <<gpui::element::El>::property_operand::<f64>+0x39d>
  4f9d9f:	ff 15 03 00 2d 00    	call   *0x2d0003(%rip)        # 7c9da8 <_DYNAMIC+0x298>
  4f9da5:	49 89 c6             	mov    %rax,%r14
  4f9da8:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  4f9dad:	e8 3e 19 00 00       	call   4fb6f0 <core::ptr::drop_glue::<gpui::semantic::ElementExtra>>
  4f9db2:	eb 09                	jmp    4f9dbd <<gpui::element::El>::property_operand::<f64>+0x39d>
  4f9db4:	ff 15 ee ff 2c 00    	call   *0x2cffee(%rip)        # 7c9da8 <_DYNAMIC+0x298>
  4f9dba:	49 89 c6             	mov    %rax,%r14
  4f9dbd:	48 89 df             	mov    %rbx,%rdi
  4f9dc0:	e8 2b 16 00 00       	call   4fb3f0 <core::ptr::drop_glue::<gpui::element::El>>
  4f9dc5:	4c 89 f7             	mov    %r14,%rdi
  4f9dc8:	e8 d3 cc 2a 00       	call   7a6aa0 <_Unwind_Resume@plt>
  4f9dcd:	ff 15 d5 ff 2c 00    	call   *0x2cffd5(%rip)        # 7c9da8 <_DYNAMIC+0x298>

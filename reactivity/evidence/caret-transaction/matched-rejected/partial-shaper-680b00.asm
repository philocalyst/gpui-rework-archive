
/tmp/gpui-caret-transaction-bin/matched-partial-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000680b00 <gpui_canvas::text::planner::append_caret>:
  680b00:	55                   	push   %rbp
  680b01:	41 57                	push   %r15
  680b03:	41 56                	push   %r14
  680b05:	41 55                	push   %r13
  680b07:	41 54                	push   %r12
  680b09:	53                   	push   %rbx
  680b0a:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  680b11:	49 89 cf             	mov    %rcx,%r15
  680b14:	49 89 d6             	mov    %rdx,%r14
  680b17:	48 89 fb             	mov    %rdi,%rbx
  680b1a:	f3 0f 5a e0          	cvtss2sd %xmm0,%xmm4
  680b1e:	41 80 38 00          	cmpb   $0x0,(%r8)
  680b22:	0f 84 fb 00 00 00    	je     680c23 <gpui_canvas::text::planner::append_caret+0x123>
  680b28:	41 0f 10 40 08       	movups 0x8(%r8),%xmm0
  680b2d:	41 0f 10 48 18       	movups 0x18(%r8),%xmm1
  680b32:	0f 29 04 24          	movaps %xmm0,(%rsp)
  680b36:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  680b3b:	66 0f 28 04 24       	movapd (%rsp),%xmm0
  680b40:	f2 0f 10 4c 24 08    	movsd  0x8(%rsp),%xmm1
  680b46:	f2 0f 58 cc          	addsd  %xmm4,%xmm1
  680b4a:	66 0f 28 54 24 10    	movapd 0x10(%rsp),%xmm2
  680b50:	66 0f 5c d0          	subpd  %xmm0,%xmm2
  680b54:	66 0f 14 c1          	unpcklpd %xmm1,%xmm0
  680b58:	66 0f 5a ca          	cvtpd2ps %xmm2,%xmm1
  680b5c:	66 0f 5a d8          	cvtpd2ps %xmm0,%xmm3
  680b60:	66 0f 14 d9          	unpcklpd %xmm1,%xmm3
  680b64:	66 0f 28 05 34 49 9a 	movapd -0x65b6cc(%rip),%xmm0        # 254a0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  680b6b:	ff 
  680b6c:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  680b70:	66 0f 66 05 f8 42 9a 	pcmpgtd -0x65bd08(%rip),%xmm0        # 24e70 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x1b0>
  680b77:	ff 
  680b78:	0f 50 c0             	movmskps %xmm0,%eax
  680b7b:	85 c0                	test   %eax,%eax
  680b7d:	0f 85 d8 01 00 00    	jne    680d5b <gpui_canvas::text::planner::append_caret+0x25b>
  680b83:	41 0f 10 40 28       	movups 0x28(%r8),%xmm0
  680b88:	41 0f 10 48 38       	movups 0x38(%r8),%xmm1
  680b8d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  680b91:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  680b96:	f2 0f 58 64 24 08    	addsd  0x8(%rsp),%xmm4
  680b9c:	66 0f 28 04 24       	movapd (%rsp),%xmm0
  680ba1:	66 0f 28 4c 24 10    	movapd 0x10(%rsp),%xmm1
  680ba7:	66 0f 5c c8          	subpd  %xmm0,%xmm1
  680bab:	66 0f 14 c4          	unpcklpd %xmm4,%xmm0
  680baf:	66 0f 5a c9          	cvtpd2ps %xmm1,%xmm1
  680bb3:	66 0f 5a e0          	cvtpd2ps %xmm0,%xmm4
  680bb7:	66 0f 14 e1          	unpcklpd %xmm1,%xmm4
  680bbb:	66 0f 28 05 dd 48 9a 	movapd -0x65b723(%rip),%xmm0        # 254a0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  680bc2:	ff 
  680bc3:	66 0f 54 c4          	andpd  %xmm4,%xmm0
  680bc7:	66 0f 66 05 a1 42 9a 	pcmpgtd -0x65bd5f(%rip),%xmm0        # 24e70 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x1b0>
  680bce:	ff 
  680bcf:	0f 50 c0             	movmskps %xmm0,%eax
  680bd2:	85 c0                	test   %eax,%eax
  680bd4:	0f 85 81 01 00 00    	jne    680d5b <gpui_canvas::text::planner::append_caret+0x25b>
  680bda:	45 01 f7             	add    %r14d,%r15d
  680bdd:	66 0f 28 c4          	movapd %xmm4,%xmm0
  680be1:	0f c6 c4 55          	shufps $0x55,%xmm4,%xmm0
  680be5:	0f 28 cc             	movaps %xmm4,%xmm1
  680be8:	66 0f 15 cc          	unpckhpd %xmm4,%xmm1
  680bec:	0f 28 d4             	movaps %xmm4,%xmm2
  680bef:	0f c6 d4 ff          	shufps $0xff,%xmm4,%xmm2
  680bf3:	66 0f 28 fb          	movapd %xmm3,%xmm7
  680bf7:	0f c6 fb 55          	shufps $0x55,%xmm3,%xmm7
  680bfb:	0f 28 eb             	movaps %xmm3,%xmm5
  680bfe:	66 0f 15 eb          	unpckhpd %xmm3,%xmm5
  680c02:	0f 28 f3             	movaps %xmm3,%xmm6
  680c05:	0f c6 f3 ff          	shufps $0xff,%xmm3,%xmm6
  680c09:	45 89 fe             	mov    %r15d,%r14d
  680c0c:	0f 2e dc             	ucomiss %xmm4,%xmm3
  680c0f:	40 b5 01             	mov    $0x1,%bpl
  680c12:	0f 85 f9 01 00 00    	jne    680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680c18:	0f 8b a6 01 00 00    	jnp    680dc4 <gpui_canvas::text::planner::append_caret+0x2c4>
  680c1e:	e9 ee 01 00 00       	jmp    680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680c23:	49 89 f5             	mov    %rsi,%r13
  680c26:	0f 29 64 24 30       	movaps %xmm4,0x30(%rsp)
  680c2b:	48 89 f7             	mov    %rsi,%rdi
  680c2e:	4c 89 fe             	mov    %r15,%rsi
  680c31:	ba 01 00 00 00       	mov    $0x1,%edx
  680c36:	e8 05 42 00 00       	call   684e40 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
  680c3b:	49 89 c4             	mov    %rax,%r12
  680c3e:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  680c43:	80 e2 01             	and    $0x1,%dl
  680c46:	88 54 24 48          	mov    %dl,0x48(%rsp)
  680c4a:	4c 39 f8             	cmp    %r15,%rax
  680c4d:	0f 85 82 00 00 00    	jne    680cd5 <gpui_canvas::text::planner::append_caret+0x1d5>
  680c53:	48 89 e7             	mov    %rsp,%rdi
  680c56:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  680c5b:	f3 0f 10 05 09 cb 99 	movss  -0x6634f7(%rip),%xmm0        # 1d76c <GCC_except_table0+0x28>
  680c62:	ff 
  680c63:	4c 89 ea             	mov    %r13,%rdx
  680c66:	e8 95 42 00 00       	call   684f00 <<parley::editing::cursor::Cursor>::geometry::<()>>
  680c6b:	f2 0f 10 44 24 08    	movsd  0x8(%rsp),%xmm0
  680c71:	f2 0f 58 44 24 30    	addsd  0x30(%rsp),%xmm0
  680c77:	66 0f 28 0c 24       	movapd (%rsp),%xmm1
  680c7c:	66 0f 28 54 24 10    	movapd 0x10(%rsp),%xmm2
  680c82:	66 0f 5c d1          	subpd  %xmm1,%xmm2
  680c86:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
  680c8a:	66 0f 5a c9          	cvtpd2ps %xmm1,%xmm1
  680c8e:	66 0f 5a d2          	cvtpd2ps %xmm2,%xmm2
  680c92:	66 0f 28 c1          	movapd %xmm1,%xmm0
  680c96:	66 0f 14 c2          	unpcklpd %xmm2,%xmm0
  680c9a:	66 0f 54 05 fe 47 9a 	andpd  -0x65b802(%rip),%xmm0        # 254a0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  680ca1:	ff 
  680ca2:	66 0f 66 05 c6 41 9a 	pcmpgtd -0x65be3a(%rip),%xmm0        # 24e70 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x1b0>
  680ca9:	ff 
  680caa:	0f 50 c0             	movmskps %xmm0,%eax
  680cad:	85 c0                	test   %eax,%eax
  680caf:	0f 85 a6 00 00 00    	jne    680d5b <gpui_canvas::text::planner::append_caret+0x25b>
  680cb5:	66 0f 29 4c 24 20    	movapd %xmm1,0x20(%rsp)
  680cbb:	0f c6 c9 55          	shufps $0x55,%xmm1,%xmm1
  680cbf:	0f 29 4c 24 50       	movaps %xmm1,0x50(%rsp)
  680cc4:	66 0f 29 54 24 70    	movapd %xmm2,0x70(%rsp)
  680cca:	0f c6 d2 55          	shufps $0x55,%xmm2,%xmm2
  680cce:	0f 29 54 24 60       	movaps %xmm2,0x60(%rsp)
  680cd3:	eb 00                	jmp    680cd5 <gpui_canvas::text::planner::append_caret+0x1d5>
  680cd5:	4c 89 ef             	mov    %r13,%rdi
  680cd8:	4c 89 fe             	mov    %r15,%rsi
  680cdb:	31 d2                	xor    %edx,%edx
  680cdd:	e8 5e 41 00 00       	call   684e40 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
  680ce2:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  680ce7:	80 e2 01             	and    $0x1,%dl
  680cea:	88 54 24 48          	mov    %dl,0x48(%rsp)
  680cee:	4c 39 f8             	cmp    %r15,%rax
  680cf1:	75 7f                	jne    680d72 <gpui_canvas::text::planner::append_caret+0x272>
  680cf3:	48 89 e7             	mov    %rsp,%rdi
  680cf6:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  680cfb:	f3 0f 10 05 69 ca 99 	movss  -0x663597(%rip),%xmm0        # 1d76c <GCC_except_table0+0x28>
  680d02:	ff 
  680d03:	4c 89 ea             	mov    %r13,%rdx
  680d06:	e8 f5 41 00 00       	call   684f00 <<parley::editing::cursor::Cursor>::geometry::<()>>
  680d0b:	66 0f 28 54 24 30    	movapd 0x30(%rsp),%xmm2
  680d11:	f2 0f 58 54 24 08    	addsd  0x8(%rsp),%xmm2
  680d17:	66 0f 28 04 24       	movapd (%rsp),%xmm0
  680d1c:	66 0f 28 4c 24 10    	movapd 0x10(%rsp),%xmm1
  680d22:	66 0f 5c c8          	subpd  %xmm0,%xmm1
  680d26:	66 0f 14 c2          	unpcklpd %xmm2,%xmm0
  680d2a:	66 0f 5a e0          	cvtpd2ps %xmm0,%xmm4
  680d2e:	66 0f 5a c1          	cvtpd2ps %xmm1,%xmm0
  680d32:	66 0f 14 e0          	unpcklpd %xmm0,%xmm4
  680d36:	66 0f 28 05 62 47 9a 	movapd -0x65b89e(%rip),%xmm0        # 254a0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  680d3d:	ff 
  680d3e:	66 0f 54 c4          	andpd  %xmm4,%xmm0
  680d42:	66 0f 66 05 26 41 9a 	pcmpgtd -0x65beda(%rip),%xmm0        # 24e70 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x1b0>
  680d49:	ff 
  680d4a:	0f 50 c0             	movmskps %xmm0,%eax
  680d4d:	85 c0                	test   %eax,%eax
  680d4f:	0f 28 5c 24 20       	movaps 0x20(%rsp),%xmm3
  680d54:	0f 28 6c 24 70       	movaps 0x70(%rsp),%xmm5
  680d59:	74 33                	je     680d8e <gpui_canvas::text::planner::append_caret+0x28e>
  680d5b:	b8 01 00 00 00       	mov    $0x1,%eax
  680d60:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  680d67:	5b                   	pop    %rbx
  680d68:	41 5c                	pop    %r12
  680d6a:	41 5d                	pop    %r13
  680d6c:	41 5e                	pop    %r14
  680d6e:	41 5f                	pop    %r15
  680d70:	5d                   	pop    %rbp
  680d71:	c3                   	ret
  680d72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  680d77:	4d 39 fc             	cmp    %r15,%r12
  680d7a:	75 e4                	jne    680d60 <gpui_canvas::text::planner::append_caret+0x260>
  680d7c:	45 01 f7             	add    %r14d,%r15d
  680d7f:	31 ed                	xor    %ebp,%ebp
  680d81:	45 89 fe             	mov    %r15d,%r14d
  680d84:	0f 28 5c 24 20       	movaps 0x20(%rsp),%xmm3
  680d89:	e9 83 00 00 00       	jmp    680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680d8e:	45 01 fe             	add    %r15d,%r14d
  680d91:	4d 39 fc             	cmp    %r15,%r12
  680d94:	0f 85 c9 00 00 00    	jne    680e63 <gpui_canvas::text::planner::append_caret+0x363>
  680d9a:	66 0f 28 c4          	movapd %xmm4,%xmm0
  680d9e:	0f c6 c4 55          	shufps $0x55,%xmm4,%xmm0
  680da2:	0f 28 cc             	movaps %xmm4,%xmm1
  680da5:	66 0f 15 cc          	unpckhpd %xmm4,%xmm1
  680da9:	0f 28 d4             	movaps %xmm4,%xmm2
  680dac:	0f c6 d4 ff          	shufps $0xff,%xmm4,%xmm2
  680db0:	0f 28 74 24 60       	movaps 0x60(%rsp),%xmm6
  680db5:	0f 28 7c 24 50       	movaps 0x50(%rsp),%xmm7
  680dba:	0f 2e dc             	ucomiss %xmm4,%xmm3
  680dbd:	40 b5 01             	mov    $0x1,%bpl
  680dc0:	75 4f                	jne    680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680dc2:	7a 4d                	jp     680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680dc4:	0f 2e f8             	ucomiss %xmm0,%xmm7
  680dc7:	75 48                	jne    680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680dc9:	7a 46                	jp     680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680dcb:	0f 2e e9             	ucomiss %xmm1,%xmm5
  680dce:	75 41                	jne    680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680dd0:	7a 3f                	jp     680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680dd2:	0f 2e f2             	ucomiss %xmm2,%xmm6
  680dd5:	75 3a                	jne    680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680dd7:	7a 38                	jp     680e11 <gpui_canvas::text::planner::append_caret+0x311>
  680dd9:	4c 8b 7b 10          	mov    0x10(%rbx),%r15
  680ddd:	4c 3b 3b             	cmp    (%rbx),%r15
  680de0:	75 13                	jne    680df5 <gpui_canvas::text::planner::append_caret+0x2f5>
  680de2:	48 89 df             	mov    %rbx,%rdi
  680de5:	0f 29 5c 24 20       	movaps %xmm3,0x20(%rsp)
  680dea:	ff 15 d8 84 10 00    	call   *0x1084d8(%rip)        # 7892c8 <_DYNAMIC+0x4b0>
  680df0:	0f 28 5c 24 20       	movaps 0x20(%rsp),%xmm3
  680df5:	48 8b 43 08          	mov    0x8(%rbx),%rax
  680df9:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  680dfd:	44 89 34 88          	mov    %r14d,(%rax,%rcx,4)
  680e01:	f3 0f 11 5c 88 04    	movss  %xmm3,0x4(%rax,%rcx,4)
  680e07:	c6 44 88 08 03       	movb   $0x3,0x8(%rax,%rcx,4)
  680e0c:	e9 85 00 00 00       	jmp    680e96 <gpui_canvas::text::planner::append_caret+0x396>
  680e11:	4c 8b 7b 10          	mov    0x10(%rbx),%r15
  680e15:	4c 3b 3b             	cmp    (%rbx),%r15
  680e18:	75 1d                	jne    680e37 <gpui_canvas::text::planner::append_caret+0x337>
  680e1a:	48 89 df             	mov    %rbx,%rdi
  680e1d:	0f 29 5c 24 20       	movaps %xmm3,0x20(%rsp)
  680e22:	0f 29 64 24 30       	movaps %xmm4,0x30(%rsp)
  680e27:	ff 15 9b 84 10 00    	call   *0x10849b(%rip)        # 7892c8 <_DYNAMIC+0x4b0>
  680e2d:	0f 28 64 24 30       	movaps 0x30(%rsp),%xmm4
  680e32:	0f 28 5c 24 20       	movaps 0x20(%rsp),%xmm3
  680e37:	48 8b 43 08          	mov    0x8(%rbx),%rax
  680e3b:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  680e3f:	44 89 34 88          	mov    %r14d,(%rax,%rcx,4)
  680e43:	f3 0f 11 5c 88 04    	movss  %xmm3,0x4(%rax,%rcx,4)
  680e49:	c6 44 88 08 01       	movb   $0x1,0x8(%rax,%rcx,4)
  680e4e:	49 ff c7             	inc    %r15
  680e51:	4c 89 7b 10          	mov    %r15,0x10(%rbx)
  680e55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  680e5a:	40 84 ed             	test   %bpl,%bpl
  680e5d:	0f 84 fd fe ff ff    	je     680d60 <gpui_canvas::text::planner::append_caret+0x260>
  680e63:	4c 8b 7b 10          	mov    0x10(%rbx),%r15
  680e67:	4c 3b 3b             	cmp    (%rbx),%r15
  680e6a:	75 13                	jne    680e7f <gpui_canvas::text::planner::append_caret+0x37f>
  680e6c:	48 89 df             	mov    %rbx,%rdi
  680e6f:	0f 29 64 24 30       	movaps %xmm4,0x30(%rsp)
  680e74:	ff 15 4e 84 10 00    	call   *0x10844e(%rip)        # 7892c8 <_DYNAMIC+0x4b0>
  680e7a:	0f 28 64 24 30       	movaps 0x30(%rsp),%xmm4
  680e7f:	48 8b 43 08          	mov    0x8(%rbx),%rax
  680e83:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  680e87:	44 89 34 88          	mov    %r14d,(%rax,%rcx,4)
  680e8b:	f3 0f 11 64 88 04    	movss  %xmm4,0x4(%rax,%rcx,4)
  680e91:	c6 44 88 08 02       	movb   $0x2,0x8(%rax,%rcx,4)
  680e96:	49 ff c7             	inc    %r15
  680e99:	4c 89 7b 10          	mov    %r15,0x10(%rbx)
  680e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  680ea2:	e9 b9 fe ff ff       	jmp    680d60 <gpui_canvas::text::planner::append_caret+0x260>

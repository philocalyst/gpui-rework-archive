
/tmp/gpui-caret-transaction-bin/matched-partial-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007ebcf0 <parley::editing::geometry::pair_from_entries::<()>>:
  7ebcf0:	55                   	push   %rbp
  7ebcf1:	41 57                	push   %r15
  7ebcf3:	41 56                	push   %r14
  7ebcf5:	41 55                	push   %r13
  7ebcf7:	41 54                	push   %r12
  7ebcf9:	53                   	push   %rbx
  7ebcfa:	48 81 ec d8 01 00 00 	sub    $0x1d8,%rsp
  7ebd01:	49 89 f6             	mov    %rsi,%r14
  7ebd04:	48 89 fb             	mov    %rdi,%rbx
  7ebd07:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  7ebd0c:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  7ebd11:	4d 85 c0             	test   %r8,%r8
  7ebd14:	74 4a                	je     7ebd60 <parley::editing::geometry::pair_from_entries::<()>+0x70>
  7ebd16:	41 8b 00             	mov    (%r8),%eax
  7ebd19:	49 39 86 18 01 00 00 	cmp    %rax,0x118(%r14)
  7ebd20:	76 3e                	jbe    7ebd60 <parley::editing::geometry::pair_from_entries::<()>+0x70>
  7ebd22:	41 8b 70 04          	mov    0x4(%r8),%esi
  7ebd26:	4c 6b c8 70          	imul   $0x70,%rax,%r9
  7ebd2a:	4d 8b 96 10 01 00 00 	mov    0x110(%r14),%r10
  7ebd31:	4b 8b 7c 0a 10       	mov    0x10(%r10,%r9,1),%rdi
  7ebd36:	48 01 f7             	add    %rsi,%rdi
  7ebd39:	4b 3b 7c 0a 18       	cmp    0x18(%r10,%r9,1),%rdi
  7ebd3e:	73 20                	jae    7ebd60 <parley::editing::geometry::pair_from_entries::<()>+0x70>
  7ebd40:	49 3b be 30 01 00 00 	cmp    0x130(%r14),%rdi
  7ebd47:	73 17                	jae    7ebd60 <parley::editing::geometry::pair_from_entries::<()>+0x70>
  7ebd49:	4d 8b 8e 28 01 00 00 	mov    0x128(%r14),%r9
  7ebd50:	48 8d 3c bf          	lea    (%rdi,%rdi,4),%rdi
  7ebd54:	41 80 7c f9 21 00    	cmpb   $0x0,0x21(%r9,%rdi,8)
  7ebd5a:	0f 84 e7 01 00 00    	je     7ebf47 <parley::editing::geometry::pair_from_entries::<()>+0x257>
  7ebd60:	48 c7 84 24 48 01 00 	movq   $0x0,0x148(%rsp)
  7ebd67:	00 00 00 00 00 
  7ebd6c:	49 8b 86 50 01 00 00 	mov    0x150(%r14),%rax
  7ebd73:	40 b5 01             	mov    $0x1,%bpl
  7ebd76:	45 31 ff             	xor    %r15d,%r15d
  7ebd79:	48 39 d0             	cmp    %rdx,%rax
  7ebd7c:	0f 85 0a 03 00 00    	jne    7ec08c <parley::editing::geometry::pair_from_entries::<()>+0x39c>
  7ebd82:	48 85 c9             	test   %rcx,%rcx
  7ebd85:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  7ebd8b:	74 48                	je     7ebdd5 <parley::editing::geometry::pair_from_entries::<()>+0xe5>
  7ebd8d:	8b 01                	mov    (%rcx),%eax
  7ebd8f:	49 39 86 18 01 00 00 	cmp    %rax,0x118(%r14)
  7ebd96:	76 3d                	jbe    7ebdd5 <parley::editing::geometry::pair_from_entries::<()>+0xe5>
  7ebd98:	8b 71 04             	mov    0x4(%rcx),%esi
  7ebd9b:	4c 6b c0 70          	imul   $0x70,%rax,%r8
  7ebd9f:	4d 8b 8e 10 01 00 00 	mov    0x110(%r14),%r9
  7ebda6:	4b 8b 7c 01 10       	mov    0x10(%r9,%r8,1),%rdi
  7ebdab:	48 01 f7             	add    %rsi,%rdi
  7ebdae:	4b 3b 7c 01 18       	cmp    0x18(%r9,%r8,1),%rdi
  7ebdb3:	73 20                	jae    7ebdd5 <parley::editing::geometry::pair_from_entries::<()>+0xe5>
  7ebdb5:	49 3b be 30 01 00 00 	cmp    0x130(%r14),%rdi
  7ebdbc:	73 17                	jae    7ebdd5 <parley::editing::geometry::pair_from_entries::<()>+0xe5>
  7ebdbe:	4d 8b 86 28 01 00 00 	mov    0x128(%r14),%r8
  7ebdc5:	48 8d 3c bf          	lea    (%rdi,%rdi,4),%rdi
  7ebdc9:	41 80 7c f8 21 00    	cmpb   $0x0,0x21(%r8,%rdi,8)
  7ebdcf:	0f 84 d3 02 00 00    	je     7ec0a8 <parley::editing::geometry::pair_from_entries::<()>+0x3b8>
  7ebdd5:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  7ebddc:	00 00 00 00 00 
  7ebde1:	45 31 e4             	xor    %r12d,%r12d
  7ebde4:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  7ebde9:	40 88 6c 24 68       	mov    %bpl,0x68(%rsp)
  7ebdee:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  7ebdf3:	4c 89 7c 24 28       	mov    %r15,0x28(%rsp)
  7ebdf8:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  7ebdff:	00 
  7ebe00:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  7ebe05:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  7ebe0a:	4c 8d 44 24 10       	lea    0x10(%rsp),%r8
  7ebe0f:	4c 8d 4c 24 18       	lea    0x18(%rsp),%r9
  7ebe14:	49 89 d5             	mov    %rdx,%r13
  7ebe17:	4c 89 f2             	mov    %r14,%rdx
  7ebe1a:	e8 91 c5 00 00       	call   7f83b0 <<parley::editing::cursor::Cursor>::geometry_with::<(), parley::editing::geometry::pair_from_entries<()>::{closure#2}::{closure#0}>>
  7ebe1f:	4d 85 ed             	test   %r13,%r13
  7ebe22:	0f 84 bb 00 00 00    	je     7ebee3 <parley::editing::geometry::pair_from_entries::<()>+0x1f3>
  7ebe28:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  7ebe2f:	00 
  7ebe30:	48 85 c0             	test   %rax,%rax
  7ebe33:	0f 84 aa 00 00 00    	je     7ebee3 <parley::editing::geometry::pair_from_entries::<()>+0x1f3>
  7ebe39:	8b bc 24 70 01 00 00 	mov    0x170(%rsp),%edi
  7ebe40:	48 8b 70 58          	mov    0x58(%rax),%rsi
  7ebe44:	48 39 fe             	cmp    %rdi,%rsi
  7ebe47:	0f 86 ef 02 00 00    	jbe    7ec13c <parley::editing::geometry::pair_from_entries::<()>+0x44c>
  7ebe4d:	48 8b 48 50          	mov    0x50(%rax),%rcx
  7ebe51:	48 8d 14 ff          	lea    (%rdi,%rdi,8),%rdx
  7ebe55:	48 c1 e2 04          	shl    $0x4,%rdx
  7ebe59:	0f 10 40 68          	movups 0x68(%rax),%xmm0
  7ebe5d:	0f 10 88 80 00 00 00 	movups 0x80(%rax),%xmm1
  7ebe64:	0f 10 90 98 00 00 00 	movups 0x98(%rax),%xmm2
  7ebe6b:	0f 11 44 24 20       	movups %xmm0,0x20(%rsp)
  7ebe70:	0f 11 4c 24 30       	movups %xmm1,0x30(%rsp)
  7ebe75:	0f 11 54 24 40       	movups %xmm2,0x40(%rsp)
  7ebe7a:	48 8b 44 11 50       	mov    0x50(%rcx,%rdx,1),%rax
  7ebe7f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  7ebe84:	8b b4 24 c8 01 00 00 	mov    0x1c8(%rsp),%esi
  7ebe8b:	8b 94 24 cc 01 00 00 	mov    0x1cc(%rsp),%edx
  7ebe92:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  7ebe97:	ff 15 d3 24 34 00    	call   *0x3424d3(%rip)        # b2e370 <_DYNAMIC+0xe70>
  7ebe9d:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  7ebea4:	00 
  7ebea5:	c6 84 24 90 00 00 00 	movb   $0x0,0x90(%rsp)
  7ebeac:	00 
  7ebead:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  7ebeb2:	4c 89 7c 24 28       	mov    %r15,0x28(%rsp)
  7ebeb7:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  7ebebc:	48 8d b4 24 88 00 00 	lea    0x88(%rsp),%rsi
  7ebec3:	00 
  7ebec4:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  7ebec9:	4c 8d 44 24 10       	lea    0x10(%rsp),%r8
  7ebece:	4c 8d 4c 24 18       	lea    0x18(%rsp),%r9
  7ebed3:	4c 89 f2             	mov    %r14,%rdx
  7ebed6:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  7ebedc:	e8 cf c4 00 00       	call   7f83b0 <<parley::editing::cursor::Cursor>::geometry_with::<(), parley::editing::geometry::pair_from_entries<()>::{closure#2}::{closure#0}>>
  7ebee1:	eb 1a                	jmp    7ebefd <parley::editing::geometry::pair_from_entries::<()>+0x20d>
  7ebee3:	0f 10 84 24 98 00 00 	movups 0x98(%rsp),%xmm0
  7ebeea:	00 
  7ebeeb:	0f 10 8c 24 a8 00 00 	movups 0xa8(%rsp),%xmm1
  7ebef2:	00 
  7ebef3:	0f 29 4c 24 70       	movaps %xmm1,0x70(%rsp)
  7ebef8:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  7ebefd:	0f 10 84 24 98 00 00 	movups 0x98(%rsp),%xmm0
  7ebf04:	00 
  7ebf05:	0f 10 8c 24 a8 00 00 	movups 0xa8(%rsp),%xmm1
  7ebf0c:	00 
  7ebf0d:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  7ebf12:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  7ebf17:	0f 28 54 24 60       	movaps 0x60(%rsp),%xmm2
  7ebf1c:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  7ebf21:	0f 29 54 24 40       	movaps %xmm2,0x40(%rsp)
  7ebf26:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
  7ebf2b:	0f 11 5b 38          	movups %xmm3,0x38(%rbx)
  7ebf2f:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  7ebf33:	0f 11 4b 18          	movups %xmm1,0x18(%rbx)
  7ebf37:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  7ebf3b:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  7ebf42:	e9 4c 01 00 00       	jmp    7ec093 <parley::editing::geometry::pair_from_entries::<()>+0x3a3>
  7ebf47:	4d 8d 0c f9          	lea    (%r9,%rdi,8),%r9
  7ebf4b:	49 8b 79 10          	mov    0x10(%r9),%rdi
  7ebf4f:	49 3b 7e 58          	cmp    0x58(%r14),%rdi
  7ebf53:	0f 83 07 fe ff ff    	jae    7ebd60 <parley::editing::geometry::pair_from_entries::<()>+0x70>
  7ebf59:	49 3b be e8 00 00 00 	cmp    0xe8(%r14),%rdi
  7ebf60:	0f 83 fa fd ff ff    	jae    7ebd60 <parley::editing::geometry::pair_from_entries::<()>+0x70>
  7ebf66:	4c 8d 14 ff          	lea    (%rdi,%rdi,8),%r10
  7ebf6a:	49 c1 e2 04          	shl    $0x4,%r10
  7ebf6e:	4d 03 56 50          	add    0x50(%r14),%r10
  7ebf72:	4c 8d 1c bf          	lea    (%rdi,%rdi,4),%r11
  7ebf76:	49 c1 e3 04          	shl    $0x4,%r11
  7ebf7a:	4d 03 9e e0 00 00 00 	add    0xe0(%r14),%r11
  7ebf81:	4c 89 b4 24 b8 00 00 	mov    %r14,0xb8(%rsp)
  7ebf88:	00 
  7ebf89:	4c 89 94 24 c0 00 00 	mov    %r10,0xc0(%rsp)
  7ebf90:	00 
  7ebf91:	4c 89 9c 24 c8 00 00 	mov    %r11,0xc8(%rsp)
  7ebf98:	00 
  7ebf99:	4c 89 8c 24 d0 00 00 	mov    %r9,0xd0(%rsp)
  7ebfa0:	00 
  7ebfa1:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
  7ebfa8:	89 b4 24 dc 00 00 00 	mov    %esi,0xdc(%rsp)
  7ebfaf:	89 bc 24 e0 00 00 00 	mov    %edi,0xe0(%rsp)
  7ebfb6:	41 8b 40 08          	mov    0x8(%r8),%eax
  7ebfba:	4c 8d bc 24 48 01 00 	lea    0x148(%rsp),%r15
  7ebfc1:	00 
  7ebfc2:	48 8d b4 24 b8 00 00 	lea    0xb8(%rsp),%rsi
  7ebfc9:	00 
  7ebfca:	4c 89 ff             	mov    %r15,%rdi
  7ebfcd:	49 89 d4             	mov    %rdx,%r12
  7ebfd0:	89 c2                	mov    %eax,%edx
  7ebfd2:	49 89 cd             	mov    %rcx,%r13
  7ebfd5:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  7ebfdb:	e8 20 df 00 00       	call   7f9f00 <<parley::layout::run::Run<()>>::cluster_containing_char>
  7ebfe0:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  7ebfe6:	4c 89 e9             	mov    %r13,%rcx
  7ebfe9:	4c 89 e2             	mov    %r12,%rdx
  7ebfec:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  7ebff3:	00 
  7ebff4:	48 85 c0             	test   %rax,%rax
  7ebff7:	0f 84 6f fd ff ff    	je     7ebd6c <parley::editing::geometry::pair_from_entries::<()>+0x7c>
  7ebffd:	8b bc 24 70 01 00 00 	mov    0x170(%rsp),%edi
  7ec004:	48 8b 70 58          	mov    0x58(%rax),%rsi
  7ec008:	48 39 fe             	cmp    %rdi,%rsi
  7ec00b:	0f 86 2b 01 00 00    	jbe    7ec13c <parley::editing::geometry::pair_from_entries::<()>+0x44c>
  7ec011:	48 8b 48 50          	mov    0x50(%rax),%rcx
  7ec015:	48 8d 14 ff          	lea    (%rdi,%rdi,8),%rdx
  7ec019:	48 c1 e2 04          	shl    $0x4,%rdx
  7ec01d:	0f 10 40 68          	movups 0x68(%rax),%xmm0
  7ec021:	0f 10 88 80 00 00 00 	movups 0x80(%rax),%xmm1
  7ec028:	0f 10 90 98 00 00 00 	movups 0x98(%rax),%xmm2
  7ec02f:	0f 11 84 24 b8 00 00 	movups %xmm0,0xb8(%rsp)
  7ec036:	00 
  7ec037:	0f 11 8c 24 c8 00 00 	movups %xmm1,0xc8(%rsp)
  7ec03e:	00 
  7ec03f:	0f 11 94 24 d8 00 00 	movups %xmm2,0xd8(%rsp)
  7ec046:	00 
  7ec047:	48 8b 44 11 50       	mov    0x50(%rcx,%rdx,1),%rax
  7ec04c:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  7ec053:	00 
  7ec054:	8b b4 24 c8 01 00 00 	mov    0x1c8(%rsp),%esi
  7ec05b:	8b 94 24 cc 01 00 00 	mov    0x1cc(%rsp),%edx
  7ec062:	48 8d bc 24 b8 00 00 	lea    0xb8(%rsp),%rdi
  7ec069:	00 
  7ec06a:	ff 15 00 23 34 00    	call   *0x342300(%rip)        # b2e370 <_DYNAMIC+0xe70>
  7ec070:	48 85 c0             	test   %rax,%rax
  7ec073:	40 0f 95 c5          	setne  %bpl
  7ec077:	4c 89 e2             	mov    %r12,%rdx
  7ec07a:	4c 89 e9             	mov    %r13,%rcx
  7ec07d:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  7ec083:	48 39 d0             	cmp    %rdx,%rax
  7ec086:	0f 84 f6 fc ff ff    	je     7ebd82 <parley::editing::geometry::pair_from_entries::<()>+0x92>
  7ec08c:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  7ec093:	48 89 d8             	mov    %rbx,%rax
  7ec096:	48 81 c4 d8 01 00 00 	add    $0x1d8,%rsp
  7ec09d:	5b                   	pop    %rbx
  7ec09e:	41 5c                	pop    %r12
  7ec0a0:	41 5d                	pop    %r13
  7ec0a2:	41 5e                	pop    %r14
  7ec0a4:	41 5f                	pop    %r15
  7ec0a6:	5d                   	pop    %rbp
  7ec0a7:	c3                   	ret
  7ec0a8:	4d 8d 04 f8          	lea    (%r8,%rdi,8),%r8
  7ec0ac:	49 8b 78 10          	mov    0x10(%r8),%rdi
  7ec0b0:	49 3b 7e 58          	cmp    0x58(%r14),%rdi
  7ec0b4:	0f 83 1b fd ff ff    	jae    7ebdd5 <parley::editing::geometry::pair_from_entries::<()>+0xe5>
  7ec0ba:	49 3b be e8 00 00 00 	cmp    0xe8(%r14),%rdi
  7ec0c1:	0f 83 0e fd ff ff    	jae    7ebdd5 <parley::editing::geometry::pair_from_entries::<()>+0xe5>
  7ec0c7:	4c 8d 0c ff          	lea    (%rdi,%rdi,8),%r9
  7ec0cb:	49 c1 e1 04          	shl    $0x4,%r9
  7ec0cf:	4d 03 4e 50          	add    0x50(%r14),%r9
  7ec0d3:	4c 8d 14 bf          	lea    (%rdi,%rdi,4),%r10
  7ec0d7:	49 c1 e2 04          	shl    $0x4,%r10
  7ec0db:	4d 03 96 e0 00 00 00 	add    0xe0(%r14),%r10
  7ec0e2:	4c 89 74 24 20       	mov    %r14,0x20(%rsp)
  7ec0e7:	4c 89 4c 24 28       	mov    %r9,0x28(%rsp)
  7ec0ec:	4c 89 54 24 30       	mov    %r10,0x30(%rsp)
  7ec0f1:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
  7ec0f6:	89 44 24 40          	mov    %eax,0x40(%rsp)
  7ec0fa:	89 74 24 44          	mov    %esi,0x44(%rsp)
  7ec0fe:	89 7c 24 48          	mov    %edi,0x48(%rsp)
  7ec102:	8b 41 08             	mov    0x8(%rcx),%eax
  7ec105:	4c 8d a4 24 b8 00 00 	lea    0xb8(%rsp),%r12
  7ec10c:	00 
  7ec10d:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  7ec112:	4c 89 e7             	mov    %r12,%rdi
  7ec115:	49 89 d5             	mov    %rdx,%r13
  7ec118:	89 c2                	mov    %eax,%edx
  7ec11a:	e8 e1 dd 00 00       	call   7f9f00 <<parley::layout::run::Run<()>>::cluster_containing_char>
  7ec11f:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  7ec125:	4c 89 ea             	mov    %r13,%rdx
  7ec128:	48 8b 84 24 b8 00 00 	mov    0xb8(%rsp),%rax
  7ec12f:	00 
  7ec130:	48 85 c0             	test   %rax,%rax
  7ec133:	4c 0f 44 e0          	cmove  %rax,%r12
  7ec137:	e9 a8 fc ff ff       	jmp    7ebde4 <parley::editing::geometry::pair_from_entries::<()>+0xf4>
  7ec13c:	48 8d 15 9d c1 31 00 	lea    0x31c19d(%rip),%rdx        # b082e0 <anon.e1aed3256c0f336e2763058c1a348a1e.26.llvm.17407148579165845042>
  7ec143:	ff 15 87 16 34 00    	call   *0x341687(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>

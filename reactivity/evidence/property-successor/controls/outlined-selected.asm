00000000006cbce0 <property_linked_control[154f7d0d02387650]::main>:
  6cbce0:	55                   	push   %rbp
  6cbce1:	41 57                	push   %r15
  6cbce3:	41 56                	push   %r14
  6cbce5:	41 55                	push   %r13
  6cbce7:	41 54                	push   %r12
  6cbce9:	53                   	push   %rbx
  6cbcea:	48 81 ec 28 0d 00 00 	sub    $0xd28,%rsp
  6cbcf1:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cbcf8:	00 
  6cbcf9:	48 bb f0 00 00 00 78 	movabs $0x78000000f0,%rbx
  6cbd00:	00 00 00 
  6cbd03:	f3 0f 10 05 e5 0f 97 	movss  -0x68f01b(%rip),%xmm0        # 3ccf0 <GCC_except_table0+0x34>
  6cbd0a:	ff 
  6cbd0b:	48 89 de             	mov    %rbx,%rsi
  6cbd0e:	ff 15 e4 08 34 00    	call   *0x3408e4(%rip)        # a0c5f8 <_DYNAMIC+0x458>
  6cbd14:	4c 8b bc 24 50 03 00 	mov    0x350(%rsp),%r15
  6cbd1b:	00 
  6cbd1c:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  6cbd20:	0f 85 80 19 00 00    	jne    6cd6a6 <property_linked_control[154f7d0d02387650]::main+0x19c6>
  6cbd26:	0f 57 c0             	xorps  %xmm0,%xmm0
  6cbd29:	0f 11 84 24 20 01 00 	movups %xmm0,0x120(%rsp)
  6cbd30:	00 
  6cbd31:	0f 11 84 24 38 01 00 	movups %xmm0,0x138(%rsp)
  6cbd38:	00 
  6cbd39:	48 c7 84 24 f8 00 00 	movq   $0xffffffffffffffff,0xf8(%rsp)
  6cbd40:	00 ff ff ff ff 
  6cbd45:	48 c7 84 24 10 01 00 	movq   $0x0,0x110(%rsp)
  6cbd4c:	00 00 00 00 00 
  6cbd51:	48 c7 84 24 18 01 00 	movq   $0x8,0x118(%rsp)
  6cbd58:	00 08 00 00 00 
  6cbd5d:	48 c7 84 24 30 01 00 	movq   $0x8,0x130(%rsp)
  6cbd64:	00 08 00 00 00 
  6cbd69:	48 c7 84 24 48 01 00 	movq   $0x8,0x148(%rsp)
  6cbd70:	00 08 00 00 00 
  6cbd75:	48 c7 84 24 50 01 00 	movq   $0x0,0x150(%rsp)
  6cbd7c:	00 00 00 00 00 
  6cbd81:	48 c7 84 24 58 01 00 	movq   $0x1,0x158(%rsp)
  6cbd88:	00 01 00 00 00 
  6cbd8d:	c7 84 24 90 0a 00 00 	movl   $0x0,0xa90(%rsp)
  6cbd94:	00 00 00 00 
  6cbd98:	c7 84 24 98 0a 00 00 	movl   $0x434b0000,0xa98(%rsp)
  6cbd9f:	00 00 4b 43 
  6cbda3:	66 c7 84 24 9c 0a 00 	movw   $0x0,0xa9c(%rsp)
  6cbdaa:	00 00 00 
  6cbdad:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cbdb4:	00 
  6cbdb5:	48 8d 8c 24 90 0a 00 	lea    0xa90(%rsp),%rcx
  6cbdbc:	00 
  6cbdbd:	be f0 00 00 00       	mov    $0xf0,%esi
  6cbdc2:	ba 78 00 00 00       	mov    $0x78,%edx
  6cbdc7:	ff 15 33 08 34 00    	call   *0x340833(%rip)        # a0c600 <_DYNAMIC+0x460>
  6cbdcd:	4c 8b bc 24 50 03 00 	mov    0x350(%rsp),%r15
  6cbdd4:	00 
  6cbdd5:	44 8b b4 24 58 03 00 	mov    0x358(%rsp),%r14d
  6cbddc:	00 
  6cbddd:	44 8b a4 24 5c 03 00 	mov    0x35c(%rsp),%r12d
  6cbde4:	00 
  6cbde5:	49 83 ff 02          	cmp    $0x2,%r15
  6cbde9:	0f 84 00 19 00 00    	je     6cd6ef <property_linked_control[154f7d0d02387650]::main+0x1a0f>
  6cbdef:	48 8d b4 24 60 03 00 	lea    0x360(%rsp),%rsi
  6cbdf6:	00 
  6cbdf7:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  6cbdfe:	00 
  6cbdff:	ba d8 01 00 00       	mov    $0x1d8,%edx
  6cbe04:	ff 15 f6 05 34 00    	call   *0x3405f6(%rip)        # a0c400 <memcpy@GLIBC_2.14>
  6cbe0a:	4c 89 bc 24 60 01 00 	mov    %r15,0x160(%rsp)
  6cbe11:	00 
  6cbe12:	44 89 b4 24 68 01 00 	mov    %r14d,0x168(%rsp)
  6cbe19:	00 
  6cbe1a:	44 89 a4 24 6c 01 00 	mov    %r12d,0x16c(%rsp)
  6cbe21:	00 
  6cbe22:	ff 15 e0 07 34 00    	call   *0x3407e0(%rip)        # a0c608 <_DYNAMIC+0x468>
  6cbe28:	49 89 c6             	mov    %rax,%r14
  6cbe2b:	48 8d bc 24 90 0a 00 	lea    0xa90(%rsp),%rdi
  6cbe32:	00 
  6cbe33:	ff 15 d7 07 34 00    	call   *0x3407d7(%rip)        # a0c610 <_DYNAMIC+0x470>
  6cbe39:	48 8b 84 24 58 01 00 	mov    0x158(%rsp),%rax
  6cbe40:	00 
  6cbe41:	48 89 84 24 d8 05 00 	mov    %rax,0x5d8(%rsp)
  6cbe48:	00 
  6cbe49:	0f 10 84 24 48 01 00 	movups 0x148(%rsp),%xmm0
  6cbe50:	00 
  6cbe51:	0f 11 84 24 c8 05 00 	movups %xmm0,0x5c8(%rsp)
  6cbe58:	00 
  6cbe59:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  6cbe60:	00 
  6cbe61:	0f 11 84 24 b8 05 00 	movups %xmm0,0x5b8(%rsp)
  6cbe68:	00 
  6cbe69:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  6cbe70:	00 
  6cbe71:	0f 10 8c 24 08 01 00 	movups 0x108(%rsp),%xmm1
  6cbe78:	00 
  6cbe79:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  6cbe80:	00 
  6cbe81:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  6cbe88:	00 
  6cbe89:	0f 11 9c 24 a8 05 00 	movups %xmm3,0x5a8(%rsp)
  6cbe90:	00 
  6cbe91:	0f 11 94 24 98 05 00 	movups %xmm2,0x598(%rsp)
  6cbe98:	00 
  6cbe99:	0f 11 8c 24 88 05 00 	movups %xmm1,0x588(%rsp)
  6cbea0:	00 
  6cbea1:	0f 11 84 24 78 05 00 	movups %xmm0,0x578(%rsp)
  6cbea8:	00 
  6cbea9:	48 8d bc 24 10 06 00 	lea    0x610(%rsp),%rdi
  6cbeb0:	00 
  6cbeb1:	48 8d b4 24 90 0a 00 	lea    0xa90(%rsp),%rsi
  6cbeb8:	00 
  6cbeb9:	4c 8b 3d 40 05 34 00 	mov    0x340540(%rip),%r15        # a0c400 <memcpy@GLIBC_2.14>
  6cbec0:	ba 98 02 00 00       	mov    $0x298,%edx
  6cbec5:	41 ff d7             	call   *%r15
  6cbec8:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cbecf:	00 
  6cbed0:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
  6cbed7:	00 
  6cbed8:	ba e8 01 00 00       	mov    $0x1e8,%edx
  6cbedd:	41 ff d7             	call   *%r15
  6cbee0:	48 c7 84 24 10 09 00 	movq   $0x0,0x910(%rsp)
  6cbee7:	00 00 00 00 00 
  6cbeec:	48 c7 84 24 20 09 00 	movq   $0x0,0x920(%rsp)
  6cbef3:	00 00 00 00 00 
  6cbef8:	48 c7 84 24 e0 05 00 	movq   $0x0,0x5e0(%rsp)
  6cbeff:	00 00 00 00 00 
  6cbf04:	48 c7 84 24 e8 05 00 	movq   $0x8,0x5e8(%rsp)
  6cbf0b:	00 08 00 00 00 
  6cbf10:	0f 57 c0             	xorps  %xmm0,%xmm0
  6cbf13:	0f 11 84 24 f0 05 00 	movups %xmm0,0x5f0(%rsp)
  6cbf1a:	00 
  6cbf1b:	48 c7 84 24 00 06 00 	movq   $0x8,0x600(%rsp)
  6cbf22:	00 08 00 00 00 
  6cbf27:	48 c7 84 24 08 06 00 	movq   $0x0,0x608(%rsp)
  6cbf2e:	00 00 00 00 00 
  6cbf33:	48 c7 84 24 40 09 00 	movq   $0x0,0x940(%rsp)
  6cbf3a:	00 00 00 00 00 
  6cbf3f:	0f 11 84 24 38 05 00 	movups %xmm0,0x538(%rsp)
  6cbf46:	00 
  6cbf47:	0f 11 84 24 48 05 00 	movups %xmm0,0x548(%rsp)
  6cbf4e:	00 
  6cbf4f:	0f 11 84 24 28 09 00 	movups %xmm0,0x928(%rsp)
  6cbf56:	00 
  6cbf57:	48 c7 84 24 48 09 00 	movq   $0x1,0x948(%rsp)
  6cbf5e:	00 01 00 00 00 
  6cbf63:	48 c7 84 24 50 09 00 	movq   $0x0,0x950(%rsp)
  6cbf6a:	00 00 00 00 00 
  6cbf6f:	4c 89 b4 24 00 09 00 	mov    %r14,0x900(%rsp)
  6cbf76:	00 
  6cbf77:	48 c7 84 24 60 09 00 	movq   $0x0,0x960(%rsp)
  6cbf7e:	00 00 00 00 00 
  6cbf83:	48 c7 84 24 a8 09 00 	movq   $0x0,0x9a8(%rsp)
  6cbf8a:	00 00 00 00 00 
  6cbf8f:	0f 11 84 24 70 09 00 	movups %xmm0,0x970(%rsp)
  6cbf96:	00 
  6cbf97:	48 c7 84 24 80 09 00 	movq   $0x0,0x980(%rsp)
  6cbf9e:	00 00 00 00 00 
  6cbfa3:	0f 11 84 24 90 09 00 	movups %xmm0,0x990(%rsp)
  6cbfaa:	00 
  6cbfab:	48 c7 84 24 a8 08 00 	movq   $0x0,0x8a8(%rsp)
  6cbfb2:	00 00 00 00 00 
  6cbfb7:	48 c7 84 24 b0 08 00 	movq   $0x8,0x8b0(%rsp)
  6cbfbe:	00 08 00 00 00 
  6cbfc3:	0f 11 84 24 b8 08 00 	movups %xmm0,0x8b8(%rsp)
  6cbfca:	00 
  6cbfcb:	48 c7 84 24 b0 09 00 	movq   $0x0,0x9b0(%rsp)
  6cbfd2:	00 00 00 00 00 
  6cbfd7:	48 c7 84 24 c0 09 00 	movq   $0x0,0x9c0(%rsp)
  6cbfde:	00 00 00 00 00 
  6cbfe3:	c7 84 24 80 0a 00 00 	movl   $0x1000101,0xa80(%rsp)
  6cbfea:	01 01 00 01 
  6cbfee:	66 c7 84 24 84 0a 00 	movw   $0x100,0xa84(%rsp)
  6cbff5:	00 00 01 
  6cbff8:	0f 11 84 24 c8 09 00 	movups %xmm0,0x9c8(%rsp)
  6cbfff:	00 
  6cc000:	48 c7 84 24 d8 09 00 	movq   $0x0,0x9d8(%rsp)
  6cc007:	00 00 00 00 00 
  6cc00c:	48 89 9c 24 e0 09 00 	mov    %rbx,0x9e0(%rsp)
  6cc013:	00 
  6cc014:	f2 0f 10 0d 04 18 97 	movsd  -0x68e7fc(%rip),%xmm1        # 3d820 <GCC_except_table0+0xb64>
  6cc01b:	ff 
  6cc01c:	f2 0f 11 8c 24 78 0a 	movsd  %xmm1,0xa78(%rsp)
  6cc023:	00 00 
  6cc025:	48 c7 84 24 08 09 00 	movq   $0x1,0x908(%rsp)
  6cc02c:	00 01 00 00 00 
  6cc031:	48 c7 84 24 d8 08 00 	movq   $0xffffffffffffffff,0x8d8(%rsp)
  6cc038:	00 ff ff ff ff 
  6cc03d:	48 c7 84 24 e8 09 00 	movq   $0x0,0x9e8(%rsp)
  6cc044:	00 00 00 00 00 
  6cc049:	48 c7 84 24 f8 09 00 	movq   $0x0,0x9f8(%rsp)
  6cc050:	00 00 00 00 00 
  6cc055:	48 c7 84 24 c8 08 00 	movq   $0x8,0x8c8(%rsp)
  6cc05c:	00 08 00 00 00 
  6cc061:	48 c7 84 24 d0 08 00 	movq   $0x0,0x8d0(%rsp)
  6cc068:	00 00 00 00 00 
  6cc06d:	c6 84 24 86 0a 00 00 	movb   $0x0,0xa86(%rsp)
  6cc074:	00 
  6cc075:	0f 11 84 24 60 0a 00 	movups %xmm0,0xa60(%rsp)
  6cc07c:	00 
  6cc07d:	0f 11 84 24 50 0a 00 	movups %xmm0,0xa50(%rsp)
  6cc084:	00 
  6cc085:	0f 11 84 24 40 0a 00 	movups %xmm0,0xa40(%rsp)
  6cc08c:	00 
  6cc08d:	0f 11 84 24 30 0a 00 	movups %xmm0,0xa30(%rsp)
  6cc094:	00 
  6cc095:	0f 11 84 24 20 0a 00 	movups %xmm0,0xa20(%rsp)
  6cc09c:	00 
  6cc09d:	0f 11 84 24 10 0a 00 	movups %xmm0,0xa10(%rsp)
  6cc0a4:	00 
  6cc0a5:	0f 11 84 24 00 0a 00 	movups %xmm0,0xa00(%rsp)
  6cc0ac:	00 
  6cc0ad:	48 c7 84 24 70 0a 00 	movq   $0x0,0xa70(%rsp)
  6cc0b4:	00 00 00 00 00 
  6cc0b9:	ff 15 29 03 34 00    	call   *0x340329(%rip)        # a0c3e8 <_DYNAMIC+0x248>
  6cc0bf:	bf 38 07 00 00       	mov    $0x738,%edi
  6cc0c4:	be 08 00 00 00       	mov    $0x8,%esi
  6cc0c9:	ff 15 21 03 34 00    	call   *0x340321(%rip)        # a0c3f0 <_DYNAMIC+0x250>
  6cc0cf:	48 85 c0             	test   %rax,%rax
  6cc0d2:	0f 84 ca 13 00 00    	je     6cd4a2 <property_linked_control[154f7d0d02387650]::main+0x17c2>
  6cc0d8:	48 89 c3             	mov    %rax,%rbx
  6cc0db:	48 8d b4 24 50 03 00 	lea    0x350(%rsp),%rsi
  6cc0e2:	00 
  6cc0e3:	ba 38 07 00 00       	mov    $0x738,%edx
  6cc0e8:	48 89 c7             	mov    %rax,%rdi
  6cc0eb:	ff 15 0f 03 34 00    	call   *0x34030f(%rip)        # a0c400 <memcpy@GLIBC_2.14>
  6cc0f1:	48 89 9c 24 d0 00 00 	mov    %rbx,0xd0(%rsp)
  6cc0f8:	00 
  6cc0f9:	48 8d 94 24 d8 00 00 	lea    0xd8(%rsp),%rdx
  6cc100:	00 
  6cc101:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6cc106:	48 89 de             	mov    %rbx,%rsi
  6cc109:	b9 01 00 00 00       	mov    $0x1,%ecx
  6cc10e:	45 31 c0             	xor    %r8d,%r8d
  6cc111:	e8 9a 48 00 00       	call   6d09b0 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::describe_with_changed>
  6cc116:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
  6cc11b:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  6cc11f:	0f 85 13 15 00 00    	jne    6cd638 <property_linked_control[154f7d0d02387650]::main+0x1958>
  6cc125:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6cc12a:	48 89 de             	mov    %rbx,%rsi
  6cc12d:	e8 ee 3a 02 00       	call   6efc20 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::present>
  6cc132:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
  6cc137:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  6cc13b:	0f 85 f7 14 00 00    	jne    6cd638 <property_linked_control[154f7d0d02387650]::main+0x1958>
  6cc141:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6cc148:	00 
  6cc149:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6cc14e:	48 85 c0             	test   %rax,%rax
  6cc151:	0f 84 2a 16 00 00    	je     6cd781 <property_linked_control[154f7d0d02387650]::main+0x1aa1>
  6cc157:	80 b8 36 07 00 00 00 	cmpb   $0x0,0x736(%rax)
  6cc15e:	0f 85 24 16 00 00    	jne    6cd788 <property_linked_control[154f7d0d02387650]::main+0x1aa8>
  6cc164:	80 b8 32 07 00 00 01 	cmpb   $0x1,0x732(%rax)
  6cc16b:	0f 85 1e 16 00 00    	jne    6cd78f <property_linked_control[154f7d0d02387650]::main+0x1aaf>
  6cc171:	4c 8b a8 80 05 00 00 	mov    0x580(%rax),%r13
  6cc178:	b9 1a 00 00 00       	mov    $0x1a,%ecx
  6cc17d:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  6cc182:	4d 85 ed             	test   %r13,%r13
  6cc185:	0f 84 0e 16 00 00    	je     6cd799 <property_linked_control[154f7d0d02387650]::main+0x1ab9>
  6cc18b:	48 8b a8 78 05 00 00 	mov    0x578(%rax),%rbp
  6cc192:	49 c1 e5 06          	shl    $0x6,%r13
  6cc196:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6cc19b:	4c 8d b0 e8 01 00 00 	lea    0x1e8(%rax),%r14
  6cc1a2:	45 31 e4             	xor    %r12d,%r12d
  6cc1a5:	bb 53 75 62 6a       	mov    $0x6a627553,%ebx
  6cc1aa:	41 bf 6a 65 63 74    	mov    $0x7463656a,%r15d
  6cc1b0:	eb 1b                	jmp    6cc1cd <property_linked_control[154f7d0d02387650]::main+0x4ed>
  6cc1b2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6cc1b9:	1f 84 00 00 00 00 00 
  6cc1c0:	49 83 c4 40          	add    $0x40,%r12
  6cc1c4:	4d 39 e5             	cmp    %r12,%r13
  6cc1c7:	0f 84 cc 15 00 00    	je     6cd799 <property_linked_control[154f7d0d02387650]::main+0x1ab9>
  6cc1cd:	42 80 7c 25 3d 05    	cmpb   $0x5,0x3d(%rbp,%r12,1)
  6cc1d3:	75 eb                	jne    6cc1c0 <property_linked_control[154f7d0d02387650]::main+0x4e0>
  6cc1d5:	4a 8b 44 25 28       	mov    0x28(%rbp,%r12,1),%rax
  6cc1da:	48 85 c0             	test   %rax,%rax
  6cc1dd:	74 e1                	je     6cc1c0 <property_linked_control[154f7d0d02387650]::main+0x4e0>
  6cc1df:	48 8b 08             	mov    (%rax),%rcx
  6cc1e2:	48 83 e1 fe          	and    $0xfffffffffffffffe,%rcx
  6cc1e6:	48 83 f9 0e          	cmp    $0xe,%rcx
  6cc1ea:	75 d4                	jne    6cc1c0 <property_linked_control[154f7d0d02387650]::main+0x4e0>
  6cc1ec:	8b 48 10             	mov    0x10(%rax),%ecx
  6cc1ef:	31 d9                	xor    %ebx,%ecx
  6cc1f1:	8b 40 13             	mov    0x13(%rax),%eax
  6cc1f4:	44 31 f8             	xor    %r15d,%eax
  6cc1f7:	09 c8                	or     %ecx,%eax
  6cc1f9:	75 c5                	jne    6cc1c0 <property_linked_control[154f7d0d02387650]::main+0x4e0>
  6cc1fb:	4a 8b 74 25 20       	mov    0x20(%rbp,%r12,1),%rsi
  6cc200:	4c 89 f7             	mov    %r14,%rdi
  6cc203:	ff 15 67 02 34 00    	call   *0x340267(%rip)        # a0c470 <_DYNAMIC+0x2d0>
  6cc209:	84 c0                	test   %al,%al
  6cc20b:	74 b3                	je     6cc1c0 <property_linked_control[154f7d0d02387650]::main+0x4e0>
  6cc20d:	4a 8b 74 25 20       	mov    0x20(%rbp,%r12,1),%rsi
  6cc212:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6cc217:	48 81 c7 b0 05 00 00 	add    $0x5b0,%rdi
  6cc21e:	ff 15 f4 03 34 00    	call   *0x3403f4(%rip)        # a0c618 <_DYNAMIC+0x478>
  6cc224:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6cc22b:	00 
  6cc22c:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  6cc233:	00 
  6cc234:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6cc239:	48 85 c0             	test   %rax,%rax
  6cc23c:	0f 84 9d 15 00 00    	je     6cd7df <property_linked_control[154f7d0d02387650]::main+0x1aff>
  6cc242:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  6cc247:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
  6cc24e:	00 
  6cc24f:	48 89 8c 24 68 01 00 	mov    %rcx,0x168(%rsp)
  6cc256:	00 
  6cc257:	48 c7 84 24 50 03 00 	movq   $0x0,0x350(%rsp)
  6cc25e:	00 00 00 00 00 
  6cc263:	80 b8 36 07 00 00 00 	cmpb   $0x0,0x736(%rax)
  6cc26a:	0f 85 8c 15 00 00    	jne    6cd7fc <property_linked_control[154f7d0d02387650]::main+0x1b1c>
  6cc270:	48 8b 88 78 06 00 00 	mov    0x678(%rax),%rcx
  6cc277:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  6cc27b:	0f 84 36 12 00 00    	je     6cd4b7 <property_linked_control[154f7d0d02387650]::main+0x17d7>
  6cc281:	48 ff c1             	inc    %rcx
  6cc284:	48 8b 94 24 c8 00 00 	mov    0xc8(%rsp),%rdx
  6cc28b:	00 
  6cc28c:	48 89 90 c0 05 00 00 	mov    %rdx,0x5c0(%rax)
  6cc293:	48 8b 94 24 c0 00 00 	mov    0xc0(%rsp),%rdx
  6cc29a:	00 
  6cc29b:	48 89 90 c8 05 00 00 	mov    %rdx,0x5c8(%rax)
  6cc2a2:	48 89 88 78 06 00 00 	mov    %rcx,0x678(%rax)
  6cc2a9:	48 ff 80 c8 06 00 00 	incq   0x6c8(%rax)
  6cc2b0:	48 c7 80 20 07 00 00 	movq   $0x0,0x720(%rax)
  6cc2b7:	00 00 00 00 
  6cc2bb:	48 8d bc 24 90 0a 00 	lea    0xa90(%rsp),%rdi
  6cc2c2:	00 
  6cc2c3:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
  6cc2ca:	00 
  6cc2cb:	48 8d 8c 24 50 03 00 	lea    0x350(%rsp),%rcx
  6cc2d2:	00 
  6cc2d3:	31 d2                	xor    %edx,%edx
  6cc2d5:	45 31 c0             	xor    %r8d,%r8d
  6cc2d8:	e8 43 22 00 00       	call   6ce520 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::after_source_changed>
  6cc2dd:	48 83 bc 24 90 0a 00 	cmpq   $0xfffffffffffffffe,0xa90(%rsp)
  6cc2e4:	00 fe 
  6cc2e6:	0f 85 d8 11 00 00    	jne    6cd4c4 <property_linked_control[154f7d0d02387650]::main+0x17e4>
  6cc2ec:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  6cc2f1:	48 85 db             	test   %rbx,%rbx
  6cc2f4:	0f 84 0c 15 00 00    	je     6cd806 <property_linked_control[154f7d0d02387650]::main+0x1b26>
  6cc2fa:	80 bb 36 07 00 00 00 	cmpb   $0x0,0x736(%rbx)
  6cc301:	0f 85 06 15 00 00    	jne    6cd80d <property_linked_control[154f7d0d02387650]::main+0x1b2d>
  6cc307:	80 bb 32 07 00 00 01 	cmpb   $0x1,0x732(%rbx)
  6cc30e:	0f 85 00 15 00 00    	jne    6cd814 <property_linked_control[154f7d0d02387650]::main+0x1b34>
  6cc314:	4c 8b ab 80 05 00 00 	mov    0x580(%rbx),%r13
  6cc31b:	b8 1a 00 00 00       	mov    $0x1a,%eax
  6cc320:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6cc325:	4d 85 ed             	test   %r13,%r13
  6cc328:	0f 84 f0 14 00 00    	je     6cd81e <property_linked_control[154f7d0d02387650]::main+0x1b3e>
  6cc32e:	48 8b ab 78 05 00 00 	mov    0x578(%rbx),%rbp
  6cc335:	49 c1 e5 06          	shl    $0x6,%r13
  6cc339:	4c 8d b3 e8 01 00 00 	lea    0x1e8(%rbx),%r14
  6cc340:	45 31 e4             	xor    %r12d,%r12d
  6cc343:	41 bf 41 63 74 69    	mov    $0x69746341,%r15d
  6cc349:	eb 12                	jmp    6cc35d <property_linked_control[154f7d0d02387650]::main+0x67d>
  6cc34b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  6cc350:	49 83 c4 40          	add    $0x40,%r12
  6cc354:	4d 39 e5             	cmp    %r12,%r13
  6cc357:	0f 84 c1 14 00 00    	je     6cd81e <property_linked_control[154f7d0d02387650]::main+0x1b3e>
  6cc35d:	42 80 7c 25 3d 05    	cmpb   $0x5,0x3d(%rbp,%r12,1)
  6cc363:	75 eb                	jne    6cc350 <property_linked_control[154f7d0d02387650]::main+0x670>
  6cc365:	4a 8b 44 25 28       	mov    0x28(%rbp,%r12,1),%rax
  6cc36a:	48 85 c0             	test   %rax,%rax
  6cc36d:	74 e1                	je     6cc350 <property_linked_control[154f7d0d02387650]::main+0x670>
  6cc36f:	48 8b 08             	mov    (%rax),%rcx
  6cc372:	48 83 e1 fe          	and    $0xfffffffffffffffe,%rcx
  6cc376:	48 83 f9 0c          	cmp    $0xc,%rcx
  6cc37a:	75 d4                	jne    6cc350 <property_linked_control[154f7d0d02387650]::main+0x670>
  6cc37c:	8b 48 10             	mov    0x10(%rax),%ecx
  6cc37f:	44 31 f9             	xor    %r15d,%ecx
  6cc382:	0f b7 40 14          	movzwl 0x14(%rax),%eax
  6cc386:	35 6f 6e 00 00       	xor    $0x6e6f,%eax
  6cc38b:	09 c8                	or     %ecx,%eax
  6cc38d:	75 c1                	jne    6cc350 <property_linked_control[154f7d0d02387650]::main+0x670>
  6cc38f:	4a 8b 74 25 20       	mov    0x20(%rbp,%r12,1),%rsi
  6cc394:	4c 89 f7             	mov    %r14,%rdi
  6cc397:	ff 15 d3 00 34 00    	call   *0x3400d3(%rip)        # a0c470 <_DYNAMIC+0x2d0>
  6cc39d:	84 c0                	test   %al,%al
  6cc39f:	74 af                	je     6cc350 <property_linked_control[154f7d0d02387650]::main+0x670>
  6cc3a1:	4a 8b 74 25 20       	mov    0x20(%rbp,%r12,1),%rsi
  6cc3a6:	48 81 c3 b0 05 00 00 	add    $0x5b0,%rbx
  6cc3ad:	48 89 df             	mov    %rbx,%rdi
  6cc3b0:	ff 15 62 02 34 00    	call   *0x340262(%rip)        # a0c618 <_DYNAMIC+0x478>
  6cc3b6:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6cc3bb:	48 89 94 24 f0 00 00 	mov    %rdx,0xf0(%rsp)
  6cc3c2:	00 
  6cc3c3:	48 8d 05 66 16 32 00 	lea    0x321666(%rip),%rax        # 9eda30 <__frame_dummy_init_array_entry+0xa00>
  6cc3ca:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  6cc3d1:	00 
  6cc3d2:	48 8d 05 47 19 32 00 	lea    0x321947(%rip),%rax        # 9edd20 <__frame_dummy_init_array_entry+0xcf0>
  6cc3d9:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  6cc3de:	48 8d 05 9b 19 32 00 	lea    0x32199b(%rip),%rax        # 9edd80 <__frame_dummy_init_array_entry+0xd50>
  6cc3e5:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  6cc3ec:	00 
  6cc3ed:	b8 03 00 00 00       	mov    $0x3,%eax
  6cc3f2:	eb 4b                	jmp    6cc43f <property_linked_control[154f7d0d02387650]::main+0x75f>
  6cc3f4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6cc3fb:	00 00 00 00 00 
  6cc400:	48 c7 84 24 60 01 00 	movq   $0x20,0x160(%rsp)
  6cc407:	00 20 00 00 00 
  6cc40c:	48 89 84 24 68 01 00 	mov    %rax,0x168(%rsp)
  6cc413:	00 
  6cc414:	4c 89 ac 24 70 01 00 	mov    %r13,0x170(%rsp)
  6cc41b:	00 
  6cc41c:	4c 89 bc 24 78 01 00 	mov    %r15,0x178(%rsp)
  6cc423:	00 
  6cc424:	48 83 bc 24 60 01 00 	cmpq   $0xfffffffffffffffe,0x160(%rsp)
  6cc42b:	00 fe 
  6cc42d:	8b 44 24 20          	mov    0x20(%rsp),%eax
  6cc431:	0f 85 fe 0f 00 00    	jne    6cd435 <property_linked_control[154f7d0d02387650]::main+0x1755>
  6cc437:	ff c8                	dec    %eax
  6cc439:	0f 84 a1 0e 00 00    	je     6cd2e0 <property_linked_control[154f7d0d02387650]::main+0x1600>
  6cc43f:	89 44 24 20          	mov    %eax,0x20(%rsp)
  6cc443:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  6cc448:	4d 85 e4             	test   %r12,%r12
  6cc44b:	0f 84 a8 11 00 00    	je     6cd5f9 <property_linked_control[154f7d0d02387650]::main+0x1919>
  6cc451:	4c 89 64 24 30       	mov    %r12,0x30(%rsp)
  6cc456:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  6cc45b:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6cc460:	48 c7 84 24 f8 00 00 	movq   $0x0,0xf8(%rsp)
  6cc467:	00 00 00 00 00 
  6cc46c:	41 80 bc 24 36 07 00 	cmpb   $0x1,0x736(%r12)
  6cc473:	00 01 
  6cc475:	0f 84 9b 11 00 00    	je     6cd616 <property_linked_control[154f7d0d02387650]::main+0x1936>
  6cc47b:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cc482:	00 
  6cc483:	4c 89 e6             	mov    %r12,%rsi
  6cc486:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  6cc48b:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  6cc492:	00 
  6cc493:	e8 48 7d 01 00       	call   6e41e0 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::resolve_index>
  6cc498:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6cc49f:	00 
  6cc4a0:	48 8b 9c 24 58 03 00 	mov    0x358(%rsp),%rbx
  6cc4a7:	00 
  6cc4a8:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6cc4ac:	0f 85 07 11 00 00    	jne    6cd5b9 <property_linked_control[154f7d0d02387650]::main+0x18d9>
  6cc4b2:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  6cc4b9:	00 
  6cc4ba:	48 39 f3             	cmp    %rsi,%rbx
  6cc4bd:	0f 83 e9 14 00 00    	jae    6cd9ac <property_linked_control[154f7d0d02387650]::main+0x1ccc>
  6cc4c3:	49 8b 84 24 98 02 00 	mov    0x298(%r12),%rax
  6cc4ca:	00 
  6cc4cb:	48 8d 0c 9b          	lea    (%rbx,%rbx,4),%rcx
  6cc4cf:	8b 54 c8 20          	mov    0x20(%rax,%rcx,8),%edx
  6cc4d3:	83 e2 0f             	and    $0xf,%edx
  6cc4d6:	8d 72 fd             	lea    -0x3(%rdx),%esi
  6cc4d9:	83 fe 07             	cmp    $0x7,%esi
  6cc4dc:	72 09                	jb     6cc4e7 <property_linked_control[154f7d0d02387650]::main+0x807>
  6cc4de:	83 fa 02             	cmp    $0x2,%edx
  6cc4e1:	0f 83 b3 00 00 00    	jae    6cc59a <property_linked_control[154f7d0d02387650]::main+0x8ba>
  6cc4e7:	48 8d 2c c8          	lea    (%rax,%rcx,8),%rbp
  6cc4eb:	48 83 7d 08 00       	cmpq   $0x0,0x8(%rbp)
  6cc4f0:	0f 84 31 11 00 00    	je     6cd627 <property_linked_control[154f7d0d02387650]::main+0x1947>
  6cc4f6:	48 83 c5 08          	add    $0x8,%rbp
  6cc4fa:	4d 8d b4 24 c0 05 00 	lea    0x5c0(%r12),%r14
  6cc501:	00 
  6cc502:	4d 8d 84 24 28 02 00 	lea    0x228(%r12),%r8
  6cc509:	00 
  6cc50a:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6cc50f:	48 89 ee             	mov    %rbp,%rsi
  6cc512:	4c 89 f2             	mov    %r14,%rdx
  6cc515:	48 8d 0d 2c 0f 32 00 	lea    0x320f2c(%rip),%rcx        # 9ed448 <__frame_dummy_init_array_entry+0x418>
  6cc51c:	4c 8d 0d 45 0f 32 00 	lea    0x320f45(%rip),%r9        # 9ed468 <__frame_dummy_init_array_entry+0x438>
  6cc523:	ff 15 f7 00 34 00    	call   *0x3400f7(%rip)        # a0c620 <_DYNAMIC+0x480>
  6cc529:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6cc52e:	4c 8b 6c 24 78       	mov    0x78(%rsp),%r13
  6cc533:	4c 8b bc 24 80 00 00 	mov    0x80(%rsp),%r15
  6cc53a:	00 
  6cc53b:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6cc542:	00 
  6cc543:	4c 89 ac 24 58 03 00 	mov    %r13,0x358(%rsp)
  6cc54a:	00 
  6cc54b:	4c 89 bc 24 60 03 00 	mov    %r15,0x360(%rsp)
  6cc552:	00 
  6cc553:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6cc557:	0f 84 43 0d 00 00    	je     6cd2a0 <property_linked_control[154f7d0d02387650]::main+0x15c0>
  6cc55d:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6cc561:	0f 85 99 fe ff ff    	jne    6cc400 <property_linked_control[154f7d0d02387650]::main+0x720>
  6cc567:	66 45 85 ed          	test   %r13w,%r13w
  6cc56b:	74 71                	je     6cc5de <property_linked_control[154f7d0d02387650]::main+0x8fe>
  6cc56d:	41 0f b7 c5          	movzwl %r13w,%eax
  6cc571:	83 f8 01             	cmp    $0x1,%eax
  6cc574:	0f 85 15 01 00 00    	jne    6cc68f <property_linked_control[154f7d0d02387650]::main+0x9af>
  6cc57a:	41 80 bc 24 36 07 00 	cmpb   $0x0,0x736(%r12)
  6cc581:	00 00 
  6cc583:	0f 84 28 01 00 00    	je     6cc6b1 <property_linked_control[154f7d0d02387650]::main+0x9d1>
  6cc589:	48 c7 84 24 60 01 00 	movq   $0xe,0x160(%rsp)
  6cc590:	00 0e 00 00 00 
  6cc595:	e9 8a fe ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cc59a:	0f 85 6b 0e 00 00    	jne    6cd40b <property_linked_control[154f7d0d02387650]::main+0x172b>
  6cc5a0:	49 c7 84 24 20 07 00 	movq   $0x0,0x720(%r12)
  6cc5a7:	00 00 00 00 00 
  6cc5ac:	41 0f b6 84 24 34 07 	movzbl 0x734(%r12),%eax
  6cc5b3:	00 00 
  6cc5b5:	49 83 bc 24 98 06 00 	cmpq   $0x0,0x698(%r12)
  6cc5bc:	00 00 
  6cc5be:	74 17                	je     6cc5d7 <property_linked_control[154f7d0d02387650]::main+0x8f7>
  6cc5c0:	84 c0                	test   %al,%al
  6cc5c2:	0f 84 98 01 00 00    	je     6cc760 <property_linked_control[154f7d0d02387650]::main+0xa80>
  6cc5c8:	49 83 bc 24 88 05 00 	cmpq   $0xffffffffffffffff,0x588(%r12)
  6cc5cf:	00 ff 
  6cc5d1:	0f 85 89 01 00 00    	jne    6cc760 <property_linked_control[154f7d0d02387650]::main+0xa80>
  6cc5d7:	31 d2                	xor    %edx,%edx
  6cc5d9:	e9 8f 01 00 00       	jmp    6cc76d <property_linked_control[154f7d0d02387650]::main+0xa8d>
  6cc5de:	4d 8b ac 24 78 06 00 	mov    0x678(%r12),%r13
  6cc5e5:	00 
  6cc5e6:	49 ff c5             	inc    %r13
  6cc5e9:	0f 84 3a 0e 00 00    	je     6cd429 <property_linked_control[154f7d0d02387650]::main+0x1749>
  6cc5ef:	48 8d bc 24 d0 00 00 	lea    0xd0(%rsp),%rdi
  6cc5f6:	00 
  6cc5f7:	48 89 ee             	mov    %rbp,%rsi
  6cc5fa:	4c 89 f2             	mov    %r14,%rdx
  6cc5fd:	48 8d 0d 44 0e 32 00 	lea    0x320e44(%rip),%rcx        # 9ed448 <__frame_dummy_init_array_entry+0x418>
  6cc604:	ff 15 1e 00 34 00    	call   *0x34001e(%rip)        # a0c628 <_DYNAMIC+0x488>
  6cc60a:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6cc611:	00 
  6cc612:	48 8b ac 24 d8 00 00 	mov    0xd8(%rsp),%rbp
  6cc619:	00 
  6cc61a:	48 8b 9c 24 e0 00 00 	mov    0xe0(%rsp),%rbx
  6cc621:	00 
  6cc622:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6cc629:	00 
  6cc62a:	48 89 ac 24 58 03 00 	mov    %rbp,0x358(%rsp)
  6cc631:	00 
  6cc632:	48 89 9c 24 60 03 00 	mov    %rbx,0x360(%rsp)
  6cc639:	00 
  6cc63a:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6cc63e:	0f 84 eb 0b 00 00    	je     6cd22f <property_linked_control[154f7d0d02387650]::main+0x154f>
  6cc644:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6cc648:	0f 85 e3 00 00 00    	jne    6cc731 <property_linked_control[154f7d0d02387650]::main+0xa51>
  6cc64e:	4d 89 ac 24 78 06 00 	mov    %r13,0x678(%r12)
  6cc655:	00 
  6cc656:	49 ff 84 24 c8 06 00 	incq   0x6c8(%r12)
  6cc65d:	00 
  6cc65e:	49 c7 84 24 20 07 00 	movq   $0x0,0x720(%r12)
  6cc665:	00 00 00 00 00 
  6cc66a:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6cc671:	00 
  6cc672:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
  6cc677:	4c 89 fa             	mov    %r15,%rdx
  6cc67a:	48 8d 8c 24 f8 00 00 	lea    0xf8(%rsp),%rcx
  6cc681:	00 
  6cc682:	45 31 c0             	xor    %r8d,%r8d
  6cc685:	e8 96 1e 00 00       	call   6ce520 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::after_source_changed>
  6cc68a:	e9 95 fd ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cc68f:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6cc696:	00 
  6cc697:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
  6cc69c:	48 89 da             	mov    %rbx,%rdx
  6cc69f:	48 8d 8c 24 f8 00 00 	lea    0xf8(%rsp),%rcx
  6cc6a6:	00 
  6cc6a7:	e8 c4 14 00 00       	call   6cdb70 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property>
  6cc6ac:	e9 73 fd ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cc6b1:	49 8b 84 24 28 06 00 	mov    0x628(%r12),%rax
  6cc6b8:	00 
  6cc6b9:	48 85 c0             	test   %rax,%rax
  6cc6bc:	0f 84 f0 00 00 00    	je     6cc7b2 <property_linked_control[154f7d0d02387650]::main+0xad2>
  6cc6c2:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6cc6c9:	00 
  6cc6ca:	0f 84 e2 00 00 00    	je     6cc7b2 <property_linked_control[154f7d0d02387650]::main+0xad2>
  6cc6d0:	49 c7 84 24 20 07 00 	movq   $0x0,0x720(%r12)
  6cc6d7:	00 00 00 00 00 
  6cc6dc:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  6cc6e3:	48 85 ed             	test   %rbp,%rbp
  6cc6e6:	0f 84 79 12 00 00    	je     6cd965 <property_linked_control[154f7d0d02387650]::main+0x1c85>
  6cc6ec:	49 c1 ed 10          	shr    $0x10,%r13
  6cc6f0:	44 0f b7 7d 10       	movzwl 0x10(%rbp),%r15d
  6cc6f5:	0f b6 75 16          	movzbl 0x16(%rbp),%esi
  6cc6f9:	0f b6 7d 12          	movzbl 0x12(%rbp),%edi
  6cc6fd:	44 89 eb             	mov    %r13d,%ebx
  6cc700:	66 83 eb 0e          	sub    $0xe,%bx
  6cc704:	b8 03 00 00 00       	mov    $0x3,%eax
  6cc709:	0f 42 d8             	cmovb  %eax,%ebx
  6cc70c:	66 83 fb 03          	cmp    $0x3,%bx
  6cc710:	0f 85 ad 00 00 00    	jne    6cc7c3 <property_linked_control[154f7d0d02387650]::main+0xae3>
  6cc716:	66 45 39 ef          	cmp    %r13w,%r15w
  6cc71a:	0f 84 a3 00 00 00    	je     6cc7c3 <property_linked_control[154f7d0d02387650]::main+0xae3>
  6cc720:	48 c7 84 24 60 01 00 	movq   $0x11,0x160(%rsp)
  6cc727:	00 11 00 00 00 
  6cc72c:	e9 f3 fc ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cc731:	48 8d 8c 24 58 03 00 	lea    0x358(%rsp),%rcx
  6cc738:	00 
  6cc739:	0f 10 01             	movups (%rcx),%xmm0
  6cc73c:	48 8d 8c 24 70 01 00 	lea    0x170(%rsp),%rcx
  6cc743:	00 
  6cc744:	0f 11 01             	movups %xmm0,(%rcx)
  6cc747:	48 c7 84 24 60 01 00 	movq   $0x20,0x160(%rsp)
  6cc74e:	00 20 00 00 00 
  6cc753:	48 89 84 24 68 01 00 	mov    %rax,0x168(%rsp)
  6cc75a:	00 
  6cc75b:	e9 c4 fc ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cc760:	49 8b 8c 24 a8 06 00 	mov    0x6a8(%r12),%rcx
  6cc767:	00 
  6cc768:	ba 01 00 00 00       	mov    $0x1,%edx
  6cc76d:	41 0f 10 84 24 78 06 	movups 0x678(%r12),%xmm0
  6cc774:	00 00 
  6cc776:	48 89 94 24 68 01 00 	mov    %rdx,0x168(%rsp)
  6cc77d:	00 
  6cc77e:	48 89 8c 24 70 01 00 	mov    %rcx,0x170(%rsp)
  6cc785:	00 
  6cc786:	0f 11 84 24 78 01 00 	movups %xmm0,0x178(%rsp)
  6cc78d:	00 
  6cc78e:	48 c7 84 24 88 01 00 	movq   $0x0,0x188(%rsp)
  6cc795:	00 00 00 00 00 
  6cc79a:	88 84 24 90 01 00 00 	mov    %al,0x190(%rsp)
  6cc7a1:	8b 44 24 20          	mov    0x20(%rsp),%eax
  6cc7a5:	ff c8                	dec    %eax
  6cc7a7:	0f 85 92 fc ff ff    	jne    6cc43f <property_linked_control[154f7d0d02387650]::main+0x75f>
  6cc7ad:	e9 2e 0b 00 00       	jmp    6cd2e0 <property_linked_control[154f7d0d02387650]::main+0x1600>
  6cc7b2:	48 c7 84 24 60 01 00 	movq   $0x1a,0x160(%rsp)
  6cc7b9:	00 1a 00 00 00 
  6cc7be:	e9 61 fc ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cc7c3:	45 89 ee             	mov    %r13d,%r14d
  6cc7c6:	41 c1 ee 10          	shr    $0x10,%r14d
  6cc7ca:	44 0f b7 c3          	movzwl %bx,%r8d
  6cc7ce:	48 8d 0d 73 20 97 ff 	lea    -0x68df8d(%rip),%rcx        # 3e848 <GCC_except_table0+0x1b8c>
  6cc7d5:	4a 63 04 81          	movslq (%rcx,%r8,4),%rax
  6cc7d9:	48 01 c8             	add    %rcx,%rax
  6cc7dc:	ff e0                	jmp    *%rax
  6cc7de:	0f b7 c6             	movzwl %si,%eax
  6cc7e1:	0d 00 01 00 00       	or     $0x100,%eax
  6cc7e6:	eb 13                	jmp    6cc7fb <property_linked_control[154f7d0d02387650]::main+0xb1b>
  6cc7e8:	0f b7 c7             	movzwl %di,%eax
  6cc7eb:	c1 e0 08             	shl    $0x8,%eax
  6cc7ee:	45 89 f5             	mov    %r14d,%r13d
  6cc7f1:	66 45 39 fd          	cmp    %r15w,%r13w
  6cc7f5:	0f 85 64 03 00 00    	jne    6ccb5f <property_linked_control[154f7d0d02387650]::main+0xe7f>
  6cc7fb:	b1 01                	mov    $0x1,%cl
  6cc7fd:	40 38 c6             	cmp    %al,%sil
  6cc800:	0f 85 5e 03 00 00    	jne    6ccb64 <property_linked_control[154f7d0d02387650]::main+0xe84>
  6cc806:	0f b7 d0             	movzwl %ax,%edx
  6cc809:	c1 ea 08             	shr    $0x8,%edx
  6cc80c:	40 38 d7             	cmp    %dl,%dil
  6cc80f:	0f 85 4f 03 00 00    	jne    6ccb64 <property_linked_control[154f7d0d02387650]::main+0xe84>
  6cc815:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  6cc819:	0f 85 45 03 00 00    	jne    6ccb64 <property_linked_control[154f7d0d02387650]::main+0xe84>
  6cc81f:	e9 8d 01 00 00       	jmp    6cc9b1 <property_linked_control[154f7d0d02387650]::main+0xcd1>
  6cc824:	41 f7 c5 00 00 ff 00 	test   $0xff0000,%r13d
  6cc82b:	0f 84 df 02 00 00    	je     6ccb10 <property_linked_control[154f7d0d02387650]::main+0xe30>
  6cc831:	48 8b 55 00          	mov    0x0(%rbp),%rdx
  6cc835:	48 85 d2             	test   %rdx,%rdx
  6cc838:	0f 84 73 01 00 00    	je     6cc9b1 <property_linked_control[154f7d0d02387650]::main+0xcd1>
  6cc83e:	4d 89 c7             	mov    %r8,%r15
  6cc841:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  6cc846:	48 8b 4d 08          	mov    0x8(%rbp),%rcx
  6cc84a:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cc851:	00 
  6cc852:	4c 89 e6             	mov    %r12,%rsi
  6cc855:	e8 86 79 01 00       	call   6e41e0 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::resolve_index>
  6cc85a:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6cc861:	00 
  6cc862:	48 8b ac 24 58 03 00 	mov    0x358(%rsp),%rbp
  6cc869:	00 
  6cc86a:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6cc86e:	0f 85 77 01 00 00    	jne    6cc9eb <property_linked_control[154f7d0d02387650]::main+0xd0b>
  6cc874:	49 8b 84 24 28 06 00 	mov    0x628(%r12),%rax
  6cc87b:	00 
  6cc87c:	48 85 c0             	test   %rax,%rax
  6cc87f:	0f 84 2a 02 00 00    	je     6ccaaf <property_linked_control[154f7d0d02387650]::main+0xdcf>
  6cc885:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6cc88c:	00 
  6cc88d:	0f 84 1c 02 00 00    	je     6ccaaf <property_linked_control[154f7d0d02387650]::main+0xdcf>
  6cc893:	49 8b 84 24 a0 02 00 	mov    0x2a0(%r12),%rax
  6cc89a:	00 
  6cc89b:	48 83 f8 1c          	cmp    $0x1c,%rax
  6cc89f:	0f 82 0a 02 00 00    	jb     6ccaaf <property_linked_control[154f7d0d02387650]::main+0xdcf>
  6cc8a5:	48 83 fd 02          	cmp    $0x2,%rbp
  6cc8a9:	0f 82 10 06 00 00    	jb     6ccebf <property_linked_control[154f7d0d02387650]::main+0x11df>
  6cc8af:	48 83 c0 e4          	add    $0xffffffffffffffe4,%rax
  6cc8b3:	48 39 c5             	cmp    %rax,%rbp
  6cc8b6:	0f 83 03 06 00 00    	jae    6ccebf <property_linked_control[154f7d0d02387650]::main+0x11df>
  6cc8bc:	66 83 fb 01          	cmp    $0x1,%bx
  6cc8c0:	0f 84 75 06 00 00    	je     6ccf3b <property_linked_control[154f7d0d02387650]::main+0x125b>
  6cc8c6:	41 83 ff 03          	cmp    $0x3,%r15d
  6cc8ca:	0f 85 b1 10 00 00    	jne    6cd981 <property_linked_control[154f7d0d02387650]::main+0x1ca1>
  6cc8d0:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cc8d7:	00 
  6cc8d8:	4c 89 e6             	mov    %r12,%rsi
  6cc8db:	48 89 ea             	mov    %rbp,%rdx
  6cc8de:	44 89 e9             	mov    %r13d,%ecx
  6cc8e1:	e8 2a 37 02 00       	call   6f0010 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::property_value_at>
  6cc8e6:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6cc8ed:	00 
  6cc8ee:	48 8d b4 24 58 03 00 	lea    0x358(%rsp),%rsi
  6cc8f5:	00 
  6cc8f6:	0f 10 06             	movups (%rsi),%xmm0
  6cc8f9:	0f 10 4e 0c          	movups 0xc(%rsi),%xmm1
  6cc8fd:	0f 29 84 24 90 0a 00 	movaps %xmm0,0xa90(%rsp)
  6cc904:	00 
  6cc905:	0f 11 8c 24 9c 0a 00 	movups %xmm1,0xa9c(%rsp)
  6cc90c:	00 
  6cc90d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6cc911:	0f 85 e1 06 00 00    	jne    6ccff8 <property_linked_control[154f7d0d02387650]::main+0x1318>
  6cc917:	0f 28 84 24 90 0a 00 	movaps 0xa90(%rsp),%xmm0
  6cc91e:	00 
  6cc91f:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  6cc924:	0f 10 84 24 9c 0a 00 	movups 0xa9c(%rsp),%xmm0
  6cc92b:	00 
  6cc92c:	0f 11 44 24 7c       	movups %xmm0,0x7c(%rsp)
  6cc931:	41 0f b6 c6          	movzbl %r14b,%eax
  6cc935:	48 8d 0d 1c 1f 97 ff 	lea    -0x68e0e4(%rip),%rcx        # 3e858 <GCC_except_table0+0x1b9c>
  6cc93c:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  6cc940:	48 01 c8             	add    %rcx,%rax
  6cc943:	ff e0                	jmp    *%rax
  6cc945:	44 89 e8             	mov    %r13d,%eax
  6cc948:	25 00 00 ff 00       	and    $0xff0000,%eax
  6cc94d:	31 c9                	xor    %ecx,%ecx
  6cc94f:	3d 00 00 02 00       	cmp    $0x20000,%eax
  6cc954:	0f 94 c1             	sete   %cl
  6cc957:	48 8d 05 e2 1c 97 ff 	lea    -0x68e31e(%rip),%rax        # 3e640 <GCC_except_table0+0x1984>
  6cc95e:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  6cc963:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cc96a:	00 
  6cc96b:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6cc970:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  6cc975:	ff 15 b5 fc 33 00    	call   *0x33fcb5(%rip)        # a0c630 <_DYNAMIC+0x490>
  6cc97b:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6cc982:	00 
  6cc983:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6cc987:	0f 85 dd 07 00 00    	jne    6cd16a <property_linked_control[154f7d0d02387650]::main+0x148a>
  6cc98d:	48 8d 84 24 58 03 00 	lea    0x358(%rsp),%rax
  6cc994:	00 
  6cc995:	0f 10 00             	movups (%rax),%xmm0
  6cc998:	0f 10 48 0c          	movups 0xc(%rax),%xmm1
  6cc99c:	0f 11 8c 24 9c 0a 00 	movups %xmm1,0xa9c(%rsp)
  6cc9a3:	00 
  6cc9a4:	0f 29 84 24 90 0a 00 	movaps %xmm0,0xa90(%rsp)
  6cc9ab:	00 
  6cc9ac:	e9 fe 06 00 00       	jmp    6cd0af <property_linked_control[154f7d0d02387650]::main+0x13cf>
  6cc9b1:	41 0f b6 84 24 34 07 	movzbl 0x734(%r12),%eax
  6cc9b8:	00 00 
  6cc9ba:	49 83 bc 24 98 06 00 	cmpq   $0x0,0x698(%r12)
  6cc9c1:	00 00 
  6cc9c3:	0f 84 9f 00 00 00    	je     6cca68 <property_linked_control[154f7d0d02387650]::main+0xd88>
  6cc9c9:	84 c0                	test   %al,%al
  6cc9cb:	74 0f                	je     6cc9dc <property_linked_control[154f7d0d02387650]::main+0xcfc>
  6cc9cd:	49 83 bc 24 88 05 00 	cmpq   $0xffffffffffffffff,0x588(%r12)
  6cc9d4:	00 ff 
  6cc9d6:	0f 84 8c 00 00 00    	je     6cca68 <property_linked_control[154f7d0d02387650]::main+0xd88>
  6cc9dc:	49 8b 94 24 a8 06 00 	mov    0x6a8(%r12),%rdx
  6cc9e3:	00 
  6cc9e4:	b9 01 00 00 00       	mov    $0x1,%ecx
  6cc9e9:	eb 7f                	jmp    6cca6a <property_linked_control[154f7d0d02387650]::main+0xd8a>
  6cc9eb:	48 8d 94 24 60 03 00 	lea    0x360(%rsp),%rdx
  6cc9f2:	00 
  6cc9f3:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  6cc9f7:	48 8d b4 24 a0 0a 00 	lea    0xaa0(%rsp),%rsi
  6cc9fe:	00 
  6cc9ff:	48 89 4e 20          	mov    %rcx,0x20(%rsi)
  6cca03:	0f 10 02             	movups (%rdx),%xmm0
  6cca06:	0f 10 4a 10          	movups 0x10(%rdx),%xmm1
  6cca0a:	0f 11 4e 10          	movups %xmm1,0x10(%rsi)
  6cca0e:	0f 11 06             	movups %xmm0,(%rsi)
  6cca11:	48 89 84 24 90 0a 00 	mov    %rax,0xa90(%rsp)
  6cca18:	00 
  6cca19:	48 89 ac 24 98 0a 00 	mov    %rbp,0xa98(%rsp)
  6cca20:	00 
  6cca21:	48 83 f8 11          	cmp    $0x11,%rax
  6cca25:	0f 85 90 00 00 00    	jne    6ccabb <property_linked_control[154f7d0d02387650]::main+0xddb>
  6cca2b:	41 0f b6 84 24 34 07 	movzbl 0x734(%r12),%eax
  6cca32:	00 00 
  6cca34:	49 83 bc 24 98 06 00 	cmpq   $0x0,0x698(%r12)
  6cca3b:	00 00 
  6cca3d:	0f 84 a0 04 00 00    	je     6ccee3 <property_linked_control[154f7d0d02387650]::main+0x1203>
  6cca43:	84 c0                	test   %al,%al
  6cca45:	74 0f                	je     6cca56 <property_linked_control[154f7d0d02387650]::main+0xd76>
  6cca47:	49 83 bc 24 88 05 00 	cmpq   $0xffffffffffffffff,0x588(%r12)
  6cca4e:	00 ff 
  6cca50:	0f 84 8d 04 00 00    	je     6ccee3 <property_linked_control[154f7d0d02387650]::main+0x1203>
  6cca56:	49 8b 94 24 a8 06 00 	mov    0x6a8(%r12),%rdx
  6cca5d:	00 
  6cca5e:	b9 01 00 00 00       	mov    $0x1,%ecx
  6cca63:	e9 7d 04 00 00       	jmp    6ccee5 <property_linked_control[154f7d0d02387650]::main+0x1205>
  6cca68:	31 c9                	xor    %ecx,%ecx
  6cca6a:	41 0f 10 84 24 78 06 	movups 0x678(%r12),%xmm0
  6cca71:	00 00 
  6cca73:	48 89 8c 24 68 01 00 	mov    %rcx,0x168(%rsp)
  6cca7a:	00 
  6cca7b:	48 89 94 24 70 01 00 	mov    %rdx,0x170(%rsp)
  6cca82:	00 
  6cca83:	0f 11 84 24 78 01 00 	movups %xmm0,0x178(%rsp)
  6cca8a:	00 
  6cca8b:	48 c7 84 24 88 01 00 	movq   $0x0,0x188(%rsp)
  6cca92:	00 00 00 00 00 
  6cca97:	88 84 24 90 01 00 00 	mov    %al,0x190(%rsp)
  6cca9e:	48 c7 84 24 60 01 00 	movq   $0xfffffffffffffffe,0x160(%rsp)
  6ccaa5:	00 fe ff ff ff 
  6ccaaa:	e9 75 f9 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6ccaaf:	48 c7 84 24 90 0a 00 	movq   $0x1a,0xa90(%rsp)
  6ccab6:	00 1a 00 00 00 
  6ccabb:	48 8b 84 24 c0 0a 00 	mov    0xac0(%rsp),%rax
  6ccac2:	00 
  6ccac3:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  6ccaca:	00 
  6ccacb:	48 8b 84 24 90 0a 00 	mov    0xa90(%rsp),%rax
  6ccad2:	00 
  6ccad3:	48 8b 8c 24 98 0a 00 	mov    0xa98(%rsp),%rcx
  6ccada:	00 
  6ccadb:	0f 10 84 24 a0 0a 00 	movups 0xaa0(%rsp),%xmm0
  6ccae2:	00 
  6ccae3:	0f 10 8c 24 b0 0a 00 	movups 0xab0(%rsp),%xmm1
  6ccaea:	00 
  6ccaeb:	0f 29 8c 24 80 01 00 	movaps %xmm1,0x180(%rsp)
  6ccaf2:	00 
  6ccaf3:	0f 29 84 24 70 01 00 	movaps %xmm0,0x170(%rsp)
  6ccafa:	00 
  6ccafb:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
  6ccb02:	00 
  6ccb03:	48 89 8c 24 68 01 00 	mov    %rcx,0x168(%rsp)
  6ccb0a:	00 
  6ccb0b:	e9 14 f9 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6ccb10:	8d 46 01             	lea    0x1(%rsi),%eax
  6ccb13:	89 44 24 10          	mov    %eax,0x10(%rsp)
  6ccb17:	89 fb                	mov    %edi,%ebx
  6ccb19:	44 89 ef             	mov    %r13d,%edi
  6ccb1c:	49 89 f6             	mov    %rsi,%r14
  6ccb1f:	e8 5c 81 00 00       	call   6d4c80 <<gpui[cf5fdc5b8959fdac]::property::PropertyId>::info>
  6ccb24:	89 df                	mov    %ebx,%edi
  6ccb26:	4c 89 f6             	mov    %r14,%rsi
  6ccb29:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  6ccb2d:	31 c9                	xor    %ecx,%ecx
  6ccb2f:	3c 04                	cmp    $0x4,%al
  6ccb31:	0f 94 c1             	sete   %cl
  6ccb34:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  6ccb37:	ff c1                	inc    %ecx
  6ccb39:	3c 02                	cmp    $0x2,%al
  6ccb3b:	b8 04 00 00 00       	mov    $0x4,%eax
  6ccb40:	0f 44 c8             	cmove  %eax,%ecx
  6ccb43:	0f b6 44 24 10       	movzbl 0x10(%rsp),%eax
  6ccb48:	f6 f1                	div    %cl
  6ccb4a:	0f b6 cc             	movzbl %ah,%ecx
  6ccb4d:	0f b7 c7             	movzwl %di,%eax
  6ccb50:	c1 e0 08             	shl    $0x8,%eax
  6ccb53:	09 c8                	or     %ecx,%eax
  6ccb55:	66 45 39 fd          	cmp    %r15w,%r13w
  6ccb59:	0f 84 9c fc ff ff    	je     6cc7fb <property_linked_control[154f7d0d02387650]::main+0xb1b>
  6ccb5f:	31 c9                	xor    %ecx,%ecx
  6ccb61:	45 89 ef             	mov    %r13d,%r15d
  6ccb64:	49 8b 94 24 78 06 00 	mov    0x678(%r12),%rdx
  6ccb6b:	00 
  6ccb6c:	48 ff c2             	inc    %rdx
  6ccb6f:	0f 84 57 06 00 00    	je     6cd1cc <property_linked_control[154f7d0d02387650]::main+0x14ec>
  6ccb75:	0f b7 c0             	movzwl %ax,%eax
  6ccb78:	66 44 89 7d 10       	mov    %r15w,0x10(%rbp)
  6ccb7d:	88 45 16             	mov    %al,0x16(%rbp)
  6ccb80:	88 65 12             	mov    %ah,0x12(%rbp)
  6ccb83:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  6ccb87:	84 c9                	test   %cl,%cl
  6ccb89:	0f 85 f6 02 00 00    	jne    6cce85 <property_linked_control[154f7d0d02387650]::main+0x11a5>
  6ccb8f:	49 8b 84 24 28 06 00 	mov    0x628(%r12),%rax
  6ccb96:	00 
  6ccb97:	48 85 c0             	test   %rax,%rax
  6ccb9a:	0f 84 b9 0d 00 00    	je     6cd959 <property_linked_control[154f7d0d02387650]::main+0x1c79>
  6ccba0:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6ccba7:	00 
  6ccba8:	0f 84 ab 0d 00 00    	je     6cd959 <property_linked_control[154f7d0d02387650]::main+0x1c79>
  6ccbae:	4d 8b ac 24 a0 02 00 	mov    0x2a0(%r12),%r13
  6ccbb5:	00 
  6ccbb6:	49 83 fd 1c          	cmp    $0x1c,%r13
  6ccbba:	0f 82 99 0d 00 00    	jb     6cd959 <property_linked_control[154f7d0d02387650]::main+0x1c79>
  6ccbc0:	48 89 94 24 e8 00 00 	mov    %rdx,0xe8(%rsp)
  6ccbc7:	00 
  6ccbc8:	41 0f b7 ff          	movzwl %r15w,%edi
  6ccbcc:	48 89 7c 24 60       	mov    %rdi,0x60(%rsp)
  6ccbd1:	ff 15 61 fa 33 00    	call   *0x33fa61(%rip)        # a0c638 <_DYNAMIC+0x498>
  6ccbd7:	49 89 c6             	mov    %rax,%r14
  6ccbda:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  6ccbdf:	4c 89 6c 24 58       	mov    %r13,0x58(%rsp)
  6ccbe4:	49 8d 7d f7          	lea    -0x9(%r13),%rdi
  6ccbe8:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  6ccbef:	00 
  6ccbf0:	48 39 f7             	cmp    %rsi,%rdi
  6ccbf3:	0f 83 51 0d 00 00    	jae    6cd94a <property_linked_control[154f7d0d02387650]::main+0x1c6a>
  6ccbf9:	49 8b 8c 24 98 02 00 	mov    0x298(%r12),%rcx
  6ccc00:	00 
  6ccc01:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  6ccc05:	4c 8d 3c d1          	lea    (%rcx,%rdx,8),%r15
  6ccc09:	4c 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%r13
  6ccc0e:	4d 85 ed             	test   %r13,%r13
  6ccc11:	74 31                	je     6ccc44 <property_linked_control[154f7d0d02387650]::main+0xf64>
  6ccc13:	48 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%rbp
  6ccc18:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6ccc1c:	48 85 c0             	test   %rax,%rax
  6ccc1f:	74 0d                	je     6ccc2e <property_linked_control[154f7d0d02387650]::main+0xf4e>
  6ccc21:	48 8d 1c d1          	lea    (%rcx,%rdx,8),%rbx
  6ccc25:	48 83 c3 08          	add    $0x8,%rbx
  6ccc29:	4c 89 ef             	mov    %r13,%rdi
  6ccc2c:	ff d0                	call   *%rax
  6ccc2e:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6ccc32:	48 85 f6             	test   %rsi,%rsi
  6ccc35:	74 0d                	je     6ccc44 <property_linked_control[154f7d0d02387650]::main+0xf64>
  6ccc37:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6ccc3b:	4c 89 ef             	mov    %r13,%rdi
  6ccc3e:	ff 15 9c f7 33 00    	call   *0x33f79c(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6ccc44:	4d 89 77 08          	mov    %r14,0x8(%r15)
  6ccc48:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6ccc4d:	49 89 47 10          	mov    %rax,0x10(%r15)
  6ccc51:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6ccc56:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  6ccc5c:	ff 15 d6 f9 33 00    	call   *0x33f9d6(%rip)        # a0c638 <_DYNAMIC+0x498>
  6ccc62:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  6ccc67:	49 89 c6             	mov    %rax,%r14
  6ccc6a:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  6ccc6f:	48 8d 79 f9          	lea    -0x7(%rcx),%rdi
  6ccc73:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  6ccc7a:	00 
  6ccc7b:	48 39 f7             	cmp    %rsi,%rdi
  6ccc7e:	0f 83 c6 0c 00 00    	jae    6cd94a <property_linked_control[154f7d0d02387650]::main+0x1c6a>
  6ccc84:	49 8b 8c 24 98 02 00 	mov    0x298(%r12),%rcx
  6ccc8b:	00 
  6ccc8c:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  6ccc90:	4c 8d 3c d1          	lea    (%rcx,%rdx,8),%r15
  6ccc94:	4c 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%r13
  6ccc99:	4d 85 ed             	test   %r13,%r13
  6ccc9c:	74 31                	je     6ccccf <property_linked_control[154f7d0d02387650]::main+0xfef>
  6ccc9e:	48 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%rbp
  6ccca3:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6ccca7:	48 85 c0             	test   %rax,%rax
  6cccaa:	74 0d                	je     6cccb9 <property_linked_control[154f7d0d02387650]::main+0xfd9>
  6cccac:	48 8d 1c d1          	lea    (%rcx,%rdx,8),%rbx
  6cccb0:	48 83 c3 08          	add    $0x8,%rbx
  6cccb4:	4c 89 ef             	mov    %r13,%rdi
  6cccb7:	ff d0                	call   *%rax
  6cccb9:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6cccbd:	48 85 f6             	test   %rsi,%rsi
  6cccc0:	74 0d                	je     6ccccf <property_linked_control[154f7d0d02387650]::main+0xfef>
  6cccc2:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6cccc6:	4c 89 ef             	mov    %r13,%rdi
  6cccc9:	ff 15 11 f7 33 00    	call   *0x33f711(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6ccccf:	4d 89 77 08          	mov    %r14,0x8(%r15)
  6cccd3:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6cccd8:	49 89 47 10          	mov    %rax,0x10(%r15)
  6cccdc:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6ccce1:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  6ccce7:	ff 15 4b f9 33 00    	call   *0x33f94b(%rip)        # a0c638 <_DYNAMIC+0x498>
  6ccced:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  6cccf2:	49 89 c6             	mov    %rax,%r14
  6cccf5:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  6cccfa:	48 8d 79 fa          	lea    -0x6(%rcx),%rdi
  6cccfe:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  6ccd05:	00 
  6ccd06:	48 39 f7             	cmp    %rsi,%rdi
  6ccd09:	0f 83 3b 0c 00 00    	jae    6cd94a <property_linked_control[154f7d0d02387650]::main+0x1c6a>
  6ccd0f:	49 8b 8c 24 98 02 00 	mov    0x298(%r12),%rcx
  6ccd16:	00 
  6ccd17:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  6ccd1b:	4c 8d 3c d1          	lea    (%rcx,%rdx,8),%r15
  6ccd1f:	4c 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%r13
  6ccd24:	4d 85 ed             	test   %r13,%r13
  6ccd27:	74 31                	je     6ccd5a <property_linked_control[154f7d0d02387650]::main+0x107a>
  6ccd29:	48 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%rbp
  6ccd2e:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6ccd32:	48 85 c0             	test   %rax,%rax
  6ccd35:	74 0d                	je     6ccd44 <property_linked_control[154f7d0d02387650]::main+0x1064>
  6ccd37:	48 8d 1c d1          	lea    (%rcx,%rdx,8),%rbx
  6ccd3b:	48 83 c3 08          	add    $0x8,%rbx
  6ccd3f:	4c 89 ef             	mov    %r13,%rdi
  6ccd42:	ff d0                	call   *%rax
  6ccd44:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6ccd48:	48 85 f6             	test   %rsi,%rsi
  6ccd4b:	74 0d                	je     6ccd5a <property_linked_control[154f7d0d02387650]::main+0x107a>
  6ccd4d:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6ccd51:	4c 89 ef             	mov    %r13,%rdi
  6ccd54:	ff 15 86 f6 33 00    	call   *0x33f686(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6ccd5a:	4d 89 77 08          	mov    %r14,0x8(%r15)
  6ccd5e:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6ccd63:	49 89 47 10          	mov    %rax,0x10(%r15)
  6ccd67:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6ccd6c:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  6ccd72:	ff 15 c0 f8 33 00    	call   *0x33f8c0(%rip)        # a0c638 <_DYNAMIC+0x498>
  6ccd78:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  6ccd7d:	49 89 c6             	mov    %rax,%r14
  6ccd80:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  6ccd85:	48 8d 79 fb          	lea    -0x5(%rcx),%rdi
  6ccd89:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  6ccd90:	00 
  6ccd91:	48 39 f7             	cmp    %rsi,%rdi
  6ccd94:	0f 83 b0 0b 00 00    	jae    6cd94a <property_linked_control[154f7d0d02387650]::main+0x1c6a>
  6ccd9a:	49 8b 8c 24 98 02 00 	mov    0x298(%r12),%rcx
  6ccda1:	00 
  6ccda2:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  6ccda6:	4c 8d 3c d1          	lea    (%rcx,%rdx,8),%r15
  6ccdaa:	4c 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%r13
  6ccdaf:	4d 85 ed             	test   %r13,%r13
  6ccdb2:	74 31                	je     6ccde5 <property_linked_control[154f7d0d02387650]::main+0x1105>
  6ccdb4:	48 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%rbp
  6ccdb9:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6ccdbd:	48 85 c0             	test   %rax,%rax
  6ccdc0:	74 0d                	je     6ccdcf <property_linked_control[154f7d0d02387650]::main+0x10ef>
  6ccdc2:	48 8d 1c d1          	lea    (%rcx,%rdx,8),%rbx
  6ccdc6:	48 83 c3 08          	add    $0x8,%rbx
  6ccdca:	4c 89 ef             	mov    %r13,%rdi
  6ccdcd:	ff d0                	call   *%rax
  6ccdcf:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6ccdd3:	48 85 f6             	test   %rsi,%rsi
  6ccdd6:	74 0d                	je     6ccde5 <property_linked_control[154f7d0d02387650]::main+0x1105>
  6ccdd8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6ccddc:	4c 89 ef             	mov    %r13,%rdi
  6ccddf:	ff 15 fb f5 33 00    	call   *0x33f5fb(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6ccde5:	4d 89 77 08          	mov    %r14,0x8(%r15)
  6ccde9:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6ccdee:	49 89 47 10          	mov    %rax,0x10(%r15)
  6ccdf2:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  6ccdf7:	81 cf 00 00 04 00    	or     $0x40000,%edi
  6ccdfd:	ff 15 35 f8 33 00    	call   *0x33f835(%rip)        # a0c638 <_DYNAMIC+0x498>
  6cce03:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  6cce08:	49 89 c6             	mov    %rax,%r14
  6cce0b:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  6cce10:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
  6cce14:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  6cce1b:	00 
  6cce1c:	48 39 f7             	cmp    %rsi,%rdi
  6cce1f:	0f 83 25 0b 00 00    	jae    6cd94a <property_linked_control[154f7d0d02387650]::main+0x1c6a>
  6cce25:	49 8b 8c 24 98 02 00 	mov    0x298(%r12),%rcx
  6cce2c:	00 
  6cce2d:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  6cce31:	4c 8d 3c d1          	lea    (%rcx,%rdx,8),%r15
  6cce35:	4c 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%r13
  6cce3a:	4d 85 ed             	test   %r13,%r13
  6cce3d:	74 31                	je     6cce70 <property_linked_control[154f7d0d02387650]::main+0x1190>
  6cce3f:	48 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%rbp
  6cce44:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6cce48:	48 85 c0             	test   %rax,%rax
  6cce4b:	74 0d                	je     6cce5a <property_linked_control[154f7d0d02387650]::main+0x117a>
  6cce4d:	48 8d 1c d1          	lea    (%rcx,%rdx,8),%rbx
  6cce51:	48 83 c3 08          	add    $0x8,%rbx
  6cce55:	4c 89 ef             	mov    %r13,%rdi
  6cce58:	ff d0                	call   *%rax
  6cce5a:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6cce5e:	48 85 f6             	test   %rsi,%rsi
  6cce61:	74 0d                	je     6cce70 <property_linked_control[154f7d0d02387650]::main+0x1190>
  6cce63:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6cce67:	4c 89 ef             	mov    %r13,%rdi
  6cce6a:	ff 15 70 f5 33 00    	call   *0x33f570(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6cce70:	4d 89 77 08          	mov    %r14,0x8(%r15)
  6cce74:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6cce79:	49 89 47 10          	mov    %rax,0x10(%r15)
  6cce7d:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
  6cce84:	00 
  6cce85:	49 89 94 24 78 06 00 	mov    %rdx,0x678(%r12)
  6cce8c:	00 
  6cce8d:	49 ff 84 24 c8 06 00 	incq   0x6c8(%r12)
  6cce94:	00 
  6cce95:	49 c7 84 24 20 07 00 	movq   $0x0,0x720(%r12)
  6cce9c:	00 00 00 00 00 
  6ccea1:	41 c6 84 24 33 07 00 	movb   $0x1,0x733(%r12)
  6ccea8:	00 01 
  6cceaa:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6cceb1:	00 
  6cceb2:	4c 89 e6             	mov    %r12,%rsi
  6cceb5:	e8 66 2d 02 00       	call   6efc20 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::present>
  6cceba:	e9 65 f5 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6ccebf:	48 c7 84 24 90 0a 00 	movq   $0x11,0xa90(%rsp)
  6ccec6:	00 11 00 00 00 
  6ccecb:	41 0f b6 84 24 34 07 	movzbl 0x734(%r12),%eax
  6cced2:	00 00 
  6cced4:	49 83 bc 24 98 06 00 	cmpq   $0x0,0x698(%r12)
  6ccedb:	00 00 
  6ccedd:	0f 85 60 fb ff ff    	jne    6cca43 <property_linked_control[154f7d0d02387650]::main+0xd63>
  6ccee3:	31 c9                	xor    %ecx,%ecx
  6ccee5:	41 0f 10 84 24 78 06 	movups 0x678(%r12),%xmm0
  6cceec:	00 00 
  6cceee:	49 8b b4 24 20 07 00 	mov    0x720(%r12),%rsi
  6ccef5:	00 
  6ccef6:	48 89 8c 24 68 01 00 	mov    %rcx,0x168(%rsp)
  6ccefd:	00 
  6ccefe:	48 89 94 24 70 01 00 	mov    %rdx,0x170(%rsp)
  6ccf05:	00 
  6ccf06:	0f 11 84 24 78 01 00 	movups %xmm0,0x178(%rsp)
  6ccf0d:	00 
  6ccf0e:	48 89 b4 24 88 01 00 	mov    %rsi,0x188(%rsp)
  6ccf15:	00 
  6ccf16:	88 84 24 90 01 00 00 	mov    %al,0x190(%rsp)
  6ccf1d:	48 c7 84 24 60 01 00 	movq   $0xfffffffffffffffe,0x160(%rsp)
  6ccf24:	00 fe ff ff ff 
  6ccf29:	48 8d bc 24 90 0a 00 	lea    0xa90(%rsp),%rdi
  6ccf30:	00 
  6ccf31:	e8 1a da fe ff       	call   6ba950 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Error>>
  6ccf36:	e9 e9 f4 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6ccf3b:	49 8b 84 24 98 02 00 	mov    0x298(%r12),%rax
  6ccf42:	00 
  6ccf43:	48 8d 0c ad 00 00 00 	lea    0x0(,%rbp,4),%rcx
  6ccf4a:	00 
  6ccf4b:	48 01 e9             	add    %rbp,%rcx
  6ccf4e:	8b 5c c8 18          	mov    0x18(%rax,%rcx,8),%ebx
  6ccf52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  6ccf57:	48 39 c3             	cmp    %rax,%rbx
  6ccf5a:	0f 84 c0 f7 ff ff    	je     6cc720 <property_linked_control[154f7d0d02387650]::main+0xa40>
  6ccf60:	48 c7 84 24 50 03 00 	movq   $0x11,0x350(%rsp)
  6ccf67:	00 11 00 00 00 
  6ccf6c:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6ccf73:	00 
  6ccf74:	e8 d7 d9 fe ff       	call   6ba950 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Error>>
  6ccf79:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  6ccf80:	00 
  6ccf81:	48 39 de             	cmp    %rbx,%rsi
  6ccf84:	0f 86 13 0a 00 00    	jbe    6cd99d <property_linked_control[154f7d0d02387650]::main+0x1cbd>
  6ccf8a:	49 8b 84 24 98 02 00 	mov    0x298(%r12),%rax
  6ccf91:	00 
  6ccf92:	49 8d bc 24 b0 05 00 	lea    0x5b0(%r12),%rdi
  6ccf99:	00 
  6ccf9a:	48 8d 0c 9b          	lea    (%rbx,%rbx,4),%rcx
  6ccf9e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  6ccfa2:	ff 15 70 f6 33 00    	call   *0x33f670(%rip)        # a0c618 <_DYNAMIC+0x478>
  6ccfa8:	48 89 c3             	mov    %rax,%rbx
  6ccfab:	49 89 d6             	mov    %rdx,%r14
  6ccfae:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6ccfb5:	00 
  6ccfb6:	4c 89 e6             	mov    %r12,%rsi
  6ccfb9:	48 89 c2             	mov    %rax,%rdx
  6ccfbc:	4c 89 f1             	mov    %r14,%rcx
  6ccfbf:	e8 0c 91 00 00       	call   6d60d0 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::inspector_app_index>
  6ccfc4:	8b ac 24 50 03 00 00 	mov    0x350(%rsp),%ebp
  6ccfcb:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6ccfd2:	00 
  6ccfd3:	e8 b8 7d fe ff       	call   6b4d90 <core[37f591cfbe66b0b1]::ptr::drop_glue::<core[37f591cfbe66b0b1]::result::Result<gpui[cf5fdc5b8959fdac]::property::PropertyValue, gpui[cf5fdc5b8959fdac]::runtime::Error>>>
  6ccfd8:	83 fd fe             	cmp    $0xfffffffe,%ebp
  6ccfdb:	75 55                	jne    6cd032 <property_linked_control[154f7d0d02387650]::main+0x1352>
  6ccfdd:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6ccfe4:	00 
  6ccfe5:	4c 89 e6             	mov    %r12,%rsi
  6ccfe8:	48 89 da             	mov    %rbx,%rdx
  6ccfeb:	4c 89 f1             	mov    %r14,%rcx
  6ccfee:	e8 fd a4 00 00       	call   6d74f0 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::inspector_select>
  6ccff3:	e9 2c f4 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6ccff8:	8b 4e 2c             	mov    0x2c(%rsi),%ecx
  6ccffb:	48 8d 94 24 68 01 00 	lea    0x168(%rsp),%rdx
  6cd002:	00 
  6cd003:	89 4a 2c             	mov    %ecx,0x2c(%rdx)
  6cd006:	0f 10 46 1c          	movups 0x1c(%rsi),%xmm0
  6cd00a:	0f 11 42 1c          	movups %xmm0,0x1c(%rdx)
  6cd00e:	0f 10 84 24 9c 0a 00 	movups 0xa9c(%rsp),%xmm0
  6cd015:	00 
  6cd016:	0f 11 42 0c          	movups %xmm0,0xc(%rdx)
  6cd01a:	0f 28 84 24 90 0a 00 	movaps 0xa90(%rsp),%xmm0
  6cd021:	00 
  6cd022:	0f 11 02             	movups %xmm0,(%rdx)
  6cd025:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
  6cd02c:	00 
  6cd02d:	e9 f2 f3 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cd032:	41 0f b6 84 24 34 07 	movzbl 0x734(%r12),%eax
  6cd039:	00 00 
  6cd03b:	49 83 bc 24 98 06 00 	cmpq   $0x0,0x698(%r12)
  6cd042:	00 00 
  6cd044:	74 1e                	je     6cd064 <property_linked_control[154f7d0d02387650]::main+0x1384>
  6cd046:	84 c0                	test   %al,%al
  6cd048:	74 0b                	je     6cd055 <property_linked_control[154f7d0d02387650]::main+0x1375>
  6cd04a:	49 83 bc 24 88 05 00 	cmpq   $0xffffffffffffffff,0x588(%r12)
  6cd051:	00 ff 
  6cd053:	74 0f                	je     6cd064 <property_linked_control[154f7d0d02387650]::main+0x1384>
  6cd055:	49 8b 94 24 a8 06 00 	mov    0x6a8(%r12),%rdx
  6cd05c:	00 
  6cd05d:	b9 01 00 00 00       	mov    $0x1,%ecx
  6cd062:	eb 02                	jmp    6cd066 <property_linked_control[154f7d0d02387650]::main+0x1386>
  6cd064:	31 c9                	xor    %ecx,%ecx
  6cd066:	41 0f 10 84 24 78 06 	movups 0x678(%r12),%xmm0
  6cd06d:	00 00 
  6cd06f:	49 8b b4 24 20 07 00 	mov    0x720(%r12),%rsi
  6cd076:	00 
  6cd077:	48 89 8c 24 68 01 00 	mov    %rcx,0x168(%rsp)
  6cd07e:	00 
  6cd07f:	48 89 94 24 70 01 00 	mov    %rdx,0x170(%rsp)
  6cd086:	00 
  6cd087:	0f 11 84 24 78 01 00 	movups %xmm0,0x178(%rsp)
  6cd08e:	00 
  6cd08f:	48 89 b4 24 88 01 00 	mov    %rsi,0x188(%rsp)
  6cd096:	00 
  6cd097:	e9 fb f9 ff ff       	jmp    6cca97 <property_linked_control[154f7d0d02387650]::main+0xdb7>
  6cd09c:	c6 84 24 90 0a 00 00 	movb   $0x0,0xa90(%rsp)
  6cd0a3:	00 
  6cd0a4:	c7 84 24 94 0a 00 00 	movl   $0x0,0xa94(%rsp)
  6cd0ab:	00 00 00 00 
  6cd0af:	44 89 ef             	mov    %r13d,%edi
  6cd0b2:	48 8d b4 24 90 0a 00 	lea    0xa90(%rsp),%rsi
  6cd0b9:	00 
  6cd0ba:	ff 15 80 f5 33 00    	call   *0x33f580(%rip)        # a0c640 <_DYNAMIC+0x4a0>
  6cd0c0:	66 85 c0             	test   %ax,%ax
  6cd0c3:	74 23                	je     6cd0e8 <property_linked_control[154f7d0d02387650]::main+0x1408>
  6cd0c5:	48 c1 e8 10          	shr    $0x10,%rax
  6cd0c9:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6cd0d0:	00 
  6cd0d1:	4c 89 e6             	mov    %r12,%rsi
  6cd0d4:	89 c2                	mov    %eax,%edx
  6cd0d6:	e8 f5 a2 00 00       	call   6d73d0 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::reject_editor>
  6cd0db:	e9 44 f3 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cd0e0:	c6 84 24 90 0a 00 00 	movb   $0xff,0xa90(%rsp)
  6cd0e7:	ff 
  6cd0e8:	49 8b 9c 24 78 06 00 	mov    0x678(%r12),%rbx
  6cd0ef:	00 
  6cd0f0:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  6cd0f4:	0f 84 d2 00 00 00    	je     6cd1cc <property_linked_control[154f7d0d02387650]::main+0x14ec>
  6cd0fa:	48 c7 84 24 50 03 00 	movq   $0x1f,0x350(%rsp)
  6cd101:	00 1f 00 00 00 
  6cd106:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cd10d:	00 
  6cd10e:	e8 3d d8 fe ff       	call   6ba950 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Error>>
  6cd113:	49 8b 84 24 28 06 00 	mov    0x628(%r12),%rax
  6cd11a:	00 
  6cd11b:	48 85 c0             	test   %rax,%rax
  6cd11e:	0f 84 0b 08 00 00    	je     6cd92f <property_linked_control[154f7d0d02387650]::main+0x1c4f>
  6cd124:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  6cd12b:	48 85 c0             	test   %rax,%rax
  6cd12e:	0f 84 fb 07 00 00    	je     6cd92f <property_linked_control[154f7d0d02387650]::main+0x1c4f>
  6cd134:	48 ff c3             	inc    %rbx
  6cd137:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  6cd13b:	48 8d 84 24 90 0a 00 	lea    0xa90(%rsp),%rax
  6cd142:	00 
  6cd143:	48 89 04 24          	mov    %rax,(%rsp)
  6cd147:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6cd14e:	00 
  6cd14f:	4c 89 e6             	mov    %r12,%rsi
  6cd152:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  6cd157:	48 89 e9             	mov    %rbp,%rcx
  6cd15a:	49 89 d8             	mov    %rbx,%r8
  6cd15d:	45 89 e9             	mov    %r13d,%r9d
  6cd160:	e8 9b 32 02 00       	call   6f0400 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::set_property_value_at>
  6cd165:	e9 ba f2 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cd16a:	83 f8 23             	cmp    $0x23,%eax
  6cd16d:	75 18                	jne    6cd187 <property_linked_control[154f7d0d02387650]::main+0x14a7>
  6cd16f:	8b 84 24 58 03 00 00 	mov    0x358(%rsp),%eax
  6cd176:	83 f8 0d             	cmp    $0xd,%eax
  6cd179:	74 62                	je     6cd1dd <property_linked_control[154f7d0d02387650]::main+0x14fd>
  6cd17b:	83 f8 0e             	cmp    $0xe,%eax
  6cd17e:	75 07                	jne    6cd187 <property_linked_control[154f7d0d02387650]::main+0x14a7>
  6cd180:	ba 07 00 00 00       	mov    $0x7,%edx
  6cd185:	eb 5b                	jmp    6cd1e2 <property_linked_control[154f7d0d02387650]::main+0x1502>
  6cd187:	48 8b 84 24 80 03 00 	mov    0x380(%rsp),%rax
  6cd18e:	00 
  6cd18f:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  6cd196:	00 
  6cd197:	0f 10 84 24 50 03 00 	movups 0x350(%rsp),%xmm0
  6cd19e:	00 
  6cd19f:	0f 10 8c 24 60 03 00 	movups 0x360(%rsp),%xmm1
  6cd1a6:	00 
  6cd1a7:	0f 10 94 24 70 03 00 	movups 0x370(%rsp),%xmm2
  6cd1ae:	00 
  6cd1af:	0f 29 94 24 80 01 00 	movaps %xmm2,0x180(%rsp)
  6cd1b6:	00 
  6cd1b7:	0f 29 8c 24 70 01 00 	movaps %xmm1,0x170(%rsp)
  6cd1be:	00 
  6cd1bf:	0f 29 84 24 60 01 00 	movaps %xmm0,0x160(%rsp)
  6cd1c6:	00 
  6cd1c7:	e9 58 f2 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cd1cc:	48 c7 84 24 60 01 00 	movq   $0x1f,0x160(%rsp)
  6cd1d3:	00 1f 00 00 00 
  6cd1d8:	e9 47 f2 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cd1dd:	ba 06 00 00 00       	mov    $0x6,%edx
  6cd1e2:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6cd1e9:	00 
  6cd1ea:	4c 89 e6             	mov    %r12,%rsi
  6cd1ed:	e8 de a1 00 00       	call   6d73d0 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::reject_editor>
  6cd1f2:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cd1f9:	00 
  6cd1fa:	e8 51 d7 fe ff       	call   6ba950 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Error>>
  6cd1ff:	e9 20 f2 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cd204:	48 89 c7             	mov    %rax,%rdi
  6cd207:	ff 15 3b f4 33 00    	call   *0x33f43b(%rip)        # a0c648 <_DYNAMIC+0x4a8>
  6cd20d:	48 89 c5             	mov    %rax,%rbp
  6cd210:	48 89 d3             	mov    %rdx,%rbx
  6cd213:	48 89 84 24 58 03 00 	mov    %rax,0x358(%rsp)
  6cd21a:	00 
  6cd21b:	48 89 94 24 60 03 00 	mov    %rdx,0x360(%rsp)
  6cd222:	00 
  6cd223:	48 c7 84 24 50 03 00 	movq   $0xfffffffffffffffe,0x350(%rsp)
  6cd22a:	00 fe ff ff ff 
  6cd22f:	4c 89 e7             	mov    %r12,%rdi
  6cd232:	e8 d9 28 02 00       	call   6efb10 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::poison>
  6cd237:	48 c7 84 24 60 01 00 	movq   $0xf,0x160(%rsp)
  6cd23e:	00 0f 00 00 00 
  6cd243:	48 8b 03             	mov    (%rbx),%rax
  6cd246:	48 85 c0             	test   %rax,%rax
  6cd249:	74 05                	je     6cd250 <property_linked_control[154f7d0d02387650]::main+0x1570>
  6cd24b:	48 89 ef             	mov    %rbp,%rdi
  6cd24e:	ff d0                	call   *%rax
  6cd250:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6cd254:	48 85 f6             	test   %rsi,%rsi
  6cd257:	0f 84 c7 f1 ff ff    	je     6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cd25d:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6cd261:	48 89 ef             	mov    %rbp,%rdi
  6cd264:	ff 15 76 f1 33 00    	call   *0x33f176(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6cd26a:	e9 b5 f1 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cd26f:	48 89 c7             	mov    %rax,%rdi
  6cd272:	ff 15 d0 f3 33 00    	call   *0x33f3d0(%rip)        # a0c648 <_DYNAMIC+0x4a8>
  6cd278:	49 89 c5             	mov    %rax,%r13
  6cd27b:	49 89 d7             	mov    %rdx,%r15
  6cd27e:	48 89 84 24 58 03 00 	mov    %rax,0x358(%rsp)
  6cd285:	00 
  6cd286:	48 89 94 24 60 03 00 	mov    %rdx,0x360(%rsp)
  6cd28d:	00 
  6cd28e:	48 c7 84 24 50 03 00 	movq   $0xfffffffffffffffe,0x350(%rsp)
  6cd295:	00 fe ff ff ff 
  6cd29a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  6cd2a0:	4c 89 e7             	mov    %r12,%rdi
  6cd2a3:	e8 68 28 02 00       	call   6efb10 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::poison>
  6cd2a8:	48 c7 84 24 60 01 00 	movq   $0xf,0x160(%rsp)
  6cd2af:	00 0f 00 00 00 
  6cd2b4:	49 8b 07             	mov    (%r15),%rax
  6cd2b7:	48 85 c0             	test   %rax,%rax
  6cd2ba:	74 05                	je     6cd2c1 <property_linked_control[154f7d0d02387650]::main+0x15e1>
  6cd2bc:	4c 89 ef             	mov    %r13,%rdi
  6cd2bf:	ff d0                	call   *%rax
  6cd2c1:	49 8b 77 08          	mov    0x8(%r15),%rsi
  6cd2c5:	48 85 f6             	test   %rsi,%rsi
  6cd2c8:	0f 84 56 f1 ff ff    	je     6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cd2ce:	49 8b 57 10          	mov    0x10(%r15),%rdx
  6cd2d2:	4c 89 ef             	mov    %r13,%rdi
  6cd2d5:	ff 15 05 f1 33 00    	call   *0x33f105(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6cd2db:	e9 44 f1 ff ff       	jmp    6cc424 <property_linked_control[154f7d0d02387650]::main+0x744>
  6cd2e0:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  6cd2e5:	48 85 db             	test   %rbx,%rbx
  6cd2e8:	0f 84 43 02 00 00    	je     6cd531 <property_linked_control[154f7d0d02387650]::main+0x1851>
  6cd2ee:	48 83 bb d0 05 00 00 	cmpq   $0x3,0x5d0(%rbx)
  6cd2f5:	03 
  6cd2f6:	0f 85 7a 02 00 00    	jne    6cd576 <property_linked_control[154f7d0d02387650]::main+0x1896>
  6cd2fc:	80 bb 36 07 00 00 00 	cmpb   $0x0,0x736(%rbx)
  6cd303:	0f 85 5b 05 00 00    	jne    6cd864 <property_linked_control[154f7d0d02387650]::main+0x1b84>
  6cd309:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cd310:	00 
  6cd311:	48 89 de             	mov    %rbx,%rsi
  6cd314:	48 8b 94 24 c8 00 00 	mov    0xc8(%rsp),%rdx
  6cd31b:	00 
  6cd31c:	48 8b 8c 24 c0 00 00 	mov    0xc0(%rsp),%rcx
  6cd323:	00 
  6cd324:	e8 b7 6e 01 00       	call   6e41e0 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::resolve_index>
  6cd329:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6cd330:	00 
  6cd331:	48 8b 94 24 58 03 00 	mov    0x358(%rsp),%rdx
  6cd338:	00 
  6cd339:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6cd33d:	0f 85 2f 05 00 00    	jne    6cd872 <property_linked_control[154f7d0d02387650]::main+0x1b92>
  6cd343:	48 8d bc 24 90 0a 00 	lea    0xa90(%rsp),%rdi
  6cd34a:	00 
  6cd34b:	48 89 de             	mov    %rbx,%rsi
  6cd34e:	b9 01 00 00 00       	mov    $0x1,%ecx
  6cd353:	e8 b8 2c 02 00       	call   6f0010 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::property_value_at>
  6cd358:	48 83 bc 24 90 0a 00 	cmpq   $0xfffffffffffffffe,0xa90(%rsp)
  6cd35f:	00 fe 
  6cd361:	0f 85 4b 05 00 00    	jne    6cd8b2 <property_linked_control[154f7d0d02387650]::main+0x1bd2>
  6cd367:	0f 10 84 24 98 0a 00 	movups 0xa98(%rsp),%xmm0
  6cd36e:	00 
  6cd36f:	0f 10 8c 24 a4 0a 00 	movups 0xaa4(%rsp),%xmm1
  6cd376:	00 
  6cd377:	0f 11 8c 24 5c 03 00 	movups %xmm1,0x35c(%rsp)
  6cd37e:	00 
  6cd37f:	0f 29 84 24 50 03 00 	movaps %xmm0,0x350(%rsp)
  6cd386:	00 
  6cd387:	80 bc 24 50 03 00 00 	cmpb   $0x0,0x350(%rsp)
  6cd38e:	00 
  6cd38f:	0f 94 c0             	sete   %al
  6cd392:	8b 8c 24 54 03 00 00 	mov    0x354(%rsp),%ecx
  6cd399:	84 c8                	test   %cl,%al
  6cd39b:	0f 84 fc 01 00 00    	je     6cd59d <property_linked_control[154f7d0d02387650]::main+0x18bd>
  6cd3a1:	f3 0f 10 05 fb fa 96 	movss  -0x690505(%rip),%xmm0        # 3cea4 <GCC_except_table0+0x1e8>
  6cd3a8:	ff 
  6cd3a9:	f3 0f c2 84 24 58 03 	cmpeqss 0x358(%rsp),%xmm0
  6cd3b0:	00 00 00 
  6cd3b3:	66 0f 7e c0          	movd   %xmm0,%eax
  6cd3b7:	83 e0 01             	and    $0x1,%eax
  6cd3ba:	84 c0                	test   %al,%al
  6cd3bc:	0f 84 e5 01 00 00    	je     6cd5a7 <property_linked_control[154f7d0d02387650]::main+0x18c7>
  6cd3c2:	48 8d 3d cb c8 97 ff 	lea    -0x683735(%rip),%rdi        # 49c94 <GCC_except_table0+0xcfd8>
  6cd3c9:	be 27 00 00 00       	mov    $0x27,%esi
  6cd3ce:	ff 15 7c f2 33 00    	call   *0x33f27c(%rip)        # a0c650 <_DYNAMIC+0x4b0>
  6cd3d4:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  6cd3d9:	48 85 db             	test   %rbx,%rbx
  6cd3dc:	74 1b                	je     6cd3f9 <property_linked_control[154f7d0d02387650]::main+0x1719>
  6cd3de:	48 89 df             	mov    %rbx,%rdi
  6cd3e1:	e8 aa 94 fe ff       	call   6b6890 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>>
  6cd3e6:	be 38 07 00 00       	mov    $0x738,%esi
  6cd3eb:	ba 08 00 00 00       	mov    $0x8,%edx
  6cd3f0:	48 89 df             	mov    %rbx,%rdi
  6cd3f3:	ff 15 e7 ef 33 00    	call   *0x33efe7(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6cd3f9:	48 81 c4 28 0d 00 00 	add    $0xd28,%rsp
  6cd400:	5b                   	pop    %rbx
  6cd401:	41 5c                	pop    %r12
  6cd403:	41 5d                	pop    %r13
  6cd405:	41 5e                	pop    %r14
  6cd407:	41 5f                	pop    %r15
  6cd409:	5d                   	pop    %rbp
  6cd40a:	c3                   	ret
  6cd40b:	48 8d 3d 22 f4 97 ff 	lea    -0x680bde(%rip),%rdi        # 4c834 <GCC_except_table0+0xfb78>
  6cd412:	48 8d 15 3f 0a 32 00 	lea    0x320a3f(%rip),%rdx        # 9ede58 <__frame_dummy_init_array_entry+0xe28>
  6cd419:	be 83 00 00 00       	mov    $0x83,%esi
  6cd41e:	ff 15 34 f0 33 00    	call   *0x33f034(%rip)        # a0c458 <_DYNAMIC+0x2b8>
  6cd424:	e9 94 05 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd429:	48 c7 84 24 60 01 00 	movq   $0x1f,0x160(%rsp)
  6cd430:	00 1f 00 00 00 
  6cd435:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  6cd43c:	00 
  6cd43d:	48 89 84 24 80 03 00 	mov    %rax,0x380(%rsp)
  6cd444:	00 
  6cd445:	0f 28 84 24 60 01 00 	movaps 0x160(%rsp),%xmm0
  6cd44c:	00 
  6cd44d:	0f 28 8c 24 70 01 00 	movaps 0x170(%rsp),%xmm1
  6cd454:	00 
  6cd455:	0f 28 94 24 80 01 00 	movaps 0x180(%rsp),%xmm2
  6cd45c:	00 
  6cd45d:	0f 29 94 24 70 03 00 	movaps %xmm2,0x370(%rsp)
  6cd464:	00 
  6cd465:	0f 29 8c 24 60 03 00 	movaps %xmm1,0x360(%rsp)
  6cd46c:	00 
  6cd46d:	0f 29 84 24 50 03 00 	movaps %xmm0,0x350(%rsp)
  6cd474:	00 
  6cd475:	48 8d 3d 34 c8 97 ff 	lea    -0x6837cc(%rip),%rdi        # 49cb0 <GCC_except_table0+0xcff4>
  6cd47c:	48 8d 0d ed 04 32 00 	lea    0x3204ed(%rip),%rcx        # 9ed970 <__frame_dummy_init_array_entry+0x940>
  6cd483:	4c 8d 05 b6 04 32 00 	lea    0x3204b6(%rip),%r8        # 9ed940 <__frame_dummy_init_array_entry+0x910>
  6cd48a:	48 8d 94 24 50 03 00 	lea    0x350(%rsp),%rdx
  6cd491:	00 
  6cd492:	be 2b 00 00 00       	mov    $0x2b,%esi
  6cd497:	ff 15 eb ef 33 00    	call   *0x33efeb(%rip)        # a0c488 <_DYNAMIC+0x2e8>
  6cd49d:	e9 1b 05 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd4a2:	bf 08 00 00 00       	mov    $0x8,%edi
  6cd4a7:	be 38 07 00 00       	mov    $0x738,%esi
  6cd4ac:	ff 15 46 ef 33 00    	call   *0x33ef46(%rip)        # a0c3f8 <_DYNAMIC+0x258>
  6cd4b2:	e9 06 05 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd4b7:	b8 1f 00 00 00       	mov    $0x1f,%eax
  6cd4bc:	48 89 84 24 90 0a 00 	mov    %rax,0xa90(%rsp)
  6cd4c3:	00 
  6cd4c4:	48 8b 84 24 c0 0a 00 	mov    0xac0(%rsp),%rax
  6cd4cb:	00 
  6cd4cc:	48 89 84 24 80 03 00 	mov    %rax,0x380(%rsp)
  6cd4d3:	00 
  6cd4d4:	0f 10 84 24 90 0a 00 	movups 0xa90(%rsp),%xmm0
  6cd4db:	00 
  6cd4dc:	0f 10 8c 24 a0 0a 00 	movups 0xaa0(%rsp),%xmm1
  6cd4e3:	00 
  6cd4e4:	0f 10 94 24 b0 0a 00 	movups 0xab0(%rsp),%xmm2
  6cd4eb:	00 
  6cd4ec:	0f 29 94 24 70 03 00 	movaps %xmm2,0x370(%rsp)
  6cd4f3:	00 
  6cd4f4:	0f 29 8c 24 60 03 00 	movaps %xmm1,0x360(%rsp)
  6cd4fb:	00 
  6cd4fc:	0f 29 84 24 50 03 00 	movaps %xmm0,0x350(%rsp)
  6cd503:	00 
  6cd504:	48 8d 3d a5 c7 97 ff 	lea    -0x68385b(%rip),%rdi        # 49cb0 <GCC_except_table0+0xcff4>
  6cd50b:	48 8d 0d 5e 04 32 00 	lea    0x32045e(%rip),%rcx        # 9ed970 <__frame_dummy_init_array_entry+0x940>
  6cd512:	4c 8d 05 af 03 32 00 	lea    0x3203af(%rip),%r8        # 9ed8c8 <__frame_dummy_init_array_entry+0x898>
  6cd519:	48 8d 94 24 50 03 00 	lea    0x350(%rsp),%rdx
  6cd520:	00 
  6cd521:	be 2b 00 00 00       	mov    $0x2b,%esi
  6cd526:	ff 15 5c ef 33 00    	call   *0x33ef5c(%rip)        # a0c488 <_DYNAMIC+0x2e8>
  6cd52c:	e9 8c 04 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd531:	48 c7 84 24 50 03 00 	movq   $0xd,0x350(%rsp)
  6cd538:	00 0d 00 00 00 
  6cd53d:	48 c7 84 24 58 03 00 	movq   $0x0,0x358(%rsp)
  6cd544:	00 00 00 00 00 
  6cd549:	48 8d 3d 60 c7 97 ff 	lea    -0x6838a0(%rip),%rdi        # 49cb0 <GCC_except_table0+0xcff4>
  6cd550:	48 8d 0d 19 04 32 00 	lea    0x320419(%rip),%rcx        # 9ed970 <__frame_dummy_init_array_entry+0x940>
  6cd557:	4c 8d 05 82 03 32 00 	lea    0x320382(%rip),%r8        # 9ed8e0 <__frame_dummy_init_array_entry+0x8b0>
  6cd55e:	48 8d 94 24 50 03 00 	lea    0x350(%rsp),%rdx
  6cd565:	00 
  6cd566:	be 2b 00 00 00       	mov    $0x2b,%esi
  6cd56b:	ff 15 17 ef 33 00    	call   *0x33ef17(%rip)        # a0c488 <_DYNAMIC+0x2e8>
  6cd571:	e9 47 04 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd576:	48 81 c3 d0 05 00 00 	add    $0x5d0,%rbx
  6cd57d:	48 8d 15 bc 11 97 ff 	lea    -0x68ee44(%rip),%rdx        # 3e740 <GCC_except_table0+0x1a84>
  6cd584:	4c 8d 0d 9d 03 32 00 	lea    0x32039d(%rip),%r9        # 9ed928 <__frame_dummy_init_array_entry+0x8f8>
  6cd58b:	31 ff                	xor    %edi,%edi
  6cd58d:	48 89 de             	mov    %rbx,%rsi
  6cd590:	31 c9                	xor    %ecx,%ecx
  6cd592:	ff 15 c0 f0 33 00    	call   *0x33f0c0(%rip)        # a0c658 <_DYNAMIC+0x4b8>
  6cd598:	e9 20 04 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd59d:	31 c0                	xor    %eax,%eax
  6cd59f:	84 c0                	test   %al,%al
  6cd5a1:	0f 85 1b fe ff ff    	jne    6cd3c2 <property_linked_control[154f7d0d02387650]::main+0x16e2>
  6cd5a7:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cd5ae:	00 
  6cd5af:	e8 27 f8 fe ff       	call   6bcddb <core[37f591cfbe66b0b1]::panicking::assert_failed::<gpui[cf5fdc5b8959fdac]::property::PropertyValue, gpui[cf5fdc5b8959fdac]::property::PropertyValue>>
  6cd5b4:	e9 04 04 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd5b9:	48 8b 8c 24 80 03 00 	mov    0x380(%rsp),%rcx
  6cd5c0:	00 
  6cd5c1:	48 8d 94 24 70 01 00 	lea    0x170(%rsp),%rdx
  6cd5c8:	00 
  6cd5c9:	48 89 4a 20          	mov    %rcx,0x20(%rdx)
  6cd5cd:	0f 10 84 24 60 03 00 	movups 0x360(%rsp),%xmm0
  6cd5d4:	00 
  6cd5d5:	0f 10 8c 24 70 03 00 	movups 0x370(%rsp),%xmm1
  6cd5dc:	00 
  6cd5dd:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  6cd5e1:	0f 11 02             	movups %xmm0,(%rdx)
  6cd5e4:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
  6cd5eb:	00 
  6cd5ec:	48 89 9c 24 68 01 00 	mov    %rbx,0x168(%rsp)
  6cd5f3:	00 
  6cd5f4:	e9 3c fe ff ff       	jmp    6cd435 <property_linked_control[154f7d0d02387650]::main+0x1755>
  6cd5f9:	48 c7 84 24 60 01 00 	movq   $0xd,0x160(%rsp)
  6cd600:	00 0d 00 00 00 
  6cd605:	48 c7 84 24 68 01 00 	movq   $0x0,0x168(%rsp)
  6cd60c:	00 00 00 00 00 
  6cd611:	e9 1f fe ff ff       	jmp    6cd435 <property_linked_control[154f7d0d02387650]::main+0x1755>
  6cd616:	48 c7 84 24 60 01 00 	movq   $0xe,0x160(%rsp)
  6cd61d:	00 0e 00 00 00 
  6cd622:	e9 0e fe ff ff       	jmp    6cd435 <property_linked_control[154f7d0d02387650]::main+0x1755>
  6cd627:	48 c7 84 24 60 01 00 	movq   $0x16,0x160(%rsp)
  6cd62e:	00 16 00 00 00 
  6cd633:	e9 fd fd ff ff       	jmp    6cd435 <property_linked_control[154f7d0d02387650]::main+0x1755>
  6cd638:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
  6cd63d:	0f 10 84 24 80 00 00 	movups 0x80(%rsp),%xmm0
  6cd644:	00 
  6cd645:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6cd64a:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6cd651:	00 
  6cd652:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  6cd657:	0f b6 ac 24 a0 00 00 	movzbl 0xa0(%rsp),%ebp
  6cd65e:	00 
  6cd65f:	8b 84 24 a1 00 00 00 	mov    0xa1(%rsp),%eax
  6cd666:	89 44 24 30          	mov    %eax,0x30(%rsp)
  6cd66a:	8b 84 24 a4 00 00 00 	mov    0xa4(%rsp),%eax
  6cd671:	89 44 24 33          	mov    %eax,0x33(%rsp)
  6cd675:	48 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%rbx
  6cd67c:	00 
  6cd67d:	48 85 db             	test   %rbx,%rbx
  6cd680:	74 1b                	je     6cd69d <property_linked_control[154f7d0d02387650]::main+0x19bd>
  6cd682:	48 89 df             	mov    %rbx,%rdi
  6cd685:	e8 06 92 fe ff       	call   6b6890 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>>
  6cd68a:	be 38 07 00 00       	mov    $0x738,%esi
  6cd68f:	ba 08 00 00 00       	mov    $0x8,%edx
  6cd694:	48 89 df             	mov    %rbx,%rdi
  6cd697:	ff 15 43 ed 33 00    	call   *0x33ed43(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6cd69d:	4d 89 f4             	mov    %r14,%r12
  6cd6a0:	49 c1 ec 20          	shr    $0x20,%r12
  6cd6a4:	eb 5c                	jmp    6cd702 <property_linked_control[154f7d0d02387650]::main+0x1a22>
  6cd6a6:	4c 8b b4 24 58 03 00 	mov    0x358(%rsp),%r14
  6cd6ad:	00 
  6cd6ae:	4d 89 f4             	mov    %r14,%r12
  6cd6b1:	49 c1 ec 20          	shr    $0x20,%r12
  6cd6b5:	0f 10 84 24 60 03 00 	movups 0x360(%rsp),%xmm0
  6cd6bc:	00 
  6cd6bd:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6cd6c2:	0f 10 84 24 70 03 00 	movups 0x370(%rsp),%xmm0
  6cd6c9:	00 
  6cd6ca:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  6cd6cf:	0f b6 ac 24 80 03 00 	movzbl 0x380(%rsp),%ebp
  6cd6d6:	00 
  6cd6d7:	8b 84 24 81 03 00 00 	mov    0x381(%rsp),%eax
  6cd6de:	89 44 24 30          	mov    %eax,0x30(%rsp)
  6cd6e2:	8b 84 24 84 03 00 00 	mov    0x384(%rsp),%eax
  6cd6e9:	89 44 24 33          	mov    %eax,0x33(%rsp)
  6cd6ed:	eb 13                	jmp    6cd702 <property_linked_control[154f7d0d02387650]::main+0x1a22>
  6cd6ef:	48 8d bc 24 f8 00 00 	lea    0xf8(%rsp),%rdi
  6cd6f6:	00 
  6cd6f7:	e8 e4 8f fe ff       	call   6b66e0 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::source::Sources<property_linked_control[154f7d0d02387650]::Model>>>
  6cd6fc:	41 bf 23 00 00 00    	mov    $0x23,%r15d
  6cd702:	4c 89 bc 24 50 03 00 	mov    %r15,0x350(%rsp)
  6cd709:	00 
  6cd70a:	49 c1 e4 20          	shl    $0x20,%r12
  6cd70e:	44 89 f0             	mov    %r14d,%eax
  6cd711:	4c 09 e0             	or     %r12,%rax
  6cd714:	48 89 84 24 58 03 00 	mov    %rax,0x358(%rsp)
  6cd71b:	00 
  6cd71c:	0f 28 44 24 20       	movaps 0x20(%rsp),%xmm0
  6cd721:	0f 11 84 24 60 03 00 	movups %xmm0,0x360(%rsp)
  6cd728:	00 
  6cd729:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  6cd72e:	0f 11 84 24 70 03 00 	movups %xmm0,0x370(%rsp)
  6cd735:	00 
  6cd736:	40 88 ac 24 80 03 00 	mov    %bpl,0x380(%rsp)
  6cd73d:	00 
  6cd73e:	8b 44 24 30          	mov    0x30(%rsp),%eax
  6cd742:	8b 4c 24 33          	mov    0x33(%rsp),%ecx
  6cd746:	89 84 24 81 03 00 00 	mov    %eax,0x381(%rsp)
  6cd74d:	89 8c 24 84 03 00 00 	mov    %ecx,0x384(%rsp)
  6cd754:	48 8d 3d 55 c5 97 ff 	lea    -0x683aab(%rip),%rdi        # 49cb0 <GCC_except_table0+0xcff4>
  6cd75b:	48 8d 0d 0e 02 32 00 	lea    0x32020e(%rip),%rcx        # 9ed970 <__frame_dummy_init_array_entry+0x940>
  6cd762:	4c 8d 05 2f 01 32 00 	lea    0x32012f(%rip),%r8        # 9ed898 <__frame_dummy_init_array_entry+0x868>
  6cd769:	48 8d 94 24 50 03 00 	lea    0x350(%rsp),%rdx
  6cd770:	00 
  6cd771:	be 2b 00 00 00       	mov    $0x2b,%esi
  6cd776:	ff 15 0c ed 33 00    	call   *0x33ed0c(%rip)        # a0c488 <_DYNAMIC+0x2e8>
  6cd77c:	e9 3c 02 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd781:	b8 0d 00 00 00       	mov    $0xd,%eax
  6cd786:	eb 0c                	jmp    6cd794 <property_linked_control[154f7d0d02387650]::main+0x1ab4>
  6cd788:	b8 0e 00 00 00       	mov    $0xe,%eax
  6cd78d:	eb 05                	jmp    6cd794 <property_linked_control[154f7d0d02387650]::main+0x1ab4>
  6cd78f:	b8 12 00 00 00       	mov    $0x12,%eax
  6cd794:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6cd799:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6cd79e:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6cd7a5:	00 
  6cd7a6:	48 c7 84 24 58 03 00 	movq   $0x0,0x358(%rsp)
  6cd7ad:	00 00 00 00 00 
  6cd7b2:	48 8d 3d 8d c4 97 ff 	lea    -0x683b73(%rip),%rdi        # 49c46 <GCC_except_table0+0xcf8a>
  6cd7b9:	48 8d 0d b0 01 32 00 	lea    0x3201b0(%rip),%rcx        # 9ed970 <__frame_dummy_init_array_entry+0x940>
  6cd7c0:	4c 8d 05 e9 00 32 00 	lea    0x3200e9(%rip),%r8        # 9ed8b0 <__frame_dummy_init_array_entry+0x880>
  6cd7c7:	48 8d 94 24 50 03 00 	lea    0x350(%rsp),%rdx
  6cd7ce:	00 
  6cd7cf:	be 2b 00 00 00       	mov    $0x2b,%esi
  6cd7d4:	ff 15 ae ec 33 00    	call   *0x33ecae(%rip)        # a0c488 <_DYNAMIC+0x2e8>
  6cd7da:	e9 de 01 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd7df:	48 c7 84 24 90 0a 00 	movq   $0xd,0xa90(%rsp)
  6cd7e6:	00 0d 00 00 00 
  6cd7eb:	48 c7 84 24 98 0a 00 	movq   $0x0,0xa98(%rsp)
  6cd7f2:	00 00 00 00 00 
  6cd7f7:	e9 c8 fc ff ff       	jmp    6cd4c4 <property_linked_control[154f7d0d02387650]::main+0x17e4>
  6cd7fc:	b8 0e 00 00 00       	mov    $0xe,%eax
  6cd801:	e9 b6 fc ff ff       	jmp    6cd4bc <property_linked_control[154f7d0d02387650]::main+0x17dc>
  6cd806:	b8 0d 00 00 00       	mov    $0xd,%eax
  6cd80b:	eb 0c                	jmp    6cd819 <property_linked_control[154f7d0d02387650]::main+0x1b39>
  6cd80d:	b8 0e 00 00 00       	mov    $0xe,%eax
  6cd812:	eb 05                	jmp    6cd819 <property_linked_control[154f7d0d02387650]::main+0x1b39>
  6cd814:	b8 12 00 00 00       	mov    $0x12,%eax
  6cd819:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6cd81e:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6cd823:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6cd82a:	00 
  6cd82b:	48 c7 84 24 58 03 00 	movq   $0x0,0x358(%rsp)
  6cd832:	00 00 00 00 00 
  6cd837:	48 8d 3d 08 c4 97 ff 	lea    -0x683bf8(%rip),%rdi        # 49c46 <GCC_except_table0+0xcf8a>
  6cd83e:	48 8d 0d 2b 01 32 00 	lea    0x32012b(%rip),%rcx        # 9ed970 <__frame_dummy_init_array_entry+0x940>
  6cd845:	4c 8d 05 64 00 32 00 	lea    0x320064(%rip),%r8        # 9ed8b0 <__frame_dummy_init_array_entry+0x880>
  6cd84c:	48 8d 94 24 50 03 00 	lea    0x350(%rsp),%rdx
  6cd853:	00 
  6cd854:	be 2b 00 00 00       	mov    $0x2b,%esi
  6cd859:	ff 15 29 ec 33 00    	call   *0x33ec29(%rip)        # a0c488 <_DYNAMIC+0x2e8>
  6cd85f:	e9 59 01 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd864:	48 c7 84 24 90 0a 00 	movq   $0xe,0xa90(%rsp)
  6cd86b:	00 0e 00 00 00 
  6cd870:	eb 40                	jmp    6cd8b2 <property_linked_control[154f7d0d02387650]::main+0x1bd2>
  6cd872:	48 8b 8c 24 80 03 00 	mov    0x380(%rsp),%rcx
  6cd879:	00 
  6cd87a:	48 89 8c 24 c0 0a 00 	mov    %rcx,0xac0(%rsp)
  6cd881:	00 
  6cd882:	0f 10 84 24 60 03 00 	movups 0x360(%rsp),%xmm0
  6cd889:	00 
  6cd88a:	0f 10 8c 24 70 03 00 	movups 0x370(%rsp),%xmm1
  6cd891:	00 
  6cd892:	0f 11 8c 24 b0 0a 00 	movups %xmm1,0xab0(%rsp)
  6cd899:	00 
  6cd89a:	0f 11 84 24 a0 0a 00 	movups %xmm0,0xaa0(%rsp)
  6cd8a1:	00 
  6cd8a2:	48 89 84 24 90 0a 00 	mov    %rax,0xa90(%rsp)
  6cd8a9:	00 
  6cd8aa:	48 89 94 24 98 0a 00 	mov    %rdx,0xa98(%rsp)
  6cd8b1:	00 
  6cd8b2:	48 8b 84 24 c0 0a 00 	mov    0xac0(%rsp),%rax
  6cd8b9:	00 
  6cd8ba:	48 89 84 24 80 03 00 	mov    %rax,0x380(%rsp)
  6cd8c1:	00 
  6cd8c2:	48 8b 84 24 90 0a 00 	mov    0xa90(%rsp),%rax
  6cd8c9:	00 
  6cd8ca:	48 8b 8c 24 98 0a 00 	mov    0xa98(%rsp),%rcx
  6cd8d1:	00 
  6cd8d2:	0f 10 84 24 a0 0a 00 	movups 0xaa0(%rsp),%xmm0
  6cd8d9:	00 
  6cd8da:	0f 10 8c 24 b0 0a 00 	movups 0xab0(%rsp),%xmm1
  6cd8e1:	00 
  6cd8e2:	0f 29 8c 24 70 03 00 	movaps %xmm1,0x370(%rsp)
  6cd8e9:	00 
  6cd8ea:	0f 29 84 24 60 03 00 	movaps %xmm0,0x360(%rsp)
  6cd8f1:	00 
  6cd8f2:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6cd8f9:	00 
  6cd8fa:	48 89 8c 24 58 03 00 	mov    %rcx,0x358(%rsp)
  6cd901:	00 
  6cd902:	48 8d 3d a7 c3 97 ff 	lea    -0x683c59(%rip),%rdi        # 49cb0 <GCC_except_table0+0xcff4>
  6cd909:	48 8d 0d 60 00 32 00 	lea    0x320060(%rip),%rcx        # 9ed970 <__frame_dummy_init_array_entry+0x940>
  6cd910:	4c 8d 05 e1 ff 31 00 	lea    0x31ffe1(%rip),%r8        # 9ed8f8 <__frame_dummy_init_array_entry+0x8c8>
  6cd917:	48 8d 94 24 50 03 00 	lea    0x350(%rsp),%rdx
  6cd91e:	00 
  6cd91f:	be 2b 00 00 00       	mov    $0x2b,%esi
  6cd924:	ff 15 5e eb 33 00    	call   *0x33eb5e(%rip)        # a0c488 <_DYNAMIC+0x2e8>
  6cd92a:	e9 8e 00 00 00       	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd92f:	48 8d 3d b8 ed 97 ff 	lea    -0x681248(%rip),%rdi        # 4c6ee <GCC_except_table0+0xfa32>
  6cd936:	48 8d 15 6b 03 32 00 	lea    0x32036b(%rip),%rdx        # 9edca8 <__frame_dummy_init_array_entry+0xc78>
  6cd93d:	be 11 00 00 00       	mov    $0x11,%esi
  6cd942:	ff 15 38 ec 33 00    	call   *0x33ec38(%rip)        # a0c580 <_DYNAMIC+0x3e0>
  6cd948:	eb 73                	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd94a:	48 8d 15 ff 03 32 00 	lea    0x3203ff(%rip),%rdx        # 9edd50 <__frame_dummy_init_array_entry+0xd20>
  6cd951:	ff 15 b9 ea 33 00    	call   *0x33eab9(%rip)        # a0c410 <_DYNAMIC+0x270>
  6cd957:	eb 64                	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd959:	48 8d 05 d8 03 32 00 	lea    0x3203d8(%rip),%rax        # 9edd38 <__frame_dummy_init_array_entry+0xd08>
  6cd960:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  6cd965:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
  6cd96a:	ff 15 08 eb 33 00    	call   *0x33eb08(%rip)        # a0c478 <_DYNAMIC+0x2d8>
  6cd970:	eb 4b                	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd972:	48 8d 05 1f 04 32 00 	lea    0x32041f(%rip),%rax        # 9edd98 <__frame_dummy_init_array_entry+0xd68>
  6cd979:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  6cd980:	00 
  6cd981:	48 8d 3d fd c0 97 ff 	lea    -0x683f03(%rip),%rdi        # 49a85 <GCC_except_table0+0xcdc9>
  6cd988:	be 28 00 00 00       	mov    $0x28,%esi
  6cd98d:	48 8b 94 24 b0 00 00 	mov    0xb0(%rsp),%rdx
  6cd994:	00 
  6cd995:	ff 15 85 ea 33 00    	call   *0x33ea85(%rip)        # a0c420 <_DYNAMIC+0x280>
  6cd99b:	eb 20                	jmp    6cd9bd <property_linked_control[154f7d0d02387650]::main+0x1cdd>
  6cd99d:	48 8d 05 c4 03 32 00 	lea    0x3203c4(%rip),%rax        # 9edd68 <__frame_dummy_init_array_entry+0xd38>
  6cd9a4:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  6cd9ab:	00 
  6cd9ac:	48 89 df             	mov    %rbx,%rdi
  6cd9af:	48 8b 94 24 b8 00 00 	mov    0xb8(%rsp),%rdx
  6cd9b6:	00 
  6cd9b7:	ff 15 53 ea 33 00    	call   *0x33ea53(%rip)        # a0c410 <_DYNAMIC+0x270>
  6cd9bd:	0f 0b                	ud2
  6cd9bf:	ff 15 9b ec 33 00    	call   *0x33ec9b(%rip)        # a0c660 <_DYNAMIC+0x4c0>
  6cd9c5:	ff 15 95 ec 33 00    	call   *0x33ec95(%rip)        # a0c660 <_DYNAMIC+0x4c0>
  6cd9cb:	49 89 c4             	mov    %rax,%r12
  6cd9ce:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cd9d5:	00 
  6cd9d6:	e8 b5 73 fe ff       	call   6b4d90 <core[37f591cfbe66b0b1]::ptr::drop_glue::<core[37f591cfbe66b0b1]::result::Result<gpui[cf5fdc5b8959fdac]::property::PropertyValue, gpui[cf5fdc5b8959fdac]::runtime::Error>>>
  6cd9db:	e9 69 01 00 00       	jmp    6cdb49 <property_linked_control[154f7d0d02387650]::main+0x1e69>
  6cd9e0:	49 89 c4             	mov    %rax,%r12
  6cd9e3:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6cd9e7:	48 85 f6             	test   %rsi,%rsi
  6cd9ea:	74 0d                	je     6cd9f9 <property_linked_control[154f7d0d02387650]::main+0x1d19>
  6cd9ec:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6cd9f0:	4c 89 ef             	mov    %r13,%rdi
  6cd9f3:	ff 15 e7 e9 33 00    	call   *0x33e9e7(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6cd9f9:	4c 89 33             	mov    %r14,(%rbx)
  6cd9fc:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6cda01:	49 89 47 10          	mov    %rax,0x10(%r15)
  6cda05:	e9 3f 01 00 00       	jmp    6cdb49 <property_linked_control[154f7d0d02387650]::main+0x1e69>
  6cda0a:	49 89 c4             	mov    %rax,%r12
  6cda0d:	4c 89 f7             	mov    %r14,%rdi
  6cda10:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  6cda15:	e8 56 60 fe ff       	call   6b3a70 <core[37f591cfbe66b0b1]::ptr::drop_glue::<core[37f591cfbe66b0b1]::option::Option<alloc[24b8200b0946867]::boxed::Box<dyn for<'a, 'b> core[37f591cfbe66b0b1]::ops::function::Fn<(&'a mut gpui[cf5fdc5b8959fdac]::element::El<'b>,), Output = ()>>>>>
  6cda1a:	e9 2a 01 00 00       	jmp    6cdb49 <property_linked_control[154f7d0d02387650]::main+0x1e69>
  6cda1f:	ff 15 e3 e9 33 00    	call   *0x33e9e3(%rip)        # a0c408 <_DYNAMIC+0x268>
  6cda25:	eb 00                	jmp    6cda27 <property_linked_control[154f7d0d02387650]::main+0x1d47>
  6cda27:	49 89 c4             	mov    %rax,%r12
  6cda2a:	be 38 07 00 00       	mov    $0x738,%esi
  6cda2f:	ba 08 00 00 00       	mov    $0x8,%edx
  6cda34:	48 89 df             	mov    %rbx,%rdi
  6cda37:	ff 15 a3 e9 33 00    	call   *0x33e9a3(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6cda3d:	4c 89 e7             	mov    %r12,%rdi
  6cda40:	e8 3b e2 31 00       	call   9ebc80 <_Unwind_Resume@plt>
  6cda45:	49 89 c4             	mov    %rax,%r12
  6cda48:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6cda4c:	48 85 f6             	test   %rsi,%rsi
  6cda4f:	0f 84 f4 00 00 00    	je     6cdb49 <property_linked_control[154f7d0d02387650]::main+0x1e69>
  6cda55:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6cda59:	48 89 ef             	mov    %rbp,%rdi
  6cda5c:	ff 15 7e e9 33 00    	call   *0x33e97e(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6cda62:	e9 e2 00 00 00       	jmp    6cdb49 <property_linked_control[154f7d0d02387650]::main+0x1e69>
  6cda67:	49 89 c4             	mov    %rax,%r12
  6cda6a:	eb 3f                	jmp    6cdaab <property_linked_control[154f7d0d02387650]::main+0x1dcb>
  6cda6c:	49 89 c4             	mov    %rax,%r12
  6cda6f:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cda76:	00 
  6cda77:	e8 84 71 fe ff       	call   6b4c00 <core[37f591cfbe66b0b1]::ptr::drop_glue::<core[37f591cfbe66b0b1]::result::Result<core[37f591cfbe66b0b1]::result::Result<gpui[cf5fdc5b8959fdac]::element::Admission, gpui[cf5fdc5b8959fdac]::source::BindError>, alloc[24b8200b0946867]::boxed::Box<dyn core[37f591cfbe66b0b1]::any::Any + core[37f591cfbe66b0b1]::marker::Send>>>>
  6cda7c:	e9 c8 00 00 00       	jmp    6cdb49 <property_linked_control[154f7d0d02387650]::main+0x1e69>
  6cda81:	e9 ae 00 00 00       	jmp    6cdb34 <property_linked_control[154f7d0d02387650]::main+0x1e54>
  6cda86:	49 89 c4             	mov    %rax,%r12
  6cda89:	48 8b bc 24 d0 00 00 	mov    0xd0(%rsp),%rdi
  6cda90:	00 
  6cda91:	e8 9a 8d fe ff       	call   6b6830 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Win<property_linked_control[154f7d0d02387650]::Model>>>
  6cda96:	e9 b8 00 00 00       	jmp    6cdb53 <property_linked_control[154f7d0d02387650]::main+0x1e73>
  6cda9b:	49 89 c4             	mov    %rax,%r12
  6cda9e:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6cdaa5:	00 
  6cdaa6:	e8 95 c9 fe ff       	call   6ba440 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui_canvas[797cf25614a0c839]::canvas::Canvas>>
  6cdaab:	48 8d bc 24 f8 00 00 	lea    0xf8(%rsp),%rdi
  6cdab2:	00 
  6cdab3:	e8 28 8c fe ff       	call   6b66e0 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::source::Sources<property_linked_control[154f7d0d02387650]::Model>>>
  6cdab8:	e9 96 00 00 00       	jmp    6cdb53 <property_linked_control[154f7d0d02387650]::main+0x1e73>
  6cdabd:	ff 15 45 e9 33 00    	call   *0x33e945(%rip)        # a0c408 <_DYNAMIC+0x268>
  6cdac3:	49 89 c4             	mov    %rax,%r12
  6cdac6:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cdacd:	00 
  6cdace:	e8 7d ce fe ff       	call   6ba950 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Error>>
  6cdad3:	4c 89 e7             	mov    %r12,%rdi
  6cdad6:	e8 a5 e1 31 00       	call   9ebc80 <_Unwind_Resume@plt>
  6cdadb:	49 89 c4             	mov    %rax,%r12
  6cdade:	49 8b 77 08          	mov    0x8(%r15),%rsi
  6cdae2:	48 85 f6             	test   %rsi,%rsi
  6cdae5:	74 62                	je     6cdb49 <property_linked_control[154f7d0d02387650]::main+0x1e69>
  6cdae7:	49 8b 57 10          	mov    0x10(%r15),%rdx
  6cdaeb:	4c 89 ef             	mov    %r13,%rdi
  6cdaee:	ff 15 ec e8 33 00    	call   *0x33e8ec(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6cdaf4:	eb 53                	jmp    6cdb49 <property_linked_control[154f7d0d02387650]::main+0x1e69>
  6cdaf6:	49 89 c4             	mov    %rax,%r12
  6cdaf9:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cdb00:	00 
  6cdb01:	e8 fa 70 fe ff       	call   6b4c00 <core[37f591cfbe66b0b1]::ptr::drop_glue::<core[37f591cfbe66b0b1]::result::Result<core[37f591cfbe66b0b1]::result::Result<gpui[cf5fdc5b8959fdac]::element::Admission, gpui[cf5fdc5b8959fdac]::source::BindError>, alloc[24b8200b0946867]::boxed::Box<dyn core[37f591cfbe66b0b1]::any::Any + core[37f591cfbe66b0b1]::marker::Send>>>>
  6cdb06:	eb 41                	jmp    6cdb49 <property_linked_control[154f7d0d02387650]::main+0x1e69>
  6cdb08:	ff 15 fa e8 33 00    	call   *0x33e8fa(%rip)        # a0c408 <_DYNAMIC+0x268>
  6cdb0e:	eb 36                	jmp    6cdb46 <property_linked_control[154f7d0d02387650]::main+0x1e66>
  6cdb10:	eb 34                	jmp    6cdb46 <property_linked_control[154f7d0d02387650]::main+0x1e66>
  6cdb12:	eb 32                	jmp    6cdb46 <property_linked_control[154f7d0d02387650]::main+0x1e66>
  6cdb14:	eb 1e                	jmp    6cdb34 <property_linked_control[154f7d0d02387650]::main+0x1e54>
  6cdb16:	eb 1c                	jmp    6cdb34 <property_linked_control[154f7d0d02387650]::main+0x1e54>
  6cdb18:	eb 1a                	jmp    6cdb34 <property_linked_control[154f7d0d02387650]::main+0x1e54>
  6cdb1a:	eb 18                	jmp    6cdb34 <property_linked_control[154f7d0d02387650]::main+0x1e54>
  6cdb1c:	49 89 c4             	mov    %rax,%r12
  6cdb1f:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cdb26:	00 
  6cdb27:	e8 64 8d fe ff       	call   6b6890 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>>
  6cdb2c:	eb 25                	jmp    6cdb53 <property_linked_control[154f7d0d02387650]::main+0x1e73>
  6cdb2e:	ff 15 d4 e8 33 00    	call   *0x33e8d4(%rip)        # a0c408 <_DYNAMIC+0x268>
  6cdb34:	49 89 c4             	mov    %rax,%r12
  6cdb37:	48 8d bc 24 50 03 00 	lea    0x350(%rsp),%rdi
  6cdb3e:	00 
  6cdb3f:	e8 0c ce fe ff       	call   6ba950 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Error>>
  6cdb44:	eb 03                	jmp    6cdb49 <property_linked_control[154f7d0d02387650]::main+0x1e69>
  6cdb46:	49 89 c4             	mov    %rax,%r12
  6cdb49:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  6cdb4e:	e8 dd 8c fe ff       	call   6b6830 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Win<property_linked_control[154f7d0d02387650]::Model>>>
  6cdb53:	4c 89 e7             	mov    %r12,%rdi
  6cdb56:	e8 25 e1 31 00       	call   9ebc80 <_Unwind_Resume@plt>
  6cdb5b:	ff 15 a7 e8 33 00    	call   *0x33e8a7(%rip)        # a0c408 <_DYNAMIC+0x268>
  6cdb61:	cc                   	int3
  6cdb62:	cc                   	int3
  6cdb63:	cc                   	int3
  6cdb64:	cc                   	int3
  6cdb65:	cc                   	int3
  6cdb66:	cc                   	int3
  6cdb67:	cc                   	int3
  6cdb68:	cc                   	int3
  6cdb69:	cc                   	int3
  6cdb6a:	cc                   	int3
  6cdb6b:	cc                   	int3
  6cdb6c:	cc                   	int3
  6cdb6d:	cc                   	int3
  6cdb6e:	cc                   	int3
  6cdb6f:	cc                   	int3

00000000006cdb70 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property>:
  6cdb70:	55                   	push   %rbp
  6cdb71:	41 57                	push   %r15
  6cdb73:	41 56                	push   %r14
  6cdb75:	41 55                	push   %r13
  6cdb77:	41 54                	push   %r12
  6cdb79:	53                   	push   %rbx
  6cdb7a:	48 81 ec b8 01 00 00 	sub    $0x1b8,%rsp
  6cdb81:	49 89 d1             	mov    %rdx,%r9
  6cdb84:	49 89 f0             	mov    %rsi,%r8
  6cdb87:	4c 8b 36             	mov    (%rsi),%r14
  6cdb8a:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6cdb91:	48 39 f2             	cmp    %rsi,%rdx
  6cdb94:	0f 83 44 08 00 00    	jae    6ce3de <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x86e>
  6cdb9a:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6cdba1:	4b 8d 2c 89          	lea    (%r9,%r9,4),%rbp
  6cdba5:	48 8b 54 e8 08       	mov    0x8(%rax,%rbp,8),%rdx
  6cdbaa:	48 8b 74 e8 10       	mov    0x10(%rax,%rbp,8),%rsi
  6cdbaf:	48 c7 44 e8 08 00 00 	movq   $0x0,0x8(%rax,%rbp,8)
  6cdbb6:	00 00 
  6cdbb8:	48 85 d2             	test   %rdx,%rdx
  6cdbbb:	0f 84 f1 07 00 00    	je     6ce3b2 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x842>
  6cdbc1:	4c 89 84 24 38 01 00 	mov    %r8,0x138(%rsp)
  6cdbc8:	00 
  6cdbc9:	48 89 8c 24 40 01 00 	mov    %rcx,0x140(%rsp)
  6cdbd0:	00 
  6cdbd1:	48 89 bc 24 b8 00 00 	mov    %rdi,0xb8(%rsp)
  6cdbd8:	00 
  6cdbd9:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  6cdbde:	48 89 94 24 50 01 00 	mov    %rdx,0x150(%rsp)
  6cdbe5:	00 
  6cdbe6:	48 89 74 24 78       	mov    %rsi,0x78(%rsp)
  6cdbeb:	48 89 b4 24 58 01 00 	mov    %rsi,0x158(%rsp)
  6cdbf2:	00 
  6cdbf3:	49 8b 86 78 06 00 00 	mov    0x678(%r14),%rax
  6cdbfa:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  6cdc01:	00 
  6cdc02:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6cdc09:	4c 89 8c 24 c0 00 00 	mov    %r9,0xc0(%rsp)
  6cdc10:	00 
  6cdc11:	49 39 f1             	cmp    %rsi,%r9
  6cdc14:	0f 83 d4 07 00 00    	jae    6ce3ee <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x87e>
  6cdc1a:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6cdc21:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  6cdc28:	48 8b 34 e8          	mov    (%rax,%rbp,8),%rsi
  6cdc2c:	45 31 e4             	xor    %r12d,%r12d
  6cdc2f:	ff 15 e3 e9 33 00    	call   *0x33e9e3(%rip)        # a0c618 <_DYNAMIC+0x478>
  6cdc35:	49 89 d1             	mov    %rdx,%r9
  6cdc38:	49 8d 96 c0 05 00 00 	lea    0x5c0(%r14),%rdx
  6cdc3f:	45 31 e4             	xor    %r12d,%r12d
  6cdc42:	48 8d 0d ff f7 31 00 	lea    0x31f7ff(%rip),%rcx        # 9ed448 <__frame_dummy_init_array_entry+0x418>
  6cdc49:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6cdc4e:	48 8d b4 24 50 01 00 	lea    0x150(%rsp),%rsi
  6cdc55:	00 
  6cdc56:	49 89 c0             	mov    %rax,%r8
  6cdc59:	ff 15 09 ea 33 00    	call   *0x33ea09(%rip)        # a0c668 <_DYNAMIC+0x4c8>
  6cdc5f:	0f b7 5c 24 20       	movzwl 0x20(%rsp),%ebx
  6cdc64:	81 fb fe ff 00 00    	cmp    $0xfffe,%ebx
  6cdc6a:	75 3d                	jne    6cdca9 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x139>
  6cdc6c:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  6cdc71:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6cdc76:	44 0f b7 64 24 38    	movzwl 0x38(%rsp),%r12d
  6cdc7c:	8b 44 24 3a          	mov    0x3a(%rsp),%eax
  6cdc80:	44 0f b7 6c 24 3e    	movzwl 0x3e(%rsp),%r13d
  6cdc86:	49 c1 e5 20          	shl    $0x20,%r13
  6cdc8a:	49 09 c5             	or     %rax,%r13
  6cdc8d:	48 89 d8             	mov    %rbx,%rax
  6cdc90:	48 25 00 ff ff ff    	and    $0xffffffffffffff00,%rax
  6cdc96:	41 bf 20 00 00 00    	mov    $0x20,%r15d
  6cdc9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  6cdca3:	00 
  6cdca4:	e9 63 04 00 00       	jmp    6ce10c <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x59c>
  6cdca9:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  6cdcae:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6cdcb3:	44 0f b6 7c 24 24    	movzbl 0x24(%rsp),%r15d
  6cdcb9:	0f b7 44 24 25       	movzwl 0x25(%rsp),%eax
  6cdcbe:	66 89 44 24 08       	mov    %ax,0x8(%rsp)
  6cdcc3:	0f b6 44 24 27       	movzbl 0x27(%rsp),%eax
  6cdcc8:	88 44 24 0a          	mov    %al,0xa(%rsp)
  6cdccc:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6cdcd1:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  6cdcd6:	0f b7 7c 24 38       	movzwl 0x38(%rsp),%edi
  6cdcdb:	85 db                	test   %ebx,%ebx
  6cdcdd:	74 2b                	je     6cdd0a <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x19a>
  6cdcdf:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  6cdce5:	75 30                	jne    6cdd17 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x1a7>
  6cdce7:	49 c7 86 20 07 00 00 	movq   $0x0,0x720(%r14)
  6cdcee:	00 00 00 00 
  6cdcf2:	49 c7 c7 fe ff ff ff 	mov    $0xfffffffffffffffe,%r15
  6cdcf9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  6cdd00:	00 
  6cdd01:	31 db                	xor    %ebx,%ebx
  6cdd03:	31 c0                	xor    %eax,%eax
  6cdd05:	e9 02 04 00 00       	jmp    6ce10c <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x59c>
  6cdd0a:	41 b7 fe             	mov    $0xfe,%r15b
  6cdd0d:	48 89 c2             	mov    %rax,%rdx
  6cdd10:	48 89 f1             	mov    %rsi,%rcx
  6cdd13:	89 fb                	mov    %edi,%ebx
  6cdd15:	eb 2c                	jmp    6cdd43 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x1d3>
  6cdd17:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6cdd1e:	00 
  6cdd1f:	8b 44 24 3a          	mov    0x3a(%rsp),%eax
  6cdd23:	44 0f b7 6c 24 3e    	movzwl 0x3e(%rsp),%r13d
  6cdd29:	49 c1 e5 20          	shl    $0x20,%r13
  6cdd2d:	49 09 c5             	or     %rax,%r13
  6cdd30:	0f b6 44 24 0a       	movzbl 0xa(%rsp),%eax
  6cdd35:	88 44 24 0e          	mov    %al,0xe(%rsp)
  6cdd39:	0f b7 44 24 08       	movzwl 0x8(%rsp),%eax
  6cdd3e:	66 89 44 24 0c       	mov    %ax,0xc(%rsp)
  6cdd43:	49 8b 86 78 06 00 00 	mov    0x678(%r14),%rax
  6cdd4a:	48 ff c0             	inc    %rax
  6cdd4d:	0f 84 78 06 00 00    	je     6ce3cb <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x85b>
  6cdd53:	66 89 7c 24 60       	mov    %di,0x60(%rsp)
  6cdd58:	48 89 34 24          	mov    %rsi,(%rsp)
  6cdd5c:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  6cdd61:	45 31 e4             	xor    %r12d,%r12d
  6cdd64:	48 8d bc 24 80 01 00 	lea    0x180(%rsp),%rdi
  6cdd6b:	00 
  6cdd6c:	4c 89 f6             	mov    %r14,%rsi
  6cdd6f:	48 89 94 24 28 01 00 	mov    %rdx,0x128(%rsp)
  6cdd76:	00 
  6cdd77:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  6cdd7e:	00 
  6cdd7f:	e8 5c 64 01 00       	call   6e41e0 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::resolve_index>
  6cdd84:	83 bc 24 80 01 00 00 	cmpl   $0xfffffffe,0x180(%rsp)
  6cdd8b:	fe 
  6cdd8c:	75 1b                	jne    6cdda9 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x239>
  6cdd8e:	48 8b 94 24 88 01 00 	mov    0x188(%rsp),%rdx
  6cdd95:	00 
  6cdd96:	41 80 ff fe          	cmp    $0xfe,%r15b
  6cdd9a:	75 55                	jne    6cddf1 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x281>
  6cdd9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  6cdda3:	00 
  6cdda4:	e9 ec 00 00 00       	jmp    6cde95 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x325>
  6cdda9:	0f 10 84 24 80 01 00 	movups 0x180(%rsp),%xmm0
  6cddb0:	00 
  6cddb1:	0f 10 8c 24 90 01 00 	movups 0x190(%rsp),%xmm1
  6cddb8:	00 
  6cddb9:	0f 10 94 24 a0 01 00 	movups 0x1a0(%rsp),%xmm2
  6cddc0:	00 
  6cddc1:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6cddc6:	48 8b 84 24 b0 01 00 	mov    0x1b0(%rsp),%rax
  6cddcd:	00 
  6cddce:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6cddd3:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  6cddd8:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  6cdddd:	66 c7 44 24 58 00 00 	movw   $0x0,0x58(%rsp)
  6cdde4:	45 31 e4             	xor    %r12d,%r12d
  6cdde7:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  6cddec:	e9 fa 01 00 00       	jmp    6cdfeb <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x47b>
  6cddf1:	44 88 bc 24 cc 00 00 	mov    %r15b,0xcc(%rsp)
  6cddf8:	00 
  6cddf9:	0f b7 44 24 0c       	movzwl 0xc(%rsp),%eax
  6cddfe:	66 89 84 24 cd 00 00 	mov    %ax,0xcd(%rsp)
  6cde05:	00 
  6cde06:	0f b6 44 24 0e       	movzbl 0xe(%rsp),%eax
  6cde0b:	88 84 24 cf 00 00 00 	mov    %al,0xcf(%rsp)
  6cde12:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  6cde19:	00 
  6cde1a:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6cde21:	00 
  6cde22:	48 8b 04 24          	mov    (%rsp),%rax
  6cde26:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  6cde2d:	00 
  6cde2e:	0f b7 44 24 60       	movzwl 0x60(%rsp),%eax
  6cde33:	66 89 84 24 e0 00 00 	mov    %ax,0xe0(%rsp)
  6cde3a:	00 
  6cde3b:	44 89 ac 24 e2 00 00 	mov    %r13d,0xe2(%rsp)
  6cde42:	00 
  6cde43:	49 c1 ed 20          	shr    $0x20,%r13
  6cde47:	66 44 89 ac 24 e6 00 	mov    %r13w,0xe6(%rsp)
  6cde4e:	00 00 
  6cde50:	45 31 e4             	xor    %r12d,%r12d
  6cde53:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  6cde5a:	00 
  6cde5b:	4c 8d 84 24 cc 00 00 	lea    0xcc(%rsp),%r8
  6cde62:	00 
  6cde63:	4c 89 f6             	mov    %r14,%rsi
  6cde66:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  6cde6b:	89 d9                	mov    %ebx,%ecx
  6cde6d:	e8 2e 27 02 00       	call   6f05a0 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::apply_property_value_at>
  6cde72:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  6cde79:	00 
  6cde7a:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6cde81:	00 
  6cde82:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6cde86:	0f 85 20 01 00 00    	jne    6cdfac <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x43c>
  6cde8c:	4c 89 2c 24          	mov    %r13,(%rsp)
  6cde90:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  6cde95:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  6cde9c:	00 
  6cde9d:	4c 89 f6             	mov    %r14,%rsi
  6cdea0:	49 89 d5             	mov    %rdx,%r13
  6cdea3:	89 d9                	mov    %ebx,%ecx
  6cdea5:	4c 8b 24 24          	mov    (%rsp),%r12
  6cdea9:	e8 62 21 02 00       	call   6f0010 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::property_value_at>
  6cdeae:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  6cdeb5:	00 
  6cdeb6:	0f 10 84 24 88 00 00 	movups 0x88(%rsp),%xmm0
  6cdebd:	00 
  6cdebe:	0f 29 84 24 60 01 00 	movaps %xmm0,0x160(%rsp)
  6cdec5:	00 
  6cdec6:	0f 10 84 24 94 00 00 	movups 0x94(%rsp),%xmm0
  6cdecd:	00 
  6cdece:	0f 11 84 24 6c 01 00 	movups %xmm0,0x16c(%rsp)
  6cded5:	00 
  6cded6:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6cdeda:	0f 85 85 00 00 00    	jne    6cdf65 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x3f5>
  6cdee0:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6cdee7:	49 39 f5             	cmp    %rsi,%r13
  6cdeea:	0f 83 1b 05 00 00    	jae    6ce40b <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x89b>
  6cdef0:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6cdef7:	4a 8d 0c ad 00 00 00 	lea    0x0(,%r13,4),%rcx
  6cdefe:	00 
  6cdeff:	4c 01 e9             	add    %r13,%rcx
  6cdf02:	48 8b 14 c8          	mov    (%rax,%rcx,8),%rdx
  6cdf06:	48 8d 7c 24 3c       	lea    0x3c(%rsp),%rdi
  6cdf0b:	4c 89 f6             	mov    %r14,%rsi
  6cdf0e:	89 d9                	mov    %ebx,%ecx
  6cdf10:	4c 8b 24 24          	mov    (%rsp),%r12
  6cdf14:	e8 67 23 02 00       	call   6f0280 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::property_contribution_at>
  6cdf19:	0f 10 84 24 6c 01 00 	movups 0x16c(%rsp),%xmm0
  6cdf20:	00 
  6cdf21:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  6cdf26:	0f 11 40 0c          	movups %xmm0,0xc(%rax)
  6cdf2a:	0f 28 84 24 60 01 00 	movaps 0x160(%rsp),%xmm0
  6cdf31:	00 
  6cdf32:	0f 11 00             	movups %xmm0,(%rax)
  6cdf35:	4c 8b bc 24 28 01 00 	mov    0x128(%rsp),%r15
  6cdf3c:	00 
  6cdf3d:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  6cdf42:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
  6cdf49:	00 
  6cdf4a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6cdf4f:	66 89 5c 24 58       	mov    %bx,0x58(%rsp)
  6cdf54:	66 85 db             	test   %bx,%bx
  6cdf57:	74 4d                	je     6cdfa6 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x436>
  6cdf59:	45 31 c0             	xor    %r8d,%r8d
  6cdf5c:	4c 8b 24 24          	mov    (%rsp),%r12
  6cdf60:	e9 ac 00 00 00       	jmp    6ce011 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x4a1>
  6cdf65:	8b 8c 24 b4 00 00 00 	mov    0xb4(%rsp),%ecx
  6cdf6c:	89 4c 24 44          	mov    %ecx,0x44(%rsp)
  6cdf70:	0f 10 84 24 a4 00 00 	movups 0xa4(%rsp),%xmm0
  6cdf77:	00 
  6cdf78:	0f 11 44 24 34       	movups %xmm0,0x34(%rsp)
  6cdf7d:	0f 28 84 24 60 01 00 	movaps 0x160(%rsp),%xmm0
  6cdf84:	00 
  6cdf85:	0f 11 44 24 18       	movups %xmm0,0x18(%rsp)
  6cdf8a:	0f 10 84 24 6c 01 00 	movups 0x16c(%rsp),%xmm0
  6cdf91:	00 
  6cdf92:	0f 11 44 24 24       	movups %xmm0,0x24(%rsp)
  6cdf97:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6cdf9c:	66 c7 44 24 58 00 00 	movw   $0x0,0x58(%rsp)
  6cdfa3:	49 89 c7             	mov    %rax,%r15
  6cdfa6:	4c 8b 24 24          	mov    (%rsp),%r12
  6cdfaa:	eb 3f                	jmp    6cdfeb <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x47b>
  6cdfac:	48 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%rcx
  6cdfb3:	00 
  6cdfb4:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  6cdfb9:	48 89 4a 20          	mov    %rcx,0x20(%rdx)
  6cdfbd:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6cdfc4:	00 
  6cdfc5:	0f 10 8c 24 a0 00 00 	movups 0xa0(%rsp),%xmm1
  6cdfcc:	00 
  6cdfcd:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  6cdfd1:	0f 11 02             	movups %xmm0,(%rdx)
  6cdfd4:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6cdfd9:	4c 89 6c 24 18       	mov    %r13,0x18(%rsp)
  6cdfde:	66 c7 44 24 58 00 00 	movw   $0x0,0x58(%rsp)
  6cdfe5:	45 31 e4             	xor    %r12d,%r12d
  6cdfe8:	49 89 c7             	mov    %rax,%r15
  6cdfeb:	4c 89 f9             	mov    %r15,%rcx
  6cdfee:	48 83 e9 0d          	sub    $0xd,%rcx
  6cdff2:	b8 14 00 00 00       	mov    $0x14,%eax
  6cdff7:	48 0f 4d c1          	cmovge %rcx,%rax
  6cdffb:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  6ce001:	48 83 f8 17          	cmp    $0x17,%rax
  6ce005:	74 0a                	je     6ce011 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x4a1>
  6ce007:	48 83 f8 04          	cmp    $0x4,%rax
  6ce00b:	0f 85 95 00 00 00    	jne    6ce0a6 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x536>
  6ce011:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  6ce016:	49 89 86 78 06 00 00 	mov    %rax,0x678(%r14)
  6ce01d:	49 ff 86 c8 06 00 00 	incq   0x6c8(%r14)
  6ce024:	48 8d 0d 1d f4 31 00 	lea    0x31f41d(%rip),%rcx        # 9ed448 <__frame_dummy_init_array_entry+0x418>
  6ce02b:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  6ce032:	00 
  6ce033:	48 8d b4 24 50 01 00 	lea    0x150(%rsp),%rsi
  6ce03a:	00 
  6ce03b:	4c 8d 4c 24 10       	lea    0x10(%rsp),%r9
  6ce040:	49 8d 96 c0 05 00 00 	lea    0x5c0(%r14),%rdx
  6ce047:	4c 89 24 24          	mov    %r12,(%rsp)
  6ce04b:	ff 15 1f e6 33 00    	call   *0x33e61f(%rip)        # a0c670 <_DYNAMIC+0x4d0>
  6ce051:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
  6ce056:	48 8b 9c 24 80 00 00 	mov    0x80(%rsp),%rbx
  6ce05d:	00 
  6ce05e:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  6ce062:	0f 84 8a 00 00 00    	je     6ce0f2 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x582>
  6ce068:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  6ce06f:	00 
  6ce070:	44 0f b7 a4 24 90 00 	movzwl 0x90(%rsp),%r12d
  6ce077:	00 00 
  6ce079:	8b 84 24 92 00 00 00 	mov    0x92(%rsp),%eax
  6ce080:	44 0f b7 ac 24 96 00 	movzwl 0x96(%rsp),%r13d
  6ce087:	00 00 
  6ce089:	49 c1 e5 20          	shl    $0x20,%r13
  6ce08d:	49 09 c5             	or     %rax,%r13
  6ce090:	41 bf 20 00 00 00    	mov    $0x20,%r15d
  6ce096:	66 83 7c 24 58 00    	cmpw   $0x0,0x58(%rsp)
  6ce09c:	0f 84 0c 02 00 00    	je     6ce2ae <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x73e>
  6ce0a2:	31 c0                	xor    %eax,%eax
  6ce0a4:	eb 66                	jmp    6ce10c <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x59c>
  6ce0a6:	4c 89 24 24          	mov    %r12,(%rsp)
  6ce0aa:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  6ce0af:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  6ce0b4:	48 89 d8             	mov    %rbx,%rax
  6ce0b7:	48 25 00 ff ff ff    	and    $0xffffffffffffff00,%rax
  6ce0bd:	44 0f b7 64 24 28    	movzwl 0x28(%rsp),%r12d
  6ce0c3:	8b 4c 24 2a          	mov    0x2a(%rsp),%ecx
  6ce0c7:	44 0f b7 6c 24 2e    	movzwl 0x2e(%rsp),%r13d
  6ce0cd:	49 c1 e5 20          	shl    $0x20,%r13
  6ce0d1:	49 09 cd             	or     %rcx,%r13
  6ce0d4:	48 8d 4c 24 30       	lea    0x30(%rsp),%rcx
  6ce0d9:	0f 10 01             	movups (%rcx),%xmm0
  6ce0dc:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  6ce0e3:	00 
  6ce0e4:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  6ce0e8:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
  6ce0ef:	00 
  6ce0f0:	eb 1a                	jmp    6ce10c <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x59c>
  6ce0f2:	66 83 7c 24 58 00    	cmpw   $0x0,0x58(%rsp)
  6ce0f8:	0f 84 35 02 00 00    	je     6ce333 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x7c3>
  6ce0fe:	bb 01 00 00 00       	mov    $0x1,%ebx
  6ce103:	49 c7 c7 fe ff ff ff 	mov    $0xfffffffffffffffe,%r15
  6ce10a:	31 c0                	xor    %eax,%eax
  6ce10c:	0f b6 db             	movzbl %bl,%ebx
  6ce10f:	48 09 c3             	or     %rax,%rbx
  6ce112:	41 0f b7 c4          	movzwl %r12w,%eax
  6ce116:	49 c1 e5 10          	shl    $0x10,%r13
  6ce11a:	49 09 c5             	or     %rax,%r13
  6ce11d:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  6ce124:	00 
  6ce125:	0f 11 84 24 08 01 00 	movups %xmm0,0x108(%rsp)
  6ce12c:	00 
  6ce12d:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  6ce134:	00 
  6ce135:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
  6ce13c:	00 
  6ce13d:	4c 89 bc 24 e8 00 00 	mov    %r15,0xe8(%rsp)
  6ce144:	00 
  6ce145:	48 89 9c 24 f0 00 00 	mov    %rbx,0xf0(%rsp)
  6ce14c:	00 
  6ce14d:	48 89 94 24 f8 00 00 	mov    %rdx,0xf8(%rsp)
  6ce154:	00 
  6ce155:	4c 89 ac 24 00 01 00 	mov    %r13,0x100(%rsp)
  6ce15c:	00 
  6ce15d:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6ce164:	48 8b bc 24 c0 00 00 	mov    0xc0(%rsp),%rdi
  6ce16b:	00 
  6ce16c:	48 39 f7             	cmp    %rsi,%rdi
  6ce16f:	0f 83 46 03 00 00    	jae    6ce4bb <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x94b>
  6ce175:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6ce17c:	4c 8d 2c e8          	lea    (%rax,%rbp,8),%r13
  6ce180:	4c 8b 64 e8 08       	mov    0x8(%rax,%rbp,8),%r12
  6ce185:	4d 85 e4             	test   %r12,%r12
  6ce188:	74 29                	je     6ce1b3 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x643>
  6ce18a:	48 8b 6c e8 10       	mov    0x10(%rax,%rbp,8),%rbp
  6ce18f:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6ce193:	48 85 c0             	test   %rax,%rax
  6ce196:	74 05                	je     6ce19d <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x62d>
  6ce198:	4c 89 e7             	mov    %r12,%rdi
  6ce19b:	ff d0                	call   *%rax
  6ce19d:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6ce1a1:	48 85 f6             	test   %rsi,%rsi
  6ce1a4:	74 0d                	je     6ce1b3 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x643>
  6ce1a6:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6ce1aa:	4c 89 e7             	mov    %r12,%rdi
  6ce1ad:	ff 15 2d e2 33 00    	call   *0x33e22d(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6ce1b3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6ce1b8:	49 89 45 08          	mov    %rax,0x8(%r13)
  6ce1bc:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  6ce1c1:	49 89 45 10          	mov    %rax,0x10(%r13)
  6ce1c5:	49 83 ff fd          	cmp    $0xfffffffffffffffd,%r15
  6ce1c9:	74 3a                	je     6ce205 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x695>
  6ce1cb:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  6ce1cf:	4c 8b a4 24 b8 00 00 	mov    0xb8(%rsp),%r12
  6ce1d6:	00 
  6ce1d7:	75 55                	jne    6ce22e <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x6be>
  6ce1d9:	f6 c3 01             	test   $0x1,%bl
  6ce1dc:	0f 84 a0 00 00 00    	je     6ce282 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x712>
  6ce1e2:	4c 89 e7             	mov    %r12,%rdi
  6ce1e5:	48 8b b4 24 38 01 00 	mov    0x138(%rsp),%rsi
  6ce1ec:	00 
  6ce1ed:	31 d2                	xor    %edx,%edx
  6ce1ef:	48 8b 8c 24 40 01 00 	mov    0x140(%rsp),%rcx
  6ce1f6:	00 
  6ce1f7:	4c 8b 04 24          	mov    (%rsp),%r8
  6ce1fb:	e8 20 03 00 00       	call   6ce520 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::after_source_changed>
  6ce200:	e9 1c 01 00 00       	jmp    6ce321 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x7b1>
  6ce205:	4c 89 f7             	mov    %r14,%rdi
  6ce208:	e8 03 19 02 00       	call   6efb10 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::poison>
  6ce20d:	48 8b 84 24 b8 00 00 	mov    0xb8(%rsp),%rax
  6ce214:	00 
  6ce215:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  6ce21c:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  6ce223:	00 
  6ce224:	e8 47 6a fe ff       	call   6b4c70 <core[37f591cfbe66b0b1]::ptr::drop_glue::<core[37f591cfbe66b0b1]::result::Result<core[37f591cfbe66b0b1]::result::Result<gpui[cf5fdc5b8959fdac]::runtime::paint::PatchOutcome, gpui[cf5fdc5b8959fdac]::runtime::Error>, alloc[24b8200b0946867]::boxed::Box<dyn core[37f591cfbe66b0b1]::any::Any + core[37f591cfbe66b0b1]::marker::Send>>>>
  6ce229:	e9 f3 00 00 00       	jmp    6ce321 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x7b1>
  6ce22e:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6ce235:	00 
  6ce236:	49 39 86 78 06 00 00 	cmp    %rax,0x678(%r14)
  6ce23d:	74 08                	je     6ce247 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x6d7>
  6ce23f:	4c 89 f7             	mov    %r14,%rdi
  6ce242:	e8 c9 18 02 00       	call   6efb10 <<gpui[cf5fdc5b8959fdac]::runtime::Runtime<property_linked_control[154f7d0d02387650]::Model>>::poison>
  6ce247:	48 8b 84 24 18 01 00 	mov    0x118(%rsp),%rax
  6ce24e:	00 
  6ce24f:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  6ce254:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  6ce25b:	00 
  6ce25c:	0f 10 8c 24 f8 00 00 	movups 0xf8(%rsp),%xmm1
  6ce263:	00 
  6ce264:	0f 10 94 24 08 01 00 	movups 0x108(%rsp),%xmm2
  6ce26b:	00 
  6ce26c:	41 0f 11 54 24 20    	movups %xmm2,0x20(%r12)
  6ce272:	41 0f 11 4c 24 10    	movups %xmm1,0x10(%r12)
  6ce278:	41 0f 11 04 24       	movups %xmm0,(%r12)
  6ce27d:	e9 9f 00 00 00       	jmp    6ce321 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x7b1>
  6ce282:	41 0f 10 86 78 06 00 	movups 0x678(%r14),%xmm0
  6ce289:	00 
  6ce28a:	41 0f b6 86 34 07 00 	movzbl 0x734(%r14),%eax
  6ce291:	00 
  6ce292:	49 83 be 98 06 00 00 	cmpq   $0x0,0x698(%r14)
  6ce299:	00 
  6ce29a:	74 0e                	je     6ce2aa <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x73a>
  6ce29c:	84 c0                	test   %al,%al
  6ce29e:	74 4c                	je     6ce2ec <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x77c>
  6ce2a0:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6ce2a7:	ff 
  6ce2a8:	75 42                	jne    6ce2ec <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x77c>
  6ce2aa:	31 c9                	xor    %ecx,%ecx
  6ce2ac:	eb 4a                	jmp    6ce2f8 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x788>
  6ce2ae:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  6ce2b3:	48 83 e9 0d          	sub    $0xd,%rcx
  6ce2b7:	b8 14 00 00 00       	mov    $0x14,%eax
  6ce2bc:	48 0f 4d c1          	cmovge %rcx,%rax
  6ce2c0:	48 83 f8 14          	cmp    $0x14,%rax
  6ce2c4:	0f 84 97 00 00 00    	je     6ce361 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x7f1>
  6ce2ca:	48 83 f8 19          	cmp    $0x19,%rax
  6ce2ce:	0f 85 ce fd ff ff    	jne    6ce0a2 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x532>
  6ce2d4:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6ce2d9:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  6ce2de:	48 85 f6             	test   %rsi,%rsi
  6ce2e1:	0f 85 8d 00 00 00    	jne    6ce374 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x804>
  6ce2e7:	e9 b6 fd ff ff       	jmp    6ce0a2 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x532>
  6ce2ec:	49 8b 96 a8 06 00 00 	mov    0x6a8(%r14),%rdx
  6ce2f3:	b9 01 00 00 00       	mov    $0x1,%ecx
  6ce2f8:	49 8b b6 20 07 00 00 	mov    0x720(%r14),%rsi
  6ce2ff:	49 89 4c 24 08       	mov    %rcx,0x8(%r12)
  6ce304:	49 89 54 24 10       	mov    %rdx,0x10(%r12)
  6ce309:	41 0f 11 44 24 18    	movups %xmm0,0x18(%r12)
  6ce30f:	49 89 74 24 28       	mov    %rsi,0x28(%r12)
  6ce314:	41 88 44 24 30       	mov    %al,0x30(%r12)
  6ce319:	49 c7 04 24 fe ff ff 	movq   $0xfffffffffffffffe,(%r12)
  6ce320:	ff 
  6ce321:	48 81 c4 b8 01 00 00 	add    $0x1b8,%rsp
  6ce328:	5b                   	pop    %rbx
  6ce329:	41 5c                	pop    %r12
  6ce32b:	41 5d                	pop    %r13
  6ce32d:	41 5e                	pop    %r14
  6ce32f:	41 5f                	pop    %r15
  6ce331:	5d                   	pop    %rbp
  6ce332:	c3                   	ret
  6ce333:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  6ce338:	48 83 e9 0d          	sub    $0xd,%rcx
  6ce33c:	b8 14 00 00 00       	mov    $0x14,%eax
  6ce341:	48 0f 4d c1          	cmovge %rcx,%rax
  6ce345:	48 83 f8 14          	cmp    $0x14,%rax
  6ce349:	74 46                	je     6ce391 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x821>
  6ce34b:	48 83 f8 19          	cmp    $0x19,%rax
  6ce34f:	0f 85 a9 fd ff ff    	jne    6ce0fe <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x58e>
  6ce355:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6ce35a:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  6ce35f:	eb 35                	jmp    6ce396 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x826>
  6ce361:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  6ce366:	48 85 f6             	test   %rsi,%rsi
  6ce369:	48 8d 44 24 30       	lea    0x30(%rsp),%rax
  6ce36e:	0f 84 2e fd ff ff    	je     6ce0a2 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x532>
  6ce374:	48 8b 38             	mov    (%rax),%rdi
  6ce377:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
  6ce37c:	ba 01 00 00 00       	mov    $0x1,%edx
  6ce381:	ff 15 59 e0 33 00    	call   *0x33e059(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6ce387:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  6ce38c:	e9 11 fd ff ff       	jmp    6ce0a2 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x532>
  6ce391:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  6ce396:	48 85 f6             	test   %rsi,%rsi
  6ce399:	0f 84 5f fd ff ff    	je     6ce0fe <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x58e>
  6ce39f:	48 8b 3a             	mov    (%rdx),%rdi
  6ce3a2:	ba 01 00 00 00       	mov    $0x1,%edx
  6ce3a7:	ff 15 33 e0 33 00    	call   *0x33e033(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6ce3ad:	e9 4c fd ff ff       	jmp    6ce0fe <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x58e>
  6ce3b2:	48 8d 3d 5e b9 97 ff 	lea    -0x6846a2(%rip),%rdi        # 49d17 <GCC_except_table0+0xd05b>
  6ce3b9:	48 8d 15 40 f6 31 00 	lea    0x31f640(%rip),%rdx        # 9eda00 <__frame_dummy_init_array_entry+0x9d0>
  6ce3c0:	be 0e 00 00 00       	mov    $0xe,%esi
  6ce3c5:	ff 15 b5 e1 33 00    	call   *0x33e1b5(%rip)        # a0c580 <_DYNAMIC+0x3e0>
  6ce3cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  6ce3d2:	00 
  6ce3d3:	41 bf 1f 00 00 00    	mov    $0x1f,%r15d
  6ce3d9:	e9 23 f9 ff ff       	jmp    6cdd01 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x191>
  6ce3de:	48 8d 15 03 f6 31 00 	lea    0x31f603(%rip),%rdx        # 9ed9e8 <__frame_dummy_init_array_entry+0x9b8>
  6ce3e5:	4c 89 cf             	mov    %r9,%rdi
  6ce3e8:	ff 15 22 e0 33 00    	call   *0x33e022(%rip)        # a0c410 <_DYNAMIC+0x270>
  6ce3ee:	45 31 e4             	xor    %r12d,%r12d
  6ce3f1:	48 8d 15 38 f0 31 00 	lea    0x31f038(%rip),%rdx        # 9ed430 <__frame_dummy_init_array_entry+0x400>
  6ce3f8:	48 8b bc 24 c0 00 00 	mov    0xc0(%rsp),%rdi
  6ce3ff:	00 
  6ce400:	ff 15 0a e0 33 00    	call   *0x33e00a(%rip)        # a0c410 <_DYNAMIC+0x270>
  6ce406:	e9 bd 00 00 00       	jmp    6ce4c8 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x958>
  6ce40b:	48 8d 15 ee ef 31 00 	lea    0x31efee(%rip),%rdx        # 9ed400 <__frame_dummy_init_array_entry+0x3d0>
  6ce412:	4c 89 ef             	mov    %r13,%rdi
  6ce415:	4c 8b 24 24          	mov    (%rsp),%r12
  6ce419:	ff 15 f1 df 33 00    	call   *0x33dff1(%rip)        # a0c410 <_DYNAMIC+0x270>
  6ce41f:	e9 a4 00 00 00       	jmp    6ce4c8 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x958>
  6ce424:	48 89 c3             	mov    %rax,%rbx
  6ce427:	e9 c2 00 00 00       	jmp    6ce4ee <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x97e>
  6ce42c:	48 89 c3             	mov    %rax,%rbx
  6ce42f:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6ce434:	e8 f7 68 fe ff       	call   6b4d30 <core[37f591cfbe66b0b1]::ptr::drop_glue::<core[37f591cfbe66b0b1]::result::Result<gpui[cf5fdc5b8959fdac]::element::PropertyState, gpui[cf5fdc5b8959fdac]::runtime::Error>>>
  6ce439:	eb 39                	jmp    6ce474 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x904>
  6ce43b:	48 89 c3             	mov    %rax,%rbx
  6ce43e:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6ce442:	48 85 f6             	test   %rsi,%rsi
  6ce445:	74 0d                	je     6ce454 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x8e4>
  6ce447:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6ce44b:	4c 89 e7             	mov    %r12,%rdi
  6ce44e:	ff 15 8c df 33 00    	call   *0x33df8c(%rip)        # a0c3e0 <_DYNAMIC+0x240>
  6ce454:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6ce459:	49 89 45 08          	mov    %rax,0x8(%r13)
  6ce45d:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  6ce462:	49 89 45 10          	mov    %rax,0x10(%r13)
  6ce466:	eb 7a                	jmp    6ce4e2 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x972>
  6ce468:	48 89 c3             	mov    %rax,%rbx
  6ce46b:	eb 75                	jmp    6ce4e2 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x972>
  6ce46d:	4c 89 24 24          	mov    %r12,(%rsp)
  6ce471:	48 89 c3             	mov    %rax,%rbx
  6ce474:	48 89 df             	mov    %rbx,%rdi
  6ce477:	ff 15 cb e1 33 00    	call   *0x33e1cb(%rip)        # a0c648 <_DYNAMIC+0x4a8>
  6ce47d:	48 89 c3             	mov    %rax,%rbx
  6ce480:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
  6ce487:	00 
  6ce488:	48 89 94 24 f8 00 00 	mov    %rdx,0xf8(%rsp)
  6ce48f:	00 
  6ce490:	48 c7 84 24 e8 00 00 	movq   $0xfffffffffffffffd,0xe8(%rsp)
  6ce497:	00 fd ff ff ff 
  6ce49c:	49 c7 c7 fd ff ff ff 	mov    $0xfffffffffffffffd,%r15
  6ce4a3:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6ce4aa:	48 8b bc 24 c0 00 00 	mov    0xc0(%rsp),%rdi
  6ce4b1:	00 
  6ce4b2:	48 39 f7             	cmp    %rsi,%rdi
  6ce4b5:	0f 82 ba fc ff ff    	jb     6ce175 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x605>
  6ce4bb:	48 8d 15 56 f5 31 00 	lea    0x31f556(%rip),%rdx        # 9eda18 <__frame_dummy_init_array_entry+0x9e8>
  6ce4c2:	ff 15 48 df 33 00    	call   *0x33df48(%rip)        # a0c410 <_DYNAMIC+0x270>
  6ce4c8:	0f 0b                	ud2
  6ce4ca:	ff 15 90 e1 33 00    	call   *0x33e190(%rip)        # a0c660 <_DYNAMIC+0x4c0>
  6ce4d0:	48 89 c3             	mov    %rax,%rbx
  6ce4d3:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  6ce4d8:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  6ce4dd:	e8 8e 55 fe ff       	call   6b3a70 <core[37f591cfbe66b0b1]::ptr::drop_glue::<core[37f591cfbe66b0b1]::option::Option<alloc[24b8200b0946867]::boxed::Box<dyn for<'a, 'b> core[37f591cfbe66b0b1]::ops::function::Fn<(&'a mut gpui[cf5fdc5b8959fdac]::element::El<'b>,), Output = ()>>>>>
  6ce4e2:	49 83 ff fd          	cmp    $0xfffffffffffffffd,%r15
  6ce4e6:	74 1b                	je     6ce503 <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x993>
  6ce4e8:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  6ce4ec:	74 0d                	je     6ce4fb <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x98b>
  6ce4ee:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  6ce4f5:	00 
  6ce4f6:	e8 55 c4 fe ff       	call   6ba950 <core[37f591cfbe66b0b1]::ptr::drop_glue::<gpui[cf5fdc5b8959fdac]::runtime::Error>>
  6ce4fb:	48 89 df             	mov    %rbx,%rdi
  6ce4fe:	e8 7d d7 31 00       	call   9ebc80 <_Unwind_Resume@plt>
  6ce503:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  6ce50a:	00 
  6ce50b:	e8 60 67 fe ff       	call   6b4c70 <core[37f591cfbe66b0b1]::ptr::drop_glue::<core[37f591cfbe66b0b1]::result::Result<core[37f591cfbe66b0b1]::result::Result<gpui[cf5fdc5b8959fdac]::runtime::paint::PatchOutcome, gpui[cf5fdc5b8959fdac]::runtime::Error>, alloc[24b8200b0946867]::boxed::Box<dyn core[37f591cfbe66b0b1]::any::Any + core[37f591cfbe66b0b1]::marker::Send>>>>
  6ce510:	eb e9                	jmp    6ce4fb <<gpui[cf5fdc5b8959fdac]::runtime::RuntimeMut<property_linked_control[154f7d0d02387650]::Model, ()>>::activate_property+0x98b>
  6ce512:	ff 15 f0 de 33 00    	call   *0x33def0(%rip)        # a0c408 <_DYNAMIC+0x268>
  6ce518:	cc                   	int3
  6ce519:	cc                   	int3
  6ce51a:	cc                   	int3
  6ce51b:	cc                   	int3
  6ce51c:	cc                   	int3
  6ce51d:	cc                   	int3
  6ce51e:	cc                   	int3
  6ce51f:	cc                   	int3


/tmp/gpui-caret-transaction-bin/62e-native-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007fac60 <<parley::layout::run::Clusters<()>>::advance_cursor>:
  7fac60:	55                   	push   %rbp
  7fac61:	41 57                	push   %r15
  7fac63:	41 56                	push   %r14
  7fac65:	41 55                	push   %r13
  7fac67:	41 54                	push   %r12
  7fac69:	53                   	push   %rbx
  7fac6a:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  7fac71:	49 89 f6             	mov    %rsi,%r14
  7fac74:	49 89 fd             	mov    %rdi,%r13
  7fac77:	80 be 08 01 00 00 00 	cmpb   $0x0,0x108(%rsi)
  7fac7e:	0f 84 b4 01 00 00    	je     7fae38 <<parley::layout::run::Clusters<()>>::advance_cursor+0x1d8>
  7fac84:	45 8b 8e a0 00 00 00 	mov    0xa0(%r14),%r9d
  7fac8b:	45 8b 96 a4 00 00 00 	mov    0xa4(%r14),%r10d
  7fac92:	31 c0                	xor    %eax,%eax
  7fac94:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  7fac9a:	45 39 d1             	cmp    %r10d,%r9d
  7fac9d:	74 2c                	je     7faccb <<parley::layout::run::Clusters<()>>::advance_cursor+0x6b>
  7fac9f:	49 8b b6 88 00 00 00 	mov    0x88(%r14),%rsi
  7faca6:	4c 39 ce             	cmp    %r9,%rsi
  7faca9:	0f 86 39 05 00 00    	jbe    7fb1e8 <<parley::layout::run::Clusters<()>>::advance_cursor+0x588>
  7facaf:	49 8d 7a ff          	lea    -0x1(%r10),%rdi
  7facb3:	48 39 f7             	cmp    %rsi,%rdi
  7facb6:	0f 83 3c 05 00 00    	jae    7fb1f8 <<parley::layout::run::Clusters<()>>::advance_cursor+0x598>
  7facbc:	49 8b 8e 80 00 00 00 	mov    0x80(%r14),%rcx
  7facc3:	4b 8d 14 49          	lea    (%r9,%r9,2),%rdx
  7facc7:	44 8b 1c d1          	mov    (%rcx,%rdx,8),%r11d
  7faccb:	41 8b 8e a8 00 00 00 	mov    0xa8(%r14),%ecx
  7facd2:	44 39 d9             	cmp    %r11d,%ecx
  7facd5:	0f 84 bb 04 00 00    	je     7fb196 <<parley::layout::run::Clusters<()>>::advance_cursor+0x536>
  7facdb:	45 8b a6 ac 00 00 00 	mov    0xac(%r14),%r12d
  7face2:	49 8b b6 88 00 00 00 	mov    0x88(%r14),%rsi
  7face9:	4c 39 e6             	cmp    %r12,%rsi
  7facec:	0f 86 13 05 00 00    	jbe    7fb205 <<parley::layout::run::Clusters<()>>::advance_cursor+0x5a5>
  7facf2:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  7facf9:	00 
  7facfa:	44 8d 79 ff          	lea    -0x1(%rcx),%r15d
  7facfe:	49 8b 96 80 00 00 00 	mov    0x80(%r14),%rdx
  7fad05:	4b 8d 04 64          	lea    (%r12,%r12,2),%rax
  7fad09:	44 3b 3c c2          	cmp    (%rdx,%rax,8),%r15d
  7fad0d:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  7fad12:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  7fad17:	73 7d                	jae    7fad96 <<parley::layout::run::Clusters<()>>::advance_cursor+0x136>
  7fad19:	41 ff cc             	dec    %r12d
  7fad1c:	45 89 a6 ac 00 00 00 	mov    %r12d,0xac(%r14)
  7fad23:	0f 57 c0             	xorps  %xmm0,%xmm0
  7fad26:	45 39 d1             	cmp    %r10d,%r9d
  7fad29:	74 62                	je     7fad8d <<parley::layout::run::Clusters<()>>::advance_cursor+0x12d>
  7fad2b:	4c 89 54 24 18       	mov    %r10,0x18(%rsp)
  7fad30:	4c 39 e6             	cmp    %r12,%rsi
  7fad33:	0f 86 00 02 00 00    	jbe    7faf39 <<parley::layout::run::Clusters<()>>::advance_cursor+0x2d9>
  7fad39:	4c 89 cd             	mov    %r9,%rbp
  7fad3c:	44 89 db             	mov    %r11d,%ebx
  7fad3f:	4b 8d 04 64          	lea    (%r12,%r12,2),%rax
  7fad43:	48 8d 3c c2          	lea    (%rdx,%rax,8),%rdi
  7fad47:	f3 0f 10 44 c2 10    	movss  0x10(%rdx,%rax,8),%xmm0
  7fad4d:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  7fad53:	49 8b 76 70          	mov    0x70(%r14),%rsi
  7fad57:	49 8b 56 78          	mov    0x78(%r14),%rdx
  7fad5b:	ff 15 67 37 33 00    	call   *0x333767(%rip)        # b2e4c8 <_DYNAMIC+0xfc8>
  7fad61:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  7fad66:	89 c0                	mov    %eax,%eax
  7fad68:	0f 57 c0             	xorps  %xmm0,%xmm0
  7fad6b:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  7fad70:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  7fad76:	f3 0f 5e c8          	divss  %xmm0,%xmm1
  7fad7a:	0f 28 c1             	movaps %xmm1,%xmm0
  7fad7d:	41 89 db             	mov    %ebx,%r11d
  7fad80:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7fad85:	49 89 e9             	mov    %rbp,%r9
  7fad88:	4c 8b 54 24 18       	mov    0x18(%rsp),%r10
  7fad8d:	f3 41 0f 11 86 b0 00 	movss  %xmm0,0xb0(%r14)
  7fad94:	00 00 
  7fad96:	4c 39 e6             	cmp    %r12,%rsi
  7fad99:	0f 86 76 04 00 00    	jbe    7fb215 <<parley::layout::run::Clusters<()>>::advance_cursor+0x5b5>
  7fad9f:	4b 8d 04 64          	lea    (%r12,%r12,2),%rax
  7fada3:	44 8b 44 c2 04       	mov    0x4(%rdx,%rax,8),%r8d
  7fada8:	f3 41 0f 10 a6 b0 00 	movss  0xb0(%r14),%xmm4
  7fadaf:	00 00 
  7fadb1:	45 39 df             	cmp    %r11d,%r15d
  7fadb4:	0f 86 a5 01 00 00    	jbe    7faf5f <<parley::layout::run::Clusters<()>>::advance_cursor+0x2ff>
  7fadba:	44 89 44 24 08       	mov    %r8d,0x8(%rsp)
  7fadbf:	4c 89 6c 24 20       	mov    %r13,0x20(%rsp)
  7fadc4:	49 8b 6e 70          	mov    0x70(%r14),%rbp
  7fadc8:	4d 8b 6e 78          	mov    0x78(%r14),%r13
  7fadcc:	45 39 d1             	cmp    %r10d,%r9d
  7fadcf:	0f 85 1b 01 00 00    	jne    7faef0 <<parley::layout::run::Clusters<()>>::advance_cursor+0x290>
  7fadd5:	0f 57 c0             	xorps  %xmm0,%xmm0
  7fadd8:	eb 0f                	jmp    7fade9 <<parley::layout::run::Clusters<()>>::advance_cursor+0x189>
  7fadda:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  7fade0:	45 39 df             	cmp    %r11d,%r15d
  7fade3:	0f 86 a0 01 00 00    	jbe    7faf89 <<parley::layout::run::Clusters<()>>::advance_cursor+0x329>
  7fade9:	44 89 ff             	mov    %r15d,%edi
  7fadec:	49 39 fd             	cmp    %rdi,%r13
  7fadef:	0f 86 b7 03 00 00    	jbe    7fb1ac <<parley::layout::run::Clusters<()>>::advance_cursor+0x54c>
  7fadf5:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  7fadf9:	80 7c 85 08 00       	cmpb   $0x0,0x8(%rbp,%rax,4)
  7fadfe:	0f 85 51 01 00 00    	jne    7faf55 <<parley::layout::run::Clusters<()>>::advance_cursor+0x2f5>
  7fae04:	44 89 e7             	mov    %r12d,%edi
  7fae07:	48 39 fe             	cmp    %rdi,%rsi
  7fae0a:	0f 86 ac 03 00 00    	jbe    7fb1bc <<parley::layout::run::Clusters<()>>::advance_cursor+0x55c>
  7fae10:	41 ff cf             	dec    %r15d
  7fae13:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  7fae17:	44 3b 3c c2          	cmp    (%rdx,%rax,8),%r15d
  7fae1b:	73 c3                	jae    7fade0 <<parley::layout::run::Clusters<()>>::advance_cursor+0x180>
  7fae1d:	41 ff cc             	dec    %r12d
  7fae20:	45 89 a6 ac 00 00 00 	mov    %r12d,0xac(%r14)
  7fae27:	41 c7 86 b0 00 00 00 	movl   $0x0,0xb0(%r14)
  7fae2e:	00 00 00 00 
  7fae32:	f3 0f 58 e0          	addss  %xmm0,%xmm4
  7fae36:	eb a8                	jmp    7fade0 <<parley::layout::run::Clusters<()>>::advance_cursor+0x180>
  7fae38:	49 8d 76 70          	lea    0x70(%r14),%rsi
  7fae3c:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  7fae41:	ff 15 89 36 33 00    	call   *0x333689(%rip)        # b2e4d0 <_DYNAMIC+0xfd0>
  7fae47:	80 7c 24 30 00       	cmpb   $0x0,0x30(%rsp)
  7fae4c:	0f 84 fc 00 00 00    	je     7faf4e <<parley::layout::run::Clusters<()>>::advance_cursor+0x2ee>
  7fae52:	44 8b 5c 24 34       	mov    0x34(%rsp),%r11d
  7fae57:	44 8b 7c 24 38       	mov    0x38(%rsp),%r15d
  7fae5c:	f3 0f 10 64 24 3c    	movss  0x3c(%rsp),%xmm4
  7fae62:	0f b7 5c 24 40       	movzwl 0x40(%rsp),%ebx
  7fae67:	0f b7 6c 24 42       	movzwl 0x42(%rsp),%ebp
  7fae6c:	41 0f b6 86 08 01 00 	movzbl 0x108(%r14),%eax
  7fae73:	00 
  7fae74:	8d 48 04             	lea    0x4(%rax),%ecx
  7fae77:	0f b6 c9             	movzbl %cl,%ecx
  7fae7a:	0f a3 cb             	bt     %ecx,%ebx
  7fae7d:	0f 82 71 01 00 00    	jb     7faff4 <<parley::layout::run::Clusters<()>>::advance_cursor+0x394>
  7fae83:	e9 f1 02 00 00       	jmp    7fb179 <<parley::layout::run::Clusters<()>>::advance_cursor+0x519>
  7fae88:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  7fae8f:	00 
  7fae90:	44 89 db             	mov    %r11d,%ebx
  7fae93:	4b 8d 04 64          	lea    (%r12,%r12,2),%rax
  7fae97:	48 8d 3c c2          	lea    (%rdx,%rax,8),%rdi
  7fae9b:	f3 0f 10 44 c2 10    	movss  0x10(%rdx,%rax,8),%xmm0
  7faea1:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  7faea7:	48 89 ee             	mov    %rbp,%rsi
  7faeaa:	4c 89 ea             	mov    %r13,%rdx
  7faead:	ff 15 15 36 33 00    	call   *0x333615(%rip)        # b2e4c8 <_DYNAMIC+0xfc8>
  7faeb3:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  7faeb8:	89 c0                	mov    %eax,%eax
  7faeba:	0f 57 c0             	xorps  %xmm0,%xmm0
  7faebd:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  7faec2:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  7faec8:	f3 0f 5e c8          	divss  %xmm0,%xmm1
  7faecc:	f3 41 0f 11 8e b0 00 	movss  %xmm1,0xb0(%r14)
  7faed3:	00 00 
  7faed5:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
  7faedb:	f3 0f 58 e1          	addss  %xmm1,%xmm4
  7faedf:	41 89 db             	mov    %ebx,%r11d
  7faee2:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7faee7:	45 39 df             	cmp    %r11d,%r15d
  7faeea:	0f 86 99 00 00 00    	jbe    7faf89 <<parley::layout::run::Clusters<()>>::advance_cursor+0x329>
  7faef0:	44 89 ff             	mov    %r15d,%edi
  7faef3:	49 39 fd             	cmp    %rdi,%r13
  7faef6:	0f 86 b0 02 00 00    	jbe    7fb1ac <<parley::layout::run::Clusters<()>>::advance_cursor+0x54c>
  7faefc:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  7faf00:	80 7c 85 08 00       	cmpb   $0x0,0x8(%rbp,%rax,4)
  7faf05:	75 4e                	jne    7faf55 <<parley::layout::run::Clusters<()>>::advance_cursor+0x2f5>
  7faf07:	44 89 e7             	mov    %r12d,%edi
  7faf0a:	48 39 fe             	cmp    %rdi,%rsi
  7faf0d:	0f 86 a9 02 00 00    	jbe    7fb1bc <<parley::layout::run::Clusters<()>>::advance_cursor+0x55c>
  7faf13:	41 ff cf             	dec    %r15d
  7faf16:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  7faf1a:	44 3b 3c c2          	cmp    (%rdx,%rax,8),%r15d
  7faf1e:	73 c7                	jae    7faee7 <<parley::layout::run::Clusters<()>>::advance_cursor+0x287>
  7faf20:	f3 0f 11 64 24 18    	movss  %xmm4,0x18(%rsp)
  7faf26:	41 ff cc             	dec    %r12d
  7faf29:	45 89 a6 ac 00 00 00 	mov    %r12d,0xac(%r14)
  7faf30:	4c 39 e6             	cmp    %r12,%rsi
  7faf33:	0f 87 57 ff ff ff    	ja     7fae90 <<parley::layout::run::Clusters<()>>::advance_cursor+0x230>
  7faf39:	48 8d 15 c8 cf 30 00 	lea    0x30cfc8(%rip),%rdx        # b07f08 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.8.llvm.14379316919819170204+0x140>
  7faf40:	4c 89 e7             	mov    %r12,%rdi
  7faf43:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7faf48:	ff 15 82 28 33 00    	call   *0x332882(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7faf4e:	31 c0                	xor    %eax,%eax
  7faf50:	e9 41 02 00 00       	jmp    7fb196 <<parley::layout::run::Clusters<()>>::advance_cursor+0x536>
  7faf55:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
  7faf5a:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  7faf5f:	66 b8 10 00          	mov    $0x10,%ax
  7faf63:	45 39 df             	cmp    %r11d,%r15d
  7faf66:	74 2f                	je     7faf97 <<parley::layout::run::Clusters<()>>::advance_cursor+0x337>
  7faf68:	44 89 e7             	mov    %r12d,%edi
  7faf6b:	48 39 fe             	cmp    %rdi,%rsi
  7faf6e:	0f 86 be 02 00 00    	jbe    7fb232 <<parley::layout::run::Clusters<()>>::advance_cursor+0x5d2>
  7faf74:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  7faf78:	31 c0                	xor    %eax,%eax
  7faf7a:	44 3b 3c ca          	cmp    (%rdx,%rcx,8),%r15d
  7faf7e:	0f 94 c0             	sete   %al
  7faf81:	c1 e0 04             	shl    $0x4,%eax
  7faf84:	45 89 fb             	mov    %r15d,%r11d
  7faf87:	eb 0e                	jmp    7faf97 <<parley::layout::run::Clusters<()>>::advance_cursor+0x337>
  7faf89:	66 b8 10 00          	mov    $0x10,%ax
  7faf8d:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
  7faf92:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  7faf97:	44 89 df             	mov    %r11d,%edi
  7faf9a:	49 8b 76 78          	mov    0x78(%r14),%rsi
  7faf9e:	48 39 fe             	cmp    %rdi,%rsi
  7fafa1:	4c 8b bc 24 80 00 00 	mov    0x80(%rsp),%r15
  7fafa8:	00 
  7fafa9:	0f 86 76 02 00 00    	jbe    7fb225 <<parley::layout::run::Clusters<()>>::advance_cursor+0x5c5>
  7fafaf:	31 c9                	xor    %ecx,%ecx
  7fafb1:	45 39 c7             	cmp    %r8d,%r15d
  7fafb4:	0f 94 c1             	sete   %cl
  7fafb7:	49 8b 56 70          	mov    0x70(%r14),%rdx
  7fafbb:	48 8d 34 7f          	lea    (%rdi,%rdi,2),%rsi
  7fafbf:	0f b6 7c b2 07       	movzbl 0x7(%rdx,%rsi,4),%edi
  7fafc4:	0f b6 54 b2 06       	movzbl 0x6(%rdx,%rsi,4),%edx
  7fafc9:	45 89 9e a8 00 00 00 	mov    %r11d,0xa8(%r14)
  7fafd0:	c1 ea 04             	shr    $0x4,%edx
  7fafd3:	83 e2 01             	and    $0x1,%edx
  7fafd6:	8d 14 7a             	lea    (%rdx,%rdi,2),%edx
  7fafd9:	c1 e1 05             	shl    $0x5,%ecx
  7fafdc:	0f b7 d8             	movzwl %ax,%ebx
  7fafdf:	09 cb                	or     %ecx,%ebx
  7fafe1:	09 d3                	or     %edx,%ebx
  7fafe3:	b0 01                	mov    $0x1,%al
  7fafe5:	8d 48 04             	lea    0x4(%rax),%ecx
  7fafe8:	0f b6 c9             	movzbl %cl,%ecx
  7fafeb:	0f a3 cb             	bt     %ecx,%ebx
  7fafee:	0f 83 85 01 00 00    	jae    7fb179 <<parley::layout::run::Clusters<()>>::advance_cursor+0x519>
  7faff4:	49 8d 76 30          	lea    0x30(%r14),%rsi
  7faff8:	84 c0                	test   %al,%al
  7faffa:	74 21                	je     7fb01d <<parley::layout::run::Clusters<()>>::advance_cursor+0x3bd>
  7faffc:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  7fb001:	45 89 dc             	mov    %r11d,%r12d
  7fb004:	f3 0f 11 64 24 18    	movss  %xmm4,0x18(%rsp)
  7fb00a:	e8 21 f8 ff ff       	call   7fa830 <<parley_engine::shape::atom::Atoms>::prev>
  7fb00f:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
  7fb015:	45 89 e3             	mov    %r12d,%r11d
  7fb018:	e9 e6 00 00 00       	jmp    7fb103 <<parley::layout::run::Clusters<()>>::advance_cursor+0x4a3>
  7fb01d:	45 8b 56 64          	mov    0x64(%r14),%r10d
  7fb021:	41 8b 7e 68          	mov    0x68(%r14),%edi
  7fb025:	44 39 d7             	cmp    %r10d,%edi
  7fb028:	75 0e                	jne    7fb038 <<parley::layout::run::Clusters<()>>::advance_cursor+0x3d8>
  7fb02a:	48 c7 44 24 30 00 00 	movq   $0x0,0x30(%rsp)
  7fb031:	00 00 
  7fb033:	e9 cb 00 00 00       	jmp    7fb103 <<parley::layout::run::Clusters<()>>::advance_cursor+0x4a3>
  7fb038:	49 8b 46 48          	mov    0x48(%r14),%rax
  7fb03c:	48 39 f8             	cmp    %rdi,%rax
  7fb03f:	0f 86 fa 01 00 00    	jbe    7fb23f <<parley::layout::run::Clusters<()>>::advance_cursor+0x5df>
  7fb045:	49 8b 56 40          	mov    0x40(%r14),%rdx
  7fb049:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  7fb04d:	f3 42 0f 10 44 ca 10 	movss  0x10(%rdx,%r9,8),%xmm0
  7fb054:	44 8d 47 01          	lea    0x1(%rdi),%r8d
  7fb058:	45 39 d0             	cmp    %r10d,%r8d
  7fb05b:	73 4b                	jae    7fb0a8 <<parley::layout::run::Clusters<()>>::advance_cursor+0x448>
  7fb05d:	45 89 dc             	mov    %r11d,%r12d
  7fb060:	44 89 c1             	mov    %r8d,%ecx
  7fb063:	4c 8d 04 49          	lea    (%rcx,%rcx,2),%r8
  7fb067:	4e 8d 1c c2          	lea    (%rdx,%r8,8),%r11
  7fb06b:	49 83 c3 16          	add    $0x16,%r11
  7fb06f:	49 89 c8             	mov    %rcx,%r8
  7fb072:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7fb079:	1f 84 00 00 00 00 00 
  7fb080:	4c 39 c0             	cmp    %r8,%rax
  7fb083:	0f 86 45 01 00 00    	jbe    7fb1ce <<parley::layout::run::Clusters<()>>::advance_cursor+0x56e>
  7fb089:	41 f6 43 01 02       	testb  $0x2,0x1(%r11)
  7fb08e:	75 15                	jne    7fb0a5 <<parley::layout::run::Clusters<()>>::advance_cursor+0x445>
  7fb090:	f3 41 0f 58 43 fa    	addss  -0x6(%r11),%xmm0
  7fb096:	49 ff c0             	inc    %r8
  7fb099:	49 83 c3 18          	add    $0x18,%r11
  7fb09d:	4d 39 c2             	cmp    %r8,%r10
  7fb0a0:	75 de                	jne    7fb080 <<parley::layout::run::Clusters<()>>::advance_cursor+0x420>
  7fb0a2:	45 89 d0             	mov    %r10d,%r8d
  7fb0a5:	45 89 e3             	mov    %r12d,%r11d
  7fb0a8:	45 89 46 68          	mov    %r8d,0x68(%r14)
  7fb0ac:	44 89 c1             	mov    %r8d,%ecx
  7fb0af:	48 ff c9             	dec    %rcx
  7fb0b2:	48 39 c1             	cmp    %rax,%rcx
  7fb0b5:	0f 83 94 01 00 00    	jae    7fb24f <<parley::layout::run::Clusters<()>>::advance_cursor+0x5ef>
  7fb0bb:	4a 8d 04 ca          	lea    (%rdx,%r9,8),%rax
  7fb0bf:	8b 00                	mov    (%rax),%eax
  7fb0c1:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  7fb0c5:	8b 4c ca 04          	mov    0x4(%rdx,%rcx,8),%ecx
  7fb0c9:	48 8b 56 30          	mov    0x30(%rsi),%rdx
  7fb0cd:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  7fb0d2:	0f 10 0e             	movups (%rsi),%xmm1
  7fb0d5:	0f 10 56 10          	movups 0x10(%rsi),%xmm2
  7fb0d9:	0f 10 5e 20          	movups 0x20(%rsi),%xmm3
  7fb0dd:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
  7fb0e2:	0f 29 54 24 40       	movaps %xmm2,0x40(%rsp)
  7fb0e7:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  7fb0ec:	89 7c 24 68          	mov    %edi,0x68(%rsp)
  7fb0f0:	44 89 44 24 6c       	mov    %r8d,0x6c(%rsp)
  7fb0f5:	89 44 24 70          	mov    %eax,0x70(%rsp)
  7fb0f9:	89 4c 24 74          	mov    %ecx,0x74(%rsp)
  7fb0fd:	f3 0f 11 44 24 78    	movss  %xmm0,0x78(%rsp)
  7fb103:	8b 44 24 70          	mov    0x70(%rsp),%eax
  7fb107:	41 89 86 f8 00 00 00 	mov    %eax,0xf8(%r14)
  7fb10e:	8b 44 24 74          	mov    0x74(%rsp),%eax
  7fb112:	41 89 86 fc 00 00 00 	mov    %eax,0xfc(%r14)
  7fb119:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  7fb11e:	49 89 86 00 01 00 00 	mov    %rax,0x100(%r14)
  7fb125:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7fb12a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7fb12f:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  7fb134:	0f 28 4c 24 50       	movaps 0x50(%rsp),%xmm1
  7fb139:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  7fb13e:	49 89 96 e8 00 00 00 	mov    %rdx,0xe8(%r14)
  7fb145:	8b 54 24 68          	mov    0x68(%rsp),%edx
  7fb149:	41 89 96 f0 00 00 00 	mov    %edx,0xf0(%r14)
  7fb150:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
  7fb154:	41 89 96 f4 00 00 00 	mov    %edx,0xf4(%r14)
  7fb15b:	41 0f 11 8e d8 00 00 	movups %xmm1,0xd8(%r14)
  7fb162:	00 
  7fb163:	41 0f 11 86 c8 00 00 	movups %xmm0,0xc8(%r14)
  7fb16a:	00 
  7fb16b:	49 89 86 b8 00 00 00 	mov    %rax,0xb8(%r14)
  7fb172:	49 89 8e c0 00 00 00 	mov    %rcx,0xc0(%r14)
  7fb179:	45 89 5d 04          	mov    %r11d,0x4(%r13)
  7fb17d:	45 89 7d 08          	mov    %r15d,0x8(%r13)
  7fb181:	f3 41 0f 11 65 0c    	movss  %xmm4,0xc(%r13)
  7fb187:	66 41 89 5d 10       	mov    %bx,0x10(%r13)
  7fb18c:	66 41 89 6d 12       	mov    %bp,0x12(%r13)
  7fb191:	b8 01 00 00 00       	mov    $0x1,%eax
  7fb196:	41 89 45 00          	mov    %eax,0x0(%r13)
  7fb19a:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  7fb1a1:	5b                   	pop    %rbx
  7fb1a2:	41 5c                	pop    %r12
  7fb1a4:	41 5d                	pop    %r13
  7fb1a6:	41 5e                	pop    %r14
  7fb1a8:	41 5f                	pop    %r15
  7fb1aa:	5d                   	pop    %rbp
  7fb1ab:	c3                   	ret
  7fb1ac:	48 8d 15 8d ce 30 00 	lea    0x30ce8d(%rip),%rdx        # b08040 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.38.llvm.14379316919819170204+0xf0>
  7fb1b3:	4c 89 ee             	mov    %r13,%rsi
  7fb1b6:	ff 15 14 26 33 00    	call   *0x332614(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fb1bc:	48 8d 15 95 ce 30 00 	lea    0x30ce95(%rip),%rdx        # b08058 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.38.llvm.14379316919819170204+0x108>
  7fb1c3:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7fb1c8:	ff 15 02 26 33 00    	call   *0x332602(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fb1ce:	48 39 c8             	cmp    %rcx,%rax
  7fb1d1:	48 0f 47 c8          	cmova  %rax,%rcx
  7fb1d5:	48 8d 15 f4 ce 30 00 	lea    0x30cef4(%rip),%rdx        # b080d0 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.54.llvm.14379316919819170204+0x30>
  7fb1dc:	48 89 cf             	mov    %rcx,%rdi
  7fb1df:	48 89 c6             	mov    %rax,%rsi
  7fb1e2:	ff 15 e8 25 33 00    	call   *0x3325e8(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fb1e8:	48 8d 15 41 cc 30 00 	lea    0x30cc41(%rip),%rdx        # b07e30 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.8.llvm.14379316919819170204+0x68>
  7fb1ef:	4c 89 cf             	mov    %r9,%rdi
  7fb1f2:	ff 15 d8 25 33 00    	call   *0x3325d8(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fb1f8:	48 8d 15 49 cc 30 00 	lea    0x30cc49(%rip),%rdx        # b07e48 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.8.llvm.14379316919819170204+0x80>
  7fb1ff:	ff 15 cb 25 33 00    	call   *0x3325cb(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fb205:	48 8d 15 04 ce 30 00 	lea    0x30ce04(%rip),%rdx        # b08010 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.38.llvm.14379316919819170204+0xc0>
  7fb20c:	4c 89 e7             	mov    %r12,%rdi
  7fb20f:	ff 15 bb 25 33 00    	call   *0x3325bb(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fb215:	48 8d 15 0c ce 30 00 	lea    0x30ce0c(%rip),%rdx        # b08028 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.38.llvm.14379316919819170204+0xd8>
  7fb21c:	4c 89 e7             	mov    %r12,%rdi
  7fb21f:	ff 15 ab 25 33 00    	call   *0x3325ab(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fb225:	48 8d 15 5c ce 30 00 	lea    0x30ce5c(%rip),%rdx        # b08088 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.38.llvm.14379316919819170204+0x138>
  7fb22c:	ff 15 9e 25 33 00    	call   *0x33259e(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fb232:	48 8d 15 37 ce 30 00 	lea    0x30ce37(%rip),%rdx        # b08070 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.38.llvm.14379316919819170204+0x120>
  7fb239:	ff 15 91 25 33 00    	call   *0x332591(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fb23f:	48 8d 15 72 ce 30 00 	lea    0x30ce72(%rip),%rdx        # b080b8 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.54.llvm.14379316919819170204+0x18>
  7fb246:	48 89 c6             	mov    %rax,%rsi
  7fb249:	ff 15 81 25 33 00    	call   *0x332581(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fb24f:	48 8d 15 92 ce 30 00 	lea    0x30ce92(%rip),%rdx        # b080e8 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.54.llvm.14379316919819170204+0x48>
  7fb256:	48 89 cf             	mov    %rcx,%rdi
  7fb259:	48 89 c6             	mov    %rax,%rsi
  7fb25c:	ff 15 6e 25 33 00    	call   *0x33256e(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>

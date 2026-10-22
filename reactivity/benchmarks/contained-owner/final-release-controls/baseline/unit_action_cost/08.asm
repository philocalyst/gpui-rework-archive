
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070bee0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change>:
  70bee0:	41 57                	push   %r15
  70bee2:	41 56                	push   %r14
  70bee4:	41 54                	push   %r12
  70bee6:	53                   	push   %rbx
  70bee7:	50                   	push   %rax
  70bee8:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70beef:	48 85 c0             	test   %rax,%rax
  70bef2:	74 12                	je     70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70bef4:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  70befb:	48 85 c0             	test   %rax,%rax
  70befe:	74 06                	je     70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70bf00:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  70bf04:	75 63                	jne    70bf69 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x89>
  70bf06:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  70bf0d:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  70bf14:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  70bf1b:	00 
  70bf1c:	74 1c                	je     70bf3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x5a>
  70bf1e:	84 c0                	test   %al,%al
  70bf20:	74 0a                	je     70bf2c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x4c>
  70bf22:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  70bf29:	ff 
  70bf2a:	74 0e                	je     70bf3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x5a>
  70bf2c:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  70bf33:	b9 01 00 00 00       	mov    $0x1,%ecx
  70bf38:	eb 02                	jmp    70bf3c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x5c>
  70bf3a:	31 c9                	xor    %ecx,%ecx
  70bf3c:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  70bf43:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70bf47:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  70bf4b:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  70bf4f:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  70bf53:	88 47 30             	mov    %al,0x30(%rdi)
  70bf56:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70bf5d:	48 83 c4 08          	add    $0x8,%rsp
  70bf61:	5b                   	pop    %rbx
  70bf62:	41 5c                	pop    %r12
  70bf64:	41 5e                	pop    %r14
  70bf66:	41 5f                	pop    %r15
  70bf68:	c3                   	ret
  70bf69:	48 8b 00             	mov    (%rax),%rax
  70bf6c:	4c 8b 86 e8 01 00 00 	mov    0x1e8(%rsi),%r8
  70bf73:	4d 85 c0             	test   %r8,%r8
  70bf76:	0f 84 99 00 00 00    	je     70c015 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x135>
  70bf7c:	41 83 f8 01          	cmp    $0x1,%r8d
  70bf80:	0f 85 ab 00 00 00    	jne    70c031 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x151>
  70bf86:	4c 8b 96 f8 01 00 00 	mov    0x1f8(%rsi),%r10
  70bf8d:	4d 85 d2             	test   %r10,%r10
  70bf90:	0f 84 70 ff ff ff    	je     70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70bf96:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  70bf9d:	45 31 c9             	xor    %r9d,%r9d
  70bfa0:	49 83 fa 01          	cmp    $0x1,%r10
  70bfa4:	74 2e                	je     70bfd4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0xf4>
  70bfa6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  70bfad:	00 00 00 
  70bfb0:	4d 89 cb             	mov    %r9,%r11
  70bfb3:	4c 89 d3             	mov    %r10,%rbx
  70bfb6:	48 d1 eb             	shr    $1,%rbx
  70bfb9:	49 01 d9             	add    %rbx,%r9
  70bfbc:	4d 89 ce             	mov    %r9,%r14
  70bfbf:	49 c1 e6 04          	shl    $0x4,%r14
  70bfc3:	4b 39 04 30          	cmp    %rax,(%r8,%r14,1)
  70bfc7:	4d 0f 47 cb          	cmova  %r11,%r9
  70bfcb:	49 29 da             	sub    %rbx,%r10
  70bfce:	49 83 fa 01          	cmp    $0x1,%r10
  70bfd2:	77 dc                	ja     70bfb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0xd0>
  70bfd4:	4d 89 cb             	mov    %r9,%r11
  70bfd7:	49 c1 e3 04          	shl    $0x4,%r11
  70bfdb:	45 31 d2             	xor    %r10d,%r10d
  70bfde:	4b 39 04 18          	cmp    %rax,(%r8,%r11,1)
  70bfe2:	41 0f 96 c2          	setbe  %r10b
  70bfe6:	4d 01 ca             	add    %r9,%r10
  70bfe9:	0f 84 17 ff ff ff    	je     70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70bfef:	49 c1 e2 04          	shl    $0x4,%r10
  70bff3:	4b 2b 44 10 f0       	sub    -0x10(%r8,%r10,1),%rax
  70bff8:	47 8b 4c 10 fc       	mov    -0x4(%r8,%r10,1),%r9d
  70bffd:	4c 39 c8             	cmp    %r9,%rax
  70c000:	0f 83 00 ff ff ff    	jae    70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c006:	4d 01 d0             	add    %r10,%r8
  70c009:	45 8b 40 f8          	mov    -0x8(%r8),%r8d
  70c00d:	4c 01 c0             	add    %r8,%rax
  70c010:	e9 82 00 00 00       	jmp    70c097 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x1b7>
  70c015:	48 2b 86 f0 01 00 00 	sub    0x1f0(%rsi),%rax
  70c01c:	0f 82 e4 fe ff ff    	jb     70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c022:	48 3b 86 f8 01 00 00 	cmp    0x1f8(%rsi),%rax
  70c029:	0f 83 d7 fe ff ff    	jae    70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c02f:	eb 66                	jmp    70c097 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x1b7>
  70c031:	4c 8b 8e f8 01 00 00 	mov    0x1f8(%rsi),%r9
  70c038:	4d 85 c9             	test   %r9,%r9
  70c03b:	0f 84 c5 fe ff ff    	je     70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c041:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  70c048:	49 83 f9 01          	cmp    $0x1,%r9
  70c04c:	75 0b                	jne    70c059 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x179>
  70c04e:	49 39 00             	cmp    %rax,(%r8)
  70c051:	0f 85 af fe ff ff    	jne    70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c057:	eb 3a                	jmp    70c093 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x1b3>
  70c059:	45 31 d2             	xor    %r10d,%r10d
  70c05c:	0f 1f 40 00          	nopl   0x0(%rax)
  70c060:	4d 89 d3             	mov    %r10,%r11
  70c063:	4c 89 cb             	mov    %r9,%rbx
  70c066:	48 d1 eb             	shr    $1,%rbx
  70c069:	49 01 da             	add    %rbx,%r10
  70c06c:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  70c070:	4b 39 04 b0          	cmp    %rax,(%r8,%r14,4)
  70c074:	4d 0f 47 d3          	cmova  %r11,%r10
  70c078:	49 29 d9             	sub    %rbx,%r9
  70c07b:	49 83 f9 01          	cmp    $0x1,%r9
  70c07f:	77 df                	ja     70c060 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x180>
  70c081:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
  70c085:	4b 39 04 88          	cmp    %rax,(%r8,%r9,4)
  70c089:	0f 85 77 fe ff ff    	jne    70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c08f:	4f 8d 04 88          	lea    (%r8,%r9,4),%r8
  70c093:	41 8b 40 08          	mov    0x8(%r8),%eax
  70c097:	48 89 fb             	mov    %rdi,%rbx
  70c09a:	48 89 f7             	mov    %rsi,%rdi
  70c09d:	49 89 f6             	mov    %rsi,%r14
  70c0a0:	48 89 c6             	mov    %rax,%rsi
  70c0a3:	49 89 cf             	mov    %rcx,%r15
  70c0a6:	49 89 d4             	mov    %rdx,%r12
  70c0a9:	e8 c2 da ff ff       	call   709b70 <<gpui::runtime::Runtime<unit_action_cost::Model>>::editing_at>
  70c0ae:	4c 89 f6             	mov    %r14,%rsi
  70c0b1:	48 89 df             	mov    %rbx,%rdi
  70c0b4:	48 85 c0             	test   %rax,%rax
  70c0b7:	0f 84 49 fe ff ff    	je     70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c0bd:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  70c0c1:	0f 84 3f fe ff ff    	je     70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c0c7:	4c 89 e2             	mov    %r12,%rdx
  70c0ca:	4c 89 f9             	mov    %r15,%rcx
  70c0cd:	4c 8b 08             	mov    (%rax),%r9
  70c0d0:	4d 85 e4             	test   %r12,%r12
  70c0d3:	74 19                	je     70c0ee <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x20e>
  70c0d5:	4c 8b 86 b0 05 00 00 	mov    0x5b0(%rsi),%r8
  70c0dc:	49 31 d0             	xor    %rdx,%r8
  70c0df:	49 89 ca             	mov    %rcx,%r10
  70c0e2:	4d 31 ca             	xor    %r9,%r10
  70c0e5:	4d 09 c2             	or     %r8,%r10
  70c0e8:	41 0f 94 c0          	sete   %r8b
  70c0ec:	eb 03                	jmp    70c0f1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x211>
  70c0ee:	45 31 c0             	xor    %r8d,%r8d
  70c0f1:	44 8b 50 18          	mov    0x18(%rax),%r10d
  70c0f5:	8b 40 20             	mov    0x20(%rax),%eax
  70c0f8:	4c 8b 9e e8 05 00 00 	mov    0x5e8(%rsi),%r11
  70c0ff:	4d 85 db             	test   %r11,%r11
  70c102:	74 17                	je     70c11b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x23b>
  70c104:	4c 33 9e b0 05 00 00 	xor    0x5b0(%rsi),%r11
  70c10b:	4c 33 8e f0 05 00 00 	xor    0x5f0(%rsi),%r9
  70c112:	4d 09 d9             	or     %r11,%r9
  70c115:	41 0f 94 c1          	sete   %r9b
  70c119:	eb 03                	jmp    70c11e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x23e>
  70c11b:	45 31 c9             	xor    %r9d,%r9d
  70c11e:	41 39 c2             	cmp    %eax,%r10d
  70c121:	0f 85 df fd ff ff    	jne    70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c127:	45 30 c8             	xor    %r9b,%r8b
  70c12a:	0f 84 d6 fd ff ff    	je     70bf06 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c130:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  70c137:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  70c13b:	74 28                	je     70c165 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x285>
  70c13d:	48 ff c0             	inc    %rax
  70c140:	48 89 86 60 06 00 00 	mov    %rax,0x660(%rsi)
  70c147:	48 ff 86 b0 06 00 00 	incq   0x6b0(%rsi)
  70c14e:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  70c155:	48 83 c4 08          	add    $0x8,%rsp
  70c159:	5b                   	pop    %rbx
  70c15a:	41 5c                	pop    %r12
  70c15c:	41 5e                	pop    %r14
  70c15e:	41 5f                	pop    %r15
  70c160:	e9 8b 19 01 00       	jmp    71daf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70c165:	48 89 96 e8 05 00 00 	mov    %rdx,0x5e8(%rsi)
  70c16c:	48 89 8e f0 05 00 00 	mov    %rcx,0x5f0(%rsi)
  70c173:	48 c7 07 1f 00 00 00 	movq   $0x1f,(%rdi)
  70c17a:	e9 de fd ff ff       	jmp    70bf5d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x7d>

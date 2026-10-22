
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fde90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property>:
  6fde90:	55                   	push   %rbp
  6fde91:	41 57                	push   %r15
  6fde93:	41 56                	push   %r14
  6fde95:	41 55                	push   %r13
  6fde97:	41 54                	push   %r12
  6fde99:	53                   	push   %rbx
  6fde9a:	48 81 ec 38 01 00 00 	sub    $0x138,%rsp
  6fdea1:	49 89 cc             	mov    %rcx,%r12
  6fdea4:	49 89 f6             	mov    %rsi,%r14
  6fdea7:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  6fdeac:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  6fdeb3:	48 39 f1             	cmp    %rsi,%rcx
  6fdeb6:	0f 83 6f 05 00 00    	jae    6fe42b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x59b>
  6fdebc:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fdec3:	4b 8d 1c a4          	lea    (%r12,%r12,4),%rbx
  6fdec7:	48 8b 74 d8 08       	mov    0x8(%rax,%rbx,8),%rsi
  6fdecc:	48 8b 4c d8 10       	mov    0x10(%rax,%rbx,8),%rcx
  6fded1:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  6fded8:	00 00 
  6fdeda:	48 85 f6             	test   %rsi,%rsi
  6fdedd:	0f 84 21 05 00 00    	je     6fe404 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x574>
  6fdee3:	48 89 94 24 d0 00 00 	mov    %rdx,0xd0(%rsp)
  6fdeea:	00 
  6fdeeb:	4c 89 84 24 d8 00 00 	mov    %r8,0xd8(%rsp)
  6fdef2:	00 
  6fdef3:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  6fdef8:	48 89 b4 24 e0 00 00 	mov    %rsi,0xe0(%rsp)
  6fdeff:	00 
  6fdf00:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  6fdf05:	48 89 8c 24 e8 00 00 	mov    %rcx,0xe8(%rsp)
  6fdf0c:	00 
  6fdf0d:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  6fdf14:	48 8d 0d 2d ca 3f 00 	lea    0x3fca2d(%rip),%rcx        # afa948 <__frame_dummy_init_array_entry+0xb0>
  6fdf1b:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fdf20:	48 8d b4 24 e0 00 00 	lea    0xe0(%rsp),%rsi
  6fdf27:	00 
  6fdf28:	48 89 ea             	mov    %rbp,%rdx
  6fdf2b:	ff 15 47 b5 42 00    	call   *0x42b547(%rip)        # b29478 <_DYNAMIC+0x378>
  6fdf31:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  6fdf37:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  6fdf3c:	0f 84 f6 00 00 00    	je     6fe038 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1a8>
  6fdf42:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fdf47:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fdf4c:	8b 74 24 24          	mov    0x24(%rsp),%esi
  6fdf50:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  6fdf55:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  6fdf5b:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  6fdf61:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  6fdf65:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fdf6a:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  6fdf71:	00 
  6fdf72:	66 45 85 ff          	test   %r15w,%r15w
  6fdf76:	0f 84 f8 00 00 00    	je     6fe074 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1e4>
  6fdf7c:	41 c1 e1 10          	shl    $0x10,%r9d
  6fdf80:	45 09 c8             	or     %r9d,%r8d
  6fdf83:	49 c1 e0 20          	shl    $0x20,%r8
  6fdf87:	4c 09 c1             	or     %r8,%rcx
  6fdf8a:	89 b4 24 f4 00 00 00 	mov    %esi,0xf4(%rsp)
  6fdf91:	40 88 bc 24 f8 00 00 	mov    %dil,0xf8(%rsp)
  6fdf98:	00 
  6fdf99:	89 8c 24 f9 00 00 00 	mov    %ecx,0xf9(%rsp)
  6fdfa0:	48 89 ce             	mov    %rcx,%rsi
  6fdfa3:	48 c1 ee 30          	shr    $0x30,%rsi
  6fdfa7:	40 88 b4 24 ff 00 00 	mov    %sil,0xff(%rsp)
  6fdfae:	00 
  6fdfaf:	48 c1 e9 20          	shr    $0x20,%rcx
  6fdfb3:	66 89 8c 24 fd 00 00 	mov    %cx,0xfd(%rsp)
  6fdfba:	00 
  6fdfbb:	0f 28 84 24 10 01 00 	movaps 0x110(%rsp),%xmm0
  6fdfc2:	00 
  6fdfc3:	0f 11 84 24 00 01 00 	movups %xmm0,0x100(%rsp)
  6fdfca:	00 
  6fdfcb:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  6fdfd2:	49 ff c5             	inc    %r13
  6fdfd5:	0f 84 42 04 00 00    	je     6fe41d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x58d>
  6fdfdb:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  6fdfe2:	0f 85 93 00 00 00    	jne    6fe07b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1eb>
  6fdfe8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fdfed:	4c 89 f6             	mov    %r14,%rsi
  6fdff0:	e8 bb ac 02 00       	call   728cb0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  6fdff5:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  6fdffb:	0f 85 83 00 00 00    	jne    6fe084 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1f4>
  6fe001:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fe006:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fe00b:	4c 8d 84 24 f4 00 00 	lea    0xf4(%rsp),%r8
  6fe012:	00 
  6fe013:	4c 89 f6             	mov    %r14,%rsi
  6fe016:	44 89 f9             	mov    %r15d,%ecx
  6fe019:	e8 f2 cd 02 00       	call   72ae10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at>
  6fe01e:	4d 89 e7             	mov    %r12,%r15
  6fe021:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fe026:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe02a:	0f 85 9e 00 00 00    	jne    6fe0ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x23e>
  6fe030:	45 31 c0             	xor    %r8d,%r8d
  6fe033:	e9 bb 00 00 00       	jmp    6fe0f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x263>
  6fe038:	0f b6 74 24 28       	movzbl 0x28(%rsp),%esi
  6fe03d:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  6fe042:	c1 e0 10             	shl    $0x10,%eax
  6fe045:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  6fe04a:	09 c1                	or     %eax,%ecx
  6fe04c:	48 c1 e1 20          	shl    $0x20,%rcx
  6fe050:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  6fe054:	48 09 cd             	or     %rcx,%rbp
  6fe057:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fe05c:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  6fe063:	00 
  6fe064:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe069:	41 bd 20 00 00 00    	mov    $0x20,%r13d
  6fe06f:	e9 bf 01 00 00       	jmp    6fe233 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3a3>
  6fe074:	31 f6                	xor    %esi,%esi
  6fe076:	e9 66 01 00 00       	jmp    6fe1e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x351>
  6fe07b:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  6fe082:	00 00 
  6fe084:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fe089:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6fe090:	00 
  6fe091:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fe096:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fe09b:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  6fe0a0:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  6fe0a5:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  6fe0ac:	00 
  6fe0ad:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  6fe0b2:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fe0b7:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fe0bc:	4d 89 e7             	mov    %r12,%r15
  6fe0bf:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fe0c4:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe0c8:	0f 84 62 ff ff ff    	je     6fe030 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1a0>
  6fe0ce:	4c 89 e1             	mov    %r12,%rcx
  6fe0d1:	48 83 e9 0d          	sub    $0xd,%rcx
  6fe0d5:	b8 14 00 00 00       	mov    $0x14,%eax
  6fe0da:	48 0f 4d c1          	cmovge %rcx,%rax
  6fe0de:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  6fe0e3:	48 83 f8 17          	cmp    $0x17,%rax
  6fe0e7:	74 0a                	je     6fe0f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x263>
  6fe0e9:	48 83 f8 04          	cmp    $0x4,%rax
  6fe0ed:	0f 85 f7 00 00 00    	jne    6fe1ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x35a>
  6fe0f3:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  6fe0fa:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fe101:	48 8d 0d 40 c8 3f 00 	lea    0x3fc840(%rip),%rcx        # afa948 <__frame_dummy_init_array_entry+0xb0>
  6fe108:	48 8d bc 24 20 01 00 	lea    0x120(%rsp),%rdi
  6fe10f:	00 
  6fe110:	48 8d b4 24 e0 00 00 	lea    0xe0(%rsp),%rsi
  6fe117:	00 
  6fe118:	48 89 ea             	mov    %rbp,%rdx
  6fe11b:	ff 15 5f b3 42 00    	call   *0x42b35f(%rip)        # b29480 <_DYNAMIC+0x380>
  6fe121:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  6fe126:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fe12b:	48 8b b4 24 20 01 00 	mov    0x120(%rsp),%rsi
  6fe132:	00 
  6fe133:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  6fe137:	74 69                	je     6fe1a2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x312>
  6fe139:	48 89 f5             	mov    %rsi,%rbp
  6fe13c:	48 c1 ed 08          	shr    $0x8,%rbp
  6fe140:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  6fe147:	00 
  6fe148:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe14d:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe151:	74 44                	je     6fe197 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x307>
  6fe153:	49 83 ec 0d          	sub    $0xd,%r12
  6fe157:	ba 14 00 00 00       	mov    $0x14,%edx
  6fe15c:	49 0f 4d d4          	cmovge %r12,%rdx
  6fe160:	48 83 fa 19          	cmp    $0x19,%rdx
  6fe164:	74 09                	je     6fe16f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x2df>
  6fe166:	48 89 c8             	mov    %rcx,%rax
  6fe169:	48 83 fa 14          	cmp    $0x14,%rdx
  6fe16d:	75 28                	jne    6fe197 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x307>
  6fe16f:	49 89 f5             	mov    %rsi,%r13
  6fe172:	48 8b 30             	mov    (%rax),%rsi
  6fe175:	48 85 f6             	test   %rsi,%rsi
  6fe178:	74 0f                	je     6fe189 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x2f9>
  6fe17a:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fe17e:	ba 01 00 00 00       	mov    $0x1,%edx
  6fe183:	ff 15 bf b1 42 00    	call   *0x42b1bf(%rip)        # b29348 <_DYNAMIC+0x248>
  6fe189:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fe18f:	4c 89 ee             	mov    %r13,%rsi
  6fe192:	e9 96 00 00 00       	jmp    6fe22d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x39d>
  6fe197:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fe19d:	e9 8b 00 00 00       	jmp    6fe22d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x39d>
  6fe1a2:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe1a6:	74 33                	je     6fe1db <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x34b>
  6fe1a8:	49 83 ec 0d          	sub    $0xd,%r12
  6fe1ac:	ba 14 00 00 00       	mov    $0x14,%edx
  6fe1b1:	49 0f 4d d4          	cmovge %r12,%rdx
  6fe1b5:	48 83 fa 19          	cmp    $0x19,%rdx
  6fe1b9:	74 09                	je     6fe1c4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x334>
  6fe1bb:	48 89 c8             	mov    %rcx,%rax
  6fe1be:	48 83 fa 14          	cmp    $0x14,%rdx
  6fe1c2:	75 17                	jne    6fe1db <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x34b>
  6fe1c4:	48 8b 30             	mov    (%rax),%rsi
  6fe1c7:	48 85 f6             	test   %rsi,%rsi
  6fe1ca:	74 0f                	je     6fe1db <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x34b>
  6fe1cc:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fe1d0:	ba 01 00 00 00       	mov    $0x1,%edx
  6fe1d5:	ff 15 6d b1 42 00    	call   *0x42b16d(%rip)        # b29348 <_DYNAMIC+0x248>
  6fe1db:	40 b6 01             	mov    $0x1,%sil
  6fe1de:	4d 89 fc             	mov    %r15,%r12
  6fe1e1:	49 c7 c5 fe ff ff ff 	mov    $0xfffffffffffffffe,%r13
  6fe1e8:	eb 49                	jmp    6fe233 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3a3>
  6fe1ea:	0f b6 74 24 68       	movzbl 0x68(%rsp),%esi
  6fe1ef:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  6fe1f4:	c1 e0 10             	shl    $0x10,%eax
  6fe1f7:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  6fe1fc:	09 c1                	or     %eax,%ecx
  6fe1fe:	48 c1 e1 20          	shl    $0x20,%rcx
  6fe202:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  6fe206:	48 09 cd             	or     %rcx,%rbp
  6fe209:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  6fe20e:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe213:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  6fe21a:	00 
  6fe21b:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6fe220:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  6fe227:	00 
  6fe228:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fe22d:	4d 89 e5             	mov    %r12,%r13
  6fe230:	4d 89 fc             	mov    %r15,%r12
  6fe233:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  6fe238:	40 0f b6 c6          	movzbl %sil,%eax
  6fe23c:	48 c1 e5 08          	shl    $0x8,%rbp
  6fe240:	48 09 c5             	or     %rax,%rbp
  6fe243:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  6fe248:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  6fe24d:	0f 11 84 24 a8 00 00 	movups %xmm0,0xa8(%rsp)
  6fe254:	00 
  6fe255:	0f 11 8c 24 b8 00 00 	movups %xmm1,0xb8(%rsp)
  6fe25c:	00 
  6fe25d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe262:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fe269:	00 
  6fe26a:	4c 89 ac 24 98 00 00 	mov    %r13,0x98(%rsp)
  6fe271:	00 
  6fe272:	48 89 ac 24 a0 00 00 	mov    %rbp,0xa0(%rsp)
  6fe279:	00 
  6fe27a:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe281:	49 39 f4             	cmp    %rsi,%r12
  6fe284:	0f 83 68 02 00 00    	jae    6fe4f2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x662>
  6fe28a:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fe291:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  6fe295:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  6fe29a:	4d 85 ff             	test   %r15,%r15
  6fe29d:	74 28                	je     6fe2c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x437>
  6fe29f:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  6fe2a4:	48 8b 03             	mov    (%rbx),%rax
  6fe2a7:	48 85 c0             	test   %rax,%rax
  6fe2aa:	74 05                	je     6fe2b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x421>
  6fe2ac:	4c 89 ff             	mov    %r15,%rdi
  6fe2af:	ff d0                	call   *%rax
  6fe2b1:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe2b5:	48 85 f6             	test   %rsi,%rsi
  6fe2b8:	74 0d                	je     6fe2c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x437>
  6fe2ba:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe2be:	4c 89 ff             	mov    %r15,%rdi
  6fe2c1:	ff 15 81 b0 42 00    	call   *0x42b081(%rip)        # b29348 <_DYNAMIC+0x248>
  6fe2c7:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fe2cc:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fe2d1:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fe2d6:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fe2db:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fe2df:	74 35                	je     6fe316 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x486>
  6fe2e1:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fe2e5:	75 77                	jne    6fe35e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4ce>
  6fe2e7:	80 7c 24 58 01       	cmpb   $0x1,0x58(%rsp)
  6fe2ec:	0f 85 a2 00 00 00    	jne    6fe394 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x504>
  6fe2f2:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fe2f7:	4c 89 f6             	mov    %r14,%rsi
  6fe2fa:	48 8b 94 24 d0 00 00 	mov    0xd0(%rsp),%rdx
  6fe301:	00 
  6fe302:	31 c9                	xor    %ecx,%ecx
  6fe304:	4c 8b 84 24 d8 00 00 	mov    0xd8(%rsp),%r8
  6fe30b:	00 
  6fe30c:	e8 4f 06 00 00       	call   6fe960 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>
  6fe311:	e9 dc 00 00 00       	jmp    6fe3f2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x562>
  6fe316:	4c 89 f7             	mov    %r14,%rdi
  6fe319:	e8 22 b0 02 00       	call   729340 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe31e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe323:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  6fe32a:	48 8b 9c 24 a8 00 00 	mov    0xa8(%rsp),%rbx
  6fe331:	00 
  6fe332:	48 8b 03             	mov    (%rbx),%rax
  6fe335:	48 85 c0             	test   %rax,%rax
  6fe338:	74 05                	je     6fe33f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4af>
  6fe33a:	48 89 ef             	mov    %rbp,%rdi
  6fe33d:	ff d0                	call   *%rax
  6fe33f:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe343:	48 85 f6             	test   %rsi,%rsi
  6fe346:	0f 84 a6 00 00 00    	je     6fe3f2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x562>
  6fe34c:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe350:	48 89 ef             	mov    %rbp,%rdi
  6fe353:	ff 15 ef af 42 00    	call   *0x42afef(%rip)        # b29348 <_DYNAMIC+0x248>
  6fe359:	e9 94 00 00 00       	jmp    6fe3f2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x562>
  6fe35e:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fe365:	00 
  6fe366:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fe36b:	48 89 41 30          	mov    %rax,0x30(%rcx)
  6fe36f:	0f 10 84 24 98 00 00 	movups 0x98(%rsp),%xmm0
  6fe376:	00 
  6fe377:	0f 10 8c 24 a8 00 00 	movups 0xa8(%rsp),%xmm1
  6fe37e:	00 
  6fe37f:	0f 10 94 24 b8 00 00 	movups 0xb8(%rsp),%xmm2
  6fe386:	00 
  6fe387:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  6fe38b:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  6fe38f:	0f 11 01             	movups %xmm0,(%rcx)
  6fe392:	eb 5e                	jmp    6fe3f2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x562>
  6fe394:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  6fe39b:	00 
  6fe39c:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  6fe3a3:	00 
  6fe3a4:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fe3ab:	00 
  6fe3ac:	74 0e                	je     6fe3bc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x52c>
  6fe3ae:	84 c0                	test   %al,%al
  6fe3b0:	74 0e                	je     6fe3c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x530>
  6fe3b2:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fe3b9:	ff 
  6fe3ba:	75 04                	jne    6fe3c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x530>
  6fe3bc:	31 c9                	xor    %ecx,%ecx
  6fe3be:	eb 0c                	jmp    6fe3cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x53c>
  6fe3c0:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fe3c7:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fe3cc:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fe3d3:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fe3d8:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  6fe3dc:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  6fe3e0:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  6fe3e4:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  6fe3e8:	88 47 30             	mov    %al,0x30(%rdi)
  6fe3eb:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  6fe3f2:	48 81 c4 38 01 00 00 	add    $0x138,%rsp
  6fe3f9:	5b                   	pop    %rbx
  6fe3fa:	41 5c                	pop    %r12
  6fe3fc:	41 5d                	pop    %r13
  6fe3fe:	41 5e                	pop    %r14
  6fe400:	41 5f                	pop    %r15
  6fe402:	5d                   	pop    %rbp
  6fe403:	c3                   	ret
  6fe404:	48 8d 3d 5a 98 96 ff 	lea    -0x6967a6(%rip),%rdi        # 67c65 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x988>
  6fe40b:	48 8d 15 fe c8 3f 00 	lea    0x3fc8fe(%rip),%rdx        # afad10 <__frame_dummy_init_array_entry+0x478>
  6fe412:	be 0e 00 00 00       	mov    $0xe,%esi
  6fe417:	ff 15 2b b0 42 00    	call   *0x42b02b(%rip)        # b29448 <_DYNAMIC+0x348>
  6fe41d:	4d 89 e7             	mov    %r12,%r15
  6fe420:	41 bc 1f 00 00 00    	mov    $0x1f,%r12d
  6fe426:	e9 02 fe ff ff       	jmp    6fe22d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x39d>
  6fe42b:	48 8d 15 c6 c8 3f 00 	lea    0x3fc8c6(%rip),%rdx        # afacf8 <__frame_dummy_init_array_entry+0x460>
  6fe432:	4c 89 e7             	mov    %r12,%rdi
  6fe435:	ff 15 1d b0 42 00    	call   *0x42b01d(%rip)        # b29458 <_DYNAMIC+0x358>
  6fe43b:	49 89 c6             	mov    %rax,%r14
  6fe43e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe442:	48 85 f6             	test   %rsi,%rsi
  6fe445:	74 0d                	je     6fe454 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5c4>
  6fe447:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe44b:	48 89 ef             	mov    %rbp,%rdi
  6fe44e:	ff 15 f4 ae 42 00    	call   *0x42aef4(%rip)        # b29348 <_DYNAMIC+0x248>
  6fe454:	4c 89 f7             	mov    %r14,%rdi
  6fe457:	e8 84 b0 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fe45c:	49 89 c5             	mov    %rax,%r13
  6fe45f:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe463:	74 46                	je     6fe4ab <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x61b>
  6fe465:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fe46a:	e8 71 9b ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe46f:	eb 3a                	jmp    6fe4ab <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x61b>
  6fe471:	49 89 c6             	mov    %rax,%r14
  6fe474:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe478:	48 85 f6             	test   %rsi,%rsi
  6fe47b:	74 0d                	je     6fe48a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5fa>
  6fe47d:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe481:	4c 89 ff             	mov    %r15,%rdi
  6fe484:	ff 15 be ae 42 00    	call   *0x42aebe(%rip)        # b29348 <_DYNAMIC+0x248>
  6fe48a:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fe48f:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fe494:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fe499:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fe49e:	eb 7c                	jmp    6fe51c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x68c>
  6fe4a0:	49 89 c6             	mov    %rax,%r14
  6fe4a3:	eb 77                	jmp    6fe51c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x68c>
  6fe4a5:	4d 89 e7             	mov    %r12,%r15
  6fe4a8:	49 89 c5             	mov    %rax,%r13
  6fe4ab:	4c 89 ef             	mov    %r13,%rdi
  6fe4ae:	ff 15 b4 af 42 00    	call   *0x42afb4(%rip)        # b29468 <_DYNAMIC+0x368>
  6fe4b4:	48 89 c5             	mov    %rax,%rbp
  6fe4b7:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  6fe4be:	00 
  6fe4bf:	48 89 94 24 a8 00 00 	mov    %rdx,0xa8(%rsp)
  6fe4c6:	00 
  6fe4c7:	48 c7 84 24 98 00 00 	movq   $0xfffffffffffffffd,0x98(%rsp)
  6fe4ce:	00 fd ff ff ff 
  6fe4d3:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fe4d8:	4d 89 fc             	mov    %r15,%r12
  6fe4db:	49 c7 c5 fd ff ff ff 	mov    $0xfffffffffffffffd,%r13
  6fe4e2:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe4e9:	49 39 f4             	cmp    %rsi,%r12
  6fe4ec:	0f 82 98 fd ff ff    	jb     6fe28a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3fa>
  6fe4f2:	48 8d 15 2f c8 3f 00 	lea    0x3fc82f(%rip),%rdx        # afad28 <__frame_dummy_init_array_entry+0x490>
  6fe4f9:	4c 89 e7             	mov    %r12,%rdi
  6fe4fc:	ff 15 56 af 42 00    	call   *0x42af56(%rip)        # b29458 <_DYNAMIC+0x358>
  6fe502:	0f 0b                	ud2
  6fe504:	ff 15 66 af 42 00    	call   *0x42af66(%rip)        # b29470 <_DYNAMIC+0x370>
  6fe50a:	49 89 c6             	mov    %rax,%r14
  6fe50d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  6fe512:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fe517:	e8 44 64 ff ff       	call   6f4960 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  6fe51c:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fe520:	74 1f                	je     6fe541 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6b1>
  6fe522:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fe526:	0f 84 28 ff ff ff    	je     6fe454 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5c4>
  6fe52c:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  6fe533:	00 
  6fe534:	e8 a7 9a ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe539:	4c 89 f7             	mov    %r14,%rdi
  6fe53c:	e8 9f af 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fe541:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  6fe548:	00 
  6fe549:	e8 b2 68 ff ff       	call   6f4e00 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe54e:	e9 01 ff ff ff       	jmp    6fe454 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5c4>
  6fe553:	ff 15 1f ae 42 00    	call   *0x42ae1f(%rip)        # b29378 <_DYNAMIC+0x278>

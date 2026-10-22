
/tmp/gpui-contained-property-exchange-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d450 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property>:
  78d450:	41 57                	push   %r15
  78d452:	41 56                	push   %r14
  78d454:	41 55                	push   %r13
  78d456:	41 54                	push   %r12
  78d458:	53                   	push   %rbx
  78d459:	48 83 ec 60          	sub    $0x60,%rsp
  78d45d:	48 89 fb             	mov    %rdi,%rbx
  78d460:	49 bc 5c 34 db 26 16 	movabs $0xe178eb1626db345c,%r12
  78d467:	eb 78 e1 
  78d46a:	49 bd 93 91 70 3a 44 	movabs $0xf7f7cc443a709193,%r13
  78d471:	cc f7 f7 
  78d474:	83 3a 01             	cmpl   $0x1,(%rdx)
  78d477:	75 39                	jne    78d4b2 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0x62>
  78d479:	4c 8b 72 08          	mov    0x8(%rdx),%r14
  78d47d:	4c 8b 7a 10          	mov    0x10(%rdx),%r15
  78d481:	48 8b 42 18          	mov    0x18(%rdx),%rax
  78d485:	48 89 e7             	mov    %rsp,%rdi
  78d488:	4c 89 fe             	mov    %r15,%rsi
  78d48b:	ff 50 18             	call   *0x18(%rax)
  78d48e:	4c 33 64 24 08       	xor    0x8(%rsp),%r12
  78d493:	4c 33 2c 24          	xor    (%rsp),%r13
  78d497:	4d 09 e5             	or     %r12,%r13
  78d49a:	b8 01 00 00 00       	mov    $0x1,%eax
  78d49f:	0f 85 90 00 00 00    	jne    78d535 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0xe5>
  78d4a5:	4c 89 ff             	mov    %r15,%rdi
  78d4a8:	4c 89 f6             	mov    %r14,%rsi
  78d4ab:	e8 50 37 ff ff       	call   780c00 <<property_actions::property_workbench::value_entry::ValueEntry>::applied_logically>
  78d4b0:	eb 7c                	jmp    78d52e <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0xde>
  78d4b2:	4c 8b 72 08          	mov    0x8(%rdx),%r14
  78d4b6:	48 8b 42 10          	mov    0x10(%rdx),%rax
  78d4ba:	4c 8b 7a 18          	mov    0x18(%rdx),%r15
  78d4be:	48 89 e7             	mov    %rsp,%rdi
  78d4c1:	4c 89 f6             	mov    %r14,%rsi
  78d4c4:	ff 50 18             	call   *0x18(%rax)
  78d4c7:	4c 33 64 24 08       	xor    0x8(%rsp),%r12
  78d4cc:	4c 33 2c 24          	xor    (%rsp),%r13
  78d4d0:	4d 09 e5             	or     %r12,%r13
  78d4d3:	b8 01 00 00 00       	mov    $0x1,%eax
  78d4d8:	75 5b                	jne    78d535 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0xe5>
  78d4da:	48 89 e7             	mov    %rsp,%rdi
  78d4dd:	4c 89 f6             	mov    %r14,%rsi
  78d4e0:	e8 9b 31 ff ff       	call   780680 <<property_actions::property_workbench::value_entry::ValueEntry>::contribution>
  78d4e5:	0f b7 44 24 10       	movzwl 0x10(%rsp),%eax
  78d4ea:	66 85 c0             	test   %ax,%ax
  78d4ed:	74 1d                	je     78d50c <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0xbc>
  78d4ef:	0f 10 04 24          	movups (%rsp),%xmm0
  78d4f3:	0f 10 4c 24 12       	movups 0x12(%rsp),%xmm1
  78d4f8:	0f 10 54 24 20       	movups 0x20(%rsp),%xmm2
  78d4fd:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  78d502:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  78d507:	0f 11 54 24 3e       	movups %xmm2,0x3e(%rsp)
  78d50c:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  78d511:	41 0f 11 07          	movups %xmm0,(%r15)
  78d515:	66 41 89 47 10       	mov    %ax,0x10(%r15)
  78d51a:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  78d51f:	41 0f 11 47 12       	movups %xmm0,0x12(%r15)
  78d524:	0f 10 44 24 3e       	movups 0x3e(%rsp),%xmm0
  78d529:	41 0f 11 47 20       	movups %xmm0,0x20(%r15)
  78d52e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  78d535:	48 89 03             	mov    %rax,(%rbx)
  78d538:	48 89 d8             	mov    %rbx,%rax
  78d53b:	48 83 c4 60          	add    $0x60,%rsp
  78d53f:	5b                   	pop    %rbx
  78d540:	41 5c                	pop    %r12
  78d542:	41 5d                	pop    %r13
  78d544:	41 5e                	pop    %r14
  78d546:	41 5f                	pop    %r15
  78d548:	c3                   	ret

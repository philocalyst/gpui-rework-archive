
/tmp/gpui-contained-property-exchange-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d390 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property>:
  78d390:	41 57                	push   %r15
  78d392:	41 56                	push   %r14
  78d394:	41 55                	push   %r13
  78d396:	41 54                	push   %r12
  78d398:	53                   	push   %rbx
  78d399:	48 83 ec 10          	sub    $0x10,%rsp
  78d39d:	48 89 fb             	mov    %rdi,%rbx
  78d3a0:	49 bc 5c 34 db 26 16 	movabs $0xe178eb1626db345c,%r12
  78d3a7:	eb 78 e1 
  78d3aa:	49 bd 93 91 70 3a 44 	movabs $0xf7f7cc443a709193,%r13
  78d3b1:	cc f7 f7 
  78d3b4:	83 3a 01             	cmpl   $0x1,(%rdx)
  78d3b7:	75 35                	jne    78d3ee <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0x5e>
  78d3b9:	4c 8b 72 08          	mov    0x8(%rdx),%r14
  78d3bd:	4c 8b 7a 10          	mov    0x10(%rdx),%r15
  78d3c1:	48 8b 42 18          	mov    0x18(%rdx),%rax
  78d3c5:	48 89 e7             	mov    %rsp,%rdi
  78d3c8:	4c 89 fe             	mov    %r15,%rsi
  78d3cb:	ff 50 18             	call   *0x18(%rax)
  78d3ce:	4c 33 64 24 08       	xor    0x8(%rsp),%r12
  78d3d3:	4c 33 2c 24          	xor    (%rsp),%r13
  78d3d7:	4d 09 e5             	or     %r12,%r13
  78d3da:	b8 01 00 00 00       	mov    $0x1,%eax
  78d3df:	75 5b                	jne    78d43c <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0xac>
  78d3e1:	4c 89 ff             	mov    %r15,%rdi
  78d3e4:	4c 89 f6             	mov    %r14,%rsi
  78d3e7:	e8 14 38 ff ff       	call   780c00 <<property_actions::property_workbench::value_entry::ValueEntry>::applied_logically>
  78d3ec:	eb 47                	jmp    78d435 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0xa5>
  78d3ee:	4c 8b 72 08          	mov    0x8(%rdx),%r14
  78d3f2:	48 8b 42 10          	mov    0x10(%rdx),%rax
  78d3f6:	4c 8b 7a 18          	mov    0x18(%rdx),%r15
  78d3fa:	48 89 e7             	mov    %rsp,%rdi
  78d3fd:	4c 89 f6             	mov    %r14,%rsi
  78d400:	ff 50 18             	call   *0x18(%rax)
  78d403:	4c 33 64 24 08       	xor    0x8(%rsp),%r12
  78d408:	4c 33 2c 24          	xor    (%rsp),%r13
  78d40c:	4d 09 e5             	or     %r12,%r13
  78d40f:	b8 01 00 00 00       	mov    $0x1,%eax
  78d414:	75 26                	jne    78d43c <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0xac>
  78d416:	41 0f b7 46 48       	movzwl 0x48(%r14),%eax
  78d41b:	66 85 c0             	test   %ax,%ax
  78d41e:	74 07                	je     78d427 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0x97>
  78d420:	41 0f 10 46 38       	movups 0x38(%r14),%xmm0
  78d425:	eb 00                	jmp    78d427 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::property+0x97>
  78d427:	41 0f 11 07          	movups %xmm0,(%r15)
  78d42b:	66 41 89 47 10       	mov    %ax,0x10(%r15)
  78d430:	41 c6 47 14 ff       	movb   $0xff,0x14(%r15)
  78d435:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  78d43c:	48 89 03             	mov    %rax,(%rbx)
  78d43f:	48 89 d8             	mov    %rbx,%rax
  78d442:	48 83 c4 10          	add    $0x10,%rsp
  78d446:	5b                   	pop    %rbx
  78d447:	41 5c                	pop    %r12
  78d449:	41 5d                	pop    %r13
  78d44b:	41 5e                	pop    %r14
  78d44d:	41 5f                	pop    %r15
  78d44f:	c3                   	ret

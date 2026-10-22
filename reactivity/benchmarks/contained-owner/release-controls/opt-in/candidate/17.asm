
/tmp/gpui-contained-owner-spike-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d680 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::proposal>:
  78d680:	41 56                	push   %r14
  78d682:	53                   	push   %rbx
  78d683:	48 83 ec 18          	sub    $0x18,%rsp
  78d687:	49 89 d6             	mov    %rdx,%r14
  78d68a:	48 89 fb             	mov    %rdi,%rbx
  78d68d:	48 89 e7             	mov    %rsp,%rdi
  78d690:	48 89 d6             	mov    %rdx,%rsi
  78d693:	ff 51 18             	call   *0x18(%rcx)
  78d696:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d69b:	66 0f 74 05 ed 1d 8d 	pcmpeqb -0x72e213(%rip),%xmm0        # 5f490 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1510>
  78d6a2:	ff 
  78d6a3:	66 0f d7 c0          	pmovmskb %xmm0,%eax
  78d6a7:	3d ff ff 00 00       	cmp    $0xffff,%eax
  78d6ac:	75 12                	jne    78d6c0 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::proposal+0x40>
  78d6ae:	41 0f b7 46 48       	movzwl 0x48(%r14),%eax
  78d6b3:	66 85 c0             	test   %ax,%ax
  78d6b6:	74 18                	je     78d6d0 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::proposal+0x50>
  78d6b8:	f3 41 0f 6f 46 38    	movdqu 0x38(%r14),%xmm0
  78d6be:	eb 10                	jmp    78d6d0 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::proposal+0x50>
  78d6c0:	48 c7 43 18 01 00 00 	movq   $0x1,0x18(%rbx)
  78d6c7:	00 
  78d6c8:	66 c7 43 10 ff ff    	movw   $0xffff,0x10(%rbx)
  78d6ce:	eb 0c                	jmp    78d6dc <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::proposal+0x5c>
  78d6d0:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  78d6d4:	66 89 43 10          	mov    %ax,0x10(%rbx)
  78d6d8:	c6 43 14 ff          	movb   $0xff,0x14(%rbx)
  78d6dc:	48 89 d8             	mov    %rbx,%rax
  78d6df:	48 83 c4 18          	add    $0x18,%rsp
  78d6e3:	5b                   	pop    %rbx
  78d6e4:	41 5e                	pop    %r14
  78d6e6:	c3                   	ret

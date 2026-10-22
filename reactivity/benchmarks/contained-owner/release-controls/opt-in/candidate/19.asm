
/tmp/gpui-contained-owner-spike-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d6f0 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::proposal>:
  78d6f0:	41 56                	push   %r14
  78d6f2:	53                   	push   %rbx
  78d6f3:	48 83 ec 38          	sub    $0x38,%rsp
  78d6f7:	49 89 d6             	mov    %rdx,%r14
  78d6fa:	48 89 fb             	mov    %rdi,%rbx
  78d6fd:	48 89 e7             	mov    %rsp,%rdi
  78d700:	48 89 d6             	mov    %rdx,%rsi
  78d703:	ff 51 18             	call   *0x18(%rcx)
  78d706:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d70b:	66 0f 74 05 7d 1d 8d 	pcmpeqb -0x72e283(%rip),%xmm0        # 5f490 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1510>
  78d712:	ff 
  78d713:	66 0f d7 c0          	pmovmskb %xmm0,%eax
  78d717:	3d ff ff 00 00       	cmp    $0xffff,%eax
  78d71c:	75 30                	jne    78d74e <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::proposal+0x5e>
  78d71e:	48 89 e7             	mov    %rsp,%rdi
  78d721:	4c 89 f6             	mov    %r14,%rsi
  78d724:	e8 47 32 ff ff       	call   780970 <<property_actions::property_workbench::value_entry::ValueEntry>::contribution>
  78d729:	66 83 7c 24 10 00    	cmpw   $0x0,0x10(%rsp)
  78d72f:	74 2d                	je     78d75e <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::proposal+0x6e>
  78d731:	f3 0f 6f 04 24       	movdqu (%rsp),%xmm0
  78d736:	0f 10 4c 24 10       	movups 0x10(%rsp),%xmm1
  78d73b:	0f 10 54 24 20       	movups 0x20(%rsp),%xmm2
  78d740:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  78d744:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  78d748:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  78d74c:	eb 16                	jmp    78d764 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::proposal+0x74>
  78d74e:	48 c7 43 18 01 00 00 	movq   $0x1,0x18(%rbx)
  78d755:	00 
  78d756:	66 c7 43 10 ff ff    	movw   $0xffff,0x10(%rbx)
  78d75c:	eb 06                	jmp    78d764 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::proposal, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::proposal+0x74>
  78d75e:	66 c7 43 10 00 00    	movw   $0x0,0x10(%rbx)
  78d764:	48 89 d8             	mov    %rbx,%rax
  78d767:	48 83 c4 38          	add    $0x38,%rsp
  78d76b:	5b                   	pop    %rbx
  78d76c:	41 5e                	pop    %r14
  78d76e:	c3                   	ret


/tmp/gpui-contained-owner-spike-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d5b0 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::applied_logically>:
  78d5b0:	41 57                	push   %r15
  78d5b2:	41 56                	push   %r14
  78d5b4:	53                   	push   %rbx
  78d5b5:	48 83 ec 10          	sub    $0x10,%rsp
  78d5b9:	4d 89 c6             	mov    %r8,%r14
  78d5bc:	49 89 d7             	mov    %rdx,%r15
  78d5bf:	48 89 fb             	mov    %rdi,%rbx
  78d5c2:	48 89 e7             	mov    %rsp,%rdi
  78d5c5:	48 89 d6             	mov    %rdx,%rsi
  78d5c8:	ff 51 18             	call   *0x18(%rcx)
  78d5cb:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d5d0:	66 0f 74 05 b8 1e 8d 	pcmpeqb -0x72e148(%rip),%xmm0        # 5f490 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1510>
  78d5d7:	ff 
  78d5d8:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  78d5dc:	b8 01 00 00 00       	mov    $0x1,%eax
  78d5e1:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  78d5e7:	75 12                	jne    78d5fb <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::applied_logically+0x4b>
  78d5e9:	4c 89 ff             	mov    %r15,%rdi
  78d5ec:	4c 89 f6             	mov    %r14,%rsi
  78d5ef:	e8 fc 38 ff ff       	call   780ef0 <<property_actions::property_workbench::value_entry::ValueEntry>::applied_logically>
  78d5f4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  78d5fb:	48 89 03             	mov    %rax,(%rbx)
  78d5fe:	48 89 d8             	mov    %rbx,%rax
  78d601:	48 83 c4 10          	add    $0x10,%rsp
  78d605:	5b                   	pop    %rbx
  78d606:	41 5e                	pop    %r14
  78d608:	41 5f                	pop    %r15
  78d60a:	c3                   	ret

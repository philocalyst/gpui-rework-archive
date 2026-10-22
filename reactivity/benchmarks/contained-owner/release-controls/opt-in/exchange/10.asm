
/tmp/gpui-contained-property-exchange-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d320 <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::admit>:
  78d320:	53                   	push   %rbx
  78d321:	48 83 ec 10          	sub    $0x10,%rsp
  78d325:	48 89 fb             	mov    %rdi,%rbx
  78d328:	48 89 e7             	mov    %rsp,%rdi
  78d32b:	48 89 d6             	mov    %rdx,%rsi
  78d32e:	ff 51 18             	call   *0x18(%rcx)
  78d331:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d336:	66 0f 74 05 02 20 8d 	pcmpeqb -0x72dffe(%rip),%xmm0        # 5f340 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1510>
  78d33d:	ff 
  78d33e:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  78d342:	b8 01 00 00 00       	mov    $0x1,%eax
  78d347:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  78d34d:	75 0d                	jne    78d35c <<gpui::element::PropertyRoute<property_actions::property_workbench::value_entry::ValueEntry, <property_actions::property_workbench::value_entry::ValueEntry>::inherit, <property_actions::property_workbench::value_entry::ValueEntry>::applied_logically> as gpui::element::Route>::admit+0x3c>
  78d34f:	66 c7 43 08 02 00    	movw   $0x2,0x8(%rbx)
  78d355:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  78d35c:	48 89 03             	mov    %rax,(%rbx)
  78d35f:	48 89 d8             	mov    %rbx,%rax
  78d362:	48 83 c4 10          	add    $0x10,%rsp
  78d366:	5b                   	pop    %rbx
  78d367:	c3                   	ret

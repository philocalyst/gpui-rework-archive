
/tmp/gpui-ack-query-comparison/a/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a7dbc0 <<gpui::runtime::query::Part>::target>:
  a7dbc0:	50                   	push   %rax
  a7dbc1:	89 f0                	mov    %esi,%eax
  a7dbc3:	48 8b 77 38          	mov    0x38(%rdi),%rsi
  a7dbc7:	48 39 c6             	cmp    %rax,%rsi
  a7dbca:	76 38                	jbe    a7dc04 <<gpui::runtime::query::Part>::target+0x44>
  a7dbcc:	48 8b 4f 30          	mov    0x30(%rdi),%rcx
  a7dbd0:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  a7dbd4:	48 c1 e0 04          	shl    $0x4,%rax
  a7dbd8:	48 8b 54 01 20       	mov    0x20(%rcx,%rax,1),%rdx
  a7dbdd:	48 85 d2             	test   %rdx,%rdx
  a7dbe0:	74 09                	je     a7dbeb <<gpui::runtime::query::Part>::target+0x2b>
  a7dbe2:	48 8b 47 28          	mov    0x28(%rdi),%rax
  a7dbe6:	48 8b 00             	mov    (%rax),%rax
  a7dbe9:	59                   	pop    %rcx
  a7dbea:	c3                   	ret
  a7dbeb:	48 8d 3d ee c9 70 ff 	lea    -0x8f3612(%rip),%rdi        # 18a5e0 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.57.llvm.11816638417077940530>
  a7dbf2:	48 8d 15 97 52 a4 00 	lea    0xa45297(%rip),%rdx        # 14c2e90 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.58.llvm.11816638417077940530>
  a7dbf9:	be 20 00 00 00       	mov    $0x20,%esi
  a7dbfe:	ff 15 14 23 ab 00    	call   *0xab2314(%rip)        # 152ff18 <_DYNAMIC+0x378>
  a7dc04:	48 8d 15 05 52 a4 00 	lea    0xa45205(%rip),%rdx        # 14c2e10 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.24.llvm.11816638417077940530>
  a7dc0b:	48 89 c7             	mov    %rax,%rdi
  a7dc0e:	ff 15 3c 22 ab 00    	call   *0xab223c(%rip)        # 152fe50 <_DYNAMIC+0x2b0>

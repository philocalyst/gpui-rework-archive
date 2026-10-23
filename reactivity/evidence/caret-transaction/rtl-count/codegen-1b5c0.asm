
/tmp/gpui-caret-transaction-bin/d54-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001b5c0 <transaction_codegen::flag_count>:
   1b5c0:	48 83 ec 38          	sub    $0x38,%rsp
   1b5c4:	48 89 f8             	mov    %rdi,%rax
   1b5c7:	4c 8b 1f             	mov    (%rdi),%r11
   1b5ca:	8b 7f 28             	mov    0x28(%rdi),%edi
   1b5cd:	49 8b 73 58          	mov    0x58(%r11),%rsi
   1b5d1:	48 39 fe             	cmp    %rdi,%rsi
   1b5d4:	0f 86 89 00 00 00    	jbe    1b663 <transaction_codegen::flag_count+0xa3>
   1b5da:	49 8b 4b 68          	mov    0x68(%r11),%rcx
   1b5de:	49 8b 53 70          	mov    0x70(%r11),%rdx
   1b5e2:	49 8b b3 80 00 00 00 	mov    0x80(%r11),%rsi
   1b5e9:	4d 8b 83 88 00 00 00 	mov    0x88(%r11),%r8
   1b5f0:	4d 8b 8b 98 00 00 00 	mov    0x98(%r11),%r9
   1b5f7:	4d 8b 93 a0 00 00 00 	mov    0xa0(%r11),%r10
   1b5fe:	48 8b 40 18          	mov    0x18(%rax),%rax
   1b602:	48 85 c0             	test   %rax,%rax
   1b605:	74 0a                	je     1b611 <transaction_codegen::flag_count+0x51>
   1b607:	48 8d 78 18          	lea    0x18(%rax),%rdi
   1b60b:	48 83 c0 1c          	add    $0x1c,%rax
   1b60f:	eb 1b                	jmp    1b62c <transaction_codegen::flag_count+0x6c>
   1b611:	4d 8b 5b 50          	mov    0x50(%r11),%r11
   1b615:	48 8d 3c ff          	lea    (%rdi,%rdi,8),%rdi
   1b619:	48 c1 e7 04          	shl    $0x4,%rdi
   1b61d:	49 8d 04 3b          	lea    (%r11,%rdi,1),%rax
   1b621:	48 83 c0 54          	add    $0x54,%rax
   1b625:	4c 01 df             	add    %r11,%rdi
   1b628:	48 83 c7 50          	add    $0x50,%rdi
   1b62c:	8b 00                	mov    (%rax),%eax
   1b62e:	8b 3f                	mov    (%rdi),%edi
   1b630:	48 89 0c 24          	mov    %rcx,(%rsp)
   1b634:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   1b639:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
   1b63e:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
   1b643:	4c 89 4c 24 20       	mov    %r9,0x20(%rsp)
   1b648:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
   1b64d:	89 7c 24 30          	mov    %edi,0x30(%rsp)
   1b651:	89 44 24 34          	mov    %eax,0x34(%rsp)
   1b655:	48 89 e7             	mov    %rsp,%rdi
   1b658:	ff 15 da 4d 04 00    	call   *0x44dda(%rip)        # 60438 <_DYNAMIC+0x270>
   1b65e:	48 83 c4 38          	add    $0x38,%rsp
   1b662:	c3                   	ret
   1b663:	48 8d 15 be 2e 04 00 	lea    0x42ebe(%rip),%rdx        # 5e528 <anon.5cab36dad6fad55fc602ca21d50a03ec.34.llvm.18336280871641450522>
   1b66a:	ff 15 88 4d 04 00    	call   *0x44d88(%rip)        # 603f8 <_DYNAMIC+0x230>

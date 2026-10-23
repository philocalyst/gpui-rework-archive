
/tmp/gpui-caret-transaction-bin/62e-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001b560 <transaction_codegen::flag_count>:
   1b560:	48 83 ec 38          	sub    $0x38,%rsp
   1b564:	48 89 f8             	mov    %rdi,%rax
   1b567:	4c 8b 1f             	mov    (%rdi),%r11
   1b56a:	8b 7f 28             	mov    0x28(%rdi),%edi
   1b56d:	49 8b 73 58          	mov    0x58(%r11),%rsi
   1b571:	48 39 fe             	cmp    %rdi,%rsi
   1b574:	0f 86 89 00 00 00    	jbe    1b603 <transaction_codegen::flag_count+0xa3>
   1b57a:	49 8b 4b 68          	mov    0x68(%r11),%rcx
   1b57e:	49 8b 53 70          	mov    0x70(%r11),%rdx
   1b582:	49 8b b3 80 00 00 00 	mov    0x80(%r11),%rsi
   1b589:	4d 8b 83 88 00 00 00 	mov    0x88(%r11),%r8
   1b590:	4d 8b 8b 98 00 00 00 	mov    0x98(%r11),%r9
   1b597:	4d 8b 93 a0 00 00 00 	mov    0xa0(%r11),%r10
   1b59e:	48 8b 40 18          	mov    0x18(%rax),%rax
   1b5a2:	48 85 c0             	test   %rax,%rax
   1b5a5:	74 0a                	je     1b5b1 <transaction_codegen::flag_count+0x51>
   1b5a7:	48 8d 78 18          	lea    0x18(%rax),%rdi
   1b5ab:	48 83 c0 1c          	add    $0x1c,%rax
   1b5af:	eb 1b                	jmp    1b5cc <transaction_codegen::flag_count+0x6c>
   1b5b1:	4d 8b 5b 50          	mov    0x50(%r11),%r11
   1b5b5:	48 8d 3c ff          	lea    (%rdi,%rdi,8),%rdi
   1b5b9:	48 c1 e7 04          	shl    $0x4,%rdi
   1b5bd:	49 8d 04 3b          	lea    (%r11,%rdi,1),%rax
   1b5c1:	48 83 c0 54          	add    $0x54,%rax
   1b5c5:	4c 01 df             	add    %r11,%rdi
   1b5c8:	48 83 c7 50          	add    $0x50,%rdi
   1b5cc:	8b 00                	mov    (%rax),%eax
   1b5ce:	8b 3f                	mov    (%rdi),%edi
   1b5d0:	48 89 0c 24          	mov    %rcx,(%rsp)
   1b5d4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   1b5d9:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
   1b5de:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
   1b5e3:	4c 89 4c 24 20       	mov    %r9,0x20(%rsp)
   1b5e8:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
   1b5ed:	89 7c 24 30          	mov    %edi,0x30(%rsp)
   1b5f1:	89 44 24 34          	mov    %eax,0x34(%rsp)
   1b5f5:	48 89 e7             	mov    %rsp,%rdi
   1b5f8:	ff 15 8a 4d 04 00    	call   *0x44d8a(%rip)        # 60388 <_DYNAMIC+0x270>
   1b5fe:	48 83 c4 38          	add    $0x38,%rsp
   1b602:	c3                   	ret
   1b603:	48 8d 15 6e 2e 04 00 	lea    0x42e6e(%rip),%rdx        # 5e478 <anon.5cab36dad6fad55fc602ca21d50a03ec.34.llvm.4639087895861959750>
   1b60a:	ff 15 38 4d 04 00    	call   *0x44d38(%rip)        # 60348 <_DYNAMIC+0x230>

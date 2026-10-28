
/tmp/gpui-validated-lookup-fixture-c3efc492061db3873f7eeb9b46e616c49d2158184564f5cee1101cbe8be1dc0b:     file format elf64-x86-64


Disassembly of section .text:

00000000004d8000 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018>:
  4d8000:	53                   	push   %rbx
  4d8001:	41 b9 11 00 00 00    	mov    $0x11,%r9d
  4d8007:	48 3b 96 a8 07 00 00 	cmp    0x7a8(%rsi),%rdx
  4d800e:	0f 85 6e 01 00 00    	jne    4d8182 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x182>
  4d8014:	80 be 6a 09 00 00 01 	cmpb   $0x1,0x96a(%rsi)
  4d801b:	0f 85 61 01 00 00    	jne    4d8182 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x182>
  4d8021:	48 8b 86 c0 07 00 00 	mov    0x7c0(%rsi),%rax
  4d8028:	48 85 c0             	test   %rax,%rax
  4d802b:	0f 84 51 01 00 00    	je     4d8182 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x182>
  4d8031:	48 8b 96 c8 07 00 00 	mov    0x7c8(%rsi),%rdx
  4d8038:	44 0f b7 90 ba 00 00 	movzwl 0xba(%rax),%r10d
  4d803f:	00 
  4d8040:	45 89 d3             	mov    %r10d,%r11d
  4d8043:	41 c1 e3 03          	shl    $0x3,%r11d
  4d8047:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  4d804e:	66 90                	xchg   %ax,%ax
  4d8050:	4d 85 db             	test   %r11,%r11
  4d8053:	74 22                	je     4d8077 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x77>
  4d8055:	4a 3b 4c c0 10       	cmp    0x10(%rax,%r8,8),%rcx
  4d805a:	0f 97 c3             	seta   %bl
  4d805d:	80 db 00             	sbb    $0x0,%bl
  4d8060:	49 ff c0             	inc    %r8
  4d8063:	49 83 c3 f8          	add    $0xfffffffffffffff8,%r11
  4d8067:	80 fb 01             	cmp    $0x1,%bl
  4d806a:	74 e4                	je     4d8050 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x50>
  4d806c:	44 0f b6 d3          	movzbl %bl,%r10d
  4d8070:	45 85 d2             	test   %r10d,%r10d
  4d8073:	74 19                	je     4d808e <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x8e>
  4d8075:	eb 03                	jmp    4d807a <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x7a>
  4d8077:	4d 89 d0             	mov    %r10,%r8
  4d807a:	48 83 ea 01          	sub    $0x1,%rdx
  4d807e:	0f 82 fe 00 00 00    	jb     4d8182 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x182>
  4d8084:	4a 8b 84 c0 c0 00 00 	mov    0xc0(%rax,%r8,8),%rax
  4d808b:	00 
  4d808c:	eb aa                	jmp    4d8038 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x38>
  4d808e:	4a 8b 54 c0 60       	mov    0x60(%rax,%r8,8),%rdx
  4d8093:	48 83 be 38 08 00 00 	cmpq   $0x0,0x838(%rsi)
  4d809a:	00 
  4d809b:	0f 84 d2 00 00 00    	je     4d8173 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x173>
  4d80a1:	48 8b 86 c8 02 00 00 	mov    0x2c8(%rsi),%rax
  4d80a8:	48 39 c2             	cmp    %rax,%rdx
  4d80ab:	0f 83 d6 00 00 00    	jae    4d8187 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x187>
  4d80b1:	4c 8b 96 c0 02 00 00 	mov    0x2c0(%rsi),%r10
  4d80b8:	41 bb ff ff ff ff    	mov    $0xffffffff,%r11d
  4d80be:	49 89 d0             	mov    %rdx,%r8
  4d80c1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  4d80c8:	0f 1f 84 00 00 00 00 
  4d80cf:	00 
  4d80d0:	4f 8d 04 80          	lea    (%r8,%r8,4),%r8
  4d80d4:	43 8b 5c c2 20       	mov    0x20(%r10,%r8,8),%ebx
  4d80d9:	83 e3 07             	and    $0x7,%ebx
  4d80dc:	83 fb 05             	cmp    $0x5,%ebx
  4d80df:	73 1b                	jae    4d80fc <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0xfc>
  4d80e1:	4f 8d 04 c2          	lea    (%r10,%r8,8),%r8
  4d80e5:	45 8b 40 18          	mov    0x18(%r8),%r8d
  4d80e9:	4d 39 d8             	cmp    %r11,%r8
  4d80ec:	0f 84 81 00 00 00    	je     4d8173 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x173>
  4d80f2:	4c 39 c0             	cmp    %r8,%rax
  4d80f5:	77 d9                	ja     4d80d0 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0xd0>
  4d80f7:	e9 8e 00 00 00       	jmp    4d818a <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x18a>
  4d80fc:	74 1e                	je     4d811c <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x11c>
  4d80fe:	83 fb 06             	cmp    $0x6,%ebx
  4d8101:	74 de                	je     4d80e1 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0xe1>
  4d8103:	48 8d 3d da f4 b6 ff 	lea    -0x490b26(%rip),%rdi        # 475e4 <anon.4aabc4744470660875e0a48c481e6222.49.llvm.16348402748963727018+0x80>
  4d810a:	48 8d 15 07 43 2c 00 	lea    0x2c4307(%rip),%rdx        # 79c418 <anon.4aabc4744470660875e0a48c481e6222.57.llvm.16348402748963727018+0x60>
  4d8111:	be a1 00 00 00       	mov    $0xa1,%esi
  4d8116:	ff 15 04 5b 2e 00    	call   *0x2e5b04(%rip)        # 7bdc20 <_DYNAMIC+0x2a0>
  4d811c:	48 8d 86 68 07 00 00 	lea    0x768(%rsi),%rax
  4d8123:	4c 8d 86 50 07 00 00 	lea    0x750(%rsi),%r8
  4d812a:	4c 8d 96 70 07 00 00 	lea    0x770(%rsi),%r10
  4d8131:	4c 8d 9e 58 07 00 00 	lea    0x758(%rsi),%r11
  4d8138:	48 83 be 60 07 00 00 	cmpq   $0xffffffffffffffff,0x760(%rsi)
  4d813f:	ff 
  4d8140:	49 0f 44 c0          	cmove  %r8,%rax
  4d8144:	4d 0f 45 da          	cmovne %r10,%r11
  4d8148:	49 8b 33             	mov    (%r11),%rsi
  4d814b:	48 8b 00             	mov    (%rax),%rax
  4d814e:	48 c1 e6 04          	shl    $0x4,%rsi
  4d8152:	48 8d 34 b6          	lea    (%rsi,%rsi,4),%rsi
  4d8156:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  4d815d:	00 00 00 
  4d8160:	48 85 f6             	test   %rsi,%rsi
  4d8163:	74 1d                	je     4d8182 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x182>
  4d8165:	48 83 c6 b0          	add    $0xffffffffffffffb0,%rsi
  4d8169:	48 39 48 20          	cmp    %rcx,0x20(%rax)
  4d816d:	48 8d 40 50          	lea    0x50(%rax),%rax
  4d8171:	75 ed                	jne    4d8160 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018+0x160>
  4d8173:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  4d8177:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  4d817b:	49 c7 c1 fe ff ff ff 	mov    $0xfffffffffffffffe,%r9
  4d8182:	4c 89 0f             	mov    %r9,(%rdi)
  4d8185:	5b                   	pop    %rbx
  4d8186:	c3                   	ret
  4d8187:	49 89 d0             	mov    %rdx,%r8
  4d818a:	48 8d 15 0f 42 2c 00 	lea    0x2c420f(%rip),%rdx        # 79c3a0 <anon.4aabc4744470660875e0a48c481e6222.53.llvm.16348402748963727018+0x30>
  4d8191:	4c 89 c7             	mov    %r8,%rdi
  4d8194:	48 89 c6             	mov    %rax,%rsi
  4d8197:	ff 15 a3 5a 2e 00    	call   *0x2e5aa3(%rip)        # 7bdc40 <_DYNAMIC+0x2c0>

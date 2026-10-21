
/tmp/gpui-option-lookup-fixture-52aecb98462de54c32e3c255ddfa3509a7bbed7c6a060852339e4ce8c4837262:     file format elf64-x86-64


Disassembly of section .text:

00000000004d7f70 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387>:
  4d7f70:	50                   	push   %rax
  4d7f71:	48 3b b7 a8 07 00 00 	cmp    0x7a8(%rdi),%rsi
  4d7f78:	75 77                	jne    4d7ff1 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x81>
  4d7f7a:	80 bf 6a 09 00 00 01 	cmpb   $0x1,0x96a(%rdi)
  4d7f81:	75 6e                	jne    4d7ff1 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x81>
  4d7f83:	48 8b 8f c0 07 00 00 	mov    0x7c0(%rdi),%rcx
  4d7f8a:	48 85 c9             	test   %rcx,%rcx
  4d7f8d:	74 62                	je     4d7ff1 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x81>
  4d7f8f:	48 8b b7 c8 07 00 00 	mov    0x7c8(%rdi),%rsi
  4d7f96:	31 c0                	xor    %eax,%eax
  4d7f98:	44 0f b7 89 ba 00 00 	movzwl 0xba(%rcx),%r9d
  4d7f9f:	00 
  4d7fa0:	45 89 ca             	mov    %r9d,%r10d
  4d7fa3:	41 c1 e2 03          	shl    $0x3,%r10d
  4d7fa7:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  4d7fae:	66 90                	xchg   %ax,%ax
  4d7fb0:	4d 85 d2             	test   %r10,%r10
  4d7fb3:	74 25                	je     4d7fda <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x6a>
  4d7fb5:	4a 3b 54 c1 10       	cmp    0x10(%rcx,%r8,8),%rdx
  4d7fba:	41 0f 97 c3          	seta   %r11b
  4d7fbe:	41 80 db 00          	sbb    $0x0,%r11b
  4d7fc2:	49 ff c0             	inc    %r8
  4d7fc5:	49 83 c2 f8          	add    $0xfffffffffffffff8,%r10
  4d7fc9:	41 80 fb 01          	cmp    $0x1,%r11b
  4d7fcd:	74 e1                	je     4d7fb0 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x40>
  4d7fcf:	45 0f b6 cb          	movzbl %r11b,%r9d
  4d7fd3:	45 85 c9             	test   %r9d,%r9d
  4d7fd6:	74 20                	je     4d7ff8 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x88>
  4d7fd8:	eb 03                	jmp    4d7fdd <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x6d>
  4d7fda:	4d 89 c8             	mov    %r9,%r8
  4d7fdd:	48 83 ee 01          	sub    $0x1,%rsi
  4d7fe1:	0f 82 f8 00 00 00    	jb     4d80df <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x16f>
  4d7fe7:	4a 8b 8c c1 c0 00 00 	mov    0xc0(%rcx,%r8,8),%rcx
  4d7fee:	00 
  4d7fef:	eb a7                	jmp    4d7f98 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x28>
  4d7ff1:	31 c0                	xor    %eax,%eax
  4d7ff3:	48 89 ca             	mov    %rcx,%rdx
  4d7ff6:	59                   	pop    %rcx
  4d7ff7:	c3                   	ret
  4d7ff8:	4a 8b 4c c1 60       	mov    0x60(%rcx,%r8,8),%rcx
  4d7ffd:	b8 01 00 00 00       	mov    $0x1,%eax
  4d8002:	48 83 bf 38 08 00 00 	cmpq   $0x0,0x838(%rdi)
  4d8009:	00 
  4d800a:	74 e7                	je     4d7ff3 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x83>
  4d800c:	48 8b b7 c8 02 00 00 	mov    0x2c8(%rdi),%rsi
  4d8013:	48 39 f1             	cmp    %rsi,%rcx
  4d8016:	0f 83 c8 00 00 00    	jae    4d80e4 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x174>
  4d801c:	4c 8b 8f c0 02 00 00 	mov    0x2c0(%rdi),%r9
  4d8023:	41 ba ff ff ff ff    	mov    $0xffffffff,%r10d
  4d8029:	49 89 c8             	mov    %rcx,%r8
  4d802c:	0f 1f 40 00          	nopl   0x0(%rax)
  4d8030:	4f 8d 04 80          	lea    (%r8,%r8,4),%r8
  4d8034:	47 8b 5c c1 20       	mov    0x20(%r9,%r8,8),%r11d
  4d8039:	41 83 e3 07          	and    $0x7,%r11d
  4d803d:	41 83 fb 05          	cmp    $0x5,%r11d
  4d8041:	73 17                	jae    4d805a <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0xea>
  4d8043:	4f 8d 04 c1          	lea    (%r9,%r8,8),%r8
  4d8047:	45 8b 40 18          	mov    0x18(%r8),%r8d
  4d804b:	4d 39 d0             	cmp    %r10,%r8
  4d804e:	74 a3                	je     4d7ff3 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x83>
  4d8050:	4c 39 c6             	cmp    %r8,%rsi
  4d8053:	77 db                	ja     4d8030 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0xc0>
  4d8055:	e9 8d 00 00 00       	jmp    4d80e7 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x177>
  4d805a:	74 1f                	je     4d807b <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x10b>
  4d805c:	41 83 fb 06          	cmp    $0x6,%r11d
  4d8060:	74 e1                	je     4d8043 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0xd3>
  4d8062:	48 8d 3d 7b f5 b6 ff 	lea    -0x490a85(%rip),%rdi        # 475e4 <anon.4aabc4744470660875e0a48c481e6222.49.llvm.12729319628953218387+0x80>
  4d8069:	48 8d 15 a8 42 2c 00 	lea    0x2c42a8(%rip),%rdx        # 79c318 <anon.4aabc4744470660875e0a48c481e6222.57.llvm.12729319628953218387+0x60>
  4d8070:	be a1 00 00 00       	mov    $0xa1,%esi
  4d8075:	ff 15 a5 5a 2e 00    	call   *0x2e5aa5(%rip)        # 7bdb20 <_DYNAMIC+0x2a0>
  4d807b:	48 8d b7 68 07 00 00 	lea    0x768(%rdi),%rsi
  4d8082:	4c 8d 87 50 07 00 00 	lea    0x750(%rdi),%r8
  4d8089:	4c 8d 8f 70 07 00 00 	lea    0x770(%rdi),%r9
  4d8090:	4c 8d 97 58 07 00 00 	lea    0x758(%rdi),%r10
  4d8097:	48 83 bf 60 07 00 00 	cmpq   $0xffffffffffffffff,0x760(%rdi)
  4d809e:	ff 
  4d809f:	49 0f 44 f0          	cmove  %r8,%rsi
  4d80a3:	4d 0f 45 d1          	cmovne %r9,%r10
  4d80a7:	49 8b 3a             	mov    (%r10),%rdi
  4d80aa:	48 8b 36             	mov    (%rsi),%rsi
  4d80ad:	48 c1 e7 04          	shl    $0x4,%rdi
  4d80b1:	48 8d 3c bf          	lea    (%rdi,%rdi,4),%rdi
  4d80b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  4d80bc:	00 00 00 00 
  4d80c0:	48 85 ff             	test   %rdi,%rdi
  4d80c3:	74 13                	je     4d80d8 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x168>
  4d80c5:	48 83 c7 b0          	add    $0xffffffffffffffb0,%rdi
  4d80c9:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  4d80cd:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  4d80d1:	75 ed                	jne    4d80c0 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x150>
  4d80d3:	e9 1b ff ff ff       	jmp    4d7ff3 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387+0x83>
  4d80d8:	31 c0                	xor    %eax,%eax
  4d80da:	48 89 ca             	mov    %rcx,%rdx
  4d80dd:	59                   	pop    %rcx
  4d80de:	c3                   	ret
  4d80df:	48 89 ca             	mov    %rcx,%rdx
  4d80e2:	59                   	pop    %rcx
  4d80e3:	c3                   	ret
  4d80e4:	49 89 c8             	mov    %rcx,%r8
  4d80e7:	48 8d 15 b2 41 2c 00 	lea    0x2c41b2(%rip),%rdx        # 79c2a0 <anon.4aabc4744470660875e0a48c481e6222.53.llvm.12729319628953218387+0x30>
  4d80ee:	4c 89 c7             	mov    %r8,%rdi
  4d80f1:	ff 15 49 5a 2e 00    	call   *0x2e5a49(%rip)        # 7bdb40 <_DYNAMIC+0x2c0>

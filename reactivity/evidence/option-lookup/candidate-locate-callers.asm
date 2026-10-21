
CALLER 00000000004c7e90 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_>:
  4c7e94:	53                   	push   %rbx
  4c7e95:	48 89 fb             	mov    %rdi,%rbx
  4c7e98:	4c 8b 36             	mov    (%rsi),%r14
  4c7e9b:	4d 85 f6             	test   %r14,%r14
  4c7e9e:	74 6b                	je     4c7f0b <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0x7b>
  4c7ea0:	be 0e 00 00 00       	mov    $0xe,%esi
  4c7ea5:	41 80 be 6e 09 00 00 	cmpb   $0x0,0x96e(%r14)
  4c7eac:	00 
  4c7ead:	0f 85 a5 00 00 00    	jne    4c7f58 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0xc8>
  4c7eb3:	4c 89 f7             	mov    %r14,%rdi
  4c7eb6:	48 89 d6             	mov    %rdx,%rsi
  4c7eb9:	48 89 ca             	mov    %rcx,%rdx
  4c7ebc:	4d 89 c7             	mov    %r8,%r15
  4c7ebf:	e8 ac 00 01 00       	call   4d7f70 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387>
  4c7ec4:	be 11 00 00 00       	mov    $0x11,%esi
  4c7ec9:	48 83 f8 01          	cmp    $0x1,%rax
  4c7ecd:	0f 85 85 00 00 00    	jne    4c7f58 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0xc8>
  4c7ed3:	4c 89 f9             	mov    %r15,%rcx
  4c7ed6:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  4c7edd:	48 85 c0             	test   %rax,%rax
  4c7ee0:	74 30                	je     4c7f12 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0x82>
  4c7ee2:	83 f8 01             	cmp    $0x1,%eax
  4c7ee5:	75 34                	jne    4c7f1b <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0x8b>
  4c7ee7:	49 8b b6 40 02 00 00 	mov    0x240(%r14),%rsi
  4c7eee:	b8 38 02 00 00       	mov    $0x238,%eax
  4c7ef3:	48 39 f2             	cmp    %rsi,%rdx
  4c7ef6:	72 4b                	jb     4c7f43 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0xb3>
  4c7ef8:	48 8d 05 41 43 2d 00 	lea    0x2d4341(%rip),%rax        # 79c240 <anon.4aabc4744470660875e0a48c481e6222.51.llvm.12729319628953218387>

CALLER 00000000004d0270 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_>:
  4d0289:	41 80 be 6e 09 00 00 	cmpb   $0x0,0x96e(%r14)
  4d0290:	00 
  4d0291:	74 20                	je     4d02b3 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x43>
  4d0293:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  4d029a:	e9 d0 02 00 00       	jmp    4d056f <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x2ff>
  4d029f:	48 c7 03 0d 00 00 00 	movq   $0xd,(%rbx)
  4d02a6:	48 c7 43 08 00 00 00 	movq   $0x0,0x8(%rbx)
  4d02ad:	00 
  4d02ae:	e9 bc 02 00 00       	jmp    4d056f <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x2ff>
  4d02b3:	49 89 f7             	mov    %rsi,%r15
  4d02b6:	4c 89 f7             	mov    %r14,%rdi
  4d02b9:	48 89 d6             	mov    %rdx,%rsi
  4d02bc:	48 89 ca             	mov    %rcx,%rdx
  4d02bf:	e8 ac 7c 00 00       	call   4d7f70 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387>
  4d02c4:	a8 01                	test   $0x1,%al
  4d02c6:	0f 84 4d 01 00 00    	je     4d0419 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x1a9>
  4d02cc:	49 8b b6 c8 02 00 00 	mov    0x2c8(%r14),%rsi
  4d02d3:	48 39 f2             	cmp    %rsi,%rdx
  4d02d6:	0f 83 c7 02 00 00    	jae    4d05a3 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x333>
  4d02dc:	49 83 c7 08          	add    $0x8,%r15
  4d02e0:	49 8b 86 c0 02 00 00 	mov    0x2c0(%r14),%rax
  4d02e7:	48 8d 0c 92          	lea    (%rdx,%rdx,4),%rcx
  4d02eb:	48 8d 2c c8          	lea    (%rax,%rcx,8),%rbp
  4d02ef:	8b 44 c8 20          	mov    0x20(%rax,%rcx,8),%eax
  4d02f3:	83 e0 07             	and    $0x7,%eax
  4d02f6:	b9 7b 00 00 00       	mov    $0x7b,%ecx
  4d02fb:	0f a3 c1             	bt     %eax,%ecx
  4d02fe:	0f 83 b5 01 00 00    	jae    4d04b9 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x249>

CALLER 00000000004d0a90 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_>:
  4d68de:	e8 ed 9e 00 00       	call   4e07d0 <_RNvXsU_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_9ExtractIfyAINtNtCsgID3RIcF1fr_4gpui8property12ContributionINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtB1e_11shared_text10SharedTextEEj2_NtNtNtB1Z_3ops5range9RangeFullNCINvMsi_B5_INtB5_8BTreeMapyB18_E6retainNCNvMsp_NtB1e_7runtimeINtB4o_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innersB_0E0ENtNtNtNtB1Z_4iter6traits8iterator8Iterator4nextB4T_>
  4d68e3:	48 8b 84 24 48 04 00 	mov    0x448(%rsp),%rax
  4d68ea:	00 
  4d68eb:	48 83 f8 02          	cmp    $0x2,%rax
  4d68ef:	0f 85 39 03 00 00    	jne    4d6c2e <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_+0x619e>
  4d68f5:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
  4d68fa:	41 c6 86 6a 09 00 00 	movb   $0x1,0x96a(%r14)
  4d6901:	01 
  4d6902:	49 8b b6 f8 07 00 00 	mov    0x7f8(%r14),%rsi
  4d6909:	48 85 f6             	test   %rsi,%rsi
  4d690c:	74 49                	je     4d6957 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_+0x5ec7>
  4d690e:	49 8b 96 00 08 00 00 	mov    0x800(%r14),%rdx
  4d6915:	4c 89 f7             	mov    %r14,%rdi
  4d6918:	e8 53 16 00 00       	call   4d7f70 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387>
  4d691d:	48 83 f8 01          	cmp    $0x1,%rax
  4d6921:	75 29                	jne    4d694c <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_+0x5ebc>
  4d6923:	49 8b b6 c8 02 00 00 	mov    0x2c8(%r14),%rsi
  4d692a:	48 39 f2             	cmp    %rsi,%rdx
  4d692d:	0f 83 1e 08 00 00    	jae    4d7151 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_+0x66c1>
  4d6933:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  4d6937:	48 c1 e7 03          	shl    $0x3,%rdi
  4d693b:	49 03 be c0 02 00 00 	add    0x2c0(%r14),%rdi
  4d6942:	ff 15 f0 72 2e 00    	call   *0x2e72f0(%rip)        # 7bdc38 <_DYNAMIC+0x3b8>
  4d6948:	84 c0                	test   %al,%al
  4d694a:	75 0b                	jne    4d6957 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_+0x5ec7>
  4d694c:	49 c7 86 f8 07 00 00 	movq   $0x0,0x7f8(%r14)
  4d6953:	00 00 00 00 
  4d6957:	48 8b 84 24 00 06 00 	mov    0x600(%rsp),%rax

CALLER 00000000004f3b20 <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_>:
  4f4104:	4c 8b 75 08          	mov    0x8(%rbp),%r14
  4f4108:	4d 85 f6             	test   %r14,%r14
  4f410b:	0f 84 0e 04 00 00    	je     4f451f <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_+0x9ff>
  4f4111:	48 89 bc 24 e0 00 00 	mov    %rdi,0xe0(%rsp)
  4f4118:	00 
  4f4119:	41 80 be 6e 09 00 00 	cmpb   $0x0,0x96e(%r14)
  4f4120:	00 
  4f4121:	0f 85 0b 04 00 00    	jne    4f4532 <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_+0xa12>
  4f4127:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  4f412c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  4f4131:	4c 89 f7             	mov    %r14,%rdi
  4f4134:	4c 89 fe             	mov    %r15,%rsi
  4f4137:	4c 89 e2             	mov    %r12,%rdx
  4f413a:	e8 31 3e fe ff       	call   4d7f70 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.12729319628953218387>
  4f413f:	48 83 f8 01          	cmp    $0x1,%rax
  4f4143:	0f 85 03 04 00 00    	jne    4f454c <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_+0xa2c>
  4f4149:	49 8b b6 c8 02 00 00 	mov    0x2c8(%r14),%rsi
  4f4150:	48 39 f2             	cmp    %rsi,%rdx
  4f4153:	0f 83 e0 03 00 00    	jae    4f4539 <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_+0xa19>
  4f4159:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  4f415d:	48 c1 e7 03          	shl    $0x3,%rdi
  4f4161:	49 03 be c0 02 00 00 	add    0x2c0(%r14),%rdi
  4f4168:	ff 15 ca 9a 2c 00    	call   *0x2c9aca(%rip)        # 7bdc38 <_DYNAMIC+0x3b8>
  4f416e:	84 c0                	test   %al,%al
  4f4170:	0f 84 dd 03 00 00    	je     4f4553 <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_+0xa33>
  4f4176:	4d 89 be f8 07 00 00 	mov    %r15,0x7f8(%r14)
  4f417d:	4d 89 a6 00 08 00 00 	mov    %r12,0x800(%r14)
  4f4184:	49 c7 86 58 09 00 00 	movq   $0x0,0x958(%r14)

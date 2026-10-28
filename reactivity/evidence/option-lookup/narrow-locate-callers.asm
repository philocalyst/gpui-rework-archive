
CALLER 00000000004c7e90 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_>:
  4c7e9c:	4c 8b 36             	mov    (%rsi),%r14
  4c7e9f:	4d 85 f6             	test   %r14,%r14
  4c7ea2:	74 16                	je     4c7eba <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0x2a>
  4c7ea4:	41 80 be 6e 09 00 00 	cmpb   $0x0,0x96e(%r14)
  4c7eab:	00 
  4c7eac:	74 18                	je     4c7ec6 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0x36>
  4c7eae:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  4c7eb5:	e9 c4 00 00 00       	jmp    4c7f7e <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0xee>
  4c7eba:	48 c7 03 0d 00 00 00 	movq   $0xd,(%rbx)
  4c7ec1:	e9 b8 00 00 00       	jmp    4c7f7e <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0xee>
  4c7ec6:	4d 89 c7             	mov    %r8,%r15
  4c7ec9:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  4c7ece:	4c 89 f6             	mov    %r14,%rsi
  4c7ed1:	e8 2a 01 01 00       	call   4d8000 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018>
  4c7ed6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  4c7edb:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  4c7edf:	75 37                	jne    4c7f18 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0x88>
  4c7ee1:	49 8b 8e 28 02 00 00 	mov    0x228(%r14),%rcx
  4c7ee8:	48 85 c9             	test   %rcx,%rcx
  4c7eeb:	4c 89 f8             	mov    %r15,%rax
  4c7eee:	74 48                	je     4c7f38 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0xa8>
  4c7ef0:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  4c7ef5:	83 f9 01             	cmp    $0x1,%ecx
  4c7ef8:	75 47                	jne    4c7f41 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0xb1>
  4c7efa:	49 8b b6 40 02 00 00 	mov    0x240(%r14),%rsi
  4c7f01:	b9 38 02 00 00       	mov    $0x238,%ecx
  4c7f06:	48 39 f7             	cmp    %rsi,%rdi
  4c7f09:	72 5e                	jb     4c7f69 <_RINvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB6_3WinNtCseYnGdwYunAn_14identity_index4PageE8propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEBL_+0xd9>

CALLER 00000000004d0290 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_>:
  4d02a7:	74 16                	je     4d02bf <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x2f>
  4d02a9:	41 80 be 6e 09 00 00 	cmpb   $0x0,0x96e(%r14)
  4d02b0:	00 
  4d02b1:	74 20                	je     4d02d3 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x43>
  4d02b3:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  4d02ba:	e9 f2 02 00 00       	jmp    4d05b1 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x321>
  4d02bf:	48 c7 03 0d 00 00 00 	movq   $0xd,(%rbx)
  4d02c6:	48 c7 43 08 00 00 00 	movq   $0x0,0x8(%rbx)
  4d02cd:	00 
  4d02ce:	e9 de 02 00 00       	jmp    4d05b1 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x321>
  4d02d3:	49 89 f7             	mov    %rsi,%r15
  4d02d6:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  4d02db:	4c 89 f6             	mov    %r14,%rsi
  4d02de:	e8 1d 7d 00 00       	call   4d8000 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018>
  4d02e3:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  4d02e8:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  4d02ec:	0f 85 52 01 00 00    	jne    4d0444 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x1b4>
  4d02f2:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  4d02f7:	49 8b b6 c8 02 00 00 	mov    0x2c8(%r14),%rsi
  4d02fe:	48 39 f7             	cmp    %rsi,%rdi
  4d0301:	0f 83 de 02 00 00    	jae    4d05e5 <_RNvMso_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_3WinNtCseYnGdwYunAn_14identity_index4PageE8activateBK_+0x355>
  4d0307:	49 83 c7 08          	add    $0x8,%r15
  4d030b:	49 8b 86 c0 02 00 00 	mov    0x2c0(%r14),%rax
  4d0312:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  4d0316:	48 8d 2c c8          	lea    (%rax,%rcx,8),%rbp
  4d031a:	8b 44 c8 20          	mov    0x20(%rax,%rcx,8),%eax
  4d031e:	83 e0 07             	and    $0x7,%eax
  4d0321:	b9 7b 00 00 00       	mov    $0x7b,%ecx

CALLER 00000000004d0ad0 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_>:
  4d692a:	00 
  4d692b:	48 83 f8 02          	cmp    $0x2,%rax
  4d692f:	0f 85 80 00 00 00    	jne    4d69b5 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_+0x5ee5>
  4d6935:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
  4d693a:	41 c6 86 6a 09 00 00 	movb   $0x1,0x96a(%r14)
  4d6941:	01 
  4d6942:	49 8b 96 f8 07 00 00 	mov    0x7f8(%r14),%rdx
  4d6949:	48 85 d2             	test   %rdx,%rdx
  4d694c:	0f 84 78 01 00 00    	je     4d6aca <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_+0x5ffa>
  4d6952:	49 8b 8e 00 08 00 00 	mov    0x800(%r14),%rcx
  4d6959:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  4d6960:	00 
  4d6961:	4c 89 f6             	mov    %r14,%rsi
  4d6964:	e8 97 16 00 00       	call   4d8000 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018>
  4d6969:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
  4d6970:	00 
  4d6971:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  4d6975:	0f 85 02 01 00 00    	jne    4d6a7d <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_+0x5fad>
  4d697b:	48 8b bc 24 40 01 00 	mov    0x140(%rsp),%rdi
  4d6982:	00 
  4d6983:	49 8b b6 c8 02 00 00 	mov    0x2c8(%r14),%rsi
  4d698a:	48 39 f7             	cmp    %rsi,%rdi
  4d698d:	0f 83 5f 08 00 00    	jae    4d71f2 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE14describe_innerBO_+0x6722>
  4d6993:	48 8d 3c bf          	lea    (%rdi,%rdi,4),%rdi
  4d6997:	48 c1 e7 03          	shl    $0x3,%rdi
  4d699b:	49 03 be c0 02 00 00 	add    0x2c0(%r14),%rdi
  4d69a2:	ff 15 90 73 2e 00    	call   *0x2e7390(%rip)        # 7bdd38 <_DYNAMIC+0x3b8>
  4d69a8:	84 c0                	test   %al,%al

CALLER 00000000004f3bc0 <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_>:
  4f41ab:	44 88 44 24 0f       	mov    %r8b,0xf(%rsp)
  4f41b0:	0f 84 07 04 00 00    	je     4f45bd <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_+0x9fd>
  4f41b6:	48 89 8c 24 d0 00 00 	mov    %rcx,0xd0(%rsp)
  4f41bd:	00 
  4f41be:	41 80 bf 6e 09 00 00 	cmpb   $0x0,0x96e(%r15)
  4f41c5:	00 
  4f41c6:	0f 85 04 04 00 00    	jne    4f45d0 <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_+0xa10>
  4f41cc:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  4f41d1:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  4f41d6:	48 89 fd             	mov    %rdi,%rbp
  4f41d9:	4c 89 fe             	mov    %r15,%rsi
  4f41dc:	4c 89 e2             	mov    %r12,%rdx
  4f41df:	4c 89 e9             	mov    %r13,%rcx
  4f41e2:	e8 19 3e fe ff       	call   4d8000 <_RNvMsp_NtCsgID3RIcF1fr_4gpui7runtimeINtB5_7RuntimeNtCseYnGdwYunAn_14identity_index4PageE6locateBO_.llvm.16348402748963727018>
  4f41e7:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  4f41ec:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  4f41f0:	0f 85 ee 03 00 00    	jne    4f45e4 <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_+0xa24>
  4f41f6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  4f41fb:	49 8b b7 c8 02 00 00 	mov    0x2c8(%r15),%rsi
  4f4202:	48 39 f7             	cmp    %rsi,%rdi
  4f4205:	0f 83 cc 03 00 00    	jae    4f45d7 <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_+0xa17>
  4f420b:	48 8d 3c bf          	lea    (%rdi,%rdi,4),%rdi
  4f420f:	48 c1 e7 03          	shl    $0x3,%rdi
  4f4213:	49 03 bf c0 02 00 00 	add    0x2c0(%r15),%rdi
  4f421a:	ff 15 18 9b 2c 00    	call   *0x2c9b18(%rip)        # 7bdd38 <_DYNAMIC+0x3b8>
  4f4220:	84 c0                	test   %al,%al
  4f4222:	0f 84 18 04 00 00    	je     4f4640 <_RINvCsbdycFORzttZ_18allocation_counter7measureNCNvCseYnGdwYunAn_14identity_index4mains_0EBM_+0xa80>
  4f4228:	4d 89 a7 f8 07 00 00 	mov    %r12,0x7f8(%r15)

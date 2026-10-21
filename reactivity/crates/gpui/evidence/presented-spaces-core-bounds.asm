
/tmp/gpui-spaces-borrowed-final-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000006d11a0 <<gpui_reactivity_core::geometry::CoordinateSpace>::bounds>:
  6d11a0:	53                   	push   %rbx
  6d11a1:	48 83 ec 20          	sub    $0x20,%rsp
  6d11a5:	48 89 fb             	mov    %rdi,%rbx
  6d11a8:	48 8d 7c 24 0c       	lea    0xc(%rsp),%rdi
  6d11ad:	ff 15 4d e3 0c 00    	call   *0xce34d(%rip)        # 79f500 <_DYNAMIC+0x2748>
  6d11b3:	31 c0                	xor    %eax,%eax
  6d11b5:	83 7c 24 0c 01       	cmpl   $0x1,0xc(%rsp)
  6d11ba:	75 0e                	jne    6d11ca <<gpui_reactivity_core::geometry::CoordinateSpace>::bounds+0x2a>
  6d11bc:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  6d11c1:	0f 11 43 04          	movups %xmm0,0x4(%rbx)
  6d11c5:	b8 01 00 00 00       	mov    $0x1,%eax
  6d11ca:	89 03                	mov    %eax,(%rbx)
  6d11cc:	48 89 d8             	mov    %rbx,%rax
  6d11cf:	48 83 c4 20          	add    $0x20,%rsp
  6d11d3:	5b                   	pop    %rbx
  6d11d4:	c3                   	ret

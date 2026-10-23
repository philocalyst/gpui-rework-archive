
/tmp/gpui-caret-transaction-bin/d54-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001b6a0 <transaction_codegen::atomic>:
   1b6a0:	48 83 ec 28          	sub    $0x28,%rsp
   1b6a4:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
   1b6ab:	00 00 
   1b6ad:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
   1b6b4:	00 00 
   1b6b6:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
   1b6bb:	c6 44 24 20 00       	movb   $0x0,0x20(%rsp)
   1b6c0:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
   1b6c5:	f3 0f 10 05 27 99 fe 	movss  -0x166d9(%rip),%xmm0        # 4ff4 <__abi_tag+0x4cc0>
   1b6cc:	ff 
   1b6cd:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
   1b6d2:	e8 89 04 00 00       	call   1bb60 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>
   1b6d7:	88 44 24 10          	mov    %al,0x10(%rsp)
   1b6db:	48 8d 44 24 10       	lea    0x10(%rsp),%rax
   1b6e0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   1b6e5:	48 83 c4 28          	add    $0x28,%rsp
   1b6e9:	c3                   	ret

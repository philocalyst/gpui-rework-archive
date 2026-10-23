
/tmp/gpui-caret-transaction-bin/62e-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001b640 <transaction_codegen::atomic>:
   1b640:	48 83 ec 28          	sub    $0x28,%rsp
   1b644:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
   1b64b:	00 00 
   1b64d:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
   1b654:	00 00 
   1b656:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
   1b65b:	c6 44 24 20 00       	movb   $0x0,0x20(%rsp)
   1b660:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
   1b665:	f3 0f 10 05 67 99 fe 	movss  -0x16699(%rip),%xmm0        # 4fd4 <__abi_tag+0x4ca0>
   1b66c:	ff 
   1b66d:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
   1b672:	e8 89 04 00 00       	call   1bb00 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>
   1b677:	88 44 24 10          	mov    %al,0x10(%rsp)
   1b67b:	48 8d 44 24 10       	lea    0x10(%rsp),%rax
   1b680:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   1b685:	48 83 c4 28          	add    $0x28,%rsp
   1b689:	c3                   	ret

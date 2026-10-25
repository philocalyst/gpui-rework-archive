
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074d110 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>>:
  74d110:	41 57                	push   %r15
  74d112:	41 56                	push   %r14
  74d114:	41 55                	push   %r13
  74d116:	41 54                	push   %r12
  74d118:	53                   	push   %rbx
  74d119:	48 83 ec 70          	sub    $0x70,%rsp
  74d11d:	48 89 fb             	mov    %rdi,%rbx
  74d120:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  74d127:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74d12e:	00 00 
  74d130:	4d 01 fe             	add    %r15,%r14
  74d133:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  74d13a:	00 00 
  74d13c:	0f 84 90 00 00 00    	je     74d1d2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xc2>
  74d142:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74d147:	0f 85 b5 00 00 00    	jne    74d202 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xf2>
  74d14d:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  74d154:	ff 
  74d155:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  74d15c:	00 
  74d15d:	ff c0                	inc    %eax
  74d15f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  74d166:	00 
  74d167:	83 f8 40             	cmp    $0x40,%eax
  74d16a:	0f 83 9f 00 00 00    	jae    74d20f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0xff>
  74d170:	89 c0                	mov    %eax,%eax
  74d172:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74d176:	48 c1 e0 04          	shl    $0x4,%rax
  74d17a:	0f 57 c0             	xorps  %xmm0,%xmm0
  74d17d:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74d183:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74d189:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74d18f:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  74d196:	00 
  74d197:	48 8b 02             	mov    (%rdx),%rax
  74d19a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  74d19e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  74d1a3:	48 89 c2             	mov    %rax,%rdx
  74d1a6:	e8 55 d0 fb ff       	call   70a200 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click>
  74d1ab:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  74d1b0:	75 78                	jne    74d22a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x11a>
  74d1b2:	48 8d 35 cf d6 3a 00 	lea    0x3ad6cf(%rip),%rsi        # afa888 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74d1b9:	48 89 df             	mov    %rbx,%rdi
  74d1bc:	e8 cf 7d 00 00       	call   754f90 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74d1c1:	48 89 d8             	mov    %rbx,%rax
  74d1c4:	48 83 c4 70          	add    $0x70,%rsp
  74d1c8:	5b                   	pop    %rbx
  74d1c9:	41 5c                	pop    %r12
  74d1cb:	41 5d                	pop    %r13
  74d1cd:	41 5e                	pop    %r14
  74d1cf:	41 5f                	pop    %r15
  74d1d1:	c3                   	ret
  74d1d2:	49 89 d4             	mov    %rdx,%r12
  74d1d5:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74d1da:	4c 89 f7             	mov    %r14,%rdi
  74d1dd:	49 89 f5             	mov    %rsi,%r13
  74d1e0:	31 f6                	xor    %esi,%esi
  74d1e2:	ff 15 70 b2 3d 00    	call   *0x3db270(%rip)        # b28458 <memset@GLIBC_2.2.5>
  74d1e8:	4c 89 e2             	mov    %r12,%rdx
  74d1eb:	4c 89 ee             	mov    %r13,%rsi
  74d1ee:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  74d1f5:	00 01 
  74d1f7:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74d1fc:	0f 84 4b ff ff ff    	je     74d14d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x3d>
  74d202:	48 8d 3d 37 da 3a 00 	lea    0x3ada37(%rip),%rdi        # afac40 <anon.cf030bdcd33bba1955553babc00e59a7.15.llvm.15067004318175258651>
  74d209:	ff 15 51 b2 3d 00    	call   *0x3db251(%rip)        # b28460 <_DYNAMIC+0x7a8>
  74d20f:	48 8d 3d 96 de 91 ff 	lea    -0x6e216a(%rip),%rdi        # 6b0ac <anon.cf030bdcd33bba1955553babc00e59a7.12.llvm.15067004318175258651>
  74d216:	48 8d 15 0b da 3a 00 	lea    0x3ada0b(%rip),%rdx        # afac28 <anon.cf030bdcd33bba1955553babc00e59a7.14.llvm.15067004318175258651>
  74d21d:	be 4b 00 00 00       	mov    $0x4b,%esi
  74d222:	ff 15 c8 ae 3d 00    	call   *0x3daec8(%rip)        # b280f0 <_DYNAMIC+0x438>
  74d228:	eb 4a                	jmp    74d274 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#1}>+0x164>
  74d22a:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74d22f:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  74d234:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  74d239:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  74d23e:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  74d243:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  74d248:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  74d24d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  74d251:	48 8d 3d fc da 91 ff 	lea    -0x6e2504(%rip),%rdi        # 6ad54 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74d258:	48 8d 0d 91 d6 3a 00 	lea    0x3ad691(%rip),%rcx        # afa8f0 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74d25f:	4c 8d 05 72 d6 3a 00 	lea    0x3ad672(%rip),%r8        # afa8d8 <anon.2d1f820267f84878e0cbda50021465a1.6.llvm.17676285964678017166>
  74d266:	48 89 e2             	mov    %rsp,%rdx
  74d269:	be 2b 00 00 00       	mov    $0x2b,%esi
  74d26e:	ff 15 94 ad 3d 00    	call   *0x3dad94(%rip)        # b28008 <_DYNAMIC+0x350>
  74d274:	0f 0b                	ud2
  74d276:	48 89 c3             	mov    %rax,%rbx
  74d279:	48 89 e7             	mov    %rsp,%rdi
  74d27c:	e8 1f 22 00 00       	call   74f4a0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74d281:	48 89 df             	mov    %rbx,%rdi
  74d284:	e8 e7 ae 3a 00       	call   af8170 <_Unwind_Resume@plt>
  74d289:	64 49 ff 07          	incq   %fs:(%r15)
  74d28d:	48 89 c7             	mov    %rax,%rdi
  74d290:	e8 db ae 3a 00       	call   af8170 <_Unwind_Resume@plt>

; ModuleID = 'probe.7032f9a949ab1f1e-cgu.0'
source_filename = "probe.7032f9a949ab1f1e-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"core::fmt::rt::Argument<'_>" = type { %"core::fmt::rt::ArgumentType<'_>" }
%"core::fmt::rt::ArgumentType<'_>" = type { ptr, [1 x i64] }

@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr, ptr, ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @_RNSNvYNCINvNtCsgiBO0YArCeQ_3std2rt10lang_startuE0INtNtNtCsaifZ2emd9Uo_4core3ops8function6FnOnceuE9call_once6vtableCs9DesMrFkSfi_5probe, ptr @_RNCINvNtCsgiBO0YArCeQ_3std2rt10lang_startuE0Cs9DesMrFkSfi_5probe, ptr @_RNCINvNtCsgiBO0YArCeQ_3std2rt10lang_startuE0Cs9DesMrFkSfi_5probe }>, align 8, !guid !0
@alloc_45c5b8d9661cc4b9c8e770e6215d84b9 = private unnamed_addr constant [8 x i8] c"P\00\00\00\00\00\00\00", align 8, !guid !1
@alloc_0ccad4f87ebf01d4fbb97e68a4b3ae8c = private unnamed_addr constant [8 x i8] c"8\00\00\00\00\00\00\00", align 8, !guid !2
@alloc_87930ff84f26c4dc0d3a344636709737 = private unnamed_addr constant [8 x i8] c"\10\00\00\00\00\00\00\00", align 8, !guid !3
@alloc_28b4525213e621d91e2b40299762a7fc = private unnamed_addr constant [8 x i8] c"0\00\00\00\00\00\00\00", align 8, !guid !4
@alloc_d7c65242e2ebcfdd375093b1e162649c = private unnamed_addr constant [8 x i8] c"\B0\00\00\00\00\00\00\00", align 8, !guid !5
@alloc_2ad387336c4e09c56ac18fccdba49dbb = private unnamed_addr constant [8 x i8] c"X\00\00\00\00\00\00\00", align 8, !guid !6
@alloc_48d9eb93f6a120f1fdd174ce4723e68e = private unnamed_addr constant [122 x i8] c"\19PUBLIC_LAYOUT ColorInput=\C0\0C BoolColors=\C0\0D BoolBinding=\C0\0B BoolState=\C0\0F PropInputBool=\C0\10 PropInputColor=\C0\04 El=\C0\07 Style=\C0\01\0A\00", align 1, !guid !7

; <core::fmt::Arguments>::new::<122, 8>
; Function Attrs: inlinehint nonlazybind uwtable
define internal { ptr, ptr } @_RINvMs2_NtCsaifZ2emd9Uo_4core3fmtNtB6_9Arguments3newKj7a_Kj8_ECs9DesMrFkSfi_5probe(ptr %template, ptr align 8 %args) unnamed_addr #0 !guid !13 {
start:
  %0 = insertvalue { ptr, ptr } poison, ptr %template, 0
  %1 = insertvalue { ptr, ptr } %0, ptr %args, 1
  ret { ptr, ptr } %1
}

; std::rt::lang_start::<()>
; Function Attrs: nonlazybind uwtable
define hidden i64 @_RINvNtCsgiBO0YArCeQ_3std2rt10lang_startuECs9DesMrFkSfi_5probe(ptr %main, i64 %argc, ptr %argv, i8 %sigpipe) unnamed_addr #1 !guid !14 {
start:
  %_7 = alloca [8 x i8], align 8
  store ptr %main, ptr %_7, align 8
; call std::rt::lang_start_internal
  %_0 = call i64 @_RNvNtCsgiBO0YArCeQ_3std2rt19lang_start_internal(ptr %_7, ptr align 8 @vtable.0, i64 %argc, ptr %argv, i8 %sigpipe)
  ret i64 %_0
}

; std::sys::backtrace::__rust_begin_short_backtrace::<fn(), ()>
; Function Attrs: noinline nonlazybind uwtable
define internal void @_RINvNtNtCsgiBO0YArCeQ_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9DesMrFkSfi_5probe(ptr %f) unnamed_addr #2 !guid !15 {
start:
  %_2 = alloca [0 x i8], align 1
; call <fn() as core::ops::function::FnOnce<()>>::call_once
  call void @_RNvYFEuINtNtNtCsaifZ2emd9Uo_4core3ops8function6FnOnceuE9call_onceCs9DesMrFkSfi_5probe(ptr %f)
  call void asm sideeffect "", "~{memory}"(), !srcloc !16
  ret void
}

; std::rt::lang_start::<()>::{closure#0}
; Function Attrs: inlinehint nonlazybind uwtable
define internal i32 @_RNCINvNtCsgiBO0YArCeQ_3std2rt10lang_startuE0Cs9DesMrFkSfi_5probe(ptr align 8 %_1) unnamed_addr #0 !guid !17 {
start:
  %_4 = load ptr, ptr %_1, align 8
; call std::sys::backtrace::__rust_begin_short_backtrace::<fn(), ()>
  call void @_RINvNtNtCsgiBO0YArCeQ_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9DesMrFkSfi_5probe(ptr %_4)
; call <() as std::process::Termination>::report
  %self = call i8 @_RNvXsU_NtCsgiBO0YArCeQ_3std7processuNtB5_11Termination6reportCs9DesMrFkSfi_5probe()
  %_0 = zext i8 %self to i32
  ret i32 %_0
}

; <std::rt::lang_start<()>::{closure#0} as core::ops::function::FnOnce<()>>::call_once::{shim:vtable#0}
; Function Attrs: inlinehint nonlazybind uwtable
define internal i32 @_RNSNvYNCINvNtCsgiBO0YArCeQ_3std2rt10lang_startuE0INtNtNtCsaifZ2emd9Uo_4core3ops8function6FnOnceuE9call_once6vtableCs9DesMrFkSfi_5probe(ptr %_1) unnamed_addr #0 !guid !18 {
start:
  %_2 = alloca [0 x i8], align 1
  %0 = load ptr, ptr %_1, align 8
; call <std::rt::lang_start<()>::{closure#0} as core::ops::function::FnOnce<()>>::call_once
  %_0 = call i32 @_RNvYNCINvNtCsgiBO0YArCeQ_3std2rt10lang_startuE0INtNtNtCsaifZ2emd9Uo_4core3ops8function6FnOnceuE9call_onceCs9DesMrFkSfi_5probe(ptr %0)
  ret i32 %_0
}

; probe::main
; Function Attrs: nonlazybind uwtable
define hidden void @_RNvCs9DesMrFkSfi_5probe4main() unnamed_addr #1 !guid !19 {
start:
  %_20 = alloca [16 x i8], align 8
  %_19 = alloca [16 x i8], align 8
  %_18 = alloca [16 x i8], align 8
  %_17 = alloca [16 x i8], align 8
  %_16 = alloca [16 x i8], align 8
  %_15 = alloca [16 x i8], align 8
  %_14 = alloca [16 x i8], align 8
  %_13 = alloca [16 x i8], align 8
  %args1 = alloca [128 x i8], align 8
  %args = alloca [64 x i8], align 8
  store ptr @alloc_45c5b8d9661cc4b9c8e770e6215d84b9, ptr %args, align 8
  %0 = getelementptr inbounds i8, ptr %args, i64 8
  store ptr @alloc_45c5b8d9661cc4b9c8e770e6215d84b9, ptr %0, align 8
  %1 = getelementptr inbounds i8, ptr %args, i64 16
  store ptr @alloc_0ccad4f87ebf01d4fbb97e68a4b3ae8c, ptr %1, align 8
  %2 = getelementptr inbounds i8, ptr %args, i64 24
  store ptr @alloc_87930ff84f26c4dc0d3a344636709737, ptr %2, align 8
  %3 = getelementptr inbounds i8, ptr %args, i64 32
  store ptr @alloc_28b4525213e621d91e2b40299762a7fc, ptr %3, align 8
  %4 = getelementptr inbounds i8, ptr %args, i64 40
  store ptr @alloc_28b4525213e621d91e2b40299762a7fc, ptr %4, align 8
  %5 = getelementptr inbounds i8, ptr %args, i64 48
  store ptr @alloc_d7c65242e2ebcfdd375093b1e162649c, ptr %5, align 8
  %6 = getelementptr inbounds i8, ptr %args, i64 56
  store ptr @alloc_2ad387336c4e09c56ac18fccdba49dbb, ptr %6, align 8
  %_23 = load ptr, ptr %args, align 8
; call <core::fmt::rt::Argument>::new_display::<usize>
  call void @_RINvMNtNtCsaifZ2emd9Uo_4core3fmt2rtNtB3_8Argument11new_displayjECsatBMBLwHs8C_4ecow(ptr sret([16 x i8]) align 8 %_13, ptr align 8 %_23)
  %7 = getelementptr inbounds i8, ptr %args, i64 8
  %_24 = load ptr, ptr %7, align 8
; call <core::fmt::rt::Argument>::new_display::<usize>
  call void @_RINvMNtNtCsaifZ2emd9Uo_4core3fmt2rtNtB3_8Argument11new_displayjECsatBMBLwHs8C_4ecow(ptr sret([16 x i8]) align 8 %_14, ptr align 8 %_24)
  %8 = getelementptr inbounds i8, ptr %args, i64 16
  %_25 = load ptr, ptr %8, align 8
; call <core::fmt::rt::Argument>::new_display::<usize>
  call void @_RINvMNtNtCsaifZ2emd9Uo_4core3fmt2rtNtB3_8Argument11new_displayjECsatBMBLwHs8C_4ecow(ptr sret([16 x i8]) align 8 %_15, ptr align 8 %_25)
  %9 = getelementptr inbounds i8, ptr %args, i64 24
  %_26 = load ptr, ptr %9, align 8
; call <core::fmt::rt::Argument>::new_display::<usize>
  call void @_RINvMNtNtCsaifZ2emd9Uo_4core3fmt2rtNtB3_8Argument11new_displayjECsatBMBLwHs8C_4ecow(ptr sret([16 x i8]) align 8 %_16, ptr align 8 %_26)
  %10 = getelementptr inbounds i8, ptr %args, i64 32
  %_27 = load ptr, ptr %10, align 8
; call <core::fmt::rt::Argument>::new_display::<usize>
  call void @_RINvMNtNtCsaifZ2emd9Uo_4core3fmt2rtNtB3_8Argument11new_displayjECsatBMBLwHs8C_4ecow(ptr sret([16 x i8]) align 8 %_17, ptr align 8 %_27)
  %11 = getelementptr inbounds i8, ptr %args, i64 40
  %_28 = load ptr, ptr %11, align 8
; call <core::fmt::rt::Argument>::new_display::<usize>
  call void @_RINvMNtNtCsaifZ2emd9Uo_4core3fmt2rtNtB3_8Argument11new_displayjECsatBMBLwHs8C_4ecow(ptr sret([16 x i8]) align 8 %_18, ptr align 8 %_28)
  %12 = getelementptr inbounds i8, ptr %args, i64 48
  %_29 = load ptr, ptr %12, align 8
; call <core::fmt::rt::Argument>::new_display::<usize>
  call void @_RINvMNtNtCsaifZ2emd9Uo_4core3fmt2rtNtB3_8Argument11new_displayjECsatBMBLwHs8C_4ecow(ptr sret([16 x i8]) align 8 %_19, ptr align 8 %_29)
  %13 = getelementptr inbounds i8, ptr %args, i64 56
  %_30 = load ptr, ptr %13, align 8
; call <core::fmt::rt::Argument>::new_display::<usize>
  call void @_RINvMNtNtCsaifZ2emd9Uo_4core3fmt2rtNtB3_8Argument11new_displayjECsatBMBLwHs8C_4ecow(ptr sret([16 x i8]) align 8 %_20, ptr align 8 %_30)
  %14 = getelementptr inbounds nuw %"core::fmt::rt::Argument<'_>", ptr %args1, i64 0
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %14, ptr align 8 %_13, i64 16, i1 false)
  %15 = getelementptr inbounds nuw %"core::fmt::rt::Argument<'_>", ptr %args1, i64 1
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %15, ptr align 8 %_14, i64 16, i1 false)
  %16 = getelementptr inbounds nuw %"core::fmt::rt::Argument<'_>", ptr %args1, i64 2
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %16, ptr align 8 %_15, i64 16, i1 false)
  %17 = getelementptr inbounds nuw %"core::fmt::rt::Argument<'_>", ptr %args1, i64 3
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %17, ptr align 8 %_16, i64 16, i1 false)
  %18 = getelementptr inbounds nuw %"core::fmt::rt::Argument<'_>", ptr %args1, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %18, ptr align 8 %_17, i64 16, i1 false)
  %19 = getelementptr inbounds nuw %"core::fmt::rt::Argument<'_>", ptr %args1, i64 5
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %19, ptr align 8 %_18, i64 16, i1 false)
  %20 = getelementptr inbounds nuw %"core::fmt::rt::Argument<'_>", ptr %args1, i64 6
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %20, ptr align 8 %_19, i64 16, i1 false)
  %21 = getelementptr inbounds nuw %"core::fmt::rt::Argument<'_>", ptr %args1, i64 7
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %21, ptr align 8 %_20, i64 16, i1 false)
; call <core::fmt::Arguments>::new::<122, 8>
  %22 = call { ptr, ptr } @_RINvMs2_NtCsaifZ2emd9Uo_4core3fmtNtB6_9Arguments3newKj7a_Kj8_ECs9DesMrFkSfi_5probe(ptr @alloc_48d9eb93f6a120f1fdd174ce4723e68e, ptr align 8 %args1)
  %_2.0 = extractvalue { ptr, ptr } %22, 0
  %_2.1 = extractvalue { ptr, ptr } %22, 1
; call std::io::stdio::_print
  call void @_RNvNtNtCsgiBO0YArCeQ_3std2io5stdio6__print(ptr %_2.0, ptr %_2.1)
  ret void
}

; <() as std::process::Termination>::report
; Function Attrs: inlinehint nonlazybind uwtable
define internal i8 @_RNvXsU_NtCsgiBO0YArCeQ_3std7processuNtB5_11Termination6reportCs9DesMrFkSfi_5probe() unnamed_addr #0 !guid !20 {
start:
  ret i8 0
}

; <fn() as core::ops::function::FnOnce<()>>::call_once
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_RNvYFEuINtNtNtCsaifZ2emd9Uo_4core3ops8function6FnOnceuE9call_onceCs9DesMrFkSfi_5probe(ptr %_1) unnamed_addr #0 !guid !21 {
start:
  %_2 = alloca [0 x i8], align 1
  call void %_1()
  ret void
}

; <std::rt::lang_start<()>::{closure#0} as core::ops::function::FnOnce<()>>::call_once
; Function Attrs: inlinehint nonlazybind uwtable
define internal i32 @_RNvYNCINvNtCsgiBO0YArCeQ_3std2rt10lang_startuE0INtNtNtCsaifZ2emd9Uo_4core3ops8function6FnOnceuE9call_onceCs9DesMrFkSfi_5probe(ptr %0) unnamed_addr #0 personality ptr @_RNvCseilXckri75C_7___rustc19rust_eh_personality !guid !22 {
start:
  %_2 = alloca [0 x i8], align 1
  %_1 = alloca [8 x i8], align 8
  store ptr %0, ptr %_1, align 8
; call std::rt::lang_start::<()>::{closure#0}
  %_0 = call i32 @_RNCINvNtCsgiBO0YArCeQ_3std2rt10lang_startuE0Cs9DesMrFkSfi_5probe(ptr align 8 %_1)
  br label %bb1

bb1:                                              ; preds = %start
  ret i32 %_0

bb3:                                              ; No predecessors!
  unreachable

bb4:                                              ; No predecessors!
  unreachable
}

; std::rt::lang_start_internal
; Function Attrs: nonlazybind uwtable
declare i64 @_RNvNtCsgiBO0YArCeQ_3std2rt19lang_start_internal(ptr, ptr align 8, i64, ptr, i8) unnamed_addr #1

; <core::fmt::rt::Argument>::new_display::<usize>
; Function Attrs: inlinehint nonlazybind uwtable
declare void @_RINvMNtNtCsaifZ2emd9Uo_4core3fmt2rtNtB3_8Argument11new_displayjECsatBMBLwHs8C_4ecow(ptr sret([16 x i8]) align 8, ptr align 8) unnamed_addr #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #3

; std::io::stdio::_print
; Function Attrs: nonlazybind uwtable
declare void @_RNvNtNtCsgiBO0YArCeQ_3std2io5stdio6__print(ptr, ptr) unnamed_addr #1

; __rustc::rust_eh_personality
; Function Attrs: nounwind nonlazybind uwtable
declare i32 @_RNvCseilXckri75C_7___rustc19rust_eh_personality(i32, i32, i64, ptr, ptr) unnamed_addr #4

; Function Attrs: nonlazybind
define i32 @main(i32 %0, ptr %1) unnamed_addr #5 !guid !23 {
top:
  %2 = sext i32 %0 to i64
; call std::rt::lang_start::<()>
  %3 = call i64 @_RINvNtCsgiBO0YArCeQ_3std2rt10lang_startuECs9DesMrFkSfi_5probe(ptr @_RNvCs9DesMrFkSfi_5probe4main, i64 %2, ptr %1, i8 0)
  %4 = trunc i64 %3 to i32
  ret i32 %4
}

attributes #0 = { inlinehint nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #2 = { noinline nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nounwind nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #5 = { nonlazybind "target-cpu"="x86-64" }

!llvm.module.flags = !{!8, !9, !10, !11}
!llvm.ident = !{!12}

!0 = !{i64 2512873533871750633}
!1 = !{i64 4388460880850347892}
!2 = !{i64 -7425554867939902757}
!3 = !{i64 7553412702465026972}
!4 = !{i64 4830905537835646631}
!5 = !{i64 4622295971206591199}
!6 = !{i64 7745630503773691621}
!7 = !{i64 7862474845658953948}
!8 = !{i32 8, !"PIC Level", i32 2}
!9 = !{i32 7, !"PIE Level", i32 2}
!10 = !{i32 2, !"RtLibUseGOT", i32 1}
!11 = !{i32 7, !"uwtable", i32 2}
!12 = !{!"rustc version 1.101.0-nightly (7189d39d9 2026-10-22)"}
!13 = !{i64 8482488476956583057}
!14 = !{i64 3146451387094202404}
!15 = !{i64 3925874606251043074}
!16 = !{i64 10777232589343155}
!17 = !{i64 -7730856937158451196}
!18 = !{i64 1194112294394496565}
!19 = !{i64 7788087100836708018}
!20 = !{i64 9003451191585441552}
!21 = !{i64 2218691366282134671}
!22 = !{i64 8121605045988353261}
!23 = !{i64 -2624081020897602054}

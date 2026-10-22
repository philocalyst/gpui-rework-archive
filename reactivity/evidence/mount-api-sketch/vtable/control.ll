; ModuleID = 'mount_vtable_control.90574bb54314715a-cgu.0'
source_filename = "mount_vtable_control.90574bb54314715a-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr, ptr, ptr, ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00", ptr @_RNvYNtCscok4uOrB22c_20mount_vtable_control8OrdinaryNtB4_5Route5admitB4_, ptr @_RNvYINtCscok4uOrB22c_20mount_vtable_control9SelectionNvB5_8proposalNvB5_5replyENtB5_5Route6invokeB5_, ptr @_RNvYINtCscok4uOrB22c_20mount_vtable_control9SelectionNvB5_8proposalNvB5_5replyENtB5_5Route11owner_scopeB5_, ptr @_RNvXs_Cscok4uOrB22c_20mount_vtable_controlINtB4_9SelectionNvB4_8proposalNvB4_5replyENtB4_5Route8propertyB4_ }>, align 8
@vtable.1 = private unnamed_addr constant <{ [24 x i8], ptr, ptr, ptr, ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00", ptr @_RNvXs_Cscok4uOrB22c_20mount_vtable_controlINtB4_9SelectionNvB4_8proposalNvB4_5replyENtB4_5Route5admitB4_, ptr @_RNvYINtCscok4uOrB22c_20mount_vtable_control9SelectionNvB5_8proposalNvB5_5replyENtB5_5Route6invokeB5_, ptr @_RNvYINtCscok4uOrB22c_20mount_vtable_control9SelectionNvB5_8proposalNvB5_5replyENtB5_5Route11owner_scopeB5_, ptr @_RNvXs_Cscok4uOrB22c_20mount_vtable_controlINtB4_9SelectionNvB4_8proposalNvB4_5replyENtB4_5Route8propertyB4_ }>, align 8

; mount_vtable_control::ordinary
; Function Attrs: mustprogress nofree norecurse nosync nounwind nonlazybind willreturn memory(none) uwtable
define { ptr, ptr } @_RNvCscok4uOrB22c_20mount_vtable_control8ordinary() unnamed_addr #0 personality ptr @rust_eh_personality {
start:
  ret { ptr, ptr } { ptr inttoptr (i64 1 to ptr), ptr @vtable.0 }
}

; mount_vtable_control::selection
; Function Attrs: mustprogress nofree norecurse nosync nounwind nonlazybind willreturn memory(none) uwtable
define { ptr, ptr } @_RNvCscok4uOrB22c_20mount_vtable_control9selection() unnamed_addr #0 personality ptr @rust_eh_personality {
start:
  ret { ptr, ptr } { ptr inttoptr (i64 1 to ptr), ptr @vtable.1 }
}

; <mount_vtable_control::Selection<mount_vtable_control::proposal, mount_vtable_control::reply> as mount_vtable_control::Route>::admit
; Function Attrs: mustprogress nofree norecurse nosync nounwind nonlazybind willreturn memory(none) uwtable
define internal noundef i8 @_RNvXs_Cscok4uOrB22c_20mount_vtable_controlINtB4_9SelectionNvB4_8proposalNvB4_5replyENtB4_5Route5admitB4_(ptr noalias nonnull readonly captures(none) %self) unnamed_addr #0 {
start:
  ret i8 1
}

; <mount_vtable_control::Selection<mount_vtable_control::proposal, mount_vtable_control::reply> as mount_vtable_control::Route>::property
; Function Attrs: mustprogress nofree norecurse nosync nounwind nonlazybind willreturn memory(none) uwtable
define internal void @_RNvXs_Cscok4uOrB22c_20mount_vtable_controlINtB4_9SelectionNvB4_8proposalNvB4_5replyENtB4_5Route8propertyB4_(ptr noalias nonnull readonly captures(none) %self, ptr noalias readnone captures(none) %_2) unnamed_addr #0 {
start:
  ret void
}

; <mount_vtable_control::Selection<mount_vtable_control::proposal, mount_vtable_control::reply> as mount_vtable_control::Route>::owner_scope
; Function Attrs: mustprogress nofree norecurse nosync nounwind nonlazybind willreturn memory(none) uwtable
define internal noundef i32 @_RNvYINtCscok4uOrB22c_20mount_vtable_control9SelectionNvB5_8proposalNvB5_5replyENtB5_5Route11owner_scopeB5_(ptr noalias nonnull readonly captures(none) %self) unnamed_addr #0 {
start:
  ret i32 0
}

; <mount_vtable_control::Selection<mount_vtable_control::proposal, mount_vtable_control::reply> as mount_vtable_control::Route>::invoke
; Function Attrs: mustprogress nofree norecurse nosync nounwind nonlazybind willreturn memory(none) uwtable
define internal void @_RNvYINtCscok4uOrB22c_20mount_vtable_control9SelectionNvB5_8proposalNvB5_5replyENtB5_5Route6invokeB5_(ptr noalias nonnull readonly captures(none) %self, ptr nonnull readnone captures(none) %_2.0, ptr noalias readonly align 8 captures(none) %_2.1) unnamed_addr #0 {
start:
  ret void
}

; <mount_vtable_control::Ordinary as mount_vtable_control::Route>::admit
; Function Attrs: mustprogress nofree norecurse nosync nounwind nonlazybind willreturn memory(none) uwtable
define internal noundef i8 @_RNvYNtCscok4uOrB22c_20mount_vtable_control8OrdinaryNtB4_5Route5admitB4_(ptr noalias nonnull readonly captures(none) %self) unnamed_addr #0 {
start:
  ret i8 0
}

; Function Attrs: nounwind nonlazybind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #1

attributes #0 = { mustprogress nofree norecurse nosync nounwind nonlazybind willreturn memory(none) uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { nounwind nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 2, !"RtLibUseGOT", i32 1}
!2 = !{!"rustc version 1.97.1 (8bab26f4f 2026-07-14)"}

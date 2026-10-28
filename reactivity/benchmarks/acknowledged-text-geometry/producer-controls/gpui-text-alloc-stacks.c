#define _GNU_SOURCE
#include <dlfcn.h>
#include <execinfo.h>
#include <inttypes.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/syscall.h>
#include <unistd.h>

/* Linux/glibc diagnostic only. No production hooks, allocator timing, or
 * retained-byte claims. Existing test stdout brackets the first-C constructor.
 * Sampling covers malloc/calloc/realloc; aligned-only allocation is not counted.
 * Backtrace recursion is suppressed and aggregate storage is statically bounded.
 */
extern void *__libc_malloc(size_t);
extern void *__libc_calloc(size_t, size_t);
extern void *__libc_realloc(void *, size_t);
extern void __libc_free(void *);
enum { CAPACITY = 4096, DEPTH = 24 };
struct Entry {
    void *frames[DEPTH];
    uint64_t count, bytes;
    int depth;
};
static struct Entry entries[CAPACITY];
static atomic_flag lock = ATOMIC_FLAG_INIT;
static atomic_int phase;
static atomic_uint_fast64_t overflow;
static _Thread_local int tracing;

static void record(size_t size) {
    if (tracing || atomic_load_explicit(&phase, memory_order_relaxed) != 1)
        return;
    tracing = 1;
    void *frames[DEPTH + 3];
    int count = backtrace(frames, DEPTH + 3);
    int depth = count > 3 ? count - 3 : 0;
    uint64_t hash = UINT64_C(1469598103934665603);
    for (int i = 0; i < depth; ++i)
        hash = (hash ^ (uintptr_t)frames[i + 3]) * UINT64_C(1099511628211);
    while (atomic_flag_test_and_set_explicit(&lock, memory_order_acquire)) {}
    for (unsigned probe = 0; probe < CAPACITY; ++probe) {
        struct Entry *entry = &entries[(hash + probe) % CAPACITY];
        if (!entry->count) {
            memcpy(entry->frames, frames + 3, depth * sizeof(void *));
            entry->depth = depth;
        }
        if (entry->depth == depth &&
            !memcmp(entry->frames, frames + 3, depth * sizeof(void *))) {
            ++entry->count;
            entry->bytes += size;
            goto done;
        }
    }
    atomic_fetch_add_explicit(&overflow, 1, memory_order_relaxed);
done:
    atomic_flag_clear_explicit(&lock, memory_order_release);
    tracing = 0;
}
void *malloc(size_t size) {
    void *result = __libc_malloc(size);
    record(size);
    return result;
}
void *calloc(size_t count, size_t size) {
    void *result = __libc_calloc(count, size);
    if (!size || count <= SIZE_MAX / size) record(count * size);
    return result;
}
void *realloc(void *previous, size_t size) {
    void *result = __libc_realloc(previous, size);
    record(size);
    return result;
}
void free(void *pointer) { __libc_free(pointer); }

static int contains(const void *bytes, size_t count, const char *needle) {
    size_t length = strlen(needle);
    if (count < length) return 0;
    for (size_t i = 0; i <= count - length; ++i)
        if (!memcmp((const char *)bytes + i, needle, length)) return 1;
    return 0;
}
ssize_t write(int fd, const void *bytes, size_t count) {
    int begin = fd == STDOUT_FILENO && contains(bytes, count, "TEXT_OWNER_HEADERS");
    int end = fd == STDOUT_FILENO && contains(bytes, count, "TEXT_OWNER case=first_c");
    if (end) atomic_store_explicit(&phase, 2, memory_order_relaxed);
    ssize_t result = syscall(SYS_write, fd, bytes, count);
    if (begin) atomic_store_explicit(&phase, 1, memory_order_relaxed);
    return result;
}
__attribute__((destructor)) static void dump(void) {
    int final_phase = atomic_exchange_explicit(&phase, 2, memory_order_relaxed);
    tracing = 1;
    fprintf(stderr, "ALLOC_PHASE final=%d overflow=%" PRIuFAST64 "\n",
            final_phase, atomic_load_explicit(&overflow, memory_order_relaxed));
    for (unsigned i = 0; i < CAPACITY; ++i) {
        const struct Entry *entry = &entries[i];
        if (!entry->count) continue;
        fprintf(stderr, "ALLOC_STACK count=%" PRIu64 " bytes=%" PRIu64,
                entry->count, entry->bytes);
        for (int frame = 0; frame < entry->depth; ++frame) {
            Dl_info info;
            if (dladdr(entry->frames[frame], &info) && info.dli_fbase)
                fprintf(stderr, " %s+0x%" PRIxPTR, info.dli_fname,
                        (uintptr_t)entry->frames[frame] - (uintptr_t)info.dli_fbase);
            else fprintf(stderr, " unknown+0x%" PRIxPTR, (uintptr_t)entry->frames[frame]);
        }
        fputc('\n', stderr);
    }
}
